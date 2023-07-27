Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A843AC0015E
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 17:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbjG0RA7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 13:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbjG0RA5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 13:00:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2285F7
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 10:00:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F7D461EEA
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 17:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92991C433C8;
        Thu, 27 Jul 2023 17:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690477255;
        bh=OxjXWr52FA6ucMztl/z0firfA0NykeRLugC7Mkijvgg=;
        h=Date:To:From:Subject:From;
        b=QZf6K9AR58w/r55oP1Oxa2eeqlDSFdo+ekUc7obNWQrlZPoD/ST8D7qNVxZcg8xV7
         BdGiIJcywuZFGQCFU2BzzqK0/ossn1uEVv0UHOY5loNfC0vTv42SlD91biAbRaSyca
         WMEBLlxZD/9Yl3iJdIGEQ6rUJWO/NDaF6JZcP6M8=
Date:   Thu, 27 Jul 2023 10:00:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-add-pageoffline-check.patch added to mm-hotfixes-unstable branch
Message-Id: <20230727170055.92991C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: add PageOffline() check
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-add-pageoffline-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-add-pageoffline-check.patch

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
Subject: mm: memory-failure: add PageOffline() check
Date: Thu, 27 Jul 2023 19:56:43 +0800

Memory failure is not interested in logically offlined page. Skip this
type of pages.

Link: https://lkml.kernel.org/r/20230727115643.639741-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-add-pageoffline-check
+++ a/mm/memory-failure.c
@@ -1558,7 +1558,7 @@ static bool hwpoison_user_mappings(struc
 	 * Here we are interested only in user-mapped pages, so skip any
 	 * other types of pages.
 	 */
-	if (PageReserved(p) || PageSlab(p) || PageTable(p))
+	if (PageReserved(p) || PageSlab(p) || PageTable(p) || PageOffline(p))
 		return true;
 	if (!(PageLRU(hpage) || PageHuge(p)))
 		return true;
@@ -2499,7 +2499,8 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
-	if (folio_test_slab(folio) || PageTable(&folio->page) || folio_test_reserved(folio))
+	if (folio_test_slab(folio) || PageTable(&folio->page) ||
+	    folio_test_reserved(folio) || PageOffline(&folio->page))
 		goto unlock_mutex;
 
 	/*
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

