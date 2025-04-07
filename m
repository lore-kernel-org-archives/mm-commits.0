Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320763C0C
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 00:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743987028; cv=none; b=ADUUhx53Uf/qjUHprLwrDdMWa22AKhMPUPZ5kIBipf/pR0kPIbBneY0jqCItpxfP7CjYdlLrYphTXMqWNjynKzG5KSLgq9RfzD9F9Mzdqsdts3k7LBI+a0zpZJMkw82LCg9firJOeS2isAt9pW0OU8ciSDdzz6RFUJiN8EYnSy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743987028; c=relaxed/simple;
	bh=oN+h1EXjQBlYYvdi1TwY7vHcmthHG+pvjg4RgJC2R7I=;
	h=Date:To:From:Subject:Message-Id; b=CbPDUl7qh7skarBrhS/Oy03e8h6aBH7biDdWjl3rGYJ+urwmY3CVrPy2Wiju75iN0BuoW7k5Wz/M9zzqW+oRU1gOHhv0ZJ4JJ7Zy9B9lfkOnhast2zgdSYns95hEPNLoeZRDdItUUVHtSQpA2ZzrBwDgBlLl/GswbNZELhfRSIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OiLhYO5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OiLhYO5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AABCC4CEE3;
	Mon,  7 Apr 2025 00:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743987027;
	bh=oN+h1EXjQBlYYvdi1TwY7vHcmthHG+pvjg4RgJC2R7I=;
	h=Date:To:From:Subject:From;
	b=OiLhYO5JoWScOI95U4AsjBtgb0bkLgJTAww9muEEV9+ABp2lskD0jZ+hkgmNRKDNc
	 tZbXTdZybu5qxUd6JOqJat3+kQY1KOhkhWX+zVpEHqMG8jjjUlyYm0a6eD5lVxbTJn
	 wtUnPH16AzfdS1DHjBk7gq2jCLoSTizflMuoHo8M=
Date: Sun, 06 Apr 2025 17:50:27 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-manually-inline-replace_stock_objcg.patch added to mm-new branch
Message-Id: <20250407005027.9AABCC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: manually inline replace_stock_objcg
has been added to the -mm mm-new branch.  Its filename is
     memcg-manually-inline-replace_stock_objcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-manually-inline-replace_stock_objcg.patch

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
Subject: memcg: manually inline replace_stock_objcg
Date: Thu, 3 Apr 2025 18:39:13 -0700

The replace_stock_objcg() is being called by only refill_obj_stock, so
manually inline it.

Link: https://lkml.kernel.org/r/20250404013913.1663035-10-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/mm/memcontrol.c~memcg-manually-inline-replace_stock_objcg
+++ a/mm/memcontrol.c
@@ -2763,17 +2763,6 @@ void __memcg_kmem_uncharge_page(struct p
 	obj_cgroup_put(objcg);
 }
 
-/* Replace the stock objcg with objcg, return the old objcg */
-static void replace_stock_objcg(struct memcg_stock_pcp *stock,
-				struct obj_cgroup *objcg)
-{
-	drain_obj_stock(stock);
-	obj_cgroup_get(objcg);
-	stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
-			? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
-	WRITE_ONCE(stock->cached_objcg, objcg);
-}
-
 static void __account_obj_stock(struct obj_cgroup *objcg,
 				struct memcg_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
@@ -2934,7 +2923,12 @@ static void refill_obj_stock(struct obj_
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
-		replace_stock_objcg(stock, objcg);
+		drain_obj_stock(stock);
+		obj_cgroup_get(objcg);
+		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
+				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
+		WRITE_ONCE(stock->cached_objcg, objcg);
+
 		allow_uncharge = true;	/* Allow uncharge when objcg changes */
 	}
 	stock->nr_bytes += nr_bytes;
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

