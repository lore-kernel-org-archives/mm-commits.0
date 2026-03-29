Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B97A1C5F1B
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744780; cv=none; b=hVlpotItXLTf5u0mdxcewQ5Be89j7zuAV2kZup5PCJH9M5xvXJPHDTnlai5CRFYy+9evE3LbaQlraK17LzSQDVcKhOaAX7px4nwZ7yTOkZeK9KBc4QTfbzvLOd4YMAWKuD8FTBPW1jkhEv4szw99fHWrMRFETKieKkQKnxEzCJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744780; c=relaxed/simple;
	bh=oxhcgwYK4WueI/BdybLHQhehPE8e6JWl4m2KelKWyB8=;
	h=Date:To:From:Subject:Message-Id; b=AMnykCZV44qlVknY0OhVaQf6R2JTEtMDxprP3A2O01XaXp9GwtaKP2mEnhkh2Bbx5xQnl+ClocqNKWc9Ga3z4dAEzF5GEppHFAfADsginpJmeK6UBMFo3/39FhM/RTLEwzPl5KFky4UQOoeK7MezlmPLCdDBxKzkAjDMRaWuYnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CCodEuwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CCodEuwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78F9C4CEF7;
	Sun, 29 Mar 2026 00:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744780;
	bh=oxhcgwYK4WueI/BdybLHQhehPE8e6JWl4m2KelKWyB8=;
	h=Date:To:From:Subject:From;
	b=CCodEuwdukCg0whwH2147EkWtjtoM4GpqqGYiJF9VdYsuCqMskaqeBwpqsF6/yQ4l
	 hiYnCWi0J/3swPPILBnmVi5NigA/nLUl5Dw64oHllV6G3PyS5ZzGBESYav6L1VveI6
	 B7ylcpPx/pljuGmZEOn/C8AKcAEfGNeNhC3WIvlE=
Date: Sat, 28 Mar 2026 17:39:39 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hao.li@linux.dev,hannes@cmpxchg.org,jweiner@meta.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-factor-out-trylock_stock-and-unlock_stock.patch removed from -mm tree
Message-Id: <20260329003939.E78F9C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: factor out trylock_stock() and unlock_stock()
has been removed from the -mm tree.  Its filename was
     mm-memcg-factor-out-trylock_stock-and-unlock_stock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <jweiner@meta.com>
Subject: mm: memcg: factor out trylock_stock() and unlock_stock()
Date: Mon, 2 Mar 2026 14:50:14 -0500

Patch series "memcg: obj stock and slab stat caching cleanups".

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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-factor-out-trylock_stock-and-unlock_stock
+++ a/mm/memcontrol.c
@@ -2950,6 +2950,19 @@ void __memcg_kmem_uncharge_page(struct p
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
@@ -3005,10 +3018,10 @@ static bool consume_obj_stock(struct obj
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
@@ -3017,7 +3030,7 @@ static bool consume_obj_stock(struct obj
 			__account_obj_stock(objcg, stock, nr_bytes, pgdat, idx);
 	}
 
-	local_unlock(&obj_stock.lock);
+	unlock_stock(stock);
 
 	return ret;
 }
@@ -3108,7 +3121,8 @@ static void refill_obj_stock(struct obj_
 	struct obj_stock_pcp *stock;
 	unsigned int nr_pages = 0;
 
-	if (!local_trylock(&obj_stock.lock)) {
+	stock = trylock_stock();
+	if (!stock) {
 		if (pgdat)
 			mod_objcg_mlstate(objcg, pgdat, idx, nr_acct);
 		nr_pages = nr_bytes >> PAGE_SHIFT;
@@ -3117,7 +3131,6 @@ static void refill_obj_stock(struct obj_
 		goto out;
 	}
 
-	stock = this_cpu_ptr(&obj_stock);
 	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
@@ -3137,7 +3150,7 @@ static void refill_obj_stock(struct obj_
 		stock->nr_bytes &= (PAGE_SIZE - 1);
 	}
 
-	local_unlock(&obj_stock.lock);
+	unlock_stock(stock);
 out:
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
_

Patches currently in -mm which might be from jweiner@meta.com are


