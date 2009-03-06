From: akpm@linux-foundation.org
Subject: [merged] md-use-kzfree.patch removed from -mm tree
Date: Fri, 06 Mar 2009 11:28:25 -0800
Message-ID: <200903061928.n26JSP1r022760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755468AbZCFT3L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 14:29:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, dm-devel@redhat.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     md: use kzfree()
has been removed from the -mm tree.  Its filename was
     md-use-kzfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: use kzfree()
From: Johannes Weiner <hannes@cmpxchg.org>

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Alasdair Kergon <dm-devel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/md/dm-crypt.c~md-use-kzfree drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~md-use-kzfree
+++ a/drivers/md/dm-crypt.c
@@ -1137,8 +1137,7 @@ bad_ivmode:
 	crypto_free_ablkcipher(tfm);
 bad_cipher:
 	/* Must zero key material before freeing */
-	memset(cc, 0, sizeof(*cc) + cc->key_size * sizeof(u8));
-	kfree(cc);
+	kzfree(cc);
 	return -EINVAL;
 }
 
@@ -1164,8 +1163,7 @@ static void crypt_dtr(struct dm_target *
 	dm_put_device(ti, cc->dev);
 
 	/* Must zero key material before freeing */
-	memset(cc, 0, sizeof(*cc) + cc->key_size * sizeof(u8));
-	kfree(cc);
+	kzfree(cc);
 }
 
 static int crypt_map(struct dm_target *ti, struct bio *bio,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
cifs-use-kzfree.patch
s390-use-kzfree.patch
usb-use-kzfree.patch
crypto-use-kzfree.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
mm-move-pagevec-stripping-to-save-unlock-relock.patch
mm-dont-free-swap-slots-on-page-deactivation.patch
mm-remove-pagevec_swap_free.patch
ecryptfs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

