Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5776C32772
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 19:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241359AbiHQTEb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 15:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241265AbiHQTEU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 15:04:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89894A12C
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 12:04:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3AD3B81F0E
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 19:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F84C433D7;
        Wed, 17 Aug 2022 19:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660763040;
        bh=hFCzvggNVuJjL8oGUQDMjGcian4EEzMUaF5RHxENh68=;
        h=Date:To:From:Subject:From;
        b=vHAw1Hr9GkFHA+aXC2R1QXKxwRDucwV4QWB/xe7tM/+PlwsrRzJ74T/JFoEhf+pVX
         ogPST2Cy6yVm/3DJJCQ4WQMk6aZNknU/gDUIXxq3ecyfvtj3LgwqMCtxhUke4bLJaT
         ARTQahiVIczZF7UtiiKUk0X9hq1c3VNuiSM1S57A=
Date:   Wed, 17 Aug 2022 12:03:59 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, will@kernel.org, vbabka@suse.cz,
        vaibhav@linux.ibm.com, tj@kernel.org, szhai2@cs.rochester.edu,
        suleiman@google.com, steven@liquorix.net, sofia.trinh@edi.works,
        rppt@kernel.org, peterz@infradead.org, oleksandr@natalenko.name,
        Michael@MichaelLarabel.com, mhocko@kernel.org, mgorman@suse.de,
        linmiaohe@huawei.com, holger@applied-asynchrony.com,
        Hi-Angel@yandex.ru, heftig@archlinux.org, hdanton@sina.com,
        hannes@cmpxchg.org, djbyrne@mtu.edu, d@chaos-reins.com,
        dave.hansen@linux.intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bgeffon@google.com, baohua@kernel.org,
        axboe@kernel.dk, aneesh.kumar@linux.ibm.com, ak@linux.intel.com,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscanc-refactor-shrink_node.patch added to mm-unstable branch
Message-Id: <20220817190400.30F84C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: refactor shrink_node()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscanc-refactor-shrink_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscanc-refactor-shrink_node.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/vmscan.c: refactor shrink_node()
Date: Mon, 15 Aug 2022 01:13:22 -0600

This patch refactors shrink_node() to improve readability for the upcoming
changes to mm/vmscan.c.

Link: https://lkml.kernel.org/r/20220815071332.627393-4-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Acked-by: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Acked-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Acked-by: Steven Barrett <steven@liquorix.net>
Acked-by: Suleiman Souhlal <suleiman@google.com>
Tested-by: Daniel Byrne <djbyrne@mtu.edu>
Tested-by: Donald Carr <d@chaos-reins.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Tested-by: Konstantin Kharlamov <Hi-Angel@yandex.ru>
Tested-by: Shuang Zhai <szhai2@cs.rochester.edu>
Tested-by: Sofia Trinh <sofia.trinh@edi.works>
Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Larabel <Michael@MichaelLarabel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |  198 ++++++++++++++++++++++++++------------------------
 1 file changed, 104 insertions(+), 94 deletions(-)

--- a/mm/vmscan.c~mm-vmscanc-refactor-shrink_node
+++ a/mm/vmscan.c
@@ -2728,6 +2728,109 @@ enum scan_balance {
 	SCAN_FILE,
 };
 
+static void prepare_scan_count(pg_data_t *pgdat, struct scan_control *sc)
+{
+	unsigned long file;
+	struct lruvec *target_lruvec;
+
+	target_lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat);
+
+	/*
+	 * Flush the memory cgroup stats, so that we read accurate per-memcg
+	 * lruvec stats for heuristics.
+	 */
+	mem_cgroup_flush_stats();
+
+	/*
+	 * Determine the scan balance between anon and file LRUs.
+	 */
+	spin_lock_irq(&target_lruvec->lru_lock);
+	sc->anon_cost = target_lruvec->anon_cost;
+	sc->file_cost = target_lruvec->file_cost;
+	spin_unlock_irq(&target_lruvec->lru_lock);
+
+	/*
+	 * Target desirable inactive:active list ratios for the anon
+	 * and file LRU lists.
+	 */
+	if (!sc->force_deactivate) {
+		unsigned long refaults;
+
+		/*
+		 * When refaults are being observed, it means a new
+		 * workingset is being established. Deactivate to get
+		 * rid of any stale active pages quickly.
+		 */
+		refaults = lruvec_page_state(target_lruvec,
+				WORKINGSET_ACTIVATE_ANON);
+		if (refaults != target_lruvec->refaults[WORKINGSET_ANON] ||
+			inactive_is_low(target_lruvec, LRU_INACTIVE_ANON))
+			sc->may_deactivate |= DEACTIVATE_ANON;
+		else
+			sc->may_deactivate &= ~DEACTIVATE_ANON;
+
+		refaults = lruvec_page_state(target_lruvec,
+				WORKINGSET_ACTIVATE_FILE);
+		if (refaults != target_lruvec->refaults[WORKINGSET_FILE] ||
+		    inactive_is_low(target_lruvec, LRU_INACTIVE_FILE))
+			sc->may_deactivate |= DEACTIVATE_FILE;
+		else
+			sc->may_deactivate &= ~DEACTIVATE_FILE;
+	} else
+		sc->may_deactivate = DEACTIVATE_ANON | DEACTIVATE_FILE;
+
+	/*
+	 * If we have plenty of inactive file pages that aren't
+	 * thrashing, try to reclaim those first before touching
+	 * anonymous pages.
+	 */
+	file = lruvec_page_state(target_lruvec, NR_INACTIVE_FILE);
+	if (file >> sc->priority && !(sc->may_deactivate & DEACTIVATE_FILE))
+		sc->cache_trim_mode = 1;
+	else
+		sc->cache_trim_mode = 0;
+
+	/*
+	 * Prevent the reclaimer from falling into the cache trap: as
+	 * cache pages start out inactive, every cache fault will tip
+	 * the scan balance towards the file LRU.  And as the file LRU
+	 * shrinks, so does the window for rotation from references.
+	 * This means we have a runaway feedback loop where a tiny
+	 * thrashing file LRU becomes infinitely more attractive than
+	 * anon pages.  Try to detect this based on file LRU size.
+	 */
+	if (!cgroup_reclaim(sc)) {
+		unsigned long total_high_wmark = 0;
+		unsigned long free, anon;
+		int z;
+
+		free = sum_zone_node_page_state(pgdat->node_id, NR_FREE_PAGES);
+		file = node_page_state(pgdat, NR_ACTIVE_FILE) +
+			   node_page_state(pgdat, NR_INACTIVE_FILE);
+
+		for (z = 0; z < MAX_NR_ZONES; z++) {
+			struct zone *zone = &pgdat->node_zones[z];
+
+			if (!managed_zone(zone))
+				continue;
+
+			total_high_wmark += high_wmark_pages(zone);
+		}
+
+		/*
+		 * Consider anon: if that's low too, this isn't a
+		 * runaway file reclaim problem, but rather just
+		 * extreme pressure. Reclaim as per usual then.
+		 */
+		anon = node_page_state(pgdat, NR_INACTIVE_ANON);
+
+		sc->file_is_tiny =
+			file + free <= total_high_wmark &&
+			!(sc->may_deactivate & DEACTIVATE_ANON) &&
+			anon >> sc->priority;
+	}
+}
+
 /*
  * Determine how aggressively the anon and file LRU lists should be
  * scanned.
@@ -3195,109 +3298,16 @@ static void shrink_node(pg_data_t *pgdat
 	unsigned long nr_reclaimed, nr_scanned;
 	struct lruvec *target_lruvec;
 	bool reclaimable = false;
-	unsigned long file;
 
 	target_lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat);
 
 again:
-	/*
-	 * Flush the memory cgroup stats, so that we read accurate per-memcg
-	 * lruvec stats for heuristics.
-	 */
-	mem_cgroup_flush_stats();
-
 	memset(&sc->nr, 0, sizeof(sc->nr));
 
 	nr_reclaimed = sc->nr_reclaimed;
 	nr_scanned = sc->nr_scanned;
 
-	/*
-	 * Determine the scan balance between anon and file LRUs.
-	 */
-	spin_lock_irq(&target_lruvec->lru_lock);
-	sc->anon_cost = target_lruvec->anon_cost;
-	sc->file_cost = target_lruvec->file_cost;
-	spin_unlock_irq(&target_lruvec->lru_lock);
-
-	/*
-	 * Target desirable inactive:active list ratios for the anon
-	 * and file LRU lists.
-	 */
-	if (!sc->force_deactivate) {
-		unsigned long refaults;
-
-		/*
-		 * When refaults are being observed, it means a new
-		 * workingset is being established. Deactivate to get
-		 * rid of any stale active pages quickly.
-		 */
-		refaults = lruvec_page_state(target_lruvec,
-				WORKINGSET_ACTIVATE_ANON);
-		if (refaults != target_lruvec->refaults[WORKINGSET_ANON] ||
-			inactive_is_low(target_lruvec, LRU_INACTIVE_ANON))
-			sc->may_deactivate |= DEACTIVATE_ANON;
-		else
-			sc->may_deactivate &= ~DEACTIVATE_ANON;
-
-		refaults = lruvec_page_state(target_lruvec,
-				WORKINGSET_ACTIVATE_FILE);
-		if (refaults != target_lruvec->refaults[WORKINGSET_FILE] ||
-		    inactive_is_low(target_lruvec, LRU_INACTIVE_FILE))
-			sc->may_deactivate |= DEACTIVATE_FILE;
-		else
-			sc->may_deactivate &= ~DEACTIVATE_FILE;
-	} else
-		sc->may_deactivate = DEACTIVATE_ANON | DEACTIVATE_FILE;
-
-	/*
-	 * If we have plenty of inactive file pages that aren't
-	 * thrashing, try to reclaim those first before touching
-	 * anonymous pages.
-	 */
-	file = lruvec_page_state(target_lruvec, NR_INACTIVE_FILE);
-	if (file >> sc->priority && !(sc->may_deactivate & DEACTIVATE_FILE))
-		sc->cache_trim_mode = 1;
-	else
-		sc->cache_trim_mode = 0;
-
-	/*
-	 * Prevent the reclaimer from falling into the cache trap: as
-	 * cache pages start out inactive, every cache fault will tip
-	 * the scan balance towards the file LRU.  And as the file LRU
-	 * shrinks, so does the window for rotation from references.
-	 * This means we have a runaway feedback loop where a tiny
-	 * thrashing file LRU becomes infinitely more attractive than
-	 * anon pages.  Try to detect this based on file LRU size.
-	 */
-	if (!cgroup_reclaim(sc)) {
-		unsigned long total_high_wmark = 0;
-		unsigned long free, anon;
-		int z;
-
-		free = sum_zone_node_page_state(pgdat->node_id, NR_FREE_PAGES);
-		file = node_page_state(pgdat, NR_ACTIVE_FILE) +
-			   node_page_state(pgdat, NR_INACTIVE_FILE);
-
-		for (z = 0; z < MAX_NR_ZONES; z++) {
-			struct zone *zone = &pgdat->node_zones[z];
-			if (!managed_zone(zone))
-				continue;
-
-			total_high_wmark += high_wmark_pages(zone);
-		}
-
-		/*
-		 * Consider anon: if that's low too, this isn't a
-		 * runaway file reclaim problem, but rather just
-		 * extreme pressure. Reclaim as per usual then.
-		 */
-		anon = node_page_state(pgdat, NR_INACTIVE_ANON);
-
-		sc->file_is_tiny =
-			file + free <= total_high_wmark &&
-			!(sc->may_deactivate & DEACTIVATE_ANON) &&
-			anon >> sc->priority;
-	}
+	prepare_scan_count(pgdat, sc);
 
 	shrink_node_memcgs(pgdat, sc);
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-x86-arm64-add-arch_has_hw_pte_young.patch
mm-x86-add-config_arch_has_nonleaf_pmd_young.patch
mm-vmscanc-refactor-shrink_node.patch
revert-include-linux-mm_inlineh-fold-__update_lru_size-into-its-sole-caller.patch
mm-multi-gen-lru-groundwork.patch
mm-multi-gen-lru-minimal-implementation.patch
mm-multi-gen-lru-exploit-locality-in-rmap.patch
mm-multi-gen-lru-support-page-table-walks.patch
mm-multi-gen-lru-optimize-multiple-memcgs.patch
mm-multi-gen-lru-kill-switch.patch
mm-multi-gen-lru-thrashing-prevention.patch
mm-multi-gen-lru-debugfs-interface.patch
mm-multi-gen-lru-admin-guide.patch
mm-multi-gen-lru-design-doc.patch

