Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B3FDC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 22:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6360F613C5
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 22:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhETWHQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 18:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230270AbhETWHQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 18:07:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AEC0613BB;
        Thu, 20 May 2021 22:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621548354;
        bh=BjZZB/yWX/UWkW9/ifsVLf2CakPvlWNlIAcbtKNfnb8=;
        h=Date:From:To:Subject:From;
        b=olgyDtlkLV+58ql478TiOlySUY0J7v4YXYRsHApfS3IPdLADEMMsGk8vBWJ9JPmxE
         +HBhftBYadHkHcA43mRn/3GSpTZLL0WjxAtoNlm/F2+QQ1zhc5g0l7txuyX59qaRwX
         3aMAqa6FaowVx128w+igaKFDmifhF+R86px/1pGY=
Date:   Thu, 20 May 2021 15:05:53 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, ddstreet@ieee.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shy828301@gmail.com,
        vbabka@suse.cz
Subject:  +
 mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages.patch added
 to -mm tree
Message-ID: <20210520220553.HlzrZR6fV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: remove kerneldoc-like comment from isolate_lru_pages
has been added to the -mm tree.  Its filename is
     mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages.patch

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
Subject: mm/vmscan: remove kerneldoc-like comment from isolate_lru_pages

Patch series "Clean W=1 build warnings for mm/".

This is a janitorial only.  During development of a tool to catch build
warnings early to avoid tripping the Intel lkp-robot, I noticed that mm/
is not clean for W=1.  This is generally harmless but there is no harm in
cleaning it up.  It disrupts git blame a little but on relatively obvious
lines that are unlikely to be git blame targets.


This patch (of 14):

make W=1 generates the following warning for vmscan.c

    mm/vmscan.c:1814: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

It is not a kerneldoc comment and isolate_lru_pages() is a static
function.  While the detailed comment is nice, it does not need to be
exposed via kernel-doc.

Link: https://lkml.kernel.org/r/20210520084809.8576-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20210520084809.8576-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages
+++ a/mm/vmscan.c
@@ -1810,7 +1810,7 @@ static __always_inline void update_lru_s
 
 }
 
-/**
+/*
  * Isolating page from the lruvec to fill in @dst list by nr_to_scan times.
  *
  * lruvec->lru_lock is heavily contended.  Some of the functions that
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

