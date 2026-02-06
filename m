Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4200E3090E0
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421683; cv=none; b=r0ozEYpIQSBjqf5eWPbarh56bTDMUrLFhxvtuGPSBMYoBuuGsX9SskLsXnSzwNZdlYByK9HjXUbhDbhBtJSVlDyg8ewz3psCG84iicDk+CjLZjkblxDXCr4HQwMIUOpvX0imS5xiHqSVPYh4pu/MBrqv8zoEwpqNkang9wGZR+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421683; c=relaxed/simple;
	bh=RFtdS96PCsREgxMmbh/uX8YOadTb6ROcN0UEvCI9gps=;
	h=Date:To:From:Subject:Message-Id; b=O2Jmqa16XLt2otd+6SguZ3QwR5tqt/t5GWPkrpgif1M0LB+HytAbpHBpNPPNeZCApRdGh209y+5Q5hT2yIieey9JgWTJZRDXATbkAq2A7k+K0OHaOJ5AZi3WyjV5mp37P3pQhJ4Oh5TAd83gYsDUbDia2opN4s/bsPhgYzueKDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ibcNmprE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ibcNmprE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAA2C116C6;
	Fri,  6 Feb 2026 23:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421682;
	bh=RFtdS96PCsREgxMmbh/uX8YOadTb6ROcN0UEvCI9gps=;
	h=Date:To:From:Subject:From;
	b=ibcNmprEKVt6ktwKXuPeuznIp16WcJkRIWJrvyYLycRBlZs2Oy3NhUazzSAfr577g
	 0DTH5SV6ZaA6kpda/3TJfbNeyw/GJE0XBMrzStey6Rbla8SerMBP1DQAmpihe0gv2i
	 /N1UYoQRwkTXw1tFPYUmH2db9O9CM6ISAmmeW3zY=
Date: Fri, 06 Feb 2026 15:48:02 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,nphamcs@gmail.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-use-sg-list-decompression-apis-from-zsmalloc.patch removed from -mm tree
Message-Id: <20260206234802.ACAA2C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: use SG list decompression APIs from zsmalloc
has been removed from the -mm tree.  Its filename was
     mm-zswap-use-sg-list-decompression-apis-from-zsmalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
@@ -931,53 +932,41 @@ unlock:
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


