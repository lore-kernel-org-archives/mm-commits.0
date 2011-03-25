From: akpm@linux-foundation.org
Subject: [merged] dm-use-little-endian-bitops.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:16 -0700
Message-ID: <201103250724.p2P7OA1e025824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933712Ab1CYHYV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm: use little-endian bitops
has been removed from the -mm tree.  Its filename was
     dm-use-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

