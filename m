From: akpm@linux-foundation.org
Subject: [to-be-updated] powerpc-pseries-reconfig-notifier-error-injection.patch removed from -mm tree
Date: Sat, 23 Jul 2011 09:40:32 -0700
Message-ID: <201107231640.p6NGe46J028913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753071Ab1GWQkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jul 2011 12:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, benh@kernel.crashing.org, greg@kroah.com, paulus@samba.org, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     powerpc: pSeries reconfig notifier error injection
has been removed from the -mm tree.  Its filename was
     powerpc-pseries-reconfig-notifier-error-injection.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: pSeries reconfig notifier error injection
From: Akinobu Mita <akinobu.mita@gmail.com>

This provides the ability to inject artifical errors to pSeries reconfig
notifier chain callbacks.  It is controlled through debugfs interface
under /sys/kernel/debug/pSeries-reconfig-notifier-error-inject/

Each of the files in the directory represents an event which can be failed
and contains the error code.  If the notifier call chain should be failed
with some events notified, write the error code to the files.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/reconfig.c |   31 ++++++++++++++++++++
 lib/Kconfig.debug                         |    9 +++++
 2 files changed, 40 insertions(+)

diff -puN arch/powerpc/platforms/pseries/reconfig.c~powerpc-pseries-reconfig-notifier-error-injection arch/powerpc/platforms/pseries/reconfig.c
--- a/arch/powerpc/platforms/pseries/reconfig.c~powerpc-pseries-reconfig-notifier-error-injection
+++ a/arch/powerpc/platforms/pseries/reconfig.c
@@ -117,6 +117,37 @@ int pSeries_reconfig_notify(unsigned lon
 	return notifier_to_errno(err);
 }
 
+#ifdef CONFIG_PSERIES_RECONFIG_NOTIFIER_ERROR_INJECTION
+
+static struct err_inject_notifier_block err_inject_reconfig_nb = {
+	.actions = {
+		{ ERR_INJECT_NOTIFIER_ACTION(PSERIES_RECONFIG_ADD) },
+		{ ERR_INJECT_NOTIFIER_ACTION(PSERIES_RECONFIG_REMOVE) },
+		{ ERR_INJECT_NOTIFIER_ACTION(PSERIES_DRCONF_MEM_ADD) },
+		{ ERR_INJECT_NOTIFIER_ACTION(PSERIES_DRCONF_MEM_REMOVE) },
+		{}
+	}
+};
+
+static int __init err_inject_reconfig_notifier_init(void)
+{
+	int err;
+
+	err = err_inject_notifier_block_init(&err_inject_reconfig_nb,
+			"pSeries-reconfig-notifier-error-inject", -1);
+	if (err)
+		return err;
+
+	err = pSeries_reconfig_notifier_register(&err_inject_reconfig_nb.nb);
+	if (err)
+		err_inject_notifier_block_cleanup(&err_inject_reconfig_nb);
+
+	return err;
+}
+late_initcall(err_inject_reconfig_notifier_init);
+
+#endif /* CONFIG_PSERIES_RECONFIG_NOTIFIER_ERROR_INJECTION */
+
 static int pSeries_reconfig_add_node(const char *path, struct property *proplist)
 {
 	struct device_node *np;
diff -puN lib/Kconfig.debug~powerpc-pseries-reconfig-notifier-error-injection lib/Kconfig.debug
--- a/lib/Kconfig.debug~powerpc-pseries-reconfig-notifier-error-injection
+++ a/lib/Kconfig.debug
@@ -1084,6 +1084,15 @@ config MEMORY_NOTIFIER_ERROR_INJECTION
 	  # echo offline > /sys/devices/system/memory/memoryXXX/state
 	  bash: echo: write error: Cannot allocate memory
 
+config PSERIES_RECONFIG_NOTIFIER_ERROR_INJECTION
+	bool "pSeries reconfig notifier error injection"
+	depends on PPC_PSERIES && NOTIFIER_ERROR_INJECTION
+	help
+	  This option provides the ability to inject artifical errors to
+	  pSeries reconfig notifier chain callbacks.  It is controlled
+	  through debugfs interface under
+	  /sys/kernel/debug/pSeries-reconfig-notifier-error-inject/
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
asm-generic-add-another-generic-ext2-atomic-bitops.patch

