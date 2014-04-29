From: akpm@linux-foundation.org
Subject: + sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch
 added to -mm tree
Date: Tue, 29 Apr 2014 16:25:31 -0700
Message-ID: <536034eb.b0W02xI9DMVvmAv3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaD2XZc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Apr 2014 19:25:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, richard@nod.at, rdunlap@infradead.org, paulmck@linux.vnet.ibm.com, cxie@redhat.com, riel@redhat.com

Subject: + sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch added to -mm tree
To: riel@redhat.com,cxie@redhat.com,paulmck@linux.vnet.ibm.com,rdunlap@infradead.org,richard@nod.at
From: akpm@linux-foundation.org
Date: Tue, 29 Apr 2014 16:25:31 -0700


The patch titled
     Subject: sysrq,rcu: suppress RCU stall warnings while sysrq runs
has been added to the -mm tree.  Its filename is
     sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: sysrq,rcu: suppress RCU stall warnings while sysrq runs

Some sysrq handlers can run for a long time, because they dump a lot of
data onto a serial console.  Having RCU stall warnings pop up in the
middle of them only makes the problem worse.

This patch temporarily disables RCU stall warnings while a sysrq request
is handled.

[paulmck@linux.vnet.ibm.com: fix TINY_RCU build error]
Signed-off-by: Rik van Riel <riel@redhat.com>
Suggested-by: Paul McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Madper Xie <cxie@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c      |    3 +++
 include/linux/rcupdate.h |   12 ++++++++++++
 kernel/rcu/update.c      |   12 ++++++++++++
 3 files changed, 27 insertions(+)

diff -puN drivers/tty/sysrq.c~sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs
+++ a/drivers/tty/sysrq.c
@@ -46,6 +46,7 @@
 #include <linux/jiffies.h>
 #include <linux/syscalls.h>
 #include <linux/of.h>
+#include <linux/rcupdate.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
@@ -511,6 +512,7 @@ void __handle_sysrq(int key, bool check_
 	int orig_log_level;
 	int i;
 
+	rcu_sysrq_start();
 	rcu_read_lock();
 	/*
 	 * Raise the apparent loglevel to maximum so that the sysrq header
@@ -554,6 +556,7 @@ void __handle_sysrq(int key, bool check_
 		console_loglevel = orig_log_level;
 	}
 	rcu_read_unlock();
+	rcu_sysrq_end();
 }
 
 void handle_sysrq(int key)
diff -puN include/linux/rcupdate.h~sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs
+++ a/include/linux/rcupdate.h
@@ -228,6 +228,18 @@ void rcu_idle_exit(void);
 void rcu_irq_enter(void);
 void rcu_irq_exit(void);
 
+#ifdef CONFIG_RCU_STALL_COMMON
+void rcu_sysrq_start(void);
+void rcu_sysrq_end(void);
+#else /* #ifdef CONFIG_RCU_STALL_COMMON */
+static inline void rcu_sysrq_start(void)
+{
+}
+static inline void rcu_sysrq_end(void)
+{
+}
+#endif /* #else #ifdef CONFIG_RCU_STALL_COMMON */
+
 #ifdef CONFIG_RCU_USER_QS
 void rcu_user_enter(void);
 void rcu_user_exit(void);
diff -puN kernel/rcu/update.c~sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs kernel/rcu/update.c
--- a/kernel/rcu/update.c~sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs
+++ a/kernel/rcu/update.c
@@ -320,6 +320,18 @@ int rcu_jiffies_till_stall_check(void)
 	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;
 }
 
+void rcu_sysrq_start(void)
+{
+	if (!rcu_cpu_stall_suppress)
+		rcu_cpu_stall_suppress = 2;
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

mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom.patch
mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom-fix.patch
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
sysrq-rcu-ify-__handle_sysrq.patch
sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch
linux-next.patch

