From: akpm@linux-foundation.org
Subject: + build-kernel-profileo-only-when-requested.patch added to -mm tree
Date: Tue, 20 May 2008 02:01:43 -0700
Message-ID: <200805200901.m4K91hde014480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756294AbYETJCU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 05:02:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, mingo@elte.hu


The patch titled
     build kernel/profile.o only when requested
has been added to the -mm tree.  Its filename is
     build-kernel-profileo-only-when-requested.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 	    exit.o itimer.o time.o softirq.o resource.o \
 	    sysctl.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
@@ -19,6 +19,7 @@ KBUILD_CFLAGS = $(if $(filter-out lockde
 	$(subst -pg,,$(ORIG_CFLAGS)))
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

linux-next.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
git-input.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-watchdog.patch
git-xtensa.patch
ibmaem-fix-64-bit-division-on-32-bit-platforms-update.patch
md-proper-extern-for-mdp_major.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
remove-include-asm-h8300-keyboardh.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-spawn_ksoftirqd-prototype.patch
build-kernel-profileo-only-when-requested.patch
remove-the-oss-trident-driver.patch
serial-8250_gscc-add-module_license.patch
mfd-sm501c-if-0-unused-functions.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
video-sis-remove-compat-code.patch
minix-remove-no_truncate-code.patch
remove-is_tty.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
reiser4.patch

