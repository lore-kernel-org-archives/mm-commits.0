Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF31417D8B2
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 20:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719348643; cv=none; b=phwlskFegS41ZayM89Hh6gPbDDm5WYC6CeFueAvfUqzj2jQLT0Ww47Moeg++pOsjhu+CREVilNulInz0Md50c/gRCHzY3Wzi09vpSWvqQi3BM0Byhd5+KhFUSCpfbCP5H2EyGqycb1wernC5D5tv2LEJfU4mZ1tuyXZRS5gER+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719348643; c=relaxed/simple;
	bh=mgqh+F9rN6pbBCJzQyS5kW/dVerr3GuC96vwP5yywZk=;
	h=Date:To:From:Subject:Message-Id; b=lniV4Uh4vHwSclkLk9314CgmtoSt6WGcyyO55Cz5vOb23nGRN9kM/j0lKUpvcG1UZQdcHwNxLyVPcaWzuQJstsYnN8HrgxqCr0Nz/KrBnB2ebnXbRlyvq9BQFVpldMFuK7CuE3Y5djCv1CiBdzABLdw002P/m/X+7zf3nHUHJzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FhpVUIbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FhpVUIbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6459C32781;
	Tue, 25 Jun 2024 20:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719348642;
	bh=mgqh+F9rN6pbBCJzQyS5kW/dVerr3GuC96vwP5yywZk=;
	h=Date:To:From:Subject:From;
	b=FhpVUIbVVyauG+Ithnd23xcMTpG2g0vjqnJVwktqXq6Ud06Y4KmjN+bVOsmk8Muen
	 5wRuEA47lVe+puLDZhpQXpJukANkDj3IttTiOE8AOt3J1RMVkF4BnQaJV7jF3ZvwP8
	 zVvFnyH0O7VPp8D6sPODplgRSn36mTl47Bq16pqw=
Date: Tue, 25 Jun 2024 13:50:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-make-memcg1_update_tree-static.patch added to mm-unstable branch
Message-Id: <20240625205042.A6459C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: make memcg1_update_tree() static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-make-memcg1_update_tree-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-make-memcg1_update_tree-static.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: make memcg1_update_tree() static
Date: Mon, 24 Jun 2024 17:59:03 -0700

memcg1_update_tree() is not used outside of mm/memcontrol-v1.c anymore,
define it as static and remove the declaration from the header file.

Link: https://lkml.kernel.org/r/20240625005906.106920-12-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    2 +-
 mm/memcontrol-v1.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memcontrol-v1.c~mm-memcg-make-memcg1_update_tree-static
+++ a/mm/memcontrol-v1.c
@@ -201,7 +201,7 @@ static unsigned long soft_limit_excess(s
 	return excess;
 }
 
-void memcg1_update_tree(struct mem_cgroup *memcg, int nid)
+static void memcg1_update_tree(struct mem_cgroup *memcg, int nid)
 {
 	unsigned long excess;
 	struct mem_cgroup_per_node *mz;
--- a/mm/memcontrol-v1.h~mm-memcg-make-memcg1_update_tree-static
+++ a/mm/memcontrol-v1.h
@@ -5,7 +5,6 @@
 
 #include <linux/cgroup-defs.h>
 
-void memcg1_update_tree(struct mem_cgroup *memcg, int nid);
 void memcg1_remove_from_trees(struct mem_cgroup *memcg);
 
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-introduce-memcontrol-v1c.patch
mm-memcg-move-soft-limit-reclaim-code-to-memcontrol-v1c.patch
mm-memcg-rename-soft-limit-reclaim-related-functions.patch
mm-memcg-move-charge-migration-code-to-memcontrol-v1c.patch
mm-memcg-rename-charge-move-related-functions.patch
mm-memcg-move-legacy-memcg-event-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_check_events.patch
mm-memcg-move-cgroup-v1-oom-handling-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_oom_recover.patch
mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c.patch
mm-memcg-make-memcg1_update_tree-static.patch
mm-memcg-group-cgroup-v1-memcg-related-declarations.patch
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch
maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch

