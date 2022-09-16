Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8185ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri, 16 Sep 2022 20:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiIPUGv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Sep 2022 16:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiIPUGr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2022 16:06:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A06B7282
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 13:06:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FB69B82930
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 20:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06953C433B5;
        Fri, 16 Sep 2022 20:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663358803;
        bh=hr6elbVdoBc8OS30lEGyQKJ9XTm7GdXOFSXlyUcf+ic=;
        h=Date:To:From:Subject:From;
        b=g+BlM4sVl1QTkuq7V/j6BEdMLMHgRt04Z8lyHHXxSXUuwS0A/ToDmyBvk1lJoij44
         uWfSUQ9fW5GJMDaHE3gXuHz9L//87DrDa6N8jVPmFopiBz67c1o+VrUElIgXt8uhe1
         0qdKvQUMTm6nu7/Yr4rx8e7AWiFzCuqfk0Q0Gic4=
Date:   Fri, 16 Sep 2022 13:06:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening.patch added to mm-unstable branch
Message-Id: <20220916200643.06953C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add __init annotations to init_mem_debugging_and_hardening()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening.patch

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
Subject: mm/page_alloc: add __init annotations to init_mem_debugging_and_hardening()
Date: Fri, 16 Sep 2022 15:22:46 +0800

It's only called by mm_init(). Add __init annotations to it.

Link: https://lkml.kernel.org/r/20220916072257.9639-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/page_alloc.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening
+++ a/include/linux/mm.h
@@ -3093,7 +3093,7 @@ extern int apply_to_existing_page_range(
 				   unsigned long address, unsigned long size,
 				   pte_fn_t fn, void *data);
 
-extern void init_mem_debugging_and_hardening(void);
+extern void __init init_mem_debugging_and_hardening(void);
 #ifdef CONFIG_PAGE_POISONING
 extern void __kernel_poison_pages(struct page *page, int numpages);
 extern void __kernel_unpoison_pages(struct page *page, int numpages);
--- a/mm/page_alloc.c~mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening
+++ a/mm/page_alloc.c
@@ -903,7 +903,7 @@ static inline void clear_page_guard(stru
  * order of appearance. So we need to first gather the full picture of what was
  * enabled, and then make decisions.
  */
-void init_mem_debugging_and_hardening(void)
+void __init init_mem_debugging_and_hardening(void)
 {
 	bool page_poisoning_requested = false;
 
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
mm-page_alloc-fix-obsolete-comment-in-deferred_pfn_valid.patch

