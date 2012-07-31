From: akpm@linux-foundation.org
Subject: [merged] powerpc-pseries-reconfig-notifier-error-injection-module.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:54:57 -0700
Message-ID: <20120731185457.D4A3F100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab2GaSy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:54:59 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:54:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, benh@kernel.crashing.org, davej@redhat.com, greg@kroah.com, michael@ellerman.id.au, paulus@samba.org, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: pSeries reconfig notifier error injection module
has been removed from the -mm tree.  Its filename was
     powerpc-pseries-reconfig-notifier-error-injection-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: powerpc: pSeries reconfig notifier error injection module

This provides the ability to inject artifical errors to pSeries reconfig
notifier chain callbacks.  It is controlled through debugfs interface
under /sys/kernel/debug/notifier-error-inject/pSeries-reconfig

If the notifier call chain should be failed with some events
notified, write the error code to "actions/<notifier event>/error".

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug                            |   17 +++++
 lib/Makefile                                 |    2 
 lib/pSeries-reconfig-notifier-error-inject.c |   51 +++++++++++++++++
 3 files changed, 70 insertions(+)

diff -puN lib/Kconfig.debug~powerpc-pseries-reconfig-notifier-error-injection-module lib/Kconfig.debug
--- a/lib/Kconfig.debug~powerpc-pseries-reconfig-notifier-error-injection-module
+++ a/lib/Kconfig.debug
@@ -1166,6 +1166,23 @@ config MEMORY_NOTIFIER_ERROR_INJECT
 
 	  If unsure, say N.
 
+config PSERIES_RECONFIG_NOTIFIER_ERROR_INJECT
+	tristate "pSeries reconfig notifier error injection module"
+	depends on PPC_PSERIES && NOTIFIER_ERROR_INJECTION
+	help
+	  This option provides the ability to inject artifical errors to
+	  pSeries reconfig notifier chain callbacks.  It is controlled
+	  through debugfs interface under
+	  /sys/kernel/debug/notifier-error-inject/pSeries-reconfig/
+
+	  If the notifier call chain should be failed with some events
+	  notified, write the error code to "actions/<notifier event>/error".
+
+	  To compile this code as a module, choose M here: the module will
+	  be called memory-notifier-error-inject.
+
+	  If unsure, say N.
+
 config FAULT_INJECTION
 	bool "Fault-injection framework"
 	depends on DEBUG_KERNEL
diff -puN lib/Makefile~powerpc-pseries-reconfig-notifier-error-injection-module lib/Makefile
--- a/lib/Makefile~powerpc-pseries-reconfig-notifier-error-injection-module
+++ a/lib/Makefile
@@ -94,6 +94,8 @@ obj-$(CONFIG_NOTIFIER_ERROR_INJECTION) +
 obj-$(CONFIG_CPU_NOTIFIER_ERROR_INJECT) += cpu-notifier-error-inject.o
 obj-$(CONFIG_PM_NOTIFIER_ERROR_INJECT) += pm-notifier-error-inject.o
 obj-$(CONFIG_MEMORY_NOTIFIER_ERROR_INJECT) += memory-notifier-error-inject.o
+obj-$(CONFIG_PSERIES_RECONFIG_NOTIFIER_ERROR_INJECT) += \
+	pSeries-reconfig-notifier-error-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
diff -puN /dev/null lib/pSeries-reconfig-notifier-error-inject.c
--- /dev/null
+++ a/lib/pSeries-reconfig-notifier-error-inject.c
@@ -0,0 +1,51 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <asm/pSeries_reconfig.h>
+
+#include "notifier-error-inject.h"
+
+static int priority;
+module_param(priority, int, 0);
+MODULE_PARM_DESC(priority, "specify pSeries reconfig notifier priority");
+
+static struct notifier_err_inject reconfig_err_inject = {
+	.actions = {
+		{ NOTIFIER_ERR_INJECT_ACTION(PSERIES_RECONFIG_ADD) },
+		{ NOTIFIER_ERR_INJECT_ACTION(PSERIES_RECONFIG_REMOVE) },
+		{ NOTIFIER_ERR_INJECT_ACTION(PSERIES_DRCONF_MEM_ADD) },
+		{ NOTIFIER_ERR_INJECT_ACTION(PSERIES_DRCONF_MEM_REMOVE) },
+		{}
+	}
+};
+
+static struct dentry *dir;
+
+static int err_inject_init(void)
+{
+	int err;
+
+	dir = notifier_err_inject_init("pSeries-reconfig",
+		notifier_err_inject_dir, &reconfig_err_inject, priority);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
+
+	err = pSeries_reconfig_notifier_register(&reconfig_err_inject.nb);
+	if (err)
+		debugfs_remove_recursive(dir);
+
+	return err;
+}
+
+static void err_inject_exit(void)
+{
+	pSeries_reconfig_notifier_unregister(&reconfig_err_inject.nb);
+	debugfs_remove_recursive(dir);
+}
+
+module_init(err_inject_init);
+module_exit(err_inject_exit);
+
+MODULE_DESCRIPTION("pSeries reconfig notifier error injection module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Akinobu Mita <akinobu.mita@gmail.com>");
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-fix-failcmdsh-warning.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch

