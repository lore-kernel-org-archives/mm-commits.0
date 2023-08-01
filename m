Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE99C0015E
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 18:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjHAScZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjHAScY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 14:32:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BDBA0
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 11:32:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF5636166E
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 18:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB8DC433C8;
        Tue,  1 Aug 2023 18:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690914742;
        bh=+MWCxTjf3S5SKb8hwtlqWFAsp/BISBpiPAHih4Pgr5A=;
        h=Date:To:From:Subject:From;
        b=0zd3UIyt2ML5QHkXwGEuWF7AKB9WxaqmXIT01klKuZf3miFUAg6xg9YUziHzVjLR3
         N4EbIhN2ll74S8OIagsQ7h605NiWivQFyvCWODPiMXIDGsS9PRBtnrXKgCp+1xcZ/a
         lP6ofdwxs0oJnMIy+ilaP2wl0qjZbxOf04iDRYo0=
Date:   Tue, 01 Aug 2023 11:32:21 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch added to mm-unstable branch
Message-Id: <20230801183222.2FB8DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: avoid unneeded alike_pages calculation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch

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
Subject: mm/page_alloc: avoid unneeded alike_pages calculation
Date: Tue, 1 Aug 2023 20:37:23 +0800

When free_pages is 0, alike_pages is not used.  So alike_pages calculation
can be avoided by checking free_pages early to save cpu cycles.  Also fix
typo 'comparable'.  It should be 'compatible' here.

Link: https://lkml.kernel.org/r/20230801123723.2225543-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-unneeded-alike_pages-calculation
+++ a/mm/page_alloc.c
@@ -1833,6 +1833,10 @@ static void steal_suitable_fallback(stru
 
 	free_pages = move_freepages_block(zone, page, start_type,
 						&movable_pages);
+	/* moving whole block can fail due to zone boundary conditions */
+	if (!free_pages)
+		goto single_page;
+
 	/*
 	 * Determine how many pages are compatible with our allocation.
 	 * For movable allocation, it's the number of movable pages which
@@ -1854,14 +1858,9 @@ static void steal_suitable_fallback(stru
 		else
 			alike_pages = 0;
 	}
-
-	/* moving whole block can fail due to zone boundary conditions */
-	if (!free_pages)
-		goto single_page;
-
 	/*
 	 * If a sufficient number of pages in the block are either free or of
-	 * comparable migratability as our allocation, claim the whole block.
+	 * compatible migratability as our allocation, claim the whole block.
 	 */
 	if (free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
 			page_group_by_mobility_disabled)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-fix-wrong-swap-entry-type-for-hwpoisoned-swapcache-page.patch
mm-memory-failure-fix-potential-unexpected-return-value-from-unpoison_memory.patch
mm-memory-failure-avoid-false-hwpoison-page-mapped-error-info.patch
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

