From: akpm@linux-foundation.org
Subject: [merged]
 tools-selftests-create-a-separate-hotplug-target-for-full-range-test.patch
 removed from -mm tree
Date: Mon, 14 Jul 2014 11:50:08 -0700
Message-ID: <53c42660.4ELPwUlx9STMprMY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:39820 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbaGNSuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jul 2014 14:50:10 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so706796yha.2
        for <mm-commits@vger.kernel.org>; Mon, 14 Jul 2014 11:50:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuah.kh@samsung.com, benh@kernel.crashing.org, fweisbec@gmail.com, gregkh@linuxfoundation.org, keescook@chromium.org, michael@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: tools: selftests - create a separate hotplug target for full range test
has been removed from the -mm tree.  Its filename was
     tools-selftests-create-a-separate-hotplug-target-for-full-range-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shuah Khan <shuah.kh@samsung.com>
Subject: tools: selftests - create a separate hotplug target for full range test

On some systems, hotplug tests can hang forever waiting for cpu and memory
to be ready to be offlined.

A special hot-plug target is created to run the full range of hotplug
tests.  In default mode, hotplug tests run in safe mode with a limited
scope.  In limited mode, cpu-hotplug test is run on a single cpu as
opposed to all hotplug capable cpus, and memory hotplug test is run on 2%
of hotplug capable memory instead of 10%.  In addition to the above
change, cpu-hotplug is changed to change processor affinity to cpu 0 so it
doesn't impact itself while the test runs.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile                      |   18 +++
 tools/testing/selftests/README.txt                    |   27 ++++-
 tools/testing/selftests/cpu-hotplug/Makefile          |    3 
 tools/testing/selftests/cpu-hotplug/on-off-test.sh    |   52 +++++++++-
 tools/testing/selftests/memory-hotplug/Makefile       |    3 
 tools/testing/selftests/memory-hotplug/on-off-test.sh |    8 +
 6 files changed, 105 insertions(+), 6 deletions(-)

diff -puN tools/testing/selftests/Makefile~tools-selftests-create-a-separate-hotplug-target-for-full-range-test tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~tools-selftests-create-a-separate-hotplug-target-for-full-range-test
+++ a/tools/testing/selftests/Makefile
@@ -12,6 +12,9 @@ TARGETS += powerpc
 TARGETS += user
 TARGETS += sysctl
 
+TARGETS_HOTPLUG = cpu-hotplug
+TARGETS_HOTPLUG += memory-hotplug
+
 all:
 	for TARGET in $(TARGETS); do \
 		make -C $$TARGET; \
@@ -22,6 +25,21 @@ run_tests: all
 		make -C $$TARGET run_tests; \
 	done;
 
+hotplug:
+	for TARGET in $(TARGETS_HOTPLUG); do \
+		make -C $$TARGET; \
+	done;
+
+run_hotplug: hotplug
+	for TARGET in $(TARGETS_HOTPLUG); do \
+		make -C $$TARGET run_full_test; \
+	done;
+
+clean_hotplug:
+	for TARGET in $(TARGETS_HOTPLUG); do \
+		make -C $$TARGET clean; \
+	done;
+
 clean:
 	for TARGET in $(TARGETS); do \
 		make -C $$TARGET clean; \
diff -puN tools/testing/selftests/README.txt~tools-selftests-create-a-separate-hotplug-target-for-full-range-test tools/testing/selftests/README.txt
--- a/tools/testing/selftests/README.txt~tools-selftests-create-a-separate-hotplug-target-for-full-range-test
+++ a/tools/testing/selftests/README.txt
@@ -4,8 +4,15 @@ The kernel contains a set of "self tests
 directory. These are intended to be small unit tests to exercise individual
 code paths in the kernel.
 
-Running the selftests
-=====================
+On some systems, hot-plug tests could hang forever waiting for cpu and
+memory to be ready to be offlined. A special hot-plug target is created
+to run full range of hot-plug tests. In default mode, hot-plug tests run
+in safe mode with a limited scope. In limited mode, cpu-hotplug test is
+run on a single cpu as opposed to all hotplug capable cpus, and memory
+hotplug test is run on 2% of hotplug capable memory instead of 10%.
+
+Running the selftests (hotplug tests are run in limited mode)
+=============================================================
 
 To build the tests:
 
@@ -18,14 +25,26 @@ To run the tests:
 
 - note that some tests will require root privileges.
 
-
-To run only tests targetted for a single subsystem:
+To run only tests targeted for a single subsystem: (including
+hotplug targets in limited mode)
 
   $  make -C tools/testing/selftests TARGETS=cpu-hotplug run_tests
 
 See the top-level tools/testing/selftests/Makefile for the list of all possible
 targets.
 
+Running the full range hotplug selftests
+========================================
+
+To build the tests:
+
+  $ make -C tools/testing/selftests hotplug
+
+To run the tests:
+
+  $ make -C tools/testing/selftests run_hotplug
+
+- note that some tests will require root privileges.
 
 Contributing new tests
 ======================
diff -puN tools/testing/selftests/cpu-hotplug/Makefile~tools-selftests-create-a-separate-hotplug-target-for-full-range-test tools/testing/selftests/cpu-hotplug/Makefile
--- a/tools/testing/selftests/cpu-hotplug/Makefile~tools-selftests-create-a-separate-hotplug-target-for-full-range-test
+++ a/tools/testing/selftests/cpu-hotplug/Makefile
@@ -3,4 +3,7 @@ all:
 run_tests:
 	@/bin/bash ./on-off-test.sh || echo "cpu-hotplug selftests: [FAIL]"
 
+run_full_test:
+	@/bin/bash ./on-off-test.sh -a || echo "cpu-hotplug selftests: [FAIL]"
+
 clean:
diff -puN tools/testing/selftests/cpu-hotplug/on-off-test.sh~tools-selftests-create-a-separate-hotplug-target-for-full-range-test tools/testing/selftests/cpu-hotplug/on-off-test.sh
--- a/tools/testing/selftests/cpu-hotplug/on-off-test.sh~tools-selftests-create-a-separate-hotplug-target-for-full-range-test
+++ a/tools/testing/selftests/cpu-hotplug/on-off-test.sh
@@ -11,6 +11,8 @@ prerequisite()
 		exit 0
 	fi
 
+	taskset -p 01 $$
+
 	SYSFS=`mount -t sysfs | head -1 | awk '{ print $3 }'`
 
 	if [ ! -d "$SYSFS" ]; then
@@ -22,6 +24,19 @@ prerequisite()
 		echo $msg cpu hotplug is not supported >&2
 		exit 0
 	fi
+
+	echo "CPU online/offline summary:"
+	online_cpus=`cat $SYSFS/devices/system/cpu/online`
+	online_max=${online_cpus##*-}
+	echo -e "\t Cpus in online state: $online_cpus"
+
+	offline_cpus=`cat $SYSFS/devices/system/cpu/offline`
+	if [[ "a$offline_cpus" = "a" ]]; then
+		offline_cpus=0
+	else
+		offline_max=${offline_cpus##*-}
+	fi
+	echo -e "\t Cpus in offline state: $offline_cpus"
 }
 
 #
@@ -113,15 +128,25 @@ offline_cpu_expect_fail()
 }
 
 error=-12
+allcpus=0
 priority=0
+online_cpus=0
+online_max=0
+offline_cpus=0
+offline_max=0
 
-while getopts e:hp: opt; do
+while getopts e:ahp: opt; do
 	case $opt in
 	e)
 		error=$OPTARG
 		;;
+	a)
+		allcpus=1
+		;;
 	h)
-		echo "Usage $0 [ -e errno ] [ -p notifier-priority ]"
+		echo "Usage $0 [ -a ] [ -e errno ] [ -p notifier-priority ]"
+		echo -e "\t default offline one cpu"
+		echo -e "\t run with -a option to offline all cpus"
 		exit
 		;;
 	p)
@@ -138,6 +163,29 @@ fi
 prerequisite
 
 #
+# Safe test (default) - offline and online one cpu
+#
+if [ $allcpus -eq 0 ]; then
+	echo "Limited scope test: one hotplug cpu"
+	echo -e "\t (leaves cpu in the original state):"
+	echo -e "\t online to offline to online: cpu $online_max"
+	offline_cpu_expect_success $online_max
+	online_cpu_expect_success $online_max
+
+	if [[ $offline_cpus -gt 0 ]]; then
+		echo -e "\t offline to online to offline: cpu $offline_max"
+		online_cpu_expect_success $offline_max
+		offline_cpu_expect_success $offline_max
+	fi
+	exit 0
+else
+	echo "Full scope test: all hotplug cpus"
+	echo -e "\t online all offline cpus"
+	echo -e "\t offline all online cpus"
+	echo -e "\t online all offline cpus"
+fi
+
+#
 # Online all hot-pluggable CPUs
 #
 for cpu in `hotplaggable_offline_cpus`; do
diff -puN tools/testing/selftests/memory-hotplug/Makefile~tools-selftests-create-a-separate-hotplug-target-for-full-range-test tools/testing/selftests/memory-hotplug/Makefile
--- a/tools/testing/selftests/memory-hotplug/Makefile~tools-selftests-create-a-separate-hotplug-target-for-full-range-test
+++ a/tools/testing/selftests/memory-hotplug/Makefile
@@ -1,6 +1,9 @@
 all:
 
 run_tests:
+	@/bin/bash ./on-off-test.sh -r 2 || echo "memory-hotplug selftests: [FAIL]"
+
+run_full_test:
 	@/bin/bash ./on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
 
 clean:
diff -puN tools/testing/selftests/memory-hotplug/on-off-test.sh~tools-selftests-create-a-separate-hotplug-target-for-full-range-test tools/testing/selftests/memory-hotplug/on-off-test.sh
--- a/tools/testing/selftests/memory-hotplug/on-off-test.sh~tools-selftests-create-a-separate-hotplug-target-for-full-range-test
+++ a/tools/testing/selftests/memory-hotplug/on-off-test.sh
@@ -142,10 +142,16 @@ fi
 
 prerequisite
 
+echo "Test scope: $ratio% hotplug memory"
+echo -e "\t online all hotplug memory in offline state"
+echo -e "\t offline $ratio% hotplug memory in online state"
+echo -e "\t online all hotplug memory in offline state"
+
 #
 # Online all hot-pluggable memory
 #
 for memory in `hotplaggable_offline_memory`; do
+	echo offline-online $memory
 	online_memory_expect_success $memory
 done
 
@@ -154,6 +160,7 @@ done
 #
 for memory in `hotpluggable_online_memory`; do
 	if [ $((RANDOM % 100)) -lt $ratio ]; then
+		echo online-offline $memory
 		offline_memory_expect_success $memory
 	fi
 done
@@ -162,6 +169,7 @@ done
 # Online all hot-pluggable memory again
 #
 for memory in `hotplaggable_offline_memory`; do
+	echo offline-online $memory
 	online_memory_expect_success $memory
 done
 
_

Patches currently in -mm which might be from shuah.kh@samsung.com are

linux-next.patch

