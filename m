Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B03F243387
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744835; cv=none; b=hJlA5AcLj8ttKA/kzpn+hM3wcl8sSVCikrt9cZyE7Dny9bLjO2tW6dLTW5VsKwIQ7nT8e4B4i/Tb8CtiDGlNHX10PcvWrVDxQDnIR03yhMN3HFc+GJZ4SusPpNUvJ6Zztt7kbPOvBiNDjKrZNsEvOP1M52+DOkGPyUOoWrkKLYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744835; c=relaxed/simple;
	bh=OrvWiwE8QYjXNIlpklWW6q64SHOQzl8feH8MkTYvPN0=;
	h=Date:To:From:Subject:Message-Id; b=Y9RhfAQwN1jtPJHqaCG3Y087EpBdGlPIV+LI21Hc2oLXTXIR7ohZYQbFGt328m9IrdlKFcnLVPEpJ3Qv+jwG8o+f/SEU8Q9e8O8YDKv5sbN+EqCT4BM1VYDxhuX89IK5TeuzBLKjK8ftr0TpF6lhI1EKcgKdZuRG65/bTuduaP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ewuYUHbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ewuYUHbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037CDC4CEF7;
	Sun, 29 Mar 2026 00:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744835;
	bh=OrvWiwE8QYjXNIlpklWW6q64SHOQzl8feH8MkTYvPN0=;
	h=Date:To:From:Subject:From;
	b=ewuYUHblc3/AJCaGOFjFIgEtsDsArGA4q/ARLOlxUV+dHrkG83/IqDkpJRGbaEpFK
	 /4lXv+s0UIfhB54wr3EZIGKpgZ2UmpQa/K2/o47+zqxuNWnvpReWAgWghsK6NKtkgI
	 hvHyxsbuvJdFH4cxxvCV6oeafye+q/1nS9WTMfS4=
Date: Sat, 28 Mar 2026 17:40:34 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,lianux.mm@gmail.com,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-use-mult_frac.patch removed from -mm tree
Message-Id: <20260329004035.037CDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: use mult_frac()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-use-mult_frac.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: use mult_frac()
Date: Sat, 7 Mar 2026 11:53:49 -0800

Patch series "mm/damon: improve/fixup/update ratio calculation, test and
documentation".

Yet another batch of misc/minor improvements and fixups.  Use mult_frac()
instead of the worse open-coding for rate calculations (patch 1).  Add a
test for a previously found and fixed bug (patch 2).  Improve and update
comments and documentations for easier code review and up-to-date
information (patches 3-6).  Finally, fix an obvious typo (patch 7).


This patch (of 7):

There are multiple places in core code that do open-code rate
calculations.  Use mult_frac(), which is developed for doing that in a way
more safe from overflow and precision loss.

Link: https://lkml.kernel.org/r/20260307195356.203753-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260307195356.203753-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: wang lian <lianux.mm@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-use-mult_frac
+++ a/mm/damon/core.c
@@ -665,7 +665,7 @@ static unsigned int damon_accesses_bp_to
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
-	return nr_accesses * 10000 / damon_max_nr_accesses(attrs);
+	return mult_frac(nr_accesses, 10000, damon_max_nr_accesses(attrs));
 }
 
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
@@ -1724,7 +1724,7 @@ static unsigned long damon_get_intervals
 	}
 	target_access_events = max_access_events * goal_bp / 10000;
 	target_access_events = target_access_events ? : 1;
-	return access_events * 10000 / target_access_events;
+	return mult_frac(access_events, 10000, target_access_events);
 }
 
 static unsigned long damon_feed_loop_next_input(unsigned long last_input,
@@ -2204,7 +2204,7 @@ static __kernel_ulong_t damos_get_node_m
 		numerator = i.totalram - i.freeram;
 	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
 		numerator = i.freeram;
-	return numerator * 10000 / i.totalram;
+	return mult_frac(numerator, 10000, i.totalram);
 }
 
 static unsigned long damos_get_node_memcg_used_bp(
@@ -2237,7 +2237,7 @@ static unsigned long damos_get_node_memc
 		numerator = used_pages;
 	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
 		numerator = i.totalram - used_pages;
-	return numerator * 10000 / i.totalram;
+	return mult_frac(numerator, 10000, i.totalram);
 }
 #else
 static __kernel_ulong_t damos_get_node_mem_bp(
@@ -2267,8 +2267,8 @@ static unsigned int damos_get_in_active_
 		global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_FILE);
 	total = active + inactive;
 	if (active_ratio)
-		return active * 10000 / total;
-	return inactive * 10000 / total;
+		return mult_frac(active, 10000, total);
+	return mult_frac(inactive, 10000, total);
 }
 
 static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
@@ -2311,8 +2311,8 @@ static unsigned long damos_quota_score(s
 	damos_for_each_quota_goal(goal, quota) {
 		damos_set_quota_goal_current_value(goal);
 		highest_score = max(highest_score,
-				goal->current_value * 10000 /
-				goal->target_value);
+				mult_frac(goal->current_value, 10000,
+					goal->target_value));
 	}
 
 	return highest_score;
@@ -2342,8 +2342,8 @@ static void damos_set_effective_quota(st
 
 	if (quota->ms) {
 		if (quota->total_charged_ns)
-			throughput = mult_frac(quota->total_charged_sz, 1000000,
-							quota->total_charged_ns);
+			throughput = mult_frac(quota->total_charged_sz,
+					1000000, quota->total_charged_ns);
 		else
 			throughput = PAGE_SIZE * 1024;
 		esz = min(throughput * quota->ms, esz);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

