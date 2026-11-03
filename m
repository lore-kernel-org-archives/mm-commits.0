Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672161;
	b=Bvakm91iZW9vIWagrAh9ObwVVBmTrLuzEFdoiDXv1j6/dyxyDEd+Cyz6DnAzc33gqzjG
	 6IABVGhPTB4RmXaI+L8aIGeg8OJk+xIc9PeykuHZyZEdpCLgdJLNgSwCuyQFwlmIyS3S8
	 3ghFjzNbumVsaMZy4JjrOTHxyWf/yFTVCuYIPufTjsu7/qywc8tgcA0lwxuk2O0BNAMAM
	 T8DklDFvmR2DouYSnk/IHvIKiFvRryZLcgObS5mgrzF/5h1rDMs4Z6tq926XjaYCSuJnO
	 w2emSoop1HAFz20fxwAYV7AAvWRThSL9ej3wTSJR9UPfgf7EP+h2ME8S77yZitEeWpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672161;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Am9iH8pLIC1iHu+9hT4vi+4H5wJkXIpPbDXInEhtGno=;
	b=PfW/NSETraz7Oh0AaxG76T9MksQmX97SV+qvfK8LqCCLFhJb/NNB65y0RCsBxButJkbM
	 nKxOKvTcQOnb4NzUZea01XuN/daV74Rn1+f5PgX4GsCt/kGPG6L9Nzu2MxIFBRBptWlbY
	 g9lEhzi2lpsNVVU/FJFAIzBKnxpvm7jua/5tV8jz1cUOTIPX67GA8aAfCfKVAxkxDXPNP
	 D86T9yAA89bEC5aBWIZmbuBS4B4vdP7fUBpeJMID1eh9O8UBqxsDYgTNGImVH4m34Wy4h
	 qgA+dRlO9h+1+RA9jWZLC9HukXZTiZYP1R/ONCjS8kOC7A0I0koA7UKw5Ne4Nnz6OPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MMuSkJ3x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BB8606D801;
	Tue,  3 Nov 2026 02:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MMuSkJ3x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247671F00919;
	Tue,  3 Nov 2026 02:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672161;
	bh=Am9iH8pLIC1iHu+9hT4vi+4H5wJkXIpPbDXInEhtGno=;
	h=Date:To:From:Subject;
	b=MMuSkJ3x4Vj8KYcguevIOQRWLspLYekHkR4uTKEIb9ZBTOBKVhShSCRDW6p68mJpg
	 Zrq2y+zk3pq2z3PGTqaCg7kuBxKqJS9s5R4PC3/CI/qwAR1YbdYese14yzjY2ER+Pt
	 lwcTtOvlnRw4xlzrRnE4J83hlth+cZxavE/Vh/p0=
Date: Mon, 02 Nov 2026 18:16:00 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,
	mhocko@suse.com,mhocko@kernel.org,jp.kobryn@linux.dev,hannes@cmpxchg.org,
	tjmercier@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memcontrol-fix-null-pointer-deref-and-uaf-from-high_work_func-on-dying-memcg.patch removed from -mm tree
Message-Id: <20261103021601.247671F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: memcontrol: fix NULL pointer deref and UAF from high_work_func() on dying memcg
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-null-pointer-deref-and-uaf-from-high_work_func-on-dying-memcg.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "T.J. Mercier" <tjmercier@google.com>
Subject: mm: memcontrol: fix NULL pointer deref and UAF from high_work_func() on dying memcg
Date: Thu, 29 Oct 2026 13:18:58 -0700

When memory.high is exceeded in non-task context, try_charge_memcg()
schedules memcg->high_work without taking a reference on the memcg, and
high_work_func() invokes reclaim_high() without pinning the memcg.

