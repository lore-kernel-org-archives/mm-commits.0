Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA93C6FA90
	for <mm-commits@archiver.kernel.org>; Sun, 25 Sep 2022 19:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbiIYTOA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Sep 2022 15:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbiIYTNv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Sep 2022 15:13:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123C6286D0
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 12:13:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5EF1B80B4D
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 19:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40569C433C1;
        Sun, 25 Sep 2022 19:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664133210;
        bh=SHKq+rKTTDjlcX6eMu2ItlviBFqtsnHgvZ2QCV+d7tA=;
        h=Date:To:From:Subject:From;
        b=jj7TReM0SGK/Ukqhb0MToUSyzuGrl5evO1wjqBhObL/y7tob+h1FApv26Vi3LpKZj
         WBcIRjNnoaM4LppBosntol9arDK9IQw7xvVZj4JHPoucQH0sC3Us8ow/BFqkTBaH3q
         Fc8XYp/I9B/eLmdapaQH8khXbGYwCqQpHqF3n6w8=
Date:   Sun, 25 Sep 2022 12:13:28 -0700
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
Message-Id: <20220925191330.40569C433C1@smtp.kernel.org>
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
Date: Thu, 22 Sep 2022 15:40:38 -0700

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

Identify pte-mapped hugepages in the file/shmem collapse path.  The
final step of which makes a racy check of the value of the pmd to
ensure it maps a pte table.  This should be fine, since races that
result in false-positive (i.e.  attempt collapse even though we
shouldn't) will fail later in collapse_pte_mapped_thp() once we
actually lock mmap_lock and reinspect the pmd value.  Races that result
in false-negatives (i.e.  where we decide to not attempt collapse, but
should have) shouldn't be an issue, since in the worst case, we do
nothing - which is what we've done up to this point.  We make a similar
check in retract_page_tables().  If we do think we've found a
pte-mapped hugepgae in khugepaged context, attempt to update page
tables mapping this hugepage.

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

[shy828301@gmail.com: Spelling mistake, update comment, and add Documentation]
  Link: https://lore.kernel.org/linux-mm/CAHbLzkpHwZxFzjfX9nxVoRhzup8WMjMfyL6Xiq8mZ9M-N3ombw@mail.gmail.com/
Link: https://lkml.kernel.org/r/20220907144521.3115321-3-zokeefe@google.com
Link: https://lkml.kernel.org/r/20220922224046.1143204-3-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/admin-guide/mm/transhuge.rst~mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -191,7 +191,14 @@ allocation failure to throttle the next
 
 	/sys/kernel/mm/transparent_hugepage/khugepaged/alloc_sleep_millisecs
 
-The khugepaged progress can be seen in the number of pages collapsed::
+The khugepaged progress can be seen in the number of pages collapsed (note
+that this counter may not be an exact count of the number of pages
+collapsed, since "collapsed" could mean multiple things: (1) A PTE mapping
+being replaced by a PMD mapping, or (2) All 4K physical pages replaced by
+one 2M hugepage. Each may happen independently, or together, depending on
+the type of memory and the failures that occur. As such, this value should
+be interpreted roughly as a sign of progress, and counters in /proc/vmstat
+consulted for more accurate accounting)::
 
 	/sys/kernel/mm/transparent_hugepage/khugepaged/pages_collapsed
 
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
+	/* Fast check before locking page if not PMD mapping PTE table */
+	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
+	if (result != SCAN_SUCCEED)
+		return;
+
 	if (!vma || !vma->vm_file ||
 	    !range_in_vma(vma, haddr, haddr + HPAGE_PMD_SIZE))
 		return;
@@ -1726,9 +1738,16 @@ static int collapse_file(struct mm_struc
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
 
@@ -1962,11 +1981,23 @@ static int khugepaged_scan_file(struct m
 		}
 
 		/*
-		 * XXX: khugepaged should compact smaller compound pages
+		 * TODO: khugepaged should compact smaller compound pages
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
 
@@ -2026,6 +2057,12 @@ static int khugepaged_scan_file(struct m
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
@@ -2118,8 +2155,26 @@ skip:
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

mm-khugepaged-check-compound_order-in-collapse_pte_mapped_thp.patch
mm-madvise-madv_collapse-return-eagain-when-page-cannot-be-isolated.patch
selftests-vm-retry-on-eagain-for-madv_collapse-selftest.patch
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

