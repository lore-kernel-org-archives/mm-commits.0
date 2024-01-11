Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1854556759
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 20:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i9cDgVCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FAEC433C7;
	Thu, 11 Jan 2024 20:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705003726;
	bh=hgdRSpFnJYuRfR/0CZh2HlRFbABP1+es6P0xE4Zsgok=;
	h=Date:To:From:Subject:From;
	b=i9cDgVCr5mZ4gjh3qj9nqROONX5E/xCpRg5mF9v+5En0qtmveDuYzLcejfwt3FeBy
	 EDiHfl/RKK1K8jurDMw1IwtS6bZlHPrO6reqyL+JeNDOqX0szolF6v8quF+2Ixi6zM
	 Hye9YFzOiB9LrVhjVNPZVJfUNd1y/boHsk1MO2Xs=
Date: Thu, 11 Jan 2024 12:08:45 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,chrisl@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-lru_gen-batch-update-counters-on-againg.patch added to mm-unstable branch
Message-Id: <20240111200846.89FAEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, lru_gen: batch update counters on aging
has been added to the -mm mm-unstable branch.  Its filename is
     mm-lru_gen-batch-update-counters-on-againg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-lru_gen-batch-update-counters-on-againg.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, lru_gen: batch update counters on aging
Date: Fri, 12 Jan 2024 02:33:19 +0800

Patch series "mm, lru_gen: batch update pages when aging", v2.

Currently when MGLRU ages, it moves the pages one by one and updates mm
counter page by page, which is correct but the overhead can be optimized
by batching these operations.

In previous series I only test with memtier which didn't show a good
enough improment.  Acutally in-mem fio benifits the most from patch 3:

Ramdisk fio test in a 4G memcg on a EPYC 7K62 with:

  fio -name=mglru --numjobs=16 --directory=/mnt --size=960m \
    --buffered=1 --ioengine=io_uring --iodepth=128 \
    --iodepth_batch_submit=32 --iodepth_batch_complete=32 \
    --rw=randread --random_distribution=zipf:0.5 --norandommap \
    --time_based --ramp_time=1m --runtime=5m --group_reporting

Before this series:
bw (  MiB/s): min= 7644, max= 9293, per=100.00%, avg=8777.77, stdev=16.59, samples=9568
iops        : min=1956954, max=2379053, avg=2247108.51, stdev=4247.22, samples=9568

After this series (+7.5%):
bw (  MiB/s): min= 8462, max= 9902, per=100.00%, avg=9444.77, stdev=16.43, samples=9568
iops        : min=2166433, max=2535135, avg=2417858.23, stdev=4205.15, samples=9568

However it's highly related to the actual timing and use case.

Besides, batch moving also has a good effect on LRU ordering.  Currently
when MGLRU ages, it walks the LRU backward, and the protected pages are
moved to the tail of newer gen one by one, which reverses the order of
pages in LRU.  Moving them in batches can help keep their order, only in a
small scope though due to the scan limit of MAX_LRU_BATCH pages.

I noticed a higher performance gain if there are a lot of pages getting
protected, but hard to reproduce, so instead I tested using a simpler
benchmark, memtier, also for a more generic result.  The main overhead
here is not aging but the result is also looking good:

Average result of 18 test runs:

Before:           44017.78 Ops/sec
After patch 1-3:  44890.50 Ops/sec (+1.8%)


This patch (of 3):

When lru_gen is aging, it will update mm counters page by page, which
causes a higher overhead if age happens frequently or there are a lot of
pages in one generation getting moved.  Optimize this by doing the counter
update in batch.

Although most __mod_*_state has its own caches the overhead is still
observable.

Tested in a 4G memcg on a EPYC 7K62 with:

  memcached -u nobody -m 16384 -s /tmp/memcached.socket \
    -a 0766 -t 16 -B binary &

  memtier_benchmark -S /tmp/memcached.socket \
    -P memcache_binary -n allkeys \
    --key-minimum=1 --key-maximum=16000000 -d 1024 \
    --ratio=1:0 --key-pattern=P:P -c 2 -t 16 --pipeline 8 -x 6

Average result of 18 test runs:

Before: 44017.78 Ops/sec
After:  44687.08 Ops/sec (+1.5%)

Link: https://lkml.kernel.org/r/20240111183321.19984-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20240111183321.19984-2-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   64 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 55 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-lru_gen-batch-update-counters-on-againg
+++ a/mm/vmscan.c
@@ -3117,9 +3117,47 @@ static int folio_update_gen(struct folio
 	return ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 }
 
