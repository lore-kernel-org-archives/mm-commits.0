Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CEA41F5D3
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784140393; cv=none; b=DKFRXI/xxiLGJ4I5U/UCaQ6PPQx8n0qT45Kx2mUKPADMJU2hNbQ35rkxuCYSVEpdSc14dNUg/xY12+diMZooa1Y3twDQJUsHs3vam5RQvw8TFl7HWgCw7AlyJYc6ynOURJsZ2/fo5qIp79M4xkzdu3B6f8IxIK8g01QFh0DV7E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784140393; c=relaxed/simple;
	bh=IvlxQfcCa9rz1Zt7bvT1Ri1jyFLd99e/SvJLkYHieyA=;
	h=Date:To:From:Subject:Message-Id; b=aNf8FbzfhpA588fQdrSF8mNusiAi6l139h4okioGemaf9skQ1Oc582AqPlyHHmEK2bc0GnZ3AcrRpJ41niG9X07QeKlJCuAFoD6kxR6bShhV5shSz8xrVIG9jvJCFejlDdWQa45Mc5PLQyWpofm/u2TMoSJQxPvff+hI6Cv/90k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ifCfsyIB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ifCfsyIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F057A1F00A3D;
	Wed, 15 Jul 2026 18:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784140375;
	bh=Vc7cE0yNLl1wSzF59jh9RMDPCnykWDBTFjj5Lbhp7eQ=;
	h=Date:To:From:Subject;
	b=ifCfsyIB/2sVxFa9zdh6Nj0hw2S9l5ldG9KNVPS/+JWmbCiRBDgdo0k8LQEL29AbT
	 prJwwbXLoMhFC4TR8uxY4p5rC8wDWeq7fz3gmeRhlqdnZeR5go7PpFq7itP7tkNb6e
	 FGAcU1jHxhTBuTyNj8Jyvo1P/mNHXVfcfKwJ4Wf0=
Date: Wed, 15 Jul 2026 11:32:54 -0700
To: mm-commits@vger.kernel.org,jiangwenxiaomi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic.patch removed from -mm tree
Message-Id: <20260715183254.F057A1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: extract vmap_set_ptes() to consolidate PTE mapping logic
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Subject: mm/vmalloc: extract vmap_set_ptes() to consolidate PTE mapping logic
Date: Thu, 9 Jul 2026 15:38:20 +0800

Extract the common PTE mapping logic from vmap_pte_range() into a shared
helper vmap_set_ptes().  This handles both CONT_PTE and regular PTE
mappings in a single function, preparing for the next patch which will
extend vmap_pages_pte_range() to also use this helper.

The #ifdef CONFIG_HUGETLB_PAGE guard is moved inside vmap_set_ptes(), so
callers no longer need to handle the conditional compilation.

No functional change.

Link: https://lore.kernel.org/20260709073823.6643-4-jiangwen6@xiaomi.com
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic
+++ a/mm/vmalloc.c
@@ -93,6 +93,33 @@ struct vfree_deferred {
 static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
 
 /*** Page table manipulation functions ***/
+
+/*
+ * Try contiguous mappings at the PTE level for arches which support them, and if
+ * requested by the caller. Fall back to PAGE_SIZE mappings otherwise.
+ *
+ * Return: mapping size.
+ */
+static __always_inline unsigned long vmap_set_ptes(pte_t *pte,
+		unsigned long addr, unsigned long end, u64 pfn,
+		pgprot_t prot, unsigned int max_page_shift)
+{
+#ifdef CONFIG_HUGETLB_PAGE
+	unsigned long size;
+
+	size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
+	if (size != PAGE_SIZE) {
+		pte_t entry = pfn_pte(pfn, prot);
+
+		entry = arch_make_huge_pte(entry, ilog2(size), 0);
+		set_huge_pte_at(&init_mm, addr, pte, entry, size);
+		return size;
+	}
+#endif
+	set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
+	return PAGE_SIZE;
+}
+
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift, pgtbl_mod_mask *mask)
@@ -121,19 +148,8 @@ static int vmap_pte_range(pmd_t *pmd, un
 			BUG();
 		}
 
-#ifdef CONFIG_HUGETLB_PAGE
-		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
-		if (size != PAGE_SIZE) {
-			pte_t entry = pfn_pte(pfn, prot);
-
-			entry = arch_make_huge_pte(entry, ilog2(size), 0);
-			set_huge_pte_at(&init_mm, addr, pte, entry, size);
-			pfn += PFN_DOWN(size);
-			continue;
-		}
-#endif
-		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
-		pfn++;
+		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
+		pfn += PFN_DOWN(size);
 	} while (pte += PFN_DOWN(size), addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
_

Patches currently in -mm which might be from jiangwenxiaomi@gmail.com are


