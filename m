Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B64F30AD15
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 11:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777290399; cv=none; b=nLXWf69csvJF/SqvqlcF+52CkqEHco96l+84ffrA5LA0sO7kXtDQbz0VwR7AoLhEObHsVpanxWGjIDDd39MszizJfg09cLHJq56OKBdazyuvM3I3VL/sNvJUHz97CEU9KWlLh/uLZrGLYe9GUpORsDr4QQnUOGPsllHCSp7Vj6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777290399; c=relaxed/simple;
	bh=aQ2xpxcS6EahjcjOXVHArnYwh5g7MxJAqhTw4WiHOWw=;
	h=Date:To:From:Subject:Message-Id; b=JPd3mc9vvgnwDJZ6fGCxqZHJSLqfu8qa+j6yMqdLNTD7PpdQhY8dYoTj+S1G4oGRLHiIBgZPvYsKvkTbeaTaHiE48c3ojreMl0QS5FbOdt0KuEKJ0hlhV3yL0WYmJDhCh7qxyCAFEAZuTH4V+znxNdMfa8UHTTwuzpONDkVrdLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GP5/738s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GP5/738s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FEBC19425;
	Mon, 27 Apr 2026 11:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777290394;
	bh=aQ2xpxcS6EahjcjOXVHArnYwh5g7MxJAqhTw4WiHOWw=;
	h=Date:To:From:Subject:From;
	b=GP5/738sWZgQ5Yyo/4yM4FgaggGNtmJws+u+fT1Z+l8T5tRVcoHJ+XPeB53Pzu8lp
	 YVfrAGMRJbSoCTPHSUBS25wj0/hlluXY6DyTOCZ9soIQXvBaC41QMC8owVMKIZbFP3
	 ABqiDeCMUaAvSbPV6NQ7eKutTNkP0QYmiDmX81g8=
Date: Mon, 27 Apr 2026 04:46:34 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hank20010209@gmail.com,gutierrez.asier@huawei-partners.com,david@kernel.org,corbet@lwn.net,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-common-optimize-damon_hot_score-using-ilog2.patch added to mm-new branch
Message-Id: <20260427114634.B6FEBC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/ops-common: optimize damon_hot_score() using ilog2()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-ops-common-optimize-damon_hot_score-using-ilog2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-common-optimize-damon_hot_score-using-ilog2.patch

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
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: mm/damon/ops-common: optimize damon_hot_score() using ilog2()
Date: Sun, 26 Apr 2026 16:16:14 -0700

Patch series "mm/damon: repost non-hotfix reviewed patches in damon/next
tree", v2.

The first patch from Liew Rui Yan add a minor performance optimization
using ilog2() instead of inefficient manual implementation of the
functionality.

The second patch from Cheng-Han Wu fixes a minor typo:
s/parametrs/parameters/.

The third patch from Liew Rui Yan make commit_inputs operation of
DAMON_RECLAIM and DAMON_LRU_SORT synchronous to improve the user
experience.

The fourth patch from Asier Gutierrez adds a new DAMOS action,
DAMOS_COLLAPSE for deterministic DAMOS-based access-aware THP system.


This patch (of 4):

The current implementation of damon_hot_score() uses a manual for-loop to
calculate the value of 'age_in_log'.  This can be efficiently replaced by
ilog2(), which is semantically more appropriate for calculating the
logarithmic value of age.

In a simulated-kernel-module performance test with 10,000,000 iterations,
this optimization showed a significant reduction in latency (average
latency reduced from ~12ns to ~1ns).

Test results from the simulated-kernel-module:
- ilog2:
    DAMON Perf Test: Starting 10000000 iterations
    =============================================
     Total Iterations : 10000000
     Average Latency  : 1 ns
     P95 Latency      : 41 ns
     P99 Latency      : 41 ns
    ---------------------------------------------
     Range (ns)      | Count        | Percent
    ---------------------------------------------
     0-19            | 0            |      0%
     20-39           | 2625000      |     26%
     40-59           | 7374000      |     73%
     60-79           | 0            |      0%
     80-99           | 0            |      0%
     100+            | 1000         |      0%
    =============================================

- for-loop:
    DAMON Perf Test: Starting 10000000 iterations
    =============================================
     Total Iterations : 10000000
     Average Latency  : 12 ns
     P95 Latency      : 51 ns
     P99 Latency      : 60 ns
    ---------------------------------------------
     Range (ns)      | Count        | Percent
    ---------------------------------------------
     0-19            | 0            |      0%
     20-39           | 0            |      0%
     40-59           | 9862000      |     98%
     60-79           | 135000       |      1%
     80-99           | 1000         |      0%
     100+            | 2000         |      0%
    =============================================

Full raw benchmark results can be found at [1].

Link: https://lore.kernel.org/20260426231619.107231-1-sj@kernel.org
Link: https://lore.kernel.org/20260426231619.107231-2-sj@kernel.org
Link: https://github.com/aethernet65535/damon-hot-score-fls-optimize/tree/master/result-raw [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: Cheng-Han Wu <hank20010209@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-optimize-damon_hot_score-using-ilog2
+++ a/mm/damon/ops-common.c
@@ -117,9 +117,12 @@ int damon_hot_score(struct damon_ctx *c,
 		damon_max_nr_accesses(&c->attrs);
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
-	for (age_in_log = 0; age_in_log < DAMON_MAX_AGE_IN_LOG && age_in_sec;
-			age_in_log++, age_in_sec >>= 1)
-		;
+	if (age_in_sec)
+		age_in_log = min_t(int, ilog2(age_in_sec) + 1,
+				DAMON_MAX_AGE_IN_LOG);
+	else
+		age_in_log = 0;
+
 
 	/* If frequency is 0, higher age means it's colder */
 	if (freq_subscore == 0)
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

mm-damon-ops-common-optimize-damon_hot_score-using-ilog2.patch
mm-damon-add-synchronous-commit-for-commit_inputs.patch

