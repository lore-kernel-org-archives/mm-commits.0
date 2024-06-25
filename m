Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7854C143882
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291603; cv=none; b=qxeRhnJeFv2WDmuAf6Oc1bh69aX0Fe6JtDF0nNA0gUoUW9m5CS4tLQIF3iCMi3ni/7W25sa6Lp9IazU1UJAL/h3T4RComYNLK5Tn7YgYHnfAILA2/1TiZyBSeIYSkjlR+kQn5NWtZP93sCY7SKL/Sl2+qhkltO7qKsNc8Wfj8Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291603; c=relaxed/simple;
	bh=Eq+SpLujiwfglQrFyJTmU5Hkx7ZWtwu/OqvmuPTLUbM=;
	h=Date:To:From:Subject:Message-Id; b=W+8N+QdJJdBdzxDBAWFmwmfboVuE4aEWa/a1L7TWOxQTnvGTbtRAMjeIDnmsZC/9o5wPCsTI34Jo946QsVi5HGZRU7ToprZz51+X6+eU7PRVVkheOiyk5v/1EWmOk77JB0+aIr/NG3VE+Zd1TGPVQrvbAoJFpLd+WDeZphOVNrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KKET0/44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KKET0/44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E24CC32789;
	Tue, 25 Jun 2024 05:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291603;
	bh=Eq+SpLujiwfglQrFyJTmU5Hkx7ZWtwu/OqvmuPTLUbM=;
	h=Date:To:From:Subject:From;
	b=KKET0/44B+zTYIEDt8p71w4Od9rQd89KIhf0iB3qxpcXfH8qJ+7+rs1KIkG0MVask
	 eWM9N1bVAcBZ3xWGsGqADEPUT6MihXOZREPeUnWhJlUgiw4P8Iy2Bq5egY+bxowMPe
	 /8JVGareSyG9HMuqWPpGI5szT5f51fhBD7ipOhyE=
Date: Mon, 24 Jun 2024 22:00:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-use-kmap_local_folio-in-zswap_load.patch removed from -mm tree
Message-Id: <20240625050003.4E24CC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm :zswap: use kmap_local_folio() in zswap_load()
has been removed from the -mm tree.  Its filename was
     mm-zswap-use-kmap_local_folio-in-zswap_load.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm :zswap: use kmap_local_folio() in zswap_load()
Date: Fri, 24 May 2024 03:38:17 +0000

Eliminate the last explicit 'struct page' reference in mm/zswap.c.

Link: https://lkml.kernel.org/r/20240524033819.1953587-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-use-kmap_local_folio-in-zswap_load
+++ a/mm/zswap.c
@@ -1551,7 +1551,6 @@ bool zswap_load(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
 	pgoff_t offset = swp_offset(swp);
-	struct page *page = &folio->page;
 	bool swapcache = folio_test_swapcache(folio);
 	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
@@ -1582,7 +1581,7 @@ bool zswap_load(struct folio *folio)
 	if (entry->length)
 		zswap_decompress(entry, folio);
 	else {
-		dst = kmap_local_page(page);
+		dst = kmap_local_folio(folio, 0);
 		zswap_fill_page(dst, entry->value);
 		kunmap_local(dst);
 	}
_

Patches currently in -mm which might be from yosryahmed@google.com are


