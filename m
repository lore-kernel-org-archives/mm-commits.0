Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293115;
	b=nnx8RcJ6fDI4W5nAIL6AqaVy+sdyIEisvPLjZb48CDNI2X/bqH1js+65TIdukeJsncuM
	 issZqNHE3KvrrxIfG6kEltc8XbfvvHeyuIJIRdEGkVj1HPN7VWYZa3+0KX2Qvx3HVfqIA
	 e4zZt3AaKWhnYJ7JEtGnp9MTN8G7PMzmaRTvh6972gtG5XX/mWv1Y33kJZDtnze2b+zit
	 2NnXgYbOoyITYkDNpRcxItxYHfDTL1RNbb5g04jZ6c0LAgk4ELwNPAg9PG+GN0G2XXqjs
	 0xvatA82oZxkywZI+O+/b8FnWo/CQd8KZPEmSTVkZy+XP7fxRR8t6sMm3f2GW0NdvPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293115;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=x0pg1ZSD2VK0yA5MmV6R9bMjgrhzjbCuT0KFvY/z3/Y=;
	b=16CBRxy99x7OpPyMAElNK1MRRKREmKX5k1oCNkuGExQBYaykb7DypwrSzPnC5drpy6wV
	 xgpRW9zGCQlgjSiNBq0e6VEKw4iNaOrDoLb6ywJKeCkEw0wiJokZsr3/2EQMSfmsoVW0M
	 Yn1KAuHkaEg9lFoa5PlFwW7cnkec0DhTFNpfaukQkfSjq7IDe/f9ebeXysDfDzX1v5n7F
	 9HYG/UxXqps1sf8SsS5fKA8PR9LqE3O4vPQknOidrCp2CF8QTwvBlV9KKdwH0GmmX9GJ0
	 1Qh6dcrpL+BTQuxvQz7wGSymxdy9kIsr/j0kOhZGLfH811yivqfduZvixLBlyNAtzlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OrMKWSDC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6225606BD76;
	Tue, 10 Nov 2026 06:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OrMKWSDC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896531F008A3;
	Tue, 10 Nov 2026 06:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293114;
	bh=x0pg1ZSD2VK0yA5MmV6R9bMjgrhzjbCuT0KFvY/z3/Y=;
	h=Date:To:From:Subject;
	b=OrMKWSDCPSghZrL08FtygmwEzYOngWAJjSJLtHS5p4PZ3eZOlhDlGG3JmIiKGa3Di
	 BRed5KR3COmDGYj1zILXz8pI95xd/yc5xZhSVEYQbEtRg5SB15TXZkmgjIQ6pEzyOM
	 LGWTCCueOgvu/G4sI0oMjOKV6OnoRgcP5JgN2It4=
Date: Mon, 09 Nov 2026 22:45:14 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,stable@vger.kernel.org,
	pjw@kernel.org,palmer@dabbelt.com,osalvador@suse.de,mark.rutland@arm.com,
	kevin.brodsky@arm.com,david@kernel.org,dave.hansen@intel.com,
	catalin.marinas@arm.com,bjorn@rivosinc.com,bjorn@kernel.org,
	apopple@nvidia.com,aou@eecs.berkeley.edu,alex@ghiti.fr,
	agordeev@linux.ibm.com,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] riscv-mm-fix-hotplug-page-table-destructor-handling.patch removed from -mm tree
Message-Id: <20261110064514.896531F008A3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: riscv/mm: fix hotplug page-table destructor handling
has been removed from the -mm tree.  Its filename was
     riscv-mm-fix-hotplug-page-table-destructor-handling.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: riscv/mm: fix hotplug page-table destructor handling
Date: Fri, 23 Oct 2026 14:34:26 +0800

RISC-V uses the same memory-hotplug teardown code for linear-map and
vmemmap page tables. Late linear-map allocations run page-table
constructors, while vmemmap and early allocations may not.

free_pte_table() unconditionally calls pagetable_dtor(), corrupting
NR_PAGETABLE accounting for constructor-free tables. free_pmd_table()
avoids that for vmemmap using is_vmemmap, but mapping type is not a
reliable proxy for constructor state. In particular, it becomes invalid
once runtime vmemmap tables use the normal pgalloc helpers.

Introduce free_pgtable_page() to select free_reserved_page() for reserved
pages and pagetable_free() otherwise. The latter runs the destructor only
when PageTable() is set, handling both constructor-backed and
constructor-free tables.

Link: https://lore.kernel.org/20261023063428.3658761-3-songmuchun@bytedance.com
Fixes: c75a74f4ba19 ("riscv: mm: Add memory hotplugging support")
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
---

 arch/riscv/mm/init.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/arch/riscv/mm/init.c~riscv-mm-fix-hotplug-page-table-destructor-handling
+++ a/arch/riscv/mm/init.c
@@ -1501,10 +1501,17 @@ struct execmem_info __init *execmem_arch
 #endif /* CONFIG_EXECMEM */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
+static void __meminit free_pgtable_page(struct page *page)
+{
+	if (PageReserved(page))
+		free_reserved_page(page);
+	else
+		pagetable_free(page_ptdesc(page));
+}
+
 static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
 {
 	struct page *page = pmd_page(*pmd);
-	struct ptdesc *ptdesc = page_ptdesc(page);
 	pte_t *pte;
 	int i;
 
@@ -1514,18 +1521,13 @@ static void __meminit free_pte_table(pte
 			return;
 	}
 
-	pagetable_dtor(ptdesc);
-	if (PageReserved(page))
-		free_reserved_page(page);
-	else
-		pagetable_free(ptdesc);
+	free_pgtable_page(page);
 	pmd_clear(pmd);
 }
 
-static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud, bool is_vmemmap)
+static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud)
 {
 	struct page *page = pud_page(*pud);
-	struct ptdesc *ptdesc = page_ptdesc(page);
 	pmd_t *pmd;
 	int i;
 
@@ -1535,12 +1537,7 @@ static void __meminit free_pmd_table(pmd
 			return;
 	}
 
-	if (!is_vmemmap)
-		pagetable_dtor(ptdesc);
-	if (PageReserved(page))
-		free_reserved_page(page);
-	else
-		pagetable_free(ptdesc);
+	free_pgtable_page(page);
 	pud_clear(pud);
 }
 
@@ -1660,7 +1657,7 @@ static void __meminit remove_pud_mapping
 		remove_pmd_mapping(pmd_base, addr, next, is_vmemmap, altmap);
 
 		if (pgtable_l4_enabled())
-			free_pmd_table(pmd_base, pudp, is_vmemmap);
+			free_pmd_table(pmd_base, pudp);
 	}
 }
 
_

Patches currently in -mm which might be from muchun.song@linux.dev are

riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch
mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch
mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch
mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch
powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
loongarch-mm-disable-device-dax-vmemmap-optimization.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch

