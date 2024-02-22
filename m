Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3BB179AC
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560220; cv=none; b=WI6FqWuLrkhKLfBlNQeSYAi0tXTBizvTopOHwOzvJIFI2g28YJ8olORy845TEq5RAAeooNu6yy99qkAjtGjrTOsTI8/gvDjdZKA/scToKVxwpN0k5DzB1uzH4AtPzZw3n2AN2NMg6j/alnLAYGy6Mnp3iRblCLRjpbyZy4gacP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560220; c=relaxed/simple;
	bh=HqZcZVgeZbl47V3SpMYV3ULybiSxss1KrX3tVUnfG+E=;
	h=Date:To:From:Subject:Message-Id; b=oBlLsa5xnH3wyMILDCOeWN6n+u3qMe50XU2C6mbIAyBjDH2aazVk10hFLGSq+P6RsXO8UMXbJUp4AHQIiJdk4jWMyA48v/dQJnZdDcNHO6csCNUARjGCoeJgWvl6jKfarz/0D9IhylQ0HMHFE8QN5Fg99R6PS1ADq/MADo4p1uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e9uCMwlA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e9uCMwlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7F7C433F1;
	Thu, 22 Feb 2024 00:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560220;
	bh=HqZcZVgeZbl47V3SpMYV3ULybiSxss1KrX3tVUnfG+E=;
	h=Date:To:From:Subject:From;
	b=e9uCMwlAhiebi4pES1PgdZHaqF9lfLFi5BOH6PF8XW34mDCvl0tKhNX/kGknxzgp2
	 IFX6tuzX5wsVFq/E/X6ludDq9TW/Xh/QkzqgVEYCsS9meG/umyTtETMy8540aAdVZ1
	 dSt2TE3eIBs4Hfe2d+f5ivJxZPRLop9O/ffXGIfw=
Date: Wed, 21 Feb 2024 16:03:39 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,donettom@linux.vnet.ibm.com,aneesh.kumar@linux.ibm.com,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-improve-reset_mm_stats.patch removed from -mm tree
Message-Id: <20240222000340.0F7F7C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: improve reset_mm_stats()
has been removed from the -mm tree.  Its filename was
     mm-mglru-improve-reset_mm_stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2879,38 +2879,37 @@ static struct mm_struct *get_next_mm(str
 
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
@@ -2954,7 +2953,7 @@ static bool iterate_mm_list(struct lruve
 	} while (!(mm = get_next_mm(walk)));
 done:
 	if (*iter || last)
-		reset_mm_stats(lruvec, walk, last);
+		reset_mm_stats(walk, last);
 
 	spin_unlock(&mm_list->lock);
 
@@ -2984,7 +2983,6 @@ static bool iterate_mm_list_nowalk(struc
 		mm_state->head = NULL;
 		mm_state->tail = NULL;
 		WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
-		reset_mm_stats(lruvec, NULL, true);
 		success = true;
 	}
 
@@ -3159,9 +3157,10 @@ static void update_batch_size(struct lru
 	walk->nr_pages[new_gen][type][zone] += delta;
 }
 
-static void reset_batch_size(struct lruvec *lruvec, struct lru_gen_mm_walk *walk)
+static void reset_batch_size(struct lru_gen_mm_walk *walk)
 {
 	int gen, type, zone;
+	struct lruvec *lruvec = walk->lruvec;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	walk->batched = 0;
@@ -3591,7 +3590,7 @@ done:
 	return -EAGAIN;
 }
 
-static void walk_mm(struct lruvec *lruvec, struct mm_struct *mm, struct lru_gen_mm_walk *walk)
+static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 {
 	static const struct mm_walk_ops mm_walk_ops = {
 		.test_walk = should_skip_vma,
@@ -3600,6 +3599,7 @@ static void walk_mm(struct lruvec *lruve
 	};
 
 	int err;
+	struct lruvec *lruvec = walk->lruvec;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
 	walk->next_addr = FIRST_USER_ADDRESS;
@@ -3628,7 +3628,7 @@ static void walk_mm(struct lruvec *lruve
 
 		if (walk->batched) {
 			spin_lock_irq(&lruvec->lru_lock);
-			reset_batch_size(lruvec, walk);
+			reset_batch_size(walk);
 			spin_unlock_irq(&lruvec->lru_lock);
 		}
 
@@ -3856,9 +3856,9 @@ static bool try_to_inc_max_seq(struct lr
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
@@ -4558,8 +4558,10 @@ retry:
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


