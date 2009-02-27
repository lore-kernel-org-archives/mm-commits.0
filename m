From: akpm@linux-foundation.org
Subject: + dm-crypt-fix-a-bug-of-async-cryption-complete-function.patch added to -mm tree
Date: Fri, 27 Feb 2009 12:04:08 -0800
Message-ID: <200902272004.n1RK4857029540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755595AbZB0UG4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Feb 2009 15:06:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, agk@redhat.com, herbert@gondor.apana.org.au, mbroz@redhat.com


The patch titled
     dm-crypt: fix a bug in async cryption complete function
has been added to the -mm tree.  Its filename is
     dm-crypt-fix-a-bug-of-async-cryption-complete-function.patch

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

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN drivers/md/dm-crypt.c~dm-crypt-fix-a-bug-of-async-cryption-complete-function drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-crypt-fix-a-bug-of-async-cryption-complete-function
+++ a/drivers/md/dm-crypt.c
@@ -60,6 +60,8 @@ struct dm_crypt_io {
 };
 
 struct dm_crypt_request {
+	struct ablkcipher_request *req;
+	struct convert_context *ctx;
 	struct scatterlist sg_in;
 	struct scatterlist sg_out;
 };
@@ -349,6 +351,8 @@ static int crypt_convert_block(struct cr
 	iv = (u8 *)ALIGN((unsigned long)(dmreq + 1),
 			 crypto_ablkcipher_alignmask(cc->tfm) + 1);
 
+	dmreq->req = req;
+	dmreq->ctx = ctx;
 	sg_init_table(&dmreq->sg_in, 1);
 	sg_set_page(&dmreq->sg_in, bv_in->bv_page, 1 << SECTOR_SHIFT,
 		    bv_in->bv_offset + ctx->offset_in);
@@ -391,12 +395,15 @@ static void kcryptd_async_done(struct cr
 static void crypt_alloc_req(struct crypt_config *cc,
 			    struct convert_context *ctx)
 {
+	struct dm_crypt_request *dmreq;
+
 	if (!cc->req)
 		cc->req = mempool_alloc(cc->req_pool, GFP_NOIO);
 	ablkcipher_request_set_tfm(cc->req, cc->tfm);
+	dmreq = (struct dm_crypt_request *)((char *)cc->req + cc->dmreq_start);
 	ablkcipher_request_set_callback(cc->req, CRYPTO_TFM_REQ_MAY_BACKLOG |
 					     CRYPTO_TFM_REQ_MAY_SLEEP,
-					     kcryptd_async_done, ctx);
+					     kcryptd_async_done, dmreq);
 }
 
 /*
@@ -821,7 +828,8 @@ static void kcryptd_crypt_read_convert(s
 static void kcryptd_async_done(struct crypto_async_request *async_req,
 			       int error)
 {
-	struct convert_context *ctx = async_req->data;
+	struct dm_crypt_request *dmreq = async_req->data;
+	struct convert_context *ctx = dmreq->ctx;
 	struct dm_crypt_io *io = container_of(ctx, struct dm_crypt_io, ctx);
 	struct crypt_config *cc = io->target->private;
 
@@ -830,7 +838,7 @@ static void kcryptd_async_done(struct cr
 		return;
 	}
 
-	mempool_free(ablkcipher_request_cast(async_req), cc->req_pool);
+	mempool_free(dmreq->req, cc->req_pool);
 
 	if (!atomic_dec_and_test(&ctx->pending))
 		return;
_

Patches currently in -mm which might be from ying.huang@intel.com are

linux-next.patch
dm-crypt-fix-a-bug-of-async-cryption-complete-function.patch