With obj_cgroup reparenting, introduced in commit bf4f059954dc ("mm:
memcg/slab: obj_cgroup API"), objects charged to a child memcg are
reparented to its parent in mem_cgroup_css_offline() instead of holding a
reference on the child until uncharged.  Subsequent uncharges of those
objects go to the parent, which can leave the child's memory use
permanently above its high limit, so any later charge on the offlined
memcg in non-task context schedules high_work.  This was later widened
from kernel memory to LRU folios when commit f1cf8d2f36dc ("mm:
memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
converted LRU folios to use obj_cgroup reparenting.

cancel_work_sync(&memcg->high_work) only runs at the end of teardown in
mem_cgroup_css_free(), so high_work_func() can start or still be running
reclaim_high() after mem_cgroup_css_released() or shrink_many() has called
lru_gen_release_memcg() and unhashed lruvec->lrugen.list.  If reclaim
tries to rotate the memcg, lru_gen_rotate_memcg() dereferences a NULL
pprev pointer.  This issue is specific to MGLRU and was introduced with
the memcg LRU in commit e4dde56cd208 ("mm: multi-gen LRU: per-node
lru_gen_folio lists").

With either traditional LRU or MGLRU, css_free_rwork_fn() calls
css_rstat_exit() which frees per-CPU rstat data before calling
mem_cgroup_css_free().  If reclaim_high() is still running, rstat updates
via mod_lruvec_state() -> __css_rstat_updated() cause a use-after-free on
the per-CPU rstat data.  This was introduced when commit 5da3bfa029d6
("cgroup: use separate rstat trees for each subsystem") moved
css_rstat_exit() ahead of ss->css_free().

Fix both problems by acquiring a reference with css_tryget_online() in
high_work_func() before calling reclaim_high(), and by resetting
memory.high and swap.high to PAGE_COUNTER_MAX in mem_cgroup_css_offline()
so that charges via references on an offlined memcg do not trigger
high_work on the dead child and skip checking live ancestors in
try_charge_memcg().

Acquiring the reference in high_work_func() rather than before scheduling
high_work is safe because mem_cgroup_css_free() calls irq_work_sync() and
cancel_work_sync() which cancels pending work and waits for an already
running high_work_func() to complete before mem_cgroup_free() frees the
memcg.  css_tryget_online() uses percpu_ref_tryget_live() and is safe to
call after percpu_ref_exit() before the cgroup is freed unlike
css_tryget().

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W           7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full)
Tainted: [B]=BAD_PAGE, [W]=WARN  <-- Taint from lru_gen_rotate_memcg() VM_WARN_ON_ONCE
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
Workqueue: events high_work_func
RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
Call Trace:
 <TASK>
 ? read_ctrl_pos+0x22f/0x3f0
 shrink_lruvec+0x16cb/0x1b80
 ? ret_from_fork_asm+0x1a/0x30
 ? lapic_next_event+0x15/0x20
 ? clockevents_program_event+0x2bb/0x6f0
 ? lapic_next_event+0x15/0x20
 ? __pfx_shrink_lruvec+0x10/0x10
 ? __pfx_clockevents_program_event+0x10/0x10
 ? _raw_spin_lock+0x84/0xe0
 ? __pfx__raw_spin_lock+0x10/0x10
 ? kasan_save_stack+0x30/0x50
 ? psi_group_change+0x381/0x740
 ? __pfx_sched_clock_cpu+0x10/0x10
 ? save_fpregs_to_fpstate+0xc4/0x2c0
 ? finish_task_switch.isra.0+0x1de/0xac0
 ? __schedule+0xf62/0x42c0
 ? __pfx___schedule+0x10/0x10
 ? __pfx___irq_work_queue_local+0x10/0x10
 ? shrink_node+0x626/0x31e0
 shrink_node+0x626/0x31e0
 ? ring_buffer_unlock_commit+0x11d/0x5c0
 ? kswapd_clear_hopeless+0xa0/0x150
 ? __pfx_shrink_node+0x10/0x10
 ? 0xffffffffc0000095
 do_try_to_free_pages+0x255/0x13b0
 ? ring_buffer_unlock_commit+0x11d/0x5c0
 ? reclaim_high+0x10a/0x1b0
 try_to_free_mem_cgroup_pages+0x1f9/0x5a0
 ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
 ? irqentry_exit+0xc6/0x670
 reclaim_high+0x10a/0x1b0
 ? __pfx_reclaim_high+0x10/0x10
 ? process_one_work+0x5ff/0x1030
 ? __pfx_high_work_func+0x10/0x10
 process_one_work+0x6e2/0x1030
 ? __pfx___schedule+0x10/0x10
 ? __pfx_process_one_work+0x10/0x10
 worker_thread+0x422/0xbb0
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x2cd/0x3a0
 ? recalc_sigpending+0x15c/0x200
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x368/0x590
 ? __pfx_ret_from_fork+0x10/0x10
 ? __switch_to+0x588/0xf50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Link: https://lore.kernel.org/20261029201858.2932905-1-tjmercier@google.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Fixes: 5da3bfa029d6 ("cgroup: use separate rstat trees for each subsystem")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: JP Kobryn <jp.kobryn@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/memcontrol.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/memcontrol.c~mm-memcontrol-fix-null-pointer-deref-and-uaf-from-high_work_func-on-dying-memcg
+++ a/mm/memcontrol.c
@@ -2457,7 +2457,10 @@ static void high_work_func(struct work_s
 	struct mem_cgroup *memcg;
 
 	memcg = container_of(work, struct mem_cgroup, high_work);
+	if (!css_tryget_online(&memcg->css))
+		return;
 	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
+	css_put(&memcg->css);
 }
 
 static void high_irq_work_func(struct irq_work *work)
@@ -4463,6 +4466,8 @@ static void mem_cgroup_css_offline(struc
 
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
+	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
+	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 
 	zswap_memcg_offline_cleanup(memcg);
 
_

Patches currently in -mm which might be from tjmercier@google.com are

mm-vmscan-remove-redundant-mem_cgroup_online-checks.patch
mm-mglru-stop-rotating-offlined-memcgs-to-the-old-generation.patch

