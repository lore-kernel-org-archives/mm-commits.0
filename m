Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2F02AEFD
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 00:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751590745; cv=none; b=SWi7/3ljgl1FjRjt6UrueJkaGuVeyYgpE743RO0q8CI2mzg6U3dWV04xOw3dTSMwRM19UD7f5mrAQiq7gS7LPFo/voJ35UFS08z0a3cFZsNp0iCcOmEeY86d85yfec1sHlHk9dkJxijQ0SaxlHoVeW/1eXqvkkYMr1zjeeLo70U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751590745; c=relaxed/simple;
	bh=knELJ074xKPh+rWn9SNPU3UfBlP+w4vg+cU2MaEc/Uk=;
	h=Date:To:From:Subject:Message-Id; b=pqU1F4qNSnbYEktsdRCrOj0C3/zi+yLg5tKc48rSXGCBnSYPy5n+Eo2kaNmyMCOy7sYWMuKnqf0zongJZwtMdJzjgftEJwtLZtR/uJ2LBwV7SzsGRA60/4sL6udIGj3ghKgWqlWBk8SAruOGFruBPxvtKv5eCxWjvdit8Xegda0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2W0ARrgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2W0ARrgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DD4C4CEE3;
	Fri,  4 Jul 2025 00:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751590745;
	bh=knELJ074xKPh+rWn9SNPU3UfBlP+w4vg+cU2MaEc/Uk=;
	h=Date:To:From:Subject:From;
	b=2W0ARrgHfY+RQ3zE3CSmz17+xOdBhMZ1ZpCkHFlFXCBYnJLd7Jz+7oIlmCYkmLCLk
	 2ZwDRS1Hxgw8FJNSIhwWCtcGT60KOw5tZ+UX8Eeb9MlK9J9ochS3SWX1jq9gSmOL/8
	 ro0T+tF8QJX7InzpTiIq9D+HfPrhdoISBCzftjU4=
Date: Thu, 03 Jul 2025 17:59:04 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,ryan.roberts@arm.com,rostedt@goodmis.org,rientjes@google.com,rdunlap@infradead.org,raquini@redhat.com,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,cl@gentwo.org,catalin.marinas@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,bagasdotme@gmail.com,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-rename-hpage_collapse_-to-khugepaged_.patch added to mm-new branch
Message-Id: <20250704005905.29DD4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: rename hpage_collapse_* to khugepaged_*
has been added to the -mm mm-new branch.  Its filename is
     khugepaged-rename-hpage_collapse_-to-khugepaged_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-rename-hpage_collapse_-to-khugepaged_.patch

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
From: Nico Pache <npache@redhat.com>
Subject: khugepaged: rename hpage_collapse_* to khugepaged_*
Date: Tue, 1 Jul 2025 23:57:28 -0600

Patch series "khugepaged: mTHP support", v8.

The following series provides khugepaged and madvise collapse with the
capability to collapse anonymous memory regions to mTHPs.

To achieve this we generalize the khugepaged functions to no longer depend
on PMD_ORDER.  Then during the PMD scan, we use a bitmap to track chunks
of pages (defined by KHUGEPAGED_MTHP_MIN_ORDER) that are utilized.  After
the PMD scan is done, we do binary recursion on the bitmap to find the
optimal mTHP sizes for the PMD range.  The restriction on max_ptes_none is
removed during the scan, to make sure we account for the whole PMD range. 
When no mTHP size is enabled, the legacy behavior of khugepaged is
maintained.  max_ptes_none will be scaled by the attempted collapse order
to determine how full a mTHP must be to be eligible for the collapse to
occur.  If a mTHP collapse is attempted, but contains swapped out, or
shared pages, we don't perform the collapse.  It is now also possible to
collapse to mTHPs without requiring the PMD THP size to be enabled.

With the default max_ptes_none=511, the code should keep its most of its
original behavior.  When enabling multiple adjacent (m)THP sizes we need
to set max_ptes_none<=255.  With max_ptes_none > HPAGE_PMD_NR/2 you will
experience collapse "creep" and constantly promote mTHPs to the next
available size.  This is due the fact that a collapse will introduce at
least 2x the number of pages, and on a future scan will satisfy the
promotion condition once again.

Patch 1:     Refactor/rename hpage_collapse
Patch 2:     Some refactoring to combine madvise_collapse and khugepaged
Patch 3-5:   Generalize khugepaged functions for arbitrary orders
Patch 6-9:   The mTHP patches
Patch 10-12: Allow khugepaged to operate without PMD enabled
Patch 13-14: Tracing/stats
Patch 15:    Documentation


This patch (of 15):

Functions in khugepaged.c use a mix of hpage_collapse and khugepaged
as the function prefix.

Rename all of them to khugepaged to keep things consistent and slightly
shorten the function names.

Link: https://lkml.kernel.org/r/20250702055742.102808-1-npache@redhat.com
Link: https://lkml.kernel.org/r/20250702055742.102808-2-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Reported-by:Takashi Iwai <tiwai@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

--- a/mm/khugepaged.c~khugepaged-rename-hpage_collapse_-to-khugepaged_
+++ a/mm/khugepaged.c
@@ -402,14 +402,14 @@ void __init khugepaged_destroy(void)
 	kmem_cache_destroy(mm_slot_cache);
 }
 
