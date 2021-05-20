Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5225C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 22:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BC73613DC
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 22:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhETWHm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 18:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231258AbhETWHl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 18:07:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB3BF613B6;
        Thu, 20 May 2021 22:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621548379;
        bh=17na6uHXizksGcMjUbtjwU0OO/QpF0LQP1RpcnWHgrs=;
        h=Date:From:To:Subject:From;
        b=MibomsbUlDpCF98+RaZSMcM3/Ap0XJAmtCRnSzmOr7u7L5090omjZqXAsiA31SQnn
         viydla8NpQiQGjFLI31twdV4HDEZBuCVSk14gqols73+7pf6V5KJS/25Goyf4pFJRc
         zv1fu7WDRAMhwtDfM6fqZ616v15HiEJkIRVjMyXg=
Date:   Thu, 20 May 2021 15:06:18 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, ddstreet@ieee.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shy828301@gmail.com,
        vbabka@suse.cz
Subject:  +
 mm-page_alloc-move-prototype-for-find_suitable_fallback.patch added to -mm
 tree
Message-ID: <20210520220618.UOZynGU6t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: move prototype for find_suitable_fallback
has been added to the -mm tree.  Its filename is
     mm-page_alloc-move-prototype-for-find_suitable_fallback.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-move-prototype-for-find_suitable_fallback.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-move-prototype-for-find_suitable_fallback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: move prototype for find_suitable_fallback

make W=1 generates the following warning in mmap_lock.c for allnoconfig

  mm/page_alloc.c:2670:5: warning: no previous prototype for `find_suitable_fallback' [-Wmissing-prototypes]
   int find_suitable_fallback(struct free_area *area, unsigned int order,
       ^~~~~~~~~~~~~~~~~~~~~~

find_suitable_fallback is only shared outside of page_alloc.c for
CONFIG_COMPACTION but to suppress the warning, move the protype outside of
CONFIG_COMPACTION.  It is not worth the effort at this time to find a
clever way of allowing compaction.c to share the code or avoid the use
entirely as the function is called on relatively slow paths.

Link: https://lkml.kernel.org/r/20210520084809.8576-14-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/internal.h~mm-page_alloc-move-prototype-for-find_suitable_fallback
+++ a/mm/internal.h
@@ -274,11 +274,10 @@ isolate_freepages_range(struct compact_c
 int
 isolate_migratepages_range(struct compact_control *cc,
 			   unsigned long low_pfn, unsigned long end_pfn);
+#endif
 int find_suitable_fallback(struct free_area *area, unsigned int order,
 			int migratetype, bool only_stealable, bool *can_steal);
 
-#endif
-
 /*
  * This function returns the order of a free page in the buddy system. In
  * general, page_zone(page)->lock must be held by the caller to prevent the
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch
mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages.patch
mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch
mm-page_alloc-make-should_fail_alloc_page-a-static-function-should_fail_alloc_page-static.patch
mm-mapping_dirty_helpers-remove-double-note-in-kerneldoc.patch
mm-early_ioremap-add-prototype-for-early_memremap_pgprot_adjust.patch
mm-memcontrolc-fix-kerneldoc-comment-for-mem_cgroup_calculate_protection.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__try_online_node.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__remove_memory.patch
mm-zbud-add-kerneldoc-fields-for-zbud_pool.patch
mm-z3fold-add-kerneldoc-fields-for-z3fold_pool.patch
mm-swap-make-swap_address_space-an-inline-function.patch
mm-mmap_lock-remove-dead-code-for-config_tracing-configurations.patch
mm-page_alloc-move-prototype-for-find_suitable_fallback.patch
mm-swap-make-node_data-an-inline-function-on-config_flatmem.patch

