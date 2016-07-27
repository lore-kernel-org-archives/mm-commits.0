From: akpm@linux-foundation.org
Subject: [merged] slab-do-not-panic-on-invalid-gfp_mask.patch removed from -mm tree
Date: Wed, 27 Jul 2016 11:59:25 -0700
Message-ID: <5799048d.n661KDZb0nw+7+Hc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148AbcG0S70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:59:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: do not panic on invalid gfp_mask
has been removed from the -mm tree.  Its filename was
     slab-do-not-panic-on-invalid-gfp_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: slab: do not panic on invalid gfp_mask

Both SLAB and SLUB BUG() when a caller provides an invalid gfp_mask.  This
is a rather harsh way to announce a non-critical issue.  Allocator is free
to ignore invalid flags.  Let's simply replace BUG() by dump_stack to tell
the offender and fixup the mask to move on with the allocation request.

This is an example for kmalloc(GFP_KERNEL|__GFP_HIGHMEM) from a test
module.
[   31.914753] Unexpected gfp: 0x2 (__GFP_HIGHMEM). Fixing up to gfp: 0x24000c0 (GFP_KERNEL). Fix your code!
[   31.914754] CPU: 0 PID: 2916 Comm: insmod Tainted: G           O    4.6.0-slabgfp2-00002-g4cdfc2ef4892-dirty #936
[   31.914755] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
[   31.914756]  0000000000000000 ffff88000d777c00 ffffffff8130e2fb ffff88000ec006c0
[   31.914758]  000000000000000c ffff88000d777c58 ffffffff811791dd 0000000000000246
[   31.914759]  0000000000000246 0000000000000046 00000002024000c0 ffff88000fa1d888
[   31.914759] Call Trace:
[   31.914760]  [<ffffffff8130e2fb>] dump_stack+0x67/0x90
[   31.914762]  [<ffffffff811791dd>] cache_alloc_refill+0x201/0x617
[   31.914763]  [<ffffffff81179b3f>] kmem_cache_alloc_trace+0xa7/0x24a
[   31.914764]  [<ffffffffa0005000>] ? 0xffffffffa0005000
[   31.914765]  [<ffffffffa0005020>] mymodule_init+0x20/0x1000 [test_slab]
[   31.914767]  [<ffffffff81000402>] do_one_initcall+0xe7/0x16c
[   31.914768]  [<ffffffff810b02de>] ? rcu_read_lock_sched_held+0x61/0x69
[   31.914769]  [<ffffffff81179c2f>] ? kmem_cache_alloc_trace+0x197/0x24a
[   31.914771]  [<ffffffff81125edc>] do_init_module+0x5f/0x1d9
[   31.914772]  [<ffffffff810d2c66>] load_module+0x1a3d/0x1f21
[   31.914774]  [<ffffffff81622931>] ? retint_kernel+0x2d/0x2d
[   31.914775]  [<ffffffff810d3232>] SyS_init_module+0xe8/0x10e
[   31.914776]  [<ffffffff810d3232>] ? SyS_init_module+0xe8/0x10e
[   31.914778]  [<ffffffff81001d08>] do_syscall_64+0x68/0x13f
[   31.914779]  [<ffffffff8162201a>] entry_SYSCALL64_slow_path+0x25/0x25

Link: http://lkml.kernel.org/r/1465548200-11384-2-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    6 ++++--
 mm/slub.c |    5 +++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~slab-do-not-panic-on-invalid-gfp_mask mm/slab.c
--- a/mm/slab.c~slab-do-not-panic-on-invalid-gfp_mask
+++ a/mm/slab.c
@@ -2687,8 +2687,10 @@ static struct page *cache_grow_begin(str
 	 */
 	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
 		gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
-		pr_emerg("Unexpected gfp: %#x (%pGg)\n", invalid_mask, &invalid_mask);
-		BUG();
+		flags &= ~GFP_SLAB_BUG_MASK;
+		pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
+				invalid_mask, &invalid_mask, flags, &flags);
+		dump_stack();
 	}
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 
diff -puN mm/slub.c~slab-do-not-panic-on-invalid-gfp_mask mm/slub.c
--- a/mm/slub.c~slab-do-not-panic-on-invalid-gfp_mask
+++ a/mm/slub.c
@@ -1613,8 +1613,9 @@ static struct page *new_slab(struct kmem
 {
 	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
 		gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
-		pr_emerg("Unexpected gfp: %#x (%pGg)\n", invalid_mask, &invalid_mask);
-		BUG();
+		flags &= ~GFP_SLAB_BUG_MASK;
+		pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
+				invalid_mask, &invalid_mask, flags, &flags);
 	}
 
 	return allocate_slab(s,
_

Patches currently in -mm which might be from mhocko@suse.com are

proc-oom-drop-bogus-task_lock-and-mm-check.patch
proc-oom-drop-bogus-sighand-lock.patch
proc-oom_adj-extract-oom_score_adj-setting-into-a-helper.patch
mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj.patch
mm-oom-skip-vforked-tasks-from-being-selected.patch
mm-oom-kill-all-tasks-sharing-the-mm.patch
mm-oom-fortify-task_will_free_mem.patch
mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks.patch
mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice.patch
mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init.patch
mm-oom-fortify-task_will_free_mem-fix.patch
freezer-oom-check-tif_memdie-on-the-correct-task.patch
cpuset-mm-fix-tif_memdie-check-in-cpuset_change_task_nodemask.patch
revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements.patch

