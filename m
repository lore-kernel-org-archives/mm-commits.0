From: akpm@linux-foundation.org
Subject: + fault-injection-notifier-error-injection.patch added to -mm tree
Date: Thu, 21 Jul 2011 14:42:05 -0700
Message-ID: <201107212142.p6LLg63w010044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799Ab1GUVmv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jul 2011 17:42:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, benh@kernel.crashing.org, greg@kroah.com, paulus@samba.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     fault-injection: notifier error injection
has been added to the -mm tree.  Its filename is
     fault-injection-notifier-error-injection.patch

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
Subject: fault-injection: notifier error injection
From: Akinobu Mita <akinobu.mita@gmail.com>

This patchset provides the ability to inject artifical errors to the
following notifier chain callbacks.  It is useful to test the error
handling of notifier call chain failures.

 * CPU notifier
 * PM notifier
 * memory hotplug notifier
 * powerpc pSeries reconfig notifier

We already have cpu-notifier-error-inject.ko module providing such
functionality for the CPU notifier.  However, this patch set adds common
basic functions and consistent debugfs interface for them.

Each of the files in the directory represents an event which can be failed
and contains the error code.  If the notifier call chain should be failed
with some events notified, write the error code to the files.

Example: Inject CPU offline error (-1 == -EPERM)

	# cd /sys/kernel/debug/cpu-notifier-error-inject
	# echo -1 > CPU_UP_PREPARE
	# echo 0 > /sys/devices/system/cpu/cpu1/online
	bash: echo: write error: Operation not permitted
				

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/notifier.h |   25 +++++++++++
 kernel/notifier.c        |   81 +++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug        |   11 +++++
 3 files changed, 117 insertions(+)

diff -puN include/linux/notifier.h~fault-injection-notifier-error-injection include/linux/notifier.h
--- a/include/linux/notifier.h~fault-injection-notifier-error-injection
+++ a/include/linux/notifier.h
@@ -208,5 +208,30 @@ static inline int notifier_to_errno(int 
 
 extern struct blocking_notifier_head reboot_notifier_list;
 
+#ifdef CONFIG_NOTIFIER_ERROR_INJECTION
+
+struct err_inject_notifier_action {
+	unsigned long val;
+	int error;
+	const char *name;
+};
+
+#define ERR_INJECT_NOTIFIER_ACTION(action)	\
+	.name = #action, .val = (action),
+
+struct err_inject_notifier_block {
+	struct notifier_block nb;
+	struct dentry *dir;
+	struct err_inject_notifier_action actions[];
+	/* The last slot must be terminated with zero sentinel */
+};
+
+extern int err_inject_notifier_block_init(struct err_inject_notifier_block *enb,
+				const char *name, int priority);
+extern void err_inject_notifier_block_cleanup(
+				struct err_inject_notifier_block *enb);
+
+#endif /* CONFIG_NOTIFIER_ERROR_INJECTION */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
diff -puN kernel/notifier.c~fault-injection-notifier-error-injection kernel/notifier.c
--- a/kernel/notifier.c~fault-injection-notifier-error-injection
+++ a/kernel/notifier.c
@@ -5,6 +5,7 @@
 #include <linux/rcupdate.h>
 #include <linux/vmalloc.h>
 #include <linux/reboot.h>
+#include <linux/debugfs.h>
 
 /*
  *	Notifier list for kernel code which wants to be called
@@ -553,3 +554,83 @@ int unregister_die_notifier(struct notif
 	return atomic_notifier_chain_unregister(&die_chain, nb);
 }
 EXPORT_SYMBOL_GPL(unregister_die_notifier);
+
+#ifdef CONFIG_NOTIFIER_ERROR_INJECTION
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
+static int err_inject_notifier_callback(struct notifier_block *nb,
+				unsigned long val, void *p)
+{
+	int err = 0;
+	struct err_inject_notifier_block *enb =
+		container_of(nb, struct err_inject_notifier_block, nb);
+	struct err_inject_notifier_action *action;
+
+	for (action = enb->actions; action->name; action++) {
+		if (action->val == val) {
+			err = action->error;
+			break;
+		}
+	}
+	if (err) {
+		printk(KERN_INFO "Injecting error (%d) to %s\n",
+			err, action->name);
+	}
+
+	return notifier_from_errno(err);
+}
+
+int err_inject_notifier_block_init(struct err_inject_notifier_block *enb,
+				const char *name, int priority)
+{
+	struct err_inject_notifier_action *action;
+	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
+
+	enb->nb.notifier_call = err_inject_notifier_callback;
+	enb->nb.priority = priority;
+
+	enb->dir = debugfs_create_dir(name, NULL);
+	if (!enb->dir)
+		return -ENOMEM;
+
+	for (action = enb->actions; action->name; action++) {
+		/*
+		 * Create debugfs r/w file containing action->error. If
+		 * notifier call chain is called with action->val, it will
+		 * fail with the error code
+		 */
+		if (!debugfs_create_errno(action->name, mode, enb->dir,
+					&action->error)) {
+			debugfs_remove_recursive(enb->dir);
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
+void err_inject_notifier_block_cleanup(struct err_inject_notifier_block *enb)
+{
+	debugfs_remove_recursive(enb->dir);
+}
+
+#endif /* CONFIG_NOTIFIER_ERROR_INJECTION */
diff -puN lib/Kconfig.debug~fault-injection-notifier-error-injection lib/Kconfig.debug
--- a/lib/Kconfig.debug~fault-injection-notifier-error-injection
+++ a/lib/Kconfig.debug
@@ -1022,6 +1022,17 @@ config LKDTM
 	Documentation on how to use the module can be found in
 	Documentation/fault-injection/provoke-crashes.txt
 
+config NOTIFIER_ERROR_INJECTION
+	bool "Notifier error injection"
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
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
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
fault-injection-notifier-error-injection.patch
cpu-cpu-notifier-error-injection.patch
pm-pm-notifier-error-injection.patch
memory-memory-notifier-error-injection.patch
powerpc-pseries-reconfig-notifier-error-injection.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch

