From: akpm@linux-foundation.org
Subject: [merged] dm-crypt-fix-a-bug-of-async-cryption-complete-function.patch removed from -mm tree
Date: Fri, 06 Mar 2009 11:28:30 -0800
Message-ID: <200903061928.n26JSUMd022773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbZCFTbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 14:31:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, agk@redhat.com, herbert@gondor.apana.org.au, mbroz@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm-crypt: fix a bug in async cryption complete function
has been removed from the -mm tree.  Its filename was
     dm-crypt-fix-a-bug-of-async-cryption-complete-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dm-crypt: fix a bug in async cryption complete function
From: Huang Ying <ying.huang@intel.com>

In async cryption complete function (kcryptd_async_done), the
crypto_async_request passed in may be different from the one passed to
crypto_ablkcipher_encrypt/decrypt.  Only crypto_async_request->data is
guaranteed to be same as the passed in one.  Current kcryptd_async_done
uses passed in crypto_async_request directly, which may cause AES-NI based
AES algorithm implementation panic.

This patch fixes this bug by using crypto_async_request->data only, which
point to dm_crypt_request, the crypto_async_request passed in and original
data (convert_context) can be gotten from dm_crypt_request.

[mbroz@redhat.com: reworked]
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff -puN drivers/md/dm-crypt.c~dm-crypt-fix-a-bug-of-async-cryption-complete-function drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-crypt-fix-a-bug-of-async-cryption-complete-function
+++ a/drivers/md/dm-crypt.c
@@ -60,6 +60,7 @@ struct dm_crypt_io {
 };
 
 struct dm_crypt_request {
+	struct convert_context *ctx;
 	struct scatterlist sg_in;
 	struct scatterlist sg_out;
 };
@@ -335,6 +336,18 @@ static void crypt_convert_init(struct cr
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
@@ -345,10 +358,11 @@ static int crypt_convert_block(struct cr
 	u8 *iv;
 	int r = 0;
 
-	dmreq = (struct dm_crypt_request *)((char *)req + cc->dmreq_start);
+	dmreq = dmreq_of_req(cc, req);
 	iv = (u8 *)ALIGN((unsigned long)(dmreq + 1),
 			 crypto_ablkcipher_alignmask(cc->tfm) + 1);
 
+	dmreq->ctx = ctx;
 	sg_init_table(&dmreq->sg_in, 1);
 	sg_set_page(&dmreq->sg_in, bv_in->bv_page, 1 << SECTOR_SHIFT,
 		    bv_in->bv_offset + ctx->offset_in);
@@ -395,8 +409,9 @@ static void crypt_alloc_req(struct crypt
 		cc->req = mempool_alloc(cc->req_pool, GFP_NOIO);
 	ablkcipher_request_set_tfm(cc->req, cc->tfm);
 	ablkcipher_request_set_callback(cc->req, CRYPTO_TFM_REQ_MAY_BACKLOG |
-					     CRYPTO_TFM_REQ_MAY_SLEEP,
-					     kcryptd_async_done, ctx);
+					CRYPTO_TFM_REQ_MAY_SLEEP,
+					kcryptd_async_done,
+					dmreq_of_req(cc, cc->req));
 }
 
 /*
@@ -821,7 +836,8 @@ static void kcryptd_crypt_read_convert(s
 static void kcryptd_async_done(struct crypto_async_request *async_req,
 			       int error)
 {
-	struct convert_context *ctx = async_req->data;
+	struct dm_crypt_request *dmreq = async_req->data;
+	struct convert_context *ctx = dmreq->ctx;
 	struct dm_crypt_io *io = container_of(ctx, struct dm_crypt_io, ctx);
 	struct crypt_config *cc = io->target->private;
 
@@ -830,7 +846,7 @@ static void kcryptd_async_done(struct cr
 		return;
 	}
 
-	mempool_free(ablkcipher_request_cast(async_req), cc->req_pool);
+	mempool_free(req_of_dmreq(cc, dmreq), cc->req_pool);
 
 	if (!atomic_dec_and_test(&ctx->pending))
 		return;
_

Patches currently in -mm which might be from ying.huang@intel.com are

linux-next.patch

