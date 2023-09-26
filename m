Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B0CE7F14B
	for <mm-commits@archiver.kernel.org>; Tue, 26 Sep 2023 23:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjIZXSE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Sep 2023 19:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbjIZXPz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2023 19:15:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F5317806
        for <mm-commits@vger.kernel.org>; Tue, 26 Sep 2023 15:17:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFFAC116CB;
        Tue, 26 Sep 2023 21:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695764384;
        bh=H1zir4Gsat5fQrvdZR5QmbasHQzVIQE4SbUc5Sxj/84=;
        h=Date:To:From:Subject:From;
        b=tBrho8+LRqBeViWD6XbjT7Uq/Z/dCfr7NJaIYbD+L15jC2OJ8Dg0tX7nykMe283hZ
         lYtb95ikqYuaLBd+x7rnWxzSOx7idCL/bU/EpNJ/uHQqtP8bmDoFss56nAkWUIhyWk
         zmLaKkJ0HPfH6TvVWf7l8Zg0DWMMDsXfBODlMgcc=
Date:   Tue, 26 Sep 2023 14:39:43 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, rientjes@google.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mhocko@suse.com, linmiaohe@huawei.com,
        jthoughton@google.com, joao.m.martins@oracle.com,
        duanxiongchun@bytedance.com, david@redhat.com,
        anshuman.khandual@arm.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-perform-vmemmap-optimization-on-a-list-of-pages.patch added to mm-unstable branch
Message-Id: <20230926213944.6EFFAC116CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: perform vmemmap optimization on a list of pages
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-perform-vmemmap-optimization-on-a-list-of-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-perform-vmemmap-optimization-on-a-list-of-pages.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: perform vmemmap optimization on a list of pages
Date: Mon, 25 Sep 2023 16:48:31 -0700

When adding hugetlb pages to the pool, we first create a list of the
allocated pages before adding to the pool.  Pass this list of pages to a
new routine hugetlb_vmemmap_optimize_folios() for vmemmap optimization.

Due to significant differences in vmemmmap initialization for bootmem
allocated hugetlb pages, a new routine prep_and_add_bootmem_folios is
created.

We also modify the routine vmemmap_should_optimize() to check for pages
that are already optimized.  There are code paths that might request
vmemmap optimization twice and we want to make sure this is not attempted.

Link: https://lkml.kernel.org/r/20230925234837.86786-4-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c         |   42 +++++++++++++++++++++++++++++++++--------
 mm/hugetlb_vmemmap.c |   11 ++++++++++
 mm/hugetlb_vmemmap.h |    5 ++++
 3 files changed, 50 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~hugetlb-perform-vmemmap-optimization-on-a-list-of-pages
+++ a/mm/hugetlb.c
@@ -2137,6 +2137,9 @@ static void prep_and_add_allocated_folio
 {
 	struct folio *folio, *tmp_f;
 
+	/* Send list for bulk vmemmap optimization processing */
+	hugetlb_vmemmap_optimize_folios(h, folio_list);
+
 	/* Add all new pool pages to free lists in one lock cycle */
 	spin_lock_irq(&hugetlb_lock);
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
@@ -3173,6 +3176,34 @@ static void __init hugetlb_folio_init_vm
 	prep_compound_head((struct page *)folio, huge_page_order(h));
 }
 
+static void __init prep_and_add_bootmem_folios(struct hstate *h,
+					struct list_head *folio_list)
+{
+	struct folio *folio, *tmp_f;
+
+	/* Send list for bulk vmemmap optimization processing */
+	hugetlb_vmemmap_optimize_folios(h, folio_list);
+
+	/* Add all new pool pages to free lists in one lock cycle */
+	spin_lock_irq(&hugetlb_lock);
+	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
+		if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
+			/*
+			 * If HVO fails, initialize all tail struct pages
+			 * We do not worry about potential long lock hold
+			 * time as this is early in boot and there should
+			 * be no contention.
+			 */
+			hugetlb_folio_init_tail_vmemmap(folio,
+					HUGETLB_VMEMMAP_RESERVE_PAGES,
+					pages_per_huge_page(h));
+		}
+		__prep_account_new_huge_page(h, folio_nid(folio));
+		enqueue_hugetlb_folio(h, folio);
+	}
+	spin_unlock_irq(&hugetlb_lock);
+}
+
 /*
  * Put bootmem huge pages into the standard lists after mem_map is up.
  * Note: This only applies to gigantic (order > MAX_ORDER) pages.
@@ -3193,7 +3224,7 @@ static void __init gather_bootmem_preall
 		 * in this list.  If so, process each size separately.
 		 */
 		if (h != prev_h && prev_h != NULL)
