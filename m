Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793312364;
	b=iIqgIiHHLKLWCBcjy1XhzowUCQISBCLxc5SyYGmJU190wbne8KVpOwf7Gh3MHsN7L7/0
	 luahC/fzmBmth2Um4XSTVPlevPZNi1vlWbwGPEYa/oC+1GyMJF9kpwoJWtMrd3Q7LUVTC
	 AYxcIwHmMVQ9uzmeFVHwwNb7XZylCTiMIY9aPRtUrsMs4eFwCZGYMv48+c5YdyPY7Dwd9
	 BJxHsLDkucXgfiAwxtCGu9I2jBGr2mYnv3PNGkfu7dq6ULhk52Gv9owAFljYRPSE8RbyQ
	 WKs/X+W/4h4gysxkCgIkCPqk4ExJhYRfiTYSylnQd8flgvQxy8XMbESA4vTIX+dXx+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793312364;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=cLPNqKSdZpk9jjbxO9SvkkSOi2LDZKIkwcHKJjgk0SM=;
	b=qGOa1CvcXRtr/Z/KdPjVQlDg3JI3+7Wrhbts7sYl+ORaCb8dzuwjTK9agjX2PTed3VRx
	 +yCRZpv3+YUmXy4SKaBLTaIR4kbA1UpmgxqT28XTXEqpyt2FF6MdJQMrBM1ya0y957dOt
	 nsqZR1B/ZYkwH5pONA8X0TgpRjnOpjyw/8KGUDMivjq3OlXyiA0OfryzmpcY6BOQZpDA5
	 QbGwbnUvU+80bNq0VzOCZg9XhbpjtQ28WhokZIp2n7oPcd0oPTXsJSS7Yy9BhT2HfP/YB
	 o2SkPWKFqlBK2bi5sKXEJcMU5CoaGWF8xbK+LJvYfFgMWujrV7x3JBJ4DtntmuqONzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Uu5s8wbX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE67F606A31A;
	Thu, 29 Oct 2026 22:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Uu5s8wbX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2EA1F01816;
	Thu, 29 Oct 2026 22:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793312363;
	bh=cLPNqKSdZpk9jjbxO9SvkkSOi2LDZKIkwcHKJjgk0SM=;
	h=Date:To:From:Subject;
	b=Uu5s8wbXbY3vsj518NolBOcxx7Rld6hGykZ8Gq7kOoQ/kS6K4KT8ikS2CGAZyQ88n
	 lYZlmGLymG27/GJ8f0LhnUVR4TOr1U7zUOVj/YQR/48yOYRiwQD1wbc8qPRkp7tTp/
	 rUuuakKVqmDpiaIzXzb25Bm8h2bVO2VKeFXfIR9s=
Date: Thu, 29 Oct 2026 15:19:22 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,
	mhocko@kernel.org,jp.kobryn@linux.dev,hannes@cmpxchg.org,
	tjmercier@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-fix-null-pointer-deref-and-uaf-from-high_work_func-on-dying-memcg.patch added to mm-hotfixes-unstable branch
Message-Id: <20261029221923.0B2EA1F01816@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: memcontrol: fix NULL pointer deref and UAF from high_work_func() on dying memcg
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcontrol-fix-null-pointer-deref-and-uaf-from-high_work_func-on-dying-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-fix-null-pointer-deref-and-uaf-from-high_work_func-on-dying-memcg.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-memcontrol-fix-null-pointer-deref-and-uaf-from-high_work_func-on-dying-memcg.patch

