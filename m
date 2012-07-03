From: akpm@linux-foundation.org
Subject: + fault-injection-notifier-error-injection.patch added to -mm tree
Date: Tue, 03 Jul 2012 13:42:49 -0700
Message-ID: <20120703204249.C8459A0148@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36231 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab2GCUmv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2012 16:42:51 -0400
Received: by ggeh3 with SMTP id h3so754304gge.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Jul 2012 13:42:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, benh@kernel.crashing.org, davej@redhat.com, greg@kroah.com, michael@ellerman.id.au, paulus@samba.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     Subject: fault-injection: notifier error injection
has been added to the -mm tree.  Its filename is
     fault-injection-notifier-error-injection.patch

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
Subject: fault-injection: notifier error injection

This patchset provides kernel modules that can be used to test the error
handling of notifier call chain failures by injecting artifical errors to
the following notifier chain callbacks.

 * CPU notifier
 * PM notifier
 * memory hotplug notifier
 * powerpc pSeries reconfig notifier

Example: Inject CPU offline error (-1 == -EPERM)

# cd /sys/kernel/debug/notifier-error-inject/cpu
# echo -1 > actions/CPU_DOWN_PREPARE/error
# echo 0 > /sys/devices/system/cpu/cpu1/online
bash: echo: write error: Operation not permitted

The patchset also adds cpu and memory hotplug tests to
tools/testing/selftests These tests first do simple online and offline
test and then do fault injection tests if notifier error injection module
is available.  


This patch:

The notifier error injection provides the ability to inject artifical
errors to specified notifier chain callbacks.  It is useful to test the
error handling of notifier call chain failures.

This adds common basic functions to define which type of events can be
fail and to initialize the debugfs interface to control what error code
should be returned and which event should be failed.

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

 lib/Kconfig.debug           |   11 +++
 lib/Makefile                |    1 
 lib/notifier-error-inject.c |  112 ++++++++++++++++++++++++++++++++++
 lib/notifier-error-inject.h |   24 +++++++
 4 files changed, 148 insertions(+)

diff -puN lib/Kconfig.debug~fault-injection-notifier-error-injection lib/Kconfig.debug
--- a/lib/Kconfig.debug~fault-injection-notifier-error-injection
+++ a/lib/Kconfig.debug
@@ -1084,6 +1084,17 @@ config LKDTM
 	Documentation on how to use the module can be found in
 	Documentation/fault-injection/provoke-crashes.txt
 
+config NOTIFIER_ERROR_INJECTION
+	tristate "Notifier error injection"
+	depends on DEBUG_KERNEL
+	select DEBUG_FS
+	help
+	  This option provides the ability to inject artifical errors to
+	  specified notifier chain callbacks. It is useful to test the error
+	  handling of notifier call chain failures.
+
+	  Say N if unsure.
+
 config CPU_NOTIFIER_ERROR_INJECT
 	tristate "CPU notifier error injection module"
 	depends on HOTPLUG_CPU && DEBUG_KERNEL
diff -puN lib/Makefile~fault-injection-notifier-error-injection lib/Makefile
--- a/lib/Makefile~fault-injection-notifier-error-injection
+++ a/lib/Makefile
@@ -90,6 +90,7 @@ obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
 obj-$(CONFIG_IOMMU_HELPER) += iommu-helper.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
+obj-$(CONFIG_NOTIFIER_ERROR_INJECTION) += notifier-error-inject.o
 obj-$(CONFIG_CPU_NOTIFIER_ERROR_INJECT) += cpu-notifier-error-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
