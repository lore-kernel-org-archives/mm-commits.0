Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCE53043CF
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 02:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782356247; cv=none; b=IYFAaTL6lj7mZKC9HVI+lK5p+u9nFvKZYFWabpUn32hWmPkdf9goF6n5oiPj988zCpXlsDYQ2v7NB+EE4QsPE/ESxhdLsLC2d7Zq2p/rQsSp31yVj7OimmB6FmmQlbUAUWr1G69nFYc11LjYS79XoI8OhjtJcHQsnoNO1TuxbgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782356247; c=relaxed/simple;
	bh=e2WwtREaAAf66A1w4ur8pj8T86fxOZffDObTsd/Ns8Q=;
	h=Date:To:From:Subject:Message-Id; b=UeK7ou0ZvyGyV+zNdhqCza1TiS10gO2zvOQC9KVNqxUpDLVICSbaYc71tBcldYK23jBg5nV8z4a4lXMBA+C76UgSgpcvj6R9xSie5Z+vJIcbKRQsnFXlCPYWRcJET04uA8Cc25TH8fSTMCGt0UfiC7M9M7kYqIe8PfvYlGcCi5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LElCwPqq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LElCwPqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187961F000E9;
	Thu, 25 Jun 2026 02:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782356246;
	bh=26NLcJL0gUI/qMDYpfN/EdeDf1So/tF5QVQYYGXRSmc=;
	h=Date:To:From:Subject;
	b=LElCwPqqquH6Ago1EKO9KtxrvtJVw832jAfpVh5K1Mk9meu0r/6E5LCsL8i4fidQR
	 lTjmyPB76qFSuWVouM3ihMXpH4VgLCXy330WaWx7BtuKLKvkrd+s2q/1nH7f0cZtZp
	 wHKmBnZgcXuFZ+hKeb490d2lv4ACxxdslpbAgXNI=
Date: Wed, 24 Jun 2026 19:57:25 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,jiangwenxiaomi@gmail.com,jiangwen6@xiaomi.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,anshuman.khandual@arm.com,ajd@linux.ibm.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch added to mm-new branch
Message-Id: <20260625025726.187961F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/hugetlb: extend batching of multiple CONT_PTE in a single PTE setup
has been added to the -mm mm-new branch.  Its filename is
     arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Thu, 18 Jun 2026 16:47:21 +0800

Patch series "mm/vmalloc: Speed up ioremap, vmalloc and vmap with
contiguous memory", v4.

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


This patch (of 6):

For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE, we can
handle CONT_PTE_SIZE groups together.

Link: https://lore.kernel.org/20260618084726.1070022-1-jiangwen6@xiaomi.com
Link: https://lore.kernel.org/20260618084726.1070022-2-jiangwen6@xiaomi.com
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
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
+			contig_ptes = size >> PAGE_SHIFT;
+			*pgsize = PAGE_SIZE;
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

arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch
arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

