Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD65D320CA2
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 21:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769029715; cv=none; b=MVyXldpM4rVlvDfRpFgY/YSiBpv/Ik72443mtq5na67DFO6bGU8ZRT41SKGTH9FmbPzaMsQ3SDiZtDnJMyOKbcw6xrKqii/2rlCG4qsPPq6+cL96vZvc9NoiFcUNMezfQw6Lp1fehDcRh8X9/bzrwRs+Q44jebv4QSGK99DOPks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769029715; c=relaxed/simple;
	bh=1EU04UgA2H3o7X+Y/X+b454JltQM8LhWkAlR+EH1Wx0=;
	h=Date:To:From:Subject:Message-Id; b=oH0IMJKeLdBHTUXhBo4wBxabJ0vocVNqmK0qJGXyrpJGCdEAns+ElppqaW+42zuG1cELcLY48OEeiOo/oXC4wBtHyTm5fyzwOxysoQlcBGumUc5Ln9MhKXeZXtcJC5+RdTxsPQlqj8Wm4YhB0esdyJUEvOvcgKwtSCIDg4SP3BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W3jMq8Q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W3jMq8Q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AC3C4CEF1;
	Wed, 21 Jan 2026 21:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769029715;
	bh=1EU04UgA2H3o7X+Y/X+b454JltQM8LhWkAlR+EH1Wx0=;
	h=Date:To:From:Subject:From;
	b=W3jMq8Q+O14589c2ywK4hiAlSAoiBWVRSMi2AfCAmtWEhU7UsJrrO+8dvAETOMQob
	 5q2ekgq2p6d5YW3Ijn4Mbo72UdqUMIL3+jvKCAivaYhEaeHCajGFEp0Jl0NQF8M1xG
	 Tpj80Pj64Gu0MBatMzUHumRp7AVSt7QQyrdSYxp4=
Date: Wed, 21 Jan 2026 13:08:34 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,nphamcs@gmail.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-use-sg-list-decompression-apis-from-zsmalloc.patch added to mm-new branch
Message-Id: <20260121210835.34AC3C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: use SG list decompression APIs from zsmalloc
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-use-sg-list-decompression-apis-from-zsmalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-use-sg-list-decompression-apis-from-zsmalloc.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: mm: zswap: use SG list decompression APIs from zsmalloc
Date: Wed, 21 Jan 2026 01:36:15 +0000

Use the new zs_obj_read_sg_*() APIs in zswap_decompress(), instead of
zs_obj_read_*() APIs returning a linear address.  The SG list is passed
directly to the crypto API, simplifying the logic and dropping the
workaround that copies highmem addresses to a buffer.  The crypto API
should internally linearize the SG list if needed.

This avoids the memcpy() in zsmalloc for objects spanning multiple pages,
although an equivalent operation will be done internally by acomp/scomp. 
However, in the future compression algorithms could support handling
discontiguous SG lists, completely eliminating the copying for spanning
objects.

Zsmalloc fills an SG list up to 2 entries in size, so change the input SG
list to fit 2 entries.

Update the incompressible entries path to use memcpy_from_sglist() to copy
the data to the folio.  Opportunistically set dlen to PAGE_SIZE in the
same code path (rather that at the top of the function) to make it
clearer.

Drop the goto in zswap_compress() as the code now is not simple enough for
an if-else statement instead.  Rename 'decomp_ret' to 'ret' and reuse it
to keep the intermediate return value of crypto_acomp_decompress() to keep
line lengths manageable.

No functional change intended.

Link: https://lkml.kernel.org/r/20260121013615.2906368-1-yosry.ahmed@linux.dev
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   49 +++++++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

--- a/mm/zswap.c~mm-zswap-use-sg-list-decompression-apis-from-zsmalloc
+++ a/mm/zswap.c
@@ -26,6 +26,7 @@
 #include <linux/mempolicy.h>
 #include <linux/mempool.h>
 #include <crypto/acompress.h>
+#include <crypto/scatterwalk.h>
 #include <linux/zswap.h>
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
@@ -936,53 +937,41 @@ unlock:
 static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 {
 	struct zswap_pool *pool = entry->pool;
-	struct scatterlist input, output;
+	struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 entries */
+	struct scatterlist output;
 	struct crypto_acomp_ctx *acomp_ctx;
-	int decomp_ret = 0, dlen = PAGE_SIZE;
-	u8 *src, *obj;
+	int ret = 0, dlen;
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
-	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, entry->length,
-				acomp_ctx->buffer);
+	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
 	if (entry->length == PAGE_SIZE) {
-		memcpy_to_folio(folio, 0, obj, entry->length);
-		goto read_done;
-	}
-
-	/*
-	 * zs_obj_read_begin() might return a kmap address of highmem when
-	 * acomp_ctx->buffer is not used.  However, sg_init_one() does not
-	 * handle highmem addresses, so copy the object to acomp_ctx->buffer.
-	 */
-	if (virt_addr_valid(obj)) {
-		src = obj;
+		WARN_ON_ONCE(input->length != PAGE_SIZE);
+		memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, PAGE_SIZE);
+		dlen = PAGE_SIZE;
 	} else {
-		WARN_ON_ONCE(obj == acomp_ctx->buffer);
-		memcpy(acomp_ctx->buffer, obj, entry->length);
-		src = acomp_ctx->buffer;
+		sg_init_table(&output, 1);
+		sg_set_folio(&output, folio, PAGE_SIZE, 0);
+		acomp_request_set_params(acomp_ctx->req, input, &output,
+					 entry->length, PAGE_SIZE);
+		ret = crypto_acomp_decompress(acomp_ctx->req);
+		ret = crypto_wait_req(ret, &acomp_ctx->wait);
+		dlen = acomp_ctx->req->dlen;
 	}
 
-	sg_init_one(&input, src, entry->length);
-	sg_init_table(&output, 1);
-	sg_set_folio(&output, folio, PAGE_SIZE, 0);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
-	decomp_ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
-
-read_done:
-	zs_obj_read_end(pool->zs_pool, entry->handle, entry->length, obj);
+	zs_obj_read_sg_end(pool->zs_pool, entry->handle);
 	acomp_ctx_put_unlock(acomp_ctx);
 
-	if (!decomp_ret && dlen == PAGE_SIZE)
+	if (!ret && dlen == PAGE_SIZE)
 		return true;
 
 	zswap_decompress_fail++;
 	pr_alert_ratelimited("Decompression error from zswap (%d:%lu %s %u->%d)\n",
 						swp_type(entry->swpentry),
 						swp_offset(entry->swpentry),
-						entry->pool->tfm_name, entry->length, dlen);
+						entry->pool->tfm_name,
+						entry->length, dlen);
 	return false;
 }
 
_

Patches currently in -mm which might be from yosry.ahmed@linux.dev are

zsmalloc-simplify-read-begin-end-logic.patch
mm-zswap-use-sg-list-decompression-apis-from-zsmalloc.patch

