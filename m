Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7261C0015E
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 17:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbjG0RAu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 13:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbjG0RAu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 13:00:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6588D9E;
        Thu, 27 Jul 2023 10:00:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE59D61EE6;
        Thu, 27 Jul 2023 17:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D121C433C8;
        Thu, 27 Jul 2023 17:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690477247;
        bh=CCTMZ3NfJ4esPxMdkshOJ5ljbzO2ebrSw0/YBFwYHNw=;
        h=Date:To:From:Subject:From;
        b=XHvFZ4NlDVz2n7XYPU2g9oGt79wFQgmXOr1MlaF7+xbAv7Pei/HYULU4ZKCyFIZaZ
         bFbGfUbW5WB212a+zKhhCFTdo3Sr31hrfe/S0L3zwuRbssvMqb/NHzselR07aSPc0D
         kMeEmn3WwQyx71Ze3eQGwcufvQSoOtia6q3/7EyA=
Date:   Thu, 27 Jul 2023 10:00:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, stable@vger.kernel.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-fix-wrong-swap-entry-type-for-hwpoisoned-swapcache-page.patch added to mm-hotfixes-unstable branch
Message-Id: <20230727170047.4D121C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: fix wrong swap entry type for hwpoisoned swapcache page
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swapfile-fix-wrong-swap-entry-type-for-hwpoisoned-swapcache-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-fix-wrong-swap-entry-type-for-hwpoisoned-swapcache-page.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile: fix wrong swap entry type for hwpoisoned swapcache page
Date: Thu, 27 Jul 2023 19:56:40 +0800

Patch series "A few fixup patches for mm", v2.

This series contains a few fixup patches to fix potential unexpected
return value, fix wrong swap entry type for hwpoisoned swapcache page and
so on.  More details can be found in the respective changelogs.


This patch (of 4):

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

mm-swapfile-fix-wrong-swap-entry-type-for-hwpoisoned-swapcache-page.patch
mm-memory-failure-fix-potential-unexpected-return-value-from-unpoison_memory.patch
mm-memory-failure-avoid-false-hwpoison-page-mapped-error-info.patch
mm-memory-failure-add-pageoffline-check.patch
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

