From: akpm@linux-foundation.org
Subject: [merged] crypto-use-formatting-of-module-name-in-crypto-api.patch removed from -mm tree
Date: Wed, 03 Jun 2009 13:02:45 -0700
Message-ID: <200906032002.n53K2j69002027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755699AbZFCUDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raa.lkml@gmail.com, herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     crypto: use formatting of module name in crypto API
has been removed from the -mm tree.  Its filename was
     crypto-use-formatting-of-module-name-in-crypto-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crypto: use formatting of module name in crypto API
From: Alex Riesen <raa.lkml@gmail.com>

gcc-4.3.3 produced this warning:
  "format not a string literal and no format arguments"

Signed-off-by: Alex Riesen <raa.lkml@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/api.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN crypto/api.c~crypto-use-formatting-of-module-name-in-crypto-api crypto/api.c
--- a/crypto/api.c~crypto-use-formatting-of-module-name-in-crypto-api
+++ a/crypto/api.c
@@ -217,14 +217,11 @@ struct crypto_alg *crypto_larval_lookup(
 
 	alg = crypto_alg_lookup(name, type, mask);
 	if (!alg) {
-		char tmp[CRYPTO_MAX_ALG_NAME];
