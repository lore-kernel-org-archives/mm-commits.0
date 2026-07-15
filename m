Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4926D4EA365
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784140385; cv=none; b=CFowW1qVnV6N1HPmx1IWjEDuoMrq/fvBrg1JUNDbhpLqrcGZ/nJmtfDW9c8F/qKbYZ+8nmmov6x313aI+EUiP0C/uKJJ2M1+kyM/elzpeCajuVhiK3vwgsZ6aDe1v1ZEMmnHhsLAZOxm+HhWtgKInoDaI+NHKrHRHwiX4/JHuN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784140385; c=relaxed/simple;
	bh=15dNgSOdzJ64zwPXsPrIJt3f7AQOG5SkraryivSqQm0=;
	h=Date:To:From:Subject:Message-Id; b=vGHEtA4TM6MpXaF9Y8mtB0D7trEyN7QMptRfp5xE0bgHsm6X5fknwpsfLquc60n3/e76/1GxlM1F9SC8xg34S0Xlx3zD6qwdZt4G+D3hp0rXUIgnwxfB97eYYZPVYt13WrTy/YMXdxBClNksSBrdr41KA/DgVWzyoy93QVYI6sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FQRcW9YW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FQRcW9YW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBC31F000E9;
	Wed, 15 Jul 2026 18:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784140372;
	bh=ZMiMjZclxJrX8CQIM418ea0uoN6Z7hDnJtX3wOpMd0Q=;
	h=Date:To:From:Subject;
	b=FQRcW9YWaGf1TH7Jw4GiJ/6hr+YgOJiar3JnNA9ZtRrkGeSZGxERQcBcCmQn73usc
	 e3oI1BUFRjN5u3mnxsuxG1zAqOyAG50+6RQyZUXAys9PIeiBGvXO5ArSAo9jw5S14l
	 GnMLwbkz6mesSlPKjpDPdvXTPNxZ/I/jOJP0i9Fs=
Date: Wed, 15 Jul 2026 11:32:51 -0700
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch removed from -mm tree
Message-Id: <20260715183251.DCBC31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/hugetlb: extend batching of multiple CONT_PTE in a single PTE setup
has been removed from the -mm tree.  Its filename was
     arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: arm64/hugetlb: extend batching of multiple CONT_PTE in a single PTE setup
Date: Thu, 9 Jul 2026 15:38:18 +0800

Patch series "mm/vmalloc: Speed up ioremap, vmalloc and vmap with
contiguous memory", v6.

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
mapping logic between the ioremap and vmalloc/vmap paths, handling both
CONT_PTE and regular PTE mappings.  This prepares for the next patch.

Patch 4 extends the page table walk path to support page shifts other than
PAGE_SHIFT and eliminates the page table rewalk for huge vmalloc mappings.
The function is renamed from vmap_small_pages_range_noflush() to
vmap_pages_range_noflush_walk().

Patches 5-6 add huge vmap support for contiguous pages, including support
for non-compound pages with pfn alignment verification.

On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and the
performance CPUfreq policy enabled, benchmark results:

* ioremap(1 MB): 1.35x faster (3407 ns -> 2526 ns)
* vmalloc(1 MB) mapping time (excluding allocation) with
  VM_ALLOW_HUGE_VMAP: 1.42x faster (5.00 us -> 3.53us)
* vmap(100MB) with order-8 pages: 8.3x faster (1235 us -> 149 us)

Many thanks to Xueyuan Chen for his testing efforts on RK3588 boards.

Large vmap() mappings were also tested by Leo Yan with ARM trace buffer
units, including TRBE and SPE.  These units use the CPU page tables for
address translation when writing trace data to DRAM, so using larger
vmap() mapping granules can reduce TLB pressure on the trace writer.

The TRBE test used a 1G CoreSight ETM AUX buffer.  Across five runs on an
isolated CPU, the average results were:

* dtlb_walk:       68.4 -> 59.4 (-13.16%)
* l1d_tlb_refill: 155.8 -> 119.6 (-23.23%)
* l2d_tlb_refill: 161435.8 -> 495.0 (-99.69%)

The SPE test used a 512M ARM SPE AUX buffer.  Across five runs on an
isolated CPU, the average results were:

* dtlb_walk:       1710.4 -> 1315.6 (-23.08%)
* l1d_tlb_refill: 16000.0 -> 15950.2 (-0.31%)
* l2d_tlb_refill: 4796.0 -> 2931.2 (-38.88%)

These results show that enabling larger vmap() mappings can materially
reduce page table walks and TLB refills for large trace buffers.

Many thanks to Leo Yan for his testing efforts on ARM trace buffers.


This patch (of 6):

For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE, we can
handle CONT_PTE_SIZE groups together.

Link: https://lore.kernel.org/20260709073823.6643-1-jiangwen6@xiaomi.com
Link: https://lore.kernel.org/20260709073823.6643-2-jiangwen6@xiaomi.com
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

 arch/arm64/mm/hugetlbpage.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/arm64/mm/hugetlbpage.c~arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -110,6 +110,12 @@ static inline int num_contig_ptes(unsign
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
 
@@ -359,6 +365,10 @@ pte_t arch_make_huge_pte(pte_t entry, un
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
arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

