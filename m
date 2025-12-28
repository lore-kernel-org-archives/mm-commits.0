Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9D71D6195
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 21:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766958930; cv=none; b=ZrPyu4Fyeqn+JHSr6TW3LQIJdnx6fhRkTcSAWvabNxzMhvKmRidl7edx5YZMnc4rd/iRDlN23foNrYdHNUA3OIqjy7rQJBirGl8iZ5aAXUjGjFz85qqPd73PFmGCGw+P+oJ0qqzSvkko9qneB6IsinL1oeMuOjxtqvg6CLFU40w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766958930; c=relaxed/simple;
	bh=7mcXS+6yiMZWfbXUv85qtVL8qhLa96qgYRLD0Lbuw84=;
	h=Date:To:From:Subject:Message-Id; b=a0wz+QgeVGMHwiwtzWFiS7yOAQJuZ1DttKuwt7Xzdhho4eVIZxI1amdf1bpoQeRq4DnN7+jjMhH+XzxLqbAEQzK5iiMUrfTc07leeIcPIKR7HP5Z6oevWTakk+ADH0dQKwOH0ZKYAqwGwbzgLqN3QgaMBlfn9ff/rXx+m0g5THY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DRS2PM7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DRS2PM7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBD3C4CEFB;
	Sun, 28 Dec 2025 21:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766958929;
	bh=7mcXS+6yiMZWfbXUv85qtVL8qhLa96qgYRLD0Lbuw84=;
	h=Date:To:From:Subject:From;
	b=DRS2PM7nE/jvabMxLCzG3QUGlU0pHftorOEyKqGo+HoFDSNzTMtYqf2IVGkWgd83x
	 M8wd6OASHH+yeIxqJEYmO1zPoyhT9thUHGGjsS6ngCgVVrLphcdFrjQvCo5ZSxWDwZ
	 zBWWQHKu6ZM+uzUkH4labfa13AIkYa5ixFb+DhTk=
Date: Sun, 28 Dec 2025 13:55:28 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-get-memcg-reference-before-access.patch added to mm-hotfixes-unstable branch
Message-Id: <20251228215529.6EBD3C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: get memcg reference before access
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-get-memcg-reference-before-access.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-get-memcg-reference-before-access.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
@@ -2080,13 +2080,15 @@ static unsigned long damos_get_node_memc
 
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
@@ -2094,6 +2096,8 @@ static unsigned long damos_get_node_memc
 	used_pages += lruvec_page_state(lruvec, NR_ACTIVE_FILE);
 	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_FILE);
 
+	mem_cgroup_put(memcg);
+
 	si_meminfo_node(&i, goal->nid);
 	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 		numerator = used_pages;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

lib-buildid-use-__kernel_read-for-sleepable-context.patch
mm-damon-core-get-memcg-reference-before-access.patch

