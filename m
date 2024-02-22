Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B6E18AED
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560221; cv=none; b=aihj26ynx432rnhmEhgnXDXoOEYLUBsEyKdQAnxnhqv+EE+gW9kp+OU4cZ4DXOkOHjVj7Voa/GxhL2ncknmOs9NZ1ELot0icD5E6RJN4szhBFCPXaKg/gBsqiqSd+jdnKxBvR/1E8WrigBERdz/0jV7Qa2aGcZGhYZKKbxXvKoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560221; c=relaxed/simple;
	bh=YSPlxGS9dlG4zfD4ysiQzIIbflV9lZHa6Gr05qHNzIc=;
	h=Date:To:From:Subject:Message-Id; b=d2/80N0ZC8ZYspM8W1sbJqLTqSNNWdk0ckLo/ZwR4IPI7kgLmgJqNdR7jY7u1pMutN4YBQER1ofRSYy2jCpZmMqAvbOV7wrO1il51ZuMhkTCYXfkl2RZay0oZqgCCN2XmJy8JarMQ10xTB7Ddtwm6b8KlzDYtACAx22IEtU9Fes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sn0W0N7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sn0W0N7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C015C433F1;
	Thu, 22 Feb 2024 00:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560221;
	bh=YSPlxGS9dlG4zfD4ysiQzIIbflV9lZHa6Gr05qHNzIc=;
	h=Date:To:From:Subject:From;
	b=Sn0W0N7VaP3VfCuZ0bFFXXXefXh1LXlmo7kKr9YFKHyRL2X1e7llfBxY9xqasDzIy
	 yl0MtznRj/5yqDm6a0qXgLJg302vP9fsdsdwljhIODLGoxvOzg5xAMbo7OH1LyHqRg
	 TGPKdClb/WHx1EyAxtd4WiiSG+VcX31kofStvEPs=
Date: Wed, 21 Feb 2024 16:03:40 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,donettom@linux.vnet.ibm.com,aneesh.kumar@linux.ibm.com,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-improve-struct-lru_gen_mm_walk.patch removed from -mm tree
Message-Id: <20240222000341.0C015C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: improve struct lru_gen_mm_walk
has been removed from the -mm tree.  Its filename was
     mm-mglru-improve-struct-lru_gen_mm_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kinsey Ho <kinseyho@google.com>
Subject: mm/mglru: improve struct lru_gen_mm_walk
Date: Wed, 14 Feb 2024 06:05:37 +0000

Rename max_seq to seq in struct lru_gen_mm_walk to keep consistent with
struct lru_gen_mm_state.  Note that seq is not always up to date with
max_seq from lru_gen_folio.

No functional changes.

Link: https://lkml.kernel.org/r/20240214060538.3524462-5-kinseyho@google.com
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Donet Tom <donettom@linux.vnet.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 ++--
 mm/vmscan.c            |   50 ++++++++++++++++++++-------------------
 2 files changed, 29 insertions(+), 27 deletions(-)

