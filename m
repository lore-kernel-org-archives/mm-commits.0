Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B79ECAAD8
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 22:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiIMWkO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 18:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiIMWkM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 18:40:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589B44D26E
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 15:40:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A14F2B810F3
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 22:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E27C433C1;
        Tue, 13 Sep 2022 22:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663108808;
        bh=+6cBRTGyYqyoFXRS1WdtTT/SDf0eyLbMaAM2JPQk1KE=;
        h=Date:To:From:Subject:From;
        b=RTsoKOPNEdBlZ4W+ijt+4ZBB2Ild1ewqwCjrUbX5T5RxPzrHkjfzLLZwFIIErEJp7
         BmDZtQ4dbaDvxNeBoLYT2m2TMFCVszBsX1bNRzkB1LMTaImcQ+Jpt1jeUS7pa6AGS2
         UFIGKiwbcJnPiGX8oC/RvQ0k4c4Y+etAv0OSBwIc=
Date:   Tue, 13 Sep 2022 15:40:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ke.wang@unisoc.com, huangzhaoyang@gmail.com,
        catalin.marinas@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch added to mm-unstable branch
Message-Id: <20220913224008.38E27C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: document bulkfree_pcp_prepare() return value
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/page_alloc.c: document bulkfree_pcp_prepare() return value
Date: Tue Sep 13 03:30:38 PM PDT 2022

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-page_allocc-document-bulkfree_pcp_prepare-return-value
+++ a/mm/page_alloc.c
@@ -1507,6 +1507,7 @@ static bool free_pcp_prepare(struct page
 	return free_pages_prepare(page, order, true, FPI_NONE);
 }
 
+/* return true if this page has an inappropriate state */
 static bool bulkfree_pcp_prepare(struct page *page)
 {
 	if (debug_pagealloc_enabled_static())
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix.patch
mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch
fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch

