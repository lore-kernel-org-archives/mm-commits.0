From: akpm@linux-foundation.org
Subject: + ocfs2-use-little-endian-bitops.patch added to -mm tree
Date: Mon, 24 Jan 2011 14:06:28 -0800
Message-ID: <201101242206.p0OM6S1H013386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081Ab1AXWGf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 17:06:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, joel.becker@oracle.com, mfasheh@suse.com


The patch titled
     ocfs2: use little-endian bitops
has been added to the -mm tree.  Its filename is
     ocfs2-use-little-endian-bitops.patch

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
Subject: ocfs2: use little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Joel Becker <joel.becker@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/ocfs2.h~ocfs2-use-little-endian-bitops fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-use-little-endian-bitops
+++ a/fs/ocfs2/ocfs2.h
@@ -831,18 +831,18 @@ static inline unsigned int ocfs2_cluster
 
 static inline void _ocfs2_set_bit(unsigned int bit, unsigned long *bitmap)
 {
-	ext2_set_bit(bit, bitmap);
+	__test_and_set_bit_le(bit, bitmap);
 }
 #define ocfs2_set_bit(bit, addr) _ocfs2_set_bit((bit), (unsigned long *)(addr))
 
 static inline void _ocfs2_clear_bit(unsigned int bit, unsigned long *bitmap)
 {
-	ext2_clear_bit(bit, bitmap);
+	__test_and_clear_bit_le(bit, bitmap);
 }
 #define ocfs2_clear_bit(bit, addr) _ocfs2_clear_bit((bit), (unsigned long *)(addr))
 
-#define ocfs2_test_bit ext2_test_bit
-#define ocfs2_find_next_zero_bit ext2_find_next_zero_bit
-#define ocfs2_find_next_bit ext2_find_next_bit
+#define ocfs2_test_bit test_bit_le
+#define ocfs2_find_next_zero_bit find_next_zero_bit_le
+#define ocfs2_find_next_bit find_next_bit_le
 #endif  /* OCFS2_H */
 
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

