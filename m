Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523BC34B697
	for <mm-commits@vger.kernel.org>; Sat,  8 Aug 2026 16:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786208286; cv=none; b=uHGRLDlUCnUeLIofu7TjOkDqwah1MTvliccDN/NVsJ0dRrJgxRTQl9PXRWCkDuR/89771A6BtiLWw7n4wwxP60nTJcK0AFbxw+uoQizqF7XLL36DE3Gh+O561wlTgkGv0UgVWZjvYPqJVXPf2O9W8+AW/0qj8V8z3JgvpHypFbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786208286; c=relaxed/simple;
	bh=Kk5YiWZ2eySqt+HhFXuquUY34TSfMH+ZRDxfVgg8oCM=;
	h=Date:To:From:Subject:Message-Id; b=Hewc8H03QpN4MzCfbS7qbxTHOMtI4zSzdc6EUUi9zdMGw1SywNGGUy8KLQlqLYD1rW2bTD4Eg/R59lvEPGugpRnDSZm8k1xDALBKZ/Y0dO5KpudQAsi6x62XaLCNCsy5hmuE22BsD3Mk6M7MSqUZyrvXs+EkT/uZ12f386jz3Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yza7m0Bf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yza7m0Bf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE55F1F00A3A;
	Sat,  8 Aug 2026 16:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786208285;
	bh=sjekwqUKF02bf+s7Wdc4xMBtUA5owHx3K/W2Iq8oqc4=;
	h=Date:To:From:Subject;
	b=yza7m0BfjYXyS8cM7S97TyaB9i6yGHOkJ79thVRzyEenWHnbsmIyYqdKkkb7sT4dv
	 6t2Z0jWux1cvsJ84mg2rUM1gvdfUZWY7VyWQTgQCTGIYZWUQi5mUqeVtMUHPCrl2qg
	 Sor0OmvmtdwKDWmjNCKnqqQ8Gp9+R3K+mpw/jfw4=
Date: Sat, 08 Aug 2026 09:58:04 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,leo.yan@arm.com,jiangwenxiaomi@gmail.com,jiangwen6@xiaomi.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,anshuman.khandual@arm.com,ajd@linux.ibm.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch removed from -mm tree
Message-Id: <20260808165804.EE55F1F00A3A@smtp.kernel.org>
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

arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

