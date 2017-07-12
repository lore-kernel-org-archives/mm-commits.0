From: akpm@linux-foundation.org
Subject: + test_sysctl-add-simple-proc_dointvec-case.patch added to -mm
 tree
Date: Wed, 12 Jul 2017 12:40:49 -0700
Message-ID: <59667b41.C95HQwzieVdzBTcj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41820 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751767AbdGLTku (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 15:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, ebiederm@xmission.com, keescook@chromium.org, shuah@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: test_sysctl: add simple proc_dointvec() case
has been added to the -mm tree.  Its filename is
     test_sysctl-add-simple-proc_dointvec-case.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_sysctl-add-simple-proc_dointvec-case.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_sysctl-add-simple-proc_dointvec-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: test_sysctl: add simple proc_dointvec() case

Test against a simple proc_dointvec() case.  While at it, add a test
against INT_MAX.  Make sure INT_MAX works, and INT_MAX+1 will fail.  Also
test negative values work.

Link: http://lkml.kernel.org/r/20170630224431.17374-5-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_sysctl.c                        |   11 +++
 tools/testing/selftests/sysctl/sysctl.sh |   62 +++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff -puN lib/test_sysctl.c~test_sysctl-add-simple-proc_dointvec-case lib/test_sysctl.c
--- a/lib/test_sysctl.c~test_sysctl-add-simple-proc_dointvec-case
+++ a/lib/test_sysctl.c
@@ -41,11 +41,15 @@ static int i_one_hundred = 100;
 
 struct test_sysctl_data {
 	int int_0001;
+	int int_0002;
+
 	char string_0001[65];
 };
 
 static struct test_sysctl_data test_data = {
 	.int_0001 = 60,
+	.int_0002 = 1,
+
 	.string_0001 = "(none)",
 };
 
@@ -61,6 +65,13 @@ static struct ctl_table test_table[] = {
 		.extra2         = &i_one_hundred,
 	},
 	{
+		.procname	= "int_0002",
+		.data		= &test_data.int_0002,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
 		.procname	= "string_0001",
 		.data		= &test_data.string_0001,
 		.maxlen		= sizeof(test_data.string_0001),
diff -puN tools/testing/selftests/sysctl/sysctl.sh~test_sysctl-add-simple-proc_dointvec-case tools/testing/selftests/sysctl/sysctl.sh
--- a/tools/testing/selftests/sysctl/sysctl.sh~test_sysctl-add-simple-proc_dointvec-case
+++ a/tools/testing/selftests/sysctl/sysctl.sh
@@ -31,6 +31,7 @@ TEST_FILE=$(mktemp)
 # we have tons of space.
 ALL_TESTS="0001:1:1"
 ALL_TESTS="$ALL_TESTS 0002:1:1"
+ALL_TESTS="$ALL_TESTS 0003:1:1"
 
 test_modprobe()
 {
@@ -82,6 +83,9 @@ function check_production_sysctl_writes_
 	if [ -z $MAX_DIGITS ]; then
 		MAX_DIGITS=$(($PAGE_SIZE/8))
 	fi
+	if [ -z $INT_MAX ]; then
+		INT_MAX=$(getconf INT_MAX)
+	fi
 }
 
 test_reqs()
@@ -122,6 +126,9 @@ reset_vals()
 		int_0001)
 			VAL="60"
 			;;
+		int_0002)
+			VAL="1"
+			;;
 		string_0001)
 			VAL="(none)"
 			;;
@@ -296,6 +303,48 @@ run_limit_digit()
 	test_rc
 }
 
+# You are using an int
+run_limit_digit_int()
+{
+	echo -n "Testing INT_MAX works ..."
+	reset_vals
+	TEST_STR="$INT_MAX"
+	echo -n $TEST_STR > $TARGET
+
+	if ! verify "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+	test_rc
+
+	echo -n "Testing INT_MAX + 1 will fail as expected..."
+	reset_vals
+	let TEST_STR=$INT_MAX+1
+	echo -n $TEST_STR > $TARGET 2> /dev/null
+
+	if verify "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+	test_rc
+
+	echo -n "Testing negative values will work as expected..."
+	reset_vals
+	TEST_STR="-3"
+	echo -n $TEST_STR > $TARGET 2> /dev/null
+	if ! verify "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+	test_rc
+}
+
 run_stringtests()
 {
 	echo -n "Writing entire sysctl in short writes ... "
@@ -389,6 +438,18 @@ sysctl_test_0002()
 	run_stringtests
 }
 
+sysctl_test_0003()
+{
+	TARGET="${SYSCTL}/int_0002"
+	reset_vals
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+
+	run_numerictests
+	run_limit_digit
+	run_limit_digit_int
+}
+
 list_tests()
 {
 	echo "Test ID list:"
@@ -399,6 +460,7 @@ list_tests()
 	echo
 	echo "0001 x $(get_test_count 0001) - tests proc_dointvec_minmax()"
 	echo "0002 x $(get_test_count 0002) - tests proc_dostring()"
+	echo "0003 x $(get_test_count 0003) - tests proc_dointvec()"
 }
 
 test_reqs
_

Patches currently in -mm which might be from mcgrof@kernel.org are

sysctl-fix-lax-sysctl_check_table-sanity-check.patch
sysctl-kdocify-sysctl_writes_strict.patch
sysctl-fold-sysctl_writes_strict-checks-into-helper.patch
sysctl-simplify-unsigned-int-support.patch
sysctl-add-unsigned-int-range-support.patch
test_sysctl-add-dedicated-proc-sysctl-test-driver.patch
test_sysctl-add-generic-script-to-expand-on-tests.patch
test_sysctl-test-against-page_size-for-int.patch
test_sysctl-add-simple-proc_dointvec-case.patch
test_sysctl-add-simple-proc_douintvec-case.patch
test_sysctl-test-against-int-proc_dointvec-array-support.patch
maintainers-give-kmod-some-maintainer-love.patch
kmod-add-test-driver-to-stress-test-the-module-loader.patch
kmod-throttle-kmod-thread-limit.patch

