From: akpm@linux-foundation.org
Subject: [merged] x86mm-make-pagefault-killable.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:36 -0700
Message-ID: <201105252025.p4PKPxvV014445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754628Ab1EYU0r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:26:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, mingo@elte.hu, tglx@linutronix.de, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     x86,mm: make pagefault killable
has been removed from the -mm tree.  Its filename was
     x86mm-make-pagefault-killable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86,mm: make pagefault killable
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

When an oom killing occurs, almost all processes are getting stuck at the
following two points.

	1) __alloc_pages_nodemask
	2) __lock_page_or_retry

1) is not very problematic because TIF_MEMDIE leads to an allocation
failure and getting out from page allocator.

2) is more problematic.  In an OOM situation, zones typically don't have
page cache at all and memory starvation might lead to greatly reduced IO
performance.  When a fork bomb occurs, TIF_MEMDIE tasks don't die quickly,
meaning that a fork bomb may create new process quickly rather than the
oom-killer killing it.  Then, the system may become livelocked.

This patch makes the pagefault interruptible by SIGKILL.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |   12 +++++++++++-
 include/linux/mm.h  |    1 +
 mm/filemap.c        |   31 ++++++++++++++++++++++++-------
 3 files changed, 36 insertions(+), 8 deletions(-)

diff -puN arch/x86/mm/fault.c~x86mm-make-pagefault-killable arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~x86mm-make-pagefault-killable
+++ a/arch/x86/mm/fault.c
@@ -965,7 +965,7 @@ do_page_fault(struct pt_regs *regs, unsi
 	struct mm_struct *mm;
 	int fault;
 	int write = error_code & PF_WRITE;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY |
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
 					(write ? FAULT_FLAG_WRITE : 0);
 
 	tsk = current;
@@ -1139,6 +1139,16 @@ good_area:
 	}
 
 	/*
+	 * Pagefault was interrupted by SIGKILL. We have no reason to
+	 * continue pagefault.
+	 */
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current)) {
+		if (!(error_code & PF_USER))
+			no_context(regs, error_code, address);
+		return;
+	}
+
+	/*
 	 * Major/minor page fault accounting is only done on the
 	 * initial attempt. If we go through a retry, it is extremely
 	 * likely that the page will be found in page cache at that point.
diff -puN include/linux/mm.h~x86mm-make-pagefault-killable include/linux/mm.h
--- a/include/linux/mm.h~x86mm-make-pagefault-killable
+++ a/include/linux/mm.h
@@ -153,6 +153,7 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_MKWRITE	0x04	/* Fault was mkwrite of existing pte */
 #define FAULT_FLAG_ALLOW_RETRY	0x08	/* Retry fault if blocking */
 #define FAULT_FLAG_RETRY_NOWAIT	0x10	/* Don't drop mmap_sem and wait when retrying */
+#define FAULT_FLAG_KILLABLE	0x20	/* The fault task is in SIGKILL killable region */
 
 /*
  * This interface is used by x86 PAT code to identify a pfn mapping that is
diff -puN mm/filemap.c~x86mm-make-pagefault-killable mm/filemap.c
--- a/mm/filemap.c~x86mm-make-pagefault-killable
+++ a/mm/filemap.c
@@ -654,15 +654,32 @@ EXPORT_SYMBOL_GPL(__lock_page_killable);
 int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
 			 unsigned int flags)
 {
-	if (!(flags & FAULT_FLAG_ALLOW_RETRY)) {
-		__lock_page(page);
-		return 1;
-	} else {
-		if (!(flags & FAULT_FLAG_RETRY_NOWAIT)) {
-			up_read(&mm->mmap_sem);
+	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+		/*
+		 * CAUTION! In this case, mmap_sem is not released
+		 * even though return 0.
+		 */
+		if (flags & FAULT_FLAG_RETRY_NOWAIT)
+			return 0;
+
+		up_read(&mm->mmap_sem);
+		if (flags & FAULT_FLAG_KILLABLE)
+			wait_on_page_locked_killable(page);
+		else
 			wait_on_page_locked(page);
-		}
 		return 0;
+	} else {
+		if (flags & FAULT_FLAG_KILLABLE) {
+			int ret;
+
+			ret = __lock_page_killable(page);
+			if (ret) {
+				up_read(&mm->mmap_sem);
+				return 0;
+			}
+		} else
+			__lock_page(page);
+		return 1;
 	}
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-increase-reclaim_distance-to-30.patch
slab-use-numa_no_node.patch
m32r-convert-cpumask-api.patch
m32r-fix-spin_lock_irqsave-misuse.patch
m32r-remove-redundant-declaration.patch
getdelays-show-average-cpu-io-swap-reclaim-delays.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
vmscanmemcg-memcg-aware-swap-token.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
add-the-pagefault-count-into-memcg-stats.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

