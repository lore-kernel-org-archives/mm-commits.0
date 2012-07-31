From: akpm@linux-foundation.org
Subject: [merged] fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:55:04 -0700
Message-ID: <20120731185505.1AC885C0065@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:63554 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab2GaSzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:55:07 -0400
Received: by lbbgp10 with SMTP id gp10so295606lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:55:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-injection: add tool to run command with failslab or fail_page_alloc
has been removed from the -mm tree.  Its filename was
     fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: fault-injection: add tool to run command with failslab or fail_page_alloc

This adds tools/testing/fault-injection/failcmd.sh to run a command while
injecting slab/page allocation failures via fault injection.

Example:

Run a command "make -C tools/testing/selftests/ run_tests" with
injecting slab allocation failure.

	# ./tools/testing/fault-injection/failcmd.sh \
		-- make -C tools/testing/selftests/ run_tests

Same as above except to specify 100 times failures at most instead of
one time at most by default.

	# ./tools/testing/fault-injection/failcmd.sh --times=100 \
		-- make -C tools/testing/selftests/ run_tests

Same as above except to inject page allocation failure instead of slab
allocation failure.

	# env FAILCMD_TYPE=fail_page_alloc \
		./tools/testing/fault-injection/failcmd.sh --times=100 \
		-- make -C tools/testing/selftests/ run_tests

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fault-injection/fault-injection.txt |   27 +
 tools/testing/fault-injection/failcmd.sh          |  219 ++++++++++++
 2 files changed, 246 insertions(+)

diff -puN Documentation/fault-injection/fault-injection.txt~fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc Documentation/fault-injection/fault-injection.txt
--- a/Documentation/fault-injection/fault-injection.txt~fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc
+++ a/Documentation/fault-injection/fault-injection.txt
@@ -240,3 +240,30 @@ trap "echo 0 > /sys/kernel/debug/$FAILTY
 echo "Injecting errors into the module $module... (interrupt to stop)"
 sleep 1000000
 
+Tool to run command with failslab or fail_page_alloc
+----------------------------------------------------
+In order to make it easier to accomplish the tasks mentioned above, we can use
+tools/testing/fault-injection/failcmd.sh.  Please run a command
+"./tools/testing/fault-injection/failcmd.sh --help" for more information and
+see the following examples.
+
+Examples:
+
+Run a command "make -C tools/testing/selftests/ run_tests" with injecting slab
+allocation failure.
+
+	# ./tools/testing/fault-injection/failcmd.sh \
+		-- make -C tools/testing/selftests/ run_tests
+
+Same as above except to specify 100 times failures at most instead of one time
+at most by default.
+
+	# ./tools/testing/fault-injection/failcmd.sh --times=100 \
+		-- make -C tools/testing/selftests/ run_tests
+
+Same as above except to inject page allocation failure instead of slab
+allocation failure.
+
+	# env FAILCMD_TYPE=fail_page_alloc \
+		./tools/testing/fault-injection/failcmd.sh --times=100 \
+                -- make -C tools/testing/selftests/ run_tests
diff -puN /dev/null tools/testing/fault-injection/failcmd.sh
--- /dev/null
+++ a/tools/testing/fault-injection/failcmd.sh
@@ -0,0 +1,219 @@
+#!/bin/bash
+#
+# NAME
+#	failcmd.sh - run a command with injecting slab/page allocation failures
+#
+# SYNOPSIS
+#	failcmd.sh --help
+#	failcmd.sh [<options>] command [arguments]
+#
+# DESCRIPTION
+#	Run command with injecting slab/page allocation failures by fault
+#	injection.
+#
+#	NOTE: you need to run this script as root.
+#
+
+usage()
+{
+	cat >&2 <<EOF
+Usage: $0 [options] command [arguments]
+
+OPTIONS
+	-p percent
+	--probability=percent
+		likelihood of failure injection, in percent.
+		Default value is 1
+
+	-t value
+	--times=value
+		specifies how many times failures may happen at most.
+		Default value is 1
+
+	--oom-kill-allocating-task=value
+		set /proc/sys/vm/oom_kill_allocating_task to specified value
+		before running the command.
+		Default value is 1
+
+	-h, --help
+		Display a usage message and exit
+
+	--interval=value, --space=value, --verbose=value, --task-filter=value,
+	--stacktrace-depth=value, --require-start=value, --require-end=value,
+	--reject-start=value, --reject-end=value, --ignore-gfp-wait=value
+		See Documentation/fault-injection/fault-injection.txt for more
+		information
+
+	failslab options:
+	--cache-filter=value
+
+	fail_page_alloc options:
+	--ignore-gfp-highmem=value, --min-order=value
+
+ENVIRONMENT
+	FAILCMD_TYPE
+		The following values for FAILCMD_TYPE are recognized:
+
+		failslab
+			inject slab allocation failures
+		fail_page_alloc
+			inject page allocation failures
+
+		If FAILCMD_TYPE is not defined, then failslab is used.
+EOF
+}
+
+if [ $UID != 0 ]; then
+	echo must be run as root >&2
+	exit 1
+fi
+
+DEBUGFS=`mount -t debugfs | head -1 | awk '{ print $3}'`
+
+if [ ! -d "$DEBUGFS" ]; then
+	echo debugfs is not mounted >&2
+	exit 1
+fi
+
+FAILCMD_TYPE=${FAILCMD_TYPE:-failslab}
+FAULTATTR=$DEBUGFS/$FAILCMD_TYPE
+
+if [ ! -d $FAULTATTR ]; then
+	echo $FAILCMD_TYPE is not available >&2
+	exit 1
+fi
+
+LONGOPTS=probability:,interval:,times:,space:,verbose:,task-filter:
+LONGOPTS=$LONGOPTS,stacktrace-depth:,require-start:,require-end:
+LONGOPTS=$LONGOPTS,reject-start:,reject-end:,oom-kill-allocating-task:,help
+
+if [ $FAILCMD_TYPE = failslab ]; then
+	LONGOPTS=$LONGOPTS,ignore-gfp-wait:,cache-filter:
+elif [ $FAILCMD_TYPE = fail_page_alloc ]; then
+	LONGOPTS=$LONGOPTS,ignore-gfp-wait:,ignore-gfp-highmem:,min-order:
+fi
+
+TEMP=`getopt -o p:i:t:s:v:h --long $LONGOPTS -n 'failcmd.sh' -- "$@"`
+
+if [ $? != 0 ]; then
+	usage
+	exit 1
+fi
+
+eval set -- "$TEMP"
+
+fault_attr_default()
+{
+	echo N > $FAULTATTR/task-filter
+	echo 0 > $FAULTATTR/probability
+	echo 1 > $FAULTATTR/times
+}
+
+fault_attr_default
+
+oom_kill_allocating_task_saved=`cat /proc/sys/vm/oom_kill_allocating_task`
+
+restore_values()
+{
+	fault_attr_default
+	echo $oom_kill_allocating_task_saved \
+		> /proc/sys/vm/oom_kill_allocating_task
+}
+
+#
+# Default options
+#
+declare -i oom_kill_allocating_task=1
+declare task_filter=Y
+declare -i probability=1
+declare -i times=1
+
+while true; do
+	case "$1" in
+	-p|--probability)
+		probability=$2
+		shift 2
+		;;
+	-i|--interval)
+		echo $2 > $FAULTATTR/interval
+		shift 2
+		;;
+	-t|--times)
+		times=$2
+		shift 2
+		;;
+	-s|--space)
+		echo $2 > $FAULTATTR/space
+		shift 2
+		;;
+	-v|--verbose)
+		echo $2 > $FAULTATTR/verbose
+		shift 2
+		;;
+	--task-filter)
+		task_filter=$2
+		shift 2
+		;;
+	--stacktrace-depth)
+		echo $2 > $FAULTATTR/stacktrace-depth
+		shift 2
+		;;
+	--require-start)
+		echo $2 > $FAULTATTR/require-start
+		shift 2
+		;;
+	--require-end)
+		echo $2 > $FAULTATTR/require-end
+		shift 2
+		;;
+	--reject-start)
+		echo $2 > $FAULTATTR/reject-start
+		shift 2
+		;;
+	--reject-end)
+		echo $2 > $FAULTATTR/reject-end
+		shift 2
+		;;
+	--oom-kill-allocating-task)
+		oom_kill_allocating_task=$2
+		shift 2
+		;;
+	--ignore-gfp-wait)
+		echo $2 > $FAULTATTR/ignore-gfp-wait
+		shift 2
+		;;
+	--cache-filter)
+		echo $2 > $FAULTATTR/cache_filter
+		shift 2
+		;;
+	--ignore-gfp-highmem)
+		echo $2 > $FAULTATTR/ignore-gfp-highmem
+		shift 2
+		;;
+	--min-order)
+		echo $2 > $FAULTATTR/min-order
+		shift 2
+		;;
+	-h|--help)
+		usage
+		exit 0
+		shift
+		;;
+	--)
+		shift
+		break
+		;;
+	esac
+done
+
+[ -z "$@" ] && exit 0
+
+echo $oom_kill_allocating_task > /proc/sys/vm/oom_kill_allocating_task
+echo $task_filter > $FAULTATTR/task-filter
+echo $probability > $FAULTATTR/probability
+echo $times > $FAULTATTR/times
+
+trap "restore_values" SIGINT SIGTERM EXIT
+
+cmd="echo 1 > /proc/self/make-it-fail && exec $@"
+bash -c "$cmd"
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-fix-failcmdsh-warning.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch

