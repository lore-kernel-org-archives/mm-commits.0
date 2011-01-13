From: akpm@linux-foundation.org
Subject: [to-be-updated] nilfs2-use-little-endian-bitops.patch removed from -mm tree
Date: Thu, 13 Jan 2011 11:44:12 -0800
Message-ID: <201101131946.p0DJkqW0028802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756875Ab1AMTq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 14:46:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: use little-endian bitops
has been removed from the -mm tree.  Its filename was
     nilfs2-use-little-endian-bitops.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: use little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/nilfs2/alloc.h~nilfs2-use-little-endian-bitops fs/nilfs2/alloc.h
--- a/fs/nilfs2/alloc.h~nilfs2-use-little-endian-bitops
+++ a/fs/nilfs2/alloc.h
@@ -74,7 +74,8 @@ int nilfs_palloc_freev(struct inode *, _
 
 #define nilfs_set_bit_atomic		ext2_set_bit_atomic
 #define nilfs_clear_bit_atomic		ext2_clear_bit_atomic
-#define nilfs_find_next_zero_bit	ext2_find_next_zero_bit
+#define nilfs_find_next_zero_bit(addr, size, off)	\
+	find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
 
 /*
  * persistent object allocator cache
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
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

