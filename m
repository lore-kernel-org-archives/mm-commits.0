From: akpm@linux-foundation.org
Subject: - mm-fix-infinite-loop-in-filemap_fault.patch removed from -mm tree
Date: Fri, 16 May 2008 15:52:45 -0700
Message-ID: <200805162252.m4GMqjUt003087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756223AbYEPWwx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:52:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: fix infinite loop in filemap_fault
has been removed from the -mm tree.  Its filename was
     mm-fix-infinite-loop-in-filemap_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-vfs-cleanups.patch
git-unprivileged-mounts.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

