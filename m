From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 032/166] virtio-balloon: switch back to OOM
 handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM
Date: Mon, 06 Apr 2020 20:05:22 -0700
Message-ID: <20200407030522.0aPk9VS4c%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDFY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:05:24 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com, david@redhat.com, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com, namit@vmware.com, rientjes@google.com, torvalds@linux-foundation.org, tysand@google.com, wei.w.wang@intel.com

From: David Hildenbrand <david@redhat.com>
Subject: virtio-balloon: switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM

Commit 71994620bb25 ("virtio_balloon: replace oom notifier with shrinker")
changed the behavior when deflation happens automatically.  Instead of
deflating when called by the OOM handler, the shrinker is used.

However, the balloon is not simply some other slab cache that should be
shrunk when under memory pressure.  The shrinker does not have a concept
of priorities yet, so this behavior cannot be configured.  Eventually once
that is in place, we might want to switch back after doing proper testing.

There was a report that this results in undesired side effects when
inflating the balloon to shrink the page cache. [1]
	"When inflating the balloon against page cache (i.e. no free memory
	 remains) vmscan.c will both shrink page cache, but also invoke the
	 shrinkers -- including the balloon's shrinker. So the balloon
	 driver allocates memory which requires reclaim, vmscan gets this
	 memory by shrinking the balloon, and then the driver adds the
	 memory back to the balloon. Basically a busy no-op."

The name "deflate on OOM" makes it pretty clear when deflation should
happen - after other approaches to reclaim memory failed, not while
reclaiming. This allows to minimize the footprint of a guest - memory
will only be taken out of the balloon when really needed.

Keep using the shrinker for VIRTIO_BALLOON_F_FREE_PAGE_HINT, because
this has no such side effects. Always register the shrinker with
VIRTIO_BALLOON_F_FREE_PAGE_HINT now. We are always allowed to reuse free
pages that are still to be processed by the guest. The hypervisor takes
care of identifying and resolving possible races between processing a
hinting request and the guest reusing a page.

In contrast to pre commit 71994620bb25 ("virtio_balloon: replace oom
notifier with shrinker"), don't add a module parameter to configure the
number of pages to deflate on OOM. Can be re-added if really needed.
Also, pay attention that leak_balloon() returns the number of 4k pages -
convert it properly in virtio_balloon_oom_notify().

Testing done by Tyler for future reference:
  Test setup: VM with 16 CPU, 64GB RAM. Running Debian 10. We have a 42
  GB file full of random bytes that we continually cat to /dev/null.
  This fills the page cache as the file is read. Meanwhile, we trigger
  the balloon to inflate, with a target size of 53 GB. This setup causes
  the balloon inflation to pressure the page cache as the page cache is
  also trying to grow. Afterwards we shrink the balloon back to zero (so
  total deflate == total inflate).

  Without this patch (kernel 4.19.0-5):
  Inflation never reaches the target until we stop the "cat file >
  /dev/null" process. Total inflation time was 542 seconds. The longest
  period that made no net forward progress was 315 seconds.
    Result of "grep balloon /proc/vmstat" after the test:
    balloon_inflate 154828377
    balloon_deflate 154828377

  With this patch (kernel 5.6.0-rc4+):
  Total inflation duration was 63 seconds. No deflate-queue activity
  occurs when pressuring the page-cache.
    Result of "grep balloon /proc/vmstat" after the test:
    balloon_inflate 12968539
    balloon_deflate 12968539

  Conclusion: This patch fixes the issue.  In the test it reduced
  inflate/deflate activity by 12x, and reduced inflation time by 8.6x. 
  But more importantly, if we hadn't killed the "cat file > /dev/null"
  process then, without the patch, the inflation process would never reach
  the target.

[1] https://www.spinics.net/lists/linux-virtualization/msg40863.html

Link: http://lkml.kernel.org/r/20200311135523.18512-2-david@redhat.com
Fixes: 71994620bb25 ("virtio_balloon: replace oom notifier with shrinker")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Tyler Sanderson <tysand@google.com>
Tested-by: Tyler Sanderson <tysand@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Wei Wang <wei.w.wang@intel.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Michal Hocko <mhocko@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |  103 +++++++++++++-----------------
 1 file changed, 47 insertions(+), 56 deletions(-)

--- a/drivers/virtio/virtio_balloon.c~virtio-balloon-switch-back-to-oom-handler-for-virtio_balloon_f_deflate_on_oom
+++ a/drivers/virtio/virtio_balloon.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/balloon_compaction.h>
+#include <linux/oom.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/mount.h>
@@ -28,7 +29,9 @@
  */
 #define VIRTIO_BALLOON_PAGES_PER_PAGE (unsigned)(PAGE_SIZE >> VIRTIO_BALLOON_PFN_SHIFT)
 #define VIRTIO_BALLOON_ARRAY_PFNS_MAX 256
-#define VIRTBALLOON_OOM_NOTIFY_PRIORITY 80
+/* Maximum number of (4k) pages to deflate on OOM notifications. */
+#define VIRTIO_BALLOON_OOM_NR_PAGES 256
+#define VIRTIO_BALLOON_OOM_NOTIFY_PRIORITY 80
 
 #define VIRTIO_BALLOON_FREE_PAGE_ALLOC_FLAG (__GFP_NORETRY | __GFP_NOWARN | \
 					     __GFP_NOMEMALLOC)
