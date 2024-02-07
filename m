Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188C61350C2
	for <mm-commits@vger.kernel.org>; Wed,  7 Feb 2024 21:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707342892; cv=none; b=f1t/911pr3l+WGy5imEYc0q9arE74st/6EpmJiLFPOev0hpEejEH3hWpwspMJ8APwOJRjKODUmkYk+hi/PTnX0bEgmtAIFo7vLKC4eHDcBIqllxJtvojQ9w7PtjRH1O9zK5hDzpQ3GzU8jvZdZG3j6eLf+PpUkOgsAOOVhFaoWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707342892; c=relaxed/simple;
	bh=8BsSs+zayHKy2QyBpWlIrnoa5G0e1nBdGgUgTGIpk88=;
	h=Date:To:From:Subject:Message-Id; b=nGTnzVTHeXLLidaZBAMSPR/lYtBVgWkwtrmLNMQAgvFnBdW63kjd4YDD49fG+VMamvnD9C4d0ltS1yJCCPCHNt9dshz8p/Gq+lU6b9KHGiDDoKMsRHtsrIBBzlY6bNeZe4KC/6iS0pi/0Vdwq/Dc/QmnOYSPea6Rqj7YaiTvk8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZIBa0Qio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZIBa0Qio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC5CC433C7;
	Wed,  7 Feb 2024 21:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707342891;
	bh=8BsSs+zayHKy2QyBpWlIrnoa5G0e1nBdGgUgTGIpk88=;
	h=Date:To:From:Subject:From;
	b=ZIBa0QioD+c0juLPSQCljENZ9UGEMwSCrCJlpS6bSeSJluzv1dmpxl69y1CNiTjR+
	 t5uICeZYf5eNOndwp1OzzhuqFz/qfHyQRiM8kgwxLGoCe/h6MEilItrO2FDfx3nCQ7
	 9oLK165x2O7Hm3Rwr4YQ7GG1js2lNs3BCYqCE7rA=
Date: Wed, 07 Feb 2024 13:54:50 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,mike.kravetz@oracle.com,mark.rutland@arm.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,sunnanyong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hvo-introduce-helper-function-to-update-and-flush-pgtable.patch removed from -mm tree
Message-Id: <20240207215451.6DC5CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: HVO: introduce helper function to update and flush pgtable
has been removed from the -mm tree.  Its filename was
     mm-hvo-introduce-helper-function-to-update-and-flush-pgtable.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Nanyong Sun <sunnanyong@huawei.com>
Subject: mm: HVO: introduce helper function to update and flush pgtable
Date: Sat, 13 Jan 2024 17:44:34 +0800

Patch series "A Solution to Re-enable hugetlb vmemmap optimize", v3.

HVO was previously disabled on arm64 [1] due to the lack of necessary
BBM(break-before-make) logic when changing page tables.  This set of
patches fix this by adding necessary BBM sequence when changing page
table, and supporting vmemmap page fault handling to fixup kernel address
translation fault if vmemmap is concurrently accessed.

I have tested this patch set with concurrently accessing the vmemmap
address when do BBM and can recover by vmemmap fault handler.  Also tested
under the config of 2/3/4 pgtable levels with 4K/64K page size and all
works well.


This patch (of 3):

Add pmd/pte update and tlb flush helper function to update page table. 
This refactoring patch is designed to facilitate each architecture to
implement its own special logic in preparation for the arm64 architecture
to follow the necessary break-before-make sequence when updating page
tables.

Link: https://lkml.kernel.org/r/20240113094436.2506396-1-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/20240113094436.2506396-2-sunnanyong@huawei.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   55 ++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 12 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hvo-introduce-helper-function-to-update-and-flush-pgtable
+++ a/mm/hugetlb_vmemmap.c
@@ -46,6 +46,37 @@ struct vmemmap_remap_walk {
 	unsigned long		flags;
 };
 
