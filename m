From: akpm@linux-foundation.org
Subject: + virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch added to -mm tree
Date: Wed, 07 Nov 2012 12:01:21 -0800
Message-ID: <20121107200122.346AB100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:58462 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2KGUBX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2012 15:01:23 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so230854yhl.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Nov 2012 12:01:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aquini@redhat.com, andi@firstfloor.org, konrad.wilk@oracle.com, mel@csn.ul.ie, minchan@kernel.org, mst@redhat.com, riel@redhat.com, rusty@rustcorp.com.au


The patch titled
     Subject: virtio_balloon: introduce migration primitives to balloon pages
has been added to the -mm tree.  Its filename is
     virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: virtio_balloon: introduce migration primitives to balloon pages

Memory fragmentation introduced by ballooning might reduce significantly
the number of 2MB contiguous memory blocks that can be used within a
guest, thus imposing performance penalties associated with the reduced
number of transparent huge pages that could be used by the guest workload.

Besides making balloon pages movable at allocation time and introducing
the necessary primitives to perform balloon page migration/compaction,
this patch also introduces the following locking scheme, in order to
enhance the syncronization methods for accessing elements of struct
virtio_balloon, thus providing protection against concurrent access
introduced by parallel memory migration threads.

 - balloon_lock (mutex) : synchronizes the access demand to elements of
                          struct virtio_balloon and its queue operations;

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |  131 +++++++++++++++++++++++++++---
 1 file changed, 119 insertions(+), 12 deletions(-)

diff -puN drivers/virtio/virtio_balloon.c~virtio_balloon-introduce-migration-primitives-to-balloon-pages drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~virtio_balloon-introduce-migration-primitives-to-balloon-pages
+++ a/drivers/virtio/virtio_balloon.c
@@ -27,6 +27,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/balloon_compaction.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -34,6 +35,7 @@
  * page units.
  */
 #define VIRTIO_BALLOON_PAGES_PER_PAGE (PAGE_SIZE >> VIRTIO_BALLOON_PFN_SHIFT)
