Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD9D3D6692
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 16:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777307504; cv=none; b=hm8wLpHtslwVDq5qs9OT3K9PmhhCbEnzwubp4Ir0Zzv/rKqhPO5okQ/hrv8/RGefnjWfTIVFwmYskLtbjEHFqIvNPLwATQFzdqKZ0TMjTis2r0ci95VmwW3ib+JiWty243vWO+cWCZ98wEpcRl5GglcqGLRkSZH0hSVMUldpu8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777307504; c=relaxed/simple;
	bh=wA5bHeAw/2+PHTHokAwNgAx7YBNs2WDnKJY8dEfDmo0=;
	h=Date:To:From:Subject:Message-Id; b=GYKTWVris8QyiMelolFi3Wp8kMLHlB+CVlnv26bpHhf9qdJpzttHUWMI5KIlyV8qizyzwVBys4DrtSA7R4Ma727LA7NFom4ezVVmgY/oEyLAzuTz+JHc9kqg/MGV69TzZCbjYkB2EZCnRTvy5HIwJE8uo43VyeHdpk0SkMeyR9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wprZYh9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wprZYh9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8B0C2BCB4;
	Mon, 27 Apr 2026 16:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777307503;
	bh=wA5bHeAw/2+PHTHokAwNgAx7YBNs2WDnKJY8dEfDmo0=;
	h=Date:To:From:Subject:From;
	b=wprZYh9RDdpRdcchc6JZ/TuULlWAq7rcwN4F6UUKHxfZT/D/qSKbUwQf0XubD7blN
	 KOGq20yHGVpSmCQJMGwuyyqATe6XfitgFKAwPRpVJAzbjD85v9OPZpKIqrUNNHHsRp
	 bCZtUsuiGk5OW6zeyWu9VJX0bOdCea8+d750gyMw=
Date: Mon, 27 Apr 2026 09:31:42 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcontrol-batch-memcg-charging-in-__memcg_slab_post_alloc_hook.patch removed from -mm tree
Message-Id: <20260427163143.7D8B0C2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcontrol: batch memcg charging in __memcg_slab_post_alloc_hook
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-batch-memcg-charging-in-__memcg_slab_post_alloc_hook.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: teawater <zhuhui@kylinos.cn>
Subject: mm/memcontrol: batch memcg charging in __memcg_slab_post_alloc_hook
Date: Fri, 20 Mar 2026 10:07:45 +0800

When kmem_cache_alloc_bulk() allocates multiple objects, the post-alloc
hook __memcg_slab_post_alloc_hook() previously charged memcg one object at
a time, even though consecutive objects may reside on slabs backed by the
same pgdat node.

Batch the memcg charging by scanning ahead from the current position to
find a contiguous run of objects whose slabs share the same pgdat, then
issue a single __obj_cgroup_charge() / __consume_obj_stock() call for the
entire run.  The per-object obj_ext assignment loop is preserved as-is
since it cannot be further collapsed.

This implements the TODO comment left in commit bc730030f956 ("memcg:
combine slab obj stock charging and accounting").

The existing error-recovery contract is unchanged: if size == 1 then
memcg_alloc_abort_single() will free the sole object, and for larger bulk
allocations kmem_cache_free_bulk() will uncharge any objects that were
already charged before the failure.

Benchmark using kmem_cache_alloc_bulk() with SLAB_ACCOUNT (iters=100000):

  bulk=32  before: 215 ns/object   after: 174 ns/object  (-19%)
  bulk=1   before: 344 ns/object   after: 335 ns/object  (  ~)

No measurable regression for bulk=1, as expected.

Link: https://lkml.kernel.org/r/20260320020745.833792-1-hui.zhu@linux.dev
Signed-off-by: teawater <zhuhui@kylinos.cn>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   77 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 58 insertions(+), 19 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-batch-memcg-charging-in-__memcg_slab_post_alloc_hook
+++ a/mm/memcontrol.c
@@ -3455,51 +3455,90 @@ bool __memcg_slab_post_alloc_hook(struct
 			return false;
 	}
 
-	for (i = 0; i < size; i++) {
+	for (i = 0; i < size; ) {
 		unsigned long obj_exts;
 		struct slabobj_ext *obj_ext;
 		struct obj_stock_pcp *stock;
+		struct pglist_data *pgdat;
+		int batch_bytes;
+		size_t run_len = 0;
+		size_t j;
+		size_t max_size;
+		bool skip_next = false;
 
 		slab = virt_to_slab(p[i]);
 
 		if (!slab_obj_exts(slab) &&
 		    alloc_slab_obj_exts(slab, s, flags, false)) {
+			i++;
 			continue;
 		}
 
+		pgdat = slab_pgdat(slab);
+		run_len = 1;
+
+		/*
+		 * The value of batch_bytes must not exceed
+		 * (INT_MAX - PAGE_SIZE) to prevent integer overflow in
+		 * the final accumulation performed by __account_obj_stock().
+		 */
+		max_size = min((size_t)((INT_MAX - PAGE_SIZE) / obj_size),
+			       size);
+
+		for (j = i + 1; j < max_size; j++) {
+			struct slab *slab_j = virt_to_slab(p[j]);
+
+			if (slab_pgdat(slab_j) != pgdat)
+				break;
+
+			if (!slab_obj_exts(slab_j) &&
+			    alloc_slab_obj_exts(slab_j, s, flags, false)) {
+				skip_next = true;
+				break;
+			}
+
+			run_len++;
+		}
+
 		/*
-		 * if we fail and size is 1, memcg_alloc_abort_single() will
+		 * If we fail and size is 1, memcg_alloc_abort_single() will
 		 * just free the object, which is ok as we have not assigned
-		 * objcg to its obj_ext yet
+		 * objcg to its obj_ext yet.
 		 *
-		 * for larger sizes, kmem_cache_free_bulk() will uncharge
-		 * any objects that were already charged and obj_ext assigned
-		 *
-		 * TODO: we could batch this until slab_pgdat(slab) changes
-		 * between iterations, with a more complicated undo
+		 * For larger sizes, kmem_cache_free_bulk() will uncharge
+		 * any objects that were already charged and obj_ext assigned.
 		 */
+		batch_bytes = obj_size * run_len;
 		stock = trylock_stock();
-		if (!stock || !__consume_obj_stock(objcg, stock, obj_size)) {
+		if (!stock || !__consume_obj_stock(objcg, stock, batch_bytes)) {
 			size_t remainder;
 
 			unlock_stock(stock);
-			if (__obj_cgroup_charge(objcg, flags, obj_size, &remainder))
+			if (__obj_cgroup_charge(objcg, flags, batch_bytes, &remainder))
 				return false;
 			stock = trylock_stock();
 			if (remainder)
 				__refill_obj_stock(objcg, stock, remainder, false);
 		}
-		__account_obj_stock(objcg, stock, obj_size,
-				    slab_pgdat(slab), cache_vmstat_idx(s));
+		__account_obj_stock(objcg, stock, batch_bytes,
+				    pgdat, cache_vmstat_idx(s));
 		unlock_stock(stock);
 
-		obj_exts = slab_obj_exts(slab);
-		get_slab_obj_exts(obj_exts);
-		off = obj_to_index(s, slab, p[i]);
-		obj_ext = slab_obj_ext(slab, obj_exts, off);
-		obj_cgroup_get(objcg);
-		obj_ext->objcg = objcg;
-		put_slab_obj_exts(obj_exts);
+		for (j = 0; j < run_len; j++) {
+			slab = virt_to_slab(p[i + j]);
+			obj_exts = slab_obj_exts(slab);
+			get_slab_obj_exts(obj_exts);
+			off = obj_to_index(s, slab, p[i + j]);
+			obj_ext = slab_obj_ext(slab, obj_exts, off);
+			obj_cgroup_get(objcg);
+			obj_ext->objcg = objcg;
+			put_slab_obj_exts(obj_exts);
+		}
+
+		if (skip_next)
+			i = i + run_len + 1;
+		else
+			i += run_len;
 	}
 
 	return true;
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are


