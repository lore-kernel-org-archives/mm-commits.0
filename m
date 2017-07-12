From: akpm@linux-foundation.org
Subject: + test_sysctl-add-simple-proc_douintvec-case.patch added to -mm
 tree
Date: Wed, 12 Jul 2017 12:40:51 -0700
Message-ID: <59667b43.cGzwMhV1uoblujZO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41828 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751767AbdGLTkw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 15:40:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, ebiederm@xmission.com, keescook@chromium.org, shuah@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: test_sysctl: add simple proc_douintvec() case
has been added to the -mm tree.  Its filename is
     test_sysctl-add-simple-proc_douintvec-case.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_sysctl-add-simple-proc_douintvec-case.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_sysctl-add-simple-proc_douintvec-case.patch

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
Subject: test_sysctl: add simple proc_douintvec() case

Test against a simple proc_douintvec() case. While at it, add
a test against UINT_MAX. Make sure UINT_MAX works, and UINT_MAX+1
will fail and that negative values are not accepted.

Link: http://lkml.kernel.org/r/20170630224431.17374-6-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_sysctl.c                        |   11 +++
 tools/testing/selftests/sysctl/sysctl.sh |   63 +++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff -puN lib/test_sysctl.c~test_sysctl-add-simple-proc_douintvec-case lib/test_sysctl.c
--- a/lib/test_sysctl.c~test_sysctl-add-simple-proc_douintvec-case
+++ a/lib/test_sysctl.c
@@ -43,6 +43,8 @@ struct test_sysctl_data {
 	int int_0001;
 	int int_0002;
 
+	unsigned int uint_0001;
+
 	char string_0001[65];
 };
 
@@ -50,6 +52,8 @@ static struct test_sysctl_data test_data
 	.int_0001 = 60,
 	.int_0002 = 1,
 
+	.uint_0001 = 314,
+
 	.string_0001 = "(none)",
 };
 
@@ -72,6 +76,13 @@ static struct ctl_table test_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "uint_0001",
+		.data		= &test_data.uint_0001,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec,
+	},
+	{
 		.procname	= "string_0001",
 		.data		= &test_data.string_0001,
 		.maxlen		= sizeof(test_data.string_0001),
diff -puN tools/testing/selftests/sysctl/sysctl.sh~test_sysctl-add-simple-proc_douintvec-case tools/testing/selftests/sysctl/sysctl.sh
--- a/tools/testing/selftests/sysctl/sysctl.sh~test_sysctl-add-simple-proc_douintvec-case
+++ a/tools/testing/selftests/sysctl/sysctl.sh
@@ -32,6 +32,7 @@ TEST_FILE=$(mktemp)
 ALL_TESTS="0001:1:1"
 ALL_TESTS="$ALL_TESTS 0002:1:1"
 ALL_TESTS="$ALL_TESTS 0003:1:1"
+ALL_TESTS="$ALL_TESTS 0004:1:1"
 
 test_modprobe()
 {
@@ -86,6 +87,9 @@ function check_production_sysctl_writes_
 	if [ -z $INT_MAX ]; then
 		INT_MAX=$(getconf INT_MAX)
 	fi
+	if [ -z $UINT_MAX ]; then
+		UINT_MAX=$(getconf UINT_MAX)
+	fi
 }
 
 test_reqs()
@@ -129,6 +133,9 @@ reset_vals()
 		int_0002)
 			VAL="1"
 			;;
+		uint_0001)
+			VAL="314"
+			;;
 		string_0001)
 			VAL="(none)"
 			;;
@@ -345,6 +352,49 @@ run_limit_digit_int()
 	test_rc
 }
 
+# You are using an unsigned int
+run_limit_digit_uint()
+{
+	echo -n "Testing UINT_MAX works ..."
+	reset_vals
+	TEST_STR="$UINT_MAX"
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
+	echo -n "Testing UINT_MAX + 1 will fail as expected..."
+	reset_vals
+	TEST_STR=$(($UINT_MAX+1))
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
+	echo -n "Testing negative values will not work as expected ..."
+	reset_vals
+	TEST_STR="-3"
+	echo -n $TEST_STR > $TARGET 2> /dev/null
+
+	if verify "${TARGET}"; then
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
@@ -450,6 +500,18 @@ sysctl_test_0003()
 	run_limit_digit_int
 }
 
+sysctl_test_0004()
+{
+	TARGET="${SYSCTL}/uint_0001"
+	reset_vals
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+
+	run_numerictests
+	run_limit_digit
+	run_limit_digit_uint
+}
+
 list_tests()
 {
 	echo "Test ID list:"
@@ -461,6 +523,7 @@ list_tests()
 	echo "0001 x $(get_test_count 0001) - tests proc_dointvec_minmax()"
 	echo "0002 x $(get_test_count 0002) - tests proc_dostring()"
 	echo "0003 x $(get_test_count 0003) - tests proc_dointvec()"
+	echo "0004 x $(get_test_count 0004) - tests proc_douintvec()"
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

