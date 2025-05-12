Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4141553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011028; cv=none; b=Xup3ITaYOL1/NjCy4llMf9JjY4dpFl8EcCnOdEG6D8gjXXCce0K/Z5iGLVWmmHLljGx/sUUe8fHJxMEzzAL9J6GAlDN7ji0RGnthbveu4r3umk+xL4KCfj7oNSBj0SOukQHfYEaCTTiJPsSWM/AY2xbTNumMhtty422Heu5ks3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011028; c=relaxed/simple;
	bh=14XKEHpHzpV8xjMVgPV+g5YPD/Axu0cMWhy8dXPqBLs=;
	h=Date:To:From:Subject:Message-Id; b=D1dG3lpbQWDcRWEItR36vfidhLTiPWlwGbXxuImcURJCqRQtIQa9bY+0WzZZhRZRV4kptVJJz9DScgN9lBvfG/gJwCxqVYIAkrNIBnwpH0CZLx/ne9sMef2RHY1cWh+ot55sHi8dZo2DibecA2kY81IfGVcIXkO/IyPNNFYDFWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wJPDLrGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wJPDLrGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62726C4CEE4;
	Mon, 12 May 2025 00:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011028;
	bh=14XKEHpHzpV8xjMVgPV+g5YPD/Axu0cMWhy8dXPqBLs=;
	h=Date:To:From:Subject:From;
	b=wJPDLrGn/p9o19X+neMg47lOoJXSw6MjGSJeR7+AeOK/375AgrTaWjbPhbpNwJbRM
	 vPE3lPbHaFtXDFsLIWZfPLdvrQeNReBKKXBQoG1uR6kjjD9+nQvwYVY84C6ZhUKgd+
	 DyYu+AiQFOytnREhWvAZDsNlFJ0OGY0LxddMGVwY=
Date: Sun, 11 May 2025 17:50:27 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-manually-inline-replace_stock_objcg.patch removed from -mm tree
Message-Id: <20250512005028.62726C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: manually inline replace_stock_objcg
has been removed from the -mm tree.  Its filename was
     memcg-manually-inline-replace_stock_objcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

memcg-introduce-non-blocking-limit-setting-option.patch
memcg-introduce-non-blocking-limit-setting-option-v3.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

