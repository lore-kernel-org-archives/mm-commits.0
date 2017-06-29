From: akpm@linux-foundation.org
Subject: [to-be-updated]
 test_sysctl-add-simple-proc_dointvec-case.patch removed from -mm tree
Date: Thu, 29 Jun 2017 12:35:55 -0700
Message-ID: <20170629193555.-PkuWrUT_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753221AbdF2TgL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 15:36:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, shuah@kernel.org


The patch titled
     Subject: test_sysctl: add simple proc_dointvec() case
has been removed from the -mm tree.  Its filename was
     test_sysctl-add-simple-proc_dointvec-case.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: test_sysctl: add simple proc_dointvec() case

Test against a simple proc_dointvec() case.  While at it, add a test
against INT_MAX.  Make sure INT_MAX works, and INT_MAX+1 will fail.  Also
test negative values work.

Link: http://lkml.kernel.org/r/20170525233729.18530-5-mcgrof@kernel.org
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
@@ -59,6 +60,9 @@ function allow_user_defaults()
 	if [ -z $MAX_DIGITS ]; then
 		MAX_DIGITS=$(($PAGE_SIZE/8))
 	fi
+	if [ -z $INT_MAX ]; then
+		INT_MAX=$(getconf INT_MAX)
+	fi
 }
 
 test_reqs()
@@ -99,6 +103,9 @@ reset_vals()
 		int_0001)
 			VAL="60"
 			;;
+		int_0002)
+			VAL="1"
+			;;
 		string_0001)
 			VAL="(none)"
 			;;
@@ -268,6 +275,48 @@ run_limit_digit()
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
@@ -361,6 +410,18 @@ sysctl_test_0002()
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
@@ -371,6 +432,7 @@ list_tests()
 	echo
 	echo "0001 x $(get_test_count 0001) - tests proc_dointvec_minmax()"
 	echo "0002 x $(get_test_count 0002) - tests proc_dostring()"
+	echo "0003 x $(get_test_count 0003) - tests proc_dointvec()"
 }
 
 test_reqs
_

Patches currently in -mm which might be from mcgrof@kernel.org are

maintainers-give-proc-sysctl-some-maintainer-love.patch
sysctl-fix-lax-sysctl_check_table-sanity-check.patch
sysctl-kdocify-sysctl_writes_strict.patch
sysctl-fold-sysctl_writes_strict-checks-into-helper.patch
sysctl-simplify-unsigned-int-support.patch
sysctl-add-unsigned-int-range-support.patch
test_sysctl-add-dedicated-proc-sysctl-test-driver.patch
test_sysctl-add-simple-proc_douintvec-case.patch
test_sysctl-test-against-int-proc_dointvec-array-support.patch

