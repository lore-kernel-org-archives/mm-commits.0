Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D92B2367D3
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 01:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779067674; cv=none; b=BsQlpdavePvI+G42dGqSKsqs56FY5GMbmESOsJdkaafAWjYS++fjAE7xrhvucqIn9h/qCT0+RHs7tkACpBMUHbWGpa7t26OPkMupKvh9FYzVs0aYCoGVtW6Xj0Plgn0EnzdKCcjmg4dEtfysFR+ReKGFnrktCXfMshfIRLjljgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779067674; c=relaxed/simple;
	bh=5h0seCXr3FwkRlpV1LFzbrXIZhwz6OBeCCLkYGAnsZ8=;
	h=Date:To:From:Subject:Message-Id; b=IG5X3WGQs5Gf1WpZ8dYTma4seaBUt2EekwTOXsaq3D0oINByWmlFscnixkBGSW48wydpjXp1oFfYhsC3S/NVTKLvkvcGJtQRutYm6ZAYJmjEWmQLTKpQQOfaIMFoNOcCqcRtiQ+ln0RMMoPs4bXOM/Yw9t1ir7XM2/n70UEZBng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r+3JwlcI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r+3JwlcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBA2C2BCB0;
	Mon, 18 May 2026 01:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779067673;
	bh=5h0seCXr3FwkRlpV1LFzbrXIZhwz6OBeCCLkYGAnsZ8=;
	h=Date:To:From:Subject:From;
	b=r+3JwlcIU+fJ7K5wJf0tppn93/8GWy1T+svMJsUpRsFm4bFkT96JA3EH3cpqHuHyl
	 0ZF1znqqjQ4aHJ4fbogbZsgKw4fqWBcR9G3YGBgKFejzUFmS3lAWSZjlksdgyzL4kD
	 8pzDwRmo7IHdwGU1nWWLRxqJreGhuPXlWtWlad5Y=
Date: Sun, 17 May 2026 18:27:53 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,oliver.sang@intel.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-cache-obj_stock-by-memcg-not-by-objcg-pointer.patch added to mm-hotfixes-unstable branch
Message-Id: <20260518012753.ABBA2C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: cache obj_stock by memcg, not by objcg pointer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memcg-cache-obj_stock-by-memcg-not-by-objcg-pointer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-cache-obj_stock-by-memcg-not-by-objcg-pointer.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: memcg: cache obj_stock by memcg, not by objcg pointer
Date: Sun, 17 May 2026 12:43:08 -0700

Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
per-node type") split a memcg's single obj_cgroup into one per NUMA node,
but the per-CPU obj_stock_pcp still keys cached_objcg by pointer. 
Cross-NUMA workloads now see a drain on every refill and a miss on every
consume that targets a sibling per-node objcg of the same memcg, producing
the 67.7% stress-ng switch-mq regression reported by LKP.

stock->nr_bytes are fungible across per-node objcgs of one memcg.  Treat
the cache as keyed by memcg in __consume_obj_stock() and
__refill_obj_stock() so siblings share the reserve.  Compare via
READ_ONCE(objcg->memcg) directly: pointer-compare only, no deref, so the
rcu_read_lock contract on obj_cgroup_memcg() does not apply.

In the same-memcg refill path also fold the incoming objcg's
nr_charged_bytes into the stock; otherwise sub-page residue accumulates on
whichever sibling was cached at drain time and obj_cgroup_release()
silently drops it, leaking up to nr_node_ids * (PAGE_SIZE - 1) bytes per
memcg lifecycle from the page_counter.  This issue was reported by
Sashiko.

Update the now-stale invariant comment on __account_obj_stock().

Qi Zheng built a specialized reproducer [1] for the corner case and
confirmed the fix.

Link: https://lore.kernel.org/20260517194308.952655-1-shakeel.butt@linux.dev
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
Link: https://lore.kernel.org/19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev/ [1]
Debugged-by: Qi Zheng <qi.zheng@linux.dev>
Tested-by: Qi Zheng <qi.zheng@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~memcg-cache-obj_stock-by-memcg-not-by-objcg-pointer
+++ a/mm/memcontrol.c
@@ -3152,7 +3152,12 @@ static void unlock_stock(struct obj_stoc
 		local_unlock(&obj_stock.lock);
 }
 
-/* Call after __refill_obj_stock() to ensure stock->cached_objg == objcg */
+/*
+ * Call after __consume_obj_stock() / __refill_obj_stock(). The stock may be
+ * cached for a sibling per-node objcg of the same memcg; in that case the
+ * vmstat batching slot does not match objcg and we fall through to the
+ * direct path.
+ */
 static void __account_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
@@ -3210,7 +3215,11 @@ static bool __consume_obj_stock(struct o
 				struct obj_stock_pcp *stock,
 				unsigned int nr_bytes)
 {
-	if (objcg == READ_ONCE(stock->cached_objcg) &&
+	struct obj_cgroup *cached = READ_ONCE(stock->cached_objcg);
+
+	/* Sibling per-node objcgs share the reserve. */
+	if ((cached == objcg ||
+	     (cached && READ_ONCE(cached->memcg) == READ_ONCE(objcg->memcg))) &&
 	    stock->nr_bytes >= nr_bytes) {
 		stock->nr_bytes -= nr_bytes;
 		return true;
@@ -3318,6 +3327,7 @@ static void __refill_obj_stock(struct ob
 			       unsigned int nr_bytes,
 			       bool allow_uncharge)
 {
+	struct obj_cgroup *cached;
 	unsigned int nr_pages = 0;
 
 	if (!stock) {
@@ -3327,7 +3337,11 @@ static void __refill_obj_stock(struct ob
 		goto out;
 	}
 
-	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
+	cached = READ_ONCE(stock->cached_objcg);
+	if (cached == objcg)
+		goto add_bytes;
+	/* Direct READ_ONCE due to just pointer comparison. */
+	if (!cached || READ_ONCE(cached->memcg) != READ_ONCE(objcg->memcg)) {
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
@@ -3335,7 +3349,12 @@ static void __refill_obj_stock(struct ob
 		WRITE_ONCE(stock->cached_objcg, objcg);
 
 		allow_uncharge = true;	/* Allow uncharge when objcg changes */
+	} else if (atomic_read(&objcg->nr_charged_bytes)) {
+		/* Fold sibling's stranded ncb into stock; else release leaks it. */
+		stock->nr_bytes += atomic_xchg(&objcg->nr_charged_bytes, 0);
+		allow_uncharge = true;
 	}
+add_bytes:
 	stock->nr_bytes += nr_bytes;
 
 	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-cache-obj_stock-by-memcg-not-by-objcg-pointer.patch

