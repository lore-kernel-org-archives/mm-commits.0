Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9813C4B84
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439210; cv=none; b=LRPmmuhIFSIZMrSTHdiFIO1lnEmx/Jto3+K2inGveEhSKyJnyynmftAt+cjYCEjoZG5025pDNpSp6l1aIN2SaBv9ho5HlxrfJnKOYJB3zzYdrEj0gbTftiYaMnNCyzLzcggVDN9p7Sk+VUzTiteZX/GnPE7PMebbAmNAf3QcAVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439210; c=relaxed/simple;
	bh=H5Vi75APs4QLiK4/WkcUkM2OCwTxeUDtJWN5byBFIXU=;
	h=Date:To:From:Subject:Message-Id; b=ApX33Z47/XRvXjzsjS3jRcHmRWTpSqG5wchXnmUKBl1Ok06syTVkV6lwja4WouVCZaHiATGL//ZN2Sp5bBcPfku9KMuzj9OzUfDYjWSxakr8+fTyeohVJhHGK9+YhX7ZrShxLh/oEnc7qDN53F37sVMADoor28Rk+2dsTwt7PW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=giDgErKJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="giDgErKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FC71F00893;
	Tue,  2 Jun 2026 22:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439209;
	bh=RFaVYGKYVw+FUGSmaxp9OGm/TfDu4j/AGCu4wY6VzmE=;
	h=Date:To:From:Subject;
	b=giDgErKJzDgPod97iVi7REghszsMWRu8kYbjnzTOKWV6EirgIzsISF6O3VzJ3v1qT
	 rqei77PNKnFU0U9ywIziDo+VHDYTrh3xNI1KVVrXgIrMOs0ovr4ynymsaRYO13uPdW
	 e/UVeh96K9ej4adgAnOimmXQL330M33gfKOqLN98=
Date: Tue, 02 Jun 2026 15:26:49 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,oliver.sang@intel.com,muchun.song@linux.dev,mhocko@kernel.org,joshua.hahnjy@gmail.com,harry@kernel.org,hannes@cmpxchg.org,alex@ghiti.fr,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-store-node_id-instead-of-pglist_data-pointer.patch removed from -mm tree
Message-Id: <20260602222649.64FC71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: store node_id instead of pglist_data pointer
has been removed from the -mm tree.  Its filename was
     memcg-store-node_id-instead-of-pglist_data-pointer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: store node_id instead of pglist_data pointer
Date: Mon, 25 May 2026 20:39:28 -0700

Patch series "memcg: shrink obj_stock_pcp and cache multiple objcgs", v3.

Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
per-node type") split a memcg's single obj_cgroup into one per NUMA node
so that reparenting LRU folios can take per-node lru locks.  As a side
effect, the per-CPU obj_stock_pcp -- which caches a single cached_objcg
pointer -- thrashes on workloads where threads of the same memcg run on
different NUMA nodes.  The kernel test robot reported a 67.7% regression
on stress-ng.switch.ops_per_sec from this pattern.

