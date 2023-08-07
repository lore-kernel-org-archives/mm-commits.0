Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 626E9C001B0
	for <mm-commits@archiver.kernel.org>; Mon,  7 Aug 2023 15:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjHGPvU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Aug 2023 11:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjHGPvT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Aug 2023 11:51:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A31C2
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 08:51:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4476161EA2
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 15:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926A8C433C7;
        Mon,  7 Aug 2023 15:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691423477;
        bh=LdLjlN6411UP2soQoF11R0ejHLxHVGJGdb15eAhsuvI=;
        h=Date:To:From:Subject:From;
        b=n+is3uq5B1AH+NemqPmLxFEcrxlEE8Qqn6PXeKBGpAgrXi+zV9l1j7lrV/V7BckE3
         pAqXVX667YAkXagDqlKygX68jg5myyKSnwEEdbcXciM8ZrR/kZr6l2h84idc1+v/6t
         N4Gxsxo3GBkBOxE71/Bj8HOcYLnPpZ1k/zVlq7J0=
Date:   Mon, 07 Aug 2023 08:51:16 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch added to mm-unstable branch
Message-Id: <20230807155117.926A8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: use helper macro llist_for_each_entry_safe()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: use helper macro llist_for_each_entry_safe()
Date: Mon, 7 Aug 2023 19:41:25 +0800

It's more convenient to use helper macro llist_for_each_entry_safe().
No functional change intended.

Link: https://lkml.kernel.org/r/20230807114125.3440802-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-use-helper-macro-llist_for_each_entry_safe
+++ a/mm/memory-failure.c
@@ -1869,13 +1869,12 @@ bool is_raw_hwpoison_page_in_hugepage(st
 
 static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 {
-	struct llist_node *t, *tnode, *head;
+	struct llist_node *head;
+	struct raw_hwp_page *p, *next;
 	unsigned long count = 0;
 
 	head = llist_del_all(raw_hwp_list_head(folio));
-	llist_for_each_safe(tnode, t, head) {
-		struct raw_hwp_page *p = container_of(tnode, struct raw_hwp_page, node);
-
+	llist_for_each_entry_safe(p, next, head, node) {
 		if (move_flag)
 			SetPageHWPoison(p->page);
 		else
@@ -1890,7 +1889,7 @@ static int folio_set_hugetlb_hwpoison(st
 {
 	struct llist_head *head;
 	struct raw_hwp_page *raw_hwp;
-	struct llist_node *t, *tnode;
+	struct raw_hwp_page *p, *next;
 	int ret = folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
 
 	/*
@@ -1901,9 +1900,7 @@ static int folio_set_hugetlb_hwpoison(st
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return -EHWPOISON;
 	head = raw_hwp_list_head(folio);
-	llist_for_each_safe(tnode, t, head->first) {
-		struct raw_hwp_page *p = container_of(tnode, struct raw_hwp_page, node);
-
+	llist_for_each_entry_safe(p, next, head->first, node) {
 		if (p->page == page)
 			return -EHWPOISON;
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
mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch

