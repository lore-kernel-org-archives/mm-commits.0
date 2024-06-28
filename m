Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7438B79B8E
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 22:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719612476; cv=none; b=dRXtzDjSncNw4RKLzLrVwVM2Zzf/Gq41ynjns5zC7BPtpLEKZZkTJMC7to0HAkSS1mdBlk+FhIwfvEhIy7XYAEgQCYEFng8J2Z+ImrQS8hiVSWE9el8SCvka6UWat7dRrqvnbVISMMCOcq7XmAqqkE/4YdM/exZEUScNF1kFfPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719612476; c=relaxed/simple;
	bh=uwySwJ8ATRYS/Ua1q6fP55RhZj80EakY9TmRfP8Em5c=;
	h=Date:To:From:Subject:Message-Id; b=h+DVcJSCBRHV8U8hTA2xLsu0DL2eCxaHuJFwTIv3eBk+8z56SNszJRln1S1rqOwqXRbuF+CRHrc+5RXtiYhk/NR7BTr0aIOVSevvHaYRiz7+n1PKXa0RmPsz6E0usTTMbSPe1ilNA8SCXtylLbDGYAjmmhEZI+qe8OQUcykdhK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Aue0+ELf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Aue0+ELf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F016DC116B1;
	Fri, 28 Jun 2024 22:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719612476;
	bh=uwySwJ8ATRYS/Ua1q6fP55RhZj80EakY9TmRfP8Em5c=;
	h=Date:To:From:Subject:From;
	b=Aue0+ELfKyFtuxxyQOHo9LxhgmbqkuoomzqX+0Mmro18th/XeXRETfe7LuQ4jps5L
	 H3/cMQ+lsfwkxo0MH2gHsSUMk/B0YM/0ulTdHnS0J7DL8V5RPaPmQVK+ZUkTAt9YJg
	 py1D4oW/dnqM3NXXjUNOyogKujkXMjSvFWeA+I5c=
Date: Fri, 28 Jun 2024 15:07:55 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-move-memcg_account_kmem-to-memcontrol-v1c.patch added to mm-unstable branch
Message-Id: <20240628220755.F016DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: move memcg_account_kmem() to memcontrol-v1.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-move-memcg_account_kmem-to-memcontrol-v1c.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-move-memcg_account_kmem-to-memcontrol-v1c.patch

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
Subject: mm: memcg: move memcg_account_kmem() to memcontrol-v1.c
Date: Fri, 28 Jun 2024 21:03:09 +0000

Patch series "mm: memcg: put cgroup v1-specific memcg data under
CONFIG_MEMCG_V1".

This patchset puts all cgroup v1's members of struct mem_cgroup, struct
mem_cgroup_per_node and struct task_struct under the CONFIG_MEMCG_V1
config option.  If cgroup v1 support is not required (and it's true for
many cgroup users these days), it allows to save a bit of memory and
compile out some code, some of which is on relatively hot paths.  It also
structures the code a bit better by grouping cgroup v1-specific stuff in
one place.


This patch (of 9):

memcg_account_kmem() consists of a trivial statistics change via
mod_memcg_state() call and a relatively large memcg1-specific part.

Let's factor out the mod_memcg_state() call and move the rest into the
mm/memcontrol-v1.c file.  Also rename memcg_account_kmem() into
memcg1_account_kmem() for consistency.

Link: https://lkml.kernel.org/r/20240628210317.272856-1-roman.gushchin@linux.dev
Link: https://lkml.kernel.org/r/20240628210317.272856-2-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   12 ++++++++++++
 mm/memcontrol-v1.h |    2 ++
 mm/memcontrol.c    |   31 ++++++++++---------------------
 3 files changed, 24 insertions(+), 21 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-move-memcg_account_kmem-to-memcontrol-v1c
+++ a/mm/memcontrol.c
@@ -1721,7 +1721,6 @@ static DEFINE_MUTEX(percpu_charge_mutex)
 static struct obj_cgroup *drain_obj_stock(struct memcg_stock_pcp *stock);
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
-static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 
 #else
 static inline struct obj_cgroup *drain_obj_stock(struct memcg_stock_pcp *stock)
