Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793312341;
	b=lQc46rjm3memo8KOAOyPkjAsIARZo3o90HHoWGyr8ZN+dDDsO0Id2MZegDMDJLoOpn8Y
	 u86TB3/x8/6TUYvxjHP32tOw6gk4+DG5u03z3M87kpSVyYGduNUEsdHD1NeetKfO7HwxC
	 y/RnqLv5QmT0HuU6pE9HAMM9hx29r6fQ/pHy+nbvEcLBcqARka/SfnP2tiTtIPG3J6dQE
	 +4yxeWR5oesEt4/5XQDHCAsfzsWxC4bsiw7nUg19i18TUHSxeK7u7SOzKxMQUsC/HKdLg
	 aiJ4LwvmTSYmv+HEp4pWBbC4lHVEE8cMLTUQQi5/nolRnBLZ0n8wPC+Olg5zzT7lRLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793312341;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ZS+sQ3A5opaBs47GIW9nkoL/ORTFHRRooaf64ZX/MbU=;
	b=WcRThuvl5014J7AQVeTyxhoeuh+MEo5FRCnaCeiJuIvQdmvT92OuOlr/Cd25L7eDCntZ
	 Ya8FWITwQh/h4N7prFxvQpDaKvUiSukNG6obFf9xgDfww59WaxMfD3IGXpWsNAH2Fos8e
	 ZeED49Ykpkvxwzf0ACu2yWsTzk5fDaJsZ/depy3eICPRjWiwUBrus830By9t65AdUfn4Y
	 xSth2vtul4hYFcBajQlmaJRkdhuUL+9R1PL2JmjV/VZb0pr+PZYJ609e12K5eHmBtd9j7
	 FuRbIYYpKtIoDkGq/ij0IeS8FBzayYd5n3RXDpMZ1nB5dMxo2YOm32nEIr45O71+M8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HCbTiXYi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AA6606A31A;
	Thu, 29 Oct 2026 22:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HCbTiXYi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50F81F01816;
	Thu, 29 Oct 2026 22:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793312340;
	bh=ZS+sQ3A5opaBs47GIW9nkoL/ORTFHRRooaf64ZX/MbU=;
	h=Date:To:From:Subject;
	b=HCbTiXYiN1pBo7r/vYK+tgPl4qDnarT24edX7pzNkVbVJVXKy29BkB45YJM/j9T2J
	 Yf1aK9lxqD6mtkQ6WTP7d80/92oM4uM7JzOz5/I1deokN5+/Gy/uXQtg/Aq9jNC3yg
	 FH/01WCVH1xm3MD4DLLUwTJArAxeIR+B2VZ7vPtw=
Date: Thu, 29 Oct 2026 15:19:00 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,
	mhocko@kernel.org,hannes@cmpxchg.org,tjmercier@google.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcontrol-fix-null-pointer-deref-in-high_work_func-on-dying-memcg.patch removed from -mm tree
Message-Id: <20261029221900.C50F81F01816@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: memcontrol: fix NULL pointer deref in high_work_func() on dying memcg
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-null-pointer-deref-in-high_work_func-on-dying-memcg.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "T.J. Mercier" <tjmercier@google.com>
Subject: mm: memcontrol: fix NULL pointer deref in high_work_func() on dying memcg
Date: Fri, 23 Oct 2026 15:23:13 -0700

When memory.high is exceeded in non-task context, try_charge_memcg()
schedules memcg->high_work without taking a CSS reference on the memcg,
and high_work_func() invokes reclaim_high() without pinning the memcg.

Before commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
dying memory cgroup for LRU folios"), memory usage above memory.high
kept the memcg's refcount non-zero. With reparenting, folios and objcgs
charged to a child memcg are reparented to its parent in
mem_cgroup_css_offline(), leaving the offlined child's memory usage
permanently above its memory.high even after its last reference is
dropped.

cancel_work_sync(&memcg->high_work) only runs at the end of teardown in
mem_cgroup_css_free(), so high_work_func() can start or still be running
reclaim_high() after mem_cgroup_css_released() or shrink_many() has
called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. This
causes lru_gen_rotate_memcg() to dereference a NULL pprev pointer.

Fix this by acquiring a reference with css_tryget_online() in
high_work_func() before calling reclaim_high(), and by resetting
memory.high and swap.high to PAGE_COUNTER_MAX in
mem_cgroup_css_offline() so that charges via references on an offlined
memcg do not trigger high_work on the dead child or skip checking live
ancestors in try_charge_memcg().

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W           7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full) <- Taint from lru_gen_rotate_memcg() VM_WARN_ON_ONCE
Tainted: [B]=BAD_PAGE, [W]=WARN
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
Workqueue: events high_work_func
RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
Code: fd 7f 09 45 84 ed 0f 85 64 0c 00 00 48 89 cf c6 83 6a 07 00 00 00 48 c1 ef 03 88 83 69 07 00 00 48 b8 00 00 00 00 00 fc ff df <80> 3c 07 00 0f 85 ec 0b 00 00 48 89 31 40 f6 c6 01 0f 85 4e 00
RSP: 0018:ffa00000001ef4c8 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ff1100000779e440 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ff1100000779b9b0 RDI: 0000000000000000
RBP: ff110000bffd8e40 R08: 0000000000000000 R09: ff1100000779ebb8
R10: ff1100000779ebb0 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: ffa00000001efb30 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ff1100011c0e7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000251ac88 CR3: 0000000009d6c000 CR4: 0000000000751ef0
PKRU: 55555554
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

Link: https://lore.kernel.org/20261023222313.3979455-1-tjmercier@google.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/memcontrol.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/memcontrol.c~mm-memcontrol-fix-null-pointer-deref-in-high_work_func-on-dying-memcg
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

