Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F51413246
	for <mm-commits@vger.kernel.org>; Thu, 30 Apr 2026 13:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777554834; cv=none; b=qmKnZm8lVRXJ5kA6epv+hrjwvI1qNDBIEknuapysaRMFtjX4Ss5ia/me9v1GieDtcn0bB4UQ7fMDYxdDEm1MCJRM08Sl9jPvzGpNvuV6ohA3A0yj47xYcsoBOjfic/P7sBQQ8xkLYzH1n8OAIJCrVV1Kmw+HvO/xJeQOA7AUQKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777554834; c=relaxed/simple;
	bh=q6q+VtRGVwL12dR9oynXSzNDuNZ/Iyn4MDMvBXcndo8=;
	h=Date:To:From:Subject:Message-Id; b=brSKtLsiQrZdOUJBjdhjpPTYkWtSuxiuLSazPg9NJQhnGPOU8XfAX9yqanYYwDbxZZF1q69fVscZ1Qlqfv1NfPgCKOgxeS2ZqVdBAOQ9zXPoHra8GkBEApIvrQ0jM7MXzDqnICgY1YOdxgZXJz8LBLcKE/Qqo9ikZ1G8NCmOvZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q50mo5i4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q50mo5i4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABC3C2BCB8;
	Thu, 30 Apr 2026 13:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777554833;
	bh=q6q+VtRGVwL12dR9oynXSzNDuNZ/Iyn4MDMvBXcndo8=;
	h=Date:To:From:Subject:From;
	b=q50mo5i4jSLsPI2RyYTG8hsDMqbKSnlhAACNRo53Zz8DzaKqVWrbRc7yRL/IdWiQn
	 wvpilG2aUkKs6KMciRxD2XJerKEbGsjHJ4vFHfxRQ+PTtTsHx3wXTJlsdWQmp7WwI+
	 kHDAEV4qjoYfwpIuKrNWUchfUFF6kJTWddgxsZeY=
Date: Thu, 30 Apr 2026 06:13:52 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memcontrol-fix-rcu-unbalance-in-get_non_dying_memcg_end.patch removed from -mm tree
Message-Id: <20260430131353.1ABC3C2BCB8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: fix rcu unbalance in get_non_dying_memcg_end()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-rcu-unbalance-in-get_non_dying_memcg_end.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: memcontrol: fix rcu unbalance in get_non_dying_memcg_end()
Date: Wed, 29 Apr 2026 15:31:05 +0800

Currently, get_non_dying_memcg_start() and get_non_dying_memcg_end() both
evaluate cgroup_subsys_on_dfl(memory_cgrp_subsys) independently to
determine whether to acquire or release the RCU read lock.

However, the result of cgroup_subsys_on_dfl() can change dynamically at
runtime due to cgroup hierarchy rebinding (e.g., when the memory
controller is moved between cgroup v1 and v2 hierarchies).  This can cause
the following warning:

 =====================================
 WARNING: bad unlock balance detected!
 7.0.0-next-20260420+ #83 Tainted: G        W
 -------------------------------------
 memcg-repro/270 is trying to release lock (rcu_read_lock) at:
 [<ffffffff815f57f7>] rcu_read_unlock+0x17/0x60
 but there are no more locks to release!

 other info that might help us debug this:
 1 lock held by memcg-repro/270:
  #0: ffff888102fa2088 (vm_lock){++++}-{0:0}, at: do_user_addr_fault+0x285/0x880

 stack backtrace:
 CPU: 0 UID: 0 PID: 270 Comm: memcg-repro Tainted: G        W           7.0.0-next-20260420+ #
 Tainted: [W]=WARN
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
 Call Trace:
  <TASK>
  ? rcu_read_unlock+0x17/0x60
  dump_stack_lvl+0x77/0xb0
  print_unlock_imbalance_bug+0xe0/0xf0
  ? rcu_read_unlock+0x17/0x60
  lock_release+0x21d/0x2a0
  rcu_read_unlock+0x1c/0x60
  do_pte_missing+0x233/0xb40
  __handle_mm_fault+0x80e/0xcd0
  handle_mm_fault+0x146/0x310
  do_user_addr_fault+0x303/0x880
  exc_page_fault+0x9b/0x270
  asm_exc_page_fault+0x26/0x30
 RIP: 0033:0x5590e4eb41ea
 Code: 61 cc 66 0f 6f e0 66 0f 61 c2 66 0f db cd 66 0f 69 e2 66 0f 6f d0 66 0f 69 d4 66 0f 61 0
 RSP: 002b:00007ffcad25f030 EFLAGS: 00010202
 RAX: 00005590e4eb8010 RBX: 00007ffcad260f7d RCX: 00007f73c474d44d
 RDX: 00005590e4eb80a0 RSI: 00005590e4eb503c RDI: 000000000000000f
 RBP: 00005590e4eb70a0 R08: 0000000000000000 R09: 00007f73c483a680
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
 R13: 00007ffcad25f180 R14: 00005590e4eb6dd8 R15: 00007f73c4869020
  </TASK>
 ------------[ cut here ]------------

Fix this by explicitly tracking the RCU lock state, ensuring that
rcu_read_unlock() in get_non_dying_memcg_end() is strictly paired with the
lock acquisition, regardless of any runtime rebinding events.

Link: https://lore.kernel.org/20260429073105.44472-1-qi.zheng@linux.dev
Fixes: 8285917d6f38 ("mm: memcontrol: prepare for reparenting non-hierarchical stats")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-rcu-unbalance-in-get_non_dying_memcg_end
+++ a/mm/memcontrol.c
@@ -805,12 +805,17 @@ static long memcg_state_val_in_pages(int
  * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race with
  * reparenting of non-hierarchical state_locals.
  */
-static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg)
+static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
+							   bool *rcu_locked)
 {
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	/* Rebinding can cause this value to be changed at runtime */
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		*rcu_locked = false;
 		return memcg;
+	}
 
 	rcu_read_lock();
+	*rcu_locked = true;
 
 	while (memcg_is_dying(memcg))
 		memcg = parent_mem_cgroup(memcg);
@@ -818,20 +823,21 @@ static inline struct mem_cgroup *get_non
 	return memcg;
 }
 
-static inline void get_non_dying_memcg_end(void)
+static inline void get_non_dying_memcg_end(bool rcu_locked)
 {
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (!rcu_locked)
 		return;
 
 	rcu_read_unlock();
 }
 #else
-static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg)
+static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
+							   bool *rcu_locked)
 {
 	return memcg;
 }
 
-static inline void get_non_dying_memcg_end(void)
+static inline void get_non_dying_memcg_end(bool rcu_locked)
 {
 }
 #endif
@@ -865,12 +871,14 @@ static void __mod_memcg_state(struct mem
 void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
 		       int val)
 {
+	bool rcu_locked = false;
+
 	if (mem_cgroup_disabled())
 		return;
 
-	memcg = get_non_dying_memcg_start(memcg);
+	memcg = get_non_dying_memcg_start(memcg, &rcu_locked);
 	__mod_memcg_state(memcg, idx, val);
-	get_non_dying_memcg_end();
+	get_non_dying_memcg_end(rcu_locked);
 }
 
 #ifdef CONFIG_MEMCG_V1
@@ -933,14 +941,15 @@ static void mod_memcg_lruvec_state(struc
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup *memcg;
+	bool rcu_locked = false;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = get_non_dying_memcg_start(pn->memcg);
+	memcg = get_non_dying_memcg_start(pn->memcg, &rcu_locked);
 	pn = memcg->nodeinfo[pgdat->node_id];
 
 	__mod_memcg_lruvec_state(pn, idx, val);
 
-	get_non_dying_memcg_end();
+	get_non_dying_memcg_end(rcu_locked);
 }
 
 /**
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


