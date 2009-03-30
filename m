From: akpm@linux-foundation.org
Subject: [merged] s390-use-kzfree.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:06:24 -0700
Message-ID: <200903301906.n2UJ6OYe019057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755389AbZC3TeP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:34:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, heiko.carstens@de.ibm.com, penberg@cs.helsinki.fi, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: use kzfree()
has been removed from the -mm tree.  Its filename was
     s390-use-kzfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390: use kzfree()
From: Johannes Weiner <hannes@cmpxchg.org>

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/crypto/prng.c             |    3 +--
 drivers/s390/crypto/zcrypt_pcixcc.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/s390/crypto/prng.c~s390-use-kzfree arch/s390/crypto/prng.c
--- a/arch/s390/crypto/prng.c~s390-use-kzfree
+++ a/arch/s390/crypto/prng.c
@@ -201,8 +201,7 @@ out_free:
 static void __exit prng_exit(void)
 {
 	/* wipe me */
-	memset(p->buf, 0, prng_chunk_size);
-	kfree(p->buf);
+	kzfree(p->buf);
 	kfree(p);
 
 	misc_deregister(&prng_dev);
diff -puN drivers/s390/crypto/zcrypt_pcixcc.c~s390-use-kzfree drivers/s390/crypto/zcrypt_pcixcc.c
--- a/drivers/s390/crypto/zcrypt_pcixcc.c~s390-use-kzfree
+++ a/drivers/s390/crypto/zcrypt_pcixcc.c
@@ -781,8 +781,7 @@ static long zcrypt_pcixcc_send_cprb(stru
 		/* Signal pending. */
 		ap_cancel_message(zdev->ap_dev, &ap_msg);
 out_free:
-	memset(ap_msg.message, 0x0, ap_msg.length);
-	kfree(ap_msg.message);
+	kzfree(ap_msg.message);
 	return rc;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
cifs-use-kzfree.patch
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
nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits.patch
nommu-make-config_unevictable_lru-available-when-config_mmu=n.patch
ecryptfs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

