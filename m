Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00B13595D
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 05:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280968; cv=none; b=t91E0bKIXln5MboRD2qJUKyFXqGnGOpryriSYtysUOFRSFmbZGnjXbgkYP7zr5eSgibPhSYrfcg7LDZmXKDCvdx+toSIE8/DgV/v/umLzMzB9KHD3uokCB8A2W3u+/moPpEWgWWIMvboqIxi1Su02ADDE9KyTA7r4gbEkQENEoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280968; c=relaxed/simple;
	bh=y7cC2BIqal6FpYtwq08KKUl7ddAEmQ/aggPQBIHv4c0=;
	h=Date:To:From:Subject:Message-Id; b=Crwv06Nb4vZXraKjuCn1hdrRpiswqgD8CD9PNH0ACUj7inO0/aZS8oTk4UcXXYUW730+bMrkvm8snBYF8RW3uMugSenfTzrsu8clY1t5/4sJITs4eh5kYvgB1W+TOakt2Uc1i3IJ+G51AZEqN8UFnkNhUugFqCc9Axxr8D+8zAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0hyeirGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0hyeirGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C16CC116C6;
	Tue, 13 Jan 2026 05:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280968;
	bh=y7cC2BIqal6FpYtwq08KKUl7ddAEmQ/aggPQBIHv4c0=;
	h=Date:To:From:Subject:From;
	b=0hyeirGvxZU/lcFvEtNi42Ki8mwnMRRG1VxaVGuIUzlrFw/iEKuztXElfpPzBIObp
	 UnUlfA42Kmm0Hr9NrUKNjgKjmb4pSsw5rEEVQ8m3DQJaiKvFbsKhZ0l0/1s/ExGVvH
	 2lIWas0Bgc/isOtxmYOS9ljONWGPHi0mkck5W8uo=
Date: Mon, 12 Jan 2026 21:09:28 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-get-memcg-reference-before-access.patch removed from -mm tree
Message-Id: <20260113050928.9C16CC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: get memcg reference before access
has been removed from the -mm tree.  Its filename was
     mm-damon-core-get-memcg-reference-before-access.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm/damon/core: get memcg reference before access
Date: Wed, 24 Dec 2025 16:29:04 -0800

The commit b74a120bcf507 ("mm/damon/core: implement
DAMOS_QUOTA_NODE_MEMCG_USED_BP") added accesses to memcg structure without
getting reference to it.  This is unsafe.  Let's get the reference before
accessing the memcg.

Link: https://lkml.kernel.org/r/20251225002904.139543-1-shakeel.butt@linux.dev
Fixes: b74a120bcf507 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-get-memcg-reference-before-access
+++ a/mm/damon/core.c
@@ -2051,13 +2051,15 @@ static unsigned long damos_get_node_memc
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(goal->memcg_id);
-	rcu_read_unlock();
-	if (!memcg) {
+	if (!memcg || !mem_cgroup_tryget(memcg)) {
+		rcu_read_unlock();
 		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 			return 0;
 		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
 			return 10000;
 	}
+	rcu_read_unlock();
+
 	mem_cgroup_flush_stats(memcg);
 	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(goal->nid));
 	used_pages = lruvec_page_state(lruvec, NR_ACTIVE_ANON);
@@ -2065,6 +2067,8 @@ static unsigned long damos_get_node_memc
 	used_pages += lruvec_page_state(lruvec, NR_ACTIVE_FILE);
 	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_FILE);
 
+	mem_cgroup_put(memcg);
+
 	si_meminfo_node(&i, goal->nid);
 	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 		numerator = used_pages;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-introduce-private-id-api-for-in-kernel-users.patch
memcg-expose-mem_cgroup_ino-and-mem_cgroup_get_from_ino-unconditionally.patch
memcg-mem_cgroup_get_from_ino-returns-null-on-error.patch
memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id.patch
mm-damon-use-cgroup-id-instead-of-private-memcg-id.patch
mm-vmscan-use-cgroup-id-instead-of-private-memcg-id-in-lru_gen-interface.patch
memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix.patch

