Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96975C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 22 Dec 2022 21:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbiLVVn5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Dec 2022 16:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiLVVnp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Dec 2022 16:43:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFD4275CC
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 13:43:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD0AD61DAD
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 21:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349D3C433EF;
        Thu, 22 Dec 2022 21:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671745423;
        bh=Lnl+EoNXEqTeHss5G68qB6+VA4Jzc7q2BkwKkra7T2w=;
        h=Date:To:From:Subject:From;
        b=pkn0f+cCwmJnM/uCfziG9teIrIwNGAbj2kogF16XvihaD49nPPYsmrIOa1lVkmye1
         MpLgK1Jxp/TH9zd0l7WNqi3lIT74YI4ddZiETBwNyWjAzjbvBPXWnm1tlbf6AonX0/
         /KwMP5a/3z6kk+zuDj8Caxg+VB4zu+BccZSZVB7c=
Date:   Thu, 22 Dec 2022 13:43:42 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com, rppt@kernel.org,
        roman.gushchin@linux.dev, Michael@MichaelLarabel.com,
        mhocko@kernel.org, hannes@cmpxchg.org, corbet@lwn.net,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-shuffle-should_run_aging.patch added to mm-unstable branch
Message-Id: <20221222214343.349D3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: shuffle should_run_aging()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-shuffle-should_run_aging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-shuffle-should_run_aging.patch

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
Subject: mm: multi-gen LRU: shuffle should_run_aging()
Date: Wed, 21 Dec 2022 21:19:03 -0700

Move should_run_aging() next to its only caller left.

Link: https://lkml.kernel.org/r/20221222041905.2431096-6-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Larabel <Michael@MichaelLarabel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmscan.c~mm-multi-gen-lru-shuffle-should_run_aging
+++ a/mm/vmscan.c
@@ -4467,68 +4467,6 @@ done:
 	return true;
 }
 
-static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
-			     struct scan_control *sc, bool can_swap, unsigned long *nr_to_scan)
-{
-	int gen, type, zone;
-	unsigned long old = 0;
-	unsigned long young = 0;
-	unsigned long total = 0;
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
-	DEFINE_MIN_SEQ(lruvec);
-
-	/* whether this lruvec is completely out of cold folios */
-	if (min_seq[!can_swap] + MIN_NR_GENS > max_seq) {
-		*nr_to_scan = 0;
-		return true;
-	}
-
-	for (type = !can_swap; type < ANON_AND_FILE; type++) {
-		unsigned long seq;
-
-		for (seq = min_seq[type]; seq <= max_seq; seq++) {
-			unsigned long size = 0;
-
-			gen = lru_gen_from_seq(seq);
-
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-
-			total += size;
-			if (seq == max_seq)
-				young += size;
-			else if (seq + MIN_NR_GENS == max_seq)
-				old += size;
-		}
-	}
-
-	/* try to scrape all its memory if this memcg was deleted */
-	*nr_to_scan = mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
-
-	/*
-	 * The aging tries to be lazy to reduce the overhead, while the eviction
-	 * stalls when the number of generations reaches MIN_NR_GENS. Hence, the
-	 * ideal number of generations is MIN_NR_GENS+1.
-	 */
-	if (min_seq[!can_swap] + MIN_NR_GENS < max_seq)
-		return false;
-
-	/*
-	 * It's also ideal to spread pages out evenly, i.e., 1/(MIN_NR_GENS+1)
-	 * of the total number of pages for each generation. A reasonable range
-	 * for this average portion is [1/MIN_NR_GENS, 1/(MIN_NR_GENS+2)]. The
-	 * aging cares about the upper bound of hot pages, while the eviction
-	 * cares about the lower bound of cold pages.
-	 */
-	if (young * MIN_NR_GENS > total)
-		return true;
-	if (old * (MIN_NR_GENS + 2) < total)
-		return true;
-
-	return false;
-}
-
 static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
 {
 	int gen, type, zone;
@@ -5112,6 +5050,68 @@ retry:
 	return scanned;
 }
 
+static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
+			     struct scan_control *sc, bool can_swap, unsigned long *nr_to_scan)
+{
+	int gen, type, zone;
+	unsigned long old = 0;
+	unsigned long young = 0;
+	unsigned long total = 0;
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	DEFINE_MIN_SEQ(lruvec);
+
+	/* whether this lruvec is completely out of cold folios */
+	if (min_seq[!can_swap] + MIN_NR_GENS > max_seq) {
+		*nr_to_scan = 0;
+		return true;
+	}
+
+	for (type = !can_swap; type < ANON_AND_FILE; type++) {
+		unsigned long seq;
+
+		for (seq = min_seq[type]; seq <= max_seq; seq++) {
+			unsigned long size = 0;
+
+			gen = lru_gen_from_seq(seq);
+
+			for (zone = 0; zone < MAX_NR_ZONES; zone++)
+				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+
+			total += size;
+			if (seq == max_seq)
+				young += size;
+			else if (seq + MIN_NR_GENS == max_seq)
+				old += size;
+		}
+	}
+
+	/* try to scrape all its memory if this memcg was deleted */
+	*nr_to_scan = mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
+
+	/*
+	 * The aging tries to be lazy to reduce the overhead, while the eviction
+	 * stalls when the number of generations reaches MIN_NR_GENS. Hence, the
+	 * ideal number of generations is MIN_NR_GENS+1.
+	 */
+	if (min_seq[!can_swap] + MIN_NR_GENS < max_seq)
+		return false;
+
+	/*
+	 * It's also ideal to spread pages out evenly, i.e., 1/(MIN_NR_GENS+1)
+	 * of the total number of pages for each generation. A reasonable range
+	 * for this average portion is [1/MIN_NR_GENS, 1/(MIN_NR_GENS+2)]. The
+	 * aging cares about the upper bound of hot pages, while the eviction
+	 * cares about the lower bound of cold pages.
+	 */
+	if (young * MIN_NR_GENS > total)
+		return true;
+	if (old * (MIN_NR_GENS + 2) < total)
+		return true;
+
+	return false;
+}
+
 /*
  * For future optimizations:
  * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-multi-gen-lru-rename-lru_gen_struct-to-lru_gen_folio.patch
mm-multi-gen-lru-rename-lrugen-lists-to-lrugen-folios.patch
mm-multi-gen-lru-remove-eviction-fairness-safeguard.patch
mm-multi-gen-lru-remove-aging-fairness-safeguard.patch
mm-multi-gen-lru-shuffle-should_run_aging.patch
mm-multi-gen-lru-per-node-lru_gen_folio-lists.patch
mm-multi-gen-lru-clarify-scan_control-flags.patch
mm-multi-gen-lru-simplify-arch_has_hw_pte_young-check.patch

