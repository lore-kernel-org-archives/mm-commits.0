From: akpm@linux-foundation.org
Subject: [folded] dm-crypt-fix-a-bug-of-async-cryption-complete-function-update.patch removed from -mm tree
Date: Wed, 04 Mar 2009 12:08:03 -0800
Message-ID: <200903042008.n24K83ai029532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756153AbZCDUJm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 15:09:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mbroz@redhat.com, agk@redhat.com, herbert@gondor.apana.org.au, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     dm-crypt-fix-a-bug-of-async-cryption-complete-function-update
has been removed from the -mm tree.  Its filename was
     dm-crypt-fix-a-bug-of-async-cryption-complete-function-update.patch

This patch was dropped because it was folded into dm-crypt-fix-a-bug-of-async-cryption-complete-function.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dm-crypt-fix-a-bug-of-async-cryption-complete-function-update
From: Milan Broz <mbroz@redhat.com>

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Milan Broz <mbroz@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff -puN drivers/md/dm-crypt.c~dm-crypt-fix-a-bug-of-async-cryption-complete-function-update drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-crypt-fix-a-bug-of-async-cryption-complete-function-update
+++ a/drivers/md/dm-crypt.c
@@ -60,7 +60,6 @@ struct dm_crypt_io {
 };
 
 struct dm_crypt_request {
-	struct ablkcipher_request *req;
 	struct convert_context *ctx;
 	struct scatterlist sg_in;
 	struct scatterlist sg_out;
@@ -337,6 +336,18 @@ static void crypt_convert_init(struct cr
 	init_completion(&ctx->restart);
 }
 
+static struct dm_crypt_request *dmreq_of_req(struct crypt_config *cc,
+					     struct ablkcipher_request *req)
+{
+	return (struct dm_crypt_request *)((char *)req + cc->dmreq_start);
+}
+
+static struct ablkcipher_request *req_of_dmreq(struct crypt_config *cc,
+					       struct dm_crypt_request *dmreq)
+{
+	return (struct ablkcipher_request *)((char *)dmreq - cc->dmreq_start);
+}
+
 static int crypt_convert_block(struct crypt_config *cc,
 			       struct convert_context *ctx,
 			       struct ablkcipher_request *req)
@@ -347,11 +358,10 @@ static int crypt_convert_block(struct cr
 	u8 *iv;
 	int r = 0;
 
-	dmreq = (struct dm_crypt_request *)((char *)req + cc->dmreq_start);
+	dmreq = dmreq_of_req(cc, req);
 	iv = (u8 *)ALIGN((unsigned long)(dmreq + 1),
 			 crypto_ablkcipher_alignmask(cc->tfm) + 1);
 
-	dmreq->req = req;
 	dmreq->ctx = ctx;
 	sg_init_table(&dmreq->sg_in, 1);
 	sg_set_page(&dmreq->sg_in, bv_in->bv_page, 1 << SECTOR_SHIFT,
@@ -395,15 +405,13 @@ static void kcryptd_async_done(struct cr
 static void crypt_alloc_req(struct crypt_config *cc,
 			    struct convert_context *ctx)
 {
-	struct dm_crypt_request *dmreq;
-
 	if (!cc->req)
 		cc->req = mempool_alloc(cc->req_pool, GFP_NOIO);
 	ablkcipher_request_set_tfm(cc->req, cc->tfm);
-	dmreq = (struct dm_crypt_request *)((char *)cc->req + cc->dmreq_start);
 	ablkcipher_request_set_callback(cc->req, CRYPTO_TFM_REQ_MAY_BACKLOG |
-					     CRYPTO_TFM_REQ_MAY_SLEEP,
-					     kcryptd_async_done, dmreq);
+					CRYPTO_TFM_REQ_MAY_SLEEP,
+					kcryptd_async_done,
+					dmreq_of_req(cc, cc->req));
 }
 
 /*
@@ -838,7 +846,7 @@ static void kcryptd_async_done(struct cr
 		return;
 	}
 
-	mempool_free(dmreq->req, cc->req_pool);
+	mempool_free(req_of_dmreq(cc, dmreq), cc->req_pool);
 
 	if (!atomic_dec_and_test(&ctx->pending))
 		return;
_

Patches currently in -mm which might be from mbroz@redhat.com are

linux-next.patch
dm-crypt-fix-a-bug-of-async-cryption-complete-function.patch
dm-crypt-fix-a-bug-of-async-cryption-complete-function-update.patch