diff -puN /dev/null lib/notifier-error-inject.c
--- /dev/null
+++ a/lib/notifier-error-inject.c
@@ -0,0 +1,112 @@
+#include <linux/module.h>
+
+#include "notifier-error-inject.h"
+
+static int debugfs_errno_set(void *data, u64 val)
+{
+	*(int *)data = clamp_t(int, val, -MAX_ERRNO, 0);
+	return 0;
+}
+
+static int debugfs_errno_get(void *data, u64 *val)
+{
+	*val = *(int *)data;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_errno, debugfs_errno_get, debugfs_errno_set,
+			"%lld\n");
+
+static struct dentry *debugfs_create_errno(const char *name, mode_t mode,
+				struct dentry *parent, int *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_errno);
+}
+
+static int notifier_err_inject_callback(struct notifier_block *nb,
+				unsigned long val, void *p)
+{
+	int err = 0;
+	struct notifier_err_inject *err_inject =
+		container_of(nb, struct notifier_err_inject, nb);
+	struct notifier_err_inject_action *action;
+
+	for (action = err_inject->actions; action->name; action++) {
+		if (action->val == val) {
+			err = action->error;
+			break;
+		}
+	}
+	if (err)
+		pr_info("Injecting error (%d) to %s\n", err, action->name);
+
+	return notifier_from_errno(err);
+}
+
+struct dentry *notifier_err_inject_dir;
+EXPORT_SYMBOL_GPL(notifier_err_inject_dir);
+
+struct dentry *notifier_err_inject_init(const char *name, struct dentry *parent,
+			struct notifier_err_inject *err_inject, int priority)
+{
+	struct notifier_err_inject_action *action;
+	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
+	struct dentry *dir;
+	struct dentry *actions_dir;
+
+	err_inject->nb.notifier_call = notifier_err_inject_callback;
+	err_inject->nb.priority = priority;
+
+	dir = debugfs_create_dir(name, parent);
+	if (!dir)
+		return ERR_PTR(-ENOMEM);
+
+	actions_dir = debugfs_create_dir("actions", dir);
+	if (!actions_dir)
+		goto fail;
+
+	for (action = err_inject->actions; action->name; action++) {
+		struct dentry *action_dir;
+
+		action_dir = debugfs_create_dir(action->name, actions_dir);
+		if (!action_dir)
+			goto fail;
+
+		/*
+		 * Create debugfs r/w file containing action->error. If
+		 * notifier call chain is called with action->val, it will
+		 * fail with the error code
+		 */
+		if (!debugfs_create_errno("error", mode, action_dir,
+					&action->error))
+			goto fail;
+	}
+	return dir;
+fail:
+	debugfs_remove_recursive(dir);
+	return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL_GPL(notifier_err_inject_init);
+
+static int __init err_inject_init(void)
+{
+	notifier_err_inject_dir =
+		debugfs_create_dir("notifier-error-inject", NULL);
+
+	if (!notifier_err_inject_dir)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void __exit err_inject_exit(void)
+{
+	debugfs_remove_recursive(notifier_err_inject_dir);
+}
+
+module_init(err_inject_init);
+module_exit(err_inject_exit);
+
+MODULE_DESCRIPTION("Notifier error injection module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Akinobu Mita <akinobu.mita@gmail.com>");
diff -puN /dev/null lib/notifier-error-inject.h
--- /dev/null
+++ a/lib/notifier-error-inject.h
@@ -0,0 +1,24 @@
+#include <linux/atomic.h>
+#include <linux/debugfs.h>
+#include <linux/notifier.h>
+
+struct notifier_err_inject_action {
+	unsigned long val;
+	int error;
+	const char *name;
+};
+
+#define NOTIFIER_ERR_INJECT_ACTION(action)	\
+	.name = #action, .val = (action),
+
+struct notifier_err_inject {
+	struct notifier_block nb;
+	struct notifier_err_inject_action actions[];
+	/* The last slot must be terminated with zero sentinel */
+};
+
+extern struct dentry *notifier_err_inject_dir;
+
+extern struct dentry *notifier_err_inject_init(const char *name,
+		struct dentry *parent, struct notifier_err_inject *err_inject,
+		int priority);
_
Subject: Subject: fault-injection: notifier error injection

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

