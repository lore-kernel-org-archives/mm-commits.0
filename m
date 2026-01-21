Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032F433B96A
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 18:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020032; cv=none; b=YH5wrENus7pal1SyztEUhXt/KF8ifJB6VwIvjjqpJj6fkzodfVu4gxJ41FQCtQp0NVXtgkbkAJTPt8r0QqIXFEb334bv/dF4uxlr+UFldI/POxYMZPoG003lEgAEBGjOxsuHV5rDg/eutfWX9plDa1WEXbxULQchHM1GNGXDDlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020032; c=relaxed/simple;
	bh=TUyWYv6RbrJu+Re3BXrDr16pqbWMQtLrIa/GLdLuD78=;
	h=Date:To:From:Subject:Message-Id; b=NcvHMYNOpna+EdZQqzU4DVpR8SC/Mt2LzhAGfLVFinsybW5MWknQFuYNo2tRGY2sKEFaI5qO+KxmrLe6GS76aK3IAs7ErZWokdake+uapMTL5a7ZoP2pyg/NJKJuzTnRSjdezcMUnhjszQUu4PRmeb1/ntDyuxVIm3ysuMyJ+nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oB0jUg4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oB0jUg4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC38C4CEF1;
	Wed, 21 Jan 2026 18:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769020031;
	bh=TUyWYv6RbrJu+Re3BXrDr16pqbWMQtLrIa/GLdLuD78=;
	h=Date:To:From:Subject:From;
	b=oB0jUg4fAAY5nBPkaRPojxQF4AfBLEz1yDWovYOAf61pr4zYqQMakXdMbd69nHXHy
	 9E9eq1oqv269PhJcYY7LfGXVg8BkCb9ewwuRnGmUl0J9tm6B585GyrdvDVBxwlX4g4
	 //RxgfyZciAytqIGBhaYnfoo3JUWWBOsfNhs4AU4=
Date: Wed, 21 Jan 2026 10:27:10 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch removed from -mm tree
Message-Id: <20260121182711.8EC38C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch

This patch was dropped because it was folded into mm-hugetlb-optimize-replace_free_hugepage_folios.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix
Date: Thu Jan 15 02:34:07 PM PST 2026

use single-return-point style, tweak comment

Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
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

 mm/hugetlb.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix
+++ a/mm/hugetlb.c
@@ -2834,10 +2834,15 @@ int replace_free_hugepage_folios(unsigne
 
 			nr = folio_nr_pages(folio) - folio_page_idx(folio, page);
 
-			/* Not to disrupt normal path by vainly holding hugetlb_lock */
+			/*
+			 * Don't disrupt normal path by vainly holding
+			 * hugetlb_lock
+			 */
 			if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
-				if (order_is_gigantic(folio_order(folio)))
-					return -ENOMEM;
+				if (order_is_gigantic(folio_order(folio))) {
+					ret = -ENOMEM;
+					break;
+				}
 
 				ret = alloc_and_dissolve_hugetlb_folio(folio, &list);
 				if (ret)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-hugetlb-optimize-replace_free_hugepage_folios.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch

