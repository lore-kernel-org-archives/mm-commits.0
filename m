Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792555875;
	b=i1bb6uX+hYdgA7FfufZqDAaDCw6ubYOsY/BJf7DgHrJHGGB4Pm9VoP8MzeO/6h5DNe9F
	 ikIYxKYRwWWN7Rj4aOc7ldgshp3p2I2G7oZg2stTmB/0QIdNfjJ2LhH/oGFpBIcDo9l4a
	 1r44cYMUloYNVaDq5me/ltub4JQITDA8Qn4UvNoZ/B3UCkIl6GoCHF6+4tZzlLWApl7IW
	 5Wq2/7UxtQPUEsXvDpJwEM83LejFxbuj6gQGxpev7OhPiJ7EOe2QEd0BGysRVS/MKMQgF
	 ovYNv872SBudMHIALICS/gFe6gLHKKIXBJ5QedBkkS5TNQN9lzDcHubSKe77SqW52hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792555875;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=jp//GHMPiUj8paYMb1M4ZEg5KxKFiI5zoCO40UVeYF4=;
	b=UPaB5GPszOAW4E65bb/dw3/QXlGjiYmarvV/69VxSuTaTh7gFyHbw32LKmiQrE5j0DXs
	 687zjzlEEhbTCPbLQMTq9j09/3M2wHnL1Sfiw0Hv3noIIFuWxTaVj+pU6tttUSMpNqsLm
	 jS640f3HfWLW/JaC/sbGs05w4VUb6LSTy9Ed5/OQ/UTjhySf1iOSWJ+ghDn1vwqw1R83m
	 XsUk+iSk/+mTjAdQs/+D86yd1Ik+jZ2v80NuFNrV3Jjo3b15nthDk9uUXcScZmqnV6Shc
	 rYQ7FYAclAGkBA3H3527GXrGoMoJZ1WypKExZJKfeVcdyzLd5lfcQ+2XnBxeVPIb0Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jRh8VWQy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFFB60A2607
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 04:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jRh8VWQy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDD91F01579;
	Wed, 21 Oct 2026 04:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792555874;
	bh=jp//GHMPiUj8paYMb1M4ZEg5KxKFiI5zoCO40UVeYF4=;
	h=Date:To:From:Subject;
	b=jRh8VWQytIZXpCWZWYzFyRvgXf9h1AUNYD9OsSokrP5DATq3Cf/Xg/kqMxRqxN2dC
	 pAQubayeApdgHLKyQTn1P8W7raWY5tdDJyZjZoAxhrBFeFiC4DJAgf+qIavqGIAJ1z
	 Jck1eIkMY465tFUJyOHDw697bQ8tS7aBX0bMd1BY=
Date: Tue, 20 Oct 2026 21:11:13 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-publish-null-pointer-before-dropping-css-reference.patch added to mm-unstable branch
Message-Id: <20261021041114.7EDD91F01579@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/memcontrol: publish null pointer before dropping css reference
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-publish-null-pointer-before-dropping-css-reference.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-publish-null-pointer-before-dropping-css-reference.patch

This patch will later appear in the mm-unstable branch at
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

mm-memcontrol-publish-null-pointer-before-dropping-css-reference.patch

