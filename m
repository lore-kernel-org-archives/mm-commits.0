From: akpm@linux-foundation.org
Subject: + pm-pm-notifier-error-injection-module.patch added to -mm tree
Date: Tue, 03 Jul 2012 13:42:54 -0700
Message-ID: <20120703204254.4A8A6A0148@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:41547 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab2GCUmz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2012 16:42:55 -0400
Received: by yenl3 with SMTP id l3so757524yen.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Jul 2012 13:42:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, benh@kernel.crashing.org, davej@redhat.com, greg@kroah.com, michael@ellerman.id.au, paulus@samba.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     Subject: PM: PM notifier error injection module
has been added to the -mm tree.  Its filename is
     pm-pm-notifier-error-injection-module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: PM: PM notifier error injection module

This provides the ability to inject artifical errors to PM notifier chain
callbacks.  It is controlled through debugfs interface under
/sys/kernel/debug/notifier-error-inject/pm

Each of the files in "error" directory represents an event which can be
failed and contains the error code.  If the notifier call chain should be
failed with some events notified, write the error code to the files.

If the notifier call chain should be failed with some events notified,
write the error code to "actions/<notifier event>/error".

Example: Inject PM suspend error (-12 = -ENOMEM)

	# cd /sys/kernel/debug/notifier-error-inject/pm
	# echo -12 > actions/PM_SUSPEND_PREPARE/error
	# echo mem > /sys/power/state
	bash: echo: write error: Cannot allocate memory

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug              |   24 +++++++++++++++
 lib/Makefile                   |    1 
 lib/pm-notifier-error-inject.c |   49 +++++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+)

diff -puN lib/Kconfig.debug~pm-pm-notifier-error-injection-module lib/Kconfig.debug
--- a/lib/Kconfig.debug~pm-pm-notifier-error-injection-module
+++ a/lib/Kconfig.debug
@@ -1119,6 +1119,30 @@ config CPU_NOTIFIER_ERROR_INJECT
 
 	  If unsure, say N.
 
+config PM_NOTIFIER_ERROR_INJECT
+	tristate "PM notifier error injection module"
+	depends on PM && NOTIFIER_ERROR_INJECTION
+	default m if PM_DEBUG
+	help
+	  This option provides the ability to inject artifical errors to
+	  PM notifier chain callbacks.  It is controlled through debugfs
+	  interface /sys/kernel/debug/notifier-error-inject/pm
+
+	  If the notifier call chain should be failed with some events
+	  notified, write the error code to "actions/<notifier event>/error".
+
+	  Example: Inject PM suspend error (-12 = -ENOMEM)
+
+	  # cd /sys/kernel/debug/notifier-error-inject/pm/
+	  # echo -12 > actions/PM_SUSPEND_PREPARE/error
+	  # echo mem > /sys/power/state
+	  bash: echo: write error: Cannot allocate memory
+
+	  To compile this code as a module, choose M here: the module will
+	  be called pm-notifier-error-inject.
+
+	  If unsure, say N.
+
 config FAULT_INJECTION
 	bool "Fault-injection framework"
 	depends on DEBUG_KERNEL
diff -puN lib/Makefile~pm-pm-notifier-error-injection-module lib/Makefile
--- a/lib/Makefile~pm-pm-notifier-error-injection-module
+++ a/lib/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_IOMMU_HELPER) += iommu-help
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 obj-$(CONFIG_NOTIFIER_ERROR_INJECTION) += notifier-error-inject.o
 obj-$(CONFIG_CPU_NOTIFIER_ERROR_INJECT) += cpu-notifier-error-inject.o
+obj-$(CONFIG_PM_NOTIFIER_ERROR_INJECT) += pm-notifier-error-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
diff -puN /dev/null lib/pm-notifier-error-inject.c
--- /dev/null
+++ a/lib/pm-notifier-error-inject.c
@@ -0,0 +1,49 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/suspend.h>
+
+#include "notifier-error-inject.h"
+
+static int priority;
+module_param(priority, int, 0);
+MODULE_PARM_DESC(priority, "specify PM notifier priority");
+
+static struct notifier_err_inject pm_notifier_err_inject = {
+	.actions = {
+		{ NOTIFIER_ERR_INJECT_ACTION(PM_HIBERNATION_PREPARE) },
+		{ NOTIFIER_ERR_INJECT_ACTION(PM_SUSPEND_PREPARE) },
+		{ NOTIFIER_ERR_INJECT_ACTION(PM_RESTORE_PREPARE) },
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
+	dir = notifier_err_inject_init("pm", notifier_err_inject_dir,
+					&pm_notifier_err_inject, priority);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
+
+	err = register_pm_notifier(&pm_notifier_err_inject.nb);
+	if (err)
+		debugfs_remove_recursive(dir);
+
+	return err;
+}
+
+static void err_inject_exit(void)
+{
+	unregister_pm_notifier(&pm_notifier_err_inject.nb);
+	debugfs_remove_recursive(dir);
+}
+
+module_init(err_inject_init);
+module_exit(err_inject_exit);
+
+MODULE_DESCRIPTION("PM notifier error injection module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Akinobu Mita <akinobu.mita@gmail.com>");
_
Subject: Subject: PM: PM notifier error injection module

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
string-introduce-memweight.patch
string-introduce-memweight-fix.patch
string-introduce-memweight-fix-build-error-caused-by-memweight-introduction.patch
qnx4fs-use-memweight.patch
dm-use-memweight.patch
affs-use-memweight.patch
video-uvc-use-memweight.patch
ocfs2-use-memweight.patch
ext2-use-memweight.patch
ext3-use-memweight.patch
ext4-use-memweight.patch
fault-injection-notifier-error-injection.patch
cpu-rewrite-cpu-notifier-error-inject-module.patch
pm-pm-notifier-error-injection-module.patch
memory-memory-notifier-error-injection-module.patch
powerpc-pseries-reconfig-notifier-error-injection-module.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch

