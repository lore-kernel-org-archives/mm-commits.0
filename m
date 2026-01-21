Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9630737416E
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 18:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020027; cv=none; b=jsCCmgcQZ9a3qTUY6WaR+0NtQ16d9ate+59vv4nGTOMqPLOePbMehBcLHY7gcg1Ch9U5FF3uTiDLyYe7sko+oaTCT3P2cusYogVvgzBBSqaeaqAOwsMTmv8dSt5sM4xhI1S2RR6H0wKj5jy6gP5JB/KZptwnvH7/ydLOqSJN1XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020027; c=relaxed/simple;
	bh=gdFt1DBbTvT0slG1/U+HwwcBp/eSZI7lcD1Y2kzBI5g=;
	h=Date:To:From:Subject:Message-Id; b=Jd/I3wwOGLtyjDWLxMy3Bqp7i7+fc9pvjw+tsWwQHqDS3doS3h/uTzzW31JCRtHtZWiBSE0dB1LQswHC1EGA7UaPpnpN0eERyhxFhJHEJTFMnBp872m+buDGf4c+DNSQI+emhzdaU32q+YP3omiqiJ5kw73FuX8xT1GnHQM5B1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bLBk1njj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bLBk1njj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386F9C4CEF1;
	Wed, 21 Jan 2026 18:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769020027;
	bh=gdFt1DBbTvT0slG1/U+HwwcBp/eSZI7lcD1Y2kzBI5g=;
	h=Date:To:From:Subject:From;
	b=bLBk1njjiYhxTGL2eVU5ylSOu1wGnvWm1+Muh/sC8oqbWQ3pNMdfUmuQbCM+jvpqQ
	 plTiaoYg/I7eV1+cBQWNR3Y2aCxo3MhUqprJa16mQuS4QV7+4y1FMBoaIoT/+2Nmfk
	 R1QsmM/WdgozIcLD12cAHgTj5+rozsuv7N5M/2oU=
Date: Wed, 21 Jan 2026 10:27:06 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-optimize-replace_free_hugepage_folios-v2.patch removed from -mm tree
Message-Id: <20260121182707.386F9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: optimize replace_free_hugepage_folios()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-optimize-replace_free_hugepage_folios-v2.patch

This patch was dropped because it was folded into mm-hugetlb-optimize-replace_free_hugepage_folios.patch

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb: optimize replace_free_hugepage_folios()
Date: Wed, 14 Jan 2026 21:55:12 +0800

Turn back to use alloc_and_dissolve_hugetlb_folio() since Oscar pointed
out that the return value is different.  Then adding gigantic folio check
independently, also update changelog.

Link: https://lkml.kernel.org/r/20260114135512.2159799-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-optimize-replace_free_hugepage_folios-v2
+++ a/mm/hugetlb.c
@@ -2810,6 +2810,7 @@ int replace_free_hugepage_folios(unsigne
 	struct page *page;
 	struct hstate *h;
 	LIST_HEAD(list);
+	int ret = 0;
 
 	/* Avoid pfn iterations if no free non-gigantic huge pages */
 	for_each_hstate(h) {
@@ -2835,9 +2836,13 @@ int replace_free_hugepage_folios(unsigne
 
 			/* Not to disrupt normal path by vainly holding hugetlb_lock */
 			if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
-				if (isolate_or_dissolve_huge_folio(folio, &list))
+				if (order_is_gigantic(folio_order(folio)))
 					return -ENOMEM;
 
+				ret = alloc_and_dissolve_hugetlb_folio(folio, &list);
+				if (ret)
+					break;
+
 				putback_movable_pages(&list);
 			}
 		} else if (PageBuddy(page)) {
@@ -2851,11 +2856,10 @@ int replace_free_hugepage_folios(unsigne
 			if (order <= MAX_PAGE_ORDER)
 				nr = 1UL << order;
 		}
-
 		start_pfn += nr;
 	}
 
-	return 0;
+	return ret;
 }
 
 void wait_for_freed_hugetlb_folios(void)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch
mm-page_alloc-add-__split_page.patch
mm-cma-kill-cma_pages_valid.patch
mm-page_alloc-add-alloc_contig_frozen_rangepages.patch
mm-cma-add-cma_alloc_frozen_compound.patch
mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation.patch
mm-page_isolation-introduce-page_is_unmovable.patch
mm-page_alloc-optimize-pfn_range_valid_contig.patch
mm-hugetlb-optimize-replace_free_hugepage_folios.patch
mm-hugetlb_cma-optimize-hugetlb_cma_alloc_frozen_folio.patch
mm-hugetlb_cma-mark-hugetlb_cma_only-as-__ro_after_init.patch

