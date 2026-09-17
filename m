Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697DC3E763E
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 05:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789621325; cv=none; b=QOHEdao1qwrUAMU1G/o6XH1uDtzPEn3CSPmkjfKmuVbxQsn29uPLYPiLG0yN/PQ8W9fhiNQmUKIa+dLhnz3Ydq55CNn0X2HNFM/FWN+1eLWi0s0v3/yODfk5n79fuxgmRQXynDYsUsLny1kKbjoM1EEV5bEFSx6hKeO5WdFa5Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789621325; c=relaxed/simple;
	bh=7Ug1SAYYOU4Mr0AvtJTXMQHk0SIaG3qDXSxibuDxnCU=;
	h=Date:To:From:Subject:Message-Id; b=URRjqZYB0GQjoLdidbV29YTJ9FG7p8mdYKgDxwib5MQtDH6ToC0qyfMkZ8YaH3L7JOmj3/PpPtoQy/re1Lee9rUi5XNy3y4xWofGf/3n0M3jxSYoGDpWP/hZ/sFKScMf0kXbBPSMwLmNqI6KdDgMvHRZ4sd+IHRfo8S22+Etsd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IA6HnED5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IA6HnED5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8891F000FF;
	Thu, 17 Sep 2026 05:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789621324;
	bh=+z7AvvFh29sSlrkDyBojkqjnPSQZz1GzNU8B9EFRz9o=;
	h=Date:To:From:Subject;
	b=IA6HnED5XGX/lFzFtwiotBYAKxaBzQU86tnibm6Ux4HFWoIArLlhYIf+WW1qLVeAk
	 C6OQTM13E2b/4PbB45IinF0jqVxRgKccWq5kv2htK9R4EroVWSNOou6RQB54py3kkq
	 cqRGK5NWFJ2VVUC0lnuKYDGiy+SWAxO9Zv6vl9PA=
Date: Wed, 16 Sep 2026 22:02:03 -0700
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch removed from -mm tree
Message-Id: <20260917050204.0F8891F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: skip the RCU lock when the memcg is not dying
has been removed from the -mm tree.  Its filename was
     mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch

This patch was dropped because an updated version will be issued

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

