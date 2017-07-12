From: akpm@linux-foundation.org
Subject: + test_sysctl-test-against-page_size-for-int.patch added to -mm
 tree
Date: Wed, 12 Jul 2017 12:40:47 -0700
Message-ID: <59667b3f.uu1aluoHSTIXrjVh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41812 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751767AbdGLTks (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 15:40:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, ebiederm@xmission.com, keescook@chromium.org, shuah@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: test_sysctl: test against PAGE_SIZE for int
has been added to the -mm tree.  Its filename is
     test_sysctl-test-against-page_size-for-int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_sysctl-test-against-page_size-for-int.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_sysctl-test-against-page_size-for-int.patch

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
Subject: test_sysctl: test against PAGE_SIZE for int

Add the following tests to ensure we do not regress:

  o Test using a buffer full of space (PAGE_SIZE-1) followed by a
    single digit works

  o Test using a buffer full of spaces (PAGE_SIZE or over) will fail

As tests increase instead of unloading the module and reloading it
we can just do a shell reset_vals() with a reset to values we know
are set at init on the driver.

Link: http://lkml.kernel.org/r/20170630224431.17374-4-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/sysctl/sysctl.sh |   66 +++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff -puN tools/testing/selftests/sysctl/sysctl.sh~test_sysctl-test-against-page_size-for-int tools/testing/selftests/sysctl/sysctl.sh
--- a/tools/testing/selftests/sysctl/sysctl.sh~test_sysctl-test-against-page_size-for-int
+++ a/tools/testing/selftests/sysctl/sysctl.sh
@@ -75,6 +75,13 @@ function check_production_sysctl_writes_
 			echo "1" > ${WRITES_STRICT}
 		fi
 	fi
+
+	if [ -z $PAGE_SIZE ]; then
+		PAGE_SIZE=$(getconf PAGESIZE)
+	fi
+	if [ -z $MAX_DIGITS ]; then
+		MAX_DIGITS=$(($PAGE_SIZE/8))
+	fi
 }
 
 test_reqs()
@@ -89,6 +96,10 @@ test_reqs()
 		echo "$0: You need perl installed"
 		exit 1
 	fi
+	if ! which getconf 2> /dev/null > /dev/null; then
+		echo "$0: You need getconf installed"
+		exit 1
+	fi
 }
 
 function load_req_mod()
@@ -103,6 +114,23 @@ function load_req_mod()
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
@@ -229,7 +257,42 @@ run_numerictests()
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
+
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
 
@@ -305,15 +368,18 @@ run_stringtests()
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

