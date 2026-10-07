Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B50259C80
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334175; cv=none; b=T0H9Urz+QNeJZpC+mGYL2rBS20il5b1wzkYidITKLzciA0G2HC3EBKCvLTZ/eheTr9FuprNo6jVAxfQ1GSCZlEKXtjBXXQD1WaufrA+HsEE/96hjOL6lshHJgniJSqnrL8IkLRNT4UtRj0GVlNPrDpjekNV+gbcgcIDo6hdYnkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334175; c=relaxed/simple;
	bh=icQHq+eoOfTw8/x5z8lrIovZHpemcO8eesy2C5PGaK4=;
	h=Date:To:From:Subject:Message-Id; b=kPyPoG5EA5mQXlU0vQB5S026OclTutDyarTEhiFSvf06XQ/+nHTnHCY8lp+xNaStqr+Z/UxMSb9SLlIR5br4qDJJc7HTviPOwFV0aZXeMmeEFW2FhqdGYQhkrdQt55JNFCgQnWoz7yuth0cEPXEeDPIM7pT5sQDnCwjwitsiXko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sa5uDkUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sa5uDkUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AE61F0089B;
	Wed,  7 Oct 2026 00:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334173;
	bh=PADuZxQT24t0kBW8tvmgucByRsPAkJKT4LRv/KZm7D0=;
	h=Date:To:From:Subject;
	b=sa5uDkUA0UAYwHuoD7icu1pKTuc2LznSR9PVBFve/79366KIoNhoZbYwSZOAmj5Mt
	 pnw7Y8RT4Z+nOswgthykwBJMLfpwUJn8XsIufEpGhlcHHT6K13PJ4H+ns6pPuYGiV3
	 j6WMbHHiZ4B/i7giaJfn+NbCZ94LzHj0tKslRumM=
Date: Tue, 06 Oct 2026 17:49:33 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-localize-struct-huge_bootmem_page.patch removed from -mm tree
Message-Id: <20261007004933.A7AE61F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: localize struct huge_bootmem_page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-localize-struct-huge_bootmem_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb: localize struct huge_bootmem_page
Date: Thu, 10 Sep 2026 14:32:55 +0800

struct huge_bootmem_page is only used by hugetlb boot-time allocation
code, but its definition currently lives in mm/internal.h because
hugetlb_vmemmap_optimize_bootmem_page() takes it as an argument.  This
exposes a hugetlb-specific internal type more broadly than needed.

Change hugetlb_vmemmap_optimize_bootmem_page() to take the information it
actually needs.  With that interface, mm/hugetlb_vmemmap.h no longer needs
to include mm/internal.h, and struct huge_bootmem_page can move into
mm/hugetlb.c.

Link: https://lore.kernel.org/20260910063256.64386-17-songmuchun@bytedance.com
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

 mm/hugetlb.c         |    8 +++++++-
 mm/hugetlb_vmemmap.c |    9 +++------
 mm/hugetlb_vmemmap.h |    5 ++---
 mm/internal.h        |    7 -------
 4 files changed, 12 insertions(+), 17 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-localize-struct-huge_bootmem_page
+++ a/mm/hugetlb.c
@@ -55,6 +55,12 @@
 #include "sparse.h"
 #include <linux/page-isolation.h>
 
+struct huge_bootmem_page {
+	struct list_head list;
+	struct hstate *hstate;
+	unsigned long flags;
+};
+
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
@@ -3151,7 +3157,7 @@ static bool __init alloc_bootmem_huge_pa
 	} else {
 		list_add_tail(&m->list, &huge_boot_pages[nid]);
 		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
-		hugetlb_vmemmap_optimize_bootmem_page(m);
+		hugetlb_vmemmap_optimize_bootmem_page(pfn, huge_page_order(h));
 		/*
 		 * Only initialize the head struct page in memmap_init_reserved_pages,
 		 * rest of the struct pages will be initialized by the HugeTLB
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-localize-struct-huge_bootmem_page
+++ a/mm/hugetlb_vmemmap.c
@@ -19,6 +19,7 @@
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
 #include "sparse.h"
+#include "internal.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -705,16 +706,12 @@ void hugetlb_vmemmap_optimize_bootmem_fo
 	__hugetlb_vmemmap_optimize_folios(h, folio_list, true);
 }
 
-void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
+void __init hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order)
 {
-	struct hstate *h = m->hstate;
-	unsigned long pfn = PHYS_PFN(__pa(m));
-
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return;
 
-	section_set_compound_order_range(pfn, pages_per_huge_page(h),
-					 huge_page_order(h));
+	section_set_compound_order_range(pfn, 1UL << order, order);
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb-localize-struct-huge_bootmem_page
+++ a/mm/hugetlb_vmemmap.h
@@ -9,7 +9,6 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
-#include "internal.h"
 
 /*
  * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
@@ -26,7 +25,7 @@ long hugetlb_vmemmap_restore_folios(cons
 void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
-void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m);
+void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order);
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
 {
@@ -77,7 +76,7 @@ static inline unsigned int hugetlb_vmemm
 	return 0;
 }
 
-static inline void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
+static inline void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order)
 {
 }
 #endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
--- a/mm/internal.h~mm-hugetlb-localize-struct-huge_bootmem_page
+++ a/mm/internal.h
@@ -23,13 +23,6 @@
 #include "vma.h"
 
 struct folio_batch;
-struct hstate;
-
-struct huge_bootmem_page {
-	struct list_head list;
-	struct hstate *hstate;
-	unsigned long flags;
-};
 
 /* mm/workingset.c */
 bool workingset_test_recent(void *shadow, bool file, bool *workingset,
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


