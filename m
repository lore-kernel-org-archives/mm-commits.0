From: akpm@linux-foundation.org
Subject: [merged] mmksm-foll_migration-do-migration_entry_wait.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:08 -0800
Message-ID: <20130225205608.CB5A231C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:38709 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab3BYU4K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:10 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so347879vch.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, hannes@cmpxchg.org, izik.eidus@ravellosystems.com, mgorman@suse.de, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,ksm: FOLL_MIGRATION do migration_entry_wait
has been removed from the -mm tree.  Its filename was
     mmksm-foll_migration-do-migration_entry_wait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm,ksm: FOLL_MIGRATION do migration_entry_wait

In "ksm: remove old stable nodes more thoroughly" I said that I'd never
seen its WARN_ON_ONCE(page_mapped(page)).  True at the time of writing,
but it soon appeared once I tried fuller tests on the whole series.

It turned out to be due to the KSM page migration itself: unmerge_and_
remove_all_rmap_items() failed to locate and replace all the KSM pages,
because of that hiatus in page migration when old pte has been replaced by
migration entry, but not yet by new pte.  follow_page() finds no page at
that instant, but a KSM page reappears shortly after, without a fault.

Add FOLL_MIGRATION flag, so follow_page() can do migration_entry_wait()
for KSM's break_cow().  I'd have preferred to avoid another flag, and do
it every time, in case someone else makes the same easy mistake; but did
not find another transgressor (the common get_user_pages() is of course
safe), and cannot be sure that every follow_page() caller is prepared to
sleep - ia64's xencomm_vtop()?  Now, THP's wait_split_huge_page() can
already sleep there, since anon_vma locking was changed to mutex, but
maybe that's somehow excluded.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/ksm.c           |    2 +-
 mm/memory.c        |   20 ++++++++++++++++++--
 3 files changed, 20 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mmksm-foll_migration-do-migration_entry_wait include/linux/mm.h
--- a/include/linux/mm.h~mmksm-foll_migration-do-migration_entry_wait
+++ a/include/linux/mm.h
@@ -1651,6 +1651,7 @@ static inline struct page *follow_page(s
 #define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
 #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
+#define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff -puN mm/ksm.c~mmksm-foll_migration-do-migration_entry_wait mm/ksm.c
--- a/mm/ksm.c~mmksm-foll_migration-do-migration_entry_wait
+++ a/mm/ksm.c
@@ -364,7 +364,7 @@ static int break_ksm(struct vm_area_stru
 
 	do {
 		cond_resched();
-		page = follow_page(vma, addr, FOLL_GET);
+		page = follow_page(vma, addr, FOLL_GET | FOLL_MIGRATION);
 		if (IS_ERR_OR_NULL(page))
 			break;
 		if (PageKsm(page))
diff -puN mm/memory.c~mmksm-foll_migration-do-migration_entry_wait mm/memory.c
--- a/mm/memory.c~mmksm-foll_migration-do-migration_entry_wait
+++ a/mm/memory.c
@@ -1548,8 +1548,24 @@ split_fallthrough:
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 
 	pte = *ptep;
-	if (!pte_present(pte))
-		goto no_page;
+	if (!pte_present(pte)) {
+		swp_entry_t entry;
+		/*
+		 * KSM's break_ksm() relies upon recognizing a ksm page
+		 * even while it is being migrated, so for that case we
+		 * need migration_entry_wait().
+		 */
+		if (likely(!(flags & FOLL_MIGRATION)))
+			goto no_page;
+		if (pte_none(pte) || pte_file(pte))
+			goto no_page;
+		entry = pte_to_swp_entry(pte);
+		if (!is_migration_entry(entry))
+			goto no_page;
+		pte_unmap_unlock(ptep, ptl);
+		migration_entry_wait(mm, pmd, address);
+		goto split_fallthrough;
+	}
 	if ((flags & FOLL_NUMA) && pte_numa(pte))
 		goto no_page;
 	if ((flags & FOLL_WRITE) && !pte_write(pte))
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

