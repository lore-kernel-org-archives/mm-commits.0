From: akpm@linux-foundation.org
Subject: - befs-annotate-fs32-on-tests-for-superblock-endianness.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:18:25 -0700
Message-ID: <200810182318.m9INIPFj029279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbYJRXSb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:18:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, rathamahata@php4.ru, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     befs: annotate fs32 on tests for superblock endianness
has been removed from the -mm tree.  Its filename was
     befs-annotate-fs32-on-tests-for-superblock-endianness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: befs: annotate fs32 on tests for superblock endianness
From: Harvey Harrison <harvey.harrison@gmail.com>

Does compile-time byteswapping rather than runtime.

Noticed by sparse:
fs/befs/super.c:29:6: warning: cast to restricted __le32
fs/befs/super.c:29:6: warning: cast from restricted fs32
fs/befs/super.c:31:11: warning: cast to restricted __be32
fs/befs/super.c:31:11: warning: cast from restricted fs32
fs/befs/super.c:31:11: warning: cast to restricted __be32
fs/befs/super.c:31:11: warning: cast from restricted fs32
fs/befs/super.c:31:11: warning: cast to restricted __be32
fs/befs/super.c:31:11: warning: cast from restricted fs32
fs/befs/super.c:31:11: warning: cast to restricted __be32
fs/befs/super.c:31:11: warning: cast from restricted fs32
fs/befs/super.c:31:11: warning: cast to restricted __be32
fs/befs/super.c:31:11: warning: cast from restricted fs32
fs/befs/super.c:31:11: warning: cast to restricted __be32
fs/befs/super.c:31:11: warning: cast from restricted fs32
fs/befs/linuxvfs.c:811:7: warning: cast to restricted __le32
fs/befs/linuxvfs.c:811:7: warning: cast from restricted fs32
fs/befs/linuxvfs.c:812:7: warning: cast to restricted __be32
fs/befs/linuxvfs.c:812:7: warning: cast from restricted fs32
fs/befs/linuxvfs.c:812:7: warning: cast to restricted __be32
fs/befs/linuxvfs.c:812:7: warning: cast from restricted fs32
fs/befs/linuxvfs.c:812:7: warning: cast to restricted __be32
fs/befs/linuxvfs.c:812:7: warning: cast from restricted fs32
fs/befs/linuxvfs.c:812:7: warning: cast to restricted __be32
fs/befs/linuxvfs.c:812:7: warning: cast from restricted fs32
fs/befs/linuxvfs.c:812:7: warning: cast to restricted __be32
fs/befs/linuxvfs.c:812:7: warning: cast from restricted fs32
fs/befs/linuxvfs.c:812:7: warning: cast to restricted __be32
fs/befs/linuxvfs.c:812:7: warning: cast from restricted fs32

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "Sergey S. Kostyliov" <rathamahata@php4.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/befs_fs_types.h |    4 ++++
 fs/befs/linuxvfs.c      |    4 ++--
 fs/befs/super.c         |    6 +++---
 3 files changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/befs/befs_fs_types.h~befs-annotate-fs32-on-tests-for-superblock-endianness fs/befs/befs_fs_types.h
--- a/fs/befs/befs_fs_types.h~befs-annotate-fs32-on-tests-for-superblock-endianness
+++ a/fs/befs/befs_fs_types.h
@@ -55,8 +55,12 @@ enum super_flags {
 };
 
 #define BEFS_BYTEORDER_NATIVE 0x42494745
+#define BEFS_BYTEORDER_NATIVE_LE (__force fs32)cpu_to_le32(BEFS_BYTEORDER_NATIVE)
+#define BEFS_BYTEORDER_NATIVE_BE (__force fs32)cpu_to_be32(BEFS_BYTEORDER_NATIVE)
 
 #define BEFS_SUPER_MAGIC BEFS_SUPER_MAGIC1
+#define BEFS_SUPER_MAGIC1_LE (__force fs32)cpu_to_le32(BEFS_SUPER_MAGIC1)
+#define BEFS_SUPER_MAGIC1_BE (__force fs32)cpu_to_be32(BEFS_SUPER_MAGIC1)
 
 /*
  * Flags of inode
diff -puN fs/befs/linuxvfs.c~befs-annotate-fs32-on-tests-for-superblock-endianness fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~befs-annotate-fs32-on-tests-for-superblock-endianness
+++ a/fs/befs/linuxvfs.c
@@ -809,8 +809,8 @@ befs_fill_super(struct super_block *sb, 
 
 	/* account for offset of super block on x86 */
 	disk_sb = (befs_super_block *) bh->b_data;
-	if ((le32_to_cpu(disk_sb->magic1) == BEFS_SUPER_MAGIC1) ||
-	    (be32_to_cpu(disk_sb->magic1) == BEFS_SUPER_MAGIC1)) {
+	if ((disk_sb->magic1 == BEFS_SUPER_MAGIC1_LE) ||
+	    (disk_sb->magic1 == BEFS_SUPER_MAGIC1_BE)) {
 		befs_debug(sb, "Using PPC superblock location");
 	} else {
 		befs_debug(sb, "Using x86 superblock location");
diff -puN fs/befs/super.c~befs-annotate-fs32-on-tests-for-superblock-endianness fs/befs/super.c
--- a/fs/befs/super.c~befs-annotate-fs32-on-tests-for-superblock-endianness
+++ a/fs/befs/super.c
@@ -26,10 +26,10 @@ befs_load_sb(struct super_block *sb, bef
 	befs_sb_info *befs_sb = BEFS_SB(sb);
 
 	/* Check the byte order of the filesystem */
-	if (le32_to_cpu(disk_sb->fs_byte_order) == BEFS_BYTEORDER_NATIVE)
+	if (disk_sb->fs_byte_order == BEFS_BYTEORDER_NATIVE_LE)
 	    befs_sb->byte_order = BEFS_BYTESEX_LE;
-	else if (be32_to_cpu(disk_sb->fs_byte_order) == BEFS_BYTEORDER_NATIVE)
-	    befs_sb->byte_order = BEFS_BYTESEX_BE;	
+	else if (disk_sb->fs_byte_order == BEFS_BYTEORDER_NATIVE_BE)
+	    befs_sb->byte_order = BEFS_BYTESEX_BE;
 
 	befs_sb->magic1 = fs32_to_cpu(sb, disk_sb->magic1);
 	befs_sb->magic2 = fs32_to_cpu(sb, disk_sb->magic2);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
byteorder-provide-swabbh-generically-in-asm-byteorderh.patch
byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch

