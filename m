Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293122;
	b=Ek9qjZl8aQiGuJ2CrS503F5CpZkAuYeeieLHrsxoRc8QDqPwbZmuxL+LwL9e0reIZcmK
	 btPOlWxqcCnZBqfIYfRpUn46/aUFi/oZJe3JKkbvuriUpdhlxEUnlWaHVcTbFHwP3FZ8a
	 TpjKa7NLAbMZd7248Vcl8emoqe9vhkvmjH+gnPzv8DVUIfNqzoba+Majm+QdOVPnzZfSd
	 rUUfeKe5eJp40D92Qi4gR/2rJ7+iITyFF6ijwk3Bzg+SH5bLV+gGhonhN66R7byplFZNs
	 6hDEZUwsX7EwUVe/cc5sLcMsmHcl4TL/qisUruecgBMbJoiKxI8MFwVswn0JMnxlpXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293122;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=5C/Dt0omSofHasNhSwji9hwqILOVkgmTX5ilJiy6Nio=;
	b=ULTmNlPMq21HTsBKpHRvTLEM/Fb5YiOPmkwwN4NdhDwKxe8czLvOwgZDp1mc/eSoBTyE
	 IJq+TaMJugTSb+SM5Nq/1n8HoeHHzJR/TOWSk6muHvFxQJgFhs/FttUqqygIIkwEYpVas
	 fdb9EHTpcKHECnR8lBhPc7xxTln8qJXuy/CBPZM4NKTz8rHwQOKUJ2oqcOzaxjAGyz8xM
	 BtI0tL4Tr9lkxVv4A7maM+EVilpLECP7NTf2QVs6en4/6cur4mjYHyMYdEc9qxdmcLpw8
	 ImmmMz35hZDWiJ2Fwy0eNSjkBdr9HyghNwBTk65nNzQJtsFOdzycHtv6fHqRxm5ibLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=h6nB08i5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45741606CB19;
	Tue, 10 Nov 2026 06:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=h6nB08i5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBA51F008A1;
	Tue, 10 Nov 2026 06:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293121;
	bh=5C/Dt0omSofHasNhSwji9hwqILOVkgmTX5ilJiy6Nio=;
	h=Date:To:From:Subject;
	b=h6nB08i5PJmHEYYYQnSELQd6ojuivh2l13I0iNABYalks/TKBxYCSKvpEM1+Uez9W
	 7jMC5luKhySuKOS4mggf0C7TsBXbxts2e0yyOxZ++oWs22iTD5NaBsohf31PSzFTB5
	 cwSm6HTs1kAX8F4l+fH8DLXKYm347MSCueDnB+hQ=
Date: Mon, 09 Nov 2026 22:45:21 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,stable@vger.kernel.org,
	pjw@kernel.org,palmer@dabbelt.com,osalvador@suse.de,mark.rutland@arm.com,
	kevin.brodsky@arm.com,david@kernel.org,dave.hansen@intel.com,
	catalin.marinas@arm.com,bjorn@rivosinc.com,apopple@nvidia.com,
	aou@eecs.berkeley.edu,anshuman.khandual@arm.com,alex@ghiti.fr,
	agordeev@linux.ibm.com,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch removed from -mm tree
Message-Id: <20261110064521.BDBA51F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: arm64/mm: fix destructor for unconstructed hotplug page tables
has been removed from the -mm tree.  Its filename was
     arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: arm64/mm: fix destructor for unconstructed hotplug page tables
Date: Fri, 23 Oct 2026 14:34:28 +0800

Commit c594b83457cc ("arm64: mm: call pagetable dtor when freeing
hot-removed page tables") made free_hotplug_pgtable_page()
unconditionally run the page-table destructor. This matches page tables
allocated by the arm64 mapping code, which runs the corresponding
constructors.

However, arm64 also uses the generic sparse-vmemmap population code.
Runtime intermediate page tables allocated by that code do not run a
page-table constructor. Freeing one during memory hot-remove therefore
runs a destructor without a matching constructor and corrupts
NR_PAGETABLE accounting.

Free intermediate page-table pages through pagetable_free(). It runs the
destructor only for constructor-backed pages and then releases the page
through the page-table freeing path.

Link: https://lore.kernel.org/20261023063428.3658761-5-songmuchun@bytedance.com
Fixes: c594b83457cc ("arm64: mm: call pagetable dtor when freeing hot-removed page tables")
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
---

 arch/arm64/mm/mmu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm64/mm/mmu.c~arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables
+++ a/arch/arm64/mm/mmu.c
@@ -1495,8 +1495,7 @@ static void free_hotplug_page_range(stru
 
 static void free_hotplug_pgtable_page(struct page *page)
 {
-	pagetable_dtor(page_ptdesc(page));
-	free_hotplug_page_range(page, PAGE_SIZE, NULL);
+	pagetable_free(page_ptdesc(page));
 }
 
 static bool pgtable_range_aligned(unsigned long start, unsigned long end,
_

Patches currently in -mm which might be from muchun.song@linux.dev are

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

