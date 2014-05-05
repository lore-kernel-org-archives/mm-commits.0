From: akpm@linux-foundation.org
Subject: +
 tools-testing-selftests-sysctl-validate-sysctl_writes_strict.patch added to -mm tree
Date: Mon, 05 May 2014 15:00:29 -0700
Message-ID: <536809fd.KBCYexgujORGsqnE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357AbaEEWAa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 18:00:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, keescook@chromium.org

Subject: + tools-testing-selftests-sysctl-validate-sysctl_writes_strict.patch added to -mm tree
To: keescook@chromium.org,rdunlap@infradead.org
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 15:00:29 -0700


The patch titled
     Subject: tools/testing/selftests/sysctl: validate sysctl_writes_strict
has been added to the -mm tree.  Its filename is
     tools-testing-selftests-sysctl-validate-sysctl_writes_strict.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-testing-selftests-sysctl-validate-sysctl_writes_strict.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-testing-selftests-sysctl-validate-sysctl_writes_strict.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: tools/testing/selftests/sysctl: validate sysctl_writes_strict

This adds several behavioral tests to sysctl string and number writing to
detect unexpected cases that behaved differently when the sysctl
kernel.sysctl_writes_strict != 1.

[ original ]
root@localhost:~# make test_num
== Testing sysctl behavior against /proc/sys/kernel/domainname ==
Writing test file ... ok
Checking sysctl is not set to test value ... ok
Writing sysctl from shell ... ok
Resetting sysctl to original value ... ok
Writing entire sysctl in single write ... ok
Writing middle of sysctl after synchronized seek ... FAIL
Writing beyond end of sysctl ... FAIL
Writing sysctl with multiple long writes ... FAIL
Writing entire sysctl in short writes ... FAIL
Writing middle of sysctl after unsynchronized seek ... ok
Checking sysctl maxlen is at least 65 ... ok
Checking sysctl keeps original string on overflow append ... FAIL
Checking sysctl stays NULL terminated on write ... ok
Checking sysctl stays NULL terminated on overwrite ... ok
make: *** [test_num] Error 1
root@localhost:~# make test_string
== Testing sysctl behavior against /proc/sys/vm/swappiness ==
Writing test file ... ok
Checking sysctl is not set to test value ... ok
Writing sysctl from shell ... ok
Resetting sysctl to original value ... ok
Writing entire sysctl in single write ... ok
Writing middle of sysctl after synchronized seek ... FAIL
Writing beyond end of sysctl ... FAIL
Writing sysctl with multiple long writes ... ok
make: *** [test_string] Error 1

[ with CONFIG_PROC_SYSCTL_STRICT_WRITES ]
root@localhost:~# make run_tests
== Testing sysctl behavior against /proc/sys/kernel/domainname ==
Writing test file ... ok
Checking sysctl is not set to test value ... ok
Writing sysctl from shell ... ok
Resetting sysctl to original value ... ok
Writing entire sysctl in single write ... ok
Writing middle of sysctl after synchronized seek ... ok
Writing beyond end of sysctl ... ok
Writing sysctl with multiple long writes ... ok
Writing entire sysctl in short writes ... ok
Writing middle of sysctl after unsynchronized seek ... ok
Checking sysctl maxlen is at least 65 ... ok
Checking sysctl keeps original string on overflow append ... ok
Checking sysctl stays NULL terminated on write ... ok
Checking sysctl stays NULL terminated on overwrite ... ok
== Testing sysctl behavior against /proc/sys/vm/swappiness ==
Writing test file ... ok
Checking sysctl is not set to test value ... ok
Writing sysctl from shell ... ok
Resetting sysctl to original value ... ok
Writing entire sysctl in single write ... ok
Writing middle of sysctl after synchronized seek ... ok
Writing beyond end of sysctl ... ok
Writing sysctl with multiple long writes ... ok

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile                |    1 
 tools/testing/selftests/sysctl/Makefile         |   19 ++
 tools/testing/selftests/sysctl/common_tests     |  109 ++++++++++++++
 tools/testing/selftests/sysctl/run_numerictests |   10 +
 tools/testing/selftests/sysctl/run_stringtests  |   77 +++++++++
 5 files changed, 216 insertions(+)

diff -puN tools/testing/selftests/Makefile~tools-testing-selftests-sysctl-validate-sysctl_writes_strict tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~tools-testing-selftests-sysctl-validate-sysctl_writes_strict
+++ a/tools/testing/selftests/Makefile
@@ -10,6 +10,7 @@ TARGETS += timers
 TARGETS += vm
 TARGETS += powerpc
 TARGETS += user
+TARGETS += sysctl
 
 all:
 	for TARGET in $(TARGETS); do \
diff -puN /dev/null tools/testing/selftests/sysctl/Makefile
--- /dev/null
+++ a/tools/testing/selftests/sysctl/Makefile
@@ -0,0 +1,19 @@
+# Makefile for sysctl selftests.
+# Expects kernel.sysctl_writes_strict=1.
+
+# No binaries, but make sure arg-less "make" doesn't trigger "run_tests".
+all:
+
+# Allow specific tests to be selected.
+test_num:
+	@/bin/sh ./run_numerictests
+
+test_string:
+	@/bin/sh ./run_stringtests
+
+run_tests: all test_num test_string
+
+# Nothing to clean up.
+clean:
+
+.PHONY: all run_tests clean test_num test_string
diff -puN /dev/null tools/testing/selftests/sysctl/common_tests
--- /dev/null
+++ a/tools/testing/selftests/sysctl/common_tests
@@ -0,0 +1,109 @@
+#!/bin/sh
+
+TEST_FILE=$(mktemp)
+
+echo "== Testing sysctl behavior against ${TARGET} =="
+
+set_orig()
+{
+	echo "${ORIG}" > "${TARGET}"
+}
+
+set_test()
+{
+	echo "${TEST_STR}" > "${TARGET}"
+}
+
+verify()
+{
+	local seen
+	seen=$(cat "$1")
+	if [ "${seen}" != "${TEST_STR}" ]; then
+		return 1
+	fi
+	return 0
+}
+
+trap 'set_orig; rm -f "${TEST_FILE}"' EXIT
+
+rc=0
+
+echo -n "Writing test file ... "
+echo "${TEST_STR}" > "${TEST_FILE}"
+if ! verify "${TEST_FILE}"; then
+	echo "FAIL" >&2
+	exit 1
+else
+	echo "ok"
+fi
+
+echo -n "Checking sysctl is not set to test value ... "
+if verify "${TARGET}"; then
+	echo "FAIL" >&2
+	exit 1
+else
+	echo "ok"
+fi
+
+echo -n "Writing sysctl from shell ... "
+set_test
+if ! verify "${TARGET}"; then
+	echo "FAIL" >&2
+	exit 1
+else
+	echo "ok"
+fi
+
+echo -n "Resetting sysctl to original value ... "
+set_orig
+if verify "${TARGET}"; then
+	echo "FAIL" >&2
+	exit 1
+else
+	echo "ok"
+fi
+
+# Now that we've validated the sanity of "set_test" and "set_orig",
+# we can use those functions to set starting states before running
+# specific behavioral tests.
+
+echo -n "Writing entire sysctl in single write ... "
+set_orig
+dd if="${TEST_FILE}" of="${TARGET}" bs=4096 2>/dev/null
+if ! verify "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+echo -n "Writing middle of sysctl after synchronized seek ... "
+set_test
+dd if="${TEST_FILE}" of="${TARGET}" bs=1 seek=1 skip=1 2>/dev/null
+if ! verify "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+echo -n "Writing beyond end of sysctl ... "
+set_orig
+dd if="${TEST_FILE}" of="${TARGET}" bs=20 seek=2 2>/dev/null
+if verify "${TARGET}"; then
+        echo "FAIL" >&2
+        rc=1
+else
+        echo "ok"
+fi
+
+echo -n "Writing sysctl with multiple long writes ... "
+set_orig
+(perl -e 'print "A" x 50;'; echo "${TEST_STR}") | \
+	dd of="${TARGET}" bs=50 2>/dev/null
+if verify "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
diff -puN /dev/null tools/testing/selftests/sysctl/run_numerictests
--- /dev/null
+++ a/tools/testing/selftests/sysctl/run_numerictests
@@ -0,0 +1,10 @@
+#!/bin/sh
+
+SYSCTL="/proc/sys"
+TARGET="${SYSCTL}/vm/swappiness"
+ORIG=$(cat "${TARGET}")
+TEST_STR=$(( $ORIG + 1 ))
+
+. ./common_tests
+
+exit $rc
diff -puN /dev/null tools/testing/selftests/sysctl/run_stringtests
--- /dev/null
+++ a/tools/testing/selftests/sysctl/run_stringtests
@@ -0,0 +1,77 @@
+#!/bin/sh
+
+SYSCTL="/proc/sys"
+TARGET="${SYSCTL}/kernel/domainname"
+ORIG=$(cat "${TARGET}")
+TEST_STR="Testing sysctl"
+
+. ./common_tests
+
+# Only string sysctls support seeking/appending.
+MAXLEN=65
+
+echo -n "Writing entire sysctl in short writes ... "
+set_orig
+dd if="${TEST_FILE}" of="${TARGET}" bs=1 2>/dev/null
+if ! verify "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+echo -n "Writing middle of sysctl after unsynchronized seek ... "
+set_test
+dd if="${TEST_FILE}" of="${TARGET}" bs=1 seek=1 2>/dev/null
+if verify "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+echo -n "Checking sysctl maxlen is at least $MAXLEN ... "
+set_orig
+perl -e 'print "A" x ('"${MAXLEN}"'-2), "B";' | \
+	dd of="${TARGET}" bs="${MAXLEN}" 2>/dev/null
+if ! grep -q B "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+echo -n "Checking sysctl keeps original string on overflow append ... "
+set_orig
+perl -e 'print "A" x ('"${MAXLEN}"'-1), "B";' | \
+	dd of="${TARGET}" bs=$(( MAXLEN - 1 )) 2>/dev/null
+if grep -q B "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+echo -n "Checking sysctl stays NULL terminated on write ... "
+set_orig
+perl -e 'print "A" x ('"${MAXLEN}"'-1), "B";' | \
+	dd of="${TARGET}" bs="${MAXLEN}" 2>/dev/null
+if grep -q B "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+echo -n "Checking sysctl stays NULL terminated on overwrite ... "
+set_orig
+perl -e 'print "A" x ('"${MAXLEN}"'-1), "BB";' | \
+	dd of="${TARGET}" bs=$(( $MAXLEN + 1 )) 2>/dev/null
+if grep -q B "${TARGET}"; then
+	echo "FAIL" >&2
+	rc=1
+else
+	echo "ok"
+fi
+
+exit $rc
_

Patches currently in -mm which might be from keescook@chromium.org are

lib-vsprintf-add-%pt-format-specifier.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
ptrace-fix-fork-event-messages-across-pid-namespaces.patch
sysctl-clean-up-char-buffer-arguments.patch
sysctl-refactor-sysctl-string-writing-logic.patch
sysctl-allow-for-strict-write-position-handling.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
tools-testing-selftests-sysctl-validate-sysctl_writes_strict.patch
tools-testing-selftests-sysctl-validate-sysctl_writes_strict-fix.patch
linux-next.patch

