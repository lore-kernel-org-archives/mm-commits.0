Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4636C2FD1AA
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334216; cv=none; b=E5kOad7HqdwK/npMY+3NbPmLnw5NMY3t6NedlF+iCd/Jx3zBvuZyAfAfgWC7v0qHEfX78WcP9u+aTWk43tVJsFABFLSL+xI65ZQrCqpwfWvVSTIKkVaKOqmoQwdWNOekF7LyQiahySTT12xz6Xrdgz7PK0XDLppD7q34+i7p9rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334216; c=relaxed/simple;
	bh=XQxrzzAp4G0i2UFLrokrKcXFcThSGf/Bj/4MyIZ7G9A=;
	h=Date:To:From:Subject:Message-Id; b=mWsTuWlPHP3m4xMvO/6jjwit2umxK1eDCEiPAY5WkIIYwBJDe3p85FlgbWZNTCNPylN3BKOqKygyvuqlHsUy+auMVW2XfQpuIBxGbw+3PUMr3unfcatAcXp+SDarV+Kdd5yJN8a9csqbNTyIUQQwlC8Ol5Fxepfoc+wybtRU2d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gz/ziWNT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gz/ziWNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCB91F0089B;
	Wed,  7 Oct 2026 00:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334215;
	bh=yv7/O3AtZLOf9lisMtEMSyWmJ8JJzxalHX9OoqIV09w=;
	h=Date:To:From:Subject;
	b=gz/ziWNTjiqw3mNVAxcBgI0Ku5FaLGfCg0S+oSl0l9lyQHTya+gZ7bATH1A8q1m9x
	 C6ChS/bewbzkOuzfjpoOmyZM9+5++dnrb02XZm5+xqLG7TvJnnx4FxTjI/OJS/YvO3
	 0qVmFYidf4qweAeSS+zA9Rzrr6HChdl+6gpCMuPE=
Date: Tue, 06 Oct 2026 17:50:14 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,kuba@kernel.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,cxiong@meta.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it.patch removed from -mm tree
Message-Id: <20261007005015.1DCB91F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: trim the per-cpu charge stock instead of draining it
has been removed from the -mm tree.  Its filename was
     memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: trim the per-cpu charge stock instead of draining it
Date: Wed, 19 Aug 2026 18:20:10 -0700

Joy reported that an application generating a request/response traffic
pattern spends 44.6% to 57.0% of CPU in the memcg charge/uncharge path for
a range of message sizes, against 0.27% to 0.71% outside that range. 
Running from the root memcg, where socket memory accounting is skipped,
recovers the performance.

Tracing the charge path showed that the application generates a pattern
where the write syscall charges one page and the read syscall uncharges
two pages on the same CPU.  This hits a corner case in the memcg percpu
stock code that thrashes the stock continuously.

In the memcg percpu stock code, MEMCG_CHARGE_BATCH (64) is both the high
watermark and the emptying target, i.e.  on a request to charge one page
the kernel charges MEMCG_CHARGE_BATCH pages and caches (MEMCG_CHARGE_BATCH
- 1) of them in the percpu stock.  The following uncharge of 2 pages takes
the cached count to (MEMCG_CHARGE_BATCH + 1), and refill_stock() then
empties the cache completely.  With such a pattern the percpu stock
becomes completely ineffective.

Instead of a single boundary point for charges, use the technique the page
allocator uses for its own percpu caches, which keeps the watermark and
the emptying target apart: nr_pcp_free() frees between batch and high -
batch pages, leaving at least pcp->batch on the list.  Add a high
watermark MEMCG_STOCK_HIGH and, once the cached count goes over it, return
only the pages above MEMCG_STOCK_LOW.  The watermarks are
MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a full
batch.

For now, keep MEMCG_STOCK_HIGH same as MEMCG_CHARGE_BATCH and in future we
will reevaluate if it makes sense to increase it.

Link: https://lore.kernel.org/20260820012010.2016086-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Joy Chaoyue Xiong <cxiong@meta.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 mm/memcontrol.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it
+++ a/mm/memcontrol.c
@@ -2048,6 +2048,15 @@ void mem_cgroup_print_oom_group(struct m
  * nr_pages in a single cacheline. This may change in future.
  */
 #define NR_MEMCG_STOCK 7
+
+/*
+ * Watermarks for a charge stock slot, in the spirit of pcp->high and
+ * pcp->batch: MEMCG_STOCK_HIGH is the high watermark at which a slot is
+ * trimmed, and it is trimmed down to MEMCG_STOCK_LOW rather than emptied.
+ */
+#define MEMCG_STOCK_LOW		(MEMCG_CHARGE_BATCH / 2)
+#define MEMCG_STOCK_HIGH	(MEMCG_CHARGE_BATCH)
+
 #define FLUSHING_CACHED_CHARGE	0
 struct memcg_stock_pcp {
 	local_trylock_t lock;
@@ -2228,17 +2237,18 @@ static void refill_stock(struct mem_cgro
 {
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *cached;
-	uint8_t stock_pages;
+	unsigned int stock_pages;
 	bool success = false;
 	int empty_slot = -1;
 	int i;
 
 	/*
-	 * For now limit MEMCG_CHARGE_BATCH to 127 and less. In future if we
-	 * decide to increase it more than 127 then we will need more careful
-	 * handling of nr_pages[] in struct memcg_stock_pcp.
+	 * nr_pages[] is a uint8_t and a slot's count is capped at
+	 * MEMCG_STOCK_HIGH. Raising MEMCG_CHARGE_BATCH beyond 127 would need
+	 * more careful handling of nr_pages[] in struct memcg_stock_pcp.
 	 */
 	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
+	BUILD_BUG_ON(MEMCG_STOCK_HIGH > U8_MAX);
 
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
@@ -2259,9 +2269,12 @@ static void refill_stock(struct mem_cgro
 			empty_slot = i;
 		if (memcg == READ_ONCE(stock->cached[i])) {
 			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
+			if (stock_pages > MEMCG_STOCK_HIGH) {
+				memcg_uncharge(memcg,
+					       stock_pages - MEMCG_STOCK_LOW);
+				stock_pages = MEMCG_STOCK_LOW;
+			}
 			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (stock_pages > MEMCG_CHARGE_BATCH)
-				drain_stock(stock, i);
 			success = true;
 			break;
 		}
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-move-per-node-objcg-to-the-read-mostly-fields.patch
memcg-split-mem_cgroup_private_id-into-two-fields.patch
memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch
memcg-group-the-cold-fields-of-struct-mem_cgroup.patch
memcg-group-the-read-mostly-fields-of-struct-mem_cgroup.patch
memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch

