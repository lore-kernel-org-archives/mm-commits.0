Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70677C6FA90
	for <mm-commits@archiver.kernel.org>; Fri, 16 Sep 2022 20:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiIPUHC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Sep 2022 16:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiIPUGx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2022 16:06:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB91B7282
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 13:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4399B823FA
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 20:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496E4C433D6;
        Fri, 16 Sep 2022 20:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663358809;
        bh=Xr+QXwwFIYTyV8YXzzXoAYzcGoKn6X9rHy6ang9ohQI=;
        h=Date:To:From:Subject:From;
        b=PyQ0m9Lw9KvDpWH5IREl+zBl+QoSOQ0YljAg/phGeZLWh7aocnxZyQbvHlVIx5Sk8
         bY3lqhcPSDoQnJaBGZDj51Kie3PZkIQNF++wah27Km8bkEwmqCeI6q0yhcqYHGBRE0
         L9M4XUIN6G1a6MdiuMMRcPWZR8nyr2XSg0O97R7M=
Date:   Fri, 16 Sep 2022 13:06:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard.patch added to mm-unstable branch
Message-Id: <20220916200649.496E4C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add missing is_migrate_isolate() check in set_page_guard()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard.patch

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
Subject: mm/page_alloc: add missing is_migrate_isolate() check in set_page_guard()
Date: Fri, 16 Sep 2022 15:22:49 +0800

In MIGRATE_ISOLATE case, zone freepage state shouldn't be modified as
caller will take care of it.  Add missing is_migrate_isolate() here to
avoid possible unbalanced freepage state.  This would happen if someone
isolates the block, and then we face an MCE failure/soft-offline on a page
within that block.  __mod_zone_freepage_state() will be triggered via
below call trace which already had been triggered back when block was
isolated:

take_page_off_buddy
  break_down_buddy_pages
    set_page_guard

Link: https://lkml.kernel.org/r/20220916072257.9639-9-linmiaohe@huawei.com
Fixes: 06be6ff3d2ec ("mm,hwpoison: rework soft offline for free pages")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard
+++ a/mm/page_alloc.c
@@ -873,7 +873,8 @@ static inline bool set_page_guard(struct
 	INIT_LIST_HEAD(&page->buddy_list);
 	set_page_private(page, order);
 	/* Guard pages are not available for any usage */
-	__mod_zone_freepage_state(zone, -(1 << order), migratetype);
+	if (!is_migrate_isolate(migratetype))
+		__mod_zone_freepage_state(zone, -(1 << order), migratetype);
 
 	return true;
 }
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

