From: akpm@linux-foundation.org
Subject: [merged] ext3-use-little-endian-bitops.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:03 -0700
Message-ID: <201103250723.p2P7Nv1D025782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933600Ab1CYHYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, adilger.kernel@dilger.ca, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ext3: use little-endian bitops
has been removed from the -mm tree.  Its filename was
     ext3-use-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 include/linux/ext3_fs.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/ext3_fs.h~ext3-use-little-endian-bitops include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~ext3-use-little-endian-bitops
+++ a/include/linux/ext3_fs.h
@@ -418,13 +418,13 @@ struct ext3_inode {
 #define EXT2_MOUNT_DATA_FLAGS		EXT3_MOUNT_DATA_FLAGS
 #endif
 
-#define ext3_set_bit			ext2_set_bit
+#define ext3_set_bit			__test_and_set_bit_le
 #define ext3_set_bit_atomic		ext2_set_bit_atomic
-#define ext3_clear_bit			ext2_clear_bit
+#define ext3_clear_bit			__test_and_clear_bit_le
 #define ext3_clear_bit_atomic		ext2_clear_bit_atomic
-#define ext3_test_bit			ext2_test_bit
-#define ext3_find_first_zero_bit	ext2_find_first_zero_bit
-#define ext3_find_next_zero_bit		ext2_find_next_zero_bit
+#define ext3_test_bit			test_bit_le
+#define ext3_find_first_zero_bit	find_first_zero_bit_le
+#define ext3_find_next_zero_bit		find_next_zero_bit_le
 
 /*
  * Maximal mount counts between two filesystem checks
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

