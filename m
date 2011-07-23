From: akpm@linux-foundation.org
Subject: [to-be-updated] cpu-cpu-notifier-error-injection.patch removed from -mm tree
Date: Sat, 23 Jul 2011 09:40:25 -0700
Message-ID: <201107231639.p6NGdvrg028847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753087Ab1GWQk0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jul 2011 12:40:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, benh@kernel.crashing.org, greg@kroah.com, paulus@samba.org, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     cpu: CPU notifier error injection
has been removed from the -mm tree.  Its filename was
     cpu-cpu-notifier-error-injection.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu: CPU notifier error injection
From: Akinobu Mita <akinobu.mita@gmail.com>

This provides the ability to inject artifical errors to CPU notifier chain
callbacks.  It is controlled through debugfs interface under
/sys/kernel/debug/cpu-notifier-error-inject/

Each of the files in the directory represents an event which can be failed
and contains the error code.  If the notifier call chain should be failed
with some events notified, write the error code to the files.

Example1: inject CPU offline error (-1 == -EPERM)

	# echo -1 > /sys/kernel/debug/cpu-notifier-error-inject/CPU_UP_PREPARE
	# echo 0 > /sys/devices/system/cpu/cpu1/online
	bash: echo: write error: Operation not permitted

Example2: inject CPU online error (-2 == -ENOENT)

	# echo -2 > /sys/kernel/debug/cpu-notifier-error-inject/CPU_DOWN_PREPARE
	# echo 1 > /sys/devices/system/cpu/cpu1/online
	bash: echo: write error: No such file or directory

This also schedules cpu-notifier-error-inject.ko module for removal in
favor of more generic interface.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    8 ++++
 kernel/cpu.c                               |   31 +++++++++++++++++++
 lib/Kconfig.debug                          |   20 ++++++++++++
 3 files changed, 59 insertions(+)

diff -puN Documentation/feature-removal-schedule.txt~cpu-cpu-notifier-error-injection Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~cpu-cpu-notifier-error-injection
+++ a/Documentation/feature-removal-schedule.txt
@@ -616,3 +616,11 @@ Why:	This driver has been superseded by 
 Who:	Alan Stern <stern@rowland.harvard.edu>
 
 ----------------------------
+
+What:	Support for CPU_NOTIFIER_ERROR_INJECT (cpu-notifier-error-inject.ko)
+When:	3.3
+Why:	Replaced with more generic debugfs interface in
+	/sys/kernel/debug/cpu-notifier-error-inject/
+Who:	Akinobu Mita <akinobu.mita@gmail.com>
+
+----------------------------
diff -puN kernel/cpu.c~cpu-cpu-notifier-error-injection kernel/cpu.c
--- a/kernel/cpu.c~cpu-cpu-notifier-error-injection
+++ a/kernel/cpu.c
@@ -170,6 +170,37 @@ void __ref unregister_cpu_notifier(struc
 }
 EXPORT_SYMBOL(unregister_cpu_notifier);
 
+#ifdef CONFIG_CPU_NOTIFIER_ERROR_INJECTION
+
+static struct err_inject_notifier_block err_inject_cpu_notifier = {
+	.actions = {
+		{ ERR_INJECT_NOTIFIER_ACTION(CPU_UP_PREPARE) },
+		{ ERR_INJECT_NOTIFIER_ACTION(CPU_UP_PREPARE_FROZEN) },
+		{ ERR_INJECT_NOTIFIER_ACTION(CPU_DOWN_PREPARE) },
+		{ ERR_INJECT_NOTIFIER_ACTION(CPU_DOWN_PREPARE_FROZEN) },
+		{}
+	}
+};
+
+static int __init err_inject_cpu_notifier_init(void)
+{
+	int err;
+
+	err = err_inject_notifier_block_init(&err_inject_cpu_notifier,
+				"cpu-notifier-error-inject", -1);
+	if (err)
+		return err;
+
+	err = register_hotcpu_notifier(&err_inject_cpu_notifier.nb);
+	if (err)
+		err_inject_notifier_block_cleanup(&err_inject_cpu_notifier);
+
+	return err;
+}
+late_initcall(err_inject_cpu_notifier_init);
+
+#endif /* CONFIG_CPU_NOTIFIER_ERROR_INJECTION */
+
 static inline void check_for_tasks(int cpu)
 {
 	struct task_struct *p;
diff -puN lib/Kconfig.debug~cpu-cpu-notifier-error-injection lib/Kconfig.debug
--- a/lib/Kconfig.debug~cpu-cpu-notifier-error-injection
+++ a/lib/Kconfig.debug
@@ -1033,6 +1033,26 @@ config NOTIFIER_ERROR_INJECTION
 
 	  Say N if unsure.
 
+config CPU_NOTIFIER_ERROR_INJECTION
+	bool "CPU notifier error injection"
+	depends on HOTPLUG_CPU && NOTIFIER_ERROR_INJECTION
+	help
+	  This option provides the ability to inject artifical errors to
+	  CPU notifier chain callbacks.  It is controlled through debugfs
+	  interface under /sys/kernel/debug/cpu-notifier-error-inject/
+
+	  Each of the files in the directory represents an event which can be
+	  failed and contains the error code.  If the notifier call chain
+	  should be failed with some events notified, write the error code to
+	  the files.
+
+	  Example: Inject CPU offline error (-1 == -EPERM)
+
+	  # cd /sys/kernel/debug/cpu-notifier-error-inject
+	  # echo -1 > CPU_UP_PREPARE
+	  # echo 0 > /sys/devices/system/cpu/cpu1/online
+	  bash: echo: write error: Operation not permitted
+
 config CPU_NOTIFIER_ERROR_INJECT
 	tristate "CPU notifier error injection module"
 	depends on HOTPLUG_CPU && DEBUG_KERNEL
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
reiserfs-use-proper-little-endian-bitops.patch
reiserfs-use-hweight_long.patch
fault-injection-do-not-include-unneeded-header.patch
fault-injection-remove-nonexistent-function-extern.patch
fault-injection-cleanup-simple-attribute-of-stacktrace_depth.patch
fault-injection-use-debugfs_remove_recursive.patch
failslab-simplify-debugfs-initialization.patch
fail_page_alloc-simplify-debugfs-initialization.patch
fail_make_request-cleanup-should_fail_request.patch
pm-pm-notifier-error-injection.patch
memory-memory-notifier-error-injection.patch
powerpc-pseries-reconfig-notifier-error-injection.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch

