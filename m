Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C4110A35
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141629; cv=none; b=llQnEGqd74W0Ww/yF8k1ol0y/Shbxtqx+OGUC10Z2LvDRWXKfVM0392O7qwl9iRCFzLC+g+68jsTtBbpug7WyHRqtzYK0LnEZ/7HNaS/dwhwhatVB1Z5ZFyLJ4ivX9pHdTFlknXpiOL1Xv/ElS9CRnbeaCn9T0WmOsHWSmtiwAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141629; c=relaxed/simple;
	bh=ivVI378IZX+h5+DvJ9uTCb9L3AfalxSI/UFqqQxUMPs=;
	h=Date:To:From:Subject:Message-Id; b=ffFWQ6u/xGHenhsxI2ucKdL9dVNA15bcMCZWKq6tmsFxEAh9bZyf0fddLv8KPML5re5wJfMj6rM32lYn6W5VM5cxOgOJdUNTZQR1vl2onb+Jbb+5co3s89RqhyaokTJgh66ymEY4nL2v44tzY5+iGOc2bViTwBI9bBlM4LZR/5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IHgxFQj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IHgxFQj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A653C4AF07;
	Fri,  5 Jul 2024 01:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141628;
	bh=ivVI378IZX+h5+DvJ9uTCb9L3AfalxSI/UFqqQxUMPs=;
	h=Date:To:From:Subject:From;
	b=IHgxFQj6pNzZAfYmcIgVR/roQAKvvrJ5HGkf9gSifkAqa8lJR/cPX5/hA/6VGLSw8
	 rXNkARZ0/JU9Lz6UdH+IXOAolfAtgCx8PaCw+WPU9MojMQ1hwcOUav3kvLxYx3lUpU
	 eed50Ws4emPKl48LurFi5in3JFch7mNtI3Rh8xDs=
Date: Thu, 04 Jul 2024 18:07:07 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-put-struct-task_struct-in_user_fault-under-config_memcg_v1.patch removed from -mm tree
Message-Id: <20240705010708.6A653C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: put struct task_struct::in_user_fault under CONFIG_MEMCG_V1
has been removed from the -mm tree.  Its filename was
     mm-memcg-put-struct-task_struct-in_user_fault-under-config_memcg_v1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
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

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

