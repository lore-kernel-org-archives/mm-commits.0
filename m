Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAFC39ADB
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 20:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716582571; cv=none; b=dTUw5+09YKK0Ye5iznGbbZ3tN2q/wQADjHbGwmO5ylzdGfpEs6b4GfLwNKxYzWHFZRQJvZgoGNoeEpuOkBN8YUJH7rXBobdDUMpsJNm2DqShZoRWM4XubT9APxCXTcq6C/12Fs9g407/pFpXr4tw3w3t22JK1m4NdYEn3+ha1LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716582571; c=relaxed/simple;
	bh=yhuJC3CedW22FArnj1jC1V8vfvKKOGG+V2yos2g4RiU=;
	h=Date:To:From:Subject:Message-Id; b=KrdZp/xEmI9EDN4wah2huGUEgWy85e9U4XluRpBEZDE8I61p7N17Y9PAjNDkv8BmC8Gqhkgf2FzueRDdDLDKMoI3axTso7J/e68JfzsAm74hkz5UHcYGIMz54KSmf3nD5WkjsHnaEt/E9qUxieElXxn/JwWCwpMx9PFwrVXCQ7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VjTNAPFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VjTNAPFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DCAC2BBFC;
	Fri, 24 May 2024 20:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716582570;
	bh=yhuJC3CedW22FArnj1jC1V8vfvKKOGG+V2yos2g4RiU=;
	h=Date:To:From:Subject:From;
	b=VjTNAPFRA23saY+6+5yQMhof8o8bUMnuFSm6K3MQBanIw/XivpDVJz9y4h+SoGBU3
	 LVIxWG/9L+2CP9UT9Xbo2oXrJW3vJZeYt12GIFH+IF2S0VEfHWzjPwkoVHz7G4qM9X
	 EzZFi97LBxghpwUbN7jSocEvMHE1Os64cJu1+01c=
Date: Fri, 24 May 2024 13:29:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-use-sg_set_folio-in-zswap_compress-decompress.patch added to mm-unstable branch
Message-Id: <20240524202930.66DCAC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: use sg_set_folio() in zswap_{compress/decompress}()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-use-sg_set_folio-in-zswap_compress-decompress.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-use-sg_set_folio-in-zswap_compress-decompress.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: use sg_set_folio() in zswap_{compress/decompress}()
Date: Fri, 24 May 2024 03:38:16 +0000

Patch series "mm: zswap: trivial folio conversions".

Some trivial folio conversions in zswap code.


This patch (of 3):

sg_set_folio() is equivalent to sg_set_page() for order-0 folios, which
are the only ones supported by zswap. Now zswap_decompress() can take in
a folio directly.

Link: https://lkml.kernel.org/r/20240524033819.1953587-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20240524033819.1953587-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/zswap.c~mm-zswap-use-sg_set_folio-in-zswap_compress-decompress
+++ a/mm/zswap.c
@@ -917,7 +917,7 @@ static bool zswap_compress(struct folio
 
 	dst = acomp_ctx->buffer;
 	sg_init_table(&input, 1);
-	sg_set_page(&input, &folio->page, PAGE_SIZE, 0);
+	sg_set_folio(&input, folio, PAGE_SIZE, 0);
 
 	/*
 	 * We need PAGE_SIZE * 2 here since there maybe over-compression case,
@@ -971,7 +971,7 @@ unlock:
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
-static void zswap_decompress(struct zswap_entry *entry, struct page *page)
+static void zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 {
 	struct zpool *zpool = zswap_find_zpool(entry);
 	struct scatterlist input, output;
@@ -1000,7 +1000,7 @@ static void zswap_decompress(struct zswa
 
 	sg_init_one(&input, src, entry->length);
 	sg_init_table(&output, 1);
-	sg_set_page(&output, page, PAGE_SIZE, 0);
+	sg_set_folio(&output, folio, PAGE_SIZE, 0);
 	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
 	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
 	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
@@ -1073,7 +1073,7 @@ static int zswap_writeback_entry(struct
 		return -ENOMEM;
 	}
 
-	zswap_decompress(entry, &folio->page);
+	zswap_decompress(entry, folio);
 
 	count_vm_event(ZSWPWB);
 	if (entry->objcg)
@@ -1580,7 +1580,7 @@ bool zswap_load(struct folio *folio)
 		return false;
 
 	if (entry->length)
-		zswap_decompress(entry, page);
+		zswap_decompress(entry, folio);
 	else {
 		dst = kmap_local_page(page);
 		zswap_fill_page(dst, entry->value);
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-use-sg_set_folio-in-zswap_compress-decompress.patch
mm-zswap-use-kmap_local_folio-in-zswap_load.patch
mm-zswap-make-same_filled-functions-folio-friendly.patch

