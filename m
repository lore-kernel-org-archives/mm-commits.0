Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A26FC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:14:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiLLCOJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiLLCNw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:13:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8C765A2
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:13:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64E7260EB9
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC85C433EF;
        Mon, 12 Dec 2022 02:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811220;
        bh=Q+cvAKRWy4bqIi0ERHSz0PV6gRdcPFME5ZGOdgEk0Uo=;
        h=Date:To:From:Subject:From;
        b=d1dt23i+MjoZApcddNnYzMZ4u9n3lYl1bT7yr2GRu+Ig/LCN5INNU6UTxO7f090OF
         sm/tYa6vuj9jwmvlUe1l3rrvyY0eTJmoFwXYELQPOPtDfNiXT7mb3g7pedqARwuHuv
         KGwOus+OCcKtOI4OOhKppU2k7stZHD9wHwRbvOgE=
Date:   Sun, 11 Dec 2022 18:13:40 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch removed from -mm tree
Message-Id: <20221212021340.BAC85C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/ksm: convert break_ksm() to use walk_page_range_vma()
has been removed from the -mm tree.  Its filename was
     mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/ksm: convert break_ksm() to use walk_page_range_vma()
Date: Fri, 21 Oct 2022 12:11:40 +0200

FOLL_MIGRATION exists only for the purpose of break_ksm(), and actually,
there is not even the need to wait for the migration to finish, we only
want to know if we're dealing with a KSM page.

Using follow_page() just to identify a KSM page overcomplicates GUP code. 
Let's use walk_page_range_vma() instead, because we don't actually care
about the page itself, we only need to know a single property -- no need
to even grab a reference.

So, get rid of follow_page() usage such that we can get rid of
FOLL_MIGRATION now and eventually be able to get rid of follow_page() in
the future.

In my setup (AMD Ryzen 9 3900X), running the KSM selftest to test unmerge
performance on 2 GiB (taskset 0x8 ./ksm_tests -D -s 2048), this results in
a performance degradation of ~2% (old: ~5010 MiB/s, new: ~4900 MiB/s).  I
don't think we particularly care for now.

Interestingly, the benchmark reduction is due to the single callback. 
Adding a second callback (e.g., pud_entry()) reduces the benchmark by
another 100-200 MiB/s.

Link: https://lkml.kernel.org/r/20221021101141.84170-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   49 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 10 deletions(-)

--- a/mm/ksm.c~mm-ksm-convert-break_ksm-to-use-walk_page_range_vma
+++ a/mm/ksm.c
@@ -39,6 +39,7 @@
 #include <linux/freezer.h>
 #include <linux/oom.h>
 #include <linux/numa.h>
+#include <linux/pagewalk.h>
 
 #include <asm/tlbflush.h>
 #include "internal.h"
@@ -419,6 +420,39 @@ static inline bool ksm_test_exit(struct
 	return atomic_read(&mm->mm_users) == 0;
 }
 
+static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
+			struct mm_walk *walk)
+{
+	struct page *page = NULL;
+	spinlock_t *ptl;
+	pte_t *pte;
+	int ret;
+
+	if (pmd_leaf(*pmd) || !pmd_present(*pmd))
+		return 0;
+
+	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (pte_present(*pte)) {
+		page = vm_normal_page(walk->vma, addr, *pte);
+	} else if (!pte_none(*pte)) {
+		swp_entry_t entry = pte_to_swp_entry(*pte);
+
+		/*
+		 * As KSM pages remain KSM pages until freed, no need to wait
+		 * here for migration to end.
+		 */
+		if (is_migration_entry(entry))
+			page = pfn_swap_entry_to_page(entry);
+	}
+	ret = page && PageKsm(page);
+	pte_unmap_unlock(pte, ptl);
+	return ret;
+}
+
+static const struct mm_walk_ops break_ksm_ops = {
+	.pmd_entry = break_ksm_pmd_entry,
+};
+
 /*
  * We use break_ksm to break COW on a ksm page by triggering unsharing,
  * such that the ksm page will get replaced by an exclusive anonymous page.
@@ -434,21 +468,16 @@ static inline bool ksm_test_exit(struct
  */
 static int break_ksm(struct vm_area_struct *vma, unsigned long addr)
 {
-	struct page *page;
 	vm_fault_t ret = 0;
 
 	do {
-		bool ksm_page = false;
+		int ksm_page;
 
 		cond_resched();
-		page = follow_page(vma, addr,
-				FOLL_GET | FOLL_MIGRATION | FOLL_REMOTE);
-		if (IS_ERR_OR_NULL(page))
-			break;
-		if (PageKsm(page))
-			ksm_page = true;
-		put_page(page);
-
+		ksm_page = walk_page_range_vma(vma, addr, addr + 1,
+					       &break_ksm_ops, NULL);
+		if (WARN_ON_ONCE(ksm_page < 0))
+			return ksm_page;
 		if (!ksm_page)
 			return 0;
 		ret = handle_mm_fault(vma, addr,
_

Patches currently in -mm which might be from david@redhat.com are


