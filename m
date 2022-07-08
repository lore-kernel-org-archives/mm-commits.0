Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1713C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 21:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240431AbiGHVFQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 17:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240416AbiGHVFH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 17:05:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBBA904F9
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 14:05:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CF5BB82567
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 21:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C67C341C0;
        Fri,  8 Jul 2022 21:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657314302;
        bh=7FCHij0aHVkToFyrOlFiJR5OZmyOtXfLGW7TUivge0s=;
        h=Date:To:From:Subject:From;
        b=0UP1n0xnKN6lANxSNlPIo0JHNKM8+cDOqQHf5H8eXJKw0paU/9ftvJuR9FQBGKWGF
         sgcJYZbqGP3TUZnQi5+Hmn9OkHEmKY9oX1e7NgBW0c22EZURQi8WLDSlu0raLMNxiT
         IgJ0QtDZgINaxSVYk5RSH04/HaGNp0tccD3inE/A=
Date:   Fri, 08 Jul 2022 14:05:02 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tsbogend@alpha.franken.de, songliubraving@fb.com,
        sj@kernel.org, shy828301@gmail.com, rongwei.wang@linux.alibaba.com,
        rientjes@google.com, peterx@redhat.com, pasha.tatashin@soleen.com,
        minchan@kernel.org, mhocko@suse.com, mattst88@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, James.Bottomley@HansenPartnership.com,
        ink@jurassic.park.msu.ru, hughd@google.com, deller@gmx.de,
        david@redhat.com, ckennelly@google.com, chris@zankel.net,
        axelrasmussen@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        arnd@arndb.de, alex.shi@linux.alibaba.com, aarcange@redhat.com,
        zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch added to mm-unstable branch
Message-Id: <20220708210502.A5C67C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: rename prefix of shared collapse functions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch

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
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/khugepaged: rename prefix of shared collapse functions
Date: Wed, 6 Jul 2022 16:59:28 -0700

The following functions are shared between khugepaged and madvise collapse
contexts.  Replace the "khugepaged_" prefix with generic "hpage_collapse_"
prefix in such cases:

khugepaged_test_exit() -> hpage_collapse_test_exit()
khugepaged_scan_abort() -> hpage_collapse_scan_abort()
khugepaged_scan_pmd() -> hpage_collapse_scan_pmd()
khugepaged_find_target_node() -> hpage_collapse_find_target_node()
khugepaged_alloc_page() -> hpage_collapse_alloc_page()

The kerenel ABI (e.g.  huge_memory:mm_khugepaged_scan_pmd tracepoint) is
unaltered.

Link: https://lkml.kernel.org/r/20220706235936.2197195-11-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   68 +++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-rename-prefix-of-shared-collapse-functions
+++ a/mm/khugepaged.c
@@ -94,7 +94,7 @@ struct collapse_control {
 	/* Num pages scanned per node */
 	int node_load[MAX_NUMNODES];
 
-	/* Last target selected in khugepaged_find_target_node() */
+	/* Last target selected in hpage_collapse_find_target_node() */
 	int last_target_node;
 };
 
@@ -438,7 +438,7 @@ static void insert_to_mm_slots_hash(stru
 	hash_add(mm_slots_hash, &mm_slot->hash, (long)mm);
 }
 
-static inline int khugepaged_test_exit(struct mm_struct *mm)
+static inline int hpage_collapse_test_exit(struct mm_struct *mm)
 {
 	return atomic_read(&mm->mm_users) == 0;
 }