Commit d0211878ce06 ("memcg: cache obj_stock by memcg, not by objcg
pointer") landed as a temporary fix by treating sibling per-node objcgs as
equivalent for the cache lookup, intended to be reverted once per-node
kmem accounting is introduced.  This series takes a more general approach:
cache multiple objcgs per CPU using the multi-slot pattern memcg_stock_pcp
already uses, so the per-node objcg variants of one memcg can all coexist
in the stock without ever forcing a drain.  The temporary fix can then be
reverted.

To avoid increasing the per-CPU cache footprint, the first three patches
shrink the existing single-slot obj_stock_pcp fields.  The final patch
converts cached_objcg and nr_bytes into NR_OBJ_STOCK=5 slot arrays and
reorders the struct so the entire consume/refill/account hot path fits
within a single 64-byte cache line on non-debug 64-bit builds (verified
with pahole).


This patch (of 4):

The struct obj_stock_pcp stores a pointer to pglist_data for the slab
stats cached on the cpu.  On 64-bit machines, this costs 8 bytes.  The
pointer is not strictly required: NODE_DATA() can recover it from the node
id.  Replace cached_pgdat with int16_t node_id and use NUMA_NO_NODE as the
"no stats cached" sentinel.

At the moment all the archs limit MAX_NUMNODES to 1024 so int16_t is
plenty; a BUILD_BUG_ON() makes sure we notice if that ever changes.

Link: https://lore.kernel.org/20260526033931.1760588-1-shakeel.butt@linux.dev
Link: https://lore.kernel.org/20260526033931.1760588-2-shakeel.butt@linux.dev
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: kernel test robot <oliver.sang@intel.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~memcg-store-node_id-instead-of-pglist_data-pointer
+++ a/mm/memcontrol.c
@@ -2022,7 +2022,7 @@ struct obj_stock_pcp {
 	local_trylock_t lock;
 	unsigned int nr_bytes;
 	struct obj_cgroup *cached_objcg;
-	struct pglist_data *cached_pgdat;
+	int16_t node_id;
 	int nr_slab_reclaimable_b;
 	int nr_slab_unreclaimable_b;
 
@@ -2032,6 +2032,7 @@ struct obj_stock_pcp {
 
 static DEFINE_PER_CPU_ALIGNED(struct obj_stock_pcp, obj_stock) = {
 	.lock = INIT_LOCAL_TRYLOCK(lock),
+	.node_id = NUMA_NO_NODE,
 };
 
 static DEFINE_MUTEX(percpu_charge_mutex);
@@ -3162,6 +3163,13 @@ static void __account_obj_stock(struct o
 {
 	int *bytes;
 
+	/*
+	 * Though at the moment MAX_NUMNODES <= 1024 in all archs but let's make
+	 * sure it does not exceed S16_MAX otherwise we need to fix node_id type
+	 * in struct obj_stock_pcp.
+	 */
+	BUILD_BUG_ON(MAX_NUMNODES >= S16_MAX);
+
 	if (!stock || READ_ONCE(stock->cached_objcg) != objcg)
 		goto direct;
 
@@ -3169,9 +3177,11 @@ static void __account_obj_stock(struct o
 	 * Save vmstat data in stock and skip vmstat array update unless
 	 * accumulating over a page of vmstat data or when pgdat changes.
 	 */
-	if (stock->cached_pgdat != pgdat) {
+	if (stock->node_id == NUMA_NO_NODE) {
+		stock->node_id = pgdat->node_id;
+	} else if (stock->node_id != pgdat->node_id) {
 		/* Flush the existing cached vmstat data */
-		struct pglist_data *oldpg = stock->cached_pgdat;
+		struct pglist_data *oldpg = NODE_DATA(stock->node_id);
 
 		if (stock->nr_slab_reclaimable_b) {
 			mod_objcg_mlstate(objcg, oldpg, NR_SLAB_RECLAIMABLE_B,
@@ -3183,7 +3193,7 @@ static void __account_obj_stock(struct o
 					  stock->nr_slab_unreclaimable_b);
 			stock->nr_slab_unreclaimable_b = 0;
 		}
-		stock->cached_pgdat = pgdat;
+		stock->node_id = pgdat->node_id;
 	}
 
 	bytes = (idx == NR_SLAB_RECLAIMABLE_B) ? &stock->nr_slab_reclaimable_b
@@ -3279,19 +3289,21 @@ static void drain_obj_stock(struct obj_s
 	 * Flush the vmstat data in current stock
 	 */
 	if (stock->nr_slab_reclaimable_b || stock->nr_slab_unreclaimable_b) {
+		struct pglist_data *oldpg = NODE_DATA(stock->node_id);
+
 		if (stock->nr_slab_reclaimable_b) {
-			mod_objcg_mlstate(old, stock->cached_pgdat,
+			mod_objcg_mlstate(old, oldpg,
 					  NR_SLAB_RECLAIMABLE_B,
 					  stock->nr_slab_reclaimable_b);
 			stock->nr_slab_reclaimable_b = 0;
 		}
 		if (stock->nr_slab_unreclaimable_b) {
-			mod_objcg_mlstate(old, stock->cached_pgdat,
+			mod_objcg_mlstate(old, oldpg,
 					  NR_SLAB_UNRECLAIMABLE_B,
 					  stock->nr_slab_unreclaimable_b);
 			stock->nr_slab_unreclaimable_b = 0;
 		}
-		stock->cached_pgdat = NULL;
+		stock->node_id = NUMA_NO_NODE;
 	}
 
 	WRITE_ONCE(stock->cached_objcg, NULL);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-list_lru-drain-before-clearing-xarray-entry-on-reparent.patch

