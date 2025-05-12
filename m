Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3EE166F0C
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011020; cv=none; b=Tsnx5svTUUAvaoMbeocn8+P8nr+cNSyr2oRHxjOxX0PAEegtnIJ6RxB7anW0e1X8wUUyXnQHi68quPfWQhh53fFBQr3gRWkHZyRWjD0cDzlBvNkovf8ok5eLxksCi43POiooJuZw0jwHtyGD/xEbsHPBLkP+Mstxo0yQWe4N82I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011020; c=relaxed/simple;
	bh=PK0MVMKWOH652A6EjCy4RvdTa7Byf1RIjJ8b5gIrN0w=;
	h=Date:To:From:Subject:Message-Id; b=ZnmEYE7+lgg+5+XTfHrgXtRtS7fi8mFL/e4e/ta4hVr0yBTPCH9f3DxZt2TXT18gVJyhMmaVfnXi52jwW5nYJBhzEouVIamB2HfYiwzsI07Li0Xsiv7utE7oJ/SqDT8L1xapOYeDmgkVpnQZ5IUnW7j2+PDXJFDokxyuXlAO4gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tjVDBHUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tjVDBHUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B27C4CEE4;
	Mon, 12 May 2025 00:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011020;
	bh=PK0MVMKWOH652A6EjCy4RvdTa7Byf1RIjJ8b5gIrN0w=;
	h=Date:To:From:Subject:From;
	b=tjVDBHUYXK6dkNuaBxzYzBmPcn9GfJYjarP7X7wXh9CQgPKAmiLk+MDXif+3/SjGA
	 YaZeMNqoBIKSaexMB9uladGcjrE7++f91cXcDX2SQkMT7LPgP0yPypT0jd0H+O8vDL
	 7l93rIpFLRWtImGYoTS25nKHmrWoQ8MzdTUZ6l90=
Date: Sun, 11 May 2025 17:50:19 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-decouple-drain_obj_stock-from-local-stock.patch removed from -mm tree
Message-Id: <20250512005019.F2B27C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: decouple drain_obj_stock from local stock
has been removed from the -mm tree.  Its filename was
     memcg-decouple-drain_obj_stock-from-local-stock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: decouple drain_obj_stock from local stock
Date: Thu, 3 Apr 2025 18:39:06 -0700

Currently drain_obj_stock() can potentially call __refill_stock which
accesses local cpu stock and thus requires memcg stock's local_lock. 
However if we look at the code paths leading to drain_obj_stock(), there
is never a good reason to refill the memcg stock at all from it.

At the moment, drain_obj_stock can be called from reclaim, hotplug cpu
teardown, mod_objcg_state() and refill_obj_stock().  For reclaim and
hotplug there is no need to refill.  For the other two paths, most
probably the newly switched objcg would be used in near future and thus no
need to refill stock with the older objcg.

In addition, __refill_stock() from drain_obj_stock() happens on rare
cases, so performance is not really an issue.  Let's just uncharge
directly instead of refill which will also decouple drain_obj_stock from
local cpu stock and local_lock requirements.

Link: https://lkml.kernel.org/r/20250404013913.1663035-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-decouple-drain_obj_stock-from-local-stock
+++ a/mm/memcontrol.c
@@ -2876,7 +2876,12 @@ static struct obj_cgroup *drain_obj_stoc
 
 			mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
 			memcg1_account_kmem(memcg, -nr_pages);
-			__refill_stock(memcg, nr_pages);
+			if (!mem_cgroup_is_root(memcg)) {
+				page_counter_uncharge(&memcg->memory, nr_pages);
+				if (do_memsw_account())
+					page_counter_uncharge(&memcg->memsw,
+							      nr_pages);
+			}
 
 			css_put(&memcg->css);
 		}
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-introduce-non-blocking-limit-setting-option.patch
memcg-introduce-non-blocking-limit-setting-option-v3.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