+#define VIRTIO_BALLOON_ARRAY_PFNS_MAX 256
 
 struct virtio_balloon
 {
@@ -52,15 +54,19 @@ struct virtio_balloon
 	/* Number of balloon pages we've told the Host we're not using. */
 	unsigned int num_pages;
 	/*
-	 * The pages we've told the Host we're not using.
+	 * The pages we've told the Host we're not using are enqueued
+	 * at vb_dev_info->pages list.
 	 * Each page on this list adds VIRTIO_BALLOON_PAGES_PER_PAGE
 	 * to num_pages above.
 	 */
-	struct list_head pages;
+	struct balloon_dev_info *vb_dev_info;
+
+	/* Synchronize access/update to this struct virtio_balloon elements */
+	struct mutex balloon_lock;
 
 	/* The array of pfns we tell the Host about. */
 	unsigned int num_pfns;
-	u32 pfns[256];
+	u32 pfns[VIRTIO_BALLOON_ARRAY_PFNS_MAX];
 
 	/* Memory statistics */
 	int need_stats_update;
@@ -122,17 +128,20 @@ static void set_page_pfns(u32 pfns[], st
 
 static void fill_balloon(struct virtio_balloon *vb, size_t num)
 {
+	struct balloon_dev_info *vb_dev_info = vb->vb_dev_info;
+
 	/* We can only do one array worth at a time. */
 	num = min(num, ARRAY_SIZE(vb->pfns));
 
+	mutex_lock(&vb->balloon_lock);
 	for (vb->num_pfns = 0; vb->num_pfns < num;
 	     vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
-		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
-					__GFP_NOMEMALLOC | __GFP_NOWARN);
+		struct page *page = balloon_page_enqueue(vb_dev_info);
+
 		if (!page) {
 			dev_info_ratelimited(&vb->vdev->dev,
-					     "Out of puff! Can't get %zu pages\n",
-					     num);
+					   "Out of puff! Can't get %zu pages\n",
+					   VIRTIO_BALLOON_PAGES_PER_PAGE);
 			/* Sleep for at least 1/5 of a second before retry. */
 			msleep(200);
 			break;
@@ -140,7 +149,6 @@ static void fill_balloon(struct virtio_b
 		set_page_pfns(vb->pfns + vb->num_pfns, page);
 		vb->num_pages += VIRTIO_BALLOON_PAGES_PER_PAGE;
 		totalram_pages--;
-		list_add(&page->lru, &vb->pages);
 	}
 
 	/* Didn't get any?  Oh well. */
@@ -148,6 +156,7 @@ static void fill_balloon(struct virtio_b
 		return;
 
 	tell_host(vb, vb->inflate_vq);
+	mutex_unlock(&vb->balloon_lock);
 }
 
 static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
@@ -164,14 +173,17 @@ static void release_pages_by_pfn(const u
 static void leak_balloon(struct virtio_balloon *vb, size_t num)
 {
 	struct page *page;
+	struct balloon_dev_info *vb_dev_info = vb->vb_dev_info;
 
 	/* We can only do one array worth at a time. */
 	num = min(num, ARRAY_SIZE(vb->pfns));
 
+	mutex_lock(&vb->balloon_lock);
 	for (vb->num_pfns = 0; vb->num_pfns < num;
 	     vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
-		page = list_first_entry(&vb->pages, struct page, lru);
-		list_del(&page->lru);
+		page = balloon_page_dequeue(vb_dev_info);
+		if (!page)
+			break;
 		set_page_pfns(vb->pfns + vb->num_pfns, page);
 		vb->num_pages -= VIRTIO_BALLOON_PAGES_PER_PAGE;
 	}
@@ -182,6 +194,7 @@ static void leak_balloon(struct virtio_b
 	 * is true, we *have* to do it in this order
 	 */
 	tell_host(vb, vb->deflate_vq);
+	mutex_unlock(&vb->balloon_lock);
 	release_pages_by_pfn(vb->pfns, vb->num_pfns);
 }
 
@@ -338,9 +351,76 @@ static int init_vqs(struct virtio_balloo
 	return 0;
 }
 
+static const struct address_space_operations virtio_balloon_aops;
+#ifdef CONFIG_BALLOON_COMPACTION
+/*
+ * virtballoon_migratepage - perform the balloon page migration on behalf of
+ *			     a compation thread.     (called under page lock)
+ * @mapping: the page->mapping which will be assigned to the new migrated page.
+ * @newpage: page that will replace the isolated page after migration finishes.
+ * @page   : the isolated (old) page that is about to be migrated to newpage.
+ * @mode   : compaction mode -- not used for balloon page migration.
+ *
+ * After a ballooned page gets isolated by compaction procedures, this is the
+ * function that performs the page migration on behalf of a compaction thread
+ * The page migration for virtio balloon is done in a simple swap fashion which
+ * follows these two macro steps:
+ *  1) insert newpage into vb->pages list and update the host about it;
+ *  2) update the host about the old page removed from vb->pages list;
+ *
+ * This function preforms the balloon page migration task.
+ * Called through balloon_mapping->a_ops->migratepage
+ */
+int virtballoon_migratepage(struct address_space *mapping,
+		struct page *newpage, struct page *page, enum migrate_mode mode)
+{
+	struct balloon_dev_info *vb_dev_info = balloon_page_device(page);
+	struct virtio_balloon *vb;
+	unsigned long flags;
+
+	BUG_ON(!vb_dev_info);
+
+	vb = vb_dev_info->balloon_device;
+
+	if (!mutex_trylock(&vb->balloon_lock))
+		return -EAGAIN;
+
+	/* balloon's page migration 1st step  -- inflate "newpage" */
+	spin_lock_irqsave(&vb_dev_info->pages_lock, flags);
+	balloon_page_insert(newpage, mapping, &vb_dev_info->pages);
+	vb_dev_info->isolated_pages--;
+	spin_unlock_irqrestore(&vb_dev_info->pages_lock, flags);
+	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
+	set_page_pfns(vb->pfns, newpage);
+	tell_host(vb, vb->inflate_vq);
+
+	/*
+	 * balloon's page migration 2nd step -- deflate "page"
+	 *
+	 * It's safe to delete page->lru here because this page is at
+	 * an isolated migration list, and this step is expected to happen here
+	 */
+	balloon_page_delete(page);
+	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
+	set_page_pfns(vb->pfns, page);
+	tell_host(vb, vb->deflate_vq);
+
+	mutex_unlock(&vb->balloon_lock);
+
+	return MIGRATEPAGE_BALLOON_SUCCESS;
+}
+
+/* define the balloon_mapping->a_ops callback to allow balloon page migration */
+static const struct address_space_operations virtio_balloon_aops = {
+			.migratepage = virtballoon_migratepage,
+};
+#endif /* CONFIG_BALLOON_COMPACTION */
+
 static int virtballoon_probe(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb;
+	struct address_space *vb_mapping;
+	struct balloon_dev_info *vb_devinfo;
 	int err;
 
 	vdev->priv = vb = kmalloc(sizeof(*vb), GFP_KERNEL);
@@ -349,16 +429,37 @@ static int virtballoon_probe(struct virt
 		goto out;
 	}
 
-	INIT_LIST_HEAD(&vb->pages);
 	vb->num_pages = 0;
+	mutex_init(&vb->balloon_lock);
 	init_waitqueue_head(&vb->config_change);
 	init_waitqueue_head(&vb->acked);
 	vb->vdev = vdev;
 	vb->need_stats_update = 0;
 
+	vb_devinfo = balloon_devinfo_alloc(vb);
+	if (IS_ERR(vb_devinfo)) {
+		err = PTR_ERR(vb_devinfo);
+		goto out_free_vb;
+	}
+
+	vb_mapping = balloon_mapping_alloc(vb_devinfo,
+					   (balloon_compaction_check()) ?
+					   &virtio_balloon_aops : NULL);
+	if (IS_ERR(vb_mapping)) {
+		/*
+		 * IS_ERR(vb_mapping) && PTR_ERR(vb_mapping) == -EOPNOTSUPP
+		 * This means !CONFIG_BALLOON_COMPACTION, otherwise we get off.
+		 */
+		err = PTR_ERR(vb_mapping);
+		if (err != -EOPNOTSUPP)
+			goto out_free_vb_devinfo;
+	}
+
+	vb->vb_dev_info = vb_devinfo;
+
 	err = init_vqs(vb);
 	if (err)
-		goto out_free_vb;
+		goto out_free_vb_mapping;
 
 	vb->thread = kthread_run(balloon, vb, "vballoon");
 	if (IS_ERR(vb->thread)) {
@@ -370,6 +471,10 @@ static int virtballoon_probe(struct virt
 
 out_del_vqs:
 	vdev->config->del_vqs(vdev);
+out_free_vb_mapping:
+	balloon_mapping_free(vb_mapping);
+out_free_vb_devinfo:
+	balloon_devinfo_free(vb_devinfo);
 out_free_vb:
 	kfree(vb);
 out:
@@ -395,6 +500,8 @@ static void __devexit virtballoon_remove
 
 	kthread_stop(vb->thread);
 	remove_common(vb);
+	balloon_mapping_free(vb->vb_dev_info->mapping);
+	balloon_devinfo_free(vb->vb_dev_info);
 	kfree(vb);
 }
 
_

Patches currently in -mm which might be from aquini@redhat.com are

mm-adjust-address_space_operationsmigratepage-return-code.patch
mm-redefine-address_spaceassoc_mapping.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility.patch
mm-introduce-compaction-and-migration-for-ballooned-pages.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch
mm-introduce-putback_movable_pages.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

