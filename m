From: akpm@linux-foundation.org
Subject: [folded-merged] mm-add-vfree_atomic-fix.patch removed from -mm
 tree
Date: Mon, 12 Dec 2016 16:23:36 -0800
Message-ID: <584f3f88.C/XOpUkU1pr33LfP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37894 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbcLMAWw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:22:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, ying.huang@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-vfree_atomic-fix
has been removed from the -mm tree.  Its filename was
     mm-add-vfree_atomic-fix.patch

This patch was dropped because it was folded into mm-add-vfree_atomic.patch

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm-add-vfree_atomic-fix

DEBUG_PREEMPT complains about using this_cpu_ptr() in preemptible:
	BUG: using smp_processor_id() in preemptible [00000000] code: iperf-300s-cs-l/277
	caller is debug_smp_processor_id+0x17/0x19
	CPU: 1 PID: 277 Comm: iperf-300s-cs-l Not tainted 4.9.0-rc8-00140-gcc639db #2
	 ffffc900003f3cf0 ffffffff8123ae6f 0000000000000001 ffffffff818181da
	 ffffc900003f3d20 ffffffff81252f41 0000000000012de0 00000000fffffdff
	 ffff880009328f40 ffff88000592c400 ffffc900003f3d30 ffffffff81252f6a
	Call Trace:
	 [<ffffffff8123ae6f>] dump_stack+0x9a/0xd0
	 [<ffffffff81252f41>] check_preemption_disabled+0xdd/0xef
	 [<ffffffff81252f6a>] debug_smp_processor_id+0x17/0x19
	 [<ffffffff811796df>] __vfree_deferred+0x16/0x4c
	 [<ffffffff8117b584>] vfree_atomic+0x22/0x24
	 [<ffffffff81094f5d>] free_thread_stack+0xc2/0x106
	 [<ffffffff810951be>] put_task_stack+0x4c/0x62
	 [<ffffffff81095f81>] copy_process+0x7e0/0x16e8
	 [<ffffffff8109702d>] _do_fork+0xbb/0x2d3
	 [<ffffffff810465e8>] ? __do_page_fault+0x2e1/0x384
	 [<ffffffff8112633f>] ? trace_hardirqs_off_caller+0x12/0x24
	 [<ffffffff810972cb>] SyS_clone+0x19/0x1b
	 [<ffffffff81003800>] do_syscall_64+0x143/0x173
	 [<ffffffff81507289>] entry_SYSCALL64_slow_path+0x25/0x25

Use raw_cpu_ptr() instead of this_cpu_ptr() to hide this warning.
It's fine because llist_add() implementation is lock-less, so it works even
if we adding to the list of some other cpu. schedule_work() is also preempt-safe.

Link: http://lkml.kernel.org/r/1481553981-3856-1-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reported-by: kernel test robot <ying.huang@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-add-vfree_atomic-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-add-vfree_atomic-fix
+++ a/mm/vmalloc.c
@@ -1489,7 +1489,14 @@ static void __vunmap(const void *addr, i
 
 static inline void __vfree_deferred(const void *addr)
 {
-	struct vfree_deferred *p = this_cpu_ptr(&vfree_deferred);
+	/*
+	 * Use raw_cpu_ptr() because this can be called from preemptible
+	 * context. Preemption is absolutely fine here, because llist_add()
+	 * implementation is lockless, so it works even if we adding to list
+	 * of the other cpu.
+	 * schedule_work() should be fine with this too.
+	 */
+	struct vfree_deferred *p = raw_cpu_ptr(&vfree_deferred);
 
 	if (llist_add((struct llist_node *)addr, &p->list))
 		schedule_work(&p->wq);
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-add-vfree_atomic.patch
kernel-fork-use-vfree_atomic-to-free-thread-stack.patch
x86-ldt-use-vfree_atomic-to-free-ldt-entries.patch
kasan-turn-on-fsanitize-address-use-after-scope.patch

