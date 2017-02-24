From: akpm@linux-foundation.org
Subject: [patch 021/124] mm, page_alloc: do not depend on cpu hotplug
 locks inside the allocator
Date: Fri, 24 Feb 2017 14:56:35 -0800
Message-ID: <58b0ba23.pq4e+TxyREDZ+ivY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37520 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdBXW4k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:56:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, dvyukov@google.com, mgorman@techsingularity.net, tj@kernel.org

From: Michal Hocko <mhocko@suse.com>
Subject: mm, page_alloc: do not depend on cpu hotplug locks inside the allocator

Dmitry has reported the following lockdep splat
[<ffffffff81571db1>] lock_acquire+0x2a1/0x630 kernel/locking/lockdep.c:3753
[<ffffffff8436697e>] __mutex_lock_common kernel/locking/mutex.c:521 [inline]
[<ffffffff8436697e>] mutex_lock_nested+0x24e/0xff0 kernel/locking/mutex.c:621
[<ffffffff818f07ea>] pcpu_alloc+0xbda/0x1280 mm/percpu.c:896
[<ffffffff818f0ee4>] __alloc_percpu+0x24/0x30 mm/percpu.c:1075
[<ffffffff816543e3>] smpcfd_prepare_cpu+0x73/0xd0 kernel/smp.c:44
[<ffffffff814240b4>] cpuhp_invoke_callback+0x254/0x1480 kernel/cpu.c:136
[<ffffffff81425821>] cpuhp_up_callbacks+0x81/0x2a0 kernel/cpu.c:493
[<ffffffff81427bf3>] _cpu_up+0x1e3/0x2a0 kernel/cpu.c:1057
[<ffffffff81427d23>] do_cpu_up+0x73/0xa0 kernel/cpu.c:1087
[<ffffffff81427d68>] cpu_up+0x18/0x20 kernel/cpu.c:1095
[<ffffffff854ede84>] smp_init+0xe9/0xee kernel/smp.c:564
[<ffffffff85482f81>] kernel_init_freeable+0x439/0x690 init/main.c:1010
[<ffffffff84357083>] kernel_init+0x13/0x180 init/main.c:941
[<ffffffff84377baa>] ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:433

cpu_hotplug_begin
  cpu_hotplug.lock
pcpu_alloc
  pcpu_alloc_mutex

[<ffffffff81423012>] get_online_cpus+0x62/0x90 kernel/cpu.c:248
[<ffffffff8185fcf8>] drain_all_pages+0xf8/0x710 mm/page_alloc.c:2385
[<ffffffff81865e5d>] __alloc_pages_direct_reclaim mm/page_alloc.c:3440 [inline]
[<ffffffff81865e5d>] __alloc_pages_slowpath+0x8fd/0x2370 mm/page_alloc.c:3778
[<ffffffff818681c5>] __alloc_pages_nodemask+0x8f5/0xc60 mm/page_alloc.c:3980
[<ffffffff818ed0c1>] __alloc_pages include/linux/gfp.h:426 [inline]
[<ffffffff818ed0c1>] __alloc_pages_node include/linux/gfp.h:439 [inline]
[<ffffffff818ed0c1>] alloc_pages_node include/linux/gfp.h:453 [inline]
[<ffffffff818ed0c1>] pcpu_alloc_pages mm/percpu-vm.c:93 [inline]
[<ffffffff818ed0c1>] pcpu_populate_chunk+0x1e1/0x900 mm/percpu-vm.c:282
[<ffffffff818f0a11>] pcpu_alloc+0xe01/0x1280 mm/percpu.c:998
[<ffffffff818f0eb7>] __alloc_percpu_gfp+0x27/0x30 mm/percpu.c:1062
[<ffffffff817d25b2>] bpf_array_alloc_percpu kernel/bpf/arraymap.c:34 [inline]
[<ffffffff817d25b2>] array_map_alloc+0x532/0x710 kernel/bpf/arraymap.c:99
[<ffffffff817ba034>] find_and_alloc_map kernel/bpf/syscall.c:34 [inline]
[<ffffffff817ba034>] map_create kernel/bpf/syscall.c:188 [inline]
[<ffffffff817ba034>] SYSC_bpf kernel/bpf/syscall.c:870 [inline]
[<ffffffff817ba034>] SyS_bpf+0xd64/0x2500 kernel/bpf/syscall.c:827
[<ffffffff84377941>] entry_SYSCALL_64_fastpath+0x1f/0xc2

