From: akpm@linux-foundation.org
Subject: + isofs-fix-access-to-unallocated-memory-when-reading-corrupted-filesystem.patch added to -mm tree
Date: Tue, 29 Apr 2008 17:13:03 -0700
Message-ID: <200804300013.m3U0D3AG017430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755741AbYD3ANH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 20:13:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     isofs: fix access to unallocated memory when reading corrupted filesystem
has been added to the -mm tree.  Its filename is
     isofs-fix-access-to-unallocated-memory-when-reading-corrupted-filesystem.patch

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
vfs-fix-lock-inversion-in-drop_pagecache_sb.patch
vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch
isofs-use-get-put_unaligned_-helpers.patch
ext4-fix-update-of-mtime-and-ctime-on-rename.patch
ext4-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
ext4-fix-mount-messages-when-quota-disabled.patch
quota-le_add_cpu-conversion.patch
isofs-fix-access-to-unallocated-memory-when-reading-corrupted-filesystem.patch

