From: akpm@linux-foundation.org
Subject: [to-be-updated] pm-pm-notifier-error-injection.patch removed from -mm tree
Date: Sat, 23 Jul 2011 09:40:28 -0700
Message-ID: <201107231640.p6NGe03M028865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753071Ab1GWQk1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jul 2011 12:40:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, benh@kernel.crashing.org, greg@kroah.com, paulus@samba.org, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     PM: PM notifier error injection
has been removed from the -mm tree.  Its filename was
     pm-pm-notifier-error-injection.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PM: PM notifier error injection
From: Akinobu Mita <akinobu.mita@gmail.com>

This provides the ability to inject artifical errors to PM notifier chain
callbacks.  It is controlled through debugfs interface under
/sys/kernel/debug/pm-notifier-error-inject/

Each of the files in the directory represents an event which can be
failed and contains the error code.  If the notifier call chain should
be failed with some events notified, write the error code to the files.

Example: Inject PM suspend error (-12 = -ENOMEM)

	# cd /sys/kernel/debug/pm-notifier-error-inject
	# echo -12 > PM_SUSPEND_PREPARE
	# echo mem > /sys/power/state
	bash: echo: write error: Cannot allocate memory

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/main.c |   30 ++++++++++++++++++++++++++++++
 lib/Kconfig.debug   |   16 ++++++++++++++++
 2 files changed, 46 insertions(+)

diff -puN kernel/power/main.c~pm-pm-notifier-error-injection kernel/power/main.c
--- a/kernel/power/main.c~pm-pm-notifier-error-injection
+++ a/kernel/power/main.c
@@ -42,6 +42,36 @@ int pm_notifier_call_chain(unsigned long
 	return notifier_to_errno(ret);
 }
 
+#ifdef CONFIG_PM_NOTIFIER_ERROR_INJECTION
+
+static struct err_inject_notifier_block err_inject_pm_notifier = {
+	.actions = {
+		{ ERR_INJECT_NOTIFIER_ACTION(PM_HIBERNATION_PREPARE) },
+		{ ERR_INJECT_NOTIFIER_ACTION(PM_SUSPEND_PREPARE) },
+		{ ERR_INJECT_NOTIFIER_ACTION(PM_RESTORE_PREPARE) },
+		{}
+	}
+};
+
+static int __init err_inject_pm_notifier_init(void)
+{
+	int err;
+
+	err = err_inject_notifier_block_init(&err_inject_pm_notifier,
+				"pm-notifier-error-inject", -1);
+	if (err)
+		return err;
+
+	err = register_pm_notifier(&err_inject_pm_notifier.nb);
+	if (err)
+		err_inject_notifier_block_cleanup(&err_inject_pm_notifier);
+
+	return err;
+}
+late_initcall(err_inject_pm_notifier_init);
+
+#endif /* CONFIG_PM_NOTIFIER_ERROR_INJECTION */
+
 /* If set, devices may be suspended and resumed asynchronously. */
 int pm_async_enabled = 1;
 
diff -puN lib/Kconfig.debug~pm-pm-notifier-error-injection lib/Kconfig.debug
--- a/lib/Kconfig.debug~pm-pm-notifier-error-injection
+++ a/lib/Kconfig.debug
@@ -1053,6 +1053,22 @@ config CPU_NOTIFIER_ERROR_INJECTION
 	  # echo 0 > /sys/devices/system/cpu/cpu1/online
 	  bash: echo: write error: Operation not permitted
 
+config PM_NOTIFIER_ERROR_INJECTION
+	bool "PM notifier error injection"
+	depends on PM && NOTIFIER_ERROR_INJECTION
+	default PM_DEBUG
+	help
+	  This option provides the ability to inject artifical errors to
+	  PM notifier chain callbacks.  It is controlled through debugfs
+	  interface.
+
+	  Example: Inject PM suspend error (-12 = -ENOMEM)
+
+	  # cd /sys/kernel/debug/pm-notifier-error-inject
+	  # echo -12 > PM_SUSPEND_PREPARE
+	  # echo mem > /sys/power/state
+	  bash: echo: write error: Cannot allocate memory
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
memory-memory-notifier-error-injection.patch
powerpc-pseries-reconfig-notifier-error-injection.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch

