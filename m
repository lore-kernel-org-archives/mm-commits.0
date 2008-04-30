From: akpm@linux-foundation.org
Subject: + fbdev-bugfix-for-multiprocess-defio.patch added to -mm tree
Date: Wed, 30 Apr 2008 13:38:29 -0700
Message-ID: <200804302038.m3UKcTiq001801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760476AbYD3Uio (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 16:38:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jayakumar.lkml@gmail.com, adaplas@pol.net, bernard@largestprime.net, geert@linux-m68k.org


The patch titled
     fbdev: bugfix for multiprocess defio
has been added to the -mm tree.  Its filename is
     fbdev-bugfix-for-multiprocess-defio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: bugfix for multiprocess defio
From: Jaya Kumar <jayakumar.lkml@gmail.com>

This is a bugfix for how defio handles multiple processes manipulating
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
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
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

origin.patch
fbdev-bugfix-for-multiprocess-defio.patch

