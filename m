From: akpm@linux-foundation.org
Subject: + fault-injection-notifier-error-injection-doc.patch added to -mm tree
Date: Mon, 09 Jul 2012 13:58:01 -0700
Message-ID: <20120709205801.BE754100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:41109 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab2GIU6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2012 16:58:03 -0400
Received: by ggeh3 with SMTP id h3so1239800gge.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jul 2012 13:58:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, benh@kernel.crashing.org, davej@redhat.com, greg@kroah.com, michael@ellerman.id.au, paulus@samba.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     Subject: notifier error injection documentation
has been added to the -mm tree.  Its filename is
     fault-injection-notifier-error-injection-doc.patch

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
Subject: Subject: notifier error injection documentation

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
fault-injection-notifier-error-injection-doc.patch
cpu-rewrite-cpu-notifier-error-inject-module.patch
pm-pm-notifier-error-injection-module.patch
memory-memory-notifier-error-injection-module.patch
memory-memory-notifier-error-injection-module-fix.patch
powerpc-pseries-reconfig-notifier-error-injection-module.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc.patch