+/*
+ * Update LRU gen in batch for each lru_gen LRU list. The batch is limited to
+ * each gen / type / zone level LRU. Batch is applied after finished or aborted
+ * scanning one LRU list.
+ */
+struct gen_update_batch {
+	int delta[MAX_NR_GENS];
+};
+
+static void lru_gen_update_batch(struct lruvec *lruvec, int type, int zone,
+				 struct gen_update_batch *batch)
+{
+	int gen;
+	int promoted = 0;
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	enum lru_list lru = type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON;
+
+	for (gen = 0; gen < MAX_NR_GENS; gen++) {
+		int delta = batch->delta[gen];
+
+		if (!delta)
+			continue;
+
+		WRITE_ONCE(lrugen->nr_pages[gen][type][zone],
+			   lrugen->nr_pages[gen][type][zone] + delta);
+
+		if (lru_gen_is_active(lruvec, gen))
+			promoted += delta;
+	}
+
+	if (promoted) {
+		__update_lru_size(lruvec, lru, zone, -promoted);
+		__update_lru_size(lruvec, lru + LRU_ACTIVE, zone, promoted);
+	}
+}
+
 /* protect pages accessed multiple times through file descriptors */
-static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio,
+			 bool reclaiming, struct gen_update_batch *batch)
 {
+	int delta = folio_nr_pages(folio);
 	int type = folio_is_file_lru(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
@@ -3142,7 +3180,8 @@ static int folio_inc_gen(struct lruvec *
 			new_flags |= BIT(PG_reclaim);
 	} while (!try_cmpxchg(&folio->flags, &old_flags, new_flags));
 
-	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
+	batch->delta[old_gen] -= delta;
+	batch->delta[new_gen] += delta;
 
 	return new_gen;
 }
@@ -3676,6 +3715,7 @@ static bool inc_min_seq(struct lruvec *l
 {
 	int zone;
 	int remaining = MAX_LRU_BATCH;
+	struct gen_update_batch batch = { };
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
 
@@ -3694,12 +3734,15 @@ static bool inc_min_seq(struct lruvec *l
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
-			new_gen = folio_inc_gen(lruvec, folio, false);
+			new_gen = folio_inc_gen(lruvec, folio, false, &batch);
 			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 
-			if (!--remaining)
+			if (!--remaining) {
+				lru_gen_update_batch(lruvec, type, zone, &batch);
 				return false;
+			}
 		}
+		lru_gen_update_batch(lruvec, type, zone, &batch);
 	}
 done:
 	reset_ctrl_pos(lruvec, type, true);
@@ -4219,7 +4262,7 @@ void lru_gen_soft_reclaim(struct mem_cgr
  ******************************************************************************/
 
 static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
-		       int tier_idx)
+		       int tier_idx, struct gen_update_batch *batch)
 {
 	bool success;
 	int gen = folio_lru_gen(folio);
@@ -4261,7 +4304,7 @@ static bool sort_folio(struct lruvec *lr
 	if (tier > tier_idx || refs == BIT(LRU_REFS_WIDTH)) {
 		int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 
-		gen = folio_inc_gen(lruvec, folio, false);
+		gen = folio_inc_gen(lruvec, folio, false, batch);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 
 		WRITE_ONCE(lrugen->protected[hist][type][tier - 1],
@@ -4271,7 +4314,7 @@ static bool sort_folio(struct lruvec *lr
 
 	/* ineligible */
 	if (zone > sc->reclaim_idx || skip_cma(folio, sc)) {
-		gen = folio_inc_gen(lruvec, folio, false);
+		gen = folio_inc_gen(lruvec, folio, false, batch);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}
@@ -4279,7 +4322,7 @@ static bool sort_folio(struct lruvec *lr
 	/* waiting for writeback */
 	if (folio_test_locked(folio) || folio_test_writeback(folio) ||
 	    (type == LRU_GEN_FILE && folio_test_dirty(folio))) {
-		gen = folio_inc_gen(lruvec, folio, true);
+		gen = folio_inc_gen(lruvec, folio, true, batch);
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}
@@ -4345,6 +4388,7 @@ static int scan_folios(struct lruvec *lr
 	for (i = MAX_NR_ZONES; i > 0; i--) {
 		LIST_HEAD(moved);
 		int skipped_zone = 0;
+		struct gen_update_batch batch = { };
 		int zone = (sc->reclaim_idx + i) % MAX_NR_ZONES;
 		struct list_head *head = &lrugen->folios[gen][type][zone];
 
@@ -4359,7 +4403,7 @@ static int scan_folios(struct lruvec *lr
 
 			scanned += delta;
 
-			if (sort_folio(lruvec, folio, sc, tier))
+			if (sort_folio(lruvec, folio, sc, tier, &batch))
 				sorted += delta;
 			else if (isolate_folio(lruvec, folio, sc)) {
 				list_add(&folio->lru, list);
@@ -4379,6 +4423,8 @@ static int scan_folios(struct lruvec *lr
 			skipped += skipped_zone;
 		}
 
+		lru_gen_update_batch(lruvec, type, zone, &batch);
+
 		if (!remaining || isolated >= MIN_LRU_BATCH)
 			break;
 	}
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-lru_gen-batch-update-counters-on-againg.patch
mm-lru_gen-move-pages-in-bulk-when-aging.patch
mm-lru_gen-try-to-prefetch-next-page-when-canning-lru.patch