--- a/include/linux/mmzone.h~mm-mglru-improve-struct-lru_gen_mm_walk
+++ a/include/linux/mmzone.h
@@ -464,7 +464,7 @@ enum {
 #define NR_BLOOM_FILTERS	2
 
 struct lru_gen_mm_state {
-	/* set to max_seq after each iteration */
+	/* synced with max_seq after each iteration */
 	unsigned long seq;
 	/* where the current iteration continues after */
 	struct list_head *head;
@@ -479,8 +479,8 @@ struct lru_gen_mm_state {
 struct lru_gen_mm_walk {
 	/* the lruvec under reclaim */
 	struct lruvec *lruvec;
-	/* unstable max_seq from lru_gen_folio */
-	unsigned long max_seq;
+	/* max_seq from lru_gen_folio: can be out of date */
+	unsigned long seq;
 	/* the next address within an mm to scan */
 	unsigned long next_addr;
 	/* to batch promoted pages */
--- a/mm/vmscan.c~mm-mglru-improve-struct-lru_gen_mm_walk
+++ a/mm/vmscan.c
@@ -2888,7 +2888,7 @@ static void reset_mm_stats(struct lru_ge
 
 	lockdep_assert_held(&get_mm_list(lruvec_memcg(lruvec))->lock);
 
-	hist = lru_hist_from_seq(walk->max_seq);
+	hist = lru_hist_from_seq(walk->seq);
 
 	for (i = 0; i < NR_MM_STATS; i++) {
 		WRITE_ONCE(mm_state->stats[hist][i],
@@ -2897,7 +2897,7 @@ static void reset_mm_stats(struct lru_ge
 	}
 
 	if (NR_HIST_GENS > 1 && last) {
-		hist = lru_hist_from_seq(walk->max_seq + 1);
+		hist = lru_hist_from_seq(walk->seq + 1);
 
 		for (i = 0; i < NR_MM_STATS; i++)
 			WRITE_ONCE(mm_state->stats[hist][i], 0);
@@ -2926,9 +2926,9 @@ static bool iterate_mm_list(struct lru_g
 	 */
 	spin_lock(&mm_list->lock);
 
-	VM_WARN_ON_ONCE(mm_state->seq + 1 < walk->max_seq);
+	VM_WARN_ON_ONCE(mm_state->seq + 1 < walk->seq);
 
-	if (walk->max_seq <= mm_state->seq)
+	if (walk->seq <= mm_state->seq)
 		goto done;
 
 	if (!mm_state->head)
@@ -2958,7 +2958,7 @@ done:
 	spin_unlock(&mm_list->lock);
 
 	if (mm && first)
-		reset_bloom_filter(mm_state, walk->max_seq + 1);
+		reset_bloom_filter(mm_state, walk->seq + 1);
 
 	if (*iter)
 		mmput_async(*iter);
@@ -2968,7 +2968,7 @@ done:
 	return last;
 }
 
-static bool iterate_mm_list_nowalk(struct lruvec *lruvec, unsigned long max_seq)
+static bool iterate_mm_list_nowalk(struct lruvec *lruvec, unsigned long seq)
 {
 	bool success = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -2977,9 +2977,9 @@ static bool iterate_mm_list_nowalk(struc
 
 	spin_lock(&mm_list->lock);
 
-	VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
+	VM_WARN_ON_ONCE(mm_state->seq + 1 < seq);
 
-	if (max_seq > mm_state->seq) {
+	if (seq > mm_state->seq) {
 		mm_state->head = NULL;
 		mm_state->tail = NULL;
 		WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
@@ -3330,7 +3330,8 @@ static bool walk_pte_range(pmd_t *pmd, u
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
-	int old_gen, new_gen = lru_gen_from_seq(walk->max_seq);
+	DEFINE_MAX_SEQ(walk->lruvec);
+	int old_gen, new_gen = lru_gen_from_seq(max_seq);
 
 	pte = pte_offset_map_nolock(args->mm, pmd, start & PMD_MASK, &ptl);
 	if (!pte)
@@ -3397,7 +3398,8 @@ static void walk_pmd_range_locked(pud_t
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
-	int old_gen, new_gen = lru_gen_from_seq(walk->max_seq);
+	DEFINE_MAX_SEQ(walk->lruvec);
+	int old_gen, new_gen = lru_gen_from_seq(max_seq);
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3528,7 +3530,7 @@ restart:
 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
 		}
 
-		if (!walk->force_scan && !test_bloom_filter(mm_state, walk->max_seq, pmd + i))
+		if (!walk->force_scan && !test_bloom_filter(mm_state, walk->seq, pmd + i))
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
@@ -3539,7 +3541,7 @@ restart:
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
 
 		/* carry over to the next generation */
-		update_bloom_filter(mm_state, walk->max_seq + 1, pmd + i);
+		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
 	}
 
 	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
@@ -3610,7 +3612,7 @@ static void walk_mm(struct mm_struct *mm
 		err = -EBUSY;
 
 		/* another thread might have called inc_max_seq() */
-		if (walk->max_seq != max_seq)
+		if (walk->seq != max_seq)
 			break;
 
 		/* folio_update_gen() requires stable folio_memcg() */
@@ -3747,7 +3749,7 @@ next:
 	return success;
 }
 
-static bool inc_max_seq(struct lruvec *lruvec, unsigned long max_seq,
+static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 			bool can_swap, bool force_scan)
 {
 	bool success;
@@ -3755,14 +3757,14 @@ static bool inc_max_seq(struct lruvec *l
 	int type, zone;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 restart:
-	if (max_seq < READ_ONCE(lrugen->max_seq))
+	if (seq < READ_ONCE(lrugen->max_seq))
 		return false;
 
 	spin_lock_irq(&lruvec->lru_lock);
 
 	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 
-	success = max_seq == lrugen->max_seq;
+	success = seq == lrugen->max_seq;
 	if (!success)
 		goto unlock;
 
@@ -3815,7 +3817,7 @@ unlock:
 	return success;
 }
 
-static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long max_seq,
+static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 			       bool can_swap, bool force_scan)
 {
 	bool success;
@@ -3824,13 +3826,13 @@ static bool try_to_inc_max_seq(struct lr
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
 
-	VM_WARN_ON_ONCE(max_seq > READ_ONCE(lrugen->max_seq));
+	VM_WARN_ON_ONCE(seq > READ_ONCE(lrugen->max_seq));
 
 	if (!mm_state)
-		return inc_max_seq(lruvec, max_seq, can_swap, force_scan);
+		return inc_max_seq(lruvec, seq, can_swap, force_scan);
 
 	/* see the comment in iterate_mm_list() */
-	if (max_seq <= READ_ONCE(mm_state->seq))
+	if (seq <= READ_ONCE(mm_state->seq))
 		return false;
 
 	/*
@@ -3840,18 +3842,18 @@ static bool try_to_inc_max_seq(struct lr
 	 * is less efficient, but it avoids bursty page faults.
 	 */
 	if (!should_walk_mmu()) {
-		success = iterate_mm_list_nowalk(lruvec, max_seq);
+		success = iterate_mm_list_nowalk(lruvec, seq);
 		goto done;
 	}
 
 	walk = set_mm_walk(NULL, true);
 	if (!walk) {
-		success = iterate_mm_list_nowalk(lruvec, max_seq);
+		success = iterate_mm_list_nowalk(lruvec, seq);
 		goto done;
 	}
 
 	walk->lruvec = lruvec;
-	walk->max_seq = max_seq;
+	walk->seq = seq;
 	walk->can_swap = can_swap;
 	walk->force_scan = force_scan;
 
@@ -3862,7 +3864,7 @@ static bool try_to_inc_max_seq(struct lr
 	} while (mm);
 done:
 	if (success) {
-		success = inc_max_seq(lruvec, max_seq, can_swap, force_scan);
+		success = inc_max_seq(lruvec, seq, can_swap, force_scan);
 		WARN_ON_ONCE(!success);
 	}
 
_

Patches currently in -mm which might be from kinseyho@google.com are


