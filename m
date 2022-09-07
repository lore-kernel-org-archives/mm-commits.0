Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24355C38145
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 22:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiIGWUI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Sep 2022 18:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiIGWUC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2022 18:20:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42ED527CDA
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 15:20:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA038B81F27
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 22:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76728C433D6;
        Wed,  7 Sep 2022 22:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662589197;
        bh=sR4avclD9AsqOR3Z5XoU6yY4aVaMnxqcYIq4kX6sX1Y=;
        h=Date:To:From:Subject:From;
        b=qUk8QV0WaGJXIF90Isq+l6da7HMI/rZh3t9C7gu0UGvToBkut1Db2uJQX8MUH1OVf
         6NwXeA66a+bpnSxoTD6kZ9yh9mU+BzxExKtaAq3lr6EEigbueuEJmf9lGNIrAamZi0
         aIB3IIDod1vscdPqxqlAyv2ejEqZf6apFkFHS8iw=
Date:   Wed, 07 Sep 2022 15:19:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch added to mm-unstable branch
Message-Id: <20220907221957.76728C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: attempt to map file/shmem-backed pte-mapped THPs by pmds
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch

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
Subject: mm/khugepaged: attempt to map file/shmem-backed pte-mapped THPs by pmds
Date: Wed, 7 Sep 2022 07:45:13 -0700

The main benefit of THPs are that they can be mapped at the pmd level,
increasing the likelihood of TLB hit and spending less cycles in page
table walks.  pte-mapped hugepages - that is - hugepage-aligned compound
pages of order HPAGE_PMD_ORDER mapped by ptes - although being contiguous
in physical memory, don't have this advantage.  In fact, one could argue
they are detrimental to system performance overall since they occupy a
precious hugepage-aligned/sized region of physical memory that could
otherwise be used more effectively.  Additionally, pte-mapped hugepages
can be the cheapest memory to collapse for khugepaged since no new
hugepage allocation or copying of memory contents is necessary - we only
need to update the mapping page tables.

In the anonymous collapse path, we are able to collapse pte-mapped
hugepages (albeit, perhaps suboptimally), but the file/shmem path makes no
effort when compound pages (of any order) are encountered.

