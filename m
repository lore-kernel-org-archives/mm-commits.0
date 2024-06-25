Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7407013B2A5
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291602; cv=none; b=D0i9i8nFUxrNW2JOwBjIzo3TAGfaqDnQJ8eBbzMGIyORm60KCvavf+0BV+YITIQ/FysCMq5MB11M9/vhHfy3JYPrmj9u3k8NkPCT0WkbeKrBxXLy9nlyzhwc1B0T8joCOgzoase2XpfRBYXWyoQgpXm9EanjLiPkGmTDqI8VIXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291602; c=relaxed/simple;
	bh=/lGWWdT8O2uLCtTyy4RQBD3gP/fw4j7Akh46m7fZg/w=;
	h=Date:To:From:Subject:Message-Id; b=Rupb7HA1TQW1ehx0Uo0vbBFRQxXywEZUsVCVRnVAqzw/BC4Aa6PZ7E0kilBeQc59SDgO1TVzRAx7OIehZf4noAoKZmG45+ng9p6xsAup3n4ZUXXKYXurfoLrYvMjNbesKozRGfEYPcFPss6q8ZqQfjGmgKoBKK8Vljcse0NG5Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UAM+n0v6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UAM+n0v6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B8BC32789;
	Tue, 25 Jun 2024 05:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291602;
	bh=/lGWWdT8O2uLCtTyy4RQBD3gP/fw4j7Akh46m7fZg/w=;
	h=Date:To:From:Subject:From;
	b=UAM+n0v6wfeU2VdAyhrmtnEdREEo/5zCt/tCGRQcLmo71K7xyOjQ20VI6xgDEzFBs
	 a63dyovMVuKhJOtuC525Rml+XMArbpjiUGFmCNUhiyyubt0afVMDcWOvOLS0Z2dJzb
	 tUlQN6jh16a0KZuxxuVU+qkkkjOgFPnAl3SrEQMY=
Date: Mon, 24 Jun 2024 22:00:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-use-sg_set_folio-in-zswap_compress-decompress.patch removed from -mm tree
Message-Id: <20240625050002.46B8BC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: use sg_set_folio() in zswap_{compress/decompress}()
has been removed from the -mm tree.  Its filename was
     mm-zswap-use-sg_set_folio-in-zswap_compress-decompress.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
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


