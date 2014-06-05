From: akpm@linux-foundation.org
Subject: [merged] memcg-kill-config_mm_owner.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:50:13 -0700
Message-ID: <5390c9f5.4BeKHZ2p+QyD71ba%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaFETuO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, oleg@redhat.com

Subject: [merged] memcg-kill-config_mm_owner.patch removed from -mm tree
To: oleg@redhat.com,hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:13 -0700


The patch titled
     Subject: memcg: kill CONFIG_MM_OWNER
has been removed from the -mm tree.  Its filename was
     memcg-kill-config_mm_owner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: memcg: kill CONFIG_MM_OWNER

CONFIG_MM_OWNER makes no sense.  It is not user-selectable, it is only
selected by CONFIG_MEMCG automatically.  So we can kill this option in
init/Kconfig and do s/CONFIG_MM_OWNER/CONFIG_MEMCG/ globally.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 +-
 include/linux/sched.h    |    4 ++--
 init/Kconfig             |    7 -------
 kernel/exit.c            |    4 ++--
 kernel/fork.c            |    4 ++--
 5 files changed, 7 insertions(+), 14 deletions(-)

diff -puN include/linux/mm_types.h~memcg-kill-config_mm_owner include/linux/mm_types.h
--- a/include/linux/mm_types.h~memcg-kill-config_mm_owner
+++ a/include/linux/mm_types.h
@@ -406,7 +406,7 @@ struct mm_struct {
 	spinlock_t			ioctx_lock;
 	struct kioctx_table __rcu	*ioctx_table;
 #endif
-#ifdef CONFIG_MM_OWNER
+#ifdef CONFIG_MEMCG
 	/*
 	 * "owner" points to a task that is regarded as the canonical
 	 * user/owner of this mm. All of the following must be true in
diff -puN include/linux/sched.h~memcg-kill-config_mm_owner include/linux/sched.h
--- a/include/linux/sched.h~memcg-kill-config_mm_owner
+++ a/include/linux/sched.h
@@ -2967,7 +2967,7 @@ static inline void inc_syscw(struct task
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
-#ifdef CONFIG_MM_OWNER
+#ifdef CONFIG_MEMCG
 extern void mm_update_next_owner(struct mm_struct *mm);
 extern void mm_init_owner(struct mm_struct *mm, struct task_struct *p);
 #else
@@ -2978,7 +2978,7 @@ static inline void mm_update_next_owner(
 static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 {
 }
-#endif /* CONFIG_MM_OWNER */
+#endif /* CONFIG_MEMCG */
 
 static inline unsigned long task_rlimit(const struct task_struct *tsk,
 		unsigned int limit)
diff -puN init/Kconfig~memcg-kill-config_mm_owner init/Kconfig
--- a/init/Kconfig~memcg-kill-config_mm_owner
+++ a/init/Kconfig
@@ -933,7 +933,6 @@ config RESOURCE_COUNTERS
 config MEMCG
 	bool "Memory Resource Controller for Control Groups"
 	depends on RESOURCE_COUNTERS
-	select MM_OWNER
 	select EVENTFD
 	help
 	  Provides a memory resource controller that manages both anonymous
@@ -951,9 +950,6 @@ config MEMCG
 	  disable memory resource controller and you can avoid overheads.
 	  (and lose benefits of memory resource controller)
 
-	  This config option also selects MM_OWNER config option, which
-	  could in turn add some fork/exit overhead.
-
 config MEMCG_SWAP
 	bool "Memory Resource Controller Swap Extension"
 	depends on MEMCG && SWAP
@@ -1179,9 +1175,6 @@ config SCHED_AUTOGROUP
 	  desktop applications.  Task group autogeneration is currently based
 	  upon task session.
 
-config MM_OWNER
-	bool
-
 config SYSFS_DEPRECATED
 	bool "Enable deprecated sysfs features to support old userspace tools"
 	depends on SYSFS
diff -puN kernel/exit.c~memcg-kill-config_mm_owner kernel/exit.c
--- a/kernel/exit.c~memcg-kill-config_mm_owner
+++ a/kernel/exit.c
@@ -352,7 +352,7 @@ int disallow_signal(int sig)
 
 EXPORT_SYMBOL(disallow_signal);
 
-#ifdef CONFIG_MM_OWNER
+#ifdef CONFIG_MEMCG
 /*
  * A task is exiting.   If it owned this mm, find a new owner for the mm.
  */
@@ -434,7 +434,7 @@ assign_new_owner:
 	task_unlock(c);
 	put_task_struct(c);
 }
-#endif /* CONFIG_MM_OWNER */
+#endif /* CONFIG_MEMCG */
 
 /*
  * Turn us into a lazy TLB process if we
diff -puN kernel/fork.c~memcg-kill-config_mm_owner kernel/fork.c
--- a/kernel/fork.c~memcg-kill-config_mm_owner
+++ a/kernel/fork.c
@@ -1099,12 +1099,12 @@ static void rt_mutex_init_task(struct ta
 #endif
 }
 
-#ifdef CONFIG_MM_OWNER
+#ifdef CONFIG_MEMCG
 void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 {
 	mm->owner = p;
 }
-#endif /* CONFIG_MM_OWNER */
+#endif /* CONFIG_MEMCG */
 
 /*
  * Initialize POSIX timer handling for a single task.
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-fix-fork-event-messages-across-pid-namespaces.patch
ptrace-task_clear_jobctl_trapping-wake_up_bit-needs-mb.patch
signals-kill-sigfindinword.patch
signals-s-siginitset-sigemptyset-in-do_sigtimedwait.patch
signals-kill-rm_from_queue-change-prepare_signal-to-use-for_each_thread.patch
signals-rename-rm_from_queue_full-to-flush_sigqueue_mask.patch
signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch
signals-mv-disallow_signal-from-schedh-exitc-to-signal.patch
signals-jffs2-fix-the-wrong-usage-of-disallow_signal.patch
signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch
signals-disallow_signal-should-flush-the-potentially-pending-signal.patch
signals-introduce-kernel_sigaction.patch
signals-change-wait_for_helper-to-use-kernel_sigaction.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
linux-next.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch

