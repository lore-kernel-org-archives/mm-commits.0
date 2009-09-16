From: akpm@linux-foundation.org
Subject: + reiserfs-truncate-blocks-not-used-by-a-write-v2.patch added to -mm tree
Date: Wed, 16 Sep 2009 14:47:30 -0700
Message-ID: <200909162147.n8GLlUIX018776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760147AbZIPVr7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Sep 2009 17:47:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, jeffm@suse.com


The patch titled
     reiserfs: truncate blocks not used by a write
has been added to the -mm tree.  Its filename is
     reiserfs-truncate-blocks-not-used-by-a-write-v2.patch

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
Subject: reiserfs: truncate blocks not used by a write
From: Jan Kara <jack@suse.cz>

It can happen that write does not use all the blocks allocated in
write_begin either because of some filesystem error (like ENOSPC) or
because page with data to write has been removed from memory.  We truncate
these blocks so that we don't have dangling blocks beyond i_size.

Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/inode.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/reiserfs/inode.c~reiserfs-truncate-blocks-not-used-by-a-write-v2 fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiserfs-truncate-blocks-not-used-by-a-write-v2
+++ a/fs/reiserfs/inode.c
@@ -2611,6 +2611,8 @@ static int reiserfs_write_begin(struct f
 	if (ret) {
 		unlock_page(page);
 		page_cache_release(page);
+		/* Truncate allocated blocks */
+		reiserfs_truncate_file(inode, 0);
 	}
 	return ret;
 }
@@ -2708,9 +2710,7 @@ static int reiserfs_write_end(struct fil
 	 ** transaction tracking stuff when the size changes.  So, we have
 	 ** to do the i_size updates here.
 	 */
-	pos += copied;
-
-	if (pos > inode->i_size) {
+	if (pos + copied > inode->i_size) {
 		struct reiserfs_transaction_handle myth;
 		lock_depth = reiserfs_write_lock_once(inode->i_sb);
 		locked = true;
@@ -2728,7 +2728,7 @@ static int reiserfs_write_end(struct fil
 			goto journal_error;
 
 		reiserfs_update_inode_transaction(inode);
-		inode->i_size = pos;
+		inode->i_size = pos + copied;
 		/*
 		 * this will just nest into our transaction.  It's important
 		 * to use mark_inode_dirty so the inode gets pushed around on the
@@ -2758,6 +2758,10 @@ static int reiserfs_write_end(struct fil
 		reiserfs_write_unlock_once(inode->i_sb, lock_depth);
 	unlock_page(page);
 	page_cache_release(page);
+
+	if (pos + len > inode->i_size)
+		reiserfs_truncate_file(inode, 0);
+
 	return ret == 0 ? copied : ret;
 
       journal_error:
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode.patch
fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix.patch
linux-next.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention-fix.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
vm-document-that-setting-vfs_cache_pressure-to-0-isnt-a-good-idea.patch
reiserfs-truncate-blocks-not-used-by-a-write-v2.patch
reiser4-update-names-of-quota-methods.patch

