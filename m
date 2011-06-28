From: akpm@linux-foundation.org
Subject: [merged] dm-use-use-proper-little-endian-bitops.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:43:03 -0700
Message-ID: <201106282042.p5SKgjeW003043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab1F1Umr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm: use use proper little-endian bitops
has been removed from the -mm tree.  Its filename was
     dm-use-use-proper-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dm: use use proper little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

Using __test_and_{set,clear}_bit_le() with ignoring its return value can
be replaced with __{set,clear}_bit_le().

This also removes unnecessary casts.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-log.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/md/dm-log.c~dm-use-use-proper-little-endian-bitops drivers/md/dm-log.c
--- a/drivers/md/dm-log.c~dm-use-use-proper-little-endian-bitops
+++ a/drivers/md/dm-log.c
@@ -251,20 +251,20 @@ struct log_c {
  */
 static inline int log_test_bit(uint32_t *bs, unsigned bit)
 {
-	return test_bit_le(bit, (unsigned long *) bs) ? 1 : 0;
+	return test_bit_le(bit, bs) ? 1 : 0;
 }
 
 static inline void log_set_bit(struct log_c *l,
 			       uint32_t *bs, unsigned bit)
 {
-	__test_and_set_bit_le(bit, (unsigned long *) bs);
+	__set_bit_le(bit, bs);
 	l->touched_cleaned = 1;
 }
 
 static inline void log_clear_bit(struct log_c *l,
 				 uint32_t *bs, unsigned bit)
 {
-	__test_and_clear_bit_le(bit, (unsigned long *) bs);
+	__clear_bit_le(bit, bs);
 	l->touched_dirtied = 1;
 }
 
@@ -739,8 +739,7 @@ static int core_get_resync_work(struct d
 		return 0;
 
 	do {
-		*region = find_next_zero_bit_le(
-					     (unsigned long *) lc->sync_bits,
+		*region = find_next_zero_bit_le(lc->sync_bits,
 					     lc->region_count,
 					     lc->sync_search);
 		lc->sync_search = *region + 1;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
md-use-proper-little-endian-bitops.patch
reiserfs-use-proper-little-endian-bitops.patch
reiserfs-use-hweight_long.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch

