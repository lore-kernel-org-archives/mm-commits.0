From: akpm@linux-foundation.org
Subject: + crypto-use-kzfree.patch added to -mm tree
Date: Thu, 19 Feb 2009 12:24:46 -0800
Message-ID: <200902192024.n1JKOk1V020683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756669AbZBSUZs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 15:25:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, herbert@gondor.apana.org.au, penberg@cs.helsinki.fi


The patch titled
     crypto: use kzfree()
has been added to the -mm tree.  Its filename is
     crypto-use-kzfree.patch

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
Subject: crypto: use kzfree()
From: Johannes Weiner <hannes@cmpxchg.org>

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/api.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN crypto/api.c~crypto-use-kzfree crypto/api.c
--- a/crypto/api.c~crypto-use-kzfree
+++ a/crypto/api.c
@@ -569,20 +569,17 @@ EXPORT_SYMBOL_GPL(crypto_alloc_tfm);
 void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
 {
 	struct crypto_alg *alg;
-	int size;
 
 	if (unlikely(!mem))
 		return;
 
 	alg = tfm->__crt_alg;
-	size = ksize(mem);
 
 	if (!tfm->exit && alg->cra_exit)
 		alg->cra_exit(tfm);
 	crypto_exit_ops(tfm);
 	crypto_mod_put(alg);
-	memset(mem, 0, size);
-	kfree(mem);
+	kzfree(mem);
 }
 EXPORT_SYMBOL_GPL(crypto_destroy_tfm);
 
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

