Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E795ECAAD8
	for <mm-commits@archiver.kernel.org>; Fri, 16 Sep 2022 20:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiIPUHU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Sep 2022 16:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiIPUHA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2022 16:07:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0E1B99E0
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 13:06:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A81262D76
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 20:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57081C433C1;
        Fri, 16 Sep 2022 20:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663358815;
        bh=cPBnK/bwTVBXtUWz1rL60rruqgwmhxO+6iPLpO/2ZAM=;
        h=Date:To:From:Subject:From;
        b=Z3AUV1bf1rA40cvqgwm9+uZJa9Q6ePVNhgyiO8O7zqpXHS1eTpoi4qJDGt0kVsJHe
         xep/qRLiqY/JfDJqZ1UX0OewiHj0wbLunBE4Gfo8NqvAWZOu085Yn4qSQu8SIuzQUD
         ZY2a96RDco+pMOGQcERa81Fmg3hgBdzjMpegsCzM=
Date:   Fri, 16 Sep 2022 13:06:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-make-boot_nodestats-static.patch added to mm-unstable branch
Message-Id: <20220916200655.57081C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: make boot_nodestats static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-make-boot_nodestats-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-make-boot_nodestats-static.patch

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
Subject: mm/page_alloc: make boot_nodestats static
Date: Fri, 16 Sep 2022 15:22:52 +0800

It's only used in mm/page_alloc.c now.  Make it static.

Link: https://lkml.kernel.org/r/20220916072257.9639-12-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    2 --
 mm/page_alloc.c |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/mm/internal.h~mm-page_alloc-make-boot_nodestats-static
+++ a/mm/internal.h
@@ -836,8 +836,6 @@ int migrate_device_coherent_page(struct
  */
 struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags);
 
-DECLARE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
-
 extern bool mirrored_kernelcore;
 
 static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
--- a/mm/page_alloc.c~mm-page_alloc-make-boot_nodestats-static
+++ a/mm/page_alloc.c
@@ -6571,7 +6571,7 @@ static void per_cpu_pages_init(struct pe
 #define BOOT_PAGESET_BATCH	1
 static DEFINE_PER_CPU(struct per_cpu_pages, boot_pageset);
 static DEFINE_PER_CPU(struct per_cpu_zonestat, boot_zonestats);
-DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
+static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
 static void __build_all_zonelists(void *data)
 {
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

