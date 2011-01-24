From: akpm@linux-foundation.org
Subject: + ext3-use-little-endian-bitops.patch added to -mm tree
Date: Mon, 24 Jan 2011 14:06:24 -0800
Message-ID: <201101242206.p0OM6OOd013380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571Ab1AXWGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 17:06:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adilger.kernel@dilger.ca, jack@suse.cz


The patch titled
     ext3: use little-endian bitops
has been added to the -mm tree.  Its filename is
     ext3-use-little-endian-bitops.patch

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

smp-move-smp-setup-functions-to-kernel-smpc.patch
kvm-stop-including-asm-generic-bitops-leh-directly.patch
rds-stop-including-asm-generic-bitops-leh-directly.patch
bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
asm-generic-rename-generic-little-endian-bitops-functions.patch
asm-generic-change-little-endian-bitops-to-take-any-pointer-types.patch
powerpc-introduce-little-endian-bitops.patch
s390-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops.patch
bitops-introduce-config_generic_find_bit_le.patch
m68knommu-introduce-little-endian-bitops.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
asm-generic-use-little-endian-bitops.patch
kvm-use-little-endian-bitops.patch
rds-use-little-endian-bitops.patch
ext3-use-little-endian-bitops.patch
ext4-use-little-endian-bitops.patch
ocfs2-use-little-endian-bitops.patch
nilfs2-use-little-endian-bitops.patch
reiserfs-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
ufs-use-little-endian-bitops.patch
md-use-little-endian-bitops.patch
dm-use-little-endian-bitops.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch
m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch

