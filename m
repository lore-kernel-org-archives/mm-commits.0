Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC28EB64DD
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jul 2023 17:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjGTRLF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jul 2023 13:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjGTRLD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jul 2023 13:11:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0401986
        for <mm-commits@vger.kernel.org>; Thu, 20 Jul 2023 10:11:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7343D61B83
        for <mm-commits@vger.kernel.org>; Thu, 20 Jul 2023 17:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E91C433C7;
        Thu, 20 Jul 2023 17:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689873060;
        bh=9b1PjD8Tmjzh9xYP2ov/5TjZAMzqTEINJsmTt4p6zCc=;
        h=Date:To:From:Subject:From;
        b=g8BOEhwSxUvF1eNLPnNuCKshDTdpB/q9r2DObk8mPtAxo+C72C2Cc85lGo/uPS1JU
         CoJnI6QzspdDRcDVfVYh4LrInf3nVJG++8/n2aEDFoV3Q/gdFPGfmX1aWJUEfYvUEN
         /UJVfj4wwTEIf3wZGx5uM4hBAPXgVkoTD6asd+co=
Date:   Thu, 20 Jul 2023 10:11:00 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-obsolete-function-name-above-debug_pagealloc_enabled_static.patch added to mm-unstable branch
Message-Id: <20230720171100.C7E91C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix obsolete function name above debug_pagealloc_enabled_static()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-obsolete-function-name-above-debug_pagealloc_enabled_static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-obsolete-function-name-above-debug_pagealloc_enabled_static.patch

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
Subject: mm: fix obsolete function name above debug_pagealloc_enabled_static()
Date: Thu, 20 Jul 2023 19:28:06 +0800

Since commit 04013513cc84 ("mm, page_alloc: do not rely on the order of
page_poison and init_on_alloc/free parameters"), init_debug_pagealloc() is
converted to init_mem_debugging_and_hardening().  Later it's renamed to
mem_debugging_and_hardening_init() via commit f2fc4b44ec2b ("mm: move
init_mem_debugging_and_hardening() to mm/mm_init.c").

Link: https://lkml.kernel.org/r/20230720112806.3851893-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-fix-obsolete-function-name-above-debug_pagealloc_enabled_static
+++ a/include/linux/mm.h
@@ -3493,8 +3493,8 @@ static inline bool debug_pagealloc_enabl
 }
 
 /*
- * For use in fast paths after init_debug_pagealloc() has run, or when a
- * false negative result is not harmful when called too early.
+ * For use in fast paths after mem_debugging_and_hardening_init() has run,
+ * or when a false negative result is not harmful when called too early.
  */
 static inline bool debug_pagealloc_enabled_static(void)
 {
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

