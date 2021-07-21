Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14077C6377C
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F12A761244
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhGUUKC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jul 2021 16:10:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229830AbhGUUKA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 21 Jul 2021 16:10:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D2AA61221;
        Wed, 21 Jul 2021 20:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626900636;
        bh=wU1hREKGJIXVl1TwaI9gxZZN0KwyE/JaK1D9f+BY2nU=;
        h=Date:From:To:Subject:From;
        b=l61mjvBPzUMK8hBU2SPHfzLlzb9/0XC6AXUD2VAf6a8HAn8Ptr/hhpPDmpIRvz2Jc
         skGh74jnKdgWskwekvJzbsLurD5APhagnUytxNc1pLH1y92QDVbN9sPMvMFNncWx5c
         G9NcHWxzX8mSlKZsN7RihXchvW/kEE2Viyq30XiI=
Date:   Wed, 21 Jul 2021 13:50:34 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        yang.shi@linux.alibaba.com, weixugc@google.com,
        shy828301@gmail.com, rientjes@google.com, osalvador@suse.de,
        mhocko@suse.com, gthelen@google.com, david@redhat.com,
        dave.hansen@linux.intel.com, dan.j.williams@intel.com,
        kbusch@kernel.org
Subject:  + mm-vmscan-consider-anonymous-pages-without-swap.patch
 added to -mm tree
Message-ID: <20210721205034.0TIDQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: Consider anonymous pages without swap
has been added to the -mm tree.  Its filename is
     mm-vmscan-consider-anonymous-pages-without-swap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-consider-anonymous-pages-without-swap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-consider-anonymous-pages-without-swap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Keith Busch <kbusch@kernel.org>
Subject: mm/vmscan: Consider anonymous pages without swap

Reclaim anonymous pages if a migration path is available now that demotion
provides a non-swap recourse for reclaiming anon pages.

Note that this check is subtly different from the can_age_anon_pages()
checks.  This mechanism checks whether a specific page in a specific
context can actually be reclaimed, given current swap space and cgroup
limits.

can_age_anon_pages() is a much simpler and more preliminary check which
just says whether there is a possibility of future reclaim.

Link: https://lkml.kernel.org/r/20210715055145.195411-8-ying.huang@intel.com
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Wei Xu <weixugc@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-consider-anonymous-pages-without-swap
+++ a/mm/vmscan.c
@@ -521,7 +521,7 @@ static long add_nr_deferred(long nr, str
 
 static bool can_demote(int nid, struct scan_control *sc)
 {
-	if (sc->no_demotion)
+	if (sc && sc->no_demotion)
 		return false;
 	if (next_demotion_node(nid) == NUMA_NO_NODE)
 		return false;
@@ -530,6 +530,31 @@ static bool can_demote(int nid, struct s
 	return false;
 }
 
+static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
+					  int nid,
+					  struct scan_control *sc)
+{
+	if (memcg == NULL) {
+		/*
+		 * For non-memcg reclaim, is there
+		 * space in any swap device?
+		 */
+		if (get_nr_swap_pages() > 0)
+			return true;
+	} else {
+		/* Is the memcg below its swap limit? */
+		if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
+			return true;
+	}
+
+	/*
+	 * The page can not be swapped.
+	 *
+	 * Can it be reclaimed from this node via demotion?
+	 */
+	return can_demote_anon_pages(nid, sc);
+}
+
 /*
  * This misses isolated pages which are not accounted for to save counters.
  * As the data only determines if reclaim or compaction continues, it is
@@ -541,7 +566,7 @@ unsigned long zone_reclaimable_pages(str
 
 	nr = zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_FILE) +
 		zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_FILE);
-	if (get_nr_swap_pages() > 0)
+	if (can_reclaim_anon_pages(NULL, zone_to_nid(zone), NULL))
 		nr += zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_ANON) +
 			zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_ANON);
 
@@ -2545,6 +2570,7 @@ enum scan_balance {
 static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 			   unsigned long *nr)
 {
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	unsigned long anon_cost, file_cost, total_cost;
 	int swappiness = mem_cgroup_swappiness(memcg);
@@ -2555,7 +2581,7 @@ static void get_scan_count(struct lruvec
 	enum lru_list lru;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || mem_cgroup_get_nr_swap_pages(memcg) <= 0) {
+	if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -2925,7 +2951,7 @@ static inline bool should_continue_recla
 	 */
 	pages_for_compaction = compact_gap(sc->order);
 	inactive_lru_pages = node_page_state(pgdat, NR_INACTIVE_FILE);
-	if (get_nr_swap_pages() > 0)
+	if (can_reclaim_anon_pages(NULL, pgdat->node_id, sc))
 		inactive_lru_pages += node_page_state(pgdat, NR_INACTIVE_ANON);
 
 	return inactive_lru_pages > pages_for_compaction;
_

Patches currently in -mm which might be from kbusch@kernel.org are

mm-vmscan-consider-anonymous-pages-without-swap.patch
mm-vmscan-consider-anonymous-pages-without-swap-v11.patch

