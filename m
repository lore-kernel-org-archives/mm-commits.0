From: akpm@linux-foundation.org
Subject: + fix-up-ext2_fsh-for-userspace-after-reservations-backport.patch added to -mm tree
Date: Tue, 27 Nov 2007 12:55:16 -0800
Message-ID: <200711272055.lARKtGqO029962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41656 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759422AbXK0Uz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:55:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tp@fonz.de, sandeen@redhat.com


The patch titled
     fix up ext2_fs.h for userspace after reservations backport
has been added to the -mm tree.  Its filename is
     fix-up-ext2_fsh-for-userspace-after-reservations-backport.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix up ext2_fs.h for userspace after reservations backport
From: Tobias Poschwatta <tp@fonz.de>

In commit a686cd898bd999fd026a51e90fb0a3410d258ddb:

 "Val's cross-port of the ext3 reservations code into ext2."

include/linux/ext2_fs.h got a new function whose return value is only
defined if __KERNEL__ is defined. Putting #ifdef __KERNEL__ around the
function seems to help, patch below.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ext2.h          |    7 +++++++
 include/linux/ext2_fs.h |    7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/ext2_fs.h~fix-up-ext2_fsh-for-userspace-after-reservations-backport include/linux/ext2_fs.h
--- a/include/linux/ext2_fs.h~fix-up-ext2_fsh-for-userspace-after-reservations-backport
+++ a/include/linux/ext2_fs.h
@@ -563,11 +563,4 @@ enum {
 					 ~EXT2_DIR_ROUND)
 #define EXT2_MAX_REC_LEN		((1<<16)-1)
 
-static inline ext2_fsblk_t
-ext2_group_first_block_no(struct super_block *sb, unsigned long group_no)
-{
-	return group_no * (ext2_fsblk_t)EXT2_BLOCKS_PER_GROUP(sb) +
-		le32_to_cpu(EXT2_SB(sb)->s_es->s_first_data_block);
-}
-
 #endif	/* _LINUX_EXT2_FS_H */
diff -puN fs/ext2/ext2.h~fix-up-ext2_fsh-for-userspace-after-reservations-backport fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~fix-up-ext2_fsh-for-userspace-after-reservations-backport
+++ a/fs/ext2/ext2.h
@@ -178,3 +178,10 @@ extern const struct inode_operations ext
 /* symlink.c */
 extern const struct inode_operations ext2_fast_symlink_inode_operations;
 extern const struct inode_operations ext2_symlink_inode_operations;
+
+static inline ext2_fsblk_t
+ext2_group_first_block_no(struct super_block *sb, unsigned long group_no)
+{
+	return group_no * (ext2_fsblk_t)EXT2_BLOCKS_PER_GROUP(sb) +
+		le32_to_cpu(EXT2_SB(sb)->s_es->s_first_data_block);
+}
_

Patches currently in -mm which might be from tp@fonz.de are

fix-up-ext2_fsh-for-userspace-after-reservations-backport.patch
