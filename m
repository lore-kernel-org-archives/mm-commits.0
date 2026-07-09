Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFDE340413
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 22:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783637404; cv=none; b=Sk4RaUC6nNxh0Q1RALuRMRWkmITtGG1wwdop+IZtMVqzMjSpP5HVE6oyays+vUaGVGrtEAhXlikGPpbEYtkch12chhsbnN8edC1XSHncnyIqlCL7pXCLTcvjoK+dqXem448HCjvbE0WzjmWz7lhaaSTrHFnJ6cUeveDrt0mhdoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783637404; c=relaxed/simple;
	bh=+5fLG7k9EEJVcl0D+vSK2drdZFMZ8JbQvfTiQoFJPpU=;
	h=Date:To:From:Subject:Message-Id; b=HWtNofKaRWFuTW9y8UOpIVMPAg3YiLno2gT3SOsGCqMJu1ldyeNMM8TUGxao/XEz4CRKOdT9NrJwxU857jFwUoffhwoIyj5AUCqZBwMNyod65LQUpzSPXDxC1vhNfbxp9uCB1UOyWQtvdyXtyd0cpLTNzN5/guF0ltYjbWxogjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uUkAu9FZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uUkAu9FZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191901F00A3A;
	Thu,  9 Jul 2026 22:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783637403;
	bh=wnFB3IP8gzaLXxm05VkHTUEjyUcqavcNt3ksU78J4W0=;
	h=Date:To:From:Subject;
	b=uUkAu9FZMx+sCh65vkpsa+eM5FbGyavQfwwGXKEjB6dJpUT9JOjCIlJFa6JRDKJ9g
	 vqu/I0mCzyHSFMHpWtn7DP666+PK3IWhGBaGH+Sb8UjGL/+HbwnRU7zNtglRS/TCam
	 6EJdNMLeKkBJa7OVZMSVYixoP7UimMXsTQYD65Fk=
Date: Thu, 09 Jul 2026 15:50:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pankaj.gupta@amd.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,gourry@gourry.net,eperezma@redhat.com,david@kernel.org,alexander.h.duyck@linux.intel.com,mst@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_reporting-allow-driver-to-set-batch-capacity.patch removed from -mm tree
Message-Id: <20260709225003.191901F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_reporting: allow driver to set batch capacity
has been removed from the -mm tree.  Its filename was
     mm-page_reporting-allow-driver-to-set-batch-capacity.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: mm: page_reporting: allow driver to set batch capacity
Date: Sun, 5 Jul 2026 02:25:13 -0400

At the moment, if a virtio balloon device has a page reporting vq but its
size is < PAGE_REPORTING_CAPACITY (32), the balloon driver fails probe.

But, there's no way for host to know this value, so it can easily create a
smaller vq and suddenly adding the reporting capability to the device
makes all of the driver fail.  Not pretty.

Add a capacity field to page_reporting_dev_info so drivers can control the
maximum number of pages per report batch.

In virtio-balloon, set the capacity to the reporting virtqueue size,
letting page_reporting adapt to whatever the device provides.

Capacity need not be a power of two.  Code previously called out division
by PAGE_REPORTING_CAPACITY as cheap since it was a power of 2, but no
performance difference was observed with non-power-of-2 values.

If capacity is 0 or exceeds PAGE_REPORTING_CAPACITY, it defaults to
PAGE_REPORTING_CAPACITY.  The 0 check and the clamping is done in
page_reporting_register(), before the reporting work is scheduled, so we
never get division by 0.

Link: https://lore.kernel.org/444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com
Fixes: b0c504f15471 ("virtio-balloon: add support for providing free page reports to host")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |    5 +----
 include/linux/page_reporting.h  |    4 +++-
 mm/page_reporting.c             |   24 ++++++++++++------------
 3 files changed, 16 insertions(+), 17 deletions(-)

