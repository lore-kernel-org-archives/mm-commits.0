Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0893BED0C
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439214; cv=none; b=NBJlGxHkCyya7nG5/TVs9l+mGhNKpSduVsYWUzN9+vXqcjsBOZZO1SvaH+DIBHIXHU1IPsCpKool7Zl2p9std+JzG5qYYEBvr06zGKh9pvogVd3hYSJallRHRr5oK6th6qk88F11Y2NTuFmoRx2dFNXRnLDNtkeP04PeUgEJryk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439214; c=relaxed/simple;
	bh=z2GRFIJDLUs0zqghpXpvcmtx+2RFU2K+SgawPMD8KNA=;
	h=Date:To:From:Subject:Message-Id; b=kdrVkRowVLJg2odm4MrXHNWYHQRYcou8mVbWKW+etcruZAZd+Rrl2IQVqBlEqkPAJZyeabYaumHDtE0MCi+bmgcKiIVYaScFfwfR55RbgYcvDLYMOT2NglXEMB3tBA/HQ25ItMBVPbrtNHH7xFcHsqke3XOdBRaIQWPXQKZu7O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ME4ny4mQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ME4ny4mQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1BC1F00893;
	Tue,  2 Jun 2026 22:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439212;
	bh=51Z6DTa185B7N84kqX6bV6Fc6Cenpbhjr2IYY27rubU=;
	h=Date:To:From:Subject;
	b=ME4ny4mQpKvaj8+dJ9Wvs5tocIdo0AzLDNDWk7DFMXducm440SorQTnd7TKATKA/9
	 thop0ZZ+r2B2gKjJgN+7zvH3s7VnenhsMwSFxSQXYL5jxwB07J5DE5GUUCNQPeHnDY
	 DaSQuSJpgBAuKu6R8sAsVZ3n1YlbOI1L5iyyVb5o=
Date: Tue, 02 Jun 2026 15:26:52 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,oliver.sang@intel.com,muchun.song@linux.dev,mhocko@kernel.org,joshua.hahnjy@gmail.com,harry@kernel.org,hannes@cmpxchg.org,alex@ghiti.fr,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-int16_t-for-cached-slab-stats.patch removed from -mm tree
Message-Id: <20260602222652.AF1BC1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: int16_t for cached slab stats
has been removed from the -mm tree.  Its filename was
     memcg-int16_t-for-cached-slab-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: int16_t for cached slab stats
Date: Mon, 25 May 2026 20:39:30 -0700

Currently struct obj_stock_pcp stores cached slab stats in 'int' which is
4 bytes per counter on 64-bit machines.  Switch them to int16_t to shrink
the cached metadata.

The existing PAGE_SIZE flush in __account_obj_stock() bounds *bytes at
PAGE_SIZE on 4KiB and 16KiB page archs, well within int16_t.  On 64KiB
pages PAGE_SIZE is well above S16_MAX so that flush never fires, and a
sufficiently long run of accumulations would overflow the cache.  Add an
explicit S16_MAX guard before each add: when the next add would push
abs(*bytes) past S16_MAX, fold the cached value into @nr and flush
directly via mod_objcg_mlstate() before the accumulation.

Link: https://lore.kernel.org/20260526033931.1760588-4-shakeel.butt@linux.dev
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/mm/memcontrol.c~memcg-int16_t-for-cached-slab-stats
+++ a/mm/memcontrol.c
@@ -2032,8 +2032,8 @@ struct obj_stock_pcp {
 	uint16_t nr_bytes;
 #endif
 	int16_t node_id;
-	int nr_slab_reclaimable_b;
-	int nr_slab_unreclaimable_b;
+	int16_t nr_slab_reclaimable_b;
+	int16_t nr_slab_unreclaimable_b;
 
 	struct work_struct work;
 	unsigned long flags;
@@ -3170,7 +3170,7 @@ static void __account_obj_stock(struct o
 				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
 {
-	int *bytes;
+	int16_t *bytes;
 
 	/*
 	 * Though at the moment MAX_NUMNODES <= 1024 in all archs but let's make
@@ -3207,21 +3207,20 @@ static void __account_obj_stock(struct o
 
 	bytes = (idx == NR_SLAB_RECLAIMABLE_B) ? &stock->nr_slab_reclaimable_b
 					       : &stock->nr_slab_unreclaimable_b;
+
 	/*
-	 * Even for large object >= PAGE_SIZE, the vmstat data will still be
-	 * cached locally at least once before pushing it out.
+	 * Fold @nr into the cached value and decide whether to keep it cached
+	 * or flush it directly. Cache the combined value when it fits in the
+	 * int16_t storage and either the cache was empty (so even a value
+	 * above PAGE_SIZE gets a chance to be canceled by a paired delta) or
+	 * the combined value is within the PAGE_SIZE flush threshold.
 	 */
-	if (!*bytes) {
+	nr += *bytes;
+	if (abs(nr) <= S16_MAX && (!*bytes || abs(nr) <= PAGE_SIZE)) {
 		*bytes = nr;
 		nr = 0;
 	} else {
-		*bytes += nr;
-		if (abs(*bytes) > PAGE_SIZE) {
-			nr = *bytes;
-			*bytes = 0;
-		} else {
-			nr = 0;
-		}
+		*bytes = 0;
 	}
 direct:
 	if (nr)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-list_lru-drain-before-clearing-xarray-entry-on-reparent.patch

