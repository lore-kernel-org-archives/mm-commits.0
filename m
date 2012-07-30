From: akpm@linux-foundation.org
Subject: [folded] fault-injection-notifier-error-injection-doc.patch removed from -mm tree
Date: Mon, 30 Jul 2012 14:27:21 -0700
Message-ID: <20120730212722.508881E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:47809 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2G3V1Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 17:27:24 -0400
Received: by obbwc20 with SMTP id wc20so4010568obb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 14:27:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, benh@kernel.crashing.org, davej@redhat.com, greg@kroah.com, michael@ellerman.id.au, paulus@samba.org, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Subject: notifier error injection documentation
has been removed from the -mm tree.  Its filename was
     fault-injection-notifier-error-injection-doc.patch

This patch was dropped because it was folded into fault-injection-notifier-error-injection.patch

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: notifier error injection documentation

fault-injection-notifier-error-injection.patch in -mm tree adds
notifier error injection.

This adds Documentation/fault-injection/notifier-error-inject.txt
which describes its feature and usage examples.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fault-injection/notifier-error-inject.txt |   99 ++++++++++
 1 file changed, 99 insertions(+)

diff -puN /dev/null Documentation/fault-injection/notifier-error-inject.txt
--- /dev/null
+++ a/Documentation/fault-injection/notifier-error-inject.txt
@@ -0,0 +1,99 @@
+Notifier error injection
+========================
+
+Notifier error injection provides the ability to inject artifical errors to
+specified notifier chain callbacks. It is useful to test the error handling of
+notifier call chain failures which is rarely executed.  There are kernel
+modules that can be used to test the following notifiers.
+
+ * CPU notifier
+ * PM notifier
+ * Memory hotplug notifier
+ * powerpc pSeries reconfig notifier
+
+CPU notifier error injection module
+-----------------------------------
+This feature can be used to test the error handling of the CPU notifiers by
+injecting artifical errors to CPU notifier chain callbacks.
+
+If the notifier call chain should be failed with some events notified, write
+the error code to debugfs interface
+/sys/kernel/debug/notifier-error-inject/cpu/actions/<notifier event>/error
+
+Possible CPU notifier events to be failed are:
+
+ * CPU_UP_PREPARE
+ * CPU_UP_PREPARE_FROZEN
+ * CPU_DOWN_PREPARE
+ * CPU_DOWN_PREPARE_FROZEN
+
+Example1: Inject CPU offline error (-1 == -EPERM)
+
+	# cd /sys/kernel/debug/notifier-error-inject/cpu
+	# echo -1 > actions/CPU_DOWN_PREPARE/error
+	# echo 0 > /sys/devices/system/cpu/cpu1/online
+	bash: echo: write error: Operation not permitted
+
+Example2: inject CPU online error (-2 == -ENOENT)
+
+	# echo -2 > actions/CPU_UP_PREPARE/error
+	# echo 1 > /sys/devices/system/cpu/cpu1/online
+	bash: echo: write error: No such file or directory
+
+PM notifier error injection module
+----------------------------------
+This feature is controlled through debugfs interface
+/sys/kernel/debug/notifier-error-inject/pm/actions/<notifier event>/error
+
+Possible PM notifier events to be failed are:
+
+ * PM_HIBERNATION_PREPARE
+ * PM_SUSPEND_PREPARE
+ * PM_RESTORE_PREPARE
+
+Example: Inject PM suspend error (-12 = -ENOMEM)
+
+	# cd /sys/kernel/debug/notifier-error-inject/pm/
+	# echo -12 > actions/PM_SUSPEND_PREPARE/error
+	# echo mem > /sys/power/state
+	bash: echo: write error: Cannot allocate memory
+
+Memory hotplug notifier error injection module
+----------------------------------------------
+This feature is controlled through debugfs interface
+/sys/kernel/debug/notifier-error-inject/memory/actions/<notifier event>/error
+
+Possible memory notifier events to be failed are:
+
+ * MEM_GOING_ONLINE
+ * MEM_GOING_OFFLINE
+
+Example: Inject memory hotplug offline error (-12 == -ENOMEM)
+
+	# cd /sys/kernel/debug/notifier-error-inject/memory
+	# echo -12 > actions/MEM_GOING_OFFLINE/error
+	# echo offline > /sys/devices/system/memory/memoryXXX/state
+	bash: echo: write error: Cannot allocate memory
+
+powerpc pSeries reconfig notifier error injection module
+--------------------------------------------------------
+This feature is controlled through debugfs interface
+/sys/kernel/debug/notifier-error-inject/pSeries-reconfig/actions/<notifier event>/error
+
+Possible pSeries reconfig notifier events to be failed are:
+
+ * PSERIES_RECONFIG_ADD
+ * PSERIES_RECONFIG_REMOVE
+ * PSERIES_DRCONF_MEM_ADD
+ * PSERIES_DRCONF_MEM_REMOVE
+
+For more usage examples
+-----------------------
+There are tools/testing/selftests using the notifier error injection features
+for CPU and memory notifiers.
+
+ * tools/testing/selftests/cpu-hotplug/on-off-test.sh
+ * tools/testing/selftests/memory-hotplug/on-off-test.sh
+
+These scripts first do simple online and offline tests and then do fault
+injection tests if notifier error injection module is available.
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
string-introduce-memweight.patch
qnx4fs-use-memweight.patch
dm-use-memweight.patch
affs-use-memweight.patch
video-uvc-use-memweight.patch
ocfs2-use-memweight.patch
ext2-use-memweight.patch
ext3-use-memweight.patch
ext4-use-memweight.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
fork-fix-error-handling-in-dup_task.patch
fault-injection-notifier-error-injection.patch
cpu-rewrite-cpu-notifier-error-inject-module.patch
pm-pm-notifier-error-injection-module.patch
memory-memory-notifier-error-injection-module.patch
memory-memory-notifier-error-injection-module-fix.patch
powerpc-pseries-reconfig-notifier-error-injection-module.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc.patch
fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc-doc.patch

