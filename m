Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6955F4B44BE;
	Sat, 10 Oct 2026 19:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791659549; cv=none; b=Dy56rSBONqwuR/ttG0ZHayu5ffhlzDF4z2+Onw0Q6sOOjecTvBd6O5M4e5u84WSPd+PhQIvE4gCXpoycwYOZIdkyvqrTzi2uXXq8Sw09GnWhvD+peNcUO8+WZmit8v54yS2guqPkiRCPDmKhvCGXD+C8/K4X5QD4LhQodQlavjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791659549; c=relaxed/simple;
	bh=sWxsMlyTOECkb8O6SgJCOoo2qnviKWHgOtITSbWiuzI=;
	h=Date:To:From:Subject:Message-Id; b=bclagRtQ+EMzGTjePdwac4HBagRc2vZE4nnZV6oSw4GudvxrLwE8aEvTUDR4Ag+ZtGxAH4o9+YaZe56WSA8Dw8m+WsqActCr4atj8WUrZDhiPzBO6pmF1S3wCYKjrvcd+lQ4iAfeSOnF5vsHHbP8HMSyZRjdo8Os6Aa/GbPm7yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FSzdEg1i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FSzdEg1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A511F00893;
	Sat, 10 Oct 2026 19:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791659548;
	bh=BfstnmmH2eBJJjrBpVLOYqE1SHJzHXPvu3C9dHeQop0=;
	h=Date:To:From:Subject;
	b=FSzdEg1i1ecjJrOureM0fN4v4AdFR/29ab/L9Nxvj9sBO0TK17RBi5s7I9xCDtIJA
	 SvppT6aARVjD2bF5mDNb6WmNBIiLX1uE9VWDJgWsaRw7K43w/NaW4/uKWNdeNLBQ5f
	 W/dKEyP2IgRIGwKaWlyE9+A7lLocAtfEXwOwbSaU=
Date: Sat, 10 Oct 2026 12:12:27 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,stable@vger.kernel.org,pjw@kernel.org,palmer@dabbelt.com,osalvador@suse.de,mark.rutland@arm.com,kevin.brodsky@arm.com,david@kernel.org,dave.hansen@intel.com,catalin.marinas@arm.com,bjorn@rivosinc.com,apopple@nvidia.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-mm-fix-hotplug-page-table-destructor-handling.patch added to mm-unstable branch
Message-Id: <20261010191227.F3A511F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv/mm: fix hotplug page-table destructor handling
has been added to the -mm mm-unstable branch.  Its filename is
     riscv-mm-fix-hotplug-page-table-destructor-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-mm-fix-hotplug-page-table-destructor-handling.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Muchun Song <muchun.song@linux.dev>
Subject: riscv/mm: fix hotplug page-table destructor handling
Date: Sat, 10 Oct 2026 19:24:55 +0800

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

Link: https://lore.kernel.org/20261010112457.49485-3-songmuchun@bytedance.com
Fixes: c75a74f4ba19 ("riscv: mm: Add memory hotplugging support")
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
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
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
---

 arch/riscv/mm/init.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/arch/riscv/mm/init.c~riscv-mm-fix-hotplug-page-table-destructor-handling
+++ a/arch/riscv/mm/init.c
@@ -1486,10 +1486,17 @@ struct execmem_info __init *execmem_arch
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
 
@@ -1499,18 +1506,13 @@ static void __meminit free_pte_table(pte
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
 
@@ -1520,12 +1522,7 @@ static void __meminit free_pmd_table(pmd
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
 
@@ -1645,7 +1642,7 @@ static void __meminit remove_pud_mapping
 		remove_pmd_mapping(pmd_base, addr, next, is_vmemmap, altmap);
 
 		if (pgtable_l4_enabled)
-			free_pmd_table(pmd_base, pudp, is_vmemmap);
+			free_pmd_table(pmd_base, pudp);
 	}
 }
 
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