+#ifndef vmemmap_update_pmd
+static inline void vmemmap_update_pmd(unsigned long addr,
+				      pmd_t *pmdp, pte_t *ptep)
+{
+	pmd_populate_kernel(&init_mm, pmdp, ptep);
+}
+#endif
+
+#ifndef vmemmap_update_pte
+static inline void vmemmap_update_pte(unsigned long addr,
+				      pte_t *ptep, pte_t pte)
+{
+	set_pte_at(&init_mm, addr, ptep, pte);
+}
+#endif
+
+#ifndef vmemmap_flush_tlb_all
+static inline void vmemmap_flush_tlb_all(void)
+{
+	flush_tlb_all();
+}
+#endif
+
+#ifndef vmemmap_flush_tlb_range
+static inline void vmemmap_flush_tlb_range(unsigned long start,
+					   unsigned long end)
+{
+	flush_tlb_kernel_range(start, end);
+}
+#endif
+
 static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 			     struct vmemmap_remap_walk *walk)
 {
@@ -81,9 +112,9 @@ static int vmemmap_split_pmd(pmd_t *pmd,
 
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
-		pmd_populate_kernel(&init_mm, pmd, pgtable);
+		vmemmap_update_pmd(start, pmd, pgtable);
 		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
-			flush_tlb_kernel_range(start, start + PMD_SIZE);
+			vmemmap_flush_tlb_range(start, start + PMD_SIZE);
 	} else {
 		pte_free_kernel(&init_mm, pgtable);
 	}
@@ -171,7 +202,7 @@ static int vmemmap_remap_range(unsigned
 		return ret;
 
 	if (walk->remap_pte && !(walk->flags & VMEMMAP_REMAP_NO_TLB_FLUSH))
-		flush_tlb_kernel_range(start, end);
+		vmemmap_flush_tlb_range(start, end);
 
 	return 0;
 }
@@ -217,15 +248,15 @@ static void vmemmap_remap_pte(pte_t *pte
 
 		/*
 		 * Makes sure that preceding stores to the page contents from
-		 * vmemmap_remap_free() become visible before the set_pte_at()
-		 * write.
+		 * vmemmap_remap_free() become visible before the
+		 * vmemmap_update_pte() write.
 		 */
 		smp_wmb();
 	}
 
 	entry = mk_pte(walk->reuse_page, pgprot);
 	list_add(&page->lru, walk->vmemmap_pages);
-	set_pte_at(&init_mm, addr, pte, entry);
+	vmemmap_update_pte(addr, pte, entry);
 }
 
 /*
@@ -264,10 +295,10 @@ static void vmemmap_restore_pte(pte_t *p
 
 	/*
 	 * Makes sure that preceding stores to the page contents become visible
-	 * before the set_pte_at() write.
+	 * before the vmemmap_update_pte() write.
 	 */
 	smp_wmb();
-	set_pte_at(&init_mm, addr, pte, mk_pte(page, pgprot));
+	vmemmap_update_pte(addr, pte, mk_pte(page, pgprot));
 }
 
 /**
@@ -519,7 +550,7 @@ long hugetlb_vmemmap_restore_folios(cons
 	}
 
 	if (restored)
-		flush_tlb_all();
+		vmemmap_flush_tlb_all();
 	if (!ret)
 		ret = restored;
 	return ret;
@@ -642,7 +673,7 @@ void hugetlb_vmemmap_optimize_folios(str
 			break;
 	}
 
-	flush_tlb_all();
+	vmemmap_flush_tlb_all();
 
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
@@ -659,7 +690,7 @@ void hugetlb_vmemmap_optimize_folios(str
 		 * allowing more vmemmap remaps to occur.
 		 */
 		if (ret == -ENOMEM && !list_empty(&vmemmap_pages)) {
-			flush_tlb_all();
+			vmemmap_flush_tlb_all();
 			free_vmemmap_page_list(&vmemmap_pages);
 			INIT_LIST_HEAD(&vmemmap_pages);
 			__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages,
@@ -667,7 +698,7 @@ void hugetlb_vmemmap_optimize_folios(str
 		}
 	}
 
-	flush_tlb_all();
+	vmemmap_flush_tlb_all();
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
_

Patches currently in -mm which might be from sunnanyong@huawei.com are

arm64-mm-hvo-support-bbm-of-vmemmap-pgtable-safely.patch
arm64-mm-re-enable-optimize_hugetlb_vmemmap.patch

