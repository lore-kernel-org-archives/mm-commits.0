Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795550454;
	b=UcDf4KbSQRtt1hHBeJ75JTAGA63D1IEkATALZBnn08ZlzxSgRzF5O3GEWs3fTvo3JsNu
	 OvIiTvP7TuqE5/UMEvuPLki1400qX20/dr9tjjAKERB956b2oUfHS5AkviB7EeMMHpuld
	 WKh4G+2YENMjstapbeHFKz4r7wPgDHj+pLthJs8hbSwWRjo63Llqwy/9rcF9aQq5wXihS
	 hjcFypgHp6nBBTmij/L3xXsfpxYJJxFbZsNJixN1udPRoXLE/8lhZh3mWiEmFp5j0yrYf
	 UchgwOG/x77MCKkPS08O73kykMG8P+lRrNNI6T6KtLupgls05qLajxvZ6NLiuM0StRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795550454;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=7lRWmlzPyJE22IVPZSA9OFki5MY2r+pzTxqXruhBxUA=;
	b=O0Sxixw7AtBi/P8bEBpksl8IqFMhB76D+TSEnYurymGVK4qf8niYZjUIy9syK/zCzNbL
	 uzIlkurNPoXQNQt1u87ctc/6vXH5SrJpSVp54SWPCPYEJ4RAJxrCujb0M0wrr25X91/jn
	 4QsBKEaCsdPi2FayIB8MuqxhXzNAMR1uq7EKydRgrKFxFF9OnKHbRQ9tcZBJ2f4RVpj7V
	 d858OKqooh2v0P6K3Y3EnIVqwYtzqPTZ3jWhCzTJzmH7eI2oEY5a50I4vQ6MAKT2Fe7Zm
	 Ya14Muco75JZBI0a38z1eYEnLcLMukTZ2l4fyWgIvhjK5C/7hLfCUTFSbBskkohFMQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="zxtp2/zJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48045606A31E;
	Tue, 24 Nov 2026 20:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zxtp2/zJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018801F000C6;
	Tue, 24 Nov 2026 20:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795550454;
	bh=7lRWmlzPyJE22IVPZSA9OFki5MY2r+pzTxqXruhBxUA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=zxtp2/zJl/AlBJo206VlaVbHGF9zLL0NH2W6NRZUD7PaU/PJafknxiU4IpMRwMCnq
	 HhaOL5vmvw8Tmfb+LNEGsoWm8ZewUZBJh1WSXbUlyjTdNbCDxymh/GuzancIyckFRV
	 de4sc2Y7UWDalgwVTd7j1i+yaSyDW+XEnYSDjzyk=
Date: Tue, 24 Nov 2026 12:00:53 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,
	stable@vger.kernel.org,ryan.roberts@arm.com,qi.zheng@linux.dev,
	nico.pache@linux.dev,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,
	hughd@google.com,dev.jain@arm.com,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <c13cdd25-7d7b-4059-a22d-af0a48fabaac@kernel.org>
References: <c13cdd25-7d7b-4059-a22d-af0a48fabaac@kernel.org>
Subject: [merged mm/core.git: for-next] mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch removed from -mm tree
Message-Id: <20261124200054.018801F000C6@smtp.kernel.org>
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
     mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch

This patch was dropped because it was merged into mm/core.git: for-next

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: free unused page table allocated by do_set_pmd()
Date: Wed, 4 Nov 2026 20:56:37 +0100

do_set_pmd() can allocate vmf->prealloc_pte on architectures that need a
deposited page table, such as PowerPC with the hash MMU.  If the PMD is no
longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
without consuming that table.

Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
userfaultfd operation can install a PTE table before taking the folio
lock.  If that races with set_huge_pmd(), the unused preallocated table is
lost when its local vm_fault goes out of scope.

Track whether do_set_pmd() allocated the table and free it after dropping
the PMD lock if it was not consumed.  Preserve any preallocated table
supplied by the caller for PTE fallback.  Successful PMD installation
consumes the table and clears the pointer.

Returning without a preallocated table matches the existing behavior on
architectures that do not need a deposited table.  All callers already
handle that case.

Link: https://patch.msgid.link/c13cdd25-7d7b-4059-a22d-af0a48fabaac@kernel.org
Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>

 mm/memory.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memory.c~mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails
+++ a/mm/memory.c
@@ -5741,6 +5741,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
+	bool pgtable_allocated = false;
 	pmd_t entry;
 	vm_fault_t ret = VM_FAULT_FALLBACK;
 
@@ -5782,6 +5783,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
+		pgtable_allocated = true;
 	}
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -5812,6 +5814,10 @@ vm_fault_t do_set_pmd(struct vm_fault *v
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

mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch
mm-userfaultfd-prevent-poison-marker-loss.patch
mm-hugetlb-compare-against-persistent-count-when-freeing-lowmem-folios.patch
mm-hugetlb-preserve-reservations-when-shrinking-on-highmem.patch
mm-hugetlb-account-temporary-folios-separately.patch
mm-hugetlb-account-temporary-folios-separately-fix.patch
mm-hugetlb-serialize-page-cache-allocations-with-truncation.patch
mm-hugetlb-serialize-page-cache-allocations-with-truncation-fix.patch
mm-memfd-recheck-the-page-cache-before-allocating-a-hugetlb-folio.patch
mm-hugetlb-count-again-if-the-reserve-map-shrank.patch
mm-hugetlb-account-restored-reservations-before-freeing-folios.patch
mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush.patch
mm-userfaultfd-reject-dax-mappings.patch

