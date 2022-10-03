Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D801FC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiJCVFu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiJCVFN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC63511A09
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DE9B611D9
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8188FC433D6;
        Mon,  3 Oct 2022 21:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831094;
        bh=HrxrOGtWvVxZK0qGwzM1tds9dQHXW4bCWzqHq3AHoPc=;
        h=Date:To:From:Subject:From;
        b=mamwC7DtaT4mIlNztcye0OdVO5V18eJar+qDG+rqOAgaDtQDG1mlpoNUOJmELM9t/
         lBV3RNm9XeKzmMOMKPRne1h/TUL/Xx0+zAlCNA7sAuCwu9LgbrDV1DtrrJWtAmalIQ
         SLbWEnC+dehZ1DxOiT3Mu3iHr0w3L9NYhQARjzd0=
Date:   Mon, 03 Oct 2022 14:04:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio.patch removed from -mm tree
Message-Id: <20221003210454.8188FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: convert mem_cgroup_swapin_charge_page() to mem_cgroup_swapin_charge_folio()
has been removed from the -mm tree.  Its filename was
     memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memcg: convert mem_cgroup_swapin_charge_page() to mem_cgroup_swapin_charge_folio()
Date: Fri, 2 Sep 2022 20:46:12 +0100

All callers now have a folio, so pass it in here and remove an unnecessary
call to page_folio().

Link: https://lkml.kernel.org/r/20220902194653.1739778-17-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   13 ++++++-------
 mm/memory.c                |    2 +-
 mm/swap_state.c            |    2 +-
 4 files changed, 10 insertions(+), 11 deletions(-)

--- a/include/linux/memcontrol.h~memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio
+++ a/include/linux/memcontrol.h
@@ -688,7 +688,7 @@ static inline int mem_cgroup_charge(stru
 	return __mem_cgroup_charge(folio, mm, gfp);
 }
 
-int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
+int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry);
 void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry);
 
@@ -1254,7 +1254,7 @@ static inline int mem_cgroup_charge(stru
 	return 0;
 }
 
-static inline int mem_cgroup_swapin_charge_page(struct page *page,
+static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 			struct mm_struct *mm, gfp_t gfp, swp_entry_t entry)
 {
 	return 0;
--- a/mm/memcontrol.c~memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio
+++ a/mm/memcontrol.c
@@ -6844,21 +6844,20 @@ int __mem_cgroup_charge(struct folio *fo
 }
 
 /**
- * mem_cgroup_swapin_charge_page - charge a newly allocated page for swapin
- * @page: page to charge
+ * mem_cgroup_swapin_charge_folio - Charge a newly allocated folio for swapin.
+ * @folio: folio to charge.
  * @mm: mm context of the victim
  * @gfp: reclaim mode
- * @entry: swap entry for which the page is allocated
+ * @entry: swap entry for which the folio is allocated
  *
- * This function charges a page allocated for swapin. Please call this before
- * adding the page to the swapcache.
+ * This function charges a folio allocated for swapin. Please call this before
+ * adding the folio to the swapcache.
  *
  * Returns 0 on success. Otherwise, an error code is returned.
  */
-int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
+int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry)
 {
-	struct folio *folio = page_folio(page);
 	struct mem_cgroup *memcg;
 	unsigned short id;
 	int ret;
--- a/mm/memory.c~memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio
+++ a/mm/memory.c
@@ -3783,7 +3783,7 @@ vm_fault_t do_swap_page(struct vm_fault
 				__folio_set_locked(folio);
 				__folio_set_swapbacked(folio);
 
-				if (mem_cgroup_swapin_charge_page(page,
+				if (mem_cgroup_swapin_charge_folio(folio,
 							vma->vm_mm, GFP_KERNEL,
 							entry)) {
 					ret = VM_FAULT_OOM;
--- a/mm/swap_state.c~memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio
+++ a/mm/swap_state.c
@@ -480,7 +480,7 @@ struct page *__read_swap_cache_async(swp
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
 
-	if (mem_cgroup_swapin_charge_page(&folio->page, NULL, gfp_mask, entry))
+	if (mem_cgroup_swapin_charge_folio(folio, NULL, gfp_mask, entry))
 		goto fail_unlock;
 
 	/* May fail (-ENOMEM) if XArray node allocation failed. */
_

Patches currently in -mm which might be from willy@infradead.org are


