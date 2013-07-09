From: akpm@linux-foundation.org
Subject: [merged]
 mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:26 -0700
Message-ID: <51dc9a7e.RMNJEZKjqAEuXB9A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3GIXT1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, rientjes@google.com, mhocko@suse.cz, liqin.chen@sunplusct.com, lennox.wu@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, jonas@southpole.se, james.hogan@imgtec.com, dhowells@redhat.com, cmetcalf@tilera.com, hannes@cmpxchg.org

Subject: [merged] mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers.patch removed from -mm tree
To: hannes@cmpxchg.org,cmetcalf@tilera.com,dhowells@redhat.com,james.hogan@imgtec.com,jonas@southpole.se,kamezawa.hiroyu@jp.fujitsu.com,lennox.wu@gmail.com,liqin.chen@sunplusct.com,mhocko@suse.cz,rientjes@google.com,vgupta@synopsys.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:26 -0700


The patch titled
     Subject: mm: invoke oom-killer from remaining unconverted page fault handlers
has been removed from the -mm tree.  Its filename was
     mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memmap_init_zone-performance-improvement.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

