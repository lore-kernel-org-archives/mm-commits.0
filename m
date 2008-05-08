From: akpm@linux-foundation.org
Subject: + mm-fix-infinite-loop-in-filemap_fault.patch added to -mm tree
Date: Thu, 08 May 2008 12:47:49 -0700
Message-ID: <200805081947.m48Jlnsx002550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547AbYEHTsZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 15:48:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, npiggin@suse.de


The patch titled
     mm: fix infinite loop in filemap_fault
has been added to the -mm tree.  Its filename is
     mm-fix-infinite-loop-in-filemap_fault.patch

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
Subject: mm: fix infinite loop in filemap_fault
From: Miklos Szeredi <mszeredi@suse.cz>

filemap_fault will go into an infinite loop if ->readpage() fails
asynchronously.

AFAICS the bug was introduced by this commit, which removed the wait after the
final readpage:

   commit d00806b183152af6d24f46f0c33f14162ca1262a
   Author: Nick Piggin <npiggin@suse.de>
   Date:   Thu Jul 19 01:46:57 2007 -0700

       mm: fix fault vs invalidate race for linear mappings

Fix by reintroducing the wait_on_page_locked() after ->readpage() to make sure
the page is up-to-date before jumping back to the beginning of the function.

I've noticed this while testing nfs exporting on fuse.  The patch
fixes it.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/filemap.c~mm-fix-infinite-loop-in-filemap_fault mm/filemap.c
--- a/mm/filemap.c~mm-fix-infinite-loop-in-filemap_fault
+++ a/mm/filemap.c
@@ -1461,6 +1461,11 @@ page_not_uptodate:
 	 */
 	ClearPageError(page);
 	error = mapping->a_ops->readpage(file, page);
+	if (!error) {
+		wait_on_page_locked(page);
+		if (!PageUptodate(page))
+			error = -EIO;
+	}
 	page_cache_release(page);
 
 	if (!error || error == AOP_TRUNCATED_PAGE)
_

Patches currently in -mm which might be from mszeredi@suse.cz are

ecryptfs-clean-up-unlock_parent.patch
git-block.patch
git-vfs-cleanups.patch
mm-fix-infinite-loop-in-filemap_fault.patch

