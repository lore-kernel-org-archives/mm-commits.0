From: akpm@linux-foundation.org
Subject: [merged] ext4-use-little-endian-bitops.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:05 -0700
Message-ID: <201103250724.p2P7O0s2025785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768Ab1CYHYF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, adilger.kernel@dilger.ca, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext4: use little-endian bitops
has been removed from the -mm tree.  Its filename was
     ext4-use-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: use little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/ext4.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ext4/ext4.h~ext4-use-little-endian-bitops fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~ext4-use-little-endian-bitops
+++ a/fs/ext4/ext4.h
@@ -923,14 +923,14 @@ struct ext4_inode_info {
 #define test_opt2(sb, opt)		(EXT4_SB(sb)->s_mount_opt2 & \
 					 EXT4_MOUNT2_##opt)
 
-#define ext4_set_bit			ext2_set_bit
+#define ext4_set_bit			__test_and_set_bit_le
 #define ext4_set_bit_atomic		ext2_set_bit_atomic
-#define ext4_clear_bit			ext2_clear_bit
+#define ext4_clear_bit			__test_and_clear_bit_le
 #define ext4_clear_bit_atomic		ext2_clear_bit_atomic
-#define ext4_test_bit			ext2_test_bit
-#define ext4_find_first_zero_bit	ext2_find_first_zero_bit
-#define ext4_find_next_zero_bit		ext2_find_next_zero_bit
-#define ext4_find_next_bit		ext2_find_next_bit
+#define ext4_test_bit			test_bit_le
+#define ext4_find_first_zero_bit	find_first_zero_bit_le
+#define ext4_find_next_zero_bit		find_next_zero_bit_le
+#define ext4_find_next_bit		find_next_bit_le
 
 /*
  * Maximal mount counts between two filesystem checks
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