pcpu_alloc
  pcpu_alloc_mutex
drain_all_pages
  get_online_cpus
    cpu_hotplug.lock

[<ffffffff81427876>] cpu_hotplug_begin+0x206/0x2e0 kernel/cpu.c:304
[<ffffffff81427ada>] _cpu_up+0xca/0x2a0 kernel/cpu.c:1011
[<ffffffff81427d23>] do_cpu_up+0x73/0xa0 kernel/cpu.c:1087
[<ffffffff81427d68>] cpu_up+0x18/0x20 kernel/cpu.c:1095
[<ffffffff854ede84>] smp_init+0xe9/0xee kernel/smp.c:564
[<ffffffff85482f81>] kernel_init_freeable+0x439/0x690 init/main.c:1010
[<ffffffff84357083>] kernel_init+0x13/0x180 init/main.c:941
[<ffffffff84377baa>] ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:433

cpu_hotplug_begin
  cpu_hotplug.lock

Pulling cpu hotplug locks inside the page allocator is just too
dangerous. Let's remove the dependency by dropping get_online_cpus()
from drain_all_pages. This is not so simple though because now we do not
have a protection against cpu hotplug which means 2 things:
	- the work item might be executed on a different cpu in worker
	  from unbound pool so it doesn't run on pinned on the cpu
	- we have to make sure that we do not race with page_alloc_cpu_dead
	  calling drain_pages_zone

Disabling preemption in drain_local_pages_wq will solve the first
problem drain_local_pages will determine its local CPU from the WQ
context which will be stable after that point, page_alloc_cpu_dead
is pinned to the CPU already. The later condition is achieved
by disabling IRQs in drain_pages_zone.

Fixes: mm, page_alloc: drain per-cpu pages from workqueue context
Link: http://lkml.kernel.org/r/20170207201950.20482-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-do-not-depend-on-cpu-hotplug-locks-inside-the-allocator mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-do-not-depend-on-cpu-hotplug-locks-inside-the-allocator
+++ a/mm/page_alloc.c
@@ -2341,7 +2341,16 @@ void drain_local_pages(struct zone *zone
 
 static void drain_local_pages_wq(struct work_struct *work)
 {
+	/*
+	 * drain_all_pages doesn't use proper cpu hotplug protection so
+	 * we can race with cpu offline when the WQ can move this from
+	 * a cpu pinned worker to an unbound one. We can operate on a different
+	 * cpu which is allright but we also have to make sure to not move to
+	 * a different one.
+	 */
+	preempt_disable();
 	drain_local_pages(NULL);
+	preempt_enable();
 }
 
 /*
@@ -2366,11 +2375,6 @@ void drain_all_pages(struct zone *zone)
 	if (current->flags & PF_WQ_WORKER)
 		return;
 
-	/*
-	 * As this can be called from reclaim context, do not reenter reclaim.
-	 * An allocation failure can be handled, it's simply slower
-	 */
-	get_online_cpus();
 	works = alloc_percpu_gfp(struct work_struct, GFP_ATOMIC);
 
 	/*
@@ -2421,7 +2425,6 @@ void drain_all_pages(struct zone *zone)
 			flush_work(&work);
 		}
 	}
-	put_online_cpus();
 }
 
 #ifdef CONFIG_HIBERNATION
_
