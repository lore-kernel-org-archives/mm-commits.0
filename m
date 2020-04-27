From: akpm@linux-foundation.org
Subject: +
 lib-test_sysctl-support-testing-of-sysctl-boot-parameter.patch added to -mm
 tree
Date: Mon, 27 Apr 2020 11:34:02 -0700
Message-ID: <20200427183402.R-0AsWUBB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbgD0SeF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Apr 2020 14:34:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, christian.brauner@ubuntu.com, ebiederm@xmission.com, gpiccoli@canonical.com, gregkh@linuxfoundation.org, ivan.teterevkov@nutanix.com, keescook@chromium.org, mcgrof@kernel.org, mhiramat@kernel.org, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com, tglx@linutronix.de, vbabka@suse.cz, willy@infradead.org, yzaikin@google.com


The patch titled
     Subject: lib/test_sysctl: support testing of sysctl. boot parameter
has been added to the -mm tree.  Its filename is
     lib-test_sysctl-support-testing-of-sysctl-boot-parameter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_sysctl-support-testing-of-sysctl-boot-parameter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_sysctl-support-testing-of-sysctl-boot-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: lib/test_sysctl: support testing of sysctl. boot parameter

Testing is done by a new parameter debug.test_sysctl.boot_int which
defaults to 0 and it's expected that the tester passes a boot parameter
that sets it to 1.  The test checks if it's set to 1.  To distinguish true
failure from parameter not being set, the test checks /proc/cmdline for
the expected parameter, and whether test_sysctl is built-in and not a
module.

Link: http://lkml.kernel.org/r/20200427180433.7029-6-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Guilherme G . Piccoli" <gpiccoli@canonical.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Ivan Teterevkov <ivan.teterevkov@nutanix.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_sysctl.c                        |   13 +++++++
 tools/testing/selftests/sysctl/sysctl.sh |   36 +++++++++++++++++++++
 2 files changed, 49 insertions(+)

--- a/lib/test_sysctl.c~lib-test_sysctl-support-testing-of-sysctl-boot-parameter
+++ a/lib/test_sysctl.c
@@ -44,6 +44,8 @@ struct test_sysctl_data {
 	int int_0002;
 	int int_0003[4];
 
+	int boot_int;
+
 	unsigned int uint_0001;
 
 	char string_0001[65];
@@ -61,6 +63,8 @@ static struct test_sysctl_data test_data
 	.int_0003[2] = 2,
 	.int_0003[3] = 3,
 
+	.boot_int = 0,
+
 	.uint_0001 = 314,
 
 	.string_0001 = "(none)",
@@ -92,6 +96,15 @@ static struct ctl_table test_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "boot_int",
+		.data		= &test_data.boot_int,
+		.maxlen		= sizeof(test_data.boot_int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
+	{
 		.procname	= "uint_0001",
 		.data		= &test_data.uint_0001,
 		.maxlen		= sizeof(unsigned int),
--- a/tools/testing/selftests/sysctl/sysctl.sh~lib-test_sysctl-support-testing-of-sysctl-boot-parameter
+++ a/tools/testing/selftests/sysctl/sysctl.sh
@@ -39,6 +39,7 @@ ALL_TESTS="$ALL_TESTS 0003:1:1:int_0002"
 ALL_TESTS="$ALL_TESTS 0004:1:1:uint_0001"
 ALL_TESTS="$ALL_TESTS 0005:3:1:int_0003"
 ALL_TESTS="$ALL_TESTS 0006:50:1:bitmap_0001"
+ALL_TESTS="$ALL_TESTS 0007:1:1:boot_int"
 
 test_modprobe()
 {
@@ -752,6 +753,40 @@ sysctl_test_0006()
 	run_bitmaptest
 }
 
+sysctl_test_0007()
+{
+	TARGET="${SYSCTL}/boot_int"
+	if [ -d $DIR ]; then
+		echo "Boot param test only possible sysctl_test is built-in, not module:"
+		cat $TEST_DIR/config >&2
+		return 0
+	fi
+
+	echo -n "Testing if $TARGET is set to 1 ..."
+	ORIG=$(cat "${TARGET}")
+
+	if [ x$ORIG = "x1" ]; then
+		echo "ok"
+		return 0
+	fi
+	echo "FAIL"
+	echo "Checking if /proc/cmdline contains setting of the expected parameter ..."
+	if [ ! -f /proc/cmdline ]; then
+		echo "/proc/cmdline does not exist, test inconclusive"
+		return 0
+	fi
+
+	FOUND=$(grep -c "sysctl[./]debug[./]test_sysctl[./]boot_int=1" /proc/cmdline)
+	if [ $FOUND = "1" ]; then
+		echo "Kernel param found but $TARGET is not 1, TEST FAILED"
+		rc=1
+		test_rc
+	fi
+
+	echo "Skipping test, expected kernel parameter missing."
+	echo "To perform this test, make sure kernel is booted with parameter: sysctl.debug.test_sysctl.boot_int=1"
+}
+
 list_tests()
 {
 	echo "Test ID list:"
@@ -766,6 +801,7 @@ list_tests()
 	echo "0004 x $(get_test_count 0004) - tests proc_douintvec()"
 	echo "0005 x $(get_test_count 0005) - tests proc_douintvec() array"
 	echo "0006 x $(get_test_count 0006) - tests proc_do_large_bitmap()"
+	echo "0007 x $(get_test_count 0007) - tests setting sysctl from kernel boot param"
 }
 
 usage()
_

Patches currently in -mm which might be from vbabka@suse.cz are

usercopy-mark-dma-kmalloc-caches-as-usercopy-caches.patch
mm-dump_page-do-not-crash-with-invalid-mapping-pointer.patch
kernel-sysctl-support-setting-sysctl-parameters-from-kernel-command-line.patch
kernel-sysctl-support-handling-command-line-aliases.patch
kernel-hung_task-convert-hung_task_panic-boot-parameter-to-sysctl.patch
tools-testing-selftests-sysctl-sysctlsh-support-config_test_sysctl=y.patch
lib-test_sysctl-support-testing-of-sysctl-boot-parameter.patch
