From: akpm@linux-foundation.org
Subject: + smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch added to -mm tree
Date: Fri, 27 Jan 2012 16:15:45 -0800
Message-ID: <20120128001545.C06E8A043A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:52838 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2A1APq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 19:15:46 -0500
Received: by mail-yx0-f202.google.com with SMTP id r8so218726yen.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 16:15:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gilad@benyossef.com


The patch titled
     Subject: smp-add-func-to-ipi-cpus-based-on-parameter-func-fix
has been added to the -mm tree.  Its filename is
     smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: smp-add-func-to-ipi-cpus-based-on-parameter-func-fix

s/gfpflags/gfp_flags/

Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |   20 ++++++++++----------
 kernel/smp.c        |    8 ++++----
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN include/linux/smp.h~smp-add-func-to-ipi-cpus-based-on-parameter-func-fix include/linux/smp.h
--- a/include/linux/smp.h~smp-add-func-to-ipi-cpus-based-on-parameter-func-fix
+++ a/include/linux/smp.h
@@ -115,7 +115,7 @@ void on_each_cpu_mask(const struct cpuma
  */
 void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
 		smp_call_func_t func, void *info, bool wait,
-		gfp_t gfpflags);
+		gfp_t gfp_flags);
 
 /*
  * Mark the boot cpu "online" so that it can call console drivers in
@@ -162,15 +162,15 @@ static inline int up_smp_call_function(s
 			local_irq_enable();		\
 		}					\
 	} while (0)
-#define on_each_cpu_cond(cond_func, func, info, wait, gfpflags) \
-	do {						\
-		preempt_disable();			\
-		if (cond_func(0, info)) {		\
-			local_irq_disable();		\
-			(func)(info);			\
-			local_irq_enable();		\
-		}					\
-		preempt_enable();			\
+#define on_each_cpu_cond(cond_func, func, info, wait, gfp_flags)\
+	do {							\
+		preempt_disable();				\
+		if (cond_func(0, info)) {			\
+			local_irq_disable();			\
+			(func)(info);				\
+			local_irq_enable();			\
+		}						\
+		preempt_enable();				\
 	} while (0)
 
 static inline void smp_send_reschedule(int cpu) { }
diff -puN kernel/smp.c~smp-add-func-to-ipi-cpus-based-on-parameter-func-fix kernel/smp.c
--- a/kernel/smp.c~smp-add-func-to-ipi-cpus-based-on-parameter-func-fix
+++ a/kernel/smp.c
@@ -746,7 +746,7 @@ EXPORT_SYMBOL(on_each_cpu_mask);
  * @info:	An arbitrary pointer to pass to both functions.
  * @wait:	If true, wait (atomically) until function has
  *		completed on other CPUs.
- * @gfpflags:	GFP flags to use when allocating the cpumask
+ * @gfp_flags:	GFP flags to use when allocating the cpumask
  *		used internally by the function.
  *
  * The function might sleep if the GFP flags indicates a non
@@ -757,14 +757,14 @@ EXPORT_SYMBOL(on_each_cpu_mask);
  */
 void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
 			smp_call_func_t func, void *info, bool wait,
-			gfp_t gfpflags)
+			gfp_t gfp_flags)
 {
 	cpumask_var_t cpus;
 	int cpu, ret;
 
-	might_sleep_if(gfpflags & __GFP_WAIT);
+	might_sleep_if(gfp_flags & __GFP_WAIT);
 
-	if (likely(zalloc_cpumask_var(&cpus, (gfpflags|__GFP_NOWARN)))) {
+	if (likely(zalloc_cpumask_var(&cpus, (gfp_flags|__GFP_NOWARN)))) {
 		preempt_disable();
 		for_each_online_cpu(cpu)
 			if (cond_func(cpu, info))
_
Subject: Subject: smp-add-func-to-ipi-cpus-based-on-parameter-func-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-memcontrolc-fix-warning-with-config_numa=n.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

