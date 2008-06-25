From: akpm@linux-foundation.org
Subject: + splice-fix-generic_file_splice_read-race-with-page-invalidation.patch added to -mm tree
Date: Wed, 25 Jun 2008 14:37:42 -0700
Message-ID: <200806252137.m5PLbglV028063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbYFYViZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 17:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, jens.axboe@oracle.com


The patch titled
     splice: fix generic_file_splice_read() race with page invalidation
has been added to the -mm tree.  Its filename is
     splice-fix-generic_file_splice_read-race-with-page-invalidation.patch

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
Subject: splice: fix generic_file_splice_read() race with page invalidation
From: Miklos Szeredi <mszeredi@suse.cz>

If a page was invalidated during splicing from file to a pipe, then
generic_file_splice_read() could return a short or zero count.

This manifested itself in rare I/O errors seen on nfs exported fuse
filesystems.  This is because nfsd uses splice_direct_to_actor() to read
files, and fuse uses invalidate_inode_pages2() to invalidate stale data on
open.

Fix by redoing the page find/create if it was found to be truncated
(invalidated).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN fs/splice.c~splice-fix-generic_file_splice_read-race-with-page-invalidation fs/splice.c
--- a/fs/splice.c~splice-fix-generic_file_splice_read-race-with-page-invalidation
+++ a/fs/splice.c
@@ -379,13 +379,22 @@ __generic_file_splice_read(struct file *
 				lock_page(page);
 
 			/*
-			 * page was truncated, stop here. if this isn't the
-			 * first page, we'll just complete what we already
-			 * added
+			 * Page was truncated, or invalidated by the
+			 * filesystem.  Redo the find/create, but this time the
+			 * page is kept locked, so there's no chance of another
+			 * race with truncate/invalidate.
 			 */
 			if (!page->mapping) {
 				unlock_page(page);
-				break;
+				page = find_or_create_page(mapping, index,
+						mapping_gfp_mask(mapping));
+
+				if (!page) {
+					error = -ENOMEM;
+					break;
+				}
+				page_cache_release(pages[page_nr]);
+				pages[page_nr] = page;
 			}
 			/*
 			 * page was already under io and is now done, great
_

Patches currently in -mm which might be from mszeredi@suse.cz are

git-unprivileged-mounts.patch
splice-fix-generic_file_splice_read-race-with-page-invalidation.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

