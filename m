Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD3E2D0C89
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334170; cv=none; b=lTYG5GddWrTWDEOAghDQNuIyeBLKQ3psiKHPCK7RVYC6QRUfoFDw9+/swotZJX+FAMOSZML9h0R863r2sFCpGpUNRnsM38VNvrp9Rcjvb/JtkLyqmzh7p2O1AYUKM5cXRCXgjm8RtwY/AuJLn2IR25Pdu+lDWiRV+bZCmfua5fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334170; c=relaxed/simple;
	bh=JW2AVZ7ZKzFsJNhdGisau9oZMA942rXSt1fTTCr+iF8=;
	h=Date:To:From:Subject:Message-Id; b=DuD7mehl2Drh+BfAZMg9u9TcgRwWMR9yLRvN2EW44gWWl3p5MMuXNMcwtY6xITx6sjTd7Uv8iiP+6v7FRuCEXnEZnVaC3Sky3Li0tVUIuqTdYAwAStbGY6LkTO8Wsniu9AXeAtXYp8k6ELkiTijaEkLPn4jnXqJLtoTLMUEuDDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XPM2XMtT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XPM2XMtT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB94E1F0089D;
	Wed,  7 Oct 2026 00:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334168;
	bh=awsHwyNG/GZtUpLTjpFFl5glWxh7hhifgyyZ8tBw7M8=;
	h=Date:To:From:Subject;
	b=XPM2XMtTtR1VbX2q8Jp64w17ilBmqPE9WRJGuuITx7/ITzlw1O2f2qQV26FeaGMob
	 b7YSTlAeR+259ihHCFMhW8mNBn2v8IlYPEWqV10ShDzENsSUUogfXHbDDbYjxztq14
	 RAu9E+arRmvuvGXTUu3fj646CN3jRridljKAqlXo=
Date: Tue, 06 Oct 2026 17:49:27 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-remove-huge_bootmem_hvo.patch removed from -mm tree
Message-Id: <20261007004927.EB94E1F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: remove HUGE_BOOTMEM_HVO
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-huge_bootmem_hvo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb: remove HUGE_BOOTMEM_HVO
Date: Thu, 10 Sep 2026 14:32:53 +0800

The HUGE_BOOTMEM_HVO flag tracked whether a bootmem huge page had already
gone through the old early vmemmap optimization path.

Now that HugeTLB uses section-based vmemmap optimization, that state is
already reflected in the compound page order stored in section metadata.

Remove HUGE_BOOTMEM_HVO and its helper, and use the section state directly
when deciding whether to mark a folio as vmemmap-optimized.

Link: https://lore.kernel.org/20260910063256.64386-15-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 include/linux/hugetlb.h |    5 ++---
 mm/hugetlb.c            |   16 +++-------------
 mm/hugetlb_vmemmap.c    |    2 --
 3 files changed, 5 insertions(+), 18 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-remove-huge_bootmem_hvo
+++ a/include/linux/hugetlb.h
@@ -675,9 +675,8 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-#define HUGE_BOOTMEM_HVO		0x0001
-#define HUGE_BOOTMEM_ZONES_VALID	0x0002
-#define HUGE_BOOTMEM_CMA		0x0004
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+#define HUGE_BOOTMEM_CMA		BIT(1)
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
--- a/mm/hugetlb.c~mm-hugetlb-remove-huge_bootmem_hvo
+++ a/mm/hugetlb.c
@@ -3209,11 +3209,6 @@ static void __init hugetlb_folio_init_vm
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
-static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
-{
-	return m->flags & HUGE_BOOTMEM_HVO;
-}
-
 static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
 {
 	return m->flags & HUGE_BOOTMEM_CMA;
@@ -3288,6 +3283,7 @@ static void __init gather_bootmem_preall
 	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
+		const unsigned long pfn = folio_pfn(folio);
 
 		h = m->hstate;
 		/*
@@ -3305,15 +3301,9 @@ static void __init gather_bootmem_preall
 					   HUGETLB_VMEMMAP_RESERVE_PAGES);
 		init_new_hugetlb_folio(folio);
 
-		if (hugetlb_bootmem_page_prehvo(m))
-			/*
-			 * If pre-HVO was done, just set the
-			 * flag, the HVO code will then skip
-			 * this folio.
-			 */
+		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
 			folio_set_hugetlb_vmemmap_optimized(folio);
-		section_set_compound_order_range(folio_pfn(folio),
-						 folio_nr_pages(folio), 0);
+		section_set_compound_order_range(pfn, folio_nr_pages(folio), 0);
 
 		if (hugetlb_bootmem_page_earlycma(m))
 			folio_set_hugetlb_cma(folio);
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-remove-huge_bootmem_hvo
+++ a/mm/hugetlb_vmemmap.c
@@ -715,8 +715,6 @@ void __init hugetlb_vmemmap_optimize_boo
 
 	section_set_compound_order_range(pfn, pages_per_huge_page(h),
 					 huge_page_order(h));
-	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-		m->flags |= HUGE_BOOTMEM_HVO;
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


