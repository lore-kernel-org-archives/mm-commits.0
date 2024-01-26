Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0335CBD
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235366; cv=none; b=dGySO7J91QBiWSB+9Iw8zyEvoldZG8ZoeLXuMDIUDDOUKprRotlM0Ue5BULSbINd0GB8Qdxmdo0l/jydTo8q9WaQKVfcOh9zZdCSJr0T0ozMzkQs/Ux/S+3UpzmL40uH6lj4xv4tq3IHFvlfnEA+ut5C3oPsXTYkdGgJTNm7dZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235366; c=relaxed/simple;
	bh=vQ1hhb5OAzHbD1KFVsVOQeuLEj/8Pt+pzrg+U0c4x+8=;
	h=Date:To:From:Subject:Message-Id; b=E6J8U+IIsgNOW7HZY9wdQKd5lUp+WlV0i5bAo15E68U7rqZYP+UMlhvr3zv/QkMniIBqnsZ87CUPt8Wqcj+TK+gXl/WFhcB98Dv1o9zTI+y9YV5vnodR8GH4cELJMxTziXXKkwX9WVZ+UWP2g9CG9+WsdCDO+JgqSEYEwzbP6eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VMlK7GU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VMlK7GU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0010C433C7;
	Fri, 26 Jan 2024 02:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235366;
	bh=vQ1hhb5OAzHbD1KFVsVOQeuLEj/8Pt+pzrg+U0c4x+8=;
	h=Date:To:From:Subject:From;
	b=VMlK7GU8KGRtxKKBEYPKKP+JnSXvz3BQWslOaPZkzfaOJX1u7/ouDCThaa+E63wyO
	 SY7cjaM8NVwPA5hMtGQ+0nlEh/QkH92tArGESNzOuRnsfQbAp3PQDkLfBJHpBaMJ78
	 ycKVcz7VvrGnncWOAJjDsyK5jmyxxmc7WAcLLbDs=
Date: Thu, 25 Jan 2024 18:16:02 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,chrisl@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-lru_gen-move-pages-in-bulk-when-aging.patch removed from -mm tree
Message-Id: <20240126021605.A0010C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, lru_gen: move pages in bulk when aging
has been removed from the -mm tree.  Its filename was
     mm-lru_gen-move-pages-in-bulk-when-aging.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, lru_gen: move pages in bulk when aging
Date: Fri, 12 Jan 2024 02:33:20 +0800

Another overhead of aging is page moving.  Actually, in most cases, pages
are being moved to the same gen after folio_inc_gen is called, especially
the protected pages.  So it's better to move them in bulk.

This also has a good effect on LRU order.  Currently when MGLRU ages, it
walks the LRU backwards, and the protected pages are moved to the tail of
newer gen one by one, which actually reverses the order of pages in LRU. 
Moving them in batches can help keep their order, only in a small scope
though, due to the scan limit of MAX_LRU_BATCH pages.

After this commit, we can see a slight performance gain (with
CONFIG_DEBUG_LIST=n):

Test 1: of memcached in a 4G memcg on a EPYC 7K62 with:

  memcached -u nobody -m 16384 -s /tmp/memcached.socket \
    -a 0766 -t 16 -B binary &

  memtier_benchmark -S /tmp/memcached.socket \
    -P memcache_binary -n allkeys \
    --key-minimum=1 --key-maximum=16000000 -d 1024 \
    --ratio=1:0 --key-pattern=P:P -c 2 -t 16 --pipeline 8 -x 6

Average result of 18 test runs:

Before:           44017.78 Ops/sec
After patch 1-2:  44810.01 Ops/sec (+1.8%)

Test 2: MySQL in 6G memcg with:

  echo 'set GLOBAL innodb_buffer_pool_size=16106127360;' | \
    mysql -u USER -h localhost --password=PASS

  sysbench /usr/share/sysbench/oltp_read_only.lua \
    --mysql-user=USER --mysql-password=PASS --mysql-db=sb\
    --tables=48 --table-size=2000000 --threads=16 --time=1800\
    --report-interval=5 run

QPS of 6 test runs:

Before:
134126.83
134352.13
134045.19
133985.12
134787.47
134554.43

After patch 1-2 (+0.4%):
134913.38
134695.35
134891.31
134662.66
135090.32
134901.14

Only about 10% CPU time is spent in kernel space for MySQL test so the
improvement is very trivial.

There could be a higher performance gain when pages are getting
protected aggressively.

Link: https://lkml.kernel.org/r/20240111183321.19984-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   84 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 71 insertions(+), 13 deletions(-)

