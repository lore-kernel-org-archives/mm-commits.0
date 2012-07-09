From: akpm@linux-foundation.org
Subject: + fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc-doc.patch added to -mm tree
Date: Mon, 09 Jul 2012 13:58:48 -0700
Message-ID: <20120709205849.06C065C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:62355 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab2GIU6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2012 16:58:51 -0400
Received: by wgbdt11 with SMTP id dt11so696240wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jul 2012 13:58:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     Subject: fault-injection: mention failcmd.sh tool in document
has been added to the -mm tree.  Its filename is
     fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc-doc.patch

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
Subject: Subject: fault-injection: mention failcmd.sh tool in document

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
fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc-doc.patch

