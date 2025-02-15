Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FB74430
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 00:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739578280; cv=none; b=re9cFlS6sEUGAkEYhBawDNkQr2fSCeGnG0BnTiLhAfp4BEDN6zjMwuLdvL7URPeW1/q7l+ctdm1RDHsm6E+yPALkNLX3+uMenpOBohVUVxhpFPOnTtqr+q9tk3OCR0WTZI4gXMogABgJvXUZFWLXnJHNJTKSRKW6+aDLDFZVgTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739578280; c=relaxed/simple;
	bh=F+RN2c3ztRZrPX4jsGhUsfMGaz6/oureo9om7sbLqWU=;
	h=Date:To:From:Subject:Message-Id; b=dblAo+450RNIrpepgY28XNGVymdbvidxLHiPCOSEKNF2e+zwixU3VQJ4N2/Q0tqb3BXSRuepQWGCooiuxfsyEh+poUNm/kaU2ZOxGlTYJtzEyNN1Y+dJ4KpF6BIUJhVd03JzqXkLB4zLtFubk5B1Tvi+I/XhXaJ/l+gr7CQIQ7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jTI0LR1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jTI0LR1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32D8C4CEE2;
	Sat, 15 Feb 2025 00:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739578280;
	bh=F+RN2c3ztRZrPX4jsGhUsfMGaz6/oureo9om7sbLqWU=;
	h=Date:To:From:Subject:From;
	b=jTI0LR1z8wamfq9sXv959a0FN+4Wpy+6NdNIMhR0pJOJQFS4LOCzsDoFmmd5txzWx
	 mJ3YKoyNAVrQrm+BTP03O/vV7FJ5WFY1Um4YgAZ7pCOFs8oUuHe91FMf5obpaWmdmE
	 v+gvbF9toJJ25x583c0oERo9a/wrOjz9Drz3yIK4=
Date: Fri, 14 Feb 2025 16:11:19 -0800
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,yosryahmed@google.com,ying.huang@intel.com,yangyicong@hisilicon.com,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shahuang@redhat.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,mingo@redhat.com,mfo@canonical.com,mark.rutland@arm.com,lorenzo.stoakes@oracle.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,ioworker0@gmail.com,hpa@zytor.com,gshan@redhat.com,david@redhat.com,dave.hansen@linux.intel.com,chrisl@kernel.org,catalin.marinas@arm.com,bp@alien8.de,baolin.wang@linux.alibaba.com,aou@eecs.berkeley.edu,anshuman.khandual@arm.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-avoid-splitting-pmd-for-lazyfree-pmd-mapped-thp-in-try_to_unmap.patch added to mm-unstable branch
Message-Id: <20250215001119.F32D8C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: avoid splitting pmd for lazyfree pmd-mapped THP in try_to_unmap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-avoid-splitting-pmd-for-lazyfree-pmd-mapped-thp-in-try_to_unmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-avoid-splitting-pmd-for-lazyfree-pmd-mapped-thp-in-try_to_unmap.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: avoid splitting pmd for lazyfree pmd-mapped THP in try_to_unmap
Date: Fri, 14 Feb 2025 22:30:15 +1300

The try_to_unmap_one() function currently handles PMD-mapped THPs
inefficiently.  It first splits the PMD into PTEs, copies the dirty state
from the PMD to the PTEs, iterates over the PTEs to locate the dirty
state, and then marks the THP as swap-backed.  This process involves
unnecessary PMD splitting and redundant iteration.  Instead, this
functionality can be efficiently managed in
__discard_anon_folio_pmd_locked(), avoiding the extra steps and improving
performance.

