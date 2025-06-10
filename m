Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD1923AB9C
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 21:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749590246; cv=none; b=cTASI510obaMrYdRyu/mgyaOBFP7pkFlcn8fj3hAn2Vtdl46vzYxhRhwYTI/AhLfrFqUhGqHBBA+AWoM/gPJcjBkt9mmxwnN+D5m5G0rW1CAYjkxd8Et7G5Fixad+CX0sa3v6gvgqPX0KaHViIYrhg/y/J2nLzHp4udngea2ltM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749590246; c=relaxed/simple;
	bh=WfRUnYXo3r7XvqCAPWvrss7QaJG5pRSQA3u/eRIjNjU=;
	h=Date:To:From:Subject:Message-Id; b=dGtoGVlypEb3zKDF3oJ5ha4Es9VUJaxa4TVwpR7+nZk2j6PRQ6eiO3cdQcG7uyl4Nx+cj5O/BWWXBiWMXDyyPnRGOM0BpkK/zimFZMfu/D1Hb3KhwOxNsNeLqhYvb7/Fda0VOIDRoN6sf5uO0Cnu2j3Jl28wFsvvKIVVfWjQJuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yvq3mSJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yvq3mSJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E03FC4CEED;
	Tue, 10 Jun 2025 21:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749590246;
	bh=WfRUnYXo3r7XvqCAPWvrss7QaJG5pRSQA3u/eRIjNjU=;
	h=Date:To:From:Subject:From;
	b=yvq3mSJ+K3PV6cKINU6St/6an3WurgYSgneLRD9x2yd9ysVlF5Vq4wH2khnl6mmx2
	 DYSCLJwSfR+UJ8L4KCPxhqCyZ+7tgw3zmB84InTcJzycA/9pv4PsdF6vvtls5AcYQY
	 oV6xlogJme8qQsDnnxmBxrM5jwcjFfnERX8RL5es=
Date: Tue, 10 Jun 2025 14:17:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,willy@infradead.org,vbabka@suse.cz,ryan.roberts@arm.com,peterx@redhat.com,mingo@kernel.org,maobibo@loongson.cn,lorenzo.stoakes@oracle.com,libang.li@antgroup.com,liam.howlett@oracle.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-call-pointers-to-ptes-as-ptep.patch added to mm-new branch
Message-Id: <20250610211726.1E03FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: call pointers to ptes as ptep
has been added to the -mm mm-new branch.  Its filename is
     mm-call-pointers-to-ptes-as-ptep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-call-pointers-to-ptes-as-ptep.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm: call pointers to ptes as ptep
Date: Tue, 10 Jun 2025 09:20:42 +0530

Patch series "Optimize mremap() for large folios", v4.

Currently move_ptes() iterates through ptes one by one.  If the underlying
folio mapped by the ptes is large, we can process those ptes in a batch
using folio_pte_batch(), thus clearing and setting the PTEs in one go. 
For arm64 specifically, this results in a 16x reduction in the number of
ptep_get() calls (since on a contig block, ptep_get() on arm64 will
iterate through all 16 entries to collect a/d bits), and we also elide
extra TLBIs through get_and_clear_full_ptes, replacing ptep_get_and_clear.

Mapping 1M of memory with 64K folios, memsetting it, remapping it to src +
1M, and munmapping it 10,000 times, the average execution time reduces
from 1.9 to 1.2 seconds, giving a 37% performance optimization, on Apple
M3 (arm64).  No regression is observed for small folios.

Test program for reference:

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <string.h>
#include <errno.h>

#define SIZE (1UL << 20) // 1M

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

Link: https://lkml.kernel.org/r/20250610035043.75448-1-dev.jain@arm.com
Link: https://lkml.kernel.org/r/20250610035043.75448-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: bibo mao <maobibo@loongson.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/mm/mremap.c~mm-call-pointers-to-ptes-as-ptep
+++ a/mm/mremap.c
@@ -218,7 +218,8 @@ static int move_ptes(struct pagetable_mo
 	struct vm_area_struct *vma = pmc->old;
 	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct mm_struct *mm = vma->vm_mm;
-	pte_t *old_pte, *new_pte, pte;
+	pte_t *old_ptep, *new_ptep;
+	pte_t pte;
 	pmd_t dummy_pmdval;
 	spinlock_t *old_ptl, *new_ptl;
 	bool force_flush = false;
@@ -252,8 +253,8 @@ static int move_ptes(struct pagetable_mo
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
@@ -264,10 +265,10 @@ static int move_ptes(struct pagetable_mo
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
@@ -276,14 +277,14 @@ static int move_ptes(struct pagetable_mo
 	flush_tlb_batched_pending(vma->vm_mm);
 	arch_enter_lazy_mmu_mode();
 
-	for (; old_addr < old_end; old_pte++, old_addr += PAGE_SIZE,
-				   new_pte++, new_addr += PAGE_SIZE) {
-		VM_WARN_ON_ONCE(!pte_none(*new_pte));
+	for (; old_addr < old_end; old_ptep++, old_addr += PAGE_SIZE,
+				   new_ptep++, new_addr += PAGE_SIZE) {
+		VM_WARN_ON_ONCE(!pte_none(*new_ptep));
 
-		if (pte_none(ptep_get(old_pte)))
+		if (pte_none(ptep_get(old_ptep)))
 			continue;
 
-		pte = ptep_get_and_clear(mm, old_addr, old_pte);
+		pte = ptep_get_and_clear(mm, old_addr, old_ptep);
 		/*
 		 * If we are remapping a valid PTE, make sure
 		 * to flush TLB before we drop the PTL for the
@@ -301,7 +302,7 @@ static int move_ptes(struct pagetable_mo
 		pte = move_soft_dirty_pte(pte);
 
 		if (need_clear_uffd_wp && pte_marker_uffd_wp(pte))
-			pte_clear(mm, new_addr, new_pte);
+			pte_clear(mm, new_addr, new_ptep);
 		else {
 			if (need_clear_uffd_wp) {
 				if (pte_present(pte))
@@ -309,7 +310,7 @@ static int move_ptes(struct pagetable_mo
 				else if (is_swap_pte(pte))
 					pte = pte_swp_clear_uffd_wp(pte);
 			}
-			set_pte_at(mm, new_addr, new_pte, pte);
+			set_pte_at(mm, new_addr, new_ptep, pte);
 		}
 	}
 
@@ -318,8 +319,8 @@ static int move_ptes(struct pagetable_mo
 		flush_tlb_range(vma, old_end - len, old_end);
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
-	pte_unmap(new_pte - 1);
-	pte_unmap_unlock(old_pte - 1, old_ptl);
+	pte_unmap(new_ptep - 1);
+	pte_unmap_unlock(old_ptep - 1, old_ptl);
 out:
 	maybe_drop_rmap_locks(pmc);
 	return err;
_

Patches currently in -mm which might be from dev.jain@arm.com are

xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch
mm-call-pointers-to-ptes-as-ptep.patch
mm-optimize-mremap-by-pte-batching.patch

