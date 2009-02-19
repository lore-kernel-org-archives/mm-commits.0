From: akpm@linux-foundation.org
Subject: + s390-use-kzfree.patch added to -mm tree
Date: Thu, 19 Feb 2009 12:24:48 -0800
Message-ID: <200902192024.n1JKOmk2020687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736AbZBSUZT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 15:25:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, heiko.carstens@de.ibm.com, penberg@cs.helsinki.fi, schwidefsky@de.ibm.com


The patch titled
     s390: use kzfree()
has been added to the -mm tree.  Its filename is
     s390-use-kzfree.patch

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

slab-introduce-kzfree.patch
linux-next.patch
crypto-use-kzfree.patch
s390-use-kzfree.patch
md-use-kzfree.patch
usb-use-kzfree.patch
cifs-use-kzfree.patch
ecryptfs-use-kzfree.patch
swsusp-clean-up-shrink_all_zones.patch
swsusp-dont-fiddle-with-swappiness.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

