From: akpm@linux-foundation.org
Subject: + xfrm_algo-warning-fixes.patch added to -mm tree
Date: Tue, 22 May 2007 15:34:50 -0700
Message-ID: <200705222234.l4MMYoD6011274@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758049AbXEVWge (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 18:36:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herbert@gondor.apana.org.au


The patch titled
     xfrm_algo warning fixes
has been added to the -mm tree.  Its filename is
     xfrm_algo-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
xfrm_algo-warning-fixes.patch
git-wireless.patch
git-cryptodev.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
