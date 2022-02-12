Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4C5C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 12 Feb 2022 00:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242447AbiBLAVK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 19:21:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiBLAVK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 19:21:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC11D7A;
        Fri, 11 Feb 2022 16:21:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A977DB82DED;
        Sat, 12 Feb 2022 00:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2EFC340E9;
        Sat, 12 Feb 2022 00:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644625265;
        bh=ZLNkiTjUdSrqMxnhE1vPdZvjPQSOIuV6bT/kuw7tCz4=;
        h=Date:To:From:Subject:From;
        b=0IoPAk5887qCEo1v1DAcs8KEOmlkEyclHIGB5bJno6DBCaW9yLjRMy3icggiPLVcI
         MPUGvL0jla1U9kI23hepnekc/VE6R4y22pnWmAPBihh+EfZT2H37LM+rrpS+ppSNOo
         Aj2PYAM50kHMT33oHhVXYnFtzzgtF/iNfVfCz1Lo=
Date:   Fri, 11 Feb 2022 16:21:04 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, kirill.shutemov@linux.intel.com,
        jannh@google.com, david@redhat.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry-v4.patch removed from -mm tree
Message-Id: <20220212002105.5B2EFC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry-v4
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry-v4.patch

This patch was dropped because it was folded into fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry.patch

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry-v4

v4: * s/Treated/Treat per David
    * Collected acked-by tag from David
v3: * Fixed the fix tag, the one used by v2 was not accurate
    * Added comment about the risk calling page_mapcount() per David
    * Fix pagemap

Link: https://lkml.kernel.org/r/20220203182641.824731-1-shy828301@gmail.com
Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reported-by: syzbot+1f52b3a18d5633fa7f82@syzkaller.appspotmail.com
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry-v4
+++ a/fs/proc/task_mmu.c
@@ -469,9 +469,12 @@ static void smaps_account(struct mem_siz
 	 * If any subpage of the compound page mapped with PTE it would elevate
 	 * page_count().
 	 *
-	 * Treated regular migration entries as mapcount == 1 without reading
-	 * mapcount since calling page_mapcount() for migration entries is
-	 * racy against THP splitting.
+	 * The page_mapcount() is called to get a snapshot of the mapcount.
+	 * Without holding the page lock this snapshot can be slightly wrong as
+	 * we cannot always read the mapcount atomically.  It is not safe to
+	 * call page_mapcount() even with PTL held if the page is not mapped,
+	 * especially for migration entries.  Treat regular migration entries
+	 * as mapcount == 1.
 	 */
 	if ((page_count(page) == 1) || migration) {
 		smaps_page_accumulate(mss, page, size, size << PSS_SHIFT, dirty,
@@ -1393,6 +1396,7 @@ static pagemap_entry_t pte_to_pagemap_en
 {
 	u64 frame = 0, flags = 0;
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pte_present(pte)) {
 		if (pm->show_pfn)
@@ -1414,13 +1418,14 @@ static pagemap_entry_t pte_to_pagemap_en
 			frame = swp_type(entry) |
 				(swp_offset(entry) << MAX_SWAPFILES_SHIFT);
 		flags |= PM_SWAP;
+		migration = is_migration_entry(entry);
 		if (is_pfn_swap_entry(entry))
 			page = pfn_swap_entry_to_page(entry);
 	}
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
-	if (page && page_mapcount(page) == 1)
+	if (page && !migration && page_mapcount(page) == 1)
 		flags |= PM_MMAP_EXCLUSIVE;
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags |= PM_SOFT_DIRTY;
@@ -1436,6 +1441,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 	spinlock_t *ptl;
 	pte_t *pte, *orig_pte;
 	int err = 0;
+	bool migration = false;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	ptl = pmd_trans_huge_lock(pmdp, vma);
@@ -1476,11 +1482,12 @@ static int pagemap_pmd_range(pmd_t *pmdp
 			if (pmd_swp_uffd_wp(pmd))
 				flags |= PM_UFFD_WP;
 			VM_BUG_ON(!is_pmd_migration_entry(pmd));
+			migration = is_migration_entry(entry);
 			page = pfn_swap_entry_to_page(entry);
 		}
 #endif
 
-		if (page && page_mapcount(page) == 1)
+		if (page && !migration && page_mapcount(page) == 1)
 			flags |= PM_MMAP_EXCLUSIVE;
 
 		for (; addr != end; addr += PAGE_SIZE) {
_

Patches currently in -mm which might be from shy828301@gmail.com are

fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry.patch

