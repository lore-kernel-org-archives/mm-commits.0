Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59915C4332F
	for <mm-commits@archiver.kernel.org>; Sun, 16 Oct 2022 23:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiJPX7A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 19:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiJPX67 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 19:58:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6E72CC98
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 16:58:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43D65B80CB9
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 23:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC2EC433C1;
        Sun, 16 Oct 2022 23:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665964736;
        bh=04fIdlLBYIhJ1KpBa7kEnQWEsFSuXJDY1eQm27tOO/s=;
        h=Date:To:From:Subject:From;
        b=zkeDr5WU8Mkwpqkod3ePZjTnVLMp4TtcreIUazZtBn116670Bn9NDgp+zIHxX9AGm
         8B30un19ICu+fjLnOmvSEEvR5P3qXFopCNa8OClED3XCS534E2wcXdhTJKTjEED9Rr
         aib1dgfmk1St+dORXOLEfjkkrMbHw2SXuCpF4fxk=
Date:   Sun, 16 Oct 2022 16:58:55 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-make-rotations-a-secondary-factor-in-balancing-anon-vs-file.patch added to mm-unstable branch
Message-Id: <20221016235855.DCC2EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: make rotations a secondary factor in balancing anon vs file
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-make-rotations-a-secondary-factor-in-balancing-anon-vs-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-make-rotations-a-secondary-factor-in-balancing-anon-vs-file.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: make rotations a secondary factor in balancing anon vs file
Date: Thu, 13 Oct 2022 15:31:13 -0400

We noticed a 2% webserver throughput regression after upgrading from 5.6. 
This could be tracked down to a shift in the anon/file reclaim balance
(confirmed with swappiness) that resulted in worse reclaim efficiency and
thus more kswapd activity for the same outcome.

The change that exposed the problem is aae466b0052e ("mm/swap: implement
workingset detection for anonymous LRU").  By qualifying swapins based on
their refault distance, it lowered the cost of anon reclaim in this
workload, in turn causing (much) more anon scanning than before.  Scanning
the anon list is more expensive due to the higher ratio of mmapped pages
that may rotate during reclaim, and so the result was an increase in %sys
time.

Right now, rotations aren't considered a cost when balancing scan pressure
between LRUs.  We can end up with very few file refaults putting all the
scan pressure on hot anon pages that are rotated en masse, don't get
reclaimed, and never push back on the file LRU again.  We still only
reclaim file cache in that case, but we burn a lot CPU rotating anon
pages.  It's "fair" from an LRU age POV, but doesn't reflect the real cost
it imposes on the system.

Consider rotations as a secondary factor in balancing the LRUs.  This
doesn't attempt to make a precise comparison between IO cost and CPU cost,
it just says: if reloads are about comparable between the lists, or
rotations are overwhelmingly different, adjust for CPU work.

This fixed the regression on our webservers.  It has since been deployed
to the entire Meta fleet and hasn't caused any problems.

Link: https://lkml.kernel.org/r/20221013193113.726425-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +++--
 mm/swap.c            |   22 +++++++++++++++++-----
 mm/vmscan.c          |    4 +++-
 mm/workingset.c      |    2 +-
 4 files changed, 24 insertions(+), 9 deletions(-)

--- a/include/linux/swap.h~mm-vmscan-make-rotations-a-secondary-factor-in-balancing-anon-vs-file
+++ a/include/linux/swap.h
@@ -384,8 +384,9 @@ extern unsigned long totalreserve_pages;
 
 
 /* linux/mm/swap.c */
-void lru_note_cost(struct lruvec *lruvec, bool file, unsigned int nr_pages);
-void lru_note_cost_folio(struct folio *);
+void lru_note_cost(struct lruvec *lruvec, bool file,
+		   unsigned int nr_io, unsigned int nr_rotated);
+void lru_note_cost_refault(struct folio *);
 void folio_add_lru(struct folio *);
 void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
 void lru_cache_add(struct page *);
--- a/mm/swap.c~mm-vmscan-make-rotations-a-secondary-factor-in-balancing-anon-vs-file
+++ a/mm/swap.c
@@ -295,8 +295,20 @@ void folio_rotate_reclaimable(struct fol
 	}
 }
 
-void lru_note_cost(struct lruvec *lruvec, bool file, unsigned int nr_pages)
+void lru_note_cost(struct lruvec *lruvec, bool file,
+		   unsigned int nr_io, unsigned int nr_rotated)
 {
+	unsigned long cost;
+
+	/*
+	 * Reflect the relative cost of incurring IO and spending CPU
+	 * time on rotations. This doesn't attempt to make a precise
+	 * comparison, it just says: if reloads are about comparable
+	 * between the LRU lists, or rotations are overwhelmingly
+	 * different between them, adjust scan balance for CPU work.
+	 */
+	cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated;
+
 	do {
 		unsigned long lrusize;
 
@@ -310,9 +322,9 @@ void lru_note_cost(struct lruvec *lruvec
 		spin_lock_irq(&lruvec->lru_lock);
 		/* Record cost event */
 		if (file)
-			lruvec->file_cost += nr_pages;
+			lruvec->file_cost += cost;
 		else
-			lruvec->anon_cost += nr_pages;
+			lruvec->anon_cost += cost;
 
 		/*
 		 * Decay previous events
@@ -335,10 +347,10 @@ void lru_note_cost(struct lruvec *lruvec
 	} while ((lruvec = parent_lruvec(lruvec)));
 }
 
-void lru_note_cost_folio(struct folio *folio)
+void lru_note_cost_refault(struct folio *folio)
 {
 	lru_note_cost(folio_lruvec(folio), folio_is_file_lru(folio),
-			folio_nr_pages(folio));
+		      folio_nr_pages(folio), 0);
 }
 
 static void folio_activate_fn(struct lruvec *lruvec, struct folio *folio)
--- a/mm/vmscan.c~mm-vmscan-make-rotations-a-secondary-factor-in-balancing-anon-vs-file
+++ a/mm/vmscan.c
@@ -2499,7 +2499,7 @@ static unsigned long shrink_inactive_lis
 	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
 	spin_unlock_irq(&lruvec->lru_lock);
 
-	lru_note_cost(lruvec, file, stat.nr_pageout);
+	lru_note_cost(lruvec, file, stat.nr_pageout, nr_scanned - nr_reclaimed);
 	mem_cgroup_uncharge_list(&folio_list);
 	free_unref_page_list(&folio_list);
 
@@ -2639,6 +2639,8 @@ static void shrink_active_list(unsigned
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	spin_unlock_irq(&lruvec->lru_lock);
 
+	if (nr_rotated)
+		lru_note_cost(lruvec, file, 0, nr_rotated);
 	mem_cgroup_uncharge_list(&l_active);
 	free_unref_page_list(&l_active);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
--- a/mm/workingset.c~mm-vmscan-make-rotations-a-secondary-factor-in-balancing-anon-vs-file
+++ a/mm/workingset.c
@@ -493,7 +493,7 @@ void workingset_refault(struct folio *fo
 	if (workingset) {
 		folio_set_workingset(folio);
 		/* XXX: Move to lru_cache_add() when it supports new vs putback */
-		lru_note_cost_folio(folio);
+		lru_note_cost_refault(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
 	}
 out:
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-make-rotations-a-secondary-factor-in-balancing-anon-vs-file.patch
mm-vmscan-fix-extreme-overreclaim-and-swap-floods.patch

