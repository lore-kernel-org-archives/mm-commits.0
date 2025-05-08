Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1CA230BD9
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 23:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746747410; cv=none; b=qRjrNvrWLyHzxaWFBlSvpqawh4XQkxPU94Ao+93xEkg4i+jVSX6Derb50VWa3saVSpmLBRDH/V7+q8QFCUowRjW/iez7k/EKaX0kSP1SOFOkH0t96Ba/Y+2fvAQgenymT+iH+jIyySTEY1f+KR8xwrHYR6bDzhrCbQ4eKN1sNyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746747410; c=relaxed/simple;
	bh=1e8F0S67Lhq11t+oSW4n+1v636V8sCKPt0vUKLgwfdI=;
	h=Date:To:From:Subject:Message-Id; b=O63BGzwCC9MNMEavc9dBpibSdJSI0r6r2YqkZfICPu0BsUlS2UZJl4Tq07PGNUPAXc47JoxbwN8ruDXyxAcMSrwGEK69bDnoXgj8/NJ+1Abh9PNBgOWdjWO+VOel3e5FfhUKeHnEcJd/cBbRcFHRuNYSeKNO8EwDYol/7GQPGD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wgJ9q+3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wgJ9q+3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481FDC4CEEF;
	Thu,  8 May 2025 23:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746747409;
	bh=1e8F0S67Lhq11t+oSW4n+1v636V8sCKPt0vUKLgwfdI=;
	h=Date:To:From:Subject:From;
	b=wgJ9q+3kJscQ4yvvKS9UNgEHTMRqqv8NiOUJ15EtdBXlaEgPNmY6uVewMld10edZk
	 7F8MCx6zHBCbNpE/lvyJOkOXmsTCR/ljfB/YHSerGZ5X75Qdmz4+2lGo8HytYO2PA7
	 C1AS8LMc+gjMMqsp09Hk9KV35DWblPUOx2ntVcOw=
Date: Thu, 08 May 2025 16:36:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,willy@infradead.org,vbabka@suse.cz,ryan.roberts@arm.com,peterx@redhat.com,mingo@kernel.org,maobibo@loongson.cn,lorenzo.stoakes@oracle.com,libang.li@antgroup.com,liam.howlett@oracle.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-call-pointers-to-ptes-as-ptep.patch removed from -mm tree
Message-Id: <20250508233649.481FDC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: call pointers to ptes as ptep
has been removed from the -mm tree.  Its filename was
     mm-call-pointers-to-ptes-as-ptep.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm: call pointers to ptes as ptep
Date: Wed, 7 May 2025 11:32:55 +0530

Patch series "Optimize mremap() for large folios", v2.

Currently move_ptes() iterates through ptes one by one.  If the underlying
folio mapped by the ptes is large, we can process those ptes in a batch
using folio_pte_batch(), thus clearing and setting the PTEs in one go. 
For arm64 specifically, this results in a 16x reduction in the number of
ptep_get() calls (since on a contig block, ptep_get() on arm64 will
iterate through all 16 entries to collect a/d bits), and we also elide
extra TLBIs through get_and_clear_full_ptes, replacing ptep_get_and_clear.

Mapping 512K of memory, memsetting it, remapping it to src + 512K, and
munmapping it 10,000 times, the average execution time reduces from 1.9 to
1.2 seconds, giving a 37% performance optimization, on Apple M3 (arm64).

Test program for reference:

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <string.h>
#include <errno.h>

#define SIZE (1UL << 20) // 512 KB