@@ -114,9 +117,12 @@ struct virtio_balloon {
 	/* Memory statistics */
 	struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
 
-	/* To register a shrinker to shrink memory upon memory pressure */
+	/* Shrinker to return free pages - VIRTIO_BALLOON_F_FREE_PAGE_HINT */
 	struct shrinker shrinker;
 
+	/* OOM notifier to deflate on OOM - VIRTIO_BALLOON_F_DEFLATE_ON_OOM */
+	struct notifier_block oom_nb;
+
 	/* Free page reporting device */
 	struct virtqueue *reporting_vq;
 	struct page_reporting_dev_info pr_dev_info;
@@ -830,50 +836,13 @@ static unsigned long shrink_free_pages(s
 	return blocks_freed * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
 }
 
-static unsigned long leak_balloon_pages(struct virtio_balloon *vb,
-                                          unsigned long pages_to_free)
-{
-	return leak_balloon(vb, pages_to_free * VIRTIO_BALLOON_PAGES_PER_PAGE) /
-		VIRTIO_BALLOON_PAGES_PER_PAGE;
-}
-
-static unsigned long shrink_balloon_pages(struct virtio_balloon *vb,
-					  unsigned long pages_to_free)
-{
-	unsigned long pages_freed = 0;
-
-	/*
-	 * One invocation of leak_balloon can deflate at most
-	 * VIRTIO_BALLOON_ARRAY_PFNS_MAX balloon pages, so we call it
-	 * multiple times to deflate pages till reaching pages_to_free.
-	 */
-	while (vb->num_pages && pages_freed < pages_to_free)
-		pages_freed += leak_balloon_pages(vb,
-						  pages_to_free - pages_freed);
-
-	update_balloon_size(vb);
-
-	return pages_freed;
-}
-
 static unsigned long virtio_balloon_shrinker_scan(struct shrinker *shrinker,
 						  struct shrink_control *sc)
 {
-	unsigned long pages_to_free, pages_freed = 0;
 	struct virtio_balloon *vb = container_of(shrinker,
 					struct virtio_balloon, shrinker);
 
-	pages_to_free = sc->nr_to_scan;
-
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
-		pages_freed = shrink_free_pages(vb, pages_to_free);
-
-	if (pages_freed >= pages_to_free)
-		return pages_freed;
-
-	pages_freed += shrink_balloon_pages(vb, pages_to_free - pages_freed);
-
-	return pages_freed;
+	return shrink_free_pages(vb, sc->nr_to_scan);
 }
 
 static unsigned long virtio_balloon_shrinker_count(struct shrinker *shrinker,
@@ -881,12 +850,22 @@ static unsigned long virtio_balloon_shri
 {
 	struct virtio_balloon *vb = container_of(shrinker,
 					struct virtio_balloon, shrinker);
-	unsigned long count;
 
-	count = vb->num_pages / VIRTIO_BALLOON_PAGES_PER_PAGE;
-	count += vb->num_free_page_blocks * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
+	return vb->num_free_page_blocks * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
+}
+
+static int virtio_balloon_oom_notify(struct notifier_block *nb,
+				     unsigned long dummy, void *parm)
+{
+	struct virtio_balloon *vb = container_of(nb,
+						 struct virtio_balloon, oom_nb);
+	unsigned long *freed = parm;
+
+	*freed += leak_balloon(vb, VIRTIO_BALLOON_OOM_NR_PAGES) /
+		  VIRTIO_BALLOON_PAGES_PER_PAGE;
+	update_balloon_size(vb);
 
-	return count;
+	return NOTIFY_OK;
 }
 
 static void virtio_balloon_unregister_shrinker(struct virtio_balloon *vb)
@@ -971,7 +950,23 @@ static int virtballoon_probe(struct virt
 						  VIRTIO_BALLOON_CMD_ID_STOP);
 		spin_lock_init(&vb->free_page_list_lock);
 		INIT_LIST_HEAD(&vb->free_page_list);
+		/*
+		 * We're allowed to reuse any free pages, even if they are
+		 * still to be processed by the host.
+		 */
+		err = virtio_balloon_register_shrinker(vb);
+		if (err)
+			goto out_del_balloon_wq;
+	}
+
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM)) {
+		vb->oom_nb.notifier_call = virtio_balloon_oom_notify;
+		vb->oom_nb.priority = VIRTIO_BALLOON_OOM_NOTIFY_PRIORITY;
+		err = register_oom_notifier(&vb->oom_nb);
+		if (err < 0)
+			goto out_unregister_shrinker;
 	}
