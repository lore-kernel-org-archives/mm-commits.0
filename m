From: akpm@linux-foundation.org
Subject: - lvm-use-rounddown_pow_of_two-macro-for-simplicity.patch removed from -mm tree
Date: Fri, 09 Nov 2007 11:12:44 -0800
Message-ID: <200711091912.lA9JCiKx027947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54207 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754603AbXKITND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:13:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     LVM: Use rounddown_pow_of_two() macro for simplicity.
has been removed from the -mm tree.  Its filename was
     lvm-use-rounddown_pow_of_two-macro-for-simplicity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: LVM: Use rounddown_pow_of_two() macro for simplicity.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-snap.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/md/dm-snap.c~lvm-use-rounddown_pow_of_two-macro-for-simplicity drivers/md/dm-snap.c
--- a/drivers/md/dm-snap.c~lvm-use-rounddown_pow_of_two-macro-for-simplicity
+++ a/drivers/md/dm-snap.c
@@ -334,16 +334,6 @@ static int calc_max_buckets(void)
 }
 
 /*
- * Rounds a number down to a power of 2.
- */
-static uint32_t round_down(uint32_t n)
-{
-	while (n & (n - 1))
-		n &= (n - 1);
-	return n;
-}
-
-/*
  * Allocate room for a suitable hash table.
  */
 static int init_hash_tables(struct dm_snapshot *s)
@@ -361,8 +351,7 @@ static int init_hash_tables(struct dm_sn
 	hash_size = min(origin_dev_size, cow_dev_size) >> s->chunk_shift;
 	hash_size = min(hash_size, max_buckets);
 
-	/* Round it down to a power of 2 */
-	hash_size = round_down(hash_size);
+	hash_size = rounddown_pow_of_two(hash_size);
 	if (init_exception_table(&s->complete, hash_size))
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

arm-remove-reference-to-non-existent-mtd_obsolete_chips.patch
hwmon-replace-power-of-two-test-in-drivers-hwmon-adt7470c.patch
git-mips.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
blackfin-typo-config_rtc_bfin_module.patch
git-sparc64.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
m68knommu-remove-vestiges-of-non-existent-disktel.patch
uml-delete-some-unused-headers.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
