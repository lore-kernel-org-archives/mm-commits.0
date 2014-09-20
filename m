From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-balloon_compaction-use-common-page-ballooning-v2-fix-1.patch removed
 from -mm tree
Date: Fri, 19 Sep 2014 23:26:43 -0700
Message-ID: <541d1e23.jo9Ap2kYfl8gFpPl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaITG0s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 20 Sep 2014 02:26:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-balloon_compaction-use-common-page-ballooning-v2-fix-1
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-use-common-page-ballooning-v2-fix-1.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm-balloon_compaction-use-common-page-ballooning-v2-fix-1

This is fix for "mm/balloon_compaction: use common page ballooning".  it
reverts per-zone balloon counters and replaces them with vmstat counters:
"balloon_inflate", "balloon_deflate" and "balloon_migrate".

Per-zone balloon counters have been reverted after discussion but
reverting them from balloon_compaction conflicts with massive cleanup in
this code.  Thus this change ends up as a separate patch.  Sorry for the
mess.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c    |    1 +
 include/linux/balloon_compaction.h |    2 --
 mm/balloon_compaction.c            |    2 ++
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/virtio/virtio_balloon.c~mm-balloon_compaction-use-common-page-ballooning-v2-fix-1 drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~mm-balloon_compaction-use-common-page-ballooning-v2-fix-1
+++ a/drivers/virtio/virtio_balloon.c
@@ -395,6 +395,7 @@ static int virtballoon_migratepage(struc
 	/* balloon's page migration 1st step  -- inflate "newpage" */
 	spin_lock_irqsave(&vb_dev_info->pages_lock, flags);
 	balloon_page_insert(vb_dev_info, newpage);
+	__count_vm_event(BALLOON_MIGRATE);
 	vb_dev_info->isolated_pages--;
 	spin_unlock_irqrestore(&vb_dev_info->pages_lock, flags);
 	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
diff -puN include/linux/balloon_compaction.h~mm-balloon_compaction-use-common-page-ballooning-v2-fix-1 include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-use-common-page-ballooning-v2-fix-1
+++ a/include/linux/balloon_compaction.h
@@ -87,7 +87,6 @@ static inline void
 balloon_page_insert(struct balloon_dev_info *b_dev_info, struct page *page)
 {
 	__SetPageBalloon(page);
-	inc_zone_page_state(page, NR_BALLOON_PAGES);
 	set_page_private(page, (unsigned long)b_dev_info);
 	list_add(&page->lru, &b_dev_info->pages);
 }
@@ -104,7 +103,6 @@ balloon_page_insert(struct balloon_dev_i
 static inline void balloon_page_delete(struct page *page, bool isolated)
 {
 	__ClearPageBalloon(page);
-	dec_zone_page_state(page, NR_BALLOON_PAGES);
 	set_page_private(page, 0);
 	if (!isolated)
 		list_del(&page->lru);
diff -puN mm/balloon_compaction.c~mm-balloon_compaction-use-common-page-ballooning-v2-fix-1 mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-balloon_compaction-use-common-page-ballooning-v2-fix-1
+++ a/mm/balloon_compaction.c
@@ -36,6 +36,7 @@ struct page *balloon_page_enqueue(struct
 	BUG_ON(!trylock_page(page));
 	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
 	balloon_page_insert(b_dev_info, page);
+	__count_vm_event(BALLOON_INFLATE);
 	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
 	unlock_page(page);
 	return page;
@@ -67,6 +68,7 @@ struct page *balloon_page_dequeue(struct
 		if (trylock_page(page)) {
 			spin_lock_irqsave(&b_dev_info->pages_lock, flags);
 			balloon_page_delete(page, false);
+			__count_vm_event(BALLOON_DEFLATE);
 			spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
 			unlock_page(page);
 			return page;
_

Patches currently in -mm which might be from koct9i@gmail.com are


