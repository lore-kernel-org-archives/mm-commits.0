From: akpm@linux-foundation.org
Subject: [to-be-updated] memory-memory-notifier-error-injection.patch removed from -mm tree
Date: Sat, 23 Jul 2011 09:40:30 -0700
Message-ID: <201107231640.p6NGe2OR028906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753071Ab1GWQk3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jul 2011 12:40:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, benh@kernel.crashing.org, greg@kroah.com, paulus@samba.org, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     memory: memory notifier error injection
has been removed from the -mm tree.  Its filename was
     memory-memory-notifier-error-injection.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory: memory notifier error injection
From: Akinobu Mita <akinobu.mita@gmail.com>

This provides the ability to inject artifical errors to memory hotplug
notifier chain callbacks.  It is controlled through debugfs interface
under /sys/kernel/debug/memory-notifier-error-inject/

Each of the files in the directory represents an event which can be failed
and contains the error code.  If the notifier call chain should be failed
with some events notified, write the error code to the files.

Example: Inject memory hotplug offline error (-12 == -ENOMEM)

	# cd /sys/kernel/debug/memory-notifier-error-inject
	# echo -12 > MEM_GOING_OFFLINE
	# echo offline > /sys/devices/system/memory/memoryXXX/state
	bash: echo: write error: Cannot allocate memory

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   29 +++++++++++++++++++++++++++++
 lib/Kconfig.debug     |   15 +++++++++++++++
 2 files changed, 44 insertions(+)

diff -puN drivers/base/memory.c~memory-memory-notifier-error-injection drivers/base/memory.c
--- a/drivers/base/memory.c~memory-memory-notifier-error-injection
+++ a/drivers/base/memory.c
@@ -88,6 +88,35 @@ void unregister_memory_isolate_notifier(
 }
 EXPORT_SYMBOL(unregister_memory_isolate_notifier);
 
+#ifdef CONFIG_MEMORY_NOTIFIER_ERROR_INJECTION
+
+static struct err_inject_notifier_block err_inject_memory_notifier = {
+	.actions = {
+		{ ERR_INJECT_NOTIFIER_ACTION(MEM_GOING_ONLINE) },
+		{ ERR_INJECT_NOTIFIER_ACTION(MEM_GOING_OFFLINE) },
+		{}
+	}
+};
+
+static int __init err_inject_memory_notifier_init(void)
+{
+	int err;
+
+	err = err_inject_notifier_block_init(&err_inject_memory_notifier,
+				"memory-notifier-error-inject", -1);
+	if (err)
+		return err;
+
+	err = register_memory_notifier(&err_inject_memory_notifier.nb);
+	if (err)
+		err_inject_notifier_block_cleanup(&err_inject_memory_notifier);
+
+	return err;
+}
+late_initcall(err_inject_memory_notifier_init);
+
+#endif /* CONFIG_MEMORY_NOTIFIER_ERROR_INJECTION */
+
 /*
  * register_memory - Setup a sysfs device for a memory block
  */
diff -puN lib/Kconfig.debug~memory-memory-notifier-error-injection lib/Kconfig.debug
--- a/lib/Kconfig.debug~memory-memory-notifier-error-injection
+++ a/lib/Kconfig.debug
@@ -1069,6 +1069,21 @@ config PM_NOTIFIER_ERROR_INJECTION
 	  # echo mem > /sys/power/state
 	  bash: echo: write error: Cannot allocate memory
 
+config MEMORY_NOTIFIER_ERROR_INJECTION
+	bool "Memory hotplug notifier error injection"
+	depends on MEMORY_HOTPLUG_SPARSE && NOTIFIER_ERROR_INJECTION
+	help
+	  This option provides the ability to inject artifical errors to
+	  memory hotplug notifier chain callbacks.  It is controlled through
+	  debugfs interface.
+
+	  Example: Inject memory hotplug offline error (-12 == -ENOMEM)
+
+	  # cd /sys/kernel/debug/memory-notifier-error-inject
+	  # echo -12 > MEM_GOING_OFFLINE
+	  # echo offline > /sys/devices/system/memory/memoryXXX/state
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
powerpc-pseries-reconfig-notifier-error-injection.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch

