Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197AA79B8E
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 22:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719612479; cv=none; b=JvbwL1z9fVYykR+i7RhQW+dvr+RzKQ1kROZEn69qBvDxfgbk9ho7Y4jhEISk2QjvJ4CayCZ80Sugqeve/c/6U2a/wLYj9YjoZRj7WqMBVZe0iMjVZUjTwZvR5Ex7YEEHASjwDLtwb3ZCUS/eeP//H5UTB0aSv0YWFe5lxbQeGVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719612479; c=relaxed/simple;
	bh=VrJQOzqjAKoS6tJxpI3mEt1vvx9x+DBJ7oH70JjkVVA=;
	h=Date:To:From:Subject:Message-Id; b=nCX/VHZEgBkEeM6wyyVKHMvHvkigHTH2PFtpuPFsnZtMeJVO+wQmRmlRZzk9QuGenYa2GPqk2jKj79mhDtjXNEpgRVdXUzxTzB+utlZgVZsUwiUAQV315d1u2UufbjNSnbsfRAFujphhWLD2ipheWgfsT2uPiz4iPLxK69VbgJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yGtWSaDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yGtWSaDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94642C116B1;
	Fri, 28 Jun 2024 22:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719612478;
	bh=VrJQOzqjAKoS6tJxpI3mEt1vvx9x+DBJ7oH70JjkVVA=;
	h=Date:To:From:Subject:From;
	b=yGtWSaDDBilDd/89EXwDYueJWquh10ODKZ0P307Ews57V9gBOusquufujarSyxLDr
	 4x1qf/EZD51FK4rhYpYuda7A0sl3ZnxT5q6Rmrylx58oOCsRyYEX0hikfgWBHeL5v5
	 d5+YbS0cI+md0QDs0DipDx6Xu6WCbYbS45nt3QB0=
Date: Fri, 28 Jun 2024 15:07:58 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-factor-out-legacy-socket-memory-accounting-code.patch added to mm-unstable branch
Message-Id: <20240628220758.94642C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: factor out legacy socket memory accounting code
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-factor-out-legacy-socket-memory-accounting-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-factor-out-legacy-socket-memory-accounting-code.patch

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
Subject: mm: memcg: factor out legacy socket memory accounting code
Date: Fri, 28 Jun 2024 21:03:10 +0000

Move out the legacy cgroup v1 socket memory accounting code into
mm/memcontrol-v1.c.

This commit introduces three new functions: memcg1_tcpmem_active(),
memcg1_charge_skmem() and memcg1_uncharge_skmem(), which contain all
cgroup v1-specific code and become trivial if CONFIG_MEMCG_V1 isn't set.

Note, that !!memcg->tcpmem_pressure check in
mem_cgroup_under_socket_pressure() can't be easily moved into
memcontrol-v1.h without including memcontrol-v1.h from memcontrol.h which
isn't a good idea, so it's better to just #ifdef it.

Link: https://lkml.kernel.org/r/20240628210317.272856-3-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 ++
 mm/memcontrol-v1.c         |   17 +++++++++++++++++
 mm/memcontrol-v1.h         |   16 ++++++++++++++++
 mm/memcontrol.c            |   22 +++++-----------------
 4 files changed, 40 insertions(+), 17 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-factor-out-legacy-socket-memory-accounting-code
+++ a/include/linux/memcontrol.h
@@ -1650,8 +1650,10 @@ void mem_cgroup_sk_alloc(struct sock *sk
 void mem_cgroup_sk_free(struct sock *sk);
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
+#ifdef CONFIG_MEMCG_V1
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return !!memcg->tcpmem_pressure;
+#endif /* CONFIG_MEMCG_V1 */
 	do {
 		if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
 			return true;
--- a/mm/memcontrol.c~mm-memcg-factor-out-legacy-socket-memory-accounting-code
+++ a/mm/memcontrol.c
@@ -3791,7 +3791,7 @@ static void mem_cgroup_css_free(struct c
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
 
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_active)
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg1_tcpmem_active(memcg))
 		static_branch_dec(&memcg_sockets_enabled_key);
 
 #if defined(CONFIG_MEMCG_KMEM)
@@ -5016,7 +5016,7 @@ void mem_cgroup_sk_alloc(struct sock *sk
 	memcg = mem_cgroup_from_task(current);
 	if (mem_cgroup_is_root(memcg))
 		goto out;
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcpmem_active)
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg1_tcpmem_active(memcg))
 		goto out;
 	if (css_tryget(&memcg->css))
 		sk->sk_memcg = memcg;
@@ -5042,20 +5042,8 @@ void mem_cgroup_sk_free(struct sock *sk)
 bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 			     gfp_t gfp_mask)
 {
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
-		struct page_counter *fail;
-
-		if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
-			memcg->tcpmem_pressure = 0;
-			return true;
-		}
-		memcg->tcpmem_pressure = 1;
-		if (gfp_mask & __GFP_NOFAIL) {
-			page_counter_charge(&memcg->tcpmem, nr_pages);
-			return true;
-		}
-		return false;
-	}
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return memcg1_charge_skmem(memcg, nr_pages, gfp_mask);
 
 	if (try_charge(memcg, gfp_mask, nr_pages) == 0) {
 		mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
@@ -5073,7 +5061,7 @@ bool mem_cgroup_charge_skmem(struct mem_
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
-		page_counter_uncharge(&memcg->tcpmem, nr_pages);
+		memcg1_uncharge_skmem(memcg, nr_pages);
 		return;
 	}
 
--- a/mm/memcontrol-v1.c~mm-memcg-factor-out-legacy-socket-memory-accounting-code
+++ a/mm/memcontrol-v1.c
@@ -2925,6 +2925,23 @@ void memcg1_account_kmem(struct mem_cgro
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
+bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
+			 gfp_t gfp_mask)
+{
+	struct page_counter *fail;
+
+	if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
+		memcg->tcpmem_pressure = 0;
+		return true;
+	}
+	memcg->tcpmem_pressure = 1;
+	if (gfp_mask & __GFP_NOFAIL) {
+		page_counter_charge(&memcg->tcpmem, nr_pages);
+		return true;
+	}
+	return false;
+}
+
 static int __init memcg1_init(void)
 {
 	int node;
--- a/mm/memcontrol-v1.h~mm-memcg-factor-out-legacy-socket-memory-accounting-code
+++ a/mm/memcontrol-v1.h
@@ -108,6 +108,17 @@ void memcg1_check_events(struct mem_cgro
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
 
 void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
+static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
+{
+	return memcg->tcpmem_active;
+}
+bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
+			 gfp_t gfp_mask);
+static inline void memcg1_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	page_counter_uncharge(&memcg->tcpmem, nr_pages);
+}
+
 extern struct cftype memsw_files[];
 extern struct cftype mem_cgroup_legacy_files[];
 
@@ -127,6 +138,11 @@ static inline void memcg1_check_events(s
 static inline void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s) {}
 
 static inline void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages) {}
+static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg) { return false; }
+static inline bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
+				       gfp_t gfp_mask) { return true; }
+static inline void memcg1_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages) {}
+
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

