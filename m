From: akpm@linux-foundation.org
Subject: [folded] fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc-doc.patch removed from -mm tree
Date: Mon, 30 Jul 2012 14:28:06 -0700
Message-ID: <20120730212806.F0F965C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:58162 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2G3V2I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 17:28:08 -0400
Received: by eaao12 with SMTP id o12so194655eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 14:28:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-injection: mention failcmd.sh tool in document
has been removed from the -mm tree.  Its filename was
     fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc-doc.patch

This patch was dropped because it was folded into fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc.patch

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: fault-injection: mention failcmd.sh tool in document

fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc.patch
in -mm tree adds tools/testing/fault-injection/failcmd.sh to make it
easier to inject slab/page allocation failures by fault injection.

This adds the introduction to
Documentation/fault-injection/fault-injection.txt.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fault-injection/fault-injection.txt |   27 ++++++++++++
 1 file changed, 27 insertions(+)

diff -puN Documentation/fault-injection/fault-injection.txt~fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc-doc Documentation/fault-injection/fault-injection.txt
--- a/Documentation/fault-injection/fault-injection.txt~fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc-doc
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
powerpc-pseries-reconfig-notifier-error-injection-module.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc.patch

