Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D4F246778
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 01:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788659123; cv=none; b=GDpmvkkCwV7oR7PnAG5Y3R5dpQ6bQv12tHsVFOFygjOsxlW3QhIsIQTsN5KuYFIB3MWhAFFi908xLY14oOZPkU940zqX+So+1q/zEBtNKdgg3ySlVk9Ec7RzjxHnZqLOPEjOexD02wGqn330E9UpDQWuyNxTKw0yo5sXio9cmCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788659123; c=relaxed/simple;
	bh=rM0qeLGrmyB1KI97DSJvTzr46EgZfKgegu/pr1qBcEo=;
	h=Date:To:From:Subject:Message-Id; b=nLveVcOET6KFbL476LuxGg0Avhaz6ymEmobFMEoR6cX6Qr9uVrApWliPdiEU1lAlXOi8P9pBkvRgHCJR6CG+1goStqF8j07KNvE+MWtxl/kb8Hr0w3qyEhFtpO6KF6rAeKyLIQYTUifb7iyUEU+E0LL6sAwUKi0akpp6X/nIoDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bJKGKVsE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bJKGKVsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AF31F00A3A;
	Sun,  6 Sep 2026 01:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788659122;
	bh=/bhPQZ+lDxQZtO52zGAVL7pveFEtwgDrBcFEapxjUI4=;
	h=Date:To:From:Subject;
	b=bJKGKVsENpQ63S4LUrJMNuOHCSlZ1lb9CDQO7udObGgHVp5Fxdeq4vSHUlt9qcMZh
	 FnDssaAzL1+hVEJG8mDzUzpLY8Vpe7t58QFPCpqEcvR+GD+8QYlmL6KpFngLht3uJL
	 QPg73cuZjqYwJMJMRiEUHpz5sjDKzoKjPo68Gq1M=
Date: Sat, 05 Sep 2026 18:45:21 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch added to mm-new branch
Message-Id: <20260906014522.09AF31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: skip the RCU lock when the memcg is not dying
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch

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
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm: memcg: skip the RCU lock when the memcg is not dying
Date: Fri, 4 Sep 2026 17:45:56 +0800

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

Link: https://lore.kernel.org/0db657472c5278b2e2b87fbca7590b47ca520303.1788514750.git.zhuhui@kylinos.cn
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

