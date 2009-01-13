From: akpm@linux-foundation.org
Subject: [merged] smp_call_function_single-be-slightly-less-stupid.patch removed from -mm tree
Date: Tue, 13 Jan 2009 12:13:30 -0800
Message-ID: <200901132013.n0DKDUcL012557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754952AbZAMUNt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 15:13:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     smp_call_function_single(): be slightly less stupid
has been removed from the -mm tree.  Its filename was
     smp_call_function_single-be-slightly-less-stupid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smp_call_function_single(): be slightly less stupid
From: Andrew Morton <akpm@linux-foundation.org>

If you do

	smp_call_function_single(expression-with-side-effects, ...)

then expression-with-side-effects never gets evaluated on UP builds.

As always, implementing it in C is the correct thing to do.

While we're there, uninline it for size and possible header dependency
reasons.

And create a new kernel/up.c, as a place in which to put
uniprocessor-specific code and storage.  It should mirror kernel/smp.c.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |   13 +++----------
 kernel/Makefile     |    6 +++++-
 kernel/up.c         |   18 ++++++++++++++++++
 3 files changed, 26 insertions(+), 11 deletions(-)

diff -puN include/linux/smp.h~smp_call_function_single-be-slightly-less-stupid include/linux/smp.h
--- a/include/linux/smp.h~smp_call_function_single-be-slightly-less-stupid
+++ a/include/linux/smp.h
@@ -24,6 +24,9 @@ struct call_single_data {
 /* total number of cpus in this system (may exceed NR_CPUS) */
 extern unsigned int total_cpus;
 
+int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
+				int wait);
+
 #ifdef CONFIG_SMP
 
 #include <linux/preempt.h>
@@ -79,8 +82,6 @@ smp_call_function_mask(cpumask_t mask, v
 	return 0;
 }
 
-int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
-				int wait);
 void __smp_call_function_single(int cpuid, struct call_single_data *data);
 
 /*
@@ -140,14 +141,6 @@ static inline int up_smp_call_function(v
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
-#define smp_call_function_single(cpuid, func, info, wait) \
-({ \
-	WARN_ON(cpuid != 0);	\
-	local_irq_disable();	\
-	(func)(info);		\
-	local_irq_enable();	\
-	0;			\
-})
 #define smp_call_function_mask(mask, func, info, wait) \
 			(up_smp_call_function(func, info))
 #define smp_call_function_many(mask, func, info, wait) \
diff -puN kernel/Makefile~smp_call_function_single-be-slightly-less-stupid kernel/Makefile
--- a/kernel/Makefile~smp_call_function_single-be-slightly-less-stupid
+++ a/kernel/Makefile
@@ -40,7 +40,11 @@ obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
-obj-$(CONFIG_USE_GENERIC_SMP_HELPERS) += smp.o
+ifeq ($(CONFIG_USE_GENERIC_SMP_HELPERS),y)
+obj-y += smp.o
+else
+obj-y += up.o
+endif
 obj-$(CONFIG_SMP) += spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
diff -puN /dev/null kernel/up.c
--- /dev/null
+++ a/kernel/up.c
@@ -0,0 +1,18 @@
+/*
+ * Uniprocessor-only support functions.  The counterpart to kernel/smp.c
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/smp.h>
+
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+				int wait)
+{
+	WARN_ON(cpuid != 0);
+	local_irq_disable();
+	(func)(info);
+	local_irq_enable();
+	return 0;
+}
+EXPORT_SYMBOL(smp_call_function_single);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
alpha-fix-vmalloc-breakage-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
rtc-cumulative-style-fixes-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

