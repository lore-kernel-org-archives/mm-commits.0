From: akpm@linux-foundation.org
Subject: - fault-injection-fix-example-scripts-in-documentation.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:17 -0700
Message-ID: <200707162055.l6GKtHEB001900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758673AbXGPVKh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:10:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault-injection: fix example scripts in documentation
has been removed from the -mm tree.  Its filename was
     fault-injection-fix-example-scripts-in-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fault-injection: fix example scripts in documentation
From: Akinobu Mita <akinobu.mita@gmail.com>

Fix and cleanup example scripts in fault injection documentation.

1. Eliminate broken oops() shell function.

2. Fold failcmd.sh and failmodule.sh into example scripts. It makes
   the example scripts work independent of current working directory.

3. Set "space" parameter to 0 to start injecting errors immediately.

4. Use /sys/module/<modulename>/sections/.data as upper bound of
   .text section. Because some module doesn't have .exit.text section.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fault-injection/failcmd.sh          |    4 
 Documentation/fault-injection/failmodule.sh       |   31 ---
 Documentation/fault-injection/fault-injection.txt |  107 ++++++------
 3 files changed, 57 insertions(+), 85 deletions(-)

diff -puN Documentation/fault-injection/failcmd.sh~fault-injection-fix-example-scripts-in-documentation /dev/null
--- a/Documentation/fault-injection/failcmd.sh
+++ /dev/null
@@ -1,4 +0,0 @@
-#!/bin/bash
-
-echo 1 > /proc/self/make-it-fail
-exec $*
diff -puN Documentation/fault-injection/failmodule.sh~fault-injection-fix-example-scripts-in-documentation /dev/null
--- a/Documentation/fault-injection/failmodule.sh
+++ /dev/null
@@ -1,31 +0,0 @@
-#!/bin/bash
-#
-# Usage: failmodule <failname> <modulename> [stacktrace-depth]
-#
-#	<failname>: "failslab", "fail_alloc_page", or "fail_make_request"
-#
-#	<modulename>: module name that you want to inject faults.
-#
-#	[stacktrace-depth]: the maximum number of stacktrace walking allowed
-#
-
-STACKTRACE_DEPTH=5
-if [ $# -gt 2 ]; then
-	STACKTRACE_DEPTH=$3
-fi
-
-if [ ! -d /debug/$1 ]; then
-	echo "Fault-injection $1 does not exist" >&2
-	exit 1
-fi
-if [ ! -d /sys/module/$2 ]; then
-	echo "Module $2 does not exist" >&2
-	exit 1
-fi
-
-# Disable any fault injection
-echo 0 > /debug/$1/stacktrace-depth
-
-echo `cat /sys/module/$2/sections/.text` > /debug/$1/require-start
-echo `cat /sys/module/$2/sections/.exit.text` > /debug/$1/require-end
-echo $STACKTRACE_DEPTH > /debug/$1/stacktrace-depth
diff -puN Documentation/fault-injection/fault-injection.txt~fault-injection-fix-example-scripts-in-documentation Documentation/fault-injection/fault-injection.txt
--- a/Documentation/fault-injection/fault-injection.txt~fault-injection-fix-example-scripts-in-documentation
+++ a/Documentation/fault-injection/fault-injection.txt
@@ -161,70 +161,77 @@ o add a hook to insert failures
 Application Examples
 --------------------
 
-o inject slab allocation failures into module init/cleanup code
+o Inject slab allocation failures into module init/exit code
 
-------------------------------------------------------------------------------
 #!/bin/bash
 
-FAILCMD=Documentation/fault-injection/failcmd.sh
-BLACKLIST="root_plug evbug"
-
-FAILNAME=failslab
-echo Y > /debug/$FAILNAME/task-filter
-echo 10 > /debug/$FAILNAME/probability
-echo 100 > /debug/$FAILNAME/interval
-echo -1 > /debug/$FAILNAME/times
-echo 2 > /debug/$FAILNAME/verbose
-echo 1 > /debug/$FAILNAME/ignore-gfp-wait
+FAILTYPE=failslab
+echo Y > /debug/$FAILTYPE/task-filter
+echo 10 > /debug/$FAILTYPE/probability
+echo 100 > /debug/$FAILTYPE/interval
+echo -1 > /debug/$FAILTYPE/times
+echo 0 > /debug/$FAILTYPE/space
+echo 2 > /debug/$FAILTYPE/verbose
+echo 1 > /debug/$FAILTYPE/ignore-gfp-wait
 
-blacklist()
+faulty_system()
 {
-	echo $BLACKLIST | grep $1 > /dev/null 2>&1
+	bash -c "echo 1 > /proc/self/make-it-fail && exec $*"
 }
 
-oops()
-{
-	dmesg | grep BUG > /dev/null 2>&1
-}
-
-find /lib/modules/`uname -r` -name '*.ko' -exec basename {} .ko \; |
-	while read i
-	do
-		oops && exit 1
-
-		if ! blacklist $i
-		then
-			echo inserting $i...
-			bash $FAILCMD modprobe $i
-		fi
-	done
-
-lsmod | awk '{ if ($3 == 0) { print $1 } }' |
-	while read i
-	do
-		oops && exit 1
-
-		if ! blacklist $i
-		then
-			echo removing $i...
-			bash $FAILCMD modprobe -r $i
-		fi
-	done
+if [ $# -eq 0 ]
+then
+	echo "Usage: $0 modulename [ modulename ... ]"
+	exit 1
+fi
+
+for m in $*
+do
+	echo inserting $m...
+	faulty_system modprobe $m
+
+	echo removing $m...
+	faulty_system modprobe -r $m
+done
 
 ------------------------------------------------------------------------------
 
-o inject slab allocation failures only for a specific module
+o Inject page allocation failures only for a specific module
 
-------------------------------------------------------------------------------
 #!/bin/bash
 
-FAILMOD=Documentation/fault-injection/failmodule.sh
+FAILTYPE=fail_page_alloc
+module=$1
 
-echo injecting errors into the module $1...
+if [ -z $module ]
+then
+	echo "Usage: $0 <modulename>"
+	exit 1
+fi
+
+modprobe $module
+
+if [ ! -d /sys/module/$module/sections ]
+then
+	echo Module $module is not loaded
+	exit 1
+fi
+
+cat /sys/module/$module/sections/.text > /debug/$FAILTYPE/require-start
+cat /sys/module/$module/sections/.data > /debug/$FAILTYPE/require-end
+
+echo N > /debug/$FAILTYPE/task-filter
+echo 10 > /debug/$FAILTYPE/probability
+echo 100 > /debug/$FAILTYPE/interval
+echo -1 > /debug/$FAILTYPE/times
+echo 0 > /debug/$FAILTYPE/space
+echo 2 > /debug/$FAILTYPE/verbose
+echo 1 > /debug/$FAILTYPE/ignore-gfp-wait
+echo 1 > /debug/$FAILTYPE/ignore-gfp-highmem
+echo 10 > /debug/$FAILTYPE/stacktrace-depth
 
-modprobe $1
-bash $FAILMOD failslab $1 10
-echo 25 > /debug/failslab/probability
+trap "echo 0 > /debug/$FAILTYPE/probability" SIGINT SIGTERM EXIT
 
-------------------------------------------------------------------------------
+echo "Injecting errors into the module $module... (interrupt to stop)"
+sleep 1000000
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-dvb.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
unregister_chrdev-ignore-the-return-value.patch
unregister_chrdev-return-void.patch
unregister_blkdev-do-warn_on-on-failure.patch
unregister_blkdev-delete-redundant-messages-in-callers.patch
unregister_blkdev-delete-redundant-message.patch
unregister_blkdev-return-void.patch
