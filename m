Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832547;
	b=ntqpHAfKeaz1aCBqjpR6GEKgc8BcKPH8JdrOMM0jnq0bP3jfavOX04KKDWKkB0dXGD/y
	 3AiyaNyAuj6PXIEZBBiYjtm1BZIR3C+1+91k1p//h3r2iYPtlNzz0sxk75TUsHqmIrgtH
	 3bx/cJ3waL7X5IywNRDp7a0BWtl54CykVTqUKevQlXyF8lH6ge3CAuvWvk/PLLCdgQq7H
	 oCPe9EroBxifvhrHZTiqbicG35V7fJvK6CHziogIc5DVSD2/kXl3BOJ5PxA+FJ6l0USN/
	 aFBn2BvA+zXIGDoXxcUF8+TMQjPO+5z9xYPoVbEumykbixtxaO+b8vrLKqpX2n+QBLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832547;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=iUo6ymcKEQ9FU4/7EjDqrNF8XEJe3qAm0et8Q7TSmVM=;
	b=RKnMAd8JSPa2/kzfEjTZPp1QcC50N6ZOKrA10n7mcO9W+QMQofkE0OIQXV2J4DK9SyAG
	 kik9o2dnostJKAsy73Io9VIb0jjpJdExT0yY6JN8GOqqiiCIKhCwObDOwkbK3SJ14hv2l
	 Kp1mH7TT7S+pAxvfwZK4ysESj5/mNKFobrBolTKJZOHA+5OEjfYZpQUshcTmm2PRSwmHf
	 xigF9MXi48JeG1kyyT1kNg/yn/F5/QO97Ofr90yiG3n8nnQaRThhTxgh/hTZeZ15BQfd7
	 oM1hrKcQLt+CwnfNRawsdhuTnaJiu3wWulcAGX6rDl6KDL3uMIAYRmnzNHq7HgS6mBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ej5UqQVr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ACA606A31F
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ej5UqQVr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A641F01828;
	Sat, 24 Oct 2026 09:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832547;
	bh=iUo6ymcKEQ9FU4/7EjDqrNF8XEJe3qAm0et8Q7TSmVM=;
	h=Date:To:From:Subject;
	b=Ej5UqQVr+JRDKd7TPuySbIVXhMaTmghICkdG/aSVABnDLUOnPFOUNA0Nh5N044nmW
	 lmbdZ6Bc8sWvvuFAOnOpbLr0cldflfjyyTpMpWXTtVIWP2GVgalesnm9RRYBXRpfa6
	 4invfjQh9qY4WZODCJH9Pn3I4U6UjudVLHd6DNzM=
Date: Sat, 24 Oct 2026 02:02:26 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-publish-null-pointer-before-dropping-css-reference.patch removed from -mm tree
Message-Id: <20261024090227.41A641F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/memcontrol: publish null pointer before dropping css reference
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-publish-null-pointer-before-dropping-css-reference.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/memcontrol: publish null pointer before dropping css reference
Date: Tue, 20 Oct 2026 18:00:50 -0700

struct memcg_stock_pcp hold references to cgroups that it tracks to make
sure that the memcg never gets freed with unaccounted charges still
living in the stock. When the cached stock goes to 0 for a memcg, its
reference is dropped and the cached memcg pointer is set to NULL.

If that was the last reference, the css_put would free the associated
cgroup before publishing the NULL pointer, which can be racy on 
PREEMPT_RT. To summarize Shakeel Butt's analysis in [2],

CPU 1					CPU 2
local_trylock() takes a per-CPU
spinlock, which is an rcu read
lock along with migrate_disable

drain_stock
css_put drops the last reference
release work is queued

kworker runs css_release_work_fn()
call_rcu() starts grace period G
which waits for the refill task.

<preempt>
					drain_all_stock
					is_memcg_drain_needed()
					enters rcu_read_lock(), but
					 grace period G does not wait
					since it started after G did

					<prempt>

stock->cached[i] is cleared and
unlocks. Grace period G ends,
old is freed

					mem_cgroup_is_descendant() reads
					old->css.cgroup which has just
					been freed.

To close this gap on PREEMPT_RT, switch the order of the referene drop
and the publishing so that we publish the NULL pointer before dropping
the reference. Note that this can only happen from drain_stock who can
hold the last reference, but not on consume_stock since another
reference will always be held. But fix this in both sites to maintain
consistency. 

This is based on a report from Sashiko, who found this pre-existing
issue in my page_counter_stock series [1].

Link: https://lore.kernel.org/20261021010051.1529261-1-joshua.hahnjy@gmail.com
Link: https://sashiko.dev/#/patchset/20260928192349.3432886-1-joshua.hahnjy%40gmail.com [1]
Link: https://lore.kernel.org/all/atfMngq7nyZpt4u-@linux.dev/ [2]
Fixes: e1a366be5cb4 ("mm: memcontrol: switch to rcu protection in drain_all_stock()")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-publish-null-pointer-before-dropping-css-reference
+++ a/mm/memcontrol.c
@@ -2172,8 +2172,8 @@ static bool consume_stock(struct mem_cgr
 			stock_pages -= nr_pages;
 			WRITE_ONCE(stock->nr_pages[i], stock_pages);
 			if (!stock_pages) {
-				css_put(&memcg->css);
 				WRITE_ONCE(stock->cached[i], NULL);
+				css_put(&memcg->css);
 			}
 			ret = true;
 		}
@@ -2209,8 +2209,8 @@ static void drain_stock(struct memcg_sto
 		WRITE_ONCE(stock->nr_pages[i], 0);
 	}
 
-	css_put(&old->css);
 	WRITE_ONCE(stock->cached[i], NULL);
+	css_put(&old->css);
 }
 
 static void drain_stock_fully(struct memcg_stock_pcp *stock)
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are


