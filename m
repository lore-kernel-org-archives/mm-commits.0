Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE19346A18
	for <mm-commits@vger.kernel.org>; Sun,  3 May 2026 13:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777815049; cv=none; b=ihD99TvQ08kpe2o6XNYVXJY/tiksyVlvlNCznd9VEF0YLOp9nLupaQm84yrpXG1aZ0BwsSw2WPKFZ2dC3GAd8VYQ1LfEmoZrAwGpAYsPTAszt4qO5+K4GGhX+KyxbzjnXdA/YTzLBekx6XT4N9D0+d/YqJYaNiFOFbWKRnx4pdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777815049; c=relaxed/simple;
	bh=ZHtb7wEqabOgfQD1vlI5JjkA9x7kpJl1qEY123rogaU=;
	h=Date:To:From:Subject:Message-Id; b=ghbXkgmFxdi/hZIjJvax5OMbm4ZJCx3UdlXVb+AgxPFKdhMxTh0u4tufdPRto5e96OGIbnA4uGrVWZZRxa9EjFwOwdEL26QXusgLRwtYQc2fW5pxAuoS5ULzqKSjo/9YyH+J2DgHJrs6dwn4SFOsh1CecxyQW0jSao22JJBqRwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QRGz9lCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QRGz9lCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0460C2BCB4;
	Sun,  3 May 2026 13:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777815049;
	bh=ZHtb7wEqabOgfQD1vlI5JjkA9x7kpJl1qEY123rogaU=;
	h=Date:To:From:Subject:From;
	b=QRGz9lCKUPXMDi+cKfcC1+V97xXJQ8O0dcH6JD8RE5OHOY3oMUAw46DsjCR68cAEj
	 4ocHx+JxtDAdr8cA1HqZjCZLuACjUgsWZtUeOdVTUN7+5oeow+WdwS2pQXyCnkoR2i
	 FNS7QkUFhryvAwegTmDsEfsMkBxNzt2PLEolVZF8=
Date: Sun, 03 May 2026 06:30:46 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ying.huang@linux.alibaba.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,vbabka@suse.cz,usama.arif@linux.dev,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shivankg@amd.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,richard.weiyang@gmail.com,rdunlap@infradead.org,raquini@redhat.com,rakie.kim@sk.com,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,jack@suse.cz,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,bagasdotme@gmail.com,apopple@nvidia.com,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch added to mm-new branch
Message-Id: <20260503133048.D0460C2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: introduce collapse_allowable_orders helper function
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch

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
From: Nico Pache <npache@redhat.com>
Subject: mm/khugepaged: introduce collapse_allowable_orders helper function
Date: Sun, 19 Apr 2026 12:57:46 -0600

Add collapse_allowable_orders() to generalize THP order eligibility.  The
function determines which THP orders are permitted based on collapse
context (khugepaged vs madv_collapse).

This consolidates collapse configuration logic and provides a clean
interface for future mTHP collapse support where the orders may be
different.

Link: https://lore.kernel.org/20260419185750.260784-10-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Takashi Iwai (SUSE) <tiwai@suse.de>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/khugepaged.h        |    6 ++----
 mm/huge_memory.c                  |    2 +-
 mm/khugepaged.c                   |   20 ++++++++++++++------
 mm/vma.c                          |    6 +++---
 tools/testing/vma/include/stubs.h |    3 +--
 5 files changed, 21 insertions(+), 16 deletions(-)

--- a/include/linux/khugepaged.h~mm-khugepaged-introduce-collapse_allowable_orders-helper-function
+++ a/include/linux/khugepaged.h
@@ -13,8 +13,7 @@ extern void khugepaged_destroy(void);
 extern int start_stop_khugepaged(void);
 extern void __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
-extern void khugepaged_enter_vma(struct vm_area_struct *vma,
-				 vm_flags_t vm_flags);
+extern void khugepaged_enter_vma(struct vm_area_struct *vma);
 extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
 void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
@@ -38,8 +37,7 @@ static inline void khugepaged_fork(struc
 static inline void khugepaged_exit(struct mm_struct *mm)
 {
 }
-static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
-					vm_flags_t vm_flags)
+static inline void khugepaged_enter_vma(struct vm_area_struct *vma)
 {
 }
 static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
