Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793312087;
	b=ozeZSsAs/GGOH2bNe1Pz0mq65Yoh1p/u+tl+byjxr6qzpbYCH3zDt3+A5oHME+D4dUkC
	 U0JGdz4vEAUDmDC8w3kxmrIGtcbUcCTNBcadTSAV3kmOQ7OTsJyc2zBLPAeLlBX3ewKHE
	 XJ9OL/ScpZDZg/ySeQpJoyClbJ7ZXppRjSICg8EF0WhR5zf64AN54khPbQuvAoMPhFSM9
	 0eSkqngvUBwHmdIBXRIl5DGkjzRGesLRilicV4esw5Zdj1Y0mShRraOwv4Uz+fCrjpFAT
	 CsKgH/KolV838GCZa1co7bisDGnR47GMHr1vmz3+sr+hHjlKG67Yx3kGiDGVesDXRbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793312087;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=tmyCnl1qvRQ7dIcOzGQPMNziIbKKzNRsJXJzafXsiEg=;
	b=23ghHLP8jrKXXIBqNWxiE/UX3AmQeqGAvcdb50ePW/S9z4Jwtxk6nrAdYX6DMI1BVVvV
	 6iGHETKfWGzqg7lpKHmB14IVxt0Fa5Hb5Pa3IJAIySQ3kC305i01C/S3uXZDHt8HWT/Wn
	 Q3vf8zNIEFUQ5R5X06/YkURqXvgAp92qShdMslW0rJlhSlmrhtjjuJbxffQ7fM6RHAQhZ
	 NQMcM2xbnG7RxIV1hlRMvZRcobHjBbbAa4gsajSkftVUPxXZCPwPsZGBrxJwi6iIGPPRm
	 hv9XFfiNHdU49cezsRnyKp0UCbYN2UqOqwmezLsgnNzlo5zvh3YNgk414YI/rWRqALQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cu8qut59;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD97A606A31A
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 22:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cu8qut59
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4853F1F01816;
	Thu, 29 Oct 2026 22:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793312086;
	bh=tmyCnl1qvRQ7dIcOzGQPMNziIbKKzNRsJXJzafXsiEg=;
	h=Date:To:From:Subject;
	b=cu8qut59MNfS3y4HSRrZGb+jxfWHlK7oJfQZfvQcJU1UjQayxZytQtAemBAu6gv1s
	 neI8gr1WtX5dUgofVWJhg5XbA+hw3b5kdGCAdjWvxQwk9bMP5CUUZMadsW1V3GW5wP
	 Qv/WB3ITB1Ue3F4i7e7Hnue87L5GhxLCSjIChKnE=
Date: Thu, 29 Oct 2026 15:14:45 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,
	hannes@cmpxchg.org,kuniyu@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-reduce-nesting-in-consume_stock-and-refill_stock.patch added to mm-new branch
Message-Id: <20261029221446.4853F1F01816@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: memcg: reduce nesting in consume_stock() and refill_stock().
has been added to the -mm mm-new branch.  Its filename is
     memcg-reduce-nesting-in-consume_stock-and-refill_stock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-reduce-nesting-in-consume_stock-and-refill_stock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Kuniyuki Iwashima <kuniyu@google.com>
Subject: memcg: reduce nesting in consume_stock() and refill_stock().
Date: Thu, 29 Oct 2026 19:44:13 +0000

A later patch adds more code to the most nested block in
consume_stock() and refill_stock().

Let's reduce the nesting to make the later change cleaner.

Link: https://lore.kernel.org/20261029194452.3189365-3-kuniyu@google.com
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
---

 mm/memcontrol.c |   64 ++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 30 deletions(-)

--- a/mm/memcontrol.c~memcg-reduce-nesting-in-consume_stock-and-refill_stock
+++ a/mm/memcontrol.c
@@ -2168,15 +2168,17 @@ static bool consume_stock(struct mem_cgr
 			continue;
 
 		stock_pages = stock->nr_pages[i];
-		if (stock_pages >= nr_pages) {
-			stock_pages -= nr_pages;
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (!stock_pages) {
-				WRITE_ONCE(stock->cached[i], NULL);
-				css_put(&memcg->css);
-			}
-			ret = true;
+		if (stock_pages < nr_pages)
+			break;
+
+		stock_pages -= nr_pages;
+		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+		if (!stock_pages) {
+			WRITE_ONCE(stock->cached[i], NULL);
+			css_put(&memcg->css);
 		}
+
+		ret = true;
 		break;
 	}
 
@@ -2258,7 +2260,6 @@ static void refill_stock(struct mem_cgro
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *cached;
 	unsigned int stock_pages;
-	bool success = false;
 	int empty_slot = -1;
 	int i;
 
@@ -2287,32 +2288,35 @@ static void refill_stock(struct mem_cgro
 		cached = stock->cached[i];
 		if (!cached && empty_slot == -1)
 			empty_slot = i;
-		if (memcg == stock->cached[i]) {
-			stock_pages = stock->nr_pages[i] + nr_pages;
-			if (stock_pages > MEMCG_STOCK_HIGH) {
-				memcg_uncharge(memcg,
-					       stock_pages - MEMCG_STOCK_LOW);
-				stock_pages = MEMCG_STOCK_LOW;
-			}
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			success = true;
-			break;
+
+		if (memcg != cached)
+			continue;
+
+		stock_pages = stock->nr_pages[i] + nr_pages;
+		if (stock_pages > MEMCG_STOCK_HIGH) {
+			memcg_uncharge(memcg,
+				       stock_pages - MEMCG_STOCK_LOW);
+			stock_pages = MEMCG_STOCK_LOW;
 		}
+
+		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+
+		local_unlock(&memcg_stock.lock);
+		return;
 	}
 
-	if (!success) {
-		i = empty_slot;
-		if (i == -1) {
-			i = stock->drain_idx++;
-			if (stock->drain_idx == NR_MEMCG_STOCK)
-				stock->drain_idx = 0;
-			drain_stock(stock, i);
-		}
-		css_get(&memcg->css);
-		WRITE_ONCE(stock->cached[i], memcg);
-		WRITE_ONCE(stock->nr_pages[i], nr_pages);
+	i = empty_slot;
+	if (i == -1) {
+		i = stock->drain_idx++;
+		if (stock->drain_idx == NR_MEMCG_STOCK)
+			stock->drain_idx = 0;
+		drain_stock(stock, i);
 	}
 
+	css_get(&memcg->css);
+	WRITE_ONCE(stock->cached[i], memcg);
+	WRITE_ONCE(stock->nr_pages[i], nr_pages);
+
 	local_unlock(&memcg_stock.lock);
 }
 
_

Patches currently in -mm which might be from kuniyu@google.com are

mm-kasan-detect-double-free-involving-kfree_rcu_sheaf.patch
mm-kasan-kunit-add-double-free-tests-involving-kfree_rcu_sheaf.patch
memcg-remove-unnecessary-read_once-under-memcg_stocklock.patch
memcg-reduce-nesting-in-consume_stock-and-refill_stock.patch
memcg-annotate-slow-paths-in-consume_stock-and-refill_stock.patch
memcg-uncharge-pages-outside-memcg_stocklock-in-refill_stock.patch

