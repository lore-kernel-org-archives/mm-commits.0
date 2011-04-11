From: akpm@linux-foundation.org
Subject: + x86mm-make-pagefault-killable.patch added to -mm tree
Date: Mon, 11 Apr 2011 15:05:25 -0700
Message-ID: <201104112205.p3BM5Qbr004025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756089Ab1DKWFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 18:05:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, mingo@elte.hu, tglx@linutronix.de, willy@linux.intel.com


The patch titled
     x86,mm: make pagefault killable
has been added to the -mm tree.  Its filename is
     x86mm-make-pagefault-killable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -964,7 +964,7 @@ do_page_fault(struct pt_regs *regs, unsi
 	struct mm_struct *mm;
 	int fault;
 	int write = error_code & PF_WRITE;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY |
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
 					(write ? FAULT_FLAG_WRITE : 0);
 
 	tsk = current;
@@ -1138,6 +1138,16 @@ good_area:
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
@@ -152,6 +152,7 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_MKWRITE	0x04	/* Fault was mkwrite of existing pte */
 #define FAULT_FLAG_ALLOW_RETRY	0x08	/* Retry fault if blocking */
 #define FAULT_FLAG_RETRY_NOWAIT	0x10	/* Don't drop mmap_sem and wait when retrying */
+#define FAULT_FLAG_KILLABLE	0x20	/* The fault task is in SIGKILL killable region */
 
 /*
  * This interface is used by x86 PAT code to identify a pfn mapping that is
diff -puN mm/filemap.c~x86mm-make-pagefault-killable mm/filemap.c
--- a/mm/filemap.c~x86mm-make-pagefault-killable
+++ a/mm/filemap.c
@@ -665,15 +665,32 @@ EXPORT_SYMBOL_GPL(__lock_page_killable);
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

memcg-fix-mem_cgroup_rotate_reclaimable_page.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-increase-reclaim_distance-to-30.patch
vmscan-all_unreclaimable-use-zone-all_unreclaimable-as-a-name.patch
oom-kill-remove-boost_dying_task_prio.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

