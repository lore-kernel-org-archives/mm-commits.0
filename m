Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794255070;
	b=0gVVuPlaeMFPYzaNinauYGopAtXKswoGdxvSLsDreDArpGdY2ZLiExrM/zG5oDCo1GsL
	 gRXELP0Q65HryEK77YY343x+okE0dVjePnAZVzWgmFWhRIgYY0fmrDbbDyPv15ImXgZWt
	 Dx6qtBc1hlAml5WeaxBUv3v/qBYvMvWI263fUCCRY1BqyeJ/8erQOVb+7ysQBHX7pN2U5
	 oKKdZr9y3FlePC7MXVHahD1Gaey8oqwmPqCTTiS+cihJDv72scoS+2CGtzb4kUy8e/Cmo
	 jA3EaoiTePUa7ODV2AxkeFRiCUZM0su5NqCeiGDymfctaD4JRi6xxNy0HyrWESJPXRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794255070;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Fx4s1z13P92VnOyrby5wrsCNngXGwLDXYMxGP/UfWZU=;
	b=JHUj4rXNoWT7fuUMCKI7gizY38+Rv7RQYg3iSW+yIbcZBBS4n7oSE4nT5nVvutCqrtpA
	 GhPe5tO4I1+3hsMWXLp1g+0w9dZ33GbMXu2dU3XrnCmvfg2RcFXvHh089hJYseeCFY2aS
	 KaJmUiSUXuUBKSNppJOBX+b7yhNsmsVHOmT6SlPSTbmB2kfnv+n3d60T3lGiIv17sYYxV
	 gm1yf4nKebx1JKAT9VI1/HIMtufSshJkqOFamUgraSloWvqNONjasmXVFc+0NqHNKjzRV
	 5hPGVCPXbdMbBsCB7kbUCWnR7xaHPODwSLpItlpz5Lt4S8cC3tW8+7om6fpJIBo+/2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yUeI93vf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE594606A31C;
	Mon,  9 Nov 2026 20:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yUeI93vf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C34B1F0089F;
	Mon,  9 Nov 2026 20:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794255069;
	bh=Fx4s1z13P92VnOyrby5wrsCNngXGwLDXYMxGP/UfWZU=;
	h=Date:To:From:Subject;
	b=yUeI93vfME0HdWCfAK85vSot3rnaSQ52d7Q1F3Znu59EGiVw4QbVN77DL68FtMQVr
	 YjtZp3DkfnnQoTrglGRhGl2bIAex5+Ta52nCd0K0UsGScpfF3FUyF6d2DfQXqgPBb+
	 SCFhVEWd0ESl87RNWZGC77yuNVPDIdSuSTf//0NI=
Date: Mon, 09 Nov 2026 12:11:08 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,
	stable@vger.kernel.org,ryan.roberts@arm.com,qi.zheng@linux.dev,
	nico.pache@linux.dev,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,
	hughd@google.com,dev.jain@arm.com,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-free-unused-page-table-allocated-by-do_set_pmd.patch removed from -mm tree
Message-Id: <20261109201109.4C34B1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: free unused page table allocated by do_set_pmd()
has been removed from the -mm tree.  Its filename was
     mm-free-unused-page-table-allocated-by-do_set_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: free unused page table allocated by do_set_pmd()
Date: Fri, 06 Nov 2026 13:36:12 +0100

Patch series "mm: free unused page table allocated by do_set_pmd()", v2.


This patch (of 2):

do_set_pmd() can allocate vmf->prealloc_pte on architectures that need a
deposited page table, such as PowerPC with the hash MMU. If the PMD is
no longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
without consuming that table.

Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
userfaultfd operation can install a PTE table before taking the folio
lock. If that races with set_huge_pmd(), the unused preallocated table
is lost when its local vm_fault goes out of scope.

Track whether do_set_pmd() allocated the table and free it after dropping
the PMD lock if it was not consumed. Preserve any preallocated table
supplied by the caller for PTE fallback. Successful PMD installation
consumes the table and clears the pointer.

Returning without a preallocated table matches the existing behavior on
architectures that do not need a deposited table. All callers
already handle that case.

Link: https://lore.kernel.org/20261106-khugepaged_set_pmd-v2-0-d2457b5e377a@kernel.org
Link: https://lore.kernel.org/20261106-khugepaged_set_pmd-v2-1-d2457b5e377a@kernel.org
Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/memory.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memory.c~mm-free-unused-page-table-allocated-by-do_set_pmd
+++ a/mm/memory.c
@@ -5694,6 +5694,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
+	bool pgtable_allocated = false;
 	pmd_t entry;
 	vm_fault_t ret = VM_FAULT_FALLBACK;
 
@@ -5732,6 +5733,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
+		pgtable_allocated = true;
 	}
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -5762,6 +5764,10 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	count_vm_event(THP_FILE_MAPPED);
 out:
 	spin_unlock(vmf->ptl);
+	if (pgtable_allocated && vmf->prealloc_pte) {
+		pte_free(vma->vm_mm, vmf->prealloc_pte);
+		vmf->prealloc_pte = NULL;
+	}
 	return ret;
 }
 #else
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch
mm-dont-allocate-a-page-table-under-rcu-in-do_set_pmd.patch
mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch

