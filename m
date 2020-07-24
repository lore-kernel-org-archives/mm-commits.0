Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F321DC433E1
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 00:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC60220737
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 00:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595551664;
	bh=tWL1/jY1/uUyn3KQIVx3G/QqUoKCNW+kHBZ17RsSZV0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=L0iIzJxTqAN2OSVgGBLQ7F+0oDpvF5fCvcn+8wxn7s80r+l46/Xa4QBB/dMy1WXjN
	 my4BFoH5K6id5Ouees0VnaMgjOJB7imGg+ASh1VHuAYvr9liz+LBcvW1IlgO8/hEsY
	 HmhhkMHU99AlmKofq/3oI8uzXEvt/8ZW0bQq+QME=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgGXAro (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jul 2020 20:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbgGXAro (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jul 2020 20:47:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0BA3206E3;
        Fri, 24 Jul 2020 00:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595551663;
        bh=tWL1/jY1/uUyn3KQIVx3G/QqUoKCNW+kHBZ17RsSZV0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lduieeucFFlWwt62sJbjmGh7PUdeTfDqbYfJ44sXCnEXlg+KKG2QhGic6wwOXef41
         uD8AXVApDZAxrSlBQ4FVMh3FQ/KTtwAZGd1IeGTpt6ysRQAJuNfaIssCC2DS7tDsDd
         Gnfqo5GmD8NDgn+A5yu+hzDdxDGRDhwdMLKJHGo8=
Date:   Thu, 23 Jul 2020 17:47:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  +
 =?US-ASCII?Q?mm-workingset-prepare-the-workingset-detection-infrastructur?=
 =?US-ASCII?Q?e-for-anon-lru.patch?= added to -mm tree
Message-ID: <20200724004742.Teh0OBu39%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/workingset: prepare the workingset detection infrastructure for anon LRU
has been added to the -mm tree.  Its filename is
     mm-workingset-prepare-the-workingset-detection-infrastructure-for-anon-lru.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-prepare-the-workingset-detection-infrastructure-for-anon-lru.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-prepare-the-workingset-detection-infrastructure-for-anon-lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/workingset: prepare the workingset detection infrastructure for anon LRU

To prepare the workingset detection for anon LRU, this patch splits
workingset event counters for refault, activate and restore into anon and
file variants, as well as the refaults counter in struct lruvec.

Link: http://lkml.kernel.org/r/1595490560-15117-4-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   16 +++++++++++-----
 mm/memcontrol.c        |   16 +++++++++++-----
 mm/vmscan.c            |   15 ++++++++++-----
 mm/vmstat.c            |    9 ++++++---
 mm/workingset.c        |    8 +++++---
 5 files changed, 43 insertions(+), 21 deletions(-)

--- a/include/linux/mmzone.h~mm-workingset-prepare-the-workingset-detection-infrastructure-for-anon-lru
+++ a/include/linux/mmzone.h
@@ -173,9 +173,15 @@ enum node_stat_item {
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
 	WORKINGSET_NODES,
-	WORKINGSET_REFAULT,
-	WORKINGSET_ACTIVATE,
-	WORKINGSET_RESTORE,
+	WORKINGSET_REFAULT_BASE,
+	WORKINGSET_REFAULT_ANON = WORKINGSET_REFAULT_BASE,
+	WORKINGSET_REFAULT_FILE,
+	WORKINGSET_ACTIVATE_BASE,
+	WORKINGSET_ACTIVATE_ANON = WORKINGSET_ACTIVATE_BASE,
+	WORKINGSET_ACTIVATE_FILE,
+	WORKINGSET_RESTORE_BASE,
+	WORKINGSET_RESTORE_ANON = WORKINGSET_RESTORE_BASE,
+	WORKINGSET_RESTORE_FILE,
 	WORKINGSET_NODERECLAIM,
 	NR_ANON_MAPPED,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
@@ -277,8 +283,8 @@ struct lruvec {
 	unsigned long			file_cost;
 	/* Non-resident age, driven by LRU movement */
 	atomic_long_t			nonresident_age;
-	/* Refaults at the time of last reclaim cycle */
-	unsigned long			refaults;
+	/* Refaults at the time of last reclaim cycle, anon=0, file=1 */
+	unsigned long			refaults[2];
 	/* Various lruvec state flags (enum lruvec_flags) */
 	unsigned long			flags;
 #ifdef CONFIG_MEMCG
--- a/mm/memcontrol.c~mm-workingset-prepare-the-workingset-detection-infrastructure-for-anon-lru
+++ a/mm/memcontrol.c
@@ -1530,12 +1530,18 @@ static char *memory_stat_format(struct m
 	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGMAJFAULT),
 		       memcg_events(memcg, PGMAJFAULT));
 
-	seq_buf_printf(&s, "workingset_refault %lu\n",
-		       memcg_page_state(memcg, WORKINGSET_REFAULT));
-	seq_buf_printf(&s, "workingset_activate %lu\n",
-		       memcg_page_state(memcg, WORKINGSET_ACTIVATE));
+	seq_buf_printf(&s, "workingset_refault_anon %lu\n",
+		       memcg_page_state(memcg, WORKINGSET_REFAULT_ANON));
+	seq_buf_printf(&s, "workingset_refault_file %lu\n",
+		       memcg_page_state(memcg, WORKINGSET_REFAULT_FILE));
+	seq_buf_printf(&s, "workingset_activate_anon %lu\n",
+		       memcg_page_state(memcg, WORKINGSET_ACTIVATE_ANON));
+	seq_buf_printf(&s, "workingset_activate_file %lu\n",
+		       memcg_page_state(memcg, WORKINGSET_ACTIVATE_FILE));
 	seq_buf_printf(&s, "workingset_restore %lu\n",
-		       memcg_page_state(memcg, WORKINGSET_RESTORE));
+		       memcg_page_state(memcg, WORKINGSET_RESTORE_ANON));
+	seq_buf_printf(&s, "workingset_restore %lu\n",
+		       memcg_page_state(memcg, WORKINGSET_RESTORE_FILE));
 	seq_buf_printf(&s, "workingset_nodereclaim %lu\n",
 		       memcg_page_state(memcg, WORKINGSET_NODERECLAIM));
 
--- a/mm/vmscan.c~mm-workingset-prepare-the-workingset-detection-infrastructure-for-anon-lru
+++ a/mm/vmscan.c
@@ -2683,7 +2683,10 @@ again:
 	if (!sc->force_deactivate) {
 		unsigned long refaults;
 
-		if (inactive_is_low(target_lruvec, LRU_INACTIVE_ANON))
+		refaults = lruvec_page_state(target_lruvec,
+				WORKINGSET_ACTIVATE_ANON);
+		if (refaults != target_lruvec->refaults[0] ||
+			inactive_is_low(target_lruvec, LRU_INACTIVE_ANON))
 			sc->may_deactivate |= DEACTIVATE_ANON;
 		else
 			sc->may_deactivate &= ~DEACTIVATE_ANON;
@@ -2694,8 +2697,8 @@ again:
 		 * rid of any stale active pages quickly.
 		 */
 		refaults = lruvec_page_state(target_lruvec,
-					     WORKINGSET_ACTIVATE);
-		if (refaults != target_lruvec->refaults ||
+				WORKINGSET_ACTIVATE_FILE);
+		if (refaults != target_lruvec->refaults[1] ||
 		    inactive_is_low(target_lruvec, LRU_INACTIVE_FILE))
 			sc->may_deactivate |= DEACTIVATE_FILE;
 		else
@@ -2972,8 +2975,10 @@ static void snapshot_refaults(struct mem
 	unsigned long refaults;
 
 	target_lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
-	refaults = lruvec_page_state(target_lruvec, WORKINGSET_ACTIVATE);
-	target_lruvec->refaults = refaults;
+	refaults = lruvec_page_state(target_lruvec, WORKINGSET_ACTIVATE_ANON);
+	target_lruvec->refaults[0] = refaults;
+	refaults = lruvec_page_state(target_lruvec, WORKINGSET_ACTIVATE_FILE);
+	target_lruvec->refaults[1] = refaults;
 }
 
 /*
--- a/mm/vmstat.c~mm-workingset-prepare-the-workingset-detection-infrastructure-for-anon-lru
+++ a/mm/vmstat.c
@@ -1167,9 +1167,12 @@ const char * const vmstat_text[] = {
 	"nr_isolated_anon",
 	"nr_isolated_file",
 	"workingset_nodes",
-	"workingset_refault",
-	"workingset_activate",
-	"workingset_restore",
+	"workingset_refault_anon",
+	"workingset_refault_file",
+	"workingset_activate_anon",
+	"workingset_activate_file",
+	"workingset_restore_anon",
+	"workingset_restore_file",
 	"workingset_nodereclaim",
 	"nr_anon_pages",
 	"nr_mapped",
--- a/mm/workingset.c~mm-workingset-prepare-the-workingset-detection-infrastructure-for-anon-lru
+++ a/mm/workingset.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/memcontrol.h>
+#include <linux/mm_inline.h>
 #include <linux/writeback.h>
 #include <linux/shmem_fs.h>
 #include <linux/pagemap.h>
@@ -280,6 +281,7 @@ void *workingset_eviction(struct page *p
  */
 void workingset_refault(struct page *page, void *shadow)
 {
+	bool file = page_is_file_lru(page);
 	struct mem_cgroup *eviction_memcg;
 	struct lruvec *eviction_lruvec;
 	unsigned long refault_distance;
@@ -346,7 +348,7 @@ void workingset_refault(struct page *pag
 	memcg = page_memcg(page);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
-	inc_lruvec_state(lruvec, WORKINGSET_REFAULT);
+	inc_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file);
 
 	/*
 	 * Compare the distance to the existing workingset size. We
@@ -366,7 +368,7 @@ void workingset_refault(struct page *pag
 
 	SetPageActive(page);
 	workingset_age_nonresident(lruvec, hpage_nr_pages(page));
-	inc_lruvec_state(lruvec, WORKINGSET_ACTIVATE);
+	inc_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + file);
 
 	/* Page was active prior to eviction */
 	if (workingset) {
@@ -375,7 +377,7 @@ void workingset_refault(struct page *pag
 		spin_lock_irq(&page_pgdat(page)->lru_lock);
 		lru_note_cost_page(page);
 		spin_unlock_irq(&page_pgdat(page)->lru_lock);
-		inc_lruvec_state(lruvec, WORKINGSET_RESTORE);
+		inc_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file);
 	}
 out:
 	rcu_read_unlock();
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmscan-make-active-inactive-ratio-as-1-1-for-anon-lru.patch
mm-vmscan-protect-the-workingset-on-anonymous-lru.patch
mm-workingset-prepare-the-workingset-detection-infrastructure-for-anon-lru.patch
mm-swapcache-support-to-handle-the-shadow-entries.patch
mm-swap-implement-workingset-detection-for-anonymous-lru.patch
mm-vmscan-restore-active-inactive-ratio-for-anonymous-lru.patch
mm-page_isolation-prefer-the-node-of-the-source-page.patch
mm-migrate-move-migration-helper-from-h-to-c.patch
mm-hugetlb-unify-migration-callbacks.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch
mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch

