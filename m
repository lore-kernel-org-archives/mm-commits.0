Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65260C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 21:04:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240224AbiGHVEq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 17:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240188AbiGHVEp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 17:04:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A122BB14
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 14:04:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DA40B804A4
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 21:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C914EC341C0;
        Fri,  8 Jul 2022 21:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657314280;
        bh=TRpluUsWw7clo7WUkLnHwDdkEHhEp8MEKJ8NymtTyuM=;
        h=Date:To:From:Subject:From;
        b=qCWbE6Hm5XDfESruqhEXvqfh6UDE2I8Ou66CN+/cF7MOwLg4GQF5oH+IwQkrt4aIb
         9zHpuNNaX5uoinQT9358pxyV9AoZeHm3JVRzPxOcEtyKHVjW6BKYNrKaU/qhSm8HFk
         0O3ASEXn3TP+Wpp8EUp9Jr07inUBWEfjWSqc+bmM=
Date:   Fri, 08 Jul 2022 14:04:40 -0700
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
Subject: + mm-khugepaged-add-struct-collapse_control.patch added to mm-unstable branch
Message-Id: <20220708210440.C914EC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: add struct collapse_control
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-add-struct-collapse_control.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-add-struct-collapse_control.patch

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
Subject: mm/khugepaged: add struct collapse_control
Date: Wed, 6 Jul 2022 16:59:21 -0700

Modularize hugepage collapse by introducing struct collapse_control.  This
structure serves to describe the properties of the requested collapse, as
well as serve as a local scratch pad to use during the collapse itself.

Start by moving global per-node khugepaged statistics into this new
structure.  Note that this structure is still statically allocated since
CONFIG_NODES_SHIFT might be arbitrary large, and stack-allocating a
MAX_NUMNODES-sized array could cause -Wframe-large-than= errors.

Link: https://lkml.kernel.org/r/20220706235936.2197195-4-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
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
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   87 ++++++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 37 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-add-struct-collapse_control
+++ a/mm/khugepaged.c
@@ -85,6 +85,14 @@ static struct kmem_cache *mm_slot_cache
 
 #define MAX_PTE_MAPPED_THP 8
 
+struct collapse_control {
+	/* Num pages scanned per node */
+	int node_load[MAX_NUMNODES];
+
+	/* Last target selected in khugepaged_find_target_node() */
+	int last_target_node;
+};
+
 /**
  * struct mm_slot - hash lookup from mm to mm_slot
  * @hash: hash collision list
@@ -735,9 +743,12 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-static int khugepaged_node_load[MAX_NUMNODES];
 
-static bool khugepaged_scan_abort(int nid)
+struct collapse_control khugepaged_collapse_control = {
+	.last_target_node = NUMA_NO_NODE,
+};
+
+static bool khugepaged_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
 
@@ -749,11 +760,11 @@ static bool khugepaged_scan_abort(int ni
 		return false;
 
 	/* If there is a count for this node already, it must be acceptable */
-	if (khugepaged_node_load[nid])
+	if (cc->node_load[nid])
 		return false;
 
 	for (i = 0; i < MAX_NUMNODES; i++) {
-		if (!khugepaged_node_load[i])
+		if (!cc->node_load[i])
 			continue;
 		if (node_distance(nid, i) > node_reclaim_distance)
 			return true;
@@ -772,32 +783,31 @@ static inline gfp_t alloc_hugepage_khuge
 }
 
 #ifdef CONFIG_NUMA
