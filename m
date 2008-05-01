From: akpm@linux-foundation.org
Subject: - isofs-fix-access-to-unallocated-memory-when-reading-corrupted-filesystem.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:43 -0700
Message-ID: <200805010925.m419Ph8E030233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755416AbYEAJ0S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:26:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     isofs: fix access to unallocated memory when reading corrupted filesystem
has been removed from the -mm tree.  Its filename was
     isofs-fix-access-to-unallocated-memory-when-reading-corrupted-filesystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isofs: fix access to unallocated memory when reading corrupted filesystem
From: Jan Kara <jack@suse.cz>

When a directory on isofs is corrupted, we did not check whether length of the
name in a directory entry and the length of the directory entry itself are
consistent.  This could lead to possible access beyond the end of buffer when
the length of the name was too big.  Add this sanity check to directory
reading code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/dir.c   |    8 ++++++++
 fs/isofs/namei.c |    7 +++++++
 2 files changed, 15 insertions(+)

diff -puN fs/isofs/dir.c~isofs-fix-access-to-unallocated-memory-when-reading-corrupted-filesystem fs/isofs/dir.c
--- a/fs/isofs/dir.c~isofs-fix-access-to-unallocated-memory-when-reading-corrupted-filesystem
+++ a/fs/isofs/dir.c
@@ -145,6 +145,14 @@ static int do_isofs_readdir(struct inode
 			}
 			de = tmpde;
 		}
+		/* Basic sanity check, whether name doesn't exceed dir entry */
+		if (de_len < de->name_len[0] +
+					sizeof(struct iso_directory_record)) {
+			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
+			       " in block %lu of inode %lu\n", block,
+			       inode->i_ino);
+			return -EIO;
+		}
 
 		if (first_de) {
 			isofs_normalize_block_and_offset(de,
diff -puN fs/isofs/namei.c~isofs-fix-access-to-unallocated-memory-when-reading-corrupted-filesystem fs/isofs/namei.c
--- a/fs/isofs/namei.c~isofs-fix-access-to-unallocated-memory-when-reading-corrupted-filesystem
+++ a/fs/isofs/namei.c
@@ -111,6 +111,13 @@ isofs_find_entry(struct inode *dir, stru
 
 		dlen = de->name_len[0];
 		dpnt = de->name;
+		/* Basic sanity check, whether name doesn't exceed dir entry */
+		if (de_len < dlen + sizeof(struct iso_directory_record)) {
+			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
+			       " in block %lu of inode %lu\n", block,
+			       dir->i_ino);
+			return 0;
+		}
 
 		if (sbi->s_rock &&
 		    ((i = get_rock_ridge_filename(de, tmpname, dir)))) {
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
git-udf.patch
quota-add-a-convenience-macro-for-filesystems.patch
ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
reiserfs-fix-synchronization-of-quota-files-in-journal=data-mode.patch
reiserfs-fix-typos-in-messages-and-comments-journalled-journaled.patch
reiserfs-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
ext4-fix-mount-messages-when-quota-disabled.patch
ext4-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext4-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext4-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch

