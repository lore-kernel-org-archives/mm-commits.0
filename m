Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70843770E2
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 22:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719612490; cv=none; b=EprJZ3gHzixizS4sQWhBNXrzSeWG+82nbnA0K1mGgSGOJu5cCljtuPwrwP1C7TBENIbmBy2xhYzpDZ4DYLhfha+LLgwly9/1p/LDsVCM6JZv78MtY0c3L+hq/SFIBMuPpvhqEYlEClL8NhL2vDWHnWzSUkrbSaJl3FZNkMNTwNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719612490; c=relaxed/simple;
	bh=ikIWV777YFZJzZlKhvCvbb8i8DDdmDq0BllqJpOIVRE=;
	h=Date:To:From:Subject:Message-Id; b=Ha5w7j2Mq1GVaptpczzOk7f1V7gXFHzdm0yglz2tgNsOModAl6GN7A1i3dpwq5lPazc2OB1pBkMuEmQDYjjbfogrboBhZhXhOsrx0fxzi95fFa+rAa9nnMIsB54I5ERjI8ACf9OeP3GsaE21yVsyUlzOrGnqFvGCK/mX5LrPMpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oz6eZzfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oz6eZzfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B1AC116B1;
	Fri, 28 Jun 2024 22:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719612489;
	bh=ikIWV777YFZJzZlKhvCvbb8i8DDdmDq0BllqJpOIVRE=;
	h=Date:To:From:Subject:From;
	b=oz6eZzfs8RyZu2vpC+PIuFFMz/QtP3VUV1tdV2QtS297V1jIpoawhxdHjAKFNZ3Ue
	 NkFUE5582BfZB+5IoGMaUZx6RVDN9lOu7+bKMiH/IxP5v7p+rGPAU5bRjeozE37czq
	 MSzljYKzt/J8yvduFmihrPxH7Qhk6DWyOodExdYY=
Date: Fri, 28 Jun 2024 15:08:09 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-guard-memcg1-specific-members-of-struct-mem_cgroup_per_node.patch added to mm-unstable branch
Message-Id: <20240628220809.D9B1AC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: guard memcg1-specific members of struct mem_cgroup_per_node
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-guard-memcg1-specific-members-of-struct-mem_cgroup_per_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-guard-memcg1-specific-members-of-struct-mem_cgroup_per_node.patch

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
Subject: mm: memcg: guard memcg1-specific members of struct mem_cgroup_per_node
Date: Fri, 28 Jun 2024 21:03:15 +0000

Put memcg1-specific members of struct mem_cgroup_per_node under the
CONFIG_MEMCG_V1 config option.

Link: https://lkml.kernel.org/r/20240628210317.272856-8-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/memcontrol.h~mm-memcg-guard-memcg1-specific-members-of-struct-mem_cgroup_per_node
+++ a/include/linux/memcontrol.h
@@ -92,6 +92,7 @@ struct mem_cgroup_per_node {
 	struct lruvec_stats			*lruvec_stats;
 	struct shrinker_info __rcu	*shrinker_info;
 
+#ifdef CONFIG_MEMCG_V1
 	/*
 	 * Memcg-v1 only stuff in middle as buffer between read mostly fields
 	 * and update often fields to avoid false sharing. Once v1 stuff is
@@ -102,6 +103,7 @@ struct mem_cgroup_per_node {
 	unsigned long		usage_in_excess;/* Set to the value by which */
 						/* the soft limit is exceeded*/
 	bool			on_tree;
+#endif
 
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
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
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option-fix.patch
maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch
mm-memcg-move-memcg_account_kmem-to-memcontrol-v1c.patch
mm-memcg-factor-out-legacy-socket-memory-accounting-code.patch
mm-memcg-guard-cgroup-v1-specific-code-in-mem_cgroup_print_oom_meminfo.patch
mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init.patch
mm-memcg-guard-memcg1-specific-fields-accesses-in-mm-memcontrolc.patch
mm-memcg-put-memcg1-specific-struct-mem_cgroups-members-under-config_memcg_v1.patch
mm-memcg-guard-memcg1-specific-members-of-struct-mem_cgroup_per_node.patch
mm-memcg-put-struct-task_struct-memcg_in_oom-under-config_memcg_v1.patch
mm-memcg-put-struct-task_struct-in_user_fault-under-config_memcg_v1.patch

