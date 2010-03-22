From: akpm@linux-foundation.org
Subject: + fault-injection-add-cpu-notifier-error-injection-module.patch added to -mm tree
Date: Mon, 22 Mar 2010 14:49:30 -0700
Message-ID: <201003222149.o2MLnUCD029460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756560Ab0CVVtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 17:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     fault-injection: add CPU notifier error injection module
has been added to the -mm tree.  Its filename is
     fault-injection-add-cpu-notifier-error-injection-module.patch

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
Subject: fault-injection: add CPU notifier error injection module
From: Akinobu Mita <akinobu.mita@gmail.com>

I used this module to test the series of modification to the cpu notifiers
code.

Example1: inject CPU offline error (-1 == -EPERM)

	# modprobe cpu-notifier-error-inject cpu_down_prepare_error=-1
	# echo 0 > /sys/devices/system/cpu/cpu1/online0
	bash: echo: write error: Operation not permitted

Example2: inject CPU online error (-2 == -ENOENT)

	# modprobe cpu-notifier-error-inject cpu_up_prepare_error=-2
	# echo 1 > /sys/devices/system/cpu/cpu1/online0
	bash: echo: write error: No such file or directory

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug               |   12 +++++
 lib/Makefile                    |    1 
 lib/cpu-notifier-error-inject.c |   63 ++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)

diff -puN lib/Kconfig.debug~fault-injection-add-cpu-notifier-error-injection-module lib/Kconfig.debug
--- a/lib/Kconfig.debug~fault-injection-add-cpu-notifier-error-injection-module
+++ a/lib/Kconfig.debug
@@ -886,6 +886,18 @@ config LKDTM
 	Documentation on how to use the module can be found in
 	Documentation/fault-injection/provoke-crashes.txt
 
+config CPU_NOTIFIER_ERROR_INJECT
+	tristate "CPU notifier error injection module"
+	depends on HOTPLUG_CPU && DEBUG_KERNEL
+	help
+	  This option provides a kernel module that can be used to test
+	  the error handling of the cpu notifiers
+
+	  To compile this code as a module, choose M here: the module will
+	  be called cpu-notify-inject.
+
+	  If unsure, say N.
+
 config FAULT_INJECTION
 	bool "Fault-injection framework"
 	depends on DEBUG_KERNEL
diff -puN lib/Makefile~fault-injection-add-cpu-notifier-error-injection-module lib/Makefile
--- a/lib/Makefile~fault-injection-add-cpu-notifier-error-injection-module
+++ a/lib/Makefile
@@ -84,6 +84,7 @@ obj-$(CONFIG_IOQ) += ioq.o
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
 obj-$(CONFIG_IOMMU_HELPER) += iommu-helper.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
+obj-$(CONFIG_CPU_NOTIFIER_ERROR_INJECT) += cpu-notifier-error-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
diff -puN /dev/null lib/cpu-notifier-error-inject.c
--- /dev/null
+++ a/lib/cpu-notifier-error-inject.c
@@ -0,0 +1,63 @@
+#include <linux/kernel.h>
+#include <linux/cpu.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+
+static int priority;
+static int cpu_up_prepare_error;
+static int cpu_down_prepare_error;
+
+module_param(priority, int, 0);
+MODULE_PARM_DESC(priority, "specify cpu notifier priority");
+
+module_param(cpu_up_prepare_error, int, 0644);
+MODULE_PARM_DESC(cpu_up_prepare_error,
+		"specify error code to inject CPU_UP_PREPARE action");
+
+module_param(cpu_down_prepare_error, int, 0644);
+MODULE_PARM_DESC(cpu_down_prepare_error,
+		"specify error code to inject CPU_DOWN_PREPARE action");
+
+static int err_inject_cpu_callback(struct notifier_block *nfb,
+				unsigned long action, void *hcpu)
+{
+	int err = 0;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		err = cpu_up_prepare_error;
+		break;
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		err = cpu_down_prepare_error;
+		break;
+	}
+	if (err)
+		printk(KERN_INFO "Injecting error (%d) at cpu notifier\n", err);
+
+	return notifier_from_errno(err);
+}
+
+static struct notifier_block err_inject_cpu_notifier = {
+	.notifier_call = err_inject_cpu_callback,
+};
+
+static int err_inject_init(void)
+{
+	err_inject_cpu_notifier.priority = priority;
+
+	return register_hotcpu_notifier(&err_inject_cpu_notifier);
+}
+
+static void err_inject_exit(void)
+{
+	unregister_hotcpu_notifier(&err_inject_cpu_notifier);
+}
+
+module_init(err_inject_init);
+module_exit(err_inject_exit);
+
+MODULE_DESCRIPTION("CPU notifier error injection module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Akinobu Mita <akinobu.mita@gmail.com>");
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

intel-iommu-use-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
cpu-hotplug-introduce-cpu_notify-__cpu_notify-cpu_notify_nofail.patch
cpu-hotplug-return-better-errno-on-cpu-hotplug-failure.patch
notifier-change-notifier_from_errno0-to-return-notify_ok.patch
x86-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
topology-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
kernel-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
slab-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
iucv-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
ehca-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
s390-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
md-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
fault-injection-add-cpu-notifier-error-injection-module.patch
bitops-remove-temporary-for_each_bit.patch

