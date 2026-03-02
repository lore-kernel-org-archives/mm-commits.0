Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7442347D950
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 20:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772481923; cv=none; b=WzAAEfAEyEp0klI2nsOHtp/TPl82MJ3FJgiDuE0wd7SStyKctS5fjFvagZj7PA0fhoa0vQ2fURR3WdaOJHNe4xHoK9CiA9yPiA4HPUF00/iYbQmpbrqb1+6BGAJBWQssAn6FXf12EZQQ4IBQymaBwWpugao9qmhFu+di6RO73/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772481923; c=relaxed/simple;
	bh=IHVRfG+7kD6STLuhUGJ9XkdakB0JlHrtZevnxW6znMw=;
	h=Date:To:From:Subject:Message-Id; b=Rv3UPany6EDW6xvFObCh9BlX3Vdh1HnK5I1nYKMskbh8R+fqVqBP16UC+PG/V54guq9nqiBFt6yB7YmYXyVaYi+si5XYscGs1kBI/b2X/y3R9sBeR42hmbXpog0kp0kU0SpJAwMli7stlj68w6vLhGQedfDqRaiTFzog+jBQxVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lDLxO3hg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lDLxO3hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C95C19423;
	Mon,  2 Mar 2026 20:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772481923;
	bh=IHVRfG+7kD6STLuhUGJ9XkdakB0JlHrtZevnxW6znMw=;
	h=Date:To:From:Subject:From;
	b=lDLxO3hgxgLvLx3R+YhwQHBd+c8zhCO97daf0oL0lIglbBLF9XgD8HYcc/c9uJF78
	 liYuRmbiyRjyYHzqip+VROBsQUmgUfbrcCn09EZWxI4CLrOwmjGl4iyuT1jamsiR9g
	 y7aLM35EN3EZXPRPkD+9J/OSchI2hD4/Thx6+Hqc=
Date: Mon, 02 Mar 2026 12:05:22 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hao.li@linux.dev,hannes@cmpxchg.org,jweiner@meta.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-factor-out-trylock_stock-and-unlock_stock.patch added to mm-new branch
Message-Id: <20260302200522.E6C95C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: factor out trylock_stock() and unlock_stock()
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-factor-out-trylock_stock-and-unlock_stock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-factor-out-trylock_stock-and-unlock_stock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Johannes Weiner <jweiner@meta.com>
Subject: mm: memcg: factor out trylock_stock() and unlock_stock()
Date: Mon, 2 Mar 2026 14:50:14 -0500

Patch series ": memcg: obj stock and slab stat caching cleanups".

This is a follow-up to `[PATCH] memcg: fix slab accounting in
refill_obj_stock() trylock path`.  The way the slab stat cache and the
objcg charge cache interact appears a bit too fragile.  This series
factors those paths apart as much as practical.


This patch (of 5):

Consolidate the local lock acquisition and the local stock lookup.  This
allows subsequent patches to use !!stock as an easy way to disambiguate
the locked vs.  contended cases through the callstack.

Link: https://lkml.kernel.org/r/20260302195305.620713-1-hannes@cmpxchg.org
Link: https://lkml.kernel.org/r/20260302195305.620713-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hao Li <hao.li@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-factor-out-trylock_stock-and-unlock_stock
+++ a/mm/memcontrol.c
@@ -3208,6 +3208,19 @@ void __memcg_kmem_uncharge_page(struct p
 	obj_cgroup_put(objcg);
 }
 
+static struct obj_stock_pcp *trylock_stock(void)
+{
+	if (local_trylock(&obj_stock.lock))
+		return this_cpu_ptr(&obj_stock);
+
+	return NULL;
+}
+
+static void unlock_stock(struct obj_stock_pcp *stock)
+{
+	local_unlock(&obj_stock.lock);
+}
+
 static void __account_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
@@ -3263,10 +3276,10 @@ static bool consume_obj_stock(struct obj
 	struct obj_stock_pcp *stock;
 	bool ret = false;
 
-	if (!local_trylock(&obj_stock.lock))
+	stock = trylock_stock();
+	if (!stock)
 		return ret;
 
-	stock = this_cpu_ptr(&obj_stock);
 	if (objcg == READ_ONCE(stock->cached_objcg) && stock->nr_bytes >= nr_bytes) {
 		stock->nr_bytes -= nr_bytes;
 		ret = true;
@@ -3275,7 +3288,7 @@ static bool consume_obj_stock(struct obj
 			__account_obj_stock(objcg, stock, nr_bytes, pgdat, idx);
 	}
 
-	local_unlock(&obj_stock.lock);
+	unlock_stock(stock);
 
 	return ret;
 }
@@ -3366,7 +3379,8 @@ static void refill_obj_stock(struct obj_
 	struct obj_stock_pcp *stock;
 	unsigned int nr_pages = 0;
 
-	if (!local_trylock(&obj_stock.lock)) {
+	stock = trylock_stock();
+	if (!stock) {
 		if (pgdat)
 			mod_objcg_mlstate(objcg, pgdat, idx, nr_acct);
 		nr_pages = nr_bytes >> PAGE_SHIFT;
@@ -3375,7 +3389,6 @@ static void refill_obj_stock(struct obj_
 		goto out;
 	}
 
-	stock = this_cpu_ptr(&obj_stock);
 	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
@@ -3395,7 +3408,7 @@ static void refill_obj_stock(struct obj_
 		stock->nr_bytes &= (PAGE_SIZE - 1);
 	}
 
-	local_unlock(&obj_stock.lock);
+	unlock_stock(stock);
 out:
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
_

Patches currently in -mm which might be from jweiner@meta.com are

mm-memcg-factor-out-trylock_stock-and-unlock_stock.patch
mm-memcg-simplify-objcg-charge-size-and-stock-remainder-math.patch

