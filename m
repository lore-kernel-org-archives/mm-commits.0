Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1EB446069
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784140704; cv=none; b=NHFMexFGUkp8bqQkERP2S0TeCVH1XXQZsqTQN0r56cb9XvB4nGlI6utCOYzurcxa/zwGLO/OJgKUeEWM9O83mN0GLR8vKyX5Xnw1GXYDa09QqQLcMwqsx+EIL8aCNAmECpXknv8+jqMzk8uhTg5KyboiSNE+4M6NQkSQ+Kx9V/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784140704; c=relaxed/simple;
	bh=dTa9yOJtBzJLybI92N0xJDK6ErSDwduGQEAyJdwjS3E=;
	h=Date:To:From:Subject:Message-Id; b=gJxb6Od6o+fsUzuWouy4avkFUielnczYLDaZA2hapfzeMm95l5YZOrcWRzaFSzdaJpzkCoiTpCYja9KbrBDuk/eE2xMayYbY7WofA1k51/Q42EGjASBxSbmL8bSljQXbdLNP1dXoCs16NDGDI7Bfgb0qJhhvNyh9lXsaxGeZk+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yur839Fb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yur839Fb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB04E1F000E9;
	Wed, 15 Jul 2026 18:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784140692;
	bh=W8ts/gL+Le0/YbHYR2SyLFJt2bNt8toZWEB2w/EPJeU=;
	h=Date:To:From:Subject;
	b=Yur839Fbqdf8A6tF12f51GeU1g2tmU48IfSDBnQUa1okxGQh0g2GdV/NbA7jM7TyC
	 G+/j73sffzLUEswEHaBW3VZeY9br6RweOlkopVWR630h0iXOSy8vwdjfRhfS0dztcU
	 tutk823ETOAsdnjV+x+wXdS9xje5RIz+l2hTATls=
Date: Wed, 15 Jul 2026 11:38:12 -0700
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch added to mm-unstable branch
Message-Id: <20260715183812.BB04E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/hugetlb: extend batching of multiple CONT_PTE in a single PTE setup
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch

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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: arm64/hugetlb: extend batching of multiple CONT_PTE in a single PTE setup
Date: Wed, 15 Jul 2026 20:08:07 +0800

Patch series "mm/vmalloc: Speed up ioremap, vmalloc and vmap with
contiguous memory", v7.

This patchset accelerates ioremap, vmalloc, and vmap when the memory is
physically fully or partially contiguous.  Two techniques are used:

1. Avoid page table rewalk when setting PTEs/PMDs for multiple memory
   segments
2. Use batched mappings wherever possible in both vmalloc and ARM64
   layers

Besides accelerating the mapping path, this also enables large mappings
(PMD and cont-PTE) for vmap, which are currently not supported.

Patches 1-2 extend ARM64 vmalloc CONT-PTE mapping to support multiple
CONT-PTE regions instead of just one.

Patch 3 extracts a common helper vmap_set_ptes() that consolidates PTE
mapping logic for the ioremap and vmalloc/vmap paths, handling both
CONT_PTE and regular PTE mappings. This prepares for the next patch.

Patch 4 extends the page table walk path to support page shifts other
than PAGE_SHIFT and eliminates the page table rewalk for huge vmalloc
mappings. The function is renamed from vmap_small_pages_range_noflush()
to vmap_pages_range_noflush_walk().

Patch 5 extracts vm_shift() to consolidate vmalloc mapping shift
selection for reuse in the batching path.

Patches 6-7 add huge vmap support for contiguous pages, including
support for non-compound pages with pfn alignment verification.

On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and
the performance CPUfreq policy enabled, benchmark results:

* ioremap(1 MB): 1.35x faster (3407 ns -> 2526 ns)
* vmalloc(1 MB) mapping time (excluding allocation) with
  VM_ALLOW_HUGE_VMAP: 1.42x faster (5.00 us -> 3.53 us)
* vmap(100MB) with order-8 pages: 8.3x faster (1235 us -> 149 us)

Many thanks to Xueyuan Chen for his testing efforts on RK3588 boards.

Large vmap() mappings were also tested by Leo Yan with ARM trace buffer
units, including TRBE and SPE.  These units use the CPU page tables for
address translation when writing trace data to DRAM, so using larger
vmap() mapping granules can reduce TLB pressure on the trace writer.

The TRBE test used a 1G CoreSight ETM AUX buffer. Across five runs on an
isolated CPU, the average results were:

* dtlb_walk:       68.4 -> 59.4 (-13.16%)
* l1d_tlb_refill: 155.8 -> 119.6 (-23.23%)
* l2d_tlb_refill: 161435.8 -> 495.0 (-99.69%)

The SPE test used a 512M ARM SPE AUX buffer. Across five runs on an
isolated CPU, the average results were:

* dtlb_walk:       1710.4 -> 1315.6 (-23.08%)
* l1d_tlb_refill: 16000.0 -> 15950.2 (-0.31%)
* l2d_tlb_refill: 4796.0 -> 2931.2 (-38.88%)

These results show that enabling larger vmap() mappings can materially
reduce page table walks and TLB refills for large trace buffers.

Many thanks to Leo Yan for his testing efforts on ARM trace buffers.


This patch (of 7):

For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE, we can
handle CONT_PTE_SIZE groups together.

These additional sizes are mapping spans used by non-hugetlbfs(vmalloc) mm
code, not new HugeTLB hstate sizes.

Link: https://lore.kernel.org/20260715120813.3609949-1-jiangwen6@xiaomi.com
Link: https://lore.kernel.org/20260715120813.3609949-2-jiangwen6@xiaomi.com
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/arch/arm64/mm/hugetlbpage.c~arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -94,6 +94,11 @@ static int find_num_contig(struct mm_str
 	return CONT_PTES;
 }
 
+/*
+ * num_contig_ptes(), set_huge_pte_at() and arch_make_huge_pte() can be
+ * used by non-hugetlbfs(vmalloc) mm code to set multiple huge mappings
+ * at the PTE level.
+ */
 static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
 {
 	int contig_ptes = 1;
@@ -110,6 +115,12 @@ static inline int num_contig_ptes(unsign
 		contig_ptes = CONT_PTES;
 		break;
 	default:
+		if (size > 0 && size < PMD_SIZE &&
+				IS_ALIGNED(size, CONT_PTE_SIZE)) {
+			*pgsize = PAGE_SIZE;
+			contig_ptes = size >> PAGE_SHIFT;
+			break;
+		}
 		WARN_ON(!__hugetlb_valid_size(size));
 	}
 
@@ -359,6 +370,10 @@ pte_t arch_make_huge_pte(pte_t entry, un
 	case CONT_PTE_SIZE:
 		return pte_mkcont(entry);
 	default:
+		if (pagesize > 0 && pagesize < PMD_SIZE &&
+				IS_ALIGNED(pagesize, CONT_PTE_SIZE))
+			return pte_mkcont(entry);
+
 		break;
 	}
 	pr_warn("%s: unrecognized huge page size 0x%lx\n",
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio.patch
mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch
mm-entirely-remove-lru_add_drain-in-do_swap_page.patch
mm-clarify-the-folio_free_swap-for-do_swap_page.patch
arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch
arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

