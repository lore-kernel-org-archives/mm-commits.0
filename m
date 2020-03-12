From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-kmod-test-disabling-module-autoloading.patch
 added to -mm tree
Date: Thu, 12 Mar 2020 15:29:48 -0700
Message-ID: <20200312222948.vpAeNOJ3Y%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbgCLW3u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 18:29:50 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, ebiggers@google.com, gregkh@linuxfoundation.org, jeffv@google.com, jeyu@kernel.org, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, neilb@suse.com


The patch titled
     Subject: selftests: kmod: test disabling module autoloading
has been added to the -mm tree.  Its filename is
     selftests-kmod-test-disabling-module-autoloading.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-kmod-test-disabling-module-autoloading.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-kmod-test-disabling-module-autoloading.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: selftests: kmod: test disabling module autoloading

Test that request_module() fails with -ENOENT when
/proc/sys/kernel/modprobe contains (a) a nonexistent path, and (b) an
empty path.

Case (b) is a regression test for the patch "kmod: make request_module()
return an error when autoloading is disabled".

Tested with 'kmod.sh -t 0010 && kmod.sh -t 0011', and also simply with
'kmod.sh' to run all kmod tests.

Note: get_test_count() and get_test_enabled() were broken for test numbers
above 9 due to awk interpreting a field specification like '$0010' as
octal rather than decimal.  So I fixed that too.

Link: http://lkml.kernel.org/r/20200312202552.241885-5-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kmod/kmod.sh |   43 ++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/kmod/kmod.sh~selftests-kmod-test-disabling-module-autoloading
+++ a/tools/testing/selftests/kmod/kmod.sh
@@ -61,6 +61,8 @@ ALL_TESTS="$ALL_TESTS 0006:10:1"
 ALL_TESTS="$ALL_TESTS 0007:5:1"
 ALL_TESTS="$ALL_TESTS 0008:150:1"
 ALL_TESTS="$ALL_TESTS 0009:150:1"
+ALL_TESTS="$ALL_TESTS 0010:1:1"
+ALL_TESTS="$ALL_TESTS 0011:1:1"
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
@@ -149,6 +151,7 @@ function load_req_mod()
 
 test_finish()
 {
+	echo "$MODPROBE" > /proc/sys/kernel/modprobe
 	echo "Test completed"
 }
 
@@ -443,6 +446,30 @@ kmod_test_0009()
 	config_expect_result ${FUNCNAME[0]} SUCCESS
 }
 
+kmod_test_0010()
+{
+	kmod_defaults_driver
+	config_num_threads 1
+	echo "/KMOD_TEST_NONEXISTENT" > /proc/sys/kernel/modprobe
+	config_trigger ${FUNCNAME[0]}
+	config_expect_result ${FUNCNAME[0]} -ENOENT
+	echo "$MODPROBE" > /proc/sys/kernel/modprobe
+}
+
+kmod_test_0011()
+{
+	kmod_defaults_driver
+	config_num_threads 1
+	# This causes the kernel to not even try executing modprobe.  The error
+	# code is still -ENOENT like when modprobe doesn't exist, so we can't
+	# easily test for the exact difference.  But this still is a useful test
+	# since there was a bug where request_module() returned 0 in this case.
+	echo > /proc/sys/kernel/modprobe
+	config_trigger ${FUNCNAME[0]}
+	config_expect_result ${FUNCNAME[0]} -ENOENT
+	echo "$MODPROBE" > /proc/sys/kernel/modprobe
+}
+
 list_tests()
 {
 	echo "Test ID list:"
@@ -460,6 +487,8 @@ list_tests()
 	echo "0007 x $(get_test_count 0007) - multithreaded tests with default setup test request_module() and get_fs_type()"
 	echo "0008 x $(get_test_count 0008) - multithreaded - push kmod_concurrent over max_modprobes for request_module()"
 	echo "0009 x $(get_test_count 0009) - multithreaded - push kmod_concurrent over max_modprobes for get_fs_type()"
+	echo "0010 x $(get_test_count 0010) - test nonexistent modprobe path"
+	echo "0011 x $(get_test_count 0011) - test completely disabling module autoloading"
 }
 
 usage()
@@ -505,18 +534,23 @@ function test_num()
 	fi
 }
 
-function get_test_count()
+function get_test_data()
 {
 	test_num $1
-	TEST_DATA=$(echo $ALL_TESTS | awk '{print $'$1'}')
+	local field_num=$(echo $1 | sed 's/^0*//')
+	echo $ALL_TESTS | awk '{print $'$field_num'}'
+}
+
+function get_test_count()
+{
+	TEST_DATA=$(get_test_data $1)
 	LAST_TWO=${TEST_DATA#*:*}
 	echo ${LAST_TWO%:*}
 }
 
 function get_test_enabled()
 {
-	test_num $1
-	TEST_DATA=$(echo $ALL_TESTS | awk '{print $'$1'}')
+	TEST_DATA=$(get_test_data $1)
 	echo ${TEST_DATA#*:*:}
 }
 
@@ -611,6 +645,7 @@ test_reqs
 allow_user_defaults
 load_req_mod
 
+MODPROBE=$(</proc/sys/kernel/modprobe)
 trap "test_finish" EXIT
 
 parse_args $@
_

Patches currently in -mm which might be from ebiggers@google.com are

kmod-make-request_module-return-an-error-when-autoloading-is-disabled.patch
fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once.patch
docs-admin-guide-document-the-kernelmodprobe-sysctl.patch
selftests-kmod-test-disabling-module-autoloading.patch
