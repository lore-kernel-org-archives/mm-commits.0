From: akpm@linux-foundation.org
Subject: + sgi-gru-use-for_each_set_bit.patch added to -mm tree
Date: Mon, 01 Feb 2010 14:27:02 -0800
Message-ID: <201002012227.o11MR2L0016344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753834Ab0BAW1g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 17:27:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, steiner@sgi.com


The patch titled
     sgi-gru: use for_each_set_bit()
has been added to the -mm tree.  Its filename is
     sgi-gru-use-for_each_set_bit.patch

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

linux-next.patch
fault-injection-correct-function-names-in-documentation.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitmap-use-for_each_set_bit.patch
hpet-use-for_each_set_bit.patch
intel-iommu-use-for_each_set_bit.patch
infiniband-use-for_each_set_bit.patch
ntfs-use-bitmap_weight.patch
phonet-use-for_each_set_bit.patch
atm-use-for_each_set_bit.patch
sched-use-for_each_set_bit.patch
sgi-gru-use-for_each_set_bit.patch

