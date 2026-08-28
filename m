Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291FB3B531D
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 04:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787890910; cv=none; b=LRp51fn34MLok6GuJTyfRa0PBEbdIZJ8aT8i4SDJEHnMtoUx7o6qmK59N5EgiSlbxAG+/mhBdNCeofjwM2ia4JoYbSXWZt+ky8HAyQyyKXkyQrDv02T3v3W4fPdDdj8qzZ/apWKQ1cA6wjnOJOTlZFbYk7I8IPrzGxucnquqLco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787890910; c=relaxed/simple;
	bh=ek/R/1zWN63/Q0q0hYmde2u7FYil/u4Q40yYqyEzV9o=;
	h=Date:To:From:Subject:Message-Id; b=nZNlB4RR09KICas8MElvMpwGm9IsePM1Xgnt2AJ1q9e/Cd6wEDb+8svEvyUGAtdRgzEWsI61+647hCD9X0BKidy9UjFkRuW/nX7Bn7pil2b4nAtixzy8dwMla7rXCChFKeNinUl+E63IWpuudtZUe0HEE3Wawk1cSr8QmFs479Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vAGsGVa4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vAGsGVa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29521F000E9;
	Fri, 28 Aug 2026 04:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787890908;
	bh=2C0V0TtU8cvaW/meauct9cxrWZuG9hPbTzhLiZwRCck=;
	h=Date:To:From:Subject;
	b=vAGsGVa4MAs9DQ7VLFkHFLH0IXN13Ytoi2W6/HhTfApNth0NJUe2v9xPyESGD5j8V
	 6dUU5dbPSXdhU+728IL6px2JNx4RdKZ2yPFUlYPNdPeuGVuYHx+AKSrRXDDuJxtWqJ
	 vu1LcJtgIXQ0Tys2lI8qgMD2+bih15zYwbFt6Juc=
Date: Thu, 27 Aug 2026 21:21:48 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-huge_bootmem_hvo.patch added to mm-new branch
Message-Id: <20260828042148.B29521F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: remove HUGE_BOOTMEM_HVO
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-remove-huge_bootmem_hvo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-huge_bootmem_hvo.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb: remove HUGE_BOOTMEM_HVO
Date: Tue, 25 Aug 2026 16:46:05 +0800

The HUGE_BOOTMEM_HVO flag tracked whether a bootmem huge page had already
gone through the old early vmemmap optimization path.

Now that HugeTLB uses section-based vmemmap optimization, that state is
already reflected in the section order.

Remove HUGE_BOOTMEM_HVO and its helper, and use the section state directly
when deciding whether to mark a folio as vmemmap-optimized.

Link: https://lore.kernel.org/20260825084608.47437-15-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 ++---
 mm/hugetlb.c            |   12 +-----------
 mm/hugetlb_vmemmap.c    |    2 --
 3 files changed, 3 insertions(+), 16 deletions(-)

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
@@ -3200,11 +3200,6 @@ static void __init hugetlb_folio_init_vm
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
@@ -3296,12 +3291,7 @@ static void __init gather_bootmem_preall
 					   HUGETLB_VMEMMAP_RESERVE_PAGES);
 		init_new_hugetlb_folio(folio);
 
-		if (hugetlb_bootmem_page_prehvo(m))
-			/*
-			 * If pre-HVO was done, just set the
-			 * flag, the HVO code will then skip
-			 * this folio.
-			 */
+		if (vmemmap_optimizable_order(pfn_to_section_order(folio_pfn(folio))))
 			folio_set_hugetlb_vmemmap_optimized(folio);
 		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-remove-huge_bootmem_hvo
+++ a/mm/hugetlb_vmemmap.c
@@ -714,8 +714,6 @@ void __init hugetlb_vmemmap_optimize_boo
 		return;
 
 	section_set_order_range(pfn, pages_per_huge_page(h), huge_page_order(h));
-	if (vmemmap_optimizable_order(pfn_to_section_order(pfn)))
-		m->flags |= HUGE_BOOTMEM_HVO;
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-relax-struct-mem_section-size-constraints.patch
mm-sparse-vmemmap-rename-hvo-order-macros.patch
mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch
mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch
mm-sparse-vmemmap-support-section-based-vmemmap-accounting.patch
mm-mm_init-factor-out-pfn_to_zone.patch
mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch
mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch
mm-sparse-initialize-memory-sections-earlier.patch
mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization.patch
mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support.patch
mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch
mm-sparse-remove-section_map_size.patch
mm-hugetlb-remove-huge_bootmem_hvo.patch
mm-hugetlb-remove-huge_bootmem_cma.patch
mm-hugetlb-localize-struct-huge_bootmem_page.patch
mm-hugetlb-localize-huge_bootmem_zones_valid.patch

