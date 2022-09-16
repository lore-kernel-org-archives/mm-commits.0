Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2630AECAAA1
	for <mm-commits@archiver.kernel.org>; Fri, 16 Sep 2022 20:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiIPUHc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Sep 2022 16:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiIPUHH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2022 16:07:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A1AB9F93
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 13:07:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00AE3B82938
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 20:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2597C433D6;
        Fri, 16 Sep 2022 20:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663358823;
        bh=wrFKS0xYMQRMSlC0T34cnw9qB1Po1sk+EJlZTFqzVzc=;
        h=Date:To:From:Subject:From;
        b=kDoOmyW1EQo/9WZG+wQEAtUZG3jMcjWuQEUNnIq+HwD7o+xbj87XETH59opNMEhbH
         gVWnrTxwcsoEfadb3A3fH4zz3+AUmfBzlZ2KiUad9gAihN40+w0JlSZZdw7/AYhvm4
         BwlKA727qtW5VwcnabAyYquKRKM1/2J7svJzg3dw=
Date:   Fri, 16 Sep 2022 13:07:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-obsolete-gfpflags_normal_context.patch added to mm-unstable branch
Message-Id: <20220916200703.A2597C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: remove obsolete gfpflags_normal_context()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-obsolete-gfpflags_normal_context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-obsolete-gfpflags_normal_context.patch

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
Subject: mm/page_alloc: remove obsolete gfpflags_normal_context()
Date: Fri, 16 Sep 2022 15:22:56 +0800

Since commit dacb5d8875cc ("tcp: fix page frag corruption on page fault"),
there's no caller of gfpflags_normal_context().  Remove it as this helper
is strictly tied to the sk page frag usage and there won't be other user
in the future.

Link: https://lkml.kernel.org/r/20220916072257.9639-16-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   23 -----------------------
 1 file changed, 23 deletions(-)

--- a/include/linux/gfp.h~mm-page_alloc-remove-obsolete-gfpflags_normal_context
+++ a/include/linux/gfp.h
@@ -36,29 +36,6 @@ static inline bool gfpflags_allow_blocki
 	return !!(gfp_flags & __GFP_DIRECT_RECLAIM);
 }
 
-/**
- * gfpflags_normal_context - is gfp_flags a normal sleepable context?
- * @gfp_flags: gfp_flags to test
- *
- * Test whether @gfp_flags indicates that the allocation is from the
- * %current context and allowed to sleep.
- *
- * An allocation being allowed to block doesn't mean it owns the %current
- * context.  When direct reclaim path tries to allocate memory, the
- * allocation context is nested inside whatever %current was doing at the
- * time of the original allocation.  The nested allocation may be allowed
- * to block but modifying anything %current owns can corrupt the outer
- * context's expectations.
- *
- * %true result from this function indicates that the allocation context
- * can sleep and use anything that's associated with %current.
- */
-static inline bool gfpflags_normal_context(const gfp_t gfp_flags)
-{
-	return (gfp_flags & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC)) ==
-		__GFP_DIRECT_RECLAIM;
-}
-
 #ifdef CONFIG_HIGHMEM
 #define OPT_ZONE_HIGHMEM ZONE_HIGHMEM
 #else
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

