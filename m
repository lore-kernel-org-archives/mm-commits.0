Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B7D3E5EE7
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 05:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789621872; cv=none; b=KRSWmIod23dixqRs0382Mj3hsAGD75w2b91g55VH9myqDxBJ/HnGR5aQuRU0VP59JT790MmMYd3agkqpIFaNLORkoh0WVN0tFvCWNySfRVWjCSL+vvR1hwEI5xNpFhrjK0G4XWDIx4ySI9jWu13scPJjWmPE6kqG6XRQl3IEF+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789621872; c=relaxed/simple;
	bh=WTHxLW7BS1jTaYa80VF2QCxeGIyI5UQMX/d0iagKAc8=;
	h=Date:To:From:Subject:Message-Id; b=fRsphT4VW/t/awe25leFn/nrAuDnr9FRdquVb+1nLVkDB3JRcQuyfbHKAgyVhSHPUgXXR1Mbk37eytrScAD4PRNkQDkpWMJxFxbFV7KQxvBpYbbua5RKgJb//3WSQtBxvawnJB2sJSYGFj5UiZmhaoVVwadNdRBTV8NqVHsooTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gXs+fKk1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gXs+fKk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C981F000FF;
	Thu, 17 Sep 2026 05:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789621871;
	bh=DJT7RZW40gpK2zD4iZ5H7zQnGhd52O2FAG6pmWuQgDs=;
	h=Date:To:From:Subject;
	b=gXs+fKk1ijncL5fv81ZD1zSXGig8L2EH+bNR69QxuXbVoZH9eTdREycmRnBHir9Kx
	 V8GkAc+LXcxwATlV/KX5KI0vIxVi3ZLH3LX2GITtffc9Lb32h7deinzbV0ZBothlvE
	 rRNoerxoUmw/D7YKj5Eapt5UTsg0K4/PvBmDAQQc=
Date: Wed, 16 Sep 2026 22:11:10 -0700
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch added to mm-unstable branch
Message-Id: <20260917051111.28C981F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: skip the RCU lock when the memcg is not dying
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch

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
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm: memcg: skip the RCU lock when the memcg is not dying
Date: Fri, 11 Sep 2026 16:00:50 +0800

get_non_dying_memcg_start() takes rcu_read_lock() on every stat update,
but the lock only protects the upward walk to a non-dying ancestor, which
happens solely while a memcg is being offlined.  The dying check itself
reads the CSS_DYING flag of a memcg the caller already holds a reference
to, so it is safe without the lock.

Check memcg_is_dying() first and return immediately when the memcg is
alive, taking the RCU lock only on the rare dying path.  On an anon
fault/charge churn workload in a memcg this recovers the ~0.6% overhead
added by the previous patch (4368077 vs 4343159 pages/s before, back to
~4377000 pages/s after).

Link: https://lore.kernel.org/9ffdbdfc96312e3e13cb8f056bfe26649492d949.1789096175.git.zhuhui@kylinos.cn
Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/memcontrol.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying
+++ a/mm/memcontrol.c
@@ -881,6 +881,17 @@ static long memcg_state_val_in_pages(int
 static inline struct mem_cgroup *
 get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 {
+	/*
+	 * Fast path: the caller holds a reference to @memcg, so reading
+	 * its CSS_DYING flag without the RCU lock is safe.  The RCU lock
+	 * is only needed to walk up to a non-dying ancestor, which
+	 * happens only while a memcg is actually being offlined.
+	 */
+	if (!memcg_is_dying(memcg)) {
+		*rcu_locked = false;
+		return memcg;
+	}
+
 	rcu_read_lock();
 	*rcu_locked = true;
 
@@ -892,6 +903,9 @@ get_non_dying_memcg_start(struct mem_cgr
 
 static inline void get_non_dying_memcg_end(bool rcu_locked)
 {
+	if (!rcu_locked)
+		return;
+
 	rcu_read_unlock();
 }
 
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-vmstat-annotate-data-race-for-per-cpu-pageset-fields.patch
mm-memcg-redirect-stats-updates-of-dying-memcgs-for-all-hierarchies.patch
mm-workingset-use-lruvec_page_state_local-to-count-lru-pages.patch
mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch
mm-memcg-reparent-non-hierarchical-lruvec-stats-on-cgroup-v2.patch

