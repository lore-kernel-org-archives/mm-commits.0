From: akpm@linux-foundation.org
Subject: - fbdev-bugfix-for-multiprocess-defio.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:34:49 -0700
Message-ID: <200807141934.m6EJYnfq023839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754605AbYGNTfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jayakumar.lkml@gmail.com, bernard@largestprime.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: bugfix for multiprocess defio
has been removed from the -mm tree.  Its filename was
     fbdev-bugfix-for-multiprocess-defio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: bugfix for multiprocess defio
From: Jaya Kumar <jayakumar.lkml@gmail.com>

This patch is a bugfix for how defio handles multiple processes manipulating
the same framebuffer.

Thanks to Bernard Blackham for identifying this bug.

It occurs when two applications mmap the same framebuffer and concurrently
write to the same page.  Normally, this doesn't occur since only a single
process mmaps the framebuffer.  The symptom of the bug is that the mapping
applications will hang.  The cause is that defio incorrectly tries to add the
same page twice to the pagelist.  The solution I have is to walk the pagelist
and check for a duplicate before adding.  Since I needed to walk the pagelist,
I now also keep the pagelist in sorted order.

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Bernard Blackham <bernard@largestprime.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fb_defio.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN drivers/video/fb_defio.c~fbdev-bugfix-for-multiprocess-defio drivers/video/fb_defio.c
--- a/drivers/video/fb_defio.c~fbdev-bugfix-for-multiprocess-defio
+++ a/drivers/video/fb_defio.c
@@ -74,6 +74,7 @@ static int fb_deferred_io_mkwrite(struct
 {
 	struct fb_info *info = vma->vm_private_data;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
+	struct page *cur;
 
 	/* this is a callback we get when userspace first tries to
 	write to the page. we schedule a workqueue. that workqueue
@@ -83,7 +84,24 @@ static int fb_deferred_io_mkwrite(struct
 
 	/* protect against the workqueue changing the page list */
 	mutex_lock(&fbdefio->lock);
-	list_add(&page->lru, &fbdefio->pagelist);
+
+	/* we loop through the pagelist before adding in order
+	to keep the pagelist sorted */
+	list_for_each_entry(cur, &fbdefio->pagelist, lru) {
+		/* this check is to catch the case where a new
+		process could start writing to the same page
+		through a new pte. this new access can cause the
+		mkwrite even when the original ps's pte is marked
+		writable */
+		if (unlikely(cur == page))
+			goto page_already_added;
+		else if (cur->index > page->index)
+			break;
+	}
+
+	list_add_tail(&page->lru, &cur->lru);
+
+page_already_added:
 	mutex_unlock(&fbdefio->lock);
 
 	/* come back after delay to process the deferred IO */
_

Patches currently in -mm which might be from jayakumar.lkml@gmail.com are

linux-next.patch