The following microbenchmark redirties folios after invoking MADV_FREE,
then measures the time taken to perform memory reclamation (actually set
those folios swapbacked again) on the redirtied folios.

 #include <stdio.h>
 #include <sys/mman.h>
 #include <string.h>
 #include <time.h>

 #define SIZE 128*1024*1024  // 128 MB

 int main(int argc, char *argv[])
 {
 	while(1) {
 		volatile int *p = mmap(0, SIZE, PROT_READ | PROT_WRITE,
 				MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

 		memset((void *)p, 1, SIZE);
 		madvise((void *)p, SIZE, MADV_FREE);
 		/* redirty after MADV_FREE */
 		memset((void *)p, 1, SIZE);

		clock_t start_time = clock();
 		madvise((void *)p, SIZE, MADV_PAGEOUT);
 		clock_t end_time = clock();

 		double elapsed_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;
 		printf("Time taken by reclamation: %f seconds\n", elapsed_time);

 		munmap((void *)p, SIZE);
 	}
 	return 0;
 }

Testing results are as below,
w/o patch:
~ # ./a.out
Time taken by reclamation: 0.007300 seconds
Time taken by reclamation: 0.007226 seconds
Time taken by reclamation: 0.007295 seconds
Time taken by reclamation: 0.007731 seconds
Time taken by reclamation: 0.007134 seconds
Time taken by reclamation: 0.007285 seconds
Time taken by reclamation: 0.007720 seconds
Time taken by reclamation: 0.007128 seconds
Time taken by reclamation: 0.007710 seconds
Time taken by reclamation: 0.007712 seconds
Time taken by reclamation: 0.007236 seconds
Time taken by reclamation: 0.007690 seconds
Time taken by reclamation: 0.007174 seconds
Time taken by reclamation: 0.007670 seconds
Time taken by reclamation: 0.007169 seconds
Time taken by reclamation: 0.007305 seconds
Time taken by reclamation: 0.007432 seconds
Time taken by reclamation: 0.007158 seconds
Time taken by reclamation: 0.007133 seconds
…

w/ patch

~ # ./a.out
Time taken by reclamation: 0.002124 seconds
Time taken by reclamation: 0.002116 seconds
Time taken by reclamation: 0.002150 seconds
Time taken by reclamation: 0.002261 seconds
Time taken by reclamation: 0.002137 seconds
Time taken by reclamation: 0.002173 seconds
Time taken by reclamation: 0.002063 seconds
Time taken by reclamation: 0.002088 seconds
Time taken by reclamation: 0.002169 seconds
Time taken by reclamation: 0.002124 seconds
Time taken by reclamation: 0.002111 seconds
Time taken by reclamation: 0.002224 seconds
Time taken by reclamation: 0.002297 seconds
Time taken by reclamation: 0.002260 seconds
Time taken by reclamation: 0.002246 seconds
Time taken by reclamation: 0.002272 seconds
Time taken by reclamation: 0.002277 seconds
Time taken by reclamation: 0.002462 seconds
…

This patch significantly speeds up try_to_unmap_one() by allowing it
to skip redirtied THPs without splitting the PMD.

Link: https://lkml.kernel.org/r/20250214093015.51024-5-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Lance Yang <ioworker0@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mauricio Faria de Oliveira <mfo@canonical.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shaoqin Huang <shahuang@redhat.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   24 +++++++++++++++++-------
 mm/rmap.c        |   13 ++++++++++---
 2 files changed, 27 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~mm-avoid-splitting-pmd-for-lazyfree-pmd-mapped-thp-in-try_to_unmap
+++ a/mm/huge_memory.c
@@ -3063,8 +3063,12 @@ static bool __discard_anon_folio_pmd_loc
 	int ref_count, map_count;
 	pmd_t orig_pmd = *pmdp;
 
-	if (folio_test_dirty(folio) || pmd_dirty(orig_pmd))
+	if (pmd_dirty(orig_pmd))
+		folio_set_dirty(folio);
+	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+		folio_set_swapbacked(folio);
 		return false;
+	}
 
 	orig_pmd = pmdp_huge_clear_flush(vma, addr, pmdp);
 
@@ -3091,8 +3095,15 @@ static bool __discard_anon_folio_pmd_loc
 	 *
 	 * The only folio refs must be one from isolation plus the rmap(s).
 	 */
-	if (folio_test_dirty(folio) || pmd_dirty(orig_pmd) ||
-	    ref_count != map_count + 1) {
+	if (pmd_dirty(orig_pmd))
+		folio_set_dirty(folio);
+	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+		folio_set_swapbacked(folio);
+		set_pmd_at(mm, addr, pmdp, orig_pmd);
+		return false;
+	}
+
+	if (ref_count != map_count + 1) {
 		set_pmd_at(mm, addr, pmdp, orig_pmd);
 		return false;
 	}
@@ -3112,12 +3123,11 @@ bool unmap_huge_pmd_locked(struct vm_are
 {
 	VM_WARN_ON_FOLIO(!folio_test_pmd_mappable(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+	VM_WARN_ON_FOLIO(folio_test_swapbacked(folio), folio);
 	VM_WARN_ON_ONCE(!IS_ALIGNED(addr, HPAGE_PMD_SIZE));
 
-	if (folio_test_anon(folio) && !folio_test_swapbacked(folio))
-		return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
-
-	return false;
+	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
 }
 
 static void remap_page(struct folio *folio, unsigned long nr, int flags)
--- a/mm/rmap.c~mm-avoid-splitting-pmd-for-lazyfree-pmd-mapped-thp-in-try_to_unmap
+++ a/mm/rmap.c
@@ -1804,9 +1804,16 @@ static bool try_to_unmap_one(struct foli
 		}
 
 		if (!pvmw.pte) {
-			if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd,
-						  folio))
-				goto walk_done;
+			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
+					goto walk_done;
+				/*
+				 * unmap_huge_pmd_locked has either already marked
+				 * the folio as swap-backed or decided to retain it
+				 * due to GUP or speculative references.
+				 */
+				goto walk_abort;
+			}
 
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				/*
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-set-folio-swapbacked-iff-folios-are-dirty-in-try_to_unmap_one.patch
mm-support-tlbbatch-flush-for-a-range-of-ptes.patch
mm-support-batched-unmap-for-lazyfree-large-folios-during-reclamation.patch
mm-avoid-splitting-pmd-for-lazyfree-pmd-mapped-thp-in-try_to_unmap.patch

