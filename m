Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813ECC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D7F56112F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350484AbhICVBr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350231AbhICVBi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:01:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B04C86112F;
        Fri,  3 Sep 2021 21:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702838;
        bh=J2qgglHXD/YMsc+M9x2YlCR3VTJr2BkjvbjOGhfG1dc=;
        h=Date:From:To:Subject:From;
        b=MMXz5C6axicS1NJCVWR8E3pg5rAIl3DKXG/2mkC464MQW8fKYRWz0+K2zmMULC2zo
         jiU2QlPSLGGxrdUh8ngi4GPPNU4d+d8y2dLXCIb735z/lg/FcwwfOToF987yVaUem+
         htl7ccdJfNZktl9zFQWB7U4sWgroXjveCO7ieyOk=
Date:   Fri, 03 Sep 2021 14:00:37 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, gthelen@google.com, kbusch@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        rientjes@google.com, shy828301@gmail.com, weixugc@google.com,
        yang.shi@linux.alibaba.com, ying.huang@intel.com, ziy@nvidia.com
Subject:  [merged]
 mm-vmscan-consider-anonymous-pages-without-swap.patch removed from -mm tree
Message-ID: <20210903210037.I_DweaGo5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: Consider anonymous pages without swap
has been removed from the -mm tree.  Its filename was
     mm-vmscan-consider-anonymous-pages-without-swap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[kbusch@kernel.org: v11]
  Link: https://lkml.kernel.org/r/20210715055145.195411-8-ying.huang@intel.com
  Link: https://lkml.kernel.org/r/20210721063926.3024591-7-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20210715055145.195411-8-ying.huang@intel.com
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
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
@@ -524,7 +524,7 @@ static long add_nr_deferred(long nr, str
 
 static bool can_demote(int nid, struct scan_control *sc)
 {
-	if (sc->no_demotion)
+	if (sc && sc->no_demotion)
 		return false;
 	if (next_demotion_node(nid) == NUMA_NO_NODE)
 		return false;
@@ -533,6 +533,31 @@ static bool can_demote(int nid, struct s
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
+	return can_demote(nid, sc);
+}
+
 /*
  * This misses isolated pages which are not accounted for to save counters.
  * As the data only determines if reclaim or compaction continues, it is
@@ -544,7 +569,7 @@ unsigned long zone_reclaimable_pages(str
 
 	nr = zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_FILE) +
 		zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_FILE);
-	if (get_nr_swap_pages() > 0)
+	if (can_reclaim_anon_pages(NULL, zone_to_nid(zone), NULL))
 		nr += zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_ANON) +
 			zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_ANON);
 
@@ -2541,6 +2566,7 @@ enum scan_balance {
 static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 			   unsigned long *nr)
 {
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	unsigned long anon_cost, file_cost, total_cost;
 	int swappiness = mem_cgroup_swappiness(memcg);
@@ -2551,7 +2577,7 @@ static void get_scan_count(struct lruvec
 	enum lru_list lru;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || mem_cgroup_get_nr_swap_pages(memcg) <= 0) {
+	if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -2929,7 +2955,7 @@ static inline bool should_continue_recla
 	 */
 	pages_for_compaction = compact_gap(sc->order);
 	inactive_lru_pages = node_page_state(pgdat, NR_INACTIVE_FILE);
-	if (get_nr_swap_pages() > 0)
+	if (can_reclaim_anon_pages(NULL, pgdat->node_id, sc))
 		inactive_lru_pages += node_page_state(pgdat, NR_INACTIVE_ANON);
 
 	return inactive_lru_pages > pages_for_compaction;
_

Patches currently in -mm which might be from kbusch@kernel.org are


