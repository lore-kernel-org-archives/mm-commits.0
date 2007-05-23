From: akpm@linux-foundation.org
Subject: - xfrm_algo-warning-fixes.patch removed from -mm tree
Date: Wed, 23 May 2007 13:21:03 -0700
Message-ID: <200705232021.l4NKL21M031003@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757098AbXEWUWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 16:22:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     xfrm_algo warning fixes
has been removed from the -mm tree.  Its filename was
     xfrm_algo-warning-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xfrm_algo warning fixes
From: Herbert Xu <herbert@gondor.apana.org.au>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/xfrm/xfrm_algo.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN net/xfrm/xfrm_algo.c~xfrm_algo-warning-fixes net/xfrm/xfrm_algo.c
--- a/net/xfrm/xfrm_algo.c~xfrm_algo-warning-fixes
+++ a/net/xfrm/xfrm_algo.c
@@ -407,27 +407,27 @@ static struct xfrm_algo_desc *xfrm_find_
 static int xfrm_alg_id_match(const struct xfrm_algo_desc *entry,
 			     const void *data)
 {
-	return entry->desc.sadb_alg_id == (int)data;
+	return entry->desc.sadb_alg_id == (unsigned long)data;
 }
 
 struct xfrm_algo_desc *xfrm_aalg_get_byid(int alg_id)
 {
 	return xfrm_find_algo(&xfrm_aalg_list, xfrm_alg_id_match,
-			      (void *)alg_id, 1);
+			      (void *)(unsigned long)alg_id, 1);
 }
 EXPORT_SYMBOL_GPL(xfrm_aalg_get_byid);
 
 struct xfrm_algo_desc *xfrm_ealg_get_byid(int alg_id)
 {
 	return xfrm_find_algo(&xfrm_ealg_list, xfrm_alg_id_match,
-			      (void *)alg_id, 1);
+			      (void *)(unsigned long)alg_id, 1);
 }
 EXPORT_SYMBOL_GPL(xfrm_ealg_get_byid);
 
 struct xfrm_algo_desc *xfrm_calg_get_byid(int alg_id)
 {
 	return xfrm_find_algo(&xfrm_calg_list, xfrm_alg_id_match,
-			      (void *)alg_id, 1);
+			      (void *)(unsigned long)alg_id, 1);
 }
 EXPORT_SYMBOL_GPL(xfrm_calg_get_byid);
 
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
git-wireless.patch
git-cryptodev.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
