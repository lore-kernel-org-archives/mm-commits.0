From: akpm@linux-foundation.org
Subject: + mm-more-likely-reclaim-madv_sequential-mappings.patch added to -mm tree
Date: Sun, 20 Jul 2008 18:47:36 -0700
Message-ID: <200807210147.m6L1laBH011505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756462AbYGUBsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jul 2008 21:48:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     mm: more likely reclaim MADV_SEQUENTIAL mappings
has been added to the -mm tree.  Its filename is
     mm-more-likely-reclaim-madv_sequential-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: more likely reclaim MADV_SEQUENTIAL mappings
From: Johannes Weiner <hannes@saeurebad.de>

File pages accessed only once through sequential-read mappings between
fault and scan time are perfect candidates for reclaim.

This patch makes page_referenced() ignore these singular references and
the pages stay on the inactive list where they likely fall victim to the
next reclaim phase.

Already activated pages are still treated normally.  If they were accessed
multiple times and therefor promoted to the active list, we probably want
to keep them.

Benchmarks show that big (relative to the system's memory) MADV_SEQUENTIAL
mappings read sequentially cause much less kernel activity.  Especially
less LRU moving-around because we never activate read-once pages in the
first place just to demote them again.

And leaving these perfect reclaim candidates on the inactive list makes
it more likely for the real working set to survive the next reclaim
scan.

Benchmark graphs and the test-application can be found here:

	http://hannes.saeurebad.de/madvseq/

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN mm/rmap.c~mm-more-likely-reclaim-madv_sequential-mappings mm/rmap.c
--- a/mm/rmap.c~mm-more-likely-reclaim-madv_sequential-mappings
+++ a/mm/rmap.c
@@ -323,8 +323,18 @@ static int page_referenced_one(struct pa
 		goto out_unmap;
 	}
 
-	if (ptep_clear_flush_young_notify(vma, address, pte))
-		referenced++;
+	if (ptep_clear_flush_young_notify(vma, address, pte)) {
+		/*
+		 * If there was just one sequential access to the
+		 * page, ignore it.  Otherwise, mark_page_accessed()
+		 * will have promoted the page to the active list and
+		 * it should be kept.
+		 */
+		if (VM_SequentialReadHint(vma) && !PageActive(page))
+			ClearPageReferenced(page);
+		else
+			referenced++;
+	}
 
 	/* Pretend the page is referenced if the task has the
 	   swap token and is in the middle of a page fault. */
@@ -445,9 +455,6 @@ int page_referenced(struct page *page, i
 {
 	int referenced = 0;
 
-	if (TestClearPageReferenced(page))
-		referenced++;
-
 	if (page_mapped(page) && page->mapping) {
 		if (PageAnon(page))
 			referenced += page_referenced_anon(page, mem_cont);
@@ -463,6 +470,9 @@ int page_referenced(struct page *page, i
 		}
 	}
 
+	if (TestClearPageReferenced(page))
+		referenced++;
+
 	if (page_test_and_clear_young(page))
 		referenced++;
 
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
linux-next.patch
git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
mm-drop-unneeded-pgdat-argument-from-free_area_init_node.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
vma-page-offset-has-no-callees-drop-it.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages.patch
linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-reorder-code-to-match-new-bootmem-structure.patch
revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-clean-up-bootmemc-file-header.patch
revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-documentation-to-api-functions.patch
revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-debugging-framework.patch
bootmem-add-debugging-framework-fix.patch
bootmem-revisit-bitmap-size-calculations.patch
bootmem-revisit-bootmem-descriptor-list-handling.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-clean-up-alloc_bootmem_core.patch
bootmem-clean-up-alloc_bootmem_core-fix-new-alloc_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-free-reserve-helpers-fix.patch
revert-revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
bootmem-respect-goal-more-likely.patch
bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
bootmem-revisit-alloc_bootmem_section.patch
bootmem-replace-node_boot_start-in-struct-bootmem_data.patch
bootmem-replace-node_boot_start-in-struct-bootmem_data-fix.patch
memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch

