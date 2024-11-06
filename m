Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9B3149E00
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854747; cv=none; b=UqdRFMSgDnhXGzlSdwq7/Llgq8PvJfxSjzhcUsGwufCLcuyVJy3zsJlW3mPSFI0n0BGGAq0luZiG9n1LZYyIJgmm6rblSJ1LAflziPtLnKeLvR4z3uBpkFGqE+5cooE+MOgw+/XUwikFm+aDm+cxHn/Xb2S/pzB8a8rdcGEvYzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854747; c=relaxed/simple;
	bh=vmHtl+M4twSkIkaMl1M62TSZvNLxIzTdIzg8u8lXPP8=;
	h=Date:To:From:Subject:Message-Id; b=u2Nu2KnbtcKFRufnOHkkmrw5ZbPeEdioOCnTP0Dek9nbEwv+ZUDwAYYrFIEn6KbxXmidBboYIoOXR2u64bJ/gi1HUwzMCa9aDdOlfKAD4OOibVB8fuoMNntv3lzqgWvLU0Lc77z7vS9DbFs94QPJa6fjuVk8oe/lZXzk6VOEdSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OdZBBRes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OdZBBRes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82621C4CECF;
	Wed,  6 Nov 2024 00:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854747;
	bh=vmHtl+M4twSkIkaMl1M62TSZvNLxIzTdIzg8u8lXPP8=;
	h=Date:To:From:Subject:From;
	b=OdZBBResrWPIKetksw3auBidCF8LfL3P2sutlQ4CPWJVvxkm7gpQ0Zav1s+RI7QXM
	 0d1TlNIPQvbRCYda6n1bxBYCQb6cihyOSbDgmDTy/a8ushTnO5eYzxk3MZZ9AtiZAi
	 uGCIaUVqQbmLRECAWa9vkc6WHjPJoCOKY/dtdbqQ=
Date: Tue, 05 Nov 2024 16:59:07 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,wajdi.k.feghali@intel.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,nanhai.zou@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,21cnbao@gmail.com,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio.patch removed from -mm tree
Message-Id: <20241106005907.82621C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: modify zswap_compress() to accept a page instead of a folio
has been removed from the -mm tree.  Its filename was
     mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: mm: zswap: modify zswap_compress() to accept a page instead of a folio
Date: Mon, 30 Sep 2024 22:32:17 -0700

For zswap_store() to be able to store a large folio by compressing it one
page at a time, zswap_compress() needs to accept a page as input.  This
will allow us to iterate through each page in the folio in zswap_store(),
compress it and store it in the zpool.

Link: https://lkml.kernel.org/r/20241001053222.6944-3-kanchana.p.sridhar@intel.com
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>
Cc: "Zou, Nanhai" <nanhai.zou@intel.com>
Cc: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/zswap.c~mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio
+++ a/mm/zswap.c
@@ -875,7 +875,7 @@ static int zswap_cpu_comp_dead(unsigned
 	return 0;
 }
 
-static bool zswap_compress(struct folio *folio, struct zswap_entry *entry)
+static bool zswap_compress(struct page *page, struct zswap_entry *entry)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
@@ -893,7 +893,7 @@ static bool zswap_compress(struct folio
 
 	dst = acomp_ctx->buffer;
 	sg_init_table(&input, 1);
-	sg_set_folio(&input, folio, PAGE_SIZE, 0);
+	sg_set_page(&input, page, PAGE_SIZE, 0);
 
 	/*
 	 * We need PAGE_SIZE * 2 here since there maybe over-compression case,
@@ -1457,7 +1457,7 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	if (!zswap_compress(folio, entry))
+	if (!zswap_compress(&folio->page, entry))
 		goto put_pool;
 
 	entry->swpentry = swp;
_

Patches currently in -mm which might be from kanchana.p.sridhar@intel.com are


