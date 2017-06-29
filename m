From: akpm@linux-foundation.org
Subject: [to-be-updated]
 test_sysctl-test-against-page_size-for-int.patch removed from -mm tree
Date: Thu, 29 Jun 2017 12:35:53 -0700
Message-ID: <20170629193553.CZfNshNrf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49718 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751715AbdF2Tfy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 15:35:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, shuah@kernel.org


The patch titled
     Subject: test_sysctl: test against PAGE_SIZE for int
has been removed from the -mm tree.  Its filename was
     test_sysctl-test-against-page_size-for-int.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: test_sysctl: test against PAGE_SIZE for int

Add the following tests to ensure we do not regress:

  o Test using a buffer full of space (PAGE_SIZE-1) followed by a
    single digit works

  o Test using a buffer full of spaces (PAGE_SIZE or over) will fail

As tests increase instead of unloading the module and reloading it
we can just do a shell reset_vals() with a reset to values we know
are set at init on the driver.

Link: http://lkml.kernel.org/r/20170525233729.18530-4-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/sysctl/sysctl.sh |   65 +++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff -puN tools/testing/selftests/sysctl/sysctl.sh~test_sysctl-test-against-page_size-for-int tools/testing/selftests/sysctl/sysctl.sh
--- a/tools/testing/selftests/sysctl/sysctl.sh~test_sysctl-test-against-page_size-for-int
+++ a/tools/testing/selftests/sysctl/sysctl.sh
@@ -53,6 +53,12 @@ function allow_user_defaults()
 	if [ -z $SYSCTL ]; then
 		SYSCTL="/proc/sys/debug/test_sysctl"
 	fi
+	if [ -z $PAGE_SIZE ]; then
+		PAGE_SIZE=$(getconf PAGESIZE)
+	fi
+	if [ -z $MAX_DIGITS ]; then
+		MAX_DIGITS=$(($PAGE_SIZE/8))
+	fi
 }
 
 test_reqs()
@@ -67,6 +73,10 @@ test_reqs()
 		echo "$0: You need perl installed"
 		exit 1
 	fi
+	if ! which getconf 2> /dev/null > /dev/null; then
+		echo "$0: You need getconf installed"
+		exit 1
+	fi
 }
 
 function load_req_mod()
@@ -81,6 +91,23 @@ function load_req_mod()
 	fi
 }
 
+reset_vals()
+{
+	VAL=""
+	TRIGGER=$(basename ${TARGET})
+	case "$TRIGGER" in
+		int_0001)
+			VAL="60"
+			;;
+		string_0001)
+			VAL="(none)"
+			;;
+		*)
+			;;
+	esac
+	echo -n $VAL > $TARGET
+}
+
 set_orig()
 {
 	if [ ! -z $TARGET ]; then
@@ -202,7 +229,42 @@ run_numerictests()
 	else
 		echo "ok"
 	fi
+	test_rc
+}
+
+# Your test must accept digits 3 and 4 to use this
+run_limit_digit()
+{
+	echo -n "Checking ignoring spaces up to PAGE_SIZE works on write ..."
+	reset_vals
+
+	LIMIT=$((MAX_DIGITS -1))
+	TEST_STR="3"
+	(perl -e 'print " " x '$LIMIT';'; echo "${TEST_STR}") | \
+		dd of="${TARGET}" 2>/dev/null
+
+	if ! verify "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+	test_rc
+
+	echo -n "Checking passing PAGE_SIZE of spaces fails on write ..."
+	reset_vals
 
+	LIMIT=$((MAX_DIGITS))
+	TEST_STR="4"
+	(perl -e 'print " " x '$LIMIT';'; echo "${TEST_STR}") | \
+		dd of="${TARGET}" 2>/dev/null
+
+	if verify "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
 	test_rc
 }
 
@@ -278,15 +340,18 @@ run_stringtests()
 sysctl_test_0001()
 {
 	TARGET="${SYSCTL}/int_0001"
+	reset_vals
 	ORIG=$(cat "${TARGET}")
 	TEST_STR=$(( $ORIG + 1 ))
 
 	run_numerictests
+	run_limit_digit
 }
 
 sysctl_test_0002()
 {
 	TARGET="${SYSCTL}/string_0001"
+	reset_vals
 	ORIG=$(cat "${TARGET}")
 	TEST_STR="Testing sysctl"
 	# Only string sysctls support seeking/appending.
_

Patches currently in -mm which might be from mcgrof@kernel.org are

maintainers-give-proc-sysctl-some-maintainer-love.patch
sysctl-fix-lax-sysctl_check_table-sanity-check.patch
sysctl-kdocify-sysctl_writes_strict.patch
sysctl-fold-sysctl_writes_strict-checks-into-helper.patch
sysctl-simplify-unsigned-int-support.patch
sysctl-add-unsigned-int-range-support.patch
test_sysctl-add-dedicated-proc-sysctl-test-driver.patch
test_sysctl-add-simple-proc_dointvec-case.patch
test_sysctl-add-simple-proc_douintvec-case.patch
test_sysctl-test-against-int-proc_dointvec-array-support.patch

