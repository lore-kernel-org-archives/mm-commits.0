From: akpm@linux-foundation.org
Subject: [merged] cpu-rewrite-cpu-notifier-error-inject-module.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:54:44 -0700
Message-ID: <20120731185445.A720A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:59335 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab2GaSys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:54:48 -0400
Received: by eaao12 with SMTP id o12so241579eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:54:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, benh@kernel.crashing.org, davej@redhat.com, greg@kroah.com, michael@ellerman.id.au, paulus@samba.org, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Subject: cpu: rewrite cpu-notifier-error-inject module
has been removed from the -mm tree.  Its filename was
     cpu-rewrite-cpu-notifier-error-inject-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: cpu: rewrite cpu-notifier-error-inject module

Rewrite existing cpu-notifier-error-inject module to use debugfs based new
framework.

This change removes cpu_up_prepare_error and cpu_down_prepare_error module
parameters which were used to specify error code to be injected.  We could
keep these module parameters for backward compatibility by module_param_cb
but it seems overkill for this module.

This provides the ability to inject artifical errors to CPU notifier chain
callbacks.  It is controlled through debugfs interface under
/sys/kernel/debug/notifier-error-inject/cpu

If the notifier call chain should be failed with some events notified,
write the error code to "actions/<notifier event>/error".

Example1: inject CPU offline error (-1 == -EPERM)

	# cd /sys/kernel/debug/notifier-error-inject/cpu
	# echo -1 > actions/CPU_DOWN_PREPARE/error
	# echo 0 > /sys/devices/system/cpu/cpu1/online
	bash: echo: write error: Operation not permitted

Example2: inject CPU online error (-2 == -ENOENT)

	# cd /sys/kernel/debug/notifier-error-inject/cpu
	# echo -2 > actions/CPU_UP_PREPARE/error
	# echo 1 > /sys/devices/system/cpu/cpu1/online
	bash: echo: write error: No such file or directory

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

 lib/Kconfig.debug               |   16 ++++++-
 lib/cpu-notifier-error-inject.c |   63 +++++++++++-------------------
 2 files changed, 39 insertions(+), 40 deletions(-)

diff -puN lib/Kconfig.debug~cpu-rewrite-cpu-notifier-error-inject-module lib/Kconfig.debug
--- a/lib/Kconfig.debug~cpu-rewrite-cpu-notifier-error-inject-module
+++ a/lib/Kconfig.debug
@@ -1097,10 +1097,22 @@ config NOTIFIER_ERROR_INJECTION
 
 config CPU_NOTIFIER_ERROR_INJECT
 	tristate "CPU notifier error injection module"
-	depends on HOTPLUG_CPU && DEBUG_KERNEL
+	depends on HOTPLUG_CPU && NOTIFIER_ERROR_INJECTION
 	help
 	  This option provides a kernel module that can be used to test
-	  the error handling of the cpu notifiers
+	  the error handling of the cpu notifiers by injecting artifical
+	  errors to CPU notifier chain callbacks.  It is controlled through
+	  debugfs interface under /sys/kernel/debug/notifier-error-inject/cpu
+
+	  If the notifier call chain should be failed with some events
+	  notified, write the error code to "actions/<notifier event>/error".
+
+	  Example: Inject CPU offline error (-1 == -EPERM)
+
+	  # cd /sys/kernel/debug/notifier-error-inject/cpu
+	  # echo -1 > actions/CPU_DOWN_PREPARE/error
+	  # echo 0 > /sys/devices/system/cpu/cpu1/online
+	  bash: echo: write error: Operation not permitted
 
 	  To compile this code as a module, choose M here: the module will
 	  be called cpu-notifier-error-inject.
diff -puN lib/cpu-notifier-error-inject.c~cpu-rewrite-cpu-notifier-error-inject-module lib/cpu-notifier-error-inject.c
--- a/lib/cpu-notifier-error-inject.c~cpu-rewrite-cpu-notifier-error-inject-module
+++ a/lib/cpu-notifier-error-inject.c
@@ -1,58 +1,45 @@
 #include <linux/kernel.h>
-#include <linux/cpu.h>
 #include <linux/module.h>
-#include <linux/notifier.h>
+#include <linux/cpu.h>
 
-static int priority;
-static int cpu_up_prepare_error;
-static int cpu_down_prepare_error;
+#include "notifier-error-inject.h"
 
+static int priority;
 module_param(priority, int, 0);
 MODULE_PARM_DESC(priority, "specify cpu notifier priority");
 
-module_param(cpu_up_prepare_error, int, 0644);
-MODULE_PARM_DESC(cpu_up_prepare_error,
-		"specify error code to inject CPU_UP_PREPARE action");
-
-module_param(cpu_down_prepare_error, int, 0644);
-MODULE_PARM_DESC(cpu_down_prepare_error,
-		"specify error code to inject CPU_DOWN_PREPARE action");
-
-static int err_inject_cpu_callback(struct notifier_block *nfb,
-				unsigned long action, void *hcpu)
-{
-	int err = 0;
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		err = cpu_up_prepare_error;
-		break;
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		err = cpu_down_prepare_error;
-		break;
+static struct notifier_err_inject cpu_notifier_err_inject = {
+	.actions = {
+		{ NOTIFIER_ERR_INJECT_ACTION(CPU_UP_PREPARE) },
+		{ NOTIFIER_ERR_INJECT_ACTION(CPU_UP_PREPARE_FROZEN) },
+		{ NOTIFIER_ERR_INJECT_ACTION(CPU_DOWN_PREPARE) },
+		{ NOTIFIER_ERR_INJECT_ACTION(CPU_DOWN_PREPARE_FROZEN) },
+		{}
 	}
-	if (err)
-		printk(KERN_INFO "Injecting error (%d) at cpu notifier\n", err);
-
-	return notifier_from_errno(err);
-}
-
-static struct notifier_block err_inject_cpu_notifier = {
-	.notifier_call = err_inject_cpu_callback,
 };
 
+static struct dentry *dir;
+
 static int err_inject_init(void)
 {
-	err_inject_cpu_notifier.priority = priority;
+	int err;
+
+	dir = notifier_err_inject_init("cpu", notifier_err_inject_dir,
+					&cpu_notifier_err_inject, priority);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
+
+	err = register_hotcpu_notifier(&cpu_notifier_err_inject.nb);
+	if (err)
+		debugfs_remove_recursive(dir);
 
-	return register_hotcpu_notifier(&err_inject_cpu_notifier);
+	return err;
 }
 
 static void err_inject_exit(void)
 {
-	unregister_hotcpu_notifier(&err_inject_cpu_notifier);
+	unregister_hotcpu_notifier(&cpu_notifier_err_inject.nb);
+	debugfs_remove_recursive(dir);
 }
 
 module_init(err_inject_init);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-fix-failcmdsh-warning.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch

