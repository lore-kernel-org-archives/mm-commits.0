From: akpm@linux-foundation.org
Subject: [merged] sgi-gru-use-for_each_set_bit.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:04:43 -0400
Message-ID: <201003150705.o2F75Gqd017077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759706Ab0COHFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-gru: use for_each_set_bit()
has been removed from the -mm tree.  Its filename was
     sgi-gru-use-for_each_set_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-gru: use for_each_set_bit()
From: Akinobu Mita <akinobu.mita@gmail.com>

Replace open-coded loop with for_each_set_bit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grutables.h |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN drivers/misc/sgi-gru/grutables.h~sgi-gru-use-for_each_set_bit drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~sgi-gru-use-for_each_set_bit
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -516,8 +516,7 @@ struct gru_blade_state {
 
 /* Scan all active GRUs in a GRU bitmap */
 #define for_each_gru_in_bitmap(gid, map)				\
-	for ((gid) = find_first_bit((map), GRU_MAX_GRUS); (gid) < GRU_MAX_GRUS;\
-		(gid)++, (gid) = find_next_bit((map), GRU_MAX_GRUS, (gid)))
+	for_each_set_bit((gid), (map), GRU_MAX_GRUS)
 
 /* Scan all active GRUs on a specific blade */
 #define for_each_gru_on_blade(gru, nid, i)				\
@@ -536,23 +535,17 @@ struct gru_blade_state {
 
 /* Scan each CBR whose bit is set in a TFM (or copy of) */
 #define for_each_cbr_in_tfm(i, map)					\
-	for ((i) = find_first_bit(map, GRU_NUM_CBE);			\
-			(i) < GRU_NUM_CBE;				\
-			(i)++, (i) = find_next_bit(map, GRU_NUM_CBE, i))
+	for_each_set_bit((i), (map), GRU_NUM_CBE)
 
 /* Scan each CBR in a CBR bitmap. Note: multiple CBRs in an allocation unit */
 #define for_each_cbr_in_allocation_map(i, map, k)			\
-	for ((k) = find_first_bit(map, GRU_CBR_AU); (k) < GRU_CBR_AU;	\
-			(k) = find_next_bit(map, GRU_CBR_AU, (k) + 1)) 	\
+	for_each_set_bit((k), (map), GRU_CBR_AU)			\
 		for ((i) = (k)*GRU_CBR_AU_SIZE;				\
 				(i) < ((k) + 1) * GRU_CBR_AU_SIZE; (i)++)
 
 /* Scan each DSR in a DSR bitmap. Note: multiple DSRs in an allocation unit */
 #define for_each_dsr_in_allocation_map(i, map, k)			\
-	for ((k) = find_first_bit((const unsigned long *)map, GRU_DSR_AU);\
-			(k) < GRU_DSR_AU;				\
-			(k) = find_next_bit((const unsigned long *)map,	\
-					  GRU_DSR_AU, (k) + 1))		\
+	for_each_set_bit((k), (const unsigned long *)(map), GRU_DSR_AU)	\
 		for ((i) = (k) * GRU_DSR_AU_CL;				\
 				(i) < ((k) + 1) * GRU_DSR_AU_CL; (i)++)
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
ntfs-use-bitmap_weight.patch
hpet-use-for_each_set_bit.patch
intel-iommu-use-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
phonet-use-for_each_set_bit.patch
atm-use-for_each_set_bit.patch
bitops-remove-temporary-for_each_bit.patch

