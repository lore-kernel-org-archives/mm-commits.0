Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B3D5D463
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 15:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707923576; cv=none; b=tMZ9dPhtXeKtLmLZv+yIdDvEHVA4+MQcEoFSm3Gi1qeFJL93lDjyFXs/QIqVOw5ulkGhegdu2TSEZeNz/Fa3Wnsd7qrtQDeHo53TFH8vHb5ZqXcf6BmGkW3025jV96NJvwCrYBhynIiAFoBFSrJhIvziM3+FLWKJqrM5mtQ3Dg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707923576; c=relaxed/simple;
	bh=Oejw/a7HNJAsN7xNsKwKC/g/xkl3kju8bjDLFcndcs4=;
	h=Date:To:From:Subject:Message-Id; b=Q1L4usoK++o/yPv62SXXV3nctnB+yRv3qeQvQliQTthHBKqebW0JdswNiSNKyj7HY3fJyhfF40vAu6BVwbf+xOeegzXHmUyd+9QI1RmUq1J6I9c69yOo+svjALjZ8/znYMWEF6oz12SaKeAnXLo2NK2aVt4IbaeXX6QKrG5CaBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NkMWtic+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NkMWtic+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83734C433C7;
	Wed, 14 Feb 2024 15:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707923576;
	bh=Oejw/a7HNJAsN7xNsKwKC/g/xkl3kju8bjDLFcndcs4=;
	h=Date:To:From:Subject:From;
	b=NkMWtic+75W3tD7hcw0f18xadnOZZq8hcakQdAE1zEmdby8sae8eqRb5wzuRNkQHQ
	 HJ5sRCKrIP6cQe1aZHI3PL073/NSrjToj7CZyZ3SVDZY5B1sOh7mwe2emPAxsos3Ue
	 MqfJym20N+5KWZ+YIPwwjlVpiZxOrLjtj5lerds4=
Date: Wed, 14 Feb 2024 07:12:55 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,donettom@linux.vnet.ibm.com,aneesh.kumar@linux.ibm.com,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-improve-reset_mm_stats.patch added to mm-unstable branch
Message-Id: <20240214151256.83734C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: improve reset_mm_stats()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-improve-reset_mm_stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-improve-reset_mm_stats.patch

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
From: Kinsey Ho <kinseyho@google.com>
Subject: mm/mglru: improve reset_mm_stats()
Date: Wed, 14 Feb 2024 06:05:36 +0000

struct lruvec* is already a field of struct lru_gen_mm_walk.  Remove the
parameter struct lruvec* into functions that already have access to struct
lru_gen_mm_walk*.

Also, we do not need to handle reset histogram stats when
!should_walk_mmu().  Remove the call to reset_mm_stats() in
iterate_mm_list_nowalk().

Link: https://lkml.kernel.org/r/20240214060538.3524462-4-kinseyho@google.com
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Donet Tom <donettom@linux.vnet.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