-			prep_and_add_allocated_folios(prev_h, &folio_list);
+			prep_and_add_bootmem_folios(prev_h, &folio_list);
 		prev_h = h;
 
 		VM_BUG_ON(!hstate_is_gigantic(h));
@@ -3201,12 +3232,7 @@ static void __init gather_bootmem_preall
 
 		hugetlb_folio_init_vmemmap(folio, h,
 					   HUGETLB_VMEMMAP_RESERVE_PAGES);
-		__prep_new_hugetlb_folio(h, folio);
-		/* If HVO fails, initialize all tail struct pages */
-		if (!HPageVmemmapOptimized(&folio->page))
-			hugetlb_folio_init_tail_vmemmap(folio,
-						HUGETLB_VMEMMAP_RESERVE_PAGES,
-						pages_per_huge_page(h));
+		init_new_hugetlb_folio(h, folio);
 		list_add(&folio->lru, &folio_list);
 
 		/*
@@ -3218,7 +3244,7 @@ static void __init gather_bootmem_preall
 		cond_resched();
 	}
 
-	prep_and_add_allocated_folios(h, &folio_list);
+	prep_and_add_bootmem_folios(h, &folio_list);
 }
 
 static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
--- a/mm/hugetlb_vmemmap.c~hugetlb-perform-vmemmap-optimization-on-a-list-of-pages
+++ a/mm/hugetlb_vmemmap.c
@@ -483,6 +483,9 @@ int hugetlb_vmemmap_restore(const struct
 /* Return true iff a HugeTLB whose vmemmap should and can be optimized. */
 static bool vmemmap_should_optimize(const struct hstate *h, const struct page *head)
 {
+	if (HPageVmemmapOptimized((struct page *)head))
+		return false;
+
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return false;
 
@@ -572,6 +575,14 @@ void hugetlb_vmemmap_optimize(const stru
 		SetHPageVmemmapOptimized(head);
 }
 
+void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
+{
+	struct folio *folio;
+
+	list_for_each_entry(folio, folio_list, lru)
+		hugetlb_vmemmap_optimize(h, &folio->page);
+}
+
 static struct ctl_table hugetlb_vmemmap_sysctls[] = {
 	{
 		.procname	= "hugetlb_optimize_vmemmap",
--- a/mm/hugetlb_vmemmap.h~hugetlb-perform-vmemmap-optimization-on-a-list-of-pages
+++ a/mm/hugetlb_vmemmap.h
@@ -20,6 +20,7 @@
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int hugetlb_vmemmap_restore(const struct hstate *h, struct page *head);
 void hugetlb_vmemmap_optimize(const struct hstate *h, struct page *head);
+void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
 {
@@ -48,6 +49,10 @@ static inline void hugetlb_vmemmap_optim
 {
 }
 
+static inline void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
+{
+}
+
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
 	return 0;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-set-hugetlb-page-flag-before-optimizing-vmemmap.patch
hugetlb-optimize-update_and_free_pages_bulk-to-avoid-lock-cycles.patch
hugetlb-restructure-pool-allocations.patch
hugetlb-perform-vmemmap-optimization-on-a-list-of-pages.patch
hugetlb-perform-vmemmap-restoration-on-a-list-of-pages.patch
hugetlb-batch-freeing-of-vmemmap-pages.patch
hugetlb-batch-tlb-flushes-when-restoring-vmemmap.patch

