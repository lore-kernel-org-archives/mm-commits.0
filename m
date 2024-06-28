Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CBB80028
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 22:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719612486; cv=none; b=qm1AOthKbBSBsS68mUIXfNXFnGt2u4gPlsEdef3ERG2qdE588yaYnCqqlhDlfpi/kEV8gLSS4SWx0/wPjJPr/yXq3J32OuzG8uJUcb5eAmHymzo6lNQnYIojNY58Wt3MPTRk9Aq2y9EGFFC23qY5LRYVIAN2rZhBizsXMudo/co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719612486; c=relaxed/simple;
	bh=mavTUDf4kmD+B5MLQB0wFxB1hTb2sNbLlA4ZzKV0U/c=;
	h=Date:To:From:Subject:Message-Id; b=K/wyxrZh22U/PVELS4ANbKwQmfVF078fX0iobd21+bHx7ot8LtKh/FC9FT7HcQAYonC8sVLPuXyGw7RCilEoBbEG9WzPbJ9jiU2mXtnmEQ15xCcwUID0eqw3lad++LlbITz7EQi0hIEfTJSE3+nmj5f5HbS2Y75FIaOWIqp5glE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W84n8Mwr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W84n8Mwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFC1C116B1;
	Fri, 28 Jun 2024 22:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719612486;
	bh=mavTUDf4kmD+B5MLQB0wFxB1hTb2sNbLlA4ZzKV0U/c=;
	h=Date:To:From:Subject:From;
	b=W84n8Mwrgg5AA+Q4NCsvqxwImHxuth+cCGILKreeTvMlMcDVbSfX2FnT+WVngRS2I
	 rBER13PDE5wZ8ijUGEF9qz6gQN9T308cYIL2NqgjfWNHjjqPhsLPHogGoPG5Nj7Woz
	 qSioRRoksSNa1Gj/jrFCabSiyq8S1Icr0qgUHwUQ=
Date: Fri, 28 Jun 2024 15:08:05 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-guard-memcg1-specific-fields-accesses-in-mm-memcontrolc.patch added to mm-unstable branch
Message-Id: <20240628220806.2FFC1C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: guard memcg1-specific fields accesses in mm/memcontrol.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-guard-memcg1-specific-fields-accesses-in-mm-memcontrolc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-guard-memcg1-specific-fields-accesses-in-mm-memcontrolc.patch

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
Subject: mm: memcg: guard memcg1-specific fields accesses in mm/memcontrol.c
Date: Fri, 28 Jun 2024 21:03:13 +0000

There are only few memcg1-specific struct mem_cgroup's members accesses
left in mm/memcontrol.c.  Let's guard them with the CONFIG_MEMCG_V1 config
option.

Link: https://lkml.kernel.org/r/20240628210317.272856-6-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-guard-memcg1-specific-fields-accesses-in-mm-memcontrolc
+++ a/mm/memcontrol.c
@@ -3675,20 +3675,23 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
-		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 
 		page_counter_init(&memcg->memory, &parent->memory);
 		page_counter_init(&memcg->swap, &parent->swap);
+#ifdef CONFIG_MEMCG_V1
+		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 		page_counter_init(&memcg->kmem, &parent->kmem);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
+#endif
 	} else {
 		init_memcg_stats();
 		init_memcg_events();
 		page_counter_init(&memcg->memory, NULL);
 		page_counter_init(&memcg->swap, NULL);
+#ifdef CONFIG_MEMCG_V1
 		page_counter_init(&memcg->kmem, NULL);
 		page_counter_init(&memcg->tcpmem, NULL);
-
+#endif
 		root_mem_cgroup = memcg;
 		return &memcg->css;
 	}
@@ -3823,8 +3826,10 @@ static void mem_cgroup_css_reset(struct
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
+#ifdef CONFIG_MEMCG_V1
 	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
+#endif
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
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

