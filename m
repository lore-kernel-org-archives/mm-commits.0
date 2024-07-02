Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66951B674
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 02:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719886860; cv=none; b=tv+4Xjh9J8n4hd8mXieChOI4fF+4Jl1iZlOrecncCGOm8ExA5Ec5tHN4lkIU3wuBE18sryijgc3xQ2NwLI2W5cf+49Z/c2hKizoSTLgZSum3bVB5dQ1baGoQtDd0dNp8L2EC06gAg+JzzjeniK2S5JDJYiwCsegIzRBBXWZHvv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719886860; c=relaxed/simple;
	bh=G3qp0aCWPvyPylxGSeOtZoSl+kbtBmOdAAZNL3PL66I=;
	h=Date:To:From:Subject:Message-Id; b=mF0nyuAyet3bfDCm2B3uL7JfMjOydHYQxM/8d/CYgvByESG4fA2CxbAfsmT+cwOiiS/MaouhdSeg8PAHCtfHQRteAVCD4Tyi/pFC1CMY5JHlSHjsGOTOg+gU4jqdhJHenBKodekLZQ5gquloHhR+Nb5ow2FqdTRwOt5qgpDDUaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z+5pNkhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z+5pNkhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC41CC116B1;
	Tue,  2 Jul 2024 02:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719886860;
	bh=G3qp0aCWPvyPylxGSeOtZoSl+kbtBmOdAAZNL3PL66I=;
	h=Date:To:From:Subject:From;
	b=Z+5pNkhS/aGKtpEPdxpM2L5gqh/zyDrRYuke+7Snbah4eD4SnRfVTyqYmJC7dUhKx
	 X7yls15/TWZrqvwxpdofGytHJDeS4EO7xbkDMrI4FWVK1e5/lMRrr7dsokd2I4Qg0U
	 DJ/mXHwN0fTA9xTzOC5+EsPQqapHMh/1fmj0rstA=
Date: Mon, 01 Jul 2024 19:20:59 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch added to mm-unstable branch
Message-Id: <20240702022059.EC41CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: add cache line padding to mem_cgroup_per_node
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

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
Subject: mm: memcg: add cache line padding to mem_cgroup_per_node
Date: Mon, 1 Jul 2024 18:59:32 +0000

Memcg v1-specific fields serve a buffer function between read-mostly and
update often parts of the mem_cgroup_per_node structure.  If
CONFIG_MEMCG_V1 is not set and these fields are not present, an explicit
cacheline padding is needed.

Link: https://lkml.kernel.org/r/20240701185932.704807-2-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node
+++ a/include/linux/memcontrol.h
@@ -95,14 +95,16 @@ struct mem_cgroup_per_node {
 #ifdef CONFIG_MEMCG_V1
 	/*
 	 * Memcg-v1 only stuff in middle as buffer between read mostly fields
-	 * and update often fields to avoid false sharing. Once v1 stuff is
-	 * moved in a separate struct, an explicit padding is needed.
+	 * and update often fields to avoid false sharing. If v1 stuff is
+	 * not present, an explicit padding is needed.
 	 */
 
 	struct rb_node		tree_node;	/* RB tree node */
 	unsigned long		usage_in_excess;/* Set to the value by which */
 						/* the soft limit is exceeded*/
 	bool			on_tree;
+#else
+	CACHELINE_PADDING(_pad1_);
 #endif
 
 	/* Fields which get updated often at the end. */
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
mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

