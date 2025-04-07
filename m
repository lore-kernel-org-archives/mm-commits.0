Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D816FBF
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 00:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743987017; cv=none; b=Cy7y/WuP6dvb/KWMQwGkreE6fa0dElJW7ogcqtkfw3W5UPBHok/r0nYgEnfm1EnRocWH3Py58DwfSjOmDys5jQ3P9MQSip8nu5BMZ0rVOpR7tjFZborM2wdTUAaaNTf59dxkn7nWtmyWwbXueO8gTZDLkqweFoTcjHRWzABtYZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743987017; c=relaxed/simple;
	bh=erwaHFFoejc88H+YUlNUDB/vCwtPrScBJ3oy4wIkiu0=;
	h=Date:To:From:Subject:Message-Id; b=BqFsDBcr6cGQ5X4BuKd7sIPK10YI7GiYG0Gf3c+yDTaHGi2aKlGQJZtxLRp6rweIzUR6bIrpGl7yaRoKa/L5e+0OGJ1ydT/8l/EfM2EeSNgn3pMUX0uEvbom+lfOV/TTV+uJ7siSth632rTYdFOvvta+JI8pDkKfAaqR8e/0w3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2fcQMjRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2fcQMjRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69378C4CEE3;
	Mon,  7 Apr 2025 00:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743987015;
	bh=erwaHFFoejc88H+YUlNUDB/vCwtPrScBJ3oy4wIkiu0=;
	h=Date:To:From:Subject:From;
	b=2fcQMjRf2c9ODHcxGd6+hq20u0q6w/+olHM4LQ2rHgXa0/B/H5PG4eEStB+I1JwIC
	 SKJ65SXmt4DkUmU3nEelTrepKxGvop+mLqs5daPha+4MXi+Y4qkq3je8xP1L3nG+Gg
	 Cerj6/Bt8TAqD/E5g9I0ld+bE1M2Ol2qKmZzUW/8=
Date: Sun, 06 Apr 2025 17:50:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-introduce-memcg_uncharge.patch added to mm-new branch
Message-Id: <20250407005015.69378C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: introduce memcg_uncharge
has been added to the -mm mm-new branch.  Its filename is
     memcg-introduce-memcg_uncharge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-introduce-memcg_uncharge.patch

This patch will later appear in the mm-new branch at
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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: introduce memcg_uncharge
Date: Thu, 3 Apr 2025 18:39:07 -0700

At multiple places in memcontrol.c, the memory and memsw page counters are
being uncharged.  This is error-prone.  Let's move the functionality to a
newly introduced memcg_uncharge and call it from all those places.

Link: https://lkml.kernel.org/r/20250404013913.1663035-4-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

--- a/mm/memcontrol.c~memcg-introduce-memcg_uncharge
+++ a/mm/memcontrol.c
@@ -1822,6 +1822,13 @@ static bool consume_stock(struct mem_cgr
 	return ret;
 }
 
+static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	page_counter_uncharge(&memcg->memory, nr_pages);
+	if (do_memsw_account())
+		page_counter_uncharge(&memcg->memsw, nr_pages);
+}
+
 /*
  * Returns stocks cached in percpu and reset cached information.
  */
@@ -1834,10 +1841,7 @@ static void drain_stock(struct memcg_sto
 		return;
 
 	if (stock_pages) {
-		page_counter_uncharge(&old->memory, stock_pages);
-		if (do_memsw_account())
-			page_counter_uncharge(&old->memsw, stock_pages);
-
+		memcg_uncharge(old, stock_pages);
 		WRITE_ONCE(stock->nr_pages, 0);
 	}
 
@@ -1900,9 +1904,7 @@ static void refill_stock(struct mem_cgro
 		 * In case of unlikely failure to lock percpu stock_lock
 		 * uncharge memcg directly.
 		 */
-		page_counter_uncharge(&memcg->memory, nr_pages);
-		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, nr_pages);
+		memcg_uncharge(memcg, nr_pages);
 		return;
 	}
 	__refill_stock(memcg, nr_pages);
@@ -2876,12 +2878,8 @@ static struct obj_cgroup *drain_obj_stoc
 
 			mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
 			memcg1_account_kmem(memcg, -nr_pages);
-			if (!mem_cgroup_is_root(memcg)) {
-				page_counter_uncharge(&memcg->memory, nr_pages);
-				if (do_memsw_account())
-					page_counter_uncharge(&memcg->memsw,
-							      nr_pages);
-			}
+			if (!mem_cgroup_is_root(memcg))
+				memcg_uncharge(memcg, nr_pages);
 
 			css_put(&memcg->css);
 		}
@@ -4702,9 +4700,7 @@ static inline void uncharge_gather_clear
 static void uncharge_batch(const struct uncharge_gather *ug)
 {
 	if (ug->nr_memory) {
-		page_counter_uncharge(&ug->memcg->memory, ug->nr_memory);
-		if (do_memsw_account())
-			page_counter_uncharge(&ug->memcg->memsw, ug->nr_memory);
+		memcg_uncharge(ug->memcg, ug->nr_memory);
 		if (ug->nr_kmem) {
 			mod_memcg_state(ug->memcg, MEMCG_KMEM, -ug->nr_kmem);
 			memcg1_account_kmem(ug->memcg, -ug->nr_kmem);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-vmalloc-simplify-memcg_vmalloc-updates.patch
memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch
memcg-remove-root-memcg-check-from-refill_stock.patch
memcg-decouple-drain_obj_stock-from-local-stock.patch
memcg-introduce-memcg_uncharge.patch
memcg-manually-inline-__refill_stock.patch
memcg-no-refilling-stock-from-obj_cgroup_release.patch
memcg-do-obj_cgroup_put-inside-drain_obj_stock.patch
memcg-use-__mod_memcg_state-in-drain_obj_stock.patch
memcg-manually-inline-replace_stock_objcg.patch

