Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C11C358399
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 20:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783283789; cv=none; b=epRL0LHO91K6ymEw8M9aM2I/BJXgoIBRVyEMKLHvGckOlb/TLTBOgU7eSovi1z+Rgo08Dk7cdPdURplgiQFRn5zXH08ANaQrAHg+bfiqTivo56LoLf5xmee91E678oJ4WFfVxrItPtlw1NowPHIR5n0S4e+rIxf2gbK4W3YssKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783283789; c=relaxed/simple;
	bh=u6p/F5ZbUxdRfmGPsyKzVh854/tThjJ5d6f//IjNGvk=;
	h=Date:To:From:Subject:Message-Id; b=gDRjIUPNEgtW6OD2kqhkRGBaBk+XtB2UXp78KjccaP3UyGzxIuSOw/KezIQIPHSWd+rRNcQOh+5/TWwCHIqyfXAwblKSF7PXnJiBbKKwsYFvtwYlxxiv6WxOev5G2pdwwoGjCkydZF/4rPJ+Xk2n49V/L+3cFXDbEbfUpfCOIfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MaGz8EYY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MaGz8EYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294D61F000E9;
	Sun,  5 Jul 2026 20:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783283788;
	bh=GzYbVAaUj2RLkp2zJckjgNDVOKxP+e6UQt8gkHqqTJc=;
	h=Date:To:From:Subject;
	b=MaGz8EYYm1jghkD9wIGahbuSvXhSOTUCyXIWQxJGILLRc9yw0OJqYq3klVpt0aJw3
	 6rQ0+Q7IBWFWz1r1olai0Jr52K1hekw03SIDuDmuU55uAtuw0vvQP+eYzVPGQnbz9W
	 qXv0TsKPnNkCMscnjQpWHjc183Ugam8GywmFh5JU=
Date: Sun, 05 Jul 2026 13:36:27 -0700
To: mm-commits@vger.kernel.org,jiangwenxiaomi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic.patch removed from -mm tree
Message-Id: <20260705203628.294D61F000E9@smtp.kernel.org>
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
Date: Thu, 18 Jun 2026 16:47:23 +0800

Extract the common PTE mapping logic from vmap_pte_range() into a shared
helper vmap_set_ptes().  This handles both CONT_PTE and regular PTE
mappings in a single function, preparing for the next patch which will
extend vmap_pages_pte_range() to also use this helper.

The #ifdef CONFIG_HUGETLB_PAGE guard is moved inside vmap_set_ptes(), so
callers no longer need to handle the conditional compilation.

No functional change.

Link: https://lore.kernel.org/20260618084726.1070022-4-jiangwen6@xiaomi.com
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic
+++ a/mm/vmalloc.c
@@ -91,6 +91,35 @@ struct vfree_deferred {
 static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
 
 /*** Page table manipulation functions ***/
+
+/*
+ * Set PTE mappings for the given PFN. Try CONT_PTE mappings first when
+ * supported, otherwise fall back to PAGE_SIZE mappings.
+ *
+ * Return: mapping size.
+ */
+static __always_inline unsigned long vmap_set_ptes(pte_t *pte,
+		unsigned long addr, unsigned long end, u64 pfn,
+		pgprot_t prot, unsigned int max_page_shift)
+{
+#ifdef CONFIG_HUGETLB_PAGE
+	if (max_page_shift > PAGE_SHIFT) {
+		unsigned long size;
+
+		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
+		if (size != PAGE_SIZE) {
+			pte_t entry = pfn_pte(pfn, prot);
+
+			entry = arch_make_huge_pte(entry, ilog2(size), 0);
+			set_huge_pte_at(&init_mm, addr, pte, entry, size);
+			return size;
+		}
+	}
+#endif
+	set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
+	return PAGE_SIZE;
+}
+
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift, pgtbl_mod_mask *mask)
@@ -119,19 +148,8 @@ static int vmap_pte_range(pmd_t *pmd, un
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


