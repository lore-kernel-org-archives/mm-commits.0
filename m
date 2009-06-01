From: akpm@linux-foundation.org
Subject: + crypto-use-formatting-of-module-name-in-crypto-api.patch added to -mm tree
Date: Mon, 01 Jun 2009 14:34:05 -0700
Message-ID: <200906012134.n51LY5Yh027375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbZFAVfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 17:35:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raa.lkml@gmail.com, herbert@gondor.apana.org.au


The patch titled
     crypto: use formatting of module name in crypto API
has been added to the -mm tree.  Its filename is
     crypto-use-formatting-of-module-name-in-crypto-api.patch

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