+
 	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON)) {
 		/* Start with poison val of 0 representing general init */
 		__u32 poison_val = 0;
@@ -986,15 +981,6 @@ static int virtballoon_probe(struct virt
 		virtio_cwrite(vb->vdev, struct virtio_balloon_config,
 			      poison_val, &poison_val);
 	}
-	/*
-	 * We continue to use VIRTIO_BALLOON_F_DEFLATE_ON_OOM to decide if a
-	 * shrinker needs to be registered to relieve memory pressure.
-	 */
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM)) {
-		err = virtio_balloon_register_shrinker(vb);
-		if (err)
-			goto out_del_balloon_wq;
-	}
 
 	vb->pr_dev_info.report = virtballoon_free_page_report;
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
@@ -1003,12 +989,12 @@ static int virtballoon_probe(struct virt
 		capacity = virtqueue_get_vring_size(vb->reporting_vq);
 		if (capacity < PAGE_REPORTING_CAPACITY) {
 			err = -ENOSPC;
-			goto out_unregister_shrinker;
+			goto out_unregister_oom;
 		}
 
 		err = page_reporting_register(&vb->pr_dev_info);
 		if (err)
-			goto out_unregister_shrinker;
+			goto out_unregister_oom;
 	}
 
 	virtio_device_ready(vdev);
@@ -1017,8 +1003,11 @@ static int virtballoon_probe(struct virt
 		virtballoon_changed(vdev);
 	return 0;
 
-out_unregister_shrinker:
+out_unregister_oom:
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
+		unregister_oom_notifier(&vb->oom_nb);
+out_unregister_shrinker:
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 		virtio_balloon_unregister_shrinker(vb);
 out_del_balloon_wq:
 	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
@@ -1061,6 +1050,8 @@ static void virtballoon_remove(struct vi
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
 		page_reporting_unregister(&vb->pr_dev_info);
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
+		unregister_oom_notifier(&vb->oom_nb);
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 		virtio_balloon_unregister_shrinker(vb);
 	spin_lock_irq(&vb->stop_update_lock);
 	vb->stop_update = true;
_