-static inline int hpage_collapse_test_exit(struct mm_struct *mm)
+static inline int khugepaged_test_exit(struct mm_struct *mm)
 {
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
+static inline int khugepaged_test_exit_or_disable(struct mm_struct *mm)
 {
-	return hpage_collapse_test_exit(mm) ||
+	return khugepaged_test_exit(mm) ||
 	       test_bit(MMF_DISABLE_THP, &mm->flags);
 }
 
@@ -444,7 +444,7 @@ void __khugepaged_enter(struct mm_struct
 	int wakeup;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
+	VM_BUG_ON_MM(khugepaged_test_exit(mm), mm);
 	if (unlikely(test_and_set_bit(MMF_VM_HUGEPAGE, &mm->flags)))
 		return;
 
@@ -503,7 +503,7 @@ void __khugepaged_exit(struct mm_struct
 	} else if (mm_slot) {
 		/*
 		 * This is required to serialize against
-		 * hpage_collapse_test_exit() (which is guaranteed to run
+		 * khugepaged_test_exit() (which is guaranteed to run
 		 * under mmap sem read mode). Stop here (after we return all
 		 * pagetables will be destroyed) until khugepaged has finished
 		 * working on the pagetables under the mmap_lock.
@@ -838,7 +838,7 @@ struct collapse_control khugepaged_colla
 	.is_khugepaged = true,
 };
 
-static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
+static bool khugepaged_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
 
@@ -873,7 +873,7 @@ static inline gfp_t alloc_hugepage_khuge
 }
 
 #ifdef CONFIG_NUMA
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int khugepaged_find_target_node(struct collapse_control *cc)
 {
 	int nid, target_node = 0, max_value = 0;
 
@@ -892,7 +892,7 @@ static int hpage_collapse_find_target_no
 	return target_node;
 }
 #else
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int khugepaged_find_target_node(struct collapse_control *cc)
 {
 	return 0;
 }
@@ -912,7 +912,7 @@ static int hugepage_vma_revalidate(struc
 	struct vm_area_struct *vma;
 	unsigned long tva_flags = cc->is_khugepaged ? TVA_ENFORCE_SYSFS : 0;
 
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(khugepaged_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
 
 	*vmap = vma = find_vma(mm, address);
@@ -977,7 +977,7 @@ static int check_pmd_still_valid(struct
 
 /*
  * Bring missing pages in from swap, to complete THP collapse.
- * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
+ * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
  * Called and returns without pte mapped or spinlocks held.
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
@@ -1063,7 +1063,7 @@ static int alloc_charge_folio(struct fol
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
-	int node = hpage_collapse_find_target_node(cc);
+	int node = khugepaged_find_target_node(cc);
 	struct folio *folio;
 
 	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
@@ -1249,7 +1249,7 @@ out_nolock:
 	return result;
 }
 
-static int hpage_collapse_scan_pmd(struct mm_struct *mm,
+static int khugepaged_scan_pmd(struct mm_struct *mm,
 				   struct vm_area_struct *vma,
 				   unsigned long address, bool *mmap_locked,
 				   struct collapse_control *cc)
@@ -1363,7 +1363,7 @@ static int hpage_collapse_scan_pmd(struc
 		 * hit record.
 		 */
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (khugepaged_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			goto out_unmap;
 		}
@@ -1432,7 +1432,7 @@ static void collect_mm_slot(struct khuge
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 
-	if (hpage_collapse_test_exit(mm)) {
+	if (khugepaged_test_exit(mm)) {
 		/* free mm_slot */
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
@@ -1725,7 +1725,7 @@ static void retract_page_tables(struct a
 		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
 			continue;
 
-		if (hpage_collapse_test_exit(mm))
+		if (khugepaged_test_exit(mm))
 			continue;
 		/*
 		 * When a vma is registered with uffd-wp, we cannot recycle
@@ -2247,7 +2247,7 @@ out:
 	return result;
 }
 
-static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
+static int khugepaged_scan_file(struct mm_struct *mm, unsigned long addr,
 				    struct file *file, pgoff_t start,
 				    struct collapse_control *cc)
 {
@@ -2304,7 +2304,7 @@ static int hpage_collapse_scan_file(stru
 		}
 
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (khugepaged_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			folio_put(folio);
 			break;
@@ -2392,7 +2392,7 @@ static unsigned int khugepaged_scan_mm_s
 		goto breakouterloop_mmap_lock;
 
 	progress++;
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(khugepaged_test_exit_or_disable(mm)))
 		goto breakouterloop;
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
@@ -2400,7 +2400,7 @@ static unsigned int khugepaged_scan_mm_s
 		unsigned long hstart, hend;
 
 		cond_resched();
-		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
+		if (unlikely(khugepaged_test_exit_or_disable(mm))) {
 			progress++;
 			break;
 		}
@@ -2422,7 +2422,7 @@ skip:
 			bool mmap_locked = true;
 
 			cond_resched();
-			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+			if (unlikely(khugepaged_test_exit_or_disable(mm)))
 				goto breakouterloop;
 
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
@@ -2482,7 +2482,7 @@ breakouterloop_mmap_lock:
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
 	 */
-	if (hpage_collapse_test_exit(mm) || !vma) {
+	if (khugepaged_test_exit(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
_

Patches currently in -mm which might be from npache@redhat.com are

khugepaged-rename-hpage_collapse_-to-khugepaged_.patch
introduce-khugepaged_collapse_single_pmd-to-unify-khugepaged-and-madvise_collapse.patch
khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch
khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
khugepaged-introduce-khugepaged_scan_bitmap-for-mthp-support.patch
khugepaged-add-mthp-support.patch
khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
khugepaged-allow-madvise_collapse-to-check-all-anonymous-mthp-orders.patch
khugepaged-improve-tracepoints-for-mthp-orders.patch
khugepaged-add-per-order-mthp-khugepaged-stats.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

