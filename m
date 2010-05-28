From: akpm@linux-foundation.org
Subject: + revert-fb_defio-fix-for-non-dirty-ptes.patch added to -mm tree
Date: Fri, 28 May 2010 15:44:05 -0700
Message-ID: <201005282244.o4SMi5i8018720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771Ab0E1WoI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 18:44:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albert_herranz@yahoo.es, jayakumar.lkml@gmail.com, nickpiggin@yahoo.com.au


The patch titled
     Revert "fb_defio: fix for non-dirty ptes"
has been added to the -mm tree.  Its filename is
     revert-fb_defio-fix-for-non-dirty-ptes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Revert "fb_defio: fix for non-dirty ptes"
From: Albert Herranz <albert_herranz@yahoo.es>

This reverts commit 49bbd815fd8ba26d0354900b783b767c7f47c816 ("fb_defio:
fix for non-dirty ptes").

Although the fix provided is correct, it's been suggested to avoid the
underlying race in the same way as it is currently done in filesystems
like NFS, for maintainability.

A following patch "fb_defio: redo fix for non-dirty ptes" will provide
such an alternate fix.

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fb_defio.c |   40 +++++++------------------------------
 1 file changed, 8 insertions(+), 32 deletions(-)

diff -puN drivers/video/fb_defio.c~revert-fb_defio-fix-for-non-dirty-ptes drivers/video/fb_defio.c
--- a/drivers/video/fb_defio.c~revert-fb_defio-fix-for-non-dirty-ptes
+++ a/drivers/video/fb_defio.c
@@ -155,41 +155,25 @@ static void fb_deferred_io_work(struct w
 {
 	struct fb_info *info = container_of(work, struct fb_info,
 						deferred_work.work);
+	struct list_head *node, *next;
+	struct page *cur;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
-	struct page *page, *tmp_page;
-	struct list_head *node, *tmp_node;
-	struct list_head non_dirty;
-
-	INIT_LIST_HEAD(&non_dirty);
 
 	/* here we mkclean the pages, then do all deferred IO */
 	mutex_lock(&fbdefio->lock);
-	list_for_each_entry_safe(page, tmp_page, &fbdefio->pagelist, lru) {
-		lock_page(page);
-		/*
-		 * The workqueue callback can be triggered after a
-		 * ->page_mkwrite() call but before the PTE has been marked
-		 * dirty. In this case page_mkclean() won't "rearm" the page.
-		 *
-		 * To avoid this, remove those "non-dirty" pages from the
-		 * pagelist before calling the driver's callback, then add
-		 * them back to get processed on the next work iteration.
-		 * At that time, their PTEs will hopefully be dirty for real.
-		 */
-		if (!page_mkclean(page))
-			list_move_tail(&page->lru, &non_dirty);
-		unlock_page(page);
+	list_for_each_entry(cur, &fbdefio->pagelist, lru) {
+		lock_page(cur);
+		page_mkclean(cur);
+		unlock_page(cur);
 	}
 
 	/* driver's callback with pagelist */
 	fbdefio->deferred_io(info, &fbdefio->pagelist);
 
-	/* clear the list... */
-	list_for_each_safe(node, tmp_node, &fbdefio->pagelist) {
+	/* clear the list */
+	list_for_each_safe(node, next, &fbdefio->pagelist) {
 		list_del(node);
 	}
-	/* ... and add back the "non-dirty" pages to the list */
-	list_splice_tail(&non_dirty, &fbdefio->pagelist);
 	mutex_unlock(&fbdefio->lock);
 }
 
@@ -218,7 +202,6 @@ EXPORT_SYMBOL_GPL(fb_deferred_io_open);
 void fb_deferred_io_cleanup(struct fb_info *info)
 {
 	struct fb_deferred_io *fbdefio = info->fbdefio;
-	struct list_head *node, *tmp_node;
 	struct page *page;
 	int i;
 
@@ -226,13 +209,6 @@ void fb_deferred_io_cleanup(struct fb_in
 	cancel_delayed_work(&info->deferred_work);
 	flush_scheduled_work();
 
-	/*  the list may have still some non-dirty pages at this point */
-	mutex_lock(&fbdefio->lock);
-	list_for_each_safe(node, tmp_node, &fbdefio->pagelist) {
-		list_del(node);
-	}
-	mutex_unlock(&fbdefio->lock);
