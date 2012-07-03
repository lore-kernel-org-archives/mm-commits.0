From: akpm@linux-foundation.org
Subject: + fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch added to -mm tree
Date: Tue, 03 Jul 2012 13:42:59 -0700
Message-ID: <20120703204259.F19F2A0148@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:54725 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab2GCUnB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2012 16:43:01 -0400
Received: by vbnl22 with SMTP id l22so753620vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Jul 2012 13:43:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, akpm@linux-foundation.org, benh@kernel.crashing.org, davej@redhat.com, greg@kroah.com, michael@ellerman.id.au, paulus@samba.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     Subject: fault-injection: add selftests for cpu and memory hotplug
has been added to the -mm tree.  Its filename is
     fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch

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
Subject: fault-injection: add selftests for cpu and memory hotplug

This adds two selftests

* tools/testing/selftests/cpu-hotplug/on-off-test.sh is testing script
for CPU hotplug

1. Online all hot-pluggable CPUs
2. Offline all hot-pluggable CPUs
3. Online all hot-pluggable CPUs again
4. Exit if cpu-notifier-error-inject.ko is not available
5. Offline all hot-pluggable CPUs in preparation for testing
6. Test CPU hot-add error handling by injecting notifier errors
7. Online all hot-pluggable CPUs in preparation for testing
8. Test CPU hot-remove error handling by injecting notifier errors

* tools/testing/selftests/memory-hotplug/on-off-test.sh is doing the
similar thing for memory hotplug.

1. Online all hot-pluggable memory
2. Offline 10% of hot-pluggable memory
3. Online all hot-pluggable memory again
4. Exit if memory-notifier-error-inject.ko is not available
5. Offline 10% of hot-pluggable memory in preparation for testing
6. Test memory hot-add error handling by injecting notifier errors
7. Online all hot-pluggable memory in preparation for testing
8. Test memory hot-remove error handling by injecting notifier errors

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile                      |    2 
 tools/testing/selftests/cpu-hotplug/Makefile          |    6 
 tools/testing/selftests/cpu-hotplug/on-off-test.sh    |  221 +++++++++
 tools/testing/selftests/memory-hotplug/Makefile       |    6 
 tools/testing/selftests/memory-hotplug/on-off-test.sh |  230 ++++++++++
 5 files changed, 464 insertions(+), 1 deletion(-)

diff -puN tools/testing/selftests/Makefile~fault-injection-add-selftests-for-cpu-and-memory-hotplug tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~fault-injection-add-selftests-for-cpu-and-memory-hotplug
+++ a/tools/testing/selftests/Makefile
@@ -1,4 +1,4 @@
-TARGETS = breakpoints kcmp mqueue vm
+TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug
 
 all:
 	for TARGET in $(TARGETS); do \
