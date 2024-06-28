Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2F481728
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 22:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719612493; cv=none; b=EGMpf1cIAuk7/OC31s/qlBusCI1d6IA/VlpRz6krSKMVx1XPgZwEL2wBykTDXkJaXt5pOdoT5DT7oTX8skiMebsSpaK/Z3SRY5CH7acR+g/YFbI0tQ20io+VF9atEmNK9pUUhD32PGw4opQt8IaanCW89XRYD8AJmNoFp4mnnMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719612493; c=relaxed/simple;
	bh=2XxAZIQYi+7ThrwDul+lbegLIFV1kSQpCEykSufYW/I=;
	h=Date:To:From:Subject:Message-Id; b=aczYpk/z0u5V0rEe6lRm44WhOnj2+pAEKfxWtUy5s2RMl2Di+vcPIKMPqQQTQzWh/VXC7KRMG+OexKPApFDNp8IZ2pr4PMENrcsOFpR8pdcoKzrCPsf3/0RywUx3NG63zTsJKBx9JqpSQaPXzwsJhFrNQu5MLqz+YNuDYq2Rt5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kp9MwVUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kp9MwVUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EB2C116B1;
	Fri, 28 Jun 2024 22:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719612493;
	bh=2XxAZIQYi+7ThrwDul+lbegLIFV1kSQpCEykSufYW/I=;
	h=Date:To:From:Subject:From;
	b=kp9MwVUevavGsSqd7CYLj8/UfkIkTfnqEuN0ecbaAAUfIF/AIAN0kprvnLwO3CK8x
	 KWjXQ2Z8IRJmr67AmPCwxd4959x3SzOCxofRMakGM05G2ORacP1YkJCLzRlSYlTLaj
	 /NocYnqgMCCMT7u4YM9jatQiTWEElPYfowvYFBg8=
Date: Fri, 28 Jun 2024 15:08:13 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-put-struct-task_struct-in_user_fault-under-config_memcg_v1.patch added to mm-unstable branch
Message-Id: <20240628220813.86EB2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: put struct task_struct::in_user_fault under CONFIG_MEMCG_V1
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-put-struct-task_struct-in_user_fault-under-config_memcg_v1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-put-struct-task_struct-in_user_fault-under-config_memcg_v1.patch

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
Subject: mm: memcg: put struct task_struct::in_user_fault under CONFIG_MEMCG_V1
Date: Fri, 28 Jun 2024 21:03:17 +0000

The struct task_struct's in_user_fault member is not used by the cgroup
v2's memory controller, so it can be put under the CONFIG_MEMCG_V1 config
option.  To do so, mem_cgroup_enter_user_fault() and
mem_cgroup_exit_user_fault() are moved under the CONFIG_MEMCG_V1 option as
well.

Link: https://lkml.kernel.org/r/20240628210317.272856-10-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   40 +++++++++++++++++------------------
 include/linux/sched.h      |    2 -
 2 files changed, 21 insertions(+), 21 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-put-struct-task_struct-in_user_fault-under-config_memcg_v1
+++ a/include/linux/memcontrol.h
@@ -943,18 +943,6 @@ void mem_cgroup_print_oom_context(struct
 
 void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg);
 
-static inline void mem_cgroup_enter_user_fault(void)
-{
-	WARN_ON(current->in_user_fault);
-	current->in_user_fault = 1;
-}
-
-static inline void mem_cgroup_exit_user_fault(void)
-{
-	WARN_ON(!current->in_user_fault);
-	current->in_user_fault = 0;
-}
-
 struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
 					    struct mem_cgroup *oom_domain);
 void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
@@ -1402,14 +1390,6 @@ static inline void mem_cgroup_handle_ove
 {
 }
 
-static inline void mem_cgroup_enter_user_fault(void)
-{
-}
-
-static inline void mem_cgroup_exit_user_fault(void)
-{
-}
-
 static inline struct mem_cgroup *mem_cgroup_get_oom_group(
 	struct task_struct *victim, struct mem_cgroup *oom_domain)
 {
@@ -1890,6 +1870,18 @@ static inline void mem_cgroup_unlock_pag
 	rcu_read_unlock();
 }
 
+static inline void mem_cgroup_enter_user_fault(void)
+{
+	WARN_ON(current->in_user_fault);
+	current->in_user_fault = 1;
+}
+
+static inline void mem_cgroup_exit_user_fault(void)
+{
+	WARN_ON(!current->in_user_fault);
+	current->in_user_fault = 0;
+}
+
 #else /* CONFIG_MEMCG_V1 */
 static inline
 unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
@@ -1929,6 +1921,14 @@ static inline bool mem_cgroup_oom_synchr
 	return false;
 }
 
+static inline void mem_cgroup_enter_user_fault(void)
+{
+}
+
+static inline void mem_cgroup_exit_user_fault(void)
+{
+}
+
 #endif /* CONFIG_MEMCG_V1 */
 
 #endif /* _LINUX_MEMCONTROL_H */
--- a/include/linux/sched.h~mm-memcg-put-struct-task_struct-in_user_fault-under-config_memcg_v1
+++ a/include/linux/sched.h
@@ -934,7 +934,7 @@ struct task_struct {
 #ifndef TIF_RESTORE_SIGMASK
 	unsigned			restore_sigmask:1;
 #endif
-#ifdef CONFIG_MEMCG
+#ifdef CONFIG_MEMCG_V1
 	unsigned			in_user_fault:1;
 #endif
 #ifdef CONFIG_LRU_GEN
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