@@ -453,7 +453,7 @@ void __khugepaged_enter(struct mm_struct
 		return;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(khugepaged_test_exit(mm), mm);
+	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
 	if (unlikely(test_and_set_bit(MMF_VM_HUGEPAGE, &mm->flags))) {
 		free_mm_slot(mm_slot);
 		return;
@@ -505,11 +505,10 @@ void __khugepaged_exit(struct mm_struct
 	} else if (mm_slot) {
 		/*
 		 * This is required to serialize against
-		 * khugepaged_test_exit() (which is guaranteed to run
-		 * under mmap sem read mode). Stop here (after we
-		 * return all pagetables will be destroyed) until
-		 * khugepaged has finished working on the pagetables
-		 * under the mmap_lock.
+		 * hpage_collapse_test_exit() (which is guaranteed to run
+		 * under mmap sem read mode). Stop here (after we return all
+		 * pagetables will be destroyed) until khugepaged has finished
+		 * working on the pagetables under the mmap_lock.
 		 */
 		mmap_write_lock(mm);
 		mmap_write_unlock(mm);
@@ -754,13 +753,12 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-
 struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 	.last_target_node = NUMA_NO_NODE,
 };
 
-static bool khugepaged_scan_abort(int nid, struct collapse_control *cc)
+static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
 
@@ -795,7 +793,7 @@ static inline gfp_t alloc_hugepage_khuge
 }
 
 #ifdef CONFIG_NUMA
-static int khugepaged_find_target_node(struct collapse_control *cc)
+static int hpage_collapse_find_target_node(struct collapse_control *cc)
 {
 	int nid, target_node = 0, max_value = 0;
 
@@ -819,13 +817,13 @@ static int khugepaged_find_target_node(s
 	return target_node;
 }
 #else
-static int khugepaged_find_target_node(struct collapse_control *cc)
+static int hpage_collapse_find_target_node(struct collapse_control *cc)
 {
 	return 0;
 }
 #endif
 
-static bool khugepaged_alloc_page(struct page **hpage, gfp_t gfp, int node)
+static bool hpage_collapse_alloc_page(struct page **hpage, gfp_t gfp, int node)
 {
 	*hpage = __alloc_pages_node(node, gfp, HPAGE_PMD_ORDER);
 	if (unlikely(!*hpage)) {
@@ -850,7 +848,7 @@ static int hugepage_vma_revalidate(struc
 {
 	struct vm_area_struct *vma;
 
-	if (unlikely(khugepaged_test_exit(mm)))
+	if (unlikely(hpage_collapse_test_exit(mm)))
 		return SCAN_ANY_PROCESS;
 
 	*vmap = vma = find_vma(mm, address);
@@ -913,7 +911,7 @@ static int check_pmd_still_valid(struct
 
 /*
  * Bring missing pages in from swap, to complete THP collapse.
- * Only done if khugepaged_scan_pmd believes it is worthwhile.
+ * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
  *
  * Called and returns without pte mapped or spinlocks held.
  * Note that if false is returned, mmap_lock will be released.
@@ -978,9 +976,9 @@ static int alloc_charge_hpage(struct pag
 	/* Only allocate from the target node */
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE) | __GFP_THISNODE;
-	int node = khugepaged_find_target_node(cc);
+	int node = hpage_collapse_find_target_node(cc);
 
-	if (!khugepaged_alloc_page(hpage, gfp, node))
+	if (!hpage_collapse_alloc_page(hpage, gfp, node))
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
 	if (unlikely(mem_cgroup_charge(page_folio(*hpage), mm, gfp)))
 		return SCAN_CGROUP_CHARGE_FAIL;
@@ -1140,9 +1138,10 @@ out_nolock:
 	return result;
 }
 
-static int khugepaged_scan_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
-			       unsigned long address, bool *mmap_locked,
-			       struct collapse_control *cc)
+static int hpage_collapse_scan_pmd(struct mm_struct *mm,
+				   struct vm_area_struct *vma,
+				   unsigned long address, bool *mmap_locked,
+				   struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
@@ -1234,7 +1233,7 @@ static int khugepaged_scan_pmd(struct mm
 		 * hit record.
 		 */
 		node = page_to_nid(page);
-		if (khugepaged_scan_abort(node, cc)) {
+		if (hpage_collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			goto out_unmap;
 		}
@@ -1313,7 +1312,7 @@ static void collect_mm_slot(struct mm_sl
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 
-	if (khugepaged_test_exit(mm)) {
+	if (hpage_collapse_test_exit(mm)) {
 		/* free mm_slot */
 		hash_del(&mm_slot->hash);
 		list_del(&mm_slot->mm_node);
@@ -1486,7 +1485,7 @@ static void khugepaged_collapse_pte_mapp
 	if (!mmap_write_trylock(mm))
 		return;
 
-	if (unlikely(khugepaged_test_exit(mm)))
+	if (unlikely(hpage_collapse_test_exit(mm)))
 		goto out;
 
 	for (i = 0; i < mm_slot->nr_pte_mapped_thp; i++)
@@ -1548,7 +1547,8 @@ static void retract_page_tables(struct a
 			 * it'll always mapped in small page size for uffd-wp
 			 * registered ranges.
 			 */
-			if (!khugepaged_test_exit(mm) && !userfaultfd_wp(vma))
+			if (!hpage_collapse_test_exit(mm) &&
+			    !userfaultfd_wp(vma))
 				collapse_and_free_pmd(mm, vma, addr, pmd);
 			mmap_write_unlock(mm);
 		} else {
@@ -1975,7 +1975,7 @@ static int khugepaged_scan_file(struct m
 		}
 
 		node = page_to_nid(page);
-		if (khugepaged_scan_abort(node, cc)) {
+		if (hpage_collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			break;
 		}
@@ -2069,7 +2069,7 @@ static unsigned int khugepaged_scan_mm_s
 		goto breakouterloop_mmap_lock;
 
 	progress++;
-	if (unlikely(khugepaged_test_exit(mm)))
+	if (unlikely(hpage_collapse_test_exit(mm)))
 		goto breakouterloop;
 
 	address = khugepaged_scan.address;
@@ -2078,7 +2078,7 @@ static unsigned int khugepaged_scan_mm_s
 		unsigned long hstart, hend;
 
 		cond_resched();
-		if (unlikely(khugepaged_test_exit(mm))) {
+		if (unlikely(hpage_collapse_test_exit(mm))) {
 			progress++;
 			break;
 		}
@@ -2099,7 +2099,7 @@ skip:
 			bool mmap_locked = true;
 
 			cond_resched();
-			if (unlikely(khugepaged_test_exit(mm)))
+			if (unlikely(hpage_collapse_test_exit(mm)))
 				goto breakouterloop;
 
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
@@ -2116,9 +2116,10 @@ skip:
 				mmap_locked = false;
 				fput(file);
 			} else {
-				*result = khugepaged_scan_pmd(mm, vma,
-							      khugepaged_scan.address,
-							      &mmap_locked, cc);
+				*result = hpage_collapse_scan_pmd(mm, vma,
+								  khugepaged_scan.address,
+								  &mmap_locked,
+								  cc);
 			}
 			if (*result == SCAN_SUCCEED)
 				++khugepaged_pages_collapsed;
@@ -2148,7 +2149,7 @@ breakouterloop_mmap_lock:
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
 	 */
-	if (khugepaged_test_exit(mm) || !vma) {
+	if (hpage_collapse_test_exit(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
@@ -2432,7 +2433,8 @@ int madvise_collapse(struct vm_area_stru
 		}
 		mmap_assert_locked(mm);
 		memset(cc->node_load, 0, sizeof(cc->node_load));
-		result = khugepaged_scan_pmd(mm, vma, addr, &mmap_locked, cc);
+		result = hpage_collapse_scan_pmd(mm, vma, addr, &mmap_locked,
+						 cc);
 		if (!mmap_locked)
 			*prev = NULL;  /* Tell caller we dropped mmap_lock */
 
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-remove-redundant-transhuge_vma_suitable-check.patch
mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-huge_memory-mm_madvise_collapse-tracepoint.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
proc-smaps-add-pmdmappable-field-to-smaps.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch

