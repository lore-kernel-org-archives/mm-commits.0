From: akpm@linux-foundation.org
Subject: [merged]
 mm-softirq-safe-softirq-unsafe-lock-order-detected-in-split_huge_page_to_list.patch removed from -mm tree
Date: Thu, 21 Jan 2016 14:58:25 -0800
Message-ID: <56a16291.eASbNyG0CAWkc6A9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbcAUW60 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:58:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, dvyukov@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix interrupt unsafe locking in split_huge_page()
has been removed from the -mm tree.  Its filename was
     mm-softirq-safe-softirq-unsafe-lock-order-detected-in-split_huge_page_to_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: fix interrupt unsafe locking in split_huge_page()

split_queue_lock can be taken from interrupt context in some cases, but I
forgot to convert locking in split_huge_page() to interrupt-safe
primitives.

Let's fix this.

lockdep output:

======================================================
[ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
4.4.0+ #259 Tainted: G        W
------------------------------------------------------
syz-executor/18183 [HC0[0]:SC0[2]:HE0:SE0] is trying to acquire:
 (split_queue_lock){+.+...}, at: [<ffffffff817847d4>]
free_transhuge_page+0x24/0x90 mm/huge_memory.c:3436

and this task is already holding:
 (slock-AF_INET){+.-...}, at: [<     inline     >] spin_lock_bh
include/linux/spinlock.h:307
 (slock-AF_INET){+.-...}, at: [<ffffffff851c4fe5>]
lock_sock_fast+0x45/0x120 net/core/sock.c:2462
which would create a new lock dependency:
 (slock-AF_INET){+.-...} -> (split_queue_lock){+.+...}

but this new dependency connects a SOFTIRQ-irq-safe lock:
 (slock-AF_INET){+.-...}
... which became SOFTIRQ-irq-safe at:
  [<     inline     >] mark_irqflags kernel/locking/lockdep.c:2799
  [<ffffffff81454718>] __lock_acquire+0xfd8/0x4700 kernel/locking/lockdep.c:3162
  [<ffffffff8145a28c>] lock_acquire+0x1dc/0x430 kernel/locking/lockdep.c:3585
  [<     inline     >] __raw_spin_lock include/linux/spinlock_api_smp.h:144
  [<ffffffff863248d3>] _raw_spin_lock+0x33/0x50 kernel/locking/spinlock.c:151
  [<     inline     >] spin_lock include/linux/spinlock.h:302
  [<ffffffff855e3df1>] udp_queue_rcv_skb+0x781/0x1550 net/ipv4/udp.c:1680
  [<ffffffff855e4c10>] flush_stack+0x50/0x330 net/ipv6/udp.c:799
  [<ffffffff855e5584>] __udp4_lib_mcast_deliver+0x694/0x7f0 net/ipv4/udp.c:1798
  [<ffffffff855e6ebc>] __udp4_lib_rcv+0x17dc/0x23e0 net/ipv4/udp.c:1888
  [<ffffffff855e9021>] udp_rcv+0x21/0x30 net/ipv4/udp.c:2108
  [<ffffffff85513b33>] ip_local_deliver_finish+0x2b3/0xa50
net/ipv4/ip_input.c:216
  [<     inline     >] NF_HOOK_THRESH include/linux/netfilter.h:226
  [<     inline     >] NF_HOOK include/linux/netfilter.h:249
  [<ffffffff855149d4>] ip_local_deliver+0x1c4/0x2f0 net/ipv4/ip_input.c:257
  [<     inline     >] dst_input include/net/dst.h:498
  [<ffffffff8551273c>] ip_rcv_finish+0x5ec/0x1730 net/ipv4/ip_input.c:365
  [<     inline     >] NF_HOOK_THRESH include/linux/netfilter.h:226
  [<     inline     >] NF_HOOK include/linux/netfilter.h:249
  [<ffffffff85515463>] ip_rcv+0x963/0x1080 net/ipv4/ip_input.c:455
  [<ffffffff8521b410>] __netif_receive_skb_core+0x1620/0x2f80
net/core/dev.c:4154
  [<ffffffff8521cd9a>] __netif_receive_skb+0x2a/0x160 net/core/dev.c:4189
  [<ffffffff85220795>] netif_receive_skb_internal+0x1b5/0x390
net/core/dev.c:4217
  [<     inline     >] napi_skb_finish net/core/dev.c:4542
  [<ffffffff85224c9d>] napi_gro_receive+0x2bd/0x3c0 net/core/dev.c:4572
  [<ffffffff83a2f142>] e1000_clean_rx_irq+0x4e2/0x1100
drivers/net/ethernet/intel/e1000e/netdev.c:1038
  [<ffffffff83a2c1f8>] e1000_clean+0xa08/0x24a0
drivers/net/ethernet/intel/e1000/e1000_main.c:3819
  [<     inline     >] napi_poll net/core/dev.c:5074
  [<ffffffff8522285b>] net_rx_action+0x7eb/0xdf0 net/core/dev.c:5139
  [<ffffffff81361c0a>] __do_softirq+0x26a/0x920 kernel/softirq.c:273
  [<     inline     >] invoke_softirq kernel/softirq.c:350
  [<ffffffff8136264f>] irq_exit+0x18f/0x1d0 kernel/softirq.c:391
  [<     inline     >] exiting_irq ./arch/x86/include/asm/apic.h:659
  [<ffffffff811a9a66>] do_IRQ+0x86/0x1a0 arch/x86/kernel/irq.c:252
  [<ffffffff863264cc>] ret_from_intr+0x0/0x20 arch/x86/entry/entry_64.S:520
  [<     inline     >] arch_safe_halt ./arch/x86/include/asm/paravirt.h:117
  [<ffffffff811bdd42>] default_idle+0x52/0x2e0 arch/x86/kernel/process.c:304
  [<ffffffff811bf37a>] arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:295
  [<ffffffff81439f48>] default_idle_call+0x48/0xa0 kernel/sched/idle.c:92
  [<     inline     >] cpuidle_idle_call kernel/sched/idle.c:156
  [<     inline     >] cpu_idle_loop kernel/sched/idle.c:252
  [<ffffffff8143a604>] cpu_startup_entry+0x554/0x710 kernel/sched/idle.c:300
  [<ffffffff86301262>] rest_init+0x192/0x1a0 init/main.c:412
  [<ffffffff882fa780>] start_kernel+0x678/0x69e init/main.c:683
  [<ffffffff882f9342>] x86_64_start_reservations+0x2a/0x2c
arch/x86/kernel/head64.c:195
  [<ffffffff882f949c>] x86_64_start_kernel+0x158/0x167
arch/x86/kernel/head64.c:184

to a SOFTIRQ-irq-unsafe lock:
 (split_queue_lock){+.+...}
... which became SOFTIRQ-irq-unsafe at:
...  [<     inline     >] mark_irqflags kernel/locking/lockdep.c:2817
...  [<ffffffff81454bae>] __lock_acquire+0x146e/0x4700
kernel/locking/lockdep.c:3162
  [<ffffffff8145a28c>] lock_acquire+0x1dc/0x430 kernel/locking/lockdep.c:3585
  [<     inline     >] __raw_spin_lock include/linux/spinlock_api_smp.h:144
  [<ffffffff863248d3>] _raw_spin_lock+0x33/0x50 kernel/locking/spinlock.c:151
  [<     inline     >] spin_lock include/linux/spinlock.h:302
  [<ffffffff81782320>] split_huge_page_to_list+0xcc0/0x1c50
mm/huge_memory.c:3399
  [<     inline     >] split_huge_page include/linux/huge_mm.h:99
  [<ffffffff8174a4e8>] queue_pages_pte_range+0xa38/0xef0 mm/mempolicy.c:507
  [<     inline     >] walk_pmd_range mm/pagewalk.c:50
  [<     inline     >] walk_pud_range mm/pagewalk.c:90
  [<     inline     >] walk_pgd_range mm/pagewalk.c:116
  [<ffffffff8171d4f3>] __walk_page_range+0x653/0xcd0 mm/pagewalk.c:204
  [<ffffffff8171dc6e>] walk_page_range+0xfe/0x2b0 mm/pagewalk.c:281
  [<ffffffff81746e7b>] queue_pages_range+0xfb/0x130 mm/mempolicy.c:687
  [<     inline     >] migrate_to_node mm/mempolicy.c:1004
  [<ffffffff8174c340>] do_migrate_pages+0x370/0x4e0 mm/mempolicy.c:1109
  [<     inline     >] SYSC_migrate_pages mm/mempolicy.c:1453
  [<ffffffff8174cc10>] SyS_migrate_pages+0x640/0x730 mm/mempolicy.c:1374
  [<ffffffff863259b6>] entry_SYSCALL_64_fastpath+0x16/0x7a
arch/x86/entry/entry_64.S:185

other info that might help us debug this:

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(split_queue_lock);
                               local_irq_disable();
                               lock(slock-AF_INET);
                               lock(split_queue_lock);
  <Interrupt>
    lock(slock-AF_INET);

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~mm-softirq-safe-softirq-unsafe-lock-order-detected-in-split_huge_page_to_list mm/huge_memory.c
--- a/mm/huge_memory.c~mm-softirq-safe-softirq-unsafe-lock-order-detected-in-split_huge_page_to_list
+++ a/mm/huge_memory.c
@@ -3357,6 +3357,7 @@ int split_huge_page_to_list(struct page
 	struct anon_vma *anon_vma;
 	int count, mapcount, ret;
 	bool mlocked;
+	unsigned long flags;
 
 	VM_BUG_ON_PAGE(is_huge_zero_page(page), page);
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
@@ -3396,7 +3397,7 @@ int split_huge_page_to_list(struct page
 		lru_add_drain();
 
 	/* Prevent deferred_split_scan() touching ->_count */
-	spin_lock(&split_queue_lock);
+	spin_lock_irqsave(&split_queue_lock, flags);
 	count = page_count(head);
 	mapcount = total_mapcount(head);
 	if (!mapcount && count == 1) {
@@ -3404,11 +3405,11 @@ int split_huge_page_to_list(struct page
 			split_queue_len--;
 			list_del(page_deferred_list(head));
 		}
-		spin_unlock(&split_queue_lock);
+		spin_unlock_irqrestore(&split_queue_lock, flags);
 		__split_huge_page(page, list);
 		ret = 0;
 	} else if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount) {
-		spin_unlock(&split_queue_lock);
+		spin_unlock_irqrestore(&split_queue_lock, flags);
 		pr_alert("total_mapcount: %u, page_count(): %u\n",
 				mapcount, count);
 		if (PageTail(page))
@@ -3416,7 +3417,7 @@ int split_huge_page_to_list(struct page
 		dump_page(page, "total_mapcount(head) > 0");
 		BUG();
 	} else {
-		spin_unlock(&split_queue_lock);
+		spin_unlock_irqrestore(&split_queue_lock, flags);
 		unfreeze_page(anon_vma, head);
 		ret = -EBUSY;
 	}
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-change-pmd_trans_huge_lock-interface-to-return-ptl.patch
mlocked-pages-statistics-shows-bogus-value.patch
thp-make-split_queue-per-node.patch
thp-change-deferred_split_count-to-return-number-of-thp-in-queue.patch
thp-limit-number-of-object-to-scan-on-deferred_split_scan.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

