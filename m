From: akpm@linux-foundation.org
Subject: [to-be-updated] asm-generic-use-little-endian-bitops.patch removed from -mm tree
Date: Thu, 13 Jan 2011 11:44:04 -0800
Message-ID: <201101131946.p0DJkiPb028784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756799Ab1AMTqt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 14:46:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     asm-generic: use little-endian bitops
has been removed from the -mm tree.  Its filename was
     asm-generic-use-little-endian-bitops.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic: use little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/ext2-atomic.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/bitops/ext2-atomic.h~asm-generic-use-little-endian-bitops include/asm-generic/bitops/ext2-atomic.h
--- a/include/asm-generic/bitops/ext2-atomic.h~asm-generic-use-little-endian-bitops
+++ a/include/asm-generic/bitops/ext2-atomic.h
@@ -5,7 +5,7 @@
 	({						\
 		int ret;				\
 		spin_lock(lock);			\
-		ret = ext2_set_bit((nr), (unsigned long *)(addr)); \
+		ret = __test_and_set_le_bit((nr), (unsigned long *)(addr)); \
 		spin_unlock(lock);			\
 		ret;					\
 	})
@@ -14,7 +14,7 @@
 	({						\
 		int ret;				\
 		spin_lock(lock);			\
-		ret = ext2_clear_bit((nr), (unsigned long *)(addr)); \
+		ret = __test_and_clear_le_bit((nr), (unsigned long *)(addr)); \
 		spin_unlock(lock);			\
 		ret;					\
 	})
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
ext3-use-little-endian-bitops.patch
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

