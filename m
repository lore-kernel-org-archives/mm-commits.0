From: akpm@linux-foundation.org
Subject: + fb_defio-fix-for-non-dirty-ptes.patch added to -mm tree
Date: Thu, 13 May 2010 12:42:52 -0700
Message-ID: <201005131942.o4DJgqmA016236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932535Ab0EMTmz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 15:42:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albert_herranz@yahoo.es, jayakumar.lkml@gmail.com


The patch titled
     fb_defio: fix for non-dirty ptes
has been added to the -mm tree.  Its filename is
     fb_defio-fix-for-non-dirty-ptes.patch

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
Subject: fb_defio: fix for non-dirty ptes
From: Albert Herranz <albert_herranz@yahoo.es>

Fix a problem observed while using fb_defio with a short delay on a
PowerPC platform.

It is possible that page_mkclean() is invoked in the deferred io work
function _before_ a PTE has been marked dirty.  In this case, the page is
removed from the defio pagelist but page_mkclean() does not write-protect
the page again.  The end result is that defio ignores all subsequent
writes to the page and the corresponding portions of the framebuffer never
get updated.

The fix consists in keeping track of the pages with non-dirty PTEs,
re-checking them again on the next deferred io work iteration.  Note that
those pages are not passed to the defio callback as they are not written
by userspace yet.

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fb_defio.c |   40 +++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff -puN drivers/video/fb_defio.c~fb_defio-fix-for-non-dirty-ptes drivers/video/fb_defio.c
--- a/drivers/video/fb_defio.c~fb_defio-fix-for-non-dirty-ptes
+++ a/drivers/video/fb_defio.c
@@ -155,25 +155,41 @@ static void fb_deferred_io_work(struct w
 {
 	struct fb_info *info = container_of(work, struct fb_info,
 						deferred_work.work);
-	struct list_head *node, *next;
-	struct page *cur;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
+	struct page *page, *tmp_page;
+	struct list_head *node, *tmp_node;
+	struct list_head non_dirty;
+
+	INIT_LIST_HEAD(&non_dirty);
 
 	/* here we mkclean the pages, then do all deferred IO */
 	mutex_lock(&fbdefio->lock);
-	list_for_each_entry(cur, &fbdefio->pagelist, lru) {
-		lock_page(cur);
-		page_mkclean(cur);
-		unlock_page(cur);
+	list_for_each_entry_safe(page, tmp_page, &fbdefio->pagelist, lru) {
+		lock_page(page);
+		/*
+		 * The workqueue callback can be triggered after a
+		 * ->page_mkwrite() call but before the PTE has been marked
+		 * dirty. In this case page_mkclean() won't "rearm" the page.
+		 *
+		 * To avoid this, remove those "non-dirty" pages from the
+		 * pagelist before calling the driver's callback, then add
+		 * them back to get processed on the next work iteration.
+		 * At that time, their PTEs will hopefully be dirty for real.
+		 */
+		if (!page_mkclean(page))
+			list_move_tail(&page->lru, &non_dirty);
+		unlock_page(page);
 	}
 
 	/* driver's callback with pagelist */
 	fbdefio->deferred_io(info, &fbdefio->pagelist);
 
-	/* clear the list */
-	list_for_each_safe(node, next, &fbdefio->pagelist) {
+	/* clear the list... */
+	list_for_each_safe(node, tmp_node, &fbdefio->pagelist) {
 		list_del(node);
 	}
+	/* ... and add back the "non-dirty" pages to the list */
+	list_splice_tail(&non_dirty, &fbdefio->pagelist);
 	mutex_unlock(&fbdefio->lock);
 }
 
@@ -202,6 +218,7 @@ EXPORT_SYMBOL_GPL(fb_deferred_io_open);
 void fb_deferred_io_cleanup(struct fb_info *info)
 {
 	struct fb_deferred_io *fbdefio = info->fbdefio;
+	struct list_head *node, *tmp_node;
 	struct page *page;
 	int i;
 
@@ -209,6 +226,13 @@ void fb_deferred_io_cleanup(struct fb_in
 	cancel_delayed_work(&info->deferred_work);
 	flush_scheduled_work();
 
+	/*  the list may have still some non-dirty pages at this point */
+	mutex_lock(&fbdefio->lock);
+	list_for_each_safe(node, tmp_node, &fbdefio->pagelist) {
+		list_del(node);
+	}
+	mutex_unlock(&fbdefio->lock);
+
 	/* clear out the mapping that we setup */
 	for (i = 0 ; i < info->fix.smem_len; i += PAGE_SIZE) {
 		page = fb_deferred_io_page(info, i);
_

Patches currently in -mm which might be from albert_herranz@yahoo.es are

fb_defio-fix-for-non-dirty-ptes.patch