-static int khugepaged_find_target_node(void)
+static int khugepaged_find_target_node(struct collapse_control *cc)
 {
-	static int last_khugepaged_target_node = NUMA_NO_NODE;
 	int nid, target_node = 0, max_value = 0;
 
 	/* find first node with max normal pages hit */
 	for (nid = 0; nid < MAX_NUMNODES; nid++)
-		if (khugepaged_node_load[nid] > max_value) {
-			max_value = khugepaged_node_load[nid];
+		if (cc->node_load[nid] > max_value) {
+			max_value = cc->node_load[nid];
 			target_node = nid;
 		}
 
 	/* do some balance if several nodes have the same hit record */
-	if (target_node <= last_khugepaged_target_node)
-		for (nid = last_khugepaged_target_node + 1; nid < MAX_NUMNODES;
-				nid++)
-			if (max_value == khugepaged_node_load[nid]) {
+	if (target_node <= cc->last_target_node)
+		for (nid = cc->last_target_node + 1; nid < MAX_NUMNODES;
+		     nid++)
+			if (max_value == cc->node_load[nid]) {
 				target_node = nid;
 				break;
 			}
 
-	last_khugepaged_target_node = target_node;
+	cc->last_target_node = target_node;
 	return target_node;
 }
 #else
-static int khugepaged_find_target_node(void)
+static int khugepaged_find_target_node(struct collapse_control *cc)
 {
 	return 0;
 }
@@ -1075,10 +1085,9 @@ out_nolock:
 	return;
 }
 
-static int khugepaged_scan_pmd(struct mm_struct *mm,
-			       struct vm_area_struct *vma,
-			       unsigned long address,
-			       struct page **hpage)
+static int khugepaged_scan_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
+			       unsigned long address, struct page **hpage,
+			       struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
@@ -1098,7 +1107,7 @@ static int khugepaged_scan_pmd(struct mm
 		goto out;
 	}
 
-	memset(khugepaged_node_load, 0, sizeof(khugepaged_node_load));
+	memset(cc->node_load, 0, sizeof(cc->node_load));
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 	for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, _address += PAGE_SIZE) {
@@ -1164,16 +1173,16 @@ static int khugepaged_scan_pmd(struct mm
 
 		/*
 		 * Record which node the original page is from and save this
-		 * information to khugepaged_node_load[].
+		 * information to cc->node_load[].
 		 * Khugepaged will allocate hugepage from the node has the max
 		 * hit record.
 		 */
 		node = page_to_nid(page);
-		if (khugepaged_scan_abort(node)) {
+		if (khugepaged_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			goto out_unmap;
 		}
-		khugepaged_node_load[node]++;
+		cc->node_load[node]++;
 		if (!PageLRU(page)) {
 			result = SCAN_PAGE_LRU;
 			goto out_unmap;
@@ -1224,7 +1233,7 @@ static int khugepaged_scan_pmd(struct mm
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (ret) {
-		node = khugepaged_find_target_node();
+		node = khugepaged_find_target_node(cc);
 		/* collapse_huge_page will return with the mmap_lock released */
 		collapse_huge_page(mm, address, hpage, node,
 				referenced, unmapped);
@@ -1879,8 +1888,9 @@ out:
 	/* TODO: tracepoints */
 }
 
-static void khugepaged_scan_file(struct mm_struct *mm,
-		struct file *file, pgoff_t start, struct page **hpage)
+static void khugepaged_scan_file(struct mm_struct *mm, struct file *file,
+				 pgoff_t start, struct page **hpage,
+				 struct collapse_control *cc)
 {
 	struct page *page = NULL;
 	struct address_space *mapping = file->f_mapping;
@@ -1891,7 +1901,7 @@ static void khugepaged_scan_file(struct
 
 	present = 0;
 	swap = 0;
-	memset(khugepaged_node_load, 0, sizeof(khugepaged_node_load));
+	memset(cc->node_load, 0, sizeof(cc->node_load));
 	rcu_read_lock();
 	xas_for_each(&xas, page, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, page))
@@ -1916,11 +1926,11 @@ static void khugepaged_scan_file(struct
 		}
 
 		node = page_to_nid(page);
-		if (khugepaged_scan_abort(node)) {
+		if (khugepaged_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			break;
 		}
-		khugepaged_node_load[node]++;
+		cc->node_load[node]++;
 
 		if (!PageLRU(page)) {
 			result = SCAN_PAGE_LRU;
@@ -1953,7 +1963,7 @@ static void khugepaged_scan_file(struct
 			result = SCAN_EXCEED_NONE_PTE;
 			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 		} else {
-			node = khugepaged_find_target_node();
+			node = khugepaged_find_target_node(cc);
 			collapse_file(mm, file, start, hpage, node);
 		}
 	}
@@ -1961,8 +1971,9 @@ static void khugepaged_scan_file(struct
 	/* TODO: tracepoints */
 }
 #else
-static void khugepaged_scan_file(struct mm_struct *mm,
-		struct file *file, pgoff_t start, struct page **hpage)
+static void khugepaged_scan_file(struct mm_struct *mm, struct file *file,
+				 pgoff_t start, struct page **hpage,
+				 struct collapse_control *cc)
 {
 	BUILD_BUG();
 }
@@ -1973,7 +1984,8 @@ static void khugepaged_collapse_pte_mapp
 #endif
 
 static unsigned int khugepaged_scan_mm_slot(unsigned int pages,
-					    struct page **hpage)
+					    struct page **hpage,
+					    struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
 {
@@ -2050,12 +2062,13 @@ skip:
 
 				mmap_read_unlock(mm);
 				ret = 1;
-				khugepaged_scan_file(mm, file, pgoff, hpage);
+				khugepaged_scan_file(mm, file, pgoff, hpage,
+						     cc);
 				fput(file);
 			} else {
 				ret = khugepaged_scan_pmd(mm, vma,
 						khugepaged_scan.address,
-						hpage);
+						hpage, cc);
 			}
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
@@ -2111,7 +2124,7 @@ static int khugepaged_wait_event(void)
 		kthread_should_stop();
 }
 
-static void khugepaged_do_scan(void)
+static void khugepaged_do_scan(struct collapse_control *cc)
 {
 	struct page *hpage = NULL;
 	unsigned int progress = 0, pass_through_head = 0;
@@ -2132,7 +2145,7 @@ static void khugepaged_do_scan(void)
 		if (khugepaged_has_work() &&
 		    pass_through_head < 2)
 			progress += khugepaged_scan_mm_slot(pages - progress,
-							    &hpage);
+							    &hpage, cc);
 		else
 			progress = pages;
 		spin_unlock(&khugepaged_mm_lock);
@@ -2188,7 +2201,7 @@ static int khugepaged(void *none)
 	set_user_nice(current, MAX_NICE);
 
 	while (!kthread_should_stop()) {
-		khugepaged_do_scan();
+		khugepaged_do_scan(&khugepaged_collapse_control);
 		khugepaged_wait_work();
 	}
 
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

