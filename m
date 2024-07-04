Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D2C2581
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 01:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720058022; cv=none; b=j9kvwHshK8Go2EZ23Nbl6AoU+EmzI7Ur6vK0V2S9g8qXXX9/dXuZMAZoyzwMGdiBVHP7+lekMCOwO3TjEEGqQ+R7k8gpU/gaF/isVk6QGYQIlL3tS+tJhDrMaNBnL5CfjFiDJS1GoUjXhduSGDnXW0tVP1jE7PLoOSxn9m7B4KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720058022; c=relaxed/simple;
	bh=Ebwc+ss2MzmJVcuMi9HMIqFRbAN6GWfFjGjoRjlbwMs=;
	h=Date:To:From:Subject:Message-Id; b=aTjZzVYJ2KxsXwvYij3oTKmV73MgEUqfXcAJ5/o4kqZYgcUTLT/TSZvIZtPrhjg9S/8FRq2pEPEO7BVLMlgB0M2Jo/5rNAl1ZPEpbjy2FaB7/nwZyjepAfaqOrTsJM91AW9HZ0gP5XmSEq95/65A6W55HpZ9t05rwrOIlDXP1t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CRlXfiyA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CRlXfiyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010F8C2BD10;
	Thu,  4 Jul 2024 01:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720058022;
	bh=Ebwc+ss2MzmJVcuMi9HMIqFRbAN6GWfFjGjoRjlbwMs=;
	h=Date:To:From:Subject:From;
	b=CRlXfiyAKCXChK983b4zsfw7F23ONgi6uvGEgVXyFXhttoZXkhbC7aDAj1zp/jfol
	 7PoI+7HWj4hDmyj/E1idZW3wPeSXN6pbOm95BJEdR+DFDtSBjeTSMsqPIvvkWYXmQw
	 /AC4SYgDeMdHXTQeK85kqGs6/th6UyyBWaJUFSuk=
Date: Wed, 03 Jul 2024 18:53:41 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix.patch added to mm-unstable branch
Message-Id: <20240704015342.010F8C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix.patch

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
Subject: mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix
Date: Thu, 4 Jul 2024 00:27:12 +0000

I forgot to actually move two functions mem_cgroup_node_nr_lru_pages()
and mem_cgroup_nr_lru_pages() into mm/memcontrol-v1.c, so that they remain
in mm/memcontrol.c and their commented out duplicated versions in
mm/memcontrol-v1.c.

Link: https://lkml.kernel.org/r/20240704002712.2077812-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   74 +++++++++++++++++++++----------------------
 mm/memcontrol-v1.h |    5 --
 mm/memcontrol.c    |   38 ----------------------
 3 files changed, 37 insertions(+), 80 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix
+++ a/mm/memcontrol.c
@@ -3188,44 +3188,6 @@ static void memcg_offline_kmem(struct me
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
-unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
-					   int nid, unsigned int lru_mask,
-					   bool tree)
-{
-	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
-	unsigned long nr = 0;
-	enum lru_list lru;
-
-	VM_BUG_ON((unsigned)nid >= nr_node_ids);
-
-	for_each_lru(lru) {
-		if (!(BIT(lru) & lru_mask))
-			continue;
-		if (tree)
-			nr += lruvec_page_state(lruvec, NR_LRU_BASE + lru);
-		else
-			nr += lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
-	}
-	return nr;
-}
-
-unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
-				      unsigned int lru_mask, bool tree)
-{
-	unsigned long nr = 0;
-	enum lru_list lru;
-
-	for_each_lru(lru) {
-		if (!(BIT(lru) & lru_mask))
-			continue;
-		if (tree)
-			nr += memcg_page_state(memcg, NR_LRU_BASE + lru);
-		else
-			nr += memcg_page_state_local(memcg, NR_LRU_BASE + lru);
-	}
-	return nr;
-}
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 #include <trace/events/writeback.h>
--- a/mm/memcontrol-v1.c~mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix
+++ a/mm/memcontrol-v1.c
@@ -2494,43 +2494,43 @@ static ssize_t mem_cgroup_reset(struct k
 #define LRU_ALL_ANON (BIT(LRU_INACTIVE_ANON) | BIT(LRU_ACTIVE_ANON))
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
-/* static unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg, */
-/* 				int nid, unsigned int lru_mask, bool tree) */
-/* { */
-/* 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid)); */
-/* 	unsigned long nr = 0; */
-/* 	enum lru_list lru; */
-
-/* 	VM_BUG_ON((unsigned)nid >= nr_node_ids); */
-
-/* 	for_each_lru(lru) { */
-/* 		if (!(BIT(lru) & lru_mask)) */
-/* 			continue; */
-/* 		if (tree) */
-/* 			nr += lruvec_page_state(lruvec, NR_LRU_BASE + lru); */
-/* 		else */
-/* 			nr += lruvec_page_state_local(lruvec, NR_LRU_BASE + lru); */
-/* 	} */
-/* 	return nr; */
-/* } */
-
-/* static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg, */
-/* 					     unsigned int lru_mask, */
-/* 					     bool tree) */
-/* { */
-/* 	unsigned long nr = 0; */
-/* 	enum lru_list lru; */
-
-/* 	for_each_lru(lru) { */
-/* 		if (!(BIT(lru) & lru_mask)) */
-/* 			continue; */
-/* 		if (tree) */
-/* 			nr += memcg_page_state(memcg, NR_LRU_BASE + lru); */
-/* 		else */
-/* 			nr += memcg_page_state_local(memcg, NR_LRU_BASE + lru); */
-/* 	} */
-/* 	return nr; */
-/* } */
+static unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
+				int nid, unsigned int lru_mask, bool tree)
+{
+	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+	unsigned long nr = 0;
+	enum lru_list lru;
+
+	VM_BUG_ON((unsigned)nid >= nr_node_ids);
+
+	for_each_lru(lru) {
+		if (!(BIT(lru) & lru_mask))
+			continue;
+		if (tree)
+			nr += lruvec_page_state(lruvec, NR_LRU_BASE + lru);
+		else
+			nr += lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
+	}
+	return nr;
+}
+
+static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
+					     unsigned int lru_mask,
+					     bool tree)
+{
+	unsigned long nr = 0;
+	enum lru_list lru;
+
+	for_each_lru(lru) {
+		if (!(BIT(lru) & lru_mask))
+			continue;
+		if (tree)
+			nr += memcg_page_state(memcg, NR_LRU_BASE + lru);
+		else
+			nr += memcg_page_state_local(memcg, NR_LRU_BASE + lru);
+	}
+	return nr;
+}
 
 static int memcg_numa_stat_show(struct seq_file *m, void *v)
 {
--- a/mm/memcontrol-v1.h~mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix
+++ a/mm/memcontrol-v1.h
@@ -88,11 +88,6 @@ void memcg1_oom_finish(struct mem_cgroup
 void memcg1_oom_recover(struct mem_cgroup *memcg);
 
 void drain_all_stock(struct mem_cgroup *root_memcg);
-unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
-				      unsigned int lru_mask, bool tree);
-unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
-					   int nid, unsigned int lru_mask,
-					   bool tree);
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
 unsigned long memcg_events_local(struct mem_cgroup *memcg, int event);
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
mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix.patch
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

