From: akpm@linux-foundation.org
Subject: [to-be-updated]
 sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch removed from
 -mm tree
Date: Mon, 28 Apr 2014 16:05:22 -0700
Message-ID: <535edeb2.HgMu462K6Jgm+KOJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbaD1XFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Apr 2014 19:05:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, paulmck@linux.vnet.ibm.com, jslaby@suse.cz, joern@logfs.org, jkosina@suse.cz, gregkh@linuxfoundation.org, cxie@redhat.com, riel@redhat.com

Subject: [to-be-updated] sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch removed from -mm tree
To: riel@redhat.com,cxie@redhat.com,gregkh@linuxfoundation.org,jkosina@suse.cz,joern@logfs.org,jslaby@suse.cz,paulmck@linux.vnet.ibm.com,peterz@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 28 Apr 2014 16:05:22 -0700


The patch titled
     Subject: sysrq,rcu: suppress RCU stall warnings while sysrq runs
has been removed from the -mm tree.  Its filename was
     sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: sysrq,rcu: suppress RCU stall warnings while sysrq runs

Some sysrq handlers can run for a long time, because they dump a lot
of data onto a serial console. Having RCU stall warnings pop up in
the middle of them only makes the problem worse.

This patch temporarily disables RCU stall warnings while a sysrq
request is handled.

Signed-off-by: Rik van Riel <riel@redhat.com>
Suggested-by: Paul McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Joern Engel <joern@logfs.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Madper Xie <cxie@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c      |    2 ++
 include/linux/rcupdate.h |    2 ++
 kernel/rcu/update.c      |   11 +++++++++++
 3 files changed, 15 insertions(+)

diff -puN drivers/tty/sysrq.c~sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs
+++ a/drivers/tty/sysrq.c
@@ -511,6 +511,7 @@ void __handle_sysrq(int key, bool check_
 	int orig_log_level;
 	int i;
 
+	rcu_sysrq_start();
 	rcu_read_lock();
 	/*
 	 * Raise the apparent loglevel to maximum so that the sysrq header
@@ -554,6 +555,7 @@ void __handle_sysrq(int key, bool check_
 		console_loglevel = orig_log_level;
 	}
 	rcu_read_unlock();
+	rcu_sysrq_end();
 }
 
 void handle_sysrq(int key)
diff -puN include/linux/rcupdate.h~sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs
+++ a/include/linux/rcupdate.h
@@ -227,6 +227,8 @@ void rcu_idle_enter(void);
 void rcu_idle_exit(void);
 void rcu_irq_enter(void);
 void rcu_irq_exit(void);
+void rcu_sysrq_start(void);
+void rcu_sysrq_end(void);
 
 #ifdef CONFIG_RCU_USER_QS
 void rcu_user_enter(void);
diff -puN kernel/rcu/update.c~sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs kernel/rcu/update.c
--- a/kernel/rcu/update.c~sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs
+++ a/kernel/rcu/update.c
@@ -320,6 +320,17 @@ int rcu_jiffies_till_stall_check(void)
 	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;
 }
 
+void rcu_sysrq_start(void)
+{
+	rcu_cpu_stall_suppress = 2;
+}
+
+void rcu_sysrq_end(void)
+{
+	if (rcu_cpu_stall_suppress == 2)
+		rcu_cpu_stall_suppress = 0;
+}
+
 static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
 {
 	rcu_cpu_stall_suppress = 1;
_

Patches currently in -mm which might be from riel@redhat.com are

mm-compaction-make-isolate_freepages-start-at-pageblock-boundary.patch
revert-mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch
x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-mmapc-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