int main(void) {
    void *new_addr, *addr;

    for (int i = 0; i < 10000; ++i) {
        addr = mmap((void *)(1UL << 30), SIZE, PROT_READ | PROT_WRITE,
                    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (addr == MAP_FAILED) {
                perror("mmap");
                return 1;
        }
        memset(addr, 0xAA, SIZE);

        new_addr = mremap(addr, SIZE, SIZE, MREMAP_MAYMOVE | MREMAP_FIXED, addr + SIZE);
        if (new_addr != (addr + SIZE)) {
                perror("mremap");
                return 1;
        }
        munmap(new_addr, SIZE);
    }

}


This patch (of 2):

Avoid confusion between pte_t* and pte_t data types by suffixing pointer
type variables with p.  No functional change.

Link: https://lkml.kernel.org/r/20250507060256.78278-1-dev.jain@arm.com
Link: https://lkml.kernel.org/r/20250507060256.78278-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: bibo mao <maobibo@loongson.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/mm/mremap.c~mm-call-pointers-to-ptes-as-ptep
+++ a/mm/mremap.c
@@ -176,7 +176,8 @@ static int move_ptes(struct pagetable_mo
 	struct vm_area_struct *vma = pmc->old;
 	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct mm_struct *mm = vma->vm_mm;
-	pte_t *old_pte, *new_pte, pte;
+	pte_t *old_ptep, *new_ptep;
+	pte_t pte;
 	pmd_t dummy_pmdval;
 	spinlock_t *old_ptl, *new_ptl;
 	bool force_flush = false;
@@ -211,8 +212,8 @@ static int move_ptes(struct pagetable_mo
 	 * We don't have to worry about the ordering of src and dst
 	 * pte locks because exclusive mmap_lock prevents deadlock.
 	 */
-	old_pte = pte_offset_map_lock(mm, old_pmd, old_addr, &old_ptl);
-	if (!old_pte) {
+	old_ptep = pte_offset_map_lock(mm, old_pmd, old_addr, &old_ptl);
+	if (!old_ptep) {
 		err = -EAGAIN;
 		goto out;
 	}
@@ -223,10 +224,10 @@ static int move_ptes(struct pagetable_mo
 	 * mmap_lock, so this new_pte page is stable, so there is no need to get
 	 * pmdval and do pmd_same() check.
 	 */
-	new_pte = pte_offset_map_rw_nolock(mm, new_pmd, new_addr, &dummy_pmdval,
+	new_ptep = pte_offset_map_rw_nolock(mm, new_pmd, new_addr, &dummy_pmdval,
 					   &new_ptl);
-	if (!new_pte) {
-		pte_unmap_unlock(old_pte, old_ptl);
+	if (!new_ptep) {
+		pte_unmap_unlock(old_ptep, old_ptl);
 		err = -EAGAIN;
 		goto out;
 	}
@@ -235,12 +236,12 @@ static int move_ptes(struct pagetable_mo
 	flush_tlb_batched_pending(vma->vm_mm);
 	arch_enter_lazy_mmu_mode();
 
-	for (; old_addr < old_end; old_pte++, old_addr += PAGE_SIZE,
-				   new_pte++, new_addr += PAGE_SIZE) {
-		if (pte_none(ptep_get(old_pte)))
+	for (; old_addr < old_end; old_ptep++, old_addr += PAGE_SIZE,
+				   new_ptep++, new_addr += PAGE_SIZE) {
+		if (pte_none(ptep_get(old_ptep)))
 			continue;
 
-		pte = ptep_get_and_clear(mm, old_addr, old_pte);
+		pte = ptep_get_and_clear(mm, old_addr, old_ptep);
 		/*
 		 * If we are remapping a valid PTE, make sure
 		 * to flush TLB before we drop the PTL for the
@@ -258,7 +259,7 @@ static int move_ptes(struct pagetable_mo
 		pte = move_soft_dirty_pte(pte);
 
 		if (need_clear_uffd_wp && pte_marker_uffd_wp(pte))
-			pte_clear(mm, new_addr, new_pte);
+			pte_clear(mm, new_addr, new_ptep);
 		else {
 			if (need_clear_uffd_wp) {
 				if (pte_present(pte))
@@ -266,7 +267,7 @@ static int move_ptes(struct pagetable_mo
 				else if (is_swap_pte(pte))
 					pte = pte_swp_clear_uffd_wp(pte);
 			}
-			set_pte_at(mm, new_addr, new_pte, pte);
+			set_pte_at(mm, new_addr, new_ptep, pte);
 		}
 	}
 
@@ -275,8 +276,8 @@ static int move_ptes(struct pagetable_mo
 		flush_tlb_range(vma, old_end - len, old_end);
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
-	pte_unmap(new_pte - 1);
-	pte_unmap_unlock(old_pte - 1, old_ptl);
+	pte_unmap(new_ptep - 1);
+	pte_unmap_unlock(old_ptep - 1, old_ptl);
 out:
 	if (pmc->need_rmap_locks)
 		drop_rmap_locks(vma);
_

Patches currently in -mm which might be from dev.jain@arm.com are

mempolicy-optimize-queue_folios_pte_range-by-pte-batching.patch
mm-optimize-mremap-by-pte-batching.patch

