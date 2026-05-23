Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991501E5B88
	for <mm-commits@vger.kernel.org>; Sat, 23 May 2026 02:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779503491; cv=none; b=h+AgEWUXa8YdOt67K+XwmpuhctCr8riY5k8pzpAPKa8AoIUDqmpXwLQCKWijd+xO9C0OY6qjr8+D8aH8C4EUoVQ6DJ0rBcGoPmx4/6XqzMTSxgbxAB3YPluIKkLQYxq31R+NGhfczEJH25JdQ2uh1r8fInxge278PN+i4gZB52U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779503491; c=relaxed/simple;
	bh=IE2ZdTZeaZJpjnu6L1fZR0s3IMNfIJ2mf9NIcZRApoo=;
	h=Date:To:From:Subject:Message-Id; b=nznOR6E9XwJhpkBYbkn+7pqCr0xzBVevyFBP/zBH4dVTjrLiHRYw4vmi6ZJc+JUSn3rXWviUs9N69+foCLR917ZUomiUmf34IKYKUPc+r9XhAjTWkfKjbn0PWvgwEFnDpUQ2ZvpVmPEe7nx5WNb10S4y+1EGD87++aPB/Xhds+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eAPbOTXB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eAPbOTXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B05E1F000E9;
	Sat, 23 May 2026 02:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779503490;
	bh=s0aAF8pqGkzkTEs40USPNe1X3PDvXcHEtJneP1NbdbY=;
	h=Date:To:From:Subject;
	b=eAPbOTXB/CbqxHKs8lhXtDUYF2DHZs2kXkr1TwuzQ9z/v9xIvMvCMgyV738BoYszM
	 0KRFGr0d50yTWtQV5FfzvFNK+x0LSXnjsLGJ6yA7hZu1MXc35riH5qbuvSlk7sM85v
	 JURTmn/nbM2CanKbOs+Zz7dl5/uKYSxbw5k8jwFo=
Date: Fri, 22 May 2026 19:31:29 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,oliver.sang@intel.com,muchun.song@linux.dev,mhocko@kernel.org,joshua.hahnjy@gmail.com,harry@kernel.org,hannes@cmpxchg.org,alex@ghiti.fr,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-store-node_id-instead-of-pglist_data-pointer.patch added to mm-new branch
Message-Id: <20260523023130.1B05E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: store node_id instead of pglist_data pointer
has been added to the -mm mm-new branch.  Its filename is
     memcg-store-node_id-instead-of-pglist_data-pointer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-store-node_id-instead-of-pglist_data-pointer.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: store node_id instead of pglist_data pointer
Date: Thu, 21 May 2026 18:19:05 -0700

Patch series "memcg: shrink obj_stock_pcp and cache multiple objcgs", v2.

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

Link: https://lore.kernel.org/20260522011908.1669332-1-shakeel.butt@linux.dev
Link: https://lore.kernel.org/20260522011908.1669332-2-shakeel.butt@linux.dev
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

memcg-use-round-robin-victim-selection-in-refill_stock.patch
memcg-store-node_id-instead-of-pglist_data-pointer.patch
memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch
memcg-int16_t-for-cached-slab-stats.patch
memcg-multi-objcg-charge-support.patch