--- a/mm/vmscan.c~mm-lru_gen-move-pages-in-bulk-when-aging
+++ a/mm/vmscan.c
@@ -3120,9 +3120,46 @@ static int folio_update_gen(struct folio
  */
 struct gen_update_batch {
 	int delta[MAX_NR_GENS];
+	struct folio *head, *tail;
 };
 
-static void lru_gen_update_batch(struct lruvec *lruvec, int type, int zone,
+static void inline lru_gen_inc_bulk_finish(struct lru_gen_folio *lrugen,
+					   int bulk_gen, bool type, int zone,
+					   struct gen_update_batch *batch)
+{
+	if (!batch->head)
+		return;
+
+	list_bulk_move_tail(&lrugen->folios[bulk_gen][type][zone],
+			    &batch->head->lru,
+			    &batch->tail->lru);
+
+	batch->head = NULL;
+}
+
+/*
+ * When aging, protected pages will go to the tail of the same higher
+ * gen, so the can be moved in batches. Besides reduced overhead, this
+ * also avoids changing their LRU order in a small scope.
+ */
+static inline void lru_gen_try_inc_bulk(struct lru_gen_folio *lrugen, struct folio *folio,
+					int bulk_gen, int gen, bool type, int zone,
+					struct gen_update_batch *batch)
+{
+	/*
+	 * If folio not moving to the bulk_gen, it's raced with promotion
+	 * so it need to go to the head of another LRU.
+	 */
+	if (bulk_gen != gen)
+		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
+
+	if (!batch->head)
+		batch->tail = folio;
+
+	batch->head = folio;
+}
+
+static void lru_gen_update_batch(struct lruvec *lruvec, int bulk_gen, int type, int zone,
 				 struct gen_update_batch *batch)
 {
 	int gen;
@@ -3130,6 +3167,8 @@ static void lru_gen_update_batch(struct
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	enum lru_list lru = type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON;
 
+	lru_gen_inc_bulk_finish(lrugen, bulk_gen, type, zone, batch);
+
 	for (gen = 0; gen < MAX_NR_GENS; gen++) {
 		int delta = batch->delta[gen];
 
@@ -3714,6 +3753,7 @@ static bool inc_min_seq(struct lruvec *l
 	struct gen_update_batch batch = { };
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	int bulk_gen = (old_gen + 1) % MAX_NR_GENS;
 
 	if (type == LRU_GEN_ANON && !can_swap)
 		goto done;
@@ -3721,24 +3761,33 @@ static bool inc_min_seq(struct lruvec *l
 	/* prevent cold/hot inversion if force_scan is true */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
+		struct folio *prev = NULL;
 
-		while (!list_empty(head)) {
-			struct folio *folio = lru_to_folio(head);
+		if (!list_empty(head))
+			prev = lru_to_folio(head);
 
+		while (prev) {
+			struct folio *folio = prev;
 			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
+			if (unlikely(list_is_first(&folio->lru, head)))
+				prev = NULL;
+			else
+				prev = lru_to_folio(&folio->lru);
+
 			new_gen = folio_inc_gen(lruvec, folio, false, &batch);
-			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+			lru_gen_try_inc_bulk(lrugen, folio, bulk_gen, new_gen, type, zone, &batch);
 
 			if (!--remaining) {
-				lru_gen_update_batch(lruvec, type, zone, &batch);
+				lru_gen_update_batch(lruvec, bulk_gen, type, zone, &batch);
 				return false;
 			}
 		}
-		lru_gen_update_batch(lruvec, type, zone, &batch);
+
+		lru_gen_update_batch(lruvec, bulk_gen, type, zone, &batch);
 	}
 done:
 	reset_ctrl_pos(lruvec, type, true);
@@ -4258,7 +4307,7 @@ void lru_gen_soft_reclaim(struct mem_cgr
  ******************************************************************************/
 
 static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
-		       int tier_idx, struct gen_update_batch *batch)
+		       int tier_idx, int bulk_gen, struct gen_update_batch *batch)
 {
 	bool success;
 	int gen = folio_lru_gen(folio);
@@ -4301,7 +4350,7 @@ static bool sort_folio(struct lruvec *lr
 		int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 
 		gen = folio_inc_gen(lruvec, folio, false, batch);
-		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
+		lru_gen_try_inc_bulk(lrugen, folio, bulk_gen, gen, type, zone, batch);
 
 		WRITE_ONCE(lrugen->protected[hist][type][tier - 1],
 			   lrugen->protected[hist][type][tier - 1] + delta);
@@ -4311,7 +4360,7 @@ static bool sort_folio(struct lruvec *lr
 	/* ineligible */
 	if (zone > sc->reclaim_idx || skip_cma(folio, sc)) {
 		gen = folio_inc_gen(lruvec, folio, false, batch);
-		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
+		lru_gen_try_inc_bulk(lrugen, folio, bulk_gen, gen, type, zone, batch);
 		return true;
 	}
 
@@ -4385,11 +4434,16 @@ static int scan_folios(struct lruvec *lr
 		LIST_HEAD(moved);
 		int skipped_zone = 0;
 		struct gen_update_batch batch = { };
+		int bulk_gen = (gen + 1) % MAX_NR_GENS;
 		int zone = (sc->reclaim_idx + i) % MAX_NR_ZONES;
 		struct list_head *head = &lrugen->folios[gen][type][zone];
+		struct folio *prev = NULL;
+
+		if (!list_empty(head))
+			prev = lru_to_folio(head);
 
-		while (!list_empty(head)) {
-			struct folio *folio = lru_to_folio(head);
+		while (prev) {
+			struct folio *folio = prev;
 			int delta = folio_nr_pages(folio);
 
 			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
@@ -4398,8 +4452,12 @@ static int scan_folios(struct lruvec *lr
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
 			scanned += delta;
+			if (unlikely(list_is_first(&folio->lru, head)))
+				prev = NULL;
+			else
+				prev = lru_to_folio(&folio->lru);
 
-			if (sort_folio(lruvec, folio, sc, tier, &batch))
+			if (sort_folio(lruvec, folio, sc, tier, bulk_gen, &batch))
 				sorted += delta;
 			else if (isolate_folio(lruvec, folio, sc)) {
 				list_add(&folio->lru, list);
@@ -4419,7 +4477,7 @@ static int scan_folios(struct lruvec *lr
 			skipped += skipped_zone;
 		}
 
-		lru_gen_update_batch(lruvec, type, zone, &batch);
+		lru_gen_update_batch(lruvec, bulk_gen, type, zone, &batch);
 
 		if (!remaining || isolated >= MIN_LRU_BATCH)
 			break;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-lru_gen-try-to-prefetch-next-page-when-canning-lru.patch

