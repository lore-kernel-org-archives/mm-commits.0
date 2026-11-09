Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794255071;
	b=d/3Bf7ZeRafade4ejQ3Q0AE2xys2Y8t5rZETS9sUViiKv4vFxWvPlUS0V6tGe7kdfZE4
	 kkPUczx0ofDxnMbTBSx0JCsFw3g065fE0Yu1uJB3AQF/lF13qZOhJBV5x9KMwU9piepDs
	 B1MkZjwWJ0dfN3TZe/h1bAA/AfMvj1XzFb1vf2gTxebxsRPVdDnsc6Ooj0XER/E6IqUkJ
	 F+5MZL1qFrmk/MQ47OMlFUHdc0aBDofrjG82Cz9wHjntPhJI4IeCTcKCa3xEZ7Esf6lxj
	 jC9ePASAeAILzo6IdFFBgLj2U4nRlqmZgE9kTIhCTNrNtEEPkeOJ62fsUb0RdKl/TtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794255071;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=1nYRFZEc5Zk/CqC6RYJ964332nRTekCoBJXDzcsnpWI=;
	b=G9FVKdkhtUspmveAqjvjNU5bN+BSIQOOaM5xYdgzWK6g9Jb8vZCplTPokUpzBkFQwbMF
	 bqhlCrBBTPTkpBuwwsW/Bz4MgoT2hk4h83GhSvlkCAjFpf1tN3XntYwB0LaIDkCS17rxY
	 XXGjCWS5IQ2f0n0b4AN7cQw0bdLg/fjri4fj14UO276BSAeGxTrRKfcjndkY8cYX+ew2C
	 23tJKW95XyyIYgvywPB27Hozn/fq07EjgTHVYAfoWUjeSkZZqS+HbovCnEcXwssiDeDdC
	 fFnzWLZl+cD4iPh11Hgeb+4XXeMVZ6TA/CRO2IusQehOy+OQQVQAfJsj2vMtrAtoaKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uQxAxZho;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FA6606A330;
	Mon,  9 Nov 2026 20:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uQxAxZho
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D07D1F0089F;
	Mon,  9 Nov 2026 20:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794255070;
	bh=1nYRFZEc5Zk/CqC6RYJ964332nRTekCoBJXDzcsnpWI=;
	h=Date:To:From:Subject;
	b=uQxAxZhoD4MFengtdUkyNQHHfkl/h8mmVTfuXqH7sPOIbkxQOa/dq0KrvXtAVM8vZ
	 QEy1qkHlfvHas+xbCFhqJZrzPOEL4MMn/eZw+ngRD/pTXW5BZxEo2ETUzQaTxKH+Ld
	 u8gu1akB0QXzQlekcU45zVt4lILWwYeUcj+fNBuI=
Date: Mon, 09 Nov 2026 12:11:10 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,
	stable@vger.kernel.org,ryan.roberts@arm.com,qi.zheng@linux.dev,
	nico.pache@linux.dev,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,
	hughd@google.com,dev.jain@arm.com,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-dont-allocate-a-page-table-under-rcu-in-do_set_pmd.patch removed from -mm tree
Message-Id: <20261109201110.6D07D1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: don't allocate a page table under RCU in do_set_pmd()
has been removed from the -mm tree.  Its filename was
     mm-dont-allocate-a-page-table-under-rcu-in-do_set_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: don't allocate a page table under RCU in do_set_pmd()
Date: Fri, 06 Nov 2026 13:36:13 +0100

do_fault_around() skips PTE table preallocation when the PMD already
points to a PTE table.  A concurrent collapse can then retract that table
and clear the PMD before filemap_map_pages() locks the new PMD-sized
folio.

filemap_map_pmd() can then call do_set_pmd() with an empty PMD and no
preallocated table.  On PowerPC hash MMU, do_set_pmd() then tries
allocating a PTE table to deposit.  But filemap_map_pmd() calls
do_set_pmd() under RCU, so allocating from that context is not good.

This race became possible when retract_page_tables() stopped taking the
mmap and VMA locks.  Previously, those locks excluded retraction while the
fault was in progress.

Add a may_alloc argument to do_set_pmd() and pass false from
filemap_map_pmd(), so we can fail with VM_FAULT_FALLBACK instead of trying
to allocate.

This issue should be fairly hard to hit in practice.

Link: https://lore.kernel.org/20261106-khugepaged_set_pmd-v2-2-d2457b5e377a@kernel.org
Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
---

 include/linux/mm.h |    3 ++-
 mm/filemap.c       |    2 +-
 mm/khugepaged.c    |    2 +-
 mm/memory.c        |   10 +++++++---
 4 files changed, 11 insertions(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-dont-allocate-a-page-table-under-rcu-in-do_set_pmd
+++ a/include/linux/mm.h
@@ -2180,7 +2180,8 @@ static inline pte_t maybe_mkwrite(pte_t
 	return pte;
 }
 
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page);
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page,
+		bool may_alloc);
 void set_pte_range(struct vm_fault *vmf, struct folio *folio,
 		struct page *page, unsigned int nr, unsigned long addr);
 
--- a/mm/filemap.c~mm-dont-allocate-a-page-table-under-rcu-in-do_set_pmd
+++ a/mm/filemap.c
@@ -3749,7 +3749,7 @@ static bool filemap_map_pmd(struct vm_fa
 
 	if (pmd_none(*vmf->pmd) && folio_test_pmd_mappable(folio)) {
 		struct page *page = folio_file_page(folio, start);
-		vm_fault_t ret = do_set_pmd(vmf, folio, page);
+		vm_fault_t ret = do_set_pmd(vmf, folio, page, /* may_alloc= */ false);
 		if (!ret) {
 			/* The page is mapped successfully, reference consumed. */
 			folio_unlock(folio);
--- a/mm/khugepaged.c~mm-dont-allocate-a-page-table-under-rcu-in-do_set_pmd
+++ a/mm/khugepaged.c
@@ -1827,7 +1827,7 @@ static enum scan_result set_huge_pmd(str
 	}
 
 	vmf.pmd = pmdp;
-	if (do_set_pmd(&vmf, folio, page))
+	if (do_set_pmd(&vmf, folio, page, /* may_alloc= */ true))
 		return SCAN_FAIL;
 
 	folio_get(folio);
--- a/mm/memory.c~mm-dont-allocate-a-page-table-under-rcu-in-do_set_pmd
+++ a/mm/memory.c
@@ -5689,7 +5689,8 @@ static void deposit_prealloc_pte(struct
 	vmf->prealloc_pte = NULL;
 }
 
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page,
+		bool may_alloc)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
@@ -5730,6 +5731,8 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	 * related to pte entry. Use the preallocated table for that.
 	 */
 	if (arch_needs_pgtable_deposit() && !vmf->prealloc_pte) {
+		if (!may_alloc)
+			return VM_FAULT_FALLBACK;
 		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
@@ -5771,7 +5774,8 @@ out:
 	return ret;
 }
 #else
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page,
+		bool may_alloc)
 {
 	return VM_FAULT_FALLBACK;
 }
@@ -5895,7 +5899,7 @@ fallback:
 
 	if (pmd_none(*vmf->pmd)) {
 		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
-			ret = do_set_pmd(vmf, folio, page);
+			ret = do_set_pmd(vmf, folio, page, /* may_alloc= */ true);
 			if (ret != VM_FAULT_FALLBACK)
 				return ret;
 		}
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch
mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch

