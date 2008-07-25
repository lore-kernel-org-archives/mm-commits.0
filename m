From: akpm@linux-foundation.org
Subject: - build-kernel-profileo-only-when-requested.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:32 -0700
Message-ID: <200807252254.m6PMsW0r002831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512AbYGYWyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:54:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     build kernel/profile.o only when requested
has been removed from the -mm tree.  Its filename was
     build-kernel-profileo-only-when-requested.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: build kernel/profile.o only when requested
From: Adrian Bunk <bunk@kernel.org>

Build kernel/profile.o only if CONFIG_PROFILING is enabled.

This makes CONFIG_PROFILING=n kernels smaller.

As a bonus, some profile_tick() calls and one branch from schedule() are
now eliminated with CONFIG_PROFILING=n (but I doubt these are
measurable effects).

This patch changes the effects of CONFIG_PROFILING=n, but I don't think
having more than two choices would be the better choice.

This patch also adds the name of the first parameter to the prototypes
of profile_{hits,tick}() since I anyway had to add them for the dummy
functions.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/profile.h |   56 ++++++++++++++++++++++++++------------
 kernel/Makefile         |    3 +-
 kernel/profile.c        |    4 --
 3 files changed, 41 insertions(+), 22 deletions(-)

diff -puN include/linux/profile.h~build-kernel-profileo-only-when-requested include/linux/profile.h
--- a/include/linux/profile.h~build-kernel-profileo-only-when-requested
+++ a/include/linux/profile.h
@@ -8,8 +8,6 @@
 
 #include <asm/errno.h>
 
-extern int prof_on __read_mostly;
-
 #define CPU_PROFILING	1
 #define SCHED_PROFILING	2
 #define SLEEP_PROFILING	3
@@ -19,14 +17,29 @@ struct proc_dir_entry;
 struct pt_regs;
 struct notifier_block;
 
+#if defined(CONFIG_PROFILING) && defined(CONFIG_PROC_FS)
+void create_prof_cpu_mask(struct proc_dir_entry *);
+#else
+#define create_prof_cpu_mask(x)			do { (void)(x); } while (0)
+#endif
+
+enum profile_type {
+	PROFILE_TASK_EXIT,
+	PROFILE_MUNMAP
+};
+
+#ifdef CONFIG_PROFILING
+
+extern int prof_on __read_mostly;
+
 /* init basic kernel profiler */
 void __init profile_init(void);
-void profile_tick(int);
+void profile_tick(int type);
 
 /*
  * Add multiple profiler hits to a given address:
  */
-void profile_hits(int, void *ip, unsigned int nr_hits);
+void profile_hits(int type, void *ip, unsigned int nr_hits);
 
 /*
  * Single profiler hit:
@@ -40,19 +53,6 @@ static inline void profile_hit(int type,
 		profile_hits(type, ip, 1);
 }
 
-#ifdef CONFIG_PROC_FS
-void create_prof_cpu_mask(struct proc_dir_entry *);
-#else
-#define create_prof_cpu_mask(x)			do { (void)(x); } while (0)
-#endif
-
-enum profile_type {
-	PROFILE_TASK_EXIT,
-	PROFILE_MUNMAP
-};
-
-#ifdef CONFIG_PROFILING
-
 struct task_struct;
 struct mm_struct;
 
@@ -80,6 +80,28 @@ struct pt_regs;
 
 #else
 
+#define prof_on 0
+
+static inline void profile_init(void)
+{
+	return;
+}
+
+static inline void profile_tick(int type)
+{
+	return;
+}
+
+static inline void profile_hits(int type, void *ip, unsigned int nr_hits)
+{
+	return;
+}
+
+static inline void profile_hit(int type, void *ip)
+{
+	return;
+}
+
 static inline int task_handoff_register(struct notifier_block * n)
 {
 	return -ENOSYS;
diff -puN kernel/Makefile~build-kernel-profileo-only-when-requested kernel/Makefile
--- a/kernel/Makefile~build-kernel-profileo-only-when-requested
+++ a/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
+obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
 	    sysctl.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
@@ -24,6 +24,7 @@ CFLAGS_REMOVE_sched_clock.o = -pg
 CFLAGS_REMOVE_sched.o = -mno-spe -pg
 endif
 
+obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
diff -puN kernel/profile.c~build-kernel-profileo-only-when-requested kernel/profile.c
--- a/kernel/profile.c~build-kernel-profileo-only-when-requested
+++ a/kernel/profile.c
@@ -112,8 +112,6 @@ void __init profile_init(void)
 
 /* Profile event notifications */
 
-#ifdef CONFIG_PROFILING
-
 static BLOCKING_NOTIFIER_HEAD(task_exit_notifier);
 static ATOMIC_NOTIFIER_HEAD(task_free_notifier);
 static BLOCKING_NOTIFIER_HEAD(munmap_notifier);
@@ -203,8 +201,6 @@ void unregister_timer_hook(int (*hook)(s
 }
 EXPORT_SYMBOL_GPL(unregister_timer_hook);
 
-#endif /* CONFIG_PROFILING */
-
 
 #ifdef CONFIG_SMP
 /*
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
include-video-atmel_lcdch-must-include-linux-workqueueh.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
drm-make-drm_minors_cleanup-static.patch
make-cgroup_seqfile_release-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
make-macfb_setup-static.patch
video-console-sticonrec-make-code-static.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
video-stifbc-make-2-functions-static.patch
reiser4.patch