--- a/mm/huge_memory.c~mm-khugepaged-introduce-collapse_allowable_orders-helper-function
+++ a/mm/huge_memory.c
@@ -1571,7 +1571,7 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 	ret = vmf_anon_prepare(vmf);
 	if (ret)
 		return ret;
-	khugepaged_enter_vma(vma, vma->vm_flags);
+	khugepaged_enter_vma(vma);
 
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
--- a/mm/khugepaged.c~mm-khugepaged-introduce-collapse_allowable_orders-helper-function
+++ a/mm/khugepaged.c
@@ -447,7 +447,7 @@ int hugepage_madvise(struct vm_area_stru
 		 * register it here without waiting a page fault that
 		 * may not happen any time soon.
 		 */
-		khugepaged_enter_vma(vma, *vm_flags);
+		khugepaged_enter_vma(vma);
 		break;
 	case MADV_NOHUGEPAGE:
 		*vm_flags &= ~VM_HUGEPAGE;
@@ -546,12 +546,20 @@ void __khugepaged_enter(struct mm_struct
 		wake_up_interruptible(&khugepaged_wait);
 }
 
-void khugepaged_enter_vma(struct vm_area_struct *vma,
-			  vm_flags_t vm_flags)
+/* Check what orders are allowed based on the vma and collapse type */
+static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
+		enum tva_type tva_flags)
+{
+	unsigned long orders = BIT(HPAGE_PMD_ORDER);
+
+	return thp_vma_allowable_orders(vma, vma->vm_flags, tva_flags, orders);
+}
+
+void khugepaged_enter_vma(struct vm_area_struct *vma)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+		if (collapse_allowable_orders(vma, TVA_KHUGEPAGED))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -2664,7 +2672,7 @@ static void collapse_scan_mm_slot(unsign
 			cc->progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!collapse_allowable_orders(vma, TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -2974,7 +2982,7 @@ int madvise_collapse(struct vm_area_stru
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!collapse_allowable_orders(vma, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
 	cc = kmalloc_obj(*cc);
--- a/mm/vma.c~mm-khugepaged-introduce-collapse_allowable_orders-helper-function
+++ a/mm/vma.c
@@ -989,7 +989,7 @@ static __must_check struct vm_area_struc
 		goto abort;
 
 	vma_set_flags_mask(vmg->target, sticky_flags);
-	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
+	khugepaged_enter_vma(vmg->target);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
 
@@ -1110,7 +1110,7 @@ struct vm_area_struct *vma_merge_new_ran
 	 * following VMA if we have VMAs on both sides.
 	 */
 	if (vmg->target && !vma_expand(vmg)) {
-		khugepaged_enter_vma(vmg->target, vmg->vm_flags);
+		khugepaged_enter_vma(vmg->target);
 		vmg->state = VMA_MERGE_SUCCESS;
 		return vmg->target;
 	}
@@ -2589,7 +2589,7 @@ static int __mmap_new_vma(struct mmap_st
 	 * call covers the non-merge case.
 	 */
 	if (!vma_is_anonymous(vma))
-		khugepaged_enter_vma(vma, map->vm_flags);
+		khugepaged_enter_vma(vma);
 	*vmap = vma;
 	return 0;
 
--- a/tools/testing/vma/include/stubs.h~mm-khugepaged-introduce-collapse_allowable_orders-helper-function
+++ a/tools/testing/vma/include/stubs.h
@@ -183,8 +183,7 @@ static inline bool mpol_equal(struct mem
 	return true;
 }
 
-static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
-			  vm_flags_t vm_flags)
+static inline void khugepaged_enter_vma(struct vm_area_struct *vma)
 {
 }
 
_

Patches currently in -mm which might be from npache@redhat.com are

mm-khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch
mm-khugepaged-rework-max_ptes_-handling-with-helper-functions.patch
mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse.patch
mm-khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch
mm-khugepaged-improve-tracepoints-for-mthp-orders.patch
mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

