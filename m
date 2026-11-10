Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293118;
	b=aNQS/pMFDvkXfvlQDUxH/S27aVzulNpPsXlk3dPm0RM2RRy1iR9DVTQcrQWqtlHvD0pE
	 BLkouz6HNJQsbIZKCfqrQPWL//Te6/a02y7NtqhOJLH6S81hSP8jgIpy/KtrNy09dFP6g
	 1gxsxwyI1FVkyCYzH89HkPGev5l3+XKgrmrlOGRr4+CUO/rZQI2VZhLphLW7EO743O/YB
	 H0x4LSSAMwynan/lvwMuMhmy+w6IildtKBp5eFIW1Xk0XPtgKVbWhkIm6PZpN5MlaJFgv
	 IHLKJEmef6kswPubmAuMC6664v/u/6bKMBztYQMnWi1TjdbkPxJ12uu9nMGte7SmQQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293118;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=/xhidG+1kdsh3WnxHszwMZDJsvfNMmYDQbrCvD+jyeI=;
	b=MZzOfjgy8FdVpM4nBmNuB13uoJw7JmJJuGJEFK6mjDsDyJ0vWwZlf3NuHD8+F0v8bclV
	 w3w7Xl9b1AI4mtwNxjfzeNeeRRlQX+WLP6uejSfx/1waA5FrAj2pBuQwy1h8OWifti7De
	 gp+I4BoTJlLke89mwVVxERZ4g/cyDm3EQX8kuKi8Dht3SFQfvR9byqWHkXSUUyrS1AlSB
	 /OUh588N67int1kA8ZrPF5UAe8N1Hduom8WffGdSEsMOCoCSCjwWpHHHb1qK3Eb+tNatY
	 sJwk9PDUhsaOVGID039btsNRqTn/2bqWhHbFINTsh4wc6f9S8Dm+1AdII6WX1N8/hrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SUImvl4P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B400606CB12;
	Tue, 10 Nov 2026 06:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SUImvl4P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346311F0089F;
	Tue, 10 Nov 2026 06:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293118;
	bh=/xhidG+1kdsh3WnxHszwMZDJsvfNMmYDQbrCvD+jyeI=;
	h=Date:To:From:Subject;
	b=SUImvl4Pvgi0eM0sBOQbwHJiravm9zC3UNL25tV4eMD0mCefUd1k9le2qBozruJ/c
	 VfBws6nQa+wtL/aHYH9aWi/ogfxkAYdi6Oc1T55uVKFaQ6JiUS7/+eKK/olwxj1xKx
	 vm2TBKQJdE+XJH/LSRB8TaXM/7qCJJw8Qu9ZjLuk=
Date: Mon, 09 Nov 2026 22:45:17 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,stable@vger.kernel.org,
	pjw@kernel.org,palmer@dabbelt.com,osalvador@suse.de,mark.rutland@arm.com,
	kevin.brodsky@arm.com,david@kernel.org,dave.hansen@intel.com,
	catalin.marinas@arm.com,bjorn@rivosinc.com,bjorn@kernel.org,
	apopple@nvidia.com,aou@eecs.berkeley.edu,alex@ghiti.fr,
	agordeev@linux.ibm.com,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch removed from -mm tree
Message-Id: <20261110064518.346311F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: riscv/mm: fix missing destructor for hotplug PUD tables
has been removed from the -mm tree.  Its filename was
     riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: riscv/mm: fix missing destructor for hotplug PUD tables
Date: Fri, 23 Oct 2026 14:34:27 +0800

Commit 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special kernel
pgtable alloc") made alloc_pud_late() run the PUD page-table constructor.
However, free_pud_table() still frees non-reserved PUD tables directly
without decrementing NR_PAGETABLE.

Free PUD tables through the common free_pgtable_page() helper so that
constructor-backed tables run the matching destructor before being
freed.

Link: https://lore.kernel.org/20261023063428.3658761-4-songmuchun@bytedance.com
Fixes: 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special kernel pgtable alloc")
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

 arch/riscv/mm/init.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/riscv/mm/init.c~riscv-mm-fix-missing-destructor-for-hotplug-pud-tables
+++ a/arch/riscv/mm/init.c
@@ -1553,10 +1553,7 @@ static void __meminit free_pud_table(pud
 			return;
 	}
 
-	if (PageReserved(page))
-		free_reserved_page(page);
-	else
-		__free_pages(page, 0);
+	free_pgtable_page(page);
 	p4d_clear(p4d);
 }
 
_

Patches currently in -mm which might be from muchun.song@linux.dev are

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

