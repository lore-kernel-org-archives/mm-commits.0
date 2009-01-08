From: akpm@linux-foundation.org
Subject: + nommu-fix-cleanup-handling-in-ramfs_nommu_get_umapped_area.patch added to -mm tree
Date: Thu, 08 Jan 2009 03:05:23 -0800
Message-ID: <200901081105.n08B5N7j030842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170AbZAHLF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 06:05:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, cooloney@kernel.org, gerg@uclinux.org, graf.yang@analog.com


The patch titled
     NOMMU: Fix cleanup handling in ramfs_nommu_get_umapped_area()
has been added to the -mm tree.  Its filename is
     nommu-fix-cleanup-handling-in-ramfs_nommu_get_umapped_area.patch

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
Subject: NOMMU: Fix cleanup handling in ramfs_nommu_get_umapped_area()
From: David Howells <dhowells@redhat.com>

Fix cleanup handling in ramfs_nommu_get_umapped_area() by only freeing
the number of pages that find_get_pages() said it had returned (nr)
rather than attempting to free the number of pages we asked for
(lpages) - thus avoiding the situation whereby put_page() may be handed
NULL pointers if find_get_pages() returned fewer pages that were
requested.

Also avoid a warning about nr being uninitialised and the need for an
if-statement in the cleanup path by using appropriate gotos.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Graf Yang <graf.yang@analog.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN fs/ramfs/file-nommu.c~nommu-fix-cleanup-handling-in-ramfs_nommu_get_umapped_area fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~nommu-fix-cleanup-handling-in-ramfs_nommu_get_umapped_area
+++ a/fs/ramfs/file-nommu.c
@@ -262,11 +262,11 @@ unsigned long ramfs_nommu_get_unmapped_a
 	ret = -ENOMEM;
 	pages = kzalloc(lpages * sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
-		goto out;
+		goto out_free;
 
 	nr = find_get_pages(inode->i_mapping, pgoff, lpages, pages);
 	if (nr != lpages)
-		goto out; /* leave if some pages were missing */
+		goto out_free_pages; /* leave if some pages were missing */
 
 	/* check the pages for physical adjacency */
 	ptr = pages;
@@ -274,19 +274,18 @@ unsigned long ramfs_nommu_get_unmapped_a
 	page++;
 	for (loop = lpages; loop > 1; loop--)
 		if (*ptr++ != page++)
-			goto out;
+			goto out_free_pages;
 
 	/* okay - all conditions fulfilled */
 	ret = (unsigned long) page_address(pages[0]);
 
- out:
-	if (pages) {
-		ptr = pages;
-		for (loop = lpages; loop > 0; loop--)
-			put_page(*ptr++);
-		kfree(pages);
-	}
