From: akpm@linux-foundation.org
Subject: + dm-use-little-endian-bitops.patch added to -mm tree
Date: Mon, 24 Jan 2011 14:06:41 -0800
Message-ID: <201101242206.p0OM6feQ013414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081Ab1AXWGx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 17:06:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, agk@redhat.com


The patch titled
     dm: use little-endian bitops
has been added to the -mm tree.  Its filename is
     dm-use-little-endian-bitops.patch

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
Subject: dm: use little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-log.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/md/dm-log.c~dm-use-little-endian-bitops drivers/md/dm-log.c
--- a/drivers/md/dm-log.c~dm-use-little-endian-bitops
+++ a/drivers/md/dm-log.c
@@ -251,20 +251,20 @@ struct log_c {
  */
 static inline int log_test_bit(uint32_t *bs, unsigned bit)
 {
-	return ext2_test_bit(bit, (unsigned long *) bs) ? 1 : 0;
+	return test_bit_le(bit, (unsigned long *) bs) ? 1 : 0;
 }
 
 static inline void log_set_bit(struct log_c *l,
 			       uint32_t *bs, unsigned bit)
 {
-	ext2_set_bit(bit, (unsigned long *) bs);
+	__test_and_set_bit_le(bit, (unsigned long *) bs);
 	l->touched_cleaned = 1;
 }
 
 static inline void log_clear_bit(struct log_c *l,
 				 uint32_t *bs, unsigned bit)
 {
-	ext2_clear_bit(bit, (unsigned long *) bs);
+	__test_and_clear_bit_le(bit, (unsigned long *) bs);
 	l->touched_dirtied = 1;
 }
 
@@ -740,7 +740,7 @@ static int core_get_resync_work(struct d
 		return 0;
 
 	do {
-		*region = ext2_find_next_zero_bit(
+		*region = find_next_zero_bit_le(
 					     (unsigned long *) lc->sync_bits,
 					     lc->region_count,
 					     lc->sync_search);
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

