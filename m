From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mmpage=5Falloccma-conditionally-prefer-cma-pageblocks-for-m?=
 =?US-ASCII?Q?ovable-allocations-fix.patch?= added to -mm tree
Date: Wed, 11 Mar 2020 16:26:02 -0700
Message-ID: <20200311232602.GQ8SNyxZe%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731500AbgCKX0F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Mar 2020 19:26:05 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, cai@lca.pw, guro@fb.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, riel@surriel.com, vbabka@suse.cz


The patch titled
     Subject: mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix
has been added to the -mm tree.  Its filename is
     mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch

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
Subject: mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix

ifdef the cma-specific code.

Link: http://lkml.kernel.org/r/20200311225832.GA178154@carbon.DHCP.thefacebook.com
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Qian Cai <cai@lca.pw>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c~mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix
+++ a/mm/page_alloc.c
@@ -2713,6 +2713,7 @@ __rmqueue(struct zone *zone, unsigned in
 {
 	struct page *page;
 
+#ifdef CONFIG_CMA
 	/*
 	 * Balance movable allocations between regular and CMA areas by
 	 * allocating from CMA when over half of the zone's free memory
@@ -2725,6 +2726,7 @@ __rmqueue(struct zone *zone, unsigned in
 		if (page)
 			return page;
 	}
+#endif
 retry:
 	page = __rmqueue_smallest(zone, order, migratetype);
 	if (unlikely(!page)) {
_

Patches currently in -mm which might be from guro@fb.com are

mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations.patch
mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
mm-memcg-slab-introduce-mem_cgroup_from_obj-v2.patch
mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments.patch
mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch
mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page.patch
mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg.patch
mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab.patch
mm-kmem-rename-__memcg_kmem_uncharge_memcg-to-__memcg_kmem_uncharge.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch
