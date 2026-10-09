Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F1040243B;
	Fri,  9 Oct 2026 05:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525427; cv=none; b=V8wrwa9ZyGkjfETMe63p7VJNaEfUJDi1J0lTlP7IC56CWYHxmehmZ6Qm62dgqDB7xP9UeZUpcYg0CuqRaz/IWg4d0+bIqDEJZaas5G7cVc2FepbU+j7QE8zUQjwKGXB1kbYIUny+pZRIMd5+aJrfboTJq8RC6e2dhlAqufNZGHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525427; c=relaxed/simple;
	bh=HpgOrd2wpz5DsHMJggkk4LfUhs+Y8rML0c+C8R0FNGc=;
	h=Date:To:From:Subject:Message-Id; b=LN5Tbyv5e+XUFBTPiKEVLBIl7pdRy52EUWTjKNH3Auf4Q10W97/hiNb/WtkjSuRubDkVIYUQ0FIZLw9JubvXRxDul7S/8uyYGx0jfpoqv9HHe5WqIYHP9imfhxlvTcKl1kSxhyjiwkEuqky8ugkqjZiXnpiFpT1d6Ft99/sN1jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D8dFLPKF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D8dFLPKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA54A1F000FF;
	Fri,  9 Oct 2026 05:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525425;
	bh=SxD4USmfkRMdlQbqkR31eTtcx0iaea4wEQ9Oo4wSvKs=;
	h=Date:To:From:Subject;
	b=D8dFLPKFG3xvQetavzz6lEgQihwfo7S00Ql/Lqmd2x1W0ya+Ubv/3/eYCsXyoCRel
	 +x7qbPe6voTMZYFPZakg5STB8GbKm9xwna7aDEx/WGiZTqdVNGf0O6VJqzY8wzLuMa
	 U6PB8cdy480AHXBKcDRaMy5/e4ofHCSgguaCuSHE=
Date: Thu, 08 Oct 2026 22:57:05 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch removed from -mm tree
Message-Id: <20261009055705.CA54A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: skip the RCU lock when the memcg is not dying
has been removed from the -mm tree.  Its filename was
     mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