--- a/mm/vmscan.c~mm-mglru-improve-reset_mm_stats
+++ a/mm/vmscan.c
@@ -2880,38 +2880,37 @@ static struct mm_struct *get_next_mm(str
 
 #endif
 
-static void reset_mm_stats(struct lruvec *lruvec, struct lru_gen_mm_walk *walk, bool last)
+static void reset_mm_stats(struct lru_gen_mm_walk *walk, bool last)
 {
 	int i;
 	int hist;
+	struct lruvec *lruvec = walk->lruvec;
 	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
 
 	lockdep_assert_held(&get_mm_list(lruvec_memcg(lruvec))->lock);
 
-	if (walk) {
-		hist = lru_hist_from_seq(walk->max_seq);
+	hist = lru_hist_from_seq(walk->max_seq);
 
-		for (i = 0; i < NR_MM_STATS; i++) {
-			WRITE_ONCE(mm_state->stats[hist][i],
-				   mm_state->stats[hist][i] + walk->mm_stats[i]);
-			walk->mm_stats[i] = 0;
-		}
+	for (i = 0; i < NR_MM_STATS; i++) {
+		WRITE_ONCE(mm_state->stats[hist][i],
+			   mm_state->stats[hist][i] + walk->mm_stats[i]);
+		walk->mm_stats[i] = 0;
 	}
 
 	if (NR_HIST_GENS > 1 && last) {
-		hist = lru_hist_from_seq(mm_state->seq + 1);
+		hist = lru_hist_from_seq(walk->max_seq + 1);
 
 		for (i = 0; i < NR_MM_STATS; i++)
 			WRITE_ONCE(mm_state->stats[hist][i], 0);
 	}
 }
 
-static bool iterate_mm_list(struct lruvec *lruvec, struct lru_gen_mm_walk *walk,
-			    struct mm_struct **iter)
+static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **iter)
 {
 	bool first = false;
 	bool last = false;
 	struct mm_struct *mm = NULL;
+	struct lruvec *lruvec = walk->lruvec;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct lru_gen_mm_list *mm_list = get_mm_list(memcg);
 	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
@@ -2955,7 +2954,7 @@ static bool iterate_mm_list(struct lruve
 	} while (!(mm = get_next_mm(walk)));
 done:
 	if (*iter || last)
-		reset_mm_stats(lruvec, walk, last);
+		reset_mm_stats(walk, last);
 
 	spin_unlock(&mm_list->lock);
 
@@ -2985,7 +2984,6 @@ static bool iterate_mm_list_nowalk(struc
 		mm_state->head = NULL;
 		mm_state->tail = NULL;
 		WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
-		reset_mm_stats(lruvec, NULL, true);
 		success = true;
 	}
 
@@ -3160,9 +3158,10 @@ static void update_batch_size(struct lru
 	walk->nr_pages[new_gen][type][zone] += delta;
 }
 
-static void reset_batch_size(struct lruvec *lruvec, struct lru_gen_mm_walk *walk)
+static void reset_batch_size(struct lru_gen_mm_walk *walk)
 {
 	int gen, type, zone;
+	struct lruvec *lruvec = walk->lruvec;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	walk->batched = 0;
@@ -3592,7 +3591,7 @@ done:
 	return -EAGAIN;
 }
 
-static void walk_mm(struct lruvec *lruvec, struct mm_struct *mm, struct lru_gen_mm_walk *walk)
+static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 {
 	static const struct mm_walk_ops mm_walk_ops = {
 		.test_walk = should_skip_vma,
@@ -3601,6 +3600,7 @@ static void walk_mm(struct lruvec *lruve
 	};
 
 	int err;
+	struct lruvec *lruvec = walk->lruvec;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
 	walk->next_addr = FIRST_USER_ADDRESS;
@@ -3629,7 +3629,7 @@ static void walk_mm(struct lruvec *lruve
 
 		if (walk->batched) {
 			spin_lock_irq(&lruvec->lru_lock);
-			reset_batch_size(lruvec, walk);
+			reset_batch_size(walk);
 			spin_unlock_irq(&lruvec->lru_lock);
 		}
 
@@ -3857,9 +3857,9 @@ static bool try_to_inc_max_seq(struct lr
 	walk->force_scan = force_scan;
 
 	do {
-		success = iterate_mm_list(lruvec, walk, &mm);
+		success = iterate_mm_list(walk, &mm);
 		if (mm)
-			walk_mm(lruvec, mm, walk);
+			walk_mm(mm, walk);
 	} while (mm);
 done:
 	if (success) {
@@ -4559,8 +4559,10 @@ retry:
 	move_folios_to_lru(lruvec, &list);
 
 	walk = current->reclaim_state->mm_walk;
-	if (walk && walk->batched)
-		reset_batch_size(lruvec, walk);
+	if (walk && walk->batched) {
+		walk->lruvec = lruvec;
+		reset_batch_size(walk);
+	}
 
 	item = PGSTEAL_KSWAPD + reclaimer_offset();
 	if (!cgroup_reclaim(sc))
_

Patches currently in -mm which might be from kinseyho@google.com are

mm-mglru-drop-unused-parameter.patch
mm-mglru-improve-should_run_aging.patch
mm-mglru-improve-reset_mm_stats.patch
mm-mglru-improve-struct-lru_gen_mm_walk.patch
mm-mglru-improve-swappiness-handling.patch