Identify pte-mapped hugepages in the file/shmem collapse path.  The final
step of which makes a racy check of the value of the pmd to ensure it maps
a pte table.  This should be fine, since races that result in
false-positive (i.e.  attempt collapse even though we sholdn't) will fail
later in collapse_pte_mapped_thp() once we actually lock mmap_lock and
reinspect the pmd value.  Races that result in false-negatives (i.e. 
where we decide to not attempt collapse, but should have) shouldn't be an
issue, since in the worst case, we do nothing - which is what we've done
up to this point.  We make a similar check in retract_page_tables().  If
we do think we've found a pte-mapped hugepgae in khugepaged context,
attempt to update page tables mapping this hugepage.

Note that these collapses still count towards the
/sys/kernel/mm/transparent_hugepage/khugepaged/pages_collapsed counter,
and if the pte-mapped hugepage was also mapped into multiple process'
address spaces, could be incremented for each page table update.  Since we
increment the counter when a pte-mapped hugepage is successfully added to
the list of to-collapse pte-mapped THPs, it's possible that we never
actually update the page table either.  This is different from how
file/shmem pages_collapsed accounting works today where only a successful
page cache update is counted (it's also possible here that no page tables
are actually changed).  Though it incurs some slop, this is preferred to
either not accounting for the event at all, or plumbing through data in
struct mm_slot on whether to account for the collapse or not.

Also note that work still needs to be done to support arbitrary compound
pages, and that this should all be converted to using folios.

Link: https://lkml.kernel.org/r/20220907144521.3115321-3-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    1 
 mm/khugepaged.c                    |   67 ++++++++++++++++++++++++---
 2 files changed, 62 insertions(+), 6 deletions(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds
+++ a/include/trace/events/huge_memory.h
@@ -17,6 +17,7 @@
 	EM( SCAN_EXCEED_SHARED_PTE,	"exceed_shared_pte")		\
 	EM( SCAN_PTE_NON_PRESENT,	"pte_non_present")		\
 	EM( SCAN_PTE_UFFD_WP,		"pte_uffd_wp")			\
+	EM( SCAN_PTE_MAPPED_HUGEPAGE,	"pte_mapped_hugepage")		\
 	EM( SCAN_PAGE_RO,		"no_writable_page")		\
 	EM( SCAN_LACK_REFERENCED_PAGE,	"lack_referenced_page")		\
 	EM( SCAN_PAGE_NULL,		"page_null")			\
--- a/mm/khugepaged.c~mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds
+++ a/mm/khugepaged.c
@@ -35,6 +35,7 @@ enum scan_result {
 	SCAN_EXCEED_SHARED_PTE,
 	SCAN_PTE_NON_PRESENT,
 	SCAN_PTE_UFFD_WP,
+	SCAN_PTE_MAPPED_HUGEPAGE,
 	SCAN_PAGE_RO,
 	SCAN_LACK_REFERENCED_PAGE,
 	SCAN_PAGE_NULL,
@@ -1320,20 +1321,24 @@ static void collect_mm_slot(struct khuge
  * Notify khugepaged that given addr of the mm is pte-mapped THP. Then
  * khugepaged should try to collapse the page table.
  */
-static void khugepaged_add_pte_mapped_thp(struct mm_struct *mm,
+static bool khugepaged_add_pte_mapped_thp(struct mm_struct *mm,
 					  unsigned long addr)
 {
 	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
+	bool ret = false;
 
 	VM_BUG_ON(addr & ~HPAGE_PMD_MASK);
 
 	spin_lock(&khugepaged_mm_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
 	mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
-	if (likely(mm_slot && mm_slot->nr_pte_mapped_thp < MAX_PTE_MAPPED_THP))
+	if (likely(mm_slot && mm_slot->nr_pte_mapped_thp < MAX_PTE_MAPPED_THP)) {
 		mm_slot->pte_mapped_thp[mm_slot->nr_pte_mapped_thp++] = addr;
+		ret = true;
+	}
 	spin_unlock(&khugepaged_mm_lock);
+	return ret;
 }
 
 static void collapse_and_free_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -1370,9 +1375,16 @@ void collapse_pte_mapped_thp(struct mm_s
 	pte_t *start_pte, *pte;
 	pmd_t *pmd;
 	spinlock_t *ptl;
-	int count = 0;
+	int count = 0, result = SCAN_FAIL;
 	int i;
 
+	mmap_assert_write_locked(mm);
+
+	/* Fast check before locking page if already PMD-mapped  */
+	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
+	if (result != SCAN_SUCCEED)
+		return;
+
 	if (!vma || !vma->vm_file ||
 	    !range_in_vma(vma, haddr, haddr + HPAGE_PMD_SIZE))
 		return;
@@ -1723,9 +1735,16 @@ static int collapse_file(struct mm_struc
 		/*
 		 * If file was truncated then extended, or hole-punched, before
 		 * we locked the first page, then a THP might be there already.
+		 * This will be discovered on the first iteration.
 		 */
 		if (PageTransCompound(page)) {
-			result = SCAN_PAGE_COMPOUND;
+			struct page *head = compound_head(page);
+
+			result = compound_order(head) == HPAGE_PMD_ORDER &&
+					head->index == start
+					/* Maybe PMD-mapped */
+					? SCAN_PTE_MAPPED_HUGEPAGE
+					: SCAN_PAGE_COMPOUND;
 			goto out_unlock;
 		}
 
@@ -1963,7 +1982,19 @@ static int khugepaged_scan_file(struct m
 		 * into a PMD sized page
 		 */
 		if (PageTransCompound(page)) {
-			result = SCAN_PAGE_COMPOUND;
+			struct page *head = compound_head(page);
+
+			result = compound_order(head) == HPAGE_PMD_ORDER &&
+					head->index == start
+					/* Maybe PMD-mapped */
+					? SCAN_PTE_MAPPED_HUGEPAGE
+					: SCAN_PAGE_COMPOUND;
+			/*
+			 * For SCAN_PTE_MAPPED_HUGEPAGE, further processing
+			 * by the caller won't touch the page cache, and so
+			 * it's safe to skip LRU and refcount checks before
+			 * returning.
+			 */
 			break;
 		}
 
@@ -2023,6 +2054,12 @@ static int khugepaged_scan_file(struct m
 static void khugepaged_collapse_pte_mapped_thps(struct khugepaged_mm_slot *mm_slot)
 {
 }
+
+static bool khugepaged_add_pte_mapped_thp(struct mm_struct *mm,
+					  unsigned long addr)
+{
+	return false;
+}
 #endif
 
 static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
@@ -2115,8 +2152,26 @@ skip:
 								  &mmap_locked,
 								  cc);
 			}
-			if (*result == SCAN_SUCCEED)
+			switch (*result) {
+			case SCAN_PTE_MAPPED_HUGEPAGE: {
+				pmd_t *pmd;
+
+				*result = find_pmd_or_thp_or_none(mm,
+								  khugepaged_scan.address,
+								  &pmd);
+				if (*result != SCAN_SUCCEED)
+					break;
+				if (!khugepaged_add_pte_mapped_thp(mm,
+								   khugepaged_scan.address))
+					break;
+			} fallthrough;
+			case SCAN_SUCCEED:
 				++khugepaged_pages_collapsed;
+				break;
+			default:
+				break;
+			}
+
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 			progress += HPAGE_PMD_NR;
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-add-struct-collapse_control-fix.patch
mm-khugepaged-add-struct-collapse_control-fix-fix-fix.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior-fix.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-2.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-3.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
mm-madvise-add-madv_collapse-to-process_madvise-fix.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch
mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch
mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch
mm-madvise-add-file-and-shmem-support-to-madv_collapse.patch
mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch
selftests-vm-dedup-thp-helpers.patch
selftests-vm-modularize-thp-collapse-memory-operations.patch
selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch
selftests-vm-add-thp-collapse-shmem-testing.patch
selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch
selftests-vm-add-selftest-for-madv_collapse-of-uffd-minor-memory.patch