--- a/drivers/virtio/virtio_balloon.c~mm-page_reporting-allow-driver-to-set-batch-capacity
+++ a/drivers/virtio/virtio_balloon.c
@@ -1017,10 +1017,6 @@ static int virtballoon_probe(struct virt
 		unsigned int capacity;
 
 		capacity = virtqueue_get_vring_size(vb->reporting_vq);
-		if (capacity < PAGE_REPORTING_CAPACITY) {
-			err = -ENOSPC;
-			goto out_unregister_oom;
-		}
 
 		vb->pr_dev_info.order = PAGE_REPORTING_ORDER_UNSPECIFIED;
 
@@ -1041,6 +1037,7 @@ static int virtballoon_probe(struct virt
 		vb->pr_dev_info.order = 5;
 #endif
 
+		vb->pr_dev_info.capacity = capacity;
 		err = page_reporting_register(&vb->pr_dev_info);
 		if (err)
 			goto out_unregister_oom;
--- a/include/linux/page_reporting.h~mm-page_reporting-allow-driver-to-set-batch-capacity
+++ a/include/linux/page_reporting.h
@@ -5,7 +5,6 @@
 #include <linux/mmzone.h>
 #include <linux/scatterlist.h>
 
-/* This value should always be a power of 2, see page_reporting_cycle() */
 #define PAGE_REPORTING_CAPACITY		32
 #define PAGE_REPORTING_ORDER_UNSPECIFIED	-1
 
@@ -22,6 +21,9 @@ struct page_reporting_dev_info {
 
 	/* Minimal order of page reporting */
 	unsigned int order;
+
+	/* Max pages per report batch; 0 (default) means PAGE_REPORTING_CAPACITY */
+	unsigned int capacity;
 };
 
 /* Tear-down and bring-up for page reporting devices */
--- a/mm/page_reporting.c~mm-page_reporting-allow-driver-to-set-batch-capacity
+++ a/mm/page_reporting.c
@@ -173,11 +173,8 @@ page_reporting_cycle(struct page_reporti
 	 * any pages that may have already been present from the previous
 	 * list processed. This should result in us reporting all pages on
 	 * an idle system in about 30 seconds.
-	 *
-	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
-	 * should always be a power of 2.
 	 */
-	budget = DIV_ROUND_UP(area->nr_free, PAGE_REPORTING_CAPACITY * 16);
+	budget = DIV_ROUND_UP(area->nr_free, prdev->capacity * 16);
 
 	/* loop through free list adding unreported pages to sg list */
 	list_for_each_entry_safe(page, next, list, lru) {
@@ -222,10 +219,10 @@ page_reporting_cycle(struct page_reporti
 		spin_unlock_irq(&zone->lock);
 
 		/* begin processing pages in local list */
-		err = prdev->report(prdev, sgl, PAGE_REPORTING_CAPACITY);
+		err = prdev->report(prdev, sgl, prdev->capacity);
 
 		/* reset offset since the full list was reported */
-		*offset = PAGE_REPORTING_CAPACITY;
+		*offset = prdev->capacity;
 
 		/* update budget to reflect call to report function */
 		budget--;
@@ -234,7 +231,7 @@ page_reporting_cycle(struct page_reporti
 		spin_lock_irq(&zone->lock);
 
 		/* flush reported pages from the sg list */
-		page_reporting_drain(prdev, sgl, PAGE_REPORTING_CAPACITY, !err);
+		page_reporting_drain(prdev, sgl, prdev->capacity, !err);
 
 		/*
 		 * Reset next to first entry, the old next isn't valid
@@ -260,13 +257,13 @@ static int
 page_reporting_process_zone(struct page_reporting_dev_info *prdev,
 			    struct scatterlist *sgl, struct zone *zone)
 {
-	unsigned int order, mt, leftover, offset = PAGE_REPORTING_CAPACITY;
+	unsigned int order, mt, leftover, offset = prdev->capacity;
 	unsigned long watermark;
 	int err = 0;
 
 	/* Generate minimum watermark to be able to guarantee progress */
 	watermark = low_wmark_pages(zone) +
-		    (PAGE_REPORTING_CAPACITY << page_reporting_order);
+		    (prdev->capacity << page_reporting_order);
 
 	/*
 	 * Cancel request if insufficient free memory or if we failed
@@ -290,7 +287,7 @@ page_reporting_process_zone(struct page_
 	}
 
 	/* report the leftover pages before going idle */
-	leftover = PAGE_REPORTING_CAPACITY - offset;
+	leftover = prdev->capacity - offset;
 	if (leftover) {
 		sgl = &sgl[offset];
 		err = prdev->report(prdev, sgl, leftover);
@@ -322,11 +319,11 @@ static void page_reporting_process(struc
 	atomic_set(&prdev->state, state);
 
 	/* allocate scatterlist to store pages being reported on */
-	sgl = kmalloc_objs(*sgl, PAGE_REPORTING_CAPACITY);
+	sgl = kmalloc_objs(*sgl, prdev->capacity);
 	if (!sgl)
 		goto err_out;
 
-	sg_init_table(sgl, PAGE_REPORTING_CAPACITY);
+	sg_init_table(sgl, prdev->capacity);
 
 	for_each_zone(zone) {
 		err = page_reporting_process_zone(prdev, sgl, zone);
@@ -377,6 +374,9 @@ int page_reporting_register(struct page_
 			page_reporting_order = pageblock_order;
 	}
 
+	if (!prdev->capacity || prdev->capacity > PAGE_REPORTING_CAPACITY)
+		prdev->capacity = PAGE_REPORTING_CAPACITY;
+
 	/* initialize state and work structures */
 	atomic_set(&prdev->state, PAGE_REPORTING_IDLE);
 	INIT_DELAYED_WORK(&prdev->work, &page_reporting_process);
_

Patches currently in -mm which might be from mst@redhat.com are


