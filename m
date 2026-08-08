Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7891237B03F
	for <mm-commits@vger.kernel.org>; Sat,  8 Aug 2026 16:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786208289; cv=none; b=I6gkheaMW/3j2DCDolWaz2URHA3H+LykV444HCs4znspePcL/ghhwCDA0QUqXrBKA2PaI9mLpcVJu4GTn8bUz411tfbHsfnJ9AEp/LxPS5aze8BF2smMuRR5ZNxLoGS3P/yCnqoSRrJK8KKXfOkmQjMlefCushtfVN8y+StYALM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786208289; c=relaxed/simple;
	bh=p9W6Db/jvz7qDyu2CumVqTinOoMH74tbRuMxopVSOYU=;
	h=Date:To:From:Subject:Message-Id; b=AD/Q1NVzsEUz7zP7MhEJsgc+oOJyjCnTyYXhlr4gGQbvQockQwl16zo4+FuxN4aoF+WwDaL+2WJbgHMeEhHlBRAk31NrLUieQCEzGV/MTcpWIBe4jsqbJh/LjFr2YuuRB34wro6kd869EY4tdCjq9ovGWAx3xiXDe/a9sf29als=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DTQPYn05; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DTQPYn05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0013D1F00A3A;
	Sat,  8 Aug 2026 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786208288;
	bh=Klzg+/Lp7tm+ujJA97Zpn/qeAh/e5KCKmh1/JawrkeM=;
	h=Date:To:From:Subject;
	b=DTQPYn056ajkTDgo49Xh0+H6i24LodrOnZOESMvb2H7caHPggHCII19W81v+vW5sT
	 vaSFkTkHnsjrITfGj4fzoeNCwRt2mgH8HawLrzokNifb7Ts/1U8YhG7wub83TyHtAV
	 Irbjd6ZvCipfWinkQ0uFBvFFCieOXZC5KW70Zk5Q=
Date: Sat, 08 Aug 2026 09:58:07 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,leo.yan@arm.com,jiangwen6@xiaomi.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,ajd@linux.ibm.com,jiangwenxiaomi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic.patch removed from -mm tree
Message-Id: <20260808165808.0013D1F00A3A@smtp.kernel.org>
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
Date: Wed, 15 Jul 2026 20:08:09 +0800

Extract the common PTE mapping logic from vmap_pte_range() into a shared
helper vmap_set_ptes().  This handles both CONT_PTE and regular PTE
mappings in a single function, preparing for the next patch which will
extend vmap_pages_pte_range() to also use this helper.

The #ifdef CONFIG_HUGETLB_PAGE guard is moved inside vmap_set_ptes(), so
callers no longer need to handle the conditional compilation.

No functional change.

Link: https://lore.kernel.org/20260715120813.3609949-4-jiangwen6@xiaomi.com
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

 mm/vmalloc.c |   47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

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
@@ -100,7 +127,8 @@ static int vmap_pte_range(pmd_t *pmd, un
 	pte_t *pte;
 	u64 pfn;
 	struct page *page;
-	unsigned long size = PAGE_SIZE;
+	unsigned long size;
+	unsigned int steps;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -121,20 +149,9 @@ static int vmap_pte_range(pmd_t *pmd, un
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
-	} while (pte += PFN_DOWN(size), addr += size, addr != end);
+		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
+		steps = PFN_DOWN(size);
+	} while (pte += steps, pfn += steps, addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
_

Patches currently in -mm which might be from jiangwenxiaomi@gmail.com are

mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch

