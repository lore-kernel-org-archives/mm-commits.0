From: akpm@linux-foundation.org
Subject: +
 slub-make-sure-struct-kmem_cache_node-is-initialized-before-publication.patch added to -mm tree
Date: Fri, 07 Jul 2017 13:24:26 -0700
Message-ID: <595fedfa.7Vxwh/I+GCgT1Nno%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37152 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752483AbdGGUY1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 16:24:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: make sure struct kmem_cache_node is initialized before publication
has been added to the -mm tree.  Its filename is
     slub-make-sure-struct-kmem_cache_node-is-initialized-before-publication.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-make-sure-struct-kmem_cache_node-is-initialized-before-publication.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-make-sure-struct-kmem_cache_node-is-initialized-before-publication.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: slub: make sure struct kmem_cache_node is initialized before publication

According to KMSAN (see the report below) it's possible that
unfreeze_partials() accesses &n->list_lock before it's being initialized. 
The initialization normally happens in init_kmem_cache_node() when it's
called from init_kmem_cache_nodes(), but only after the struct
kmem_cache_node is published.  To avoid what appears to be a data race, we
need to publish the struct after it has been initialized.

KMSAN (https://github.com/google/kmsan) report is as follows:

==================================================================
BUG: KMSAN: use of uninitialized memory in
queued_spin_lock_slowpath+0xa55/0xaf0 kernel/locking/qspinlock.c:478
CPU: 1 PID: 5021 Comm: modprobe Not tainted 4.11.0-rc5+ #2876
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:16 [inline]
 dump_stack+0x172/0x1c0 lib/dump_stack.c:52
 kmsan_report+0x12a/0x180 mm/kmsan/kmsan.c:927
 __msan_warning_32+0x61/0xb0 mm/kmsan/kmsan_instr.c:469
 queued_spin_lock_slowpath+0xa55/0xaf0 kernel/locking/qspinlock.c:478
 queued_spin_lock include/asm-generic/qspinlock.h:103 [inline]
 do_raw_spin_lock include/linux/spinlock.h:148 [inline]
 __raw_spin_lock include/linux/spinlock_api_smp.h:143 [inline]
 _raw_spin_lock+0x73/0x80 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:299 [inline]
 unfreeze_partials+0x6d/0x210 mm/slub.c:2181
 put_cpu_partial mm/slub.c:2255 [inline]
 __slab_free mm/slub.c:2894 [inline]
 do_slab_free mm/slub.c:2990 [inline]
 slab_free mm/slub.c:3005 [inline]
 kmem_cache_free+0x39d/0x5b0 mm/slub.c:3020
 free_task_struct kernel/fork.c:158 [inline]
 free_task kernel/fork.c:370 [inline]
 __put_task_struct+0x7eb/0x880 kernel/fork.c:407
 put_task_struct include/linux/sched/task.h:94 [inline]
 delayed_put_task_struct+0x271/0x2b0 kernel/exit.c:181
 __rcu_reclaim kernel/rcu/rcu.h:118 [inline]
 rcu_do_batch kernel/rcu/tree.c:2879 [inline]
 invoke_rcu_callbacks kernel/rcu/tree.c:3142 [inline]
 __rcu_process_callbacks kernel/rcu/tree.c:3109 [inline]
 rcu_process_callbacks+0x1f10/0x2b50 kernel/rcu/tree.c:3126
 __do_softirq+0x485/0x942 kernel/softirq.c:284
 invoke_softirq kernel/softirq.c:364 [inline]
 irq_exit+0x1fa/0x230 kernel/softirq.c:405
 exiting_irq+0xe/0x10 arch/x86/include/asm/apic.h:657
 smp_apic_timer_interrupt+0x5a/0x80 arch/x86/kernel/apic/apic.c:966
 apic_timer_interrupt+0x86/0x90 arch/x86/entry/entry_64.S:489
RIP: 0010:native_restore_fl arch/x86/include/asm/irqflags.h:36 [inline]
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/irqflags.h:77
[inline]
RIP: 0010:__msan_poison_alloca+0xed/0x120 mm/kmsan/kmsan_instr.c:440
RSP: 0018:ffff880023d6f7b8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
RAX: 0000000000000246 RBX: ffff88001ebf8000 RCX: 0000000000000002
RDX: 0000000000000001 RSI: ffff880000000000 RDI: ffffea0000b332f0
RBP: ffff880023d6f838 R08: 0000000000000884 R09: 0000000000000004
R10: 0000160000000000 R11: 0000000000000000 R12: ffffffff85ab5df0
R13: ffff880023d6f885 R14: 0000000000000001 R15: ffffffff81ae424d
 </IRQ>
 page_remove_rmap+0x9d/0xd80 mm/rmap.c:1256
 zap_pte_range mm/memory.c:1237 [inline]
 zap_pmd_range mm/memory.c:1318 [inline]
 zap_pud_range mm/memory.c:1347 [inline]
 zap_p4d_range mm/memory.c:1368 [inline]
 unmap_page_range+0x28fd/0x34a0 mm/memory.c:1389
 unmap_single_vma+0x354/0x4b0 mm/memory.c:1434
 unmap_vmas+0x192/0x2a0 mm/memory.c:1464
 unmap_region+0x375/0x4c0 mm/mmap.c:2464
 do_munmap+0x1a39/0x2360 mm/mmap.c:2669
 vm_munmap mm/mmap.c:2688 [inline]
 SYSC_munmap+0x13d/0x1a0 mm/mmap.c:2698
 SyS_munmap+0x47/0x70 mm/mmap.c:2695
 entry_SYSCALL_64_fastpath+0x13/0x94
RIP: 0033:0x7fb3c34f0d37
RSP: 002b:00007ffd44afc268 EFLAGS: 00000206 ORIG_RAX: 000000000000000b
RAX: ffffffffffffffda RBX: 0000563670927260 RCX: 00007fb3c34f0d37
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 00007fb3c3bd5000
RBP: 0000000000000000 R08: 00007fb3c3bd1700 R09: 00007ffd44afc3c8
R10: 0000000000000000 R11: 0000000000000206 R12: 00000000ffffffff
R13: 0000563670927110 R14: 0000563670927210 R15: 00007ffd44afc4f0
origin:
 save_stack_trace+0x37/0x40 arch/x86/kernel/stacktrace.c:59
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:302 [inline]
 kmsan_internal_poison_shadow+0xb1/0x1a0 mm/kmsan/kmsan.c:198
 kmsan_kmalloc+0x7f/0xe0 mm/kmsan/kmsan.c:337
 kmsan_post_alloc_hook+0x10/0x20 mm/kmsan/kmsan.c:350
 slab_post_alloc_hook mm/slab.h:459 [inline]
 slab_alloc_node mm/slub.c:2747 [inline]
 kmem_cache_alloc_node+0x150/0x210 mm/slub.c:2788
 init_kmem_cache_nodes mm/slub.c:3430 [inline]
 kmem_cache_open mm/slub.c:3649 [inline]
 __kmem_cache_create+0x13e/0x5f0 mm/slub.c:4290
 create_cache mm/slab_common.c:382 [inline]
 kmem_cache_create+0x186/0x220 mm/slab_common.c:467
 fork_init+0x7e/0x430 kernel/fork.c:451
 start_kernel+0x499/0x580 init/main.c:654
 x86_64_start_reservations arch/x86/kernel/head64.c:196 [inline]
 x86_64_start_kernel+0x6cc/0x700 arch/x86/kernel/head64.c:177
 verify_cpu+0x0/0xfc
==================================================================

Link: http://lkml.kernel.org/r/20170707083408.40410-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-make-sure-struct-kmem_cache_node-is-initialized-before-publication mm/slub.c
--- a/mm/slub.c~slub-make-sure-struct-kmem_cache_node-is-initialized-before-publication
+++ a/mm/slub.c
@@ -3389,8 +3389,8 @@ static int init_kmem_cache_nodes(struct
 			return 0;
 		}
 
-		s->node[node] = n;
 		init_kmem_cache_node(n);
+		s->node[node] = n;
 	}
 	return 1;
 }
_

Patches currently in -mm which might be from glider@google.com are

slub-make-sure-struct-kmem_cache_node-is-initialized-before-publication.patch

