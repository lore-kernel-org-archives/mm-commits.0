Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD204C433E6
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 19:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 819FE23131
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 19:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbhAFTvk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jan 2021 14:51:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbhAFTvk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Jan 2021 14:51:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF6A923132;
        Wed,  6 Jan 2021 19:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609962660;
        bh=2M5BHXVSzCX+regNSKMw13CGNtTdIjhChQNb8WrTjmg=;
        h=Date:From:To:Subject:From;
        b=sXxorEOwJisbStQonwEUbOpOeBPzTZyJer6/qmlS7z1K4JidpIAehIfmaShmkAPyo
         K/a+zejBDvojR+CGvPVoqWzhA4lFawH8v79O10zTGo5d0TWuGgCGCqdE522q+opTVt
         vggEi5+a0webfugmHwXr66ywKpealZVzXIyIYMXs=
Date:   Wed, 06 Jan 2021 11:50:59 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, imran.f.khan@oracle.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  + mm-memcg-slab-optimize-objcg-stock-draining.patch added
 to -mm tree
Message-ID: <20210106195059.OWpyPK_iE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: optimize objcg stock draining
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-optimize-objcg-stock-draining.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-optimize-objcg-stock-draining.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-optimize-objcg-stock-draining.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: optimize objcg stock draining

Imran Khan reported a regression in hackbench results caused by the commit
f2fe7b09a52b ("mm: memcg/slab: charge individual slab objects instead of
pages").  The regression is noticeable in the case of a consequent
allocation of several relatively large slab objects, e.g.  skb's.  As soon
as the amount of stocked bytes exceeds PAGE_SIZE, drain_obj_stock() and
__memcg_kmem_uncharge() are called, and it leads to a number of atomic
operations in page_counter_uncharge().

The corresponding call graph is below (provided by Imran Khan):
  |__alloc_skb
  |    |
  |    |__kmalloc_reserve.isra.61
  |    |    |
  |    |    |__kmalloc_node_track_caller
  |    |    |    |
  |    |    |    |slab_pre_alloc_hook.constprop.88
  |    |    |     obj_cgroup_charge
  |    |    |    |    |
  |    |    |    |    |__memcg_kmem_charge
  |    |    |    |    |    |
  |    |    |    |    |    |page_counter_try_charge
  |    |    |    |    |
  |    |    |    |    |refill_obj_stock
  |    |    |    |    |    |
  |    |    |    |    |    |drain_obj_stock.isra.68
  |    |    |    |    |    |    |
  |    |    |    |    |    |    |__memcg_kmem_uncharge
  |    |    |    |    |    |    |    |
  |    |    |    |    |    |    |    |page_counter_uncharge
  |    |    |    |    |    |    |    |    |
  |    |    |    |    |    |    |    |    |page_counter_cancel
  |    |    |    |
  |    |    |    |
  |    |    |    |__slab_alloc
  |    |    |    |    |
  |    |    |    |    |___slab_alloc
  |    |    |    |    |
  |    |    |    |slab_post_alloc_hook

Instead of directly uncharging the accounted kernel memory, it's possible
to refill the generic page-sized per-cpu stock instead.  It's a much
faster operation, especially on a default hierarchy.  As a bonus,
__memcg_kmem_uncharge_page() will also get faster, so the freeing of
page-sized kernel allocations (e.g.  large kmallocs) will become faster.

A similar change has been done earlier for the socket memory by the commit
475d0487a2ad ("mm: memcontrol: use per-cpu stocks for socket memory
uncharging").

Link: https://lkml.kernel.org/r/20210106042239.2860107-1-guro@fb.com
Fixes: f2fe7b09a52b ("mm: memcg/slab: charge individual slab objects instead of
pages")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Imran Khan <imran.f.khan@oracle.com>
Tested-by: Imran Khan <imran.f.khan@oracle.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-slab-optimize-objcg-stock-draining
+++ a/mm/memcontrol.c
@@ -3122,9 +3122,7 @@ void __memcg_kmem_uncharge(struct mem_cg
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		page_counter_uncharge(&memcg->kmem, nr_pages);
 
-	page_counter_uncharge(&memcg->memory, nr_pages);
-	if (do_memsw_account())
-		page_counter_uncharge(&memcg->memsw, nr_pages);
+	refill_stock(memcg, nr_pages);
 }
 
 /**
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-memcg-slab-optimize-objcg-stock-draining.patch
mm-cma-allocate-cma-areas-bottom-up.patch
mm-cma-allocate-cma-areas-bottom-up-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-2.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3.patch
memblock-do-not-start-bottom-up-allocations-with-kernel_end.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

