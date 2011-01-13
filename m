From: akpm@linux-foundation.org
Subject: [to-be-updated] ext3-use-little-endian-bitops.patch removed from -mm tree
Date: Thu, 13 Jan 2011 11:44:06 -0800
Message-ID: <201101131946.p0DJkkvJ028788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756875Ab1AMTq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 14:46:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, adilger.kernel@dilger.ca, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ext3: use little-endian bitops
has been removed from the -mm tree.  Its filename was
     ext3-use-little-endian-bitops.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: use little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ext3_fs.h |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN include/linux/ext3_fs.h~ext3-use-little-endian-bitops include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~ext3-use-little-endian-bitops
+++ a/include/linux/ext3_fs.h
@@ -418,13 +418,18 @@ struct ext3_inode {
 #define EXT2_MOUNT_DATA_FLAGS		EXT3_MOUNT_DATA_FLAGS
 #endif
 
-#define ext3_set_bit			ext2_set_bit
+#define ext3_set_bit(nr, addr)	\
+	__test_and_set_le_bit((nr), (unsigned long *)(addr))
 #define ext3_set_bit_atomic		ext2_set_bit_atomic
-#define ext3_clear_bit			ext2_clear_bit
+#define ext3_clear_bit(nr, addr)	\
+	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
 #define ext3_clear_bit_atomic		ext2_clear_bit_atomic
-#define ext3_test_bit			ext2_test_bit
-#define ext3_find_first_zero_bit	ext2_find_first_zero_bit
-#define ext3_find_next_zero_bit		ext2_find_next_zero_bit
+#define ext3_test_bit(nr, addr)	\
+	test_le_bit((nr), (unsigned long *)(addr))
+#define ext3_find_first_zero_bit(addr, size)	\
+	find_first_zero_le_bit((unsigned long *)(addr), (size))
+#define ext3_find_next_zero_bit(addr, size, off)	\
+	find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
 
 /*
  * Maximal mount counts between two filesystem checks
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
ext4-use-little-endian-bitops.patch
ocfs2-use-little-endian-bitops.patch
nilfs2-use-little-endian-bitops.patch
reiserfs-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
ufs-use-little-endian-bitops.patch
md-use-little-endian-bit-operations.patch
dm-use-little-endian-bit-operations.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch
m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch
bitops-use-find_first_zero_bit-instead-of-find_next_zero_bitaddr-size-0.patch
spufs-use-simple_write_to_buffer.patch

