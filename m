Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DF22D063A
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675079; cv=none; b=M/CxHUXWDlsqniDImhY3iKFy2wKCvzEr8xrFQUT8w4G+7OnW4ZH1Z5efNbotPA8rWvFqfCy6hhp0dft0wYI77gIiAy6CS4xRJuJXrjIkAwItQpa6qo2tp9ddu1y9eJrkrm+S81Lsi2zcgAQ+XrRBMJ5dtW66tQLmgvM5jUZ7z9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675079; c=relaxed/simple;
	bh=lhUkFjD2y14oTbkdkNil+8/0eAP42ycE8FSZsKfLRYQ=;
	h=Date:To:From:Subject:Message-Id; b=akYhg1bSfEG/0PERKANd99z7LkHKn2GhwYxwLNJWIaOklzDN9cUdl78hPxi0/XyDceVWedc5aXb4IcDpz4mCFn9aoPHy1HsUhZRpHixvXadQ7NKntM1PzbiUbCRwtZ9U25ZmeMfFcwb5YtFqsFeLFq+ZNwFRwppm148QMes7oBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vzxnzOXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vzxnzOXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915FDC4CEF1;
	Thu, 20 Nov 2025 21:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675078;
	bh=lhUkFjD2y14oTbkdkNil+8/0eAP42ycE8FSZsKfLRYQ=;
	h=Date:To:From:Subject:From;
	b=vzxnzOXddjwGV52eqT116GXvcH4Phw0D1ZpA2XPkeuD3MSWo4BBLNkCyLSEggSJRt
	 K00i34Qz+gRHlE4qbS1GO5b66J+bxxJik/3edy3agEYqNIMZGWCH294scXpaEffqr7
	 uYhsGqWK3gRKyXlYg4QqixGg1bM7kK2U3F3ELLr0=
Date: Thu, 20 Nov 2025 13:44:38 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-optimise-hugetlb_folio_init_tail_vmemmap.patch removed from -mm tree
Message-Id: <20251120214438.915FDC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: optimise hugetlb_folio_init_tail_vmemmap()
has been removed from the -mm tree.  Its filename was
     hugetlb-optimise-hugetlb_folio_init_tail_vmemmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: optimise hugetlb_folio_init_tail_vmemmap()
Date: Thu, 6 Nov 2025 20:14:48 +0000

Extract the zone number directly from the folio instead of using the
folio's zone number to look up the zone and asking the zone what its
number is.

Also we should use &folio->page instead of casting from folio to page

Link: https://lkml.kernel.org/r/20251106201452.2292631-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~hugetlb-optimise-hugetlb_folio_init_tail_vmemmap
+++ a/mm/hugetlb.c
@@ -3246,7 +3246,7 @@ static void __init hugetlb_folio_init_ta
 					unsigned long start_page_number,
 					unsigned long end_page_number)
 {
-	enum zone_type zone = zone_idx(folio_zone(folio));
+	enum zone_type zone = folio_zonenum(folio);
 	int nid = folio_nid(folio);
 	struct page *page = folio_page(folio, start_page_number);
 	unsigned long head_pfn = folio_pfn(folio);
@@ -3279,7 +3279,7 @@ static void __init hugetlb_folio_init_vm
 	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
 	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
-	prep_compound_head((struct page *)folio, huge_page_order(h));
+	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
 static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-tweak-__vma_enter_locked.patch

