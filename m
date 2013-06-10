From: akpm@linux-foundation.org
Subject: +
 mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers.patch
 added to -mm tree
Date: Mon, 10 Jun 2013 14:47:33 -0700
Message-ID: <51b64975.wmwzg7cbb3rP7iZP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab3FJVre (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 17:47:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, rientjes@google.com, mhocko@suse.cz, liqin.chen@sunplusct.com, lennox.wu@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, jonas@southpole.se, james.hogan@imgtec.com, dhowells@redhat.com, cmetcalf@tilera.com, hannes@cmpxchg.org

Subject: + mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers.patch added to -mm tree
To: hannes@cmpxchg.org,cmetcalf@tilera.com,dhowells@redhat.com,james.hogan@imgtec.com,jonas@southpole.se,kamezawa.hiroyu@jp.fujitsu.com,lennox.wu@gmail.com,liqin.chen@sunplusct.com,mhocko@suse.cz,rientjes@google.com,vgupta@synopsys.com
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 14:47:33 -0700


The patch titled
     Subject: mm: invoke oom-killer from remaining unconverted page fault handlers
has been added to the -mm tree.  Its filename is
     mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: invoke oom-killer from remaining unconverted page fault handlers

A few remaining architectures directly kill the page faulting task in an
out of memory situation.  This is usually not a good idea since that task
might not even use a significant amount of memory and so may not be the
optimal victim to resolve the situation.

Since 2.6.29's 1c0fe6e ("mm: invoke oom-killer from page fault") there is
a hook that architecture page fault handlers are supposed to call to
invoke the OOM killer and let it pick the right task to kill.  Convert the
remaining architectures over to this hook.

To have the previous behavior of simply taking out the faulting task the
vm.oom_kill_allocating_task sysctl can be set to 1.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>   [arch/arc bits]
Cc: James Hogan <james.hogan@imgtec.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/fault.c      |    6 ++++--
 arch/metag/mm/fault.c    |    6 ++++--
 arch/mn10300/mm/fault.c  |    7 ++++---
 arch/openrisc/mm/fault.c |    8 ++++----
 arch/score/mm/fault.c    |    8 ++++----
 arch/tile/mm/fault.c     |    8 ++++----
 6 files changed, 24 insertions(+), 19 deletions(-)

diff -puN arch/arc/mm/fault.c~mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers arch/arc/mm/fault.c
--- a/arch/arc/mm/fault.c~mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers
+++ a/arch/arc/mm/fault.c
@@ -207,8 +207,10 @@ out_of_memory:
 	}
 	up_read(&mm->mmap_sem);
 
-	if (user_mode(regs))
-		do_group_exit(SIGKILL);	/* This will never return */
+	if (user_mode(regs)) {
+		pagefault_out_of_memory();
+		return;
+	}
 
 	goto no_context;
 
diff -puN arch/metag/mm/fault.c~mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers arch/metag/mm/fault.c
--- a/arch/metag/mm/fault.c~mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers
+++ a/arch/metag/mm/fault.c
@@ -224,8 +224,10 @@ do_sigbus:
 	 */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (user_mode(regs))
-		do_group_exit(SIGKILL);
+	if (user_mode(regs)) {
+		pagefault_out_of_memory();
+		return 1;
+	}
 
 no_context:
 	/* Are we prepared to handle this kernel fault?  */
diff -puN arch/mn10300/mm/fault.c~mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers arch/mn10300/mm/fault.c
--- a/arch/mn10300/mm/fault.c~mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers
+++ a/arch/mn10300/mm/fault.c
@@ -345,9 +345,10 @@ no_context:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	printk(KERN_ALERT "VM: killing process %s\n", tsk->comm);
-	if ((fault_code & MMUFCR_xFC_ACCESS) == MMUFCR_xFC_ACCESS_USR)
-		do_exit(SIGKILL);
+	if ((fault_code & MMUFCR_xFC_ACCESS) == MMUFCR_xFC_ACCESS_USR) {
+		pagefault_out_of_memory();
+		return;
+	}
 	goto no_context;
 
 do_sigbus:
diff -puN arch/openrisc/mm/fault.c~mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers arch/openrisc/mm/fault.c
--- a/arch/openrisc/mm/fault.c~mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers
+++ a/arch/openrisc/mm/fault.c
@@ -267,10 +267,10 @@ out_of_memory:
 	__asm__ __volatile__("l.nop 1");
 
 	up_read(&mm->mmap_sem);
-	printk("VM: killing process %s\n", tsk->comm);
-	if (user_mode(regs))
-		do_exit(SIGKILL);
-	goto no_context;
+	if (!user_mode(regs))
+		goto no_context;
+	pagefault_out_of_memory();
+	return;
 
 do_sigbus:
 	up_read(&mm->mmap_sem);
diff -puN arch/score/mm/fault.c~mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers arch/score/mm/fault.c
--- a/arch/score/mm/fault.c~mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers
+++ a/arch/score/mm/fault.c
@@ -172,10 +172,10 @@ out_of_memory:
 		down_read(&mm->mmap_sem);
 		goto survive;
 	}
-	printk("VM: killing process %s\n", tsk->comm);
-	if (user_mode(regs))
-		do_group_exit(SIGKILL);
-	goto no_context;
+	if (!user_mode(regs))
+		goto no_context;
+	pagefault_out_of_memory();
+	return;
 
 do_sigbus:
 	up_read(&mm->mmap_sem);
diff -puN arch/tile/mm/fault.c~mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers arch/tile/mm/fault.c
--- a/arch/tile/mm/fault.c~mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers
+++ a/arch/tile/mm/fault.c
@@ -573,10 +573,10 @@ out_of_memory:
 		down_read(&mm->mmap_sem);
 		goto survive;
 	}
-	pr_alert("VM: killing process %s\n", tsk->comm);
-	if (!is_kernel_mode)
-		do_group_exit(SIGKILL);
-	goto no_context;
+	if (is_kernel_mode)
+		goto no_context;
+	pagefault_out_of_memory();
+	return 0;
 
 do_sigbus:
 	up_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch
swap-avoid-read_swap_cache_async-race-to-deadlock-while-waiting-on-discard-i-o-completion.patch
mm-memcontrol-fix-lockless-reclaim-hierarchy-iterator.patch
mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup.patch
mm-vmscan-limit-the-number-of-pages-kswapd-reclaims-at-each-priority.patch
mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch
mm-vmscan-flatten-kswapd-priority-loop.patch
mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch
mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch
mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered-v3.patch
mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3.patch
mm-vmscan-set-zone-flags-before-blocking.patch
mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch
mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion.patch
mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3.patch
fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch
memcg-update-todo-list-in-documentation.patch
mm-add-tracepoints-for-lru-activation-and-insertions.patch
mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch
mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch
mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
memcg-kconfig-info-update.patch
mm-kill-free_all_bootmem_node.patch
mm-memcontrol-factor-out-reclaim-iterator-loading-and-updating.patch
memcg-clean-up-memcg-nodeinfo.patch
mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers.patch
mm-memmap_init_zone-performance-improvement.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