diff -puN /dev/null tools/testing/selftests/cpu-hotplug/Makefile
--- /dev/null
+++ a/tools/testing/selftests/cpu-hotplug/Makefile
@@ -0,0 +1,6 @@
+all:
+
+run_tests:
+	./on-off-test.sh
+
+clean:
diff -puN /dev/null tools/testing/selftests/cpu-hotplug/on-off-test.sh
--- /dev/null
+++ a/tools/testing/selftests/cpu-hotplug/on-off-test.sh
@@ -0,0 +1,221 @@
+#!/bin/bash
+
+SYSFS=
+
+prerequisite()
+{
+	msg="skip all tests:"
+
+	if [ $UID != 0 ]; then
+		echo $msg must be run as root >&2
+		exit 0
+	fi
+
+	SYSFS=`mount -t sysfs | head -1 | awk '{ print $3 }'`
+
+	if [ ! -d "$SYSFS" ]; then
+		echo $msg sysfs is not mounted >&2
+		exit 0
+	fi
+
+	if ! ls $SYSFS/devices/system/cpu/cpu* > /dev/null 2>&1; then
+		echo $msg cpu hotplug is not supported >&2
+		exit 0
+	fi
+}
+
+#
+# list all hot-pluggable CPUs
+#
+hotpluggable_cpus()
+{
+	local state=${1:-.\*}
+
+	for cpu in $SYSFS/devices/system/cpu/cpu*; do
+		if [ -f $cpu/online ] && grep -q $state $cpu/online; then
+			echo ${cpu##/*/cpu}
+		fi
+	done
+}
+
+hotplaggable_offline_cpus()
+{
+	hotpluggable_cpus 0
+}
+
+hotpluggable_online_cpus()
+{
+	hotpluggable_cpus 1
+}
+
+cpu_is_online()
+{
+	grep -q 1 $SYSFS/devices/system/cpu/cpu$1/online
+}
+
+cpu_is_offline()
+{
+	grep -q 0 $SYSFS/devices/system/cpu/cpu$1/online
+}
+
+online_cpu()
+{
+	echo 1 > $SYSFS/devices/system/cpu/cpu$1/online
+}
+
+offline_cpu()
+{
+	echo 0 > $SYSFS/devices/system/cpu/cpu$1/online
+}
+
+online_cpu_expect_success()
+{
+	local cpu=$1
+
+	if ! online_cpu $cpu; then
+		echo $FUNCNAME $cpu: unexpected fail >&2
+	elif ! cpu_is_online $cpu; then
+		echo $FUNCNAME $cpu: unexpected offline >&2
+	fi
+}
+
+online_cpu_expect_fail()
+{
+	local cpu=$1
+
+	if online_cpu $cpu 2> /dev/null; then
+		echo $FUNCNAME $cpu: unexpected success >&2
+	elif ! cpu_is_offline $cpu; then
+		echo $FUNCNAME $cpu: unexpected online >&2
+	fi
+}
+
+offline_cpu_expect_success()
+{
+	local cpu=$1
+
+	if ! offline_cpu $cpu; then
+		echo $FUNCNAME $cpu: unexpected fail >&2
+	elif ! cpu_is_offline $cpu; then
+		echo $FUNCNAME $cpu: unexpected offline >&2
+	fi
+}
+
+offline_cpu_expect_fail()
+{
+	local cpu=$1
+
+	if offline_cpu $cpu 2> /dev/null; then
+		echo $FUNCNAME $cpu: unexpected success >&2
+	elif ! cpu_is_online $cpu; then
+		echo $FUNCNAME $cpu: unexpected offline >&2
+	fi
+}
+
+error=-12
+priority=0
+
+while getopts e:hp: opt; do
+	case $opt in
+	e)
+		error=$OPTARG
+		;;
+	h)
+		echo "Usage $0 [ -e errno ] [ -p notifier-priority ]"
+		exit
+		;;
+	p)
+		priority=$OPTARG
+		;;
+	esac
+done
+
+if ! [ "$error" -ge -4095 -a "$error" -lt 0 ]; then
+	echo "error code must be -4095 <= errno < 0" >&2
+	exit 1
+fi
+
+prerequisite
+
+#
+# Online all hot-pluggable CPUs
+#
+for cpu in `hotplaggable_offline_cpus`; do
+	online_cpu_expect_success $cpu
+done
+
+#
+# Offline all hot-pluggable CPUs
+#
+for cpu in `hotpluggable_online_cpus`; do
+	offline_cpu_expect_success $cpu
+done
+
+#
+# Online all hot-pluggable CPUs again
+#
+for cpu in `hotplaggable_offline_cpus`; do
+	online_cpu_expect_success $cpu
+done
+
+#
+# Test with cpu notifier error injection
+#
+
+DEBUGFS=`mount -t debugfs | head -1 | awk '{ print $3 }'`
+NOTIFIER_ERR_INJECT_DIR=$DEBUGFS/notifier-error-inject/cpu
+
+prerequisite_extra()
+{
+	msg="skip extra tests:"
+
+	/sbin/modprobe -q -r cpu-notifier-error-inject
+	/sbin/modprobe -q cpu-notifier-error-inject priority=$priority
+
+	if [ ! -d "$DEBUGFS" ]; then
+		echo $msg debugfs is not mounted >&2
+		exit 0
+	fi
+
+	if [ ! -d $NOTIFIER_ERR_INJECT_DIR ]; then
+		echo $msg cpu-notifier-error-inject module is not available >&2
+		exit 0
+	fi
+}
+
+prerequisite_extra
+
+#
+# Offline all hot-pluggable CPUs
+#
+echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/CPU_DOWN_PREPARE/error
+for cpu in `hotpluggable_online_cpus`; do
+	offline_cpu_expect_success $cpu
+done
+
+#
+# Test CPU hot-add error handling (offline => online)
+#
+echo $error > $NOTIFIER_ERR_INJECT_DIR/actions/CPU_UP_PREPARE/error
+for cpu in `hotplaggable_offline_cpus`; do
+	online_cpu_expect_fail $cpu
+done
+
+#
+# Online all hot-pluggable CPUs
+#
+echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/CPU_UP_PREPARE/error
+for cpu in `hotplaggable_offline_cpus`; do
+	online_cpu_expect_success $cpu
+done
+
+#
+# Test CPU hot-remove error handling (online => offline)
+#
+echo $error > $NOTIFIER_ERR_INJECT_DIR/actions/CPU_DOWN_PREPARE/error
+for cpu in `hotpluggable_online_cpus`; do
+	offline_cpu_expect_fail $cpu
+done
+
+echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/CPU_DOWN_PREPARE/error
+/sbin/modprobe -q -r cpu-notifier-error-inject
diff -puN /dev/null tools/testing/selftests/memory-hotplug/Makefile
--- /dev/null
+++ a/tools/testing/selftests/memory-hotplug/Makefile
@@ -0,0 +1,6 @@
+all:
+
+run_tests:
+	./on-off-test.sh
+
+clean:
diff -puN /dev/null tools/testing/selftests/memory-hotplug/on-off-test.sh
--- /dev/null
+++ a/tools/testing/selftests/memory-hotplug/on-off-test.sh
@@ -0,0 +1,230 @@
+#!/bin/bash
+
+SYSFS=
+
+prerequisite()
+{
+	msg="skip all tests:"
+
+	if [ $UID != 0 ]; then
+		echo $msg must be run as root >&2
+		exit 0
+	fi
+
+	SYSFS=`mount -t sysfs | head -1 | awk '{ print $3 }'`
+
+	if [ ! -d "$SYSFS" ]; then
+		echo $msg sysfs is not mounted >&2
+		exit 0
+	fi
+
+	if ! ls $SYSFS/devices/system/memory/memory* > /dev/null 2>&1; then
+		echo $msg memory hotplug is not supported >&2
+		exit 0
+	fi
+}
+
+#
+# list all hot-pluggable memory
+#
+hotpluggable_memory()
+{
+	local state=${1:-.\*}
+
+	for memory in $SYSFS/devices/system/memory/memory*; do
+		if grep -q 1 $memory/removable &&
+		   grep -q $state $memory/state; then
+			echo ${memory##/*/memory}
+		fi
+	done
+}
+
+hotplaggable_offline_memory()
+{
+	hotpluggable_memory offline
+}
+
+hotpluggable_online_memory()
+{
+	hotpluggable_memory online
+}
+
+memory_is_online()
+{
+	grep -q online $SYSFS/devices/system/memory/memory$1/state
+}
+
+memory_is_offline()
+{
+	grep -q offline $SYSFS/devices/system/memory/memory$1/state
+}
+
+online_memory()
+{
+	echo online > $SYSFS/devices/system/memory/memory$1/state
+}
+
+offline_memory()
+{
+	echo offline > $SYSFS/devices/system/memory/memory$1/state
+}
+
+online_memory_expect_success()
+{
+	local memory=$1
+
+	if ! online_memory $memory; then
+		echo $FUNCNAME $memory: unexpected fail >&2
+	elif ! memory_is_online $memory; then
+		echo $FUNCNAME $memory: unexpected offline >&2
+	fi
+}
+
+online_memory_expect_fail()
+{
+	local memory=$1
+
+	if online_memory $memory 2> /dev/null; then
+		echo $FUNCNAME $memory: unexpected success >&2
+	elif ! memory_is_offline $memory; then
+		echo $FUNCNAME $memory: unexpected online >&2
+	fi
+}
+
+offline_memory_expect_success()
+{
+	local memory=$1
+
+	if ! offline_memory $memory; then
+		echo $FUNCNAME $memory: unexpected fail >&2
+	elif ! memory_is_offline $memory; then
+		echo $FUNCNAME $memory: unexpected offline >&2
+	fi
+}
+
+offline_memory_expect_fail()
+{
+	local memory=$1
+
+	if offline_memory $memory 2> /dev/null; then
+		echo $FUNCNAME $memory: unexpected success >&2
+	elif ! memory_is_online $memory; then
+		echo $FUNCNAME $memory: unexpected offline >&2
+	fi
+}
+
+error=-12
+priority=0
+ratio=10
+
+while getopts e:hp:r: opt; do
+	case $opt in
+	e)
+		error=$OPTARG
+		;;
+	h)
+		echo "Usage $0 [ -e errno ] [ -p notifier-priority ] [ -r percent-of-memory-to-offline ]"
+		exit
+		;;
+	p)
+		priority=$OPTARG
+		;;
+	r)
+		ratio=$OPTARG
+		;;
+	esac
+done
+
+if ! [ "$error" -ge -4095 -a "$error" -lt 0 ]; then
+	echo "error code must be -4095 <= errno < 0" >&2
+	exit 1
+fi
+
+prerequisite
+
+#
+# Online all hot-pluggable memory
+#
+for memory in `hotplaggable_offline_memory`; do
+	online_memory_expect_success $memory
+done
+
+#
+# Offline $ratio percent of hot-pluggable memory
+#
+for memory in `hotpluggable_online_memory`; do
+	if [ $((RANDOM % 100)) -lt $ratio ]; then
+		offline_memory_expect_success $memory
+	fi
+done
+
+#
+# Online all hot-pluggable memory again
+#
+for memory in `hotplaggable_offline_memory`; do
+	online_memory_expect_success $memory
+done
+
+#
+# Test with memory notifier error injection
+#
+
+DEBUGFS=`mount -t debugfs | head -1 | awk '{ print $3 }'`
+NOTIFIER_ERR_INJECT_DIR=$DEBUGFS/notifier-error-inject/memory
+
+prerequisite_extra()
+{
+	msg="skip extra tests:"
+
+	/sbin/modprobe -q -r memory-notifier-error-inject
+	/sbin/modprobe -q memory-notifier-error-inject priority=$priority
+
+	if [ ! -d "$DEBUGFS" ]; then
+		echo $msg debugfs is not mounted >&2
+		exit 0
+	fi
+
+	if [ ! -d $NOTIFIER_ERR_INJECT_DIR ]; then
+		echo $msg memory-notifier-error-inject module is not available >&2
+		exit 0
+	fi
+}
+
+prerequisite_extra
+
+#
+# Offline $ratio percent of hot-pluggable memory
+#
+echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/MEM_GOING_OFFLINE/error
+for memory in `hotpluggable_online_memory`; do
+	if [ $((RANDOM % 100)) -lt $ratio ]; then
+		offline_memory_expect_success $memory
+	fi
+done
+
+#
+# Test memory hot-add error handling (offline => online)
+#
+echo $error > $NOTIFIER_ERR_INJECT_DIR/actions/MEM_GOING_ONLINE/error
+for memory in `hotplaggable_offline_memory`; do
+	online_memory_expect_fail $memory
+done
+
+#
+# Online all hot-pluggable memory
+#
+echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/MEM_GOING_ONLINE/error
+for memory in `hotplaggable_offline_memory`; do
+	online_memory_expect_success $memory
+done
+
+#
+# Test memory hot-remove error handling (online => offline)
+#
+echo $error > $NOTIFIER_ERR_INJECT_DIR/actions/MEM_GOING_OFFLINE/error
+for memory in `hotpluggable_online_memory`; do
+	offline_memory_expect_fail $memory
+done
+
+echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/MEM_GOING_OFFLINE/error
+/sbin/modprobe -q -r memory-notifier-error-inject
_
Subject: Subject: fault-injection: add selftests for cpu and memory hotplug

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

