From: akpm@linux-foundation.org
Subject: + smp_call_function_single-be-slightly-less-stupid.patch added to -mm tree
Date: Tue, 16 Dec 2008 14:47:25 -0800
Message-ID: <200812162247.mBGMlPHT002616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbYLPWsF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Dec 2008 17:48:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     smp_call_function_single(): be slightly less stupid
has been added to the -mm tree.  Its filename is
     smp_call_function_single-be-slightly-less-stupid.patch

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
@@ -21,6 +21,9 @@ struct call_single_data {
 	u16 priv;
 };
 
+int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
+				int wait);
+
 #ifdef CONFIG_SMP
 
 #include <linux/preempt.h>
@@ -76,8 +79,6 @@ smp_call_function_mask(cpumask_t mask, v
 	return 0;
 }
 
-int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
-				int wait);
 void __smp_call_function_single(int cpuid, struct call_single_data *data);
 
 /*
@@ -137,14 +138,6 @@ static inline int up_smp_call_function(v
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
diff -puN kernel/cpu.c~smp_call_function_single-be-slightly-less-stupid kernel/cpu.c
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
diff -puN kernel/Makefile~smp_call_function_single-be-slightly-less-stupid kernel/Makefile
--- a/kernel/Makefile~smp_call_function_single-be-slightly-less-stupid
+++ a/kernel/Makefile
@@ -39,7 +39,11 @@ obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
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
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
linux-timexh-cleanup-for-userspace.patch
kernel-hrtimerc-kill-warning.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
pci-uninline-pci_ioremap_bar.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-mmapc-fix-coding-style-fix.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
ioc4-automatically-load-sgiioc4-subordinate-module-checkpatch-fixes.patch
smp_call_function_single-be-slightly-less-stupid.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes-checkpatch-fixes.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
edac-x38-use-the-architectures-readq-function-fix-fix.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

