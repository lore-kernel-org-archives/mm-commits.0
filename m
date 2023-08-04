Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41DCC04FDF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 20:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjHDUEU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 16:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjHDUES (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 16:04:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA9610D2;
        Fri,  4 Aug 2023 13:04:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FC0462120;
        Fri,  4 Aug 2023 20:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CA4C433C7;
        Fri,  4 Aug 2023 20:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691179455;
        bh=cTx3j6jZ945MTlJ+TgwwmHpiSE/yR7ZOL0ac3YZ8S2E=;
        h=Date:To:From:Subject:From;
        b=H0lt143xF/rtwIen2xL5KvWKILhy4C2hOQi1CMGKI2I0vMUm6THkJnzDkXBpDGNZk
         G+aWNkhh/PQm7EB0D53F/nBciAlCqf8GMVC2IlV5DTm0FC6IYUBbE20aKk17ICChj4
         6kt4Gcxt1DfyEW3Wwkcii45fYGUW1u15/+caQr38=
Date:   Fri, 04 Aug 2023 13:04:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, stable@vger.kernel.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-failure-fix-potential-unexpected-return-value-from-unpoison_memory.patch removed from -mm tree
Message-Id: <20230804200415.D1CA4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: fix potential unexpected return value from unpoison_memory()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-potential-unexpected-return-value-from-unpoison_memory.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: fix potential unexpected return value from unpoison_memory()
Date: Thu, 27 Jul 2023 19:56:41 +0800

If unpoison_memory() fails to clear page hwpoisoned flag, return value ret
is expected to be -EBUSY.  But when get_hwpoison_page() returns 1 and
fails to clear page hwpoisoned flag due to races, return value will be
unexpected 1 leading to users being confused.  And there's a code smell
that the variable "ret" is used not only to save the return value of
unpoison_memory(), but also the return value from get_hwpoison_page(). 
Make a further cleanup by using another auto-variable solely to save the
return value of get_hwpoison_page() as suggested by Naoya.

Link: https://lkml.kernel.org/r/20230727115643.639741-3-linmiaohe@huawei.com
Fixes: bf181c582588 ("mm/hwpoison: fix unpoison_memory()")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-potential-unexpected-return-value-from-unpoison_memory
+++ a/mm/memory-failure.c
@@ -2466,7 +2466,7 @@ int unpoison_memory(unsigned long pfn)
 {
 	struct folio *folio;
 	struct page *p;
-	int ret = -EBUSY;
+	int ret = -EBUSY, ghp;
 	unsigned long count = 1;
 	bool huge = false;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
@@ -2514,29 +2514,28 @@ int unpoison_memory(unsigned long pfn)
 	if (folio_test_slab(folio) || PageTable(&folio->page) || folio_test_reserved(folio))
 		goto unlock_mutex;
 
-	ret = get_hwpoison_page(p, MF_UNPOISON);
-	if (!ret) {
+	ghp = get_hwpoison_page(p, MF_UNPOISON);
+	if (!ghp) {
 		if (PageHuge(p)) {
 			huge = true;
 			count = folio_free_raw_hwp(folio, false);
-			if (count == 0) {
-				ret = -EBUSY;
+			if (count == 0)
 				goto unlock_mutex;
-			}
 		}
 		ret = folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
-	} else if (ret < 0) {
-		if (ret == -EHWPOISON) {
+	} else if (ghp < 0) {
+		if (ghp == -EHWPOISON) {
 			ret = put_page_back_buddy(p) ? 0 : -EBUSY;
-		} else
+		} else {
+			ret = ghp;
 			unpoison_pr_info("Unpoison: failed to grab page %#lx\n",
 					 pfn, &unpoison_rs);
+		}
 	} else {
 		if (PageHuge(p)) {
 			huge = true;
 			count = folio_free_raw_hwp(folio, false);
 			if (count == 0) {
-				ret = -EBUSY;
 				folio_put(folio);
 				goto unlock_mutex;
 			}
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