@@ -1733,9 +1732,6 @@ static bool obj_stock_flush_required(str
 {
 	return false;
 }
-static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages)
-{
-}
 #endif
 
 /**
@@ -2645,18 +2641,6 @@ struct obj_cgroup *get_obj_cgroup_from_f
 	return objcg;
 }
 
-static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages)
-{
-	mod_memcg_state(memcg, MEMCG_KMEM, nr_pages);
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
-		if (nr_pages > 0)
-			page_counter_charge(&memcg->kmem, nr_pages);
-		else
-			page_counter_uncharge(&memcg->kmem, -nr_pages);
-	}
-}
-
-
 /*
  * obj_cgroup_uncharge_pages: uncharge a number of kernel pages from a objcg
  * @objcg: object cgroup to uncharge
@@ -2669,7 +2653,8 @@ static void obj_cgroup_uncharge_pages(st
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	memcg_account_kmem(memcg, -nr_pages);
+	mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
+	memcg1_account_kmem(memcg, -nr_pages);
 	refill_stock(memcg, nr_pages);
 
 	css_put(&memcg->css);
@@ -2695,7 +2680,8 @@ static int obj_cgroup_charge_pages(struc
 	if (ret)
 		goto out;
 
-	memcg_account_kmem(memcg, nr_pages);
+	mod_memcg_state(memcg, MEMCG_KMEM, nr_pages);
+	memcg1_account_kmem(memcg, nr_pages);
 out:
 	css_put(&memcg->css);
 
@@ -2848,7 +2834,8 @@ static struct obj_cgroup *drain_obj_stoc
 
 			memcg = get_mem_cgroup_from_objcg(old);
 
-			memcg_account_kmem(memcg, -nr_pages);
+			mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
+			memcg1_account_kmem(memcg, -nr_pages);
 			__refill_stock(memcg, nr_pages);
 
 			css_put(&memcg->css);
@@ -4809,8 +4796,10 @@ static void uncharge_batch(const struct
 		page_counter_uncharge(&ug->memcg->memory, ug->nr_memory);
 		if (do_memsw_account())
 			page_counter_uncharge(&ug->memcg->memsw, ug->nr_memory);
-		if (ug->nr_kmem)
-			memcg_account_kmem(ug->memcg, -ug->nr_kmem);
+		if (ug->nr_kmem) {
+			mod_memcg_state(ug->memcg, MEMCG_KMEM, -ug->nr_kmem);
+			memcg1_account_kmem(ug->memcg, -ug->nr_kmem);
+		}
 		memcg1_oom_recover(ug->memcg);
 	}
 
--- a/mm/memcontrol-v1.c~mm-memcg-move-memcg_account_kmem-to-memcontrol-v1c
+++ a/mm/memcontrol-v1.c
@@ -2913,6 +2913,18 @@ struct cftype memsw_files[] = {
 	{ },	/* terminate */
 };
 
+#ifdef CONFIG_MEMCG_KMEM
+void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages)
+{
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		if (nr_pages > 0)
+			page_counter_charge(&memcg->kmem, nr_pages);
+		else
+			page_counter_uncharge(&memcg->kmem, -nr_pages);
+	}
+}
+#endif /* CONFIG_MEMCG_KMEM */
+
 static int __init memcg1_init(void)
 {
 	int node;
--- a/mm/memcontrol-v1.h~mm-memcg-move-memcg_account_kmem-to-memcontrol-v1c
+++ a/mm/memcontrol-v1.h
@@ -107,6 +107,7 @@ void memcg1_check_events(struct mem_cgro
 
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
 
+void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 extern struct cftype memsw_files[];
 extern struct cftype mem_cgroup_legacy_files[];
 
@@ -125,6 +126,7 @@ static inline void memcg1_check_events(s
 
 static inline void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s) {}
 
+static inline void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages) {}
 extern struct cftype memsw_files[];
 extern struct cftype mem_cgroup_legacy_files[];
 #endif	/* CONFIG_MEMCG_V1 */
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

