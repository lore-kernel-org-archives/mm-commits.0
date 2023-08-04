Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8304BC04FE1
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 20:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjHDUEU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 16:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjHDUEQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 16:04:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E9610C1;
        Fri,  4 Aug 2023 13:04:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E59BB62125;
        Fri,  4 Aug 2023 20:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FD5C433C8;
        Fri,  4 Aug 2023 20:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691179454;
        bh=6/r7siBWkdIIOVePwgSvLEbQCdl59cOtBnRIZLagt2Q=;
        h=Date:To:From:Subject:From;
        b=1BFguqO1rO22iTKi+Ec+yXFqmsK6brTTc/FaPUDOhkk+NnOX6RS/HKazSa2G/eyEE
         BmVgg/yjbPzUxp3iUhLAaSncYMOu1BGUC59CRvsqPoGcq8lV2SSNmuMLh3iWD4KNLQ
         6PNQEoMJ6wSsehAlEdYAb28h4JmVtbGtfkbHZp8Q=
Date:   Fri, 04 Aug 2023 13:04:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, stable@vger.kernel.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swapfile-fix-wrong-swap-entry-type-for-hwpoisoned-swapcache-page.patch removed from -mm tree
Message-Id: <20230804200414.46FD5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swapfile: fix wrong swap entry type for hwpoisoned swapcache page
has been removed from the -mm tree.  Its filename was
     mm-swapfile-fix-wrong-swap-entry-type-for-hwpoisoned-swapcache-page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile: fix wrong swap entry type for hwpoisoned swapcache page
Date: Thu, 27 Jul 2023 19:56:40 +0800

Patch series "A few fixup patches for mm", v2.

This series contains a few fixup patches to fix potential unexpected
return value, fix wrong swap entry type for hwpoisoned swapcache page and
so on.  More details can be found in the respective changelogs.


This patch (of 3):

Hwpoisoned dirty swap cache page is kept in the swap cache and there's
simple interception code in do_swap_page() to catch it.  But when trying
to swapoff, unuse_pte() will wrongly install a general sense of "future
accesses are invalid" swap entry for hwpoisoned swap cache page due to
unaware of such type of page.  The user will receive SIGBUS signal without
expected BUS_MCEERR_AR payload.  BTW, typo 'hwposioned' is fixed.

Link: https://lkml.kernel.org/r/20230727115643.639741-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20230727115643.639741-2-linmiaohe@huawei.com
Fixes: 6b970599e807 ("mm: hwpoison: support recovery from ksm_might_need_to_copy()")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c      |    2 ++
 mm/swapfile.c |    8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/mm/ksm.c~mm-swapfile-fix-wrong-swap-entry-type-for-hwpoisoned-swapcache-page
+++ a/mm/ksm.c
@@ -2784,6 +2784,8 @@ struct page *ksm_might_need_to_copy(stru
 			anon_vma->root == vma->anon_vma->root) {
 		return page;		/* still no need to copy it */
 	}
+	if (PageHWPoison(page))
+		return ERR_PTR(-EHWPOISON);
 	if (!PageUptodate(page))
 		return page;		/* let do_swap_page report the error */
 
--- a/mm/swapfile.c~mm-swapfile-fix-wrong-swap-entry-type-for-hwpoisoned-swapcache-page
+++ a/mm/swapfile.c
@@ -1746,7 +1746,7 @@ static int unuse_pte(struct vm_area_stru
 	struct page *swapcache;
 	spinlock_t *ptl;
 	pte_t *pte, new_pte, old_pte;
-	bool hwposioned = false;
+	bool hwpoisoned = PageHWPoison(page);
 	int ret = 1;
 
 	swapcache = page;
@@ -1754,7 +1754,7 @@ static int unuse_pte(struct vm_area_stru
 	if (unlikely(!page))
 		return -ENOMEM;
 	else if (unlikely(PTR_ERR(page) == -EHWPOISON))
-		hwposioned = true;
+		hwpoisoned = true;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (unlikely(!pte || !pte_same_as_swp(ptep_get(pte),
@@ -1765,11 +1765,11 @@ static int unuse_pte(struct vm_area_stru
 
 	old_pte = ptep_get(pte);
 
-	if (unlikely(hwposioned || !PageUptodate(page))) {
+	if (unlikely(hwpoisoned || !PageUptodate(page))) {
 		swp_entry_t swp_entry;
 
 		dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
-		if (hwposioned) {
+		if (hwpoisoned) {
 			swp_entry = make_hwpoison_entry(swapcache);
 			page = swapcache;
 		} else {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch
mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch
memory-tier-use-helper-function-destroy_memory_type.patch
mm-memory-failure-remove-unneeded-inline-annotation.patch
mm-mm_initc-remove-obsolete-macro-hash_small.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info.patch
memory-tier-rename-destroy_memory_type-to-put_memory_type.patch
mm-remove-obsolete-comment-above-struct-per_cpu_pages.patch
mm-memcg-minor-cleanup-for-mem_cgroup_id_max.patch
mm-memory-failure-remove-unneeded-pagehuge-check.patch
mm-memory-failure-ensure-moving-hwpoison-flag-to-the-raw-error-pages.patch
mm-memory-failure-dont-account-hwpoison_filter-filtered-pages.patch
mm-memory-failure-use-local-variable-huge-to-check-hugetlb-page.patch
mm-memory-failure-remove-unneeded-header-files.patch
mm-memory-failure-minor-cleanup-for-comments-and-codestyle.patch
mm-memory-failure-fetch-compound-head-after-extra-page-refcnt-is-held.patch
mm-memory-failure-fix-race-window-when-trying-to-get-hugetlb-folio.patch
mm-huge_memory-use-rmap_none-when-calling-page_add_anon_rmap.patch
mm-memcg-fix-obsolete-comment-above-mem_cgroup_max_reclaim_loops.patch
mm-memcg-minor-cleanup-for-mc_handle_present_pte.patch
memory-tier-use-helper-macro-__attr_rw.patch
mm-fix-obsolete-function-name-above-debug_pagealloc_enabled_static.patch
mm-mprotect-fix-obsolete-function-name-in-change_pte_range.patch
mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch
mm-memory-failure-add-pageoffline-check.patch
mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch
mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch
mm-page_alloc-remove-unneeded-variable-base.patch
mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch

