Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 583EDECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 19 Sep 2022 20:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiISU0E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Sep 2022 16:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiISU0D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2022 16:26:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85BAE0D3
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 13:26:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66FE3B803F5
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 20:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA0FC433C1;
        Mon, 19 Sep 2022 20:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663619160;
        bh=TnD/ouv8twoVbWqDhXvBwP3hh87wjPTHhvrRLSWgqiA=;
        h=Date:To:From:Subject:From;
        b=H+6Vc8t5wT/gwhD/opKlfYNr59GlOucTTuO7nTux2VUqZDBBmnbl5yRf2tBK1rMsn
         qDoypxPsHeW+ua4ldQkAGbtbDSZVkVUsjR54RU5gDh+dFFBfwNB9ufudVr3DbeO03x
         wTJ8ufx+bYXW8KWPHpzYqFR3jDuUTUHNdhu/keJI=
Date:   Mon, 19 Sep 2022 13:25:50 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix.patch added to mm-unstable branch
Message-Id: <20220919202559.4CA0FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix.patch

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
Subject: mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix
Date: Mon, 19 Sep 2022 17:30:51 +0800

fix htmldocs

Link: https://lkml.kernel.org/r/1bc55727-9b66-0e9e-c306-f10c4716ea89@huawei.com
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/core-api/mm-api.rst~mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix
+++ a/Documentation/core-api/mm-api.rst
@@ -19,9 +19,6 @@ User Space Memory Access
 Memory Allocation Controls
 ==========================
 
-.. kernel-doc:: include/linux/gfp.h
-   :internal:
-
 .. kernel-doc:: include/linux/gfp_types.h
    :doc: Page mobility and placement hints
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch
mm-page_alloc-ensure-kswapd-doesnt-accidentally-go-to-sleep.patch
mm-page_alloc-make-zone_pcp_update-static.patch
mm-remove-obsolete-macro-nr_pcp_order_mask-and-nr_pcp_order_width.patch
mm-page_alloc-remove-obsolete-comment-in-zone_statistics.patch
mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening.patch
mm-page_alloc-fix-freeing-static-percpu-memory.patch
mm-remove-obsolete-pgdat_is_empty.patch
mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard.patch
mm-page_alloc-use-local-variable-zone_idx-directly.patch
mm-memory_hotplug-remove-obsolete-generic_free_nodedata.patch
mm-page_alloc-make-boot_nodestats-static.patch
mm-page_alloc-use-helper-macro-sz_1km.patch
mm-page_alloc-init-local-variable-buddy_pfn.patch
mm-page_alloc-use-costly_order-in-warn_on_once_gfp.patch
mm-page_alloc-remove-obsolete-gfpflags_normal_context.patch
mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix.patch
mm-page_alloc-fix-obsolete-comment-in-deferred_pfn_valid.patch

