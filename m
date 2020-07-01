From: akpm@linux-foundation.org
Subject: [withdrawn] selftests-simplify-kmod-failure-value.patch
 removed from -mm tree
Date: Tue, 30 Jun 2020 19:35:51 -0700
Message-ID: <20200701023551.Fi3eR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgGACf5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 22:35:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yangtiezhu@loongson.cn, viro@zeniv.linux.org.uk, slyfox@gentoo.org, shuah@kernel.org, serge@hallyn.com, roopa@cumulusnetworks.com, ravenexp@gmail.com, philipp.reisner@linbit.com, nikolay@cumulusnetworks.com, lars.ellenberg@linbit.com, kuba@kernel.org, keescook@chromium.org, josh@joshtriplett.org, jmorris@namei.org, jarkko.sakkinen@linux.intel.com, hch@infradead.org, gregkh@linuxfoundation.org, dhowells@redhat.com, davem@davemloft.net, chuck.lever@oracle.com, christian.brauner@ubuntu.com, chainsaw@gentoo.org, bfields@fieldses.org, axboe@kernel.dk, ast@kernel.org, mcgrof@kernel.org


The patch titled
     Subject: selftests: simplify kmod failure value
has been removed from the -mm tree.  Its filename was
     selftests-simplify-kmod-failure-value.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: selftests: simplify kmod failure value

The "odd" 256 value was just an issue with the umh never wrapping it
around with WEXITSTATUS() for us.  Now that it does that, we can use a
sane value / name for the selftest, and this is no longer a oddity.

We add a way to detect this for older kernels, and support the old return
value for kernel code where it was given.

This never affected userspace.

Link: http://lkml.kernel.org/r/20200610154923.27510-6-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reported-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Sergey Kvachonok <ravenexp@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tony Vroon <chainsaw@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kmod/kmod.sh |   46 +++++++++++++++++++++----
 1 file changed, 39 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/kmod/kmod.sh~selftests-simplify-kmod-failure-value
+++ a/tools/testing/selftests/kmod/kmod.sh
@@ -64,6 +64,8 @@ ALL_TESTS="$ALL_TESTS 0009:150:1"
 ALL_TESTS="$ALL_TESTS 0010:1:1"
 ALL_TESTS="$ALL_TESTS 0011:1:1"
 
+MODULE_NOT_FOUND="FAILURE"
+
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
@@ -155,14 +157,19 @@ test_finish()
 	echo "Test completed"
 }
 
+# OLD_FAILURE is just because the old kernel umh never wrapped
+# the error with WEXITSTATUS(). Now that it does it, we get the
+# appropriate actual value from userspace observed in-kernel.
+
+# We keep the old mapping to ensure this script keeps working
+# with older kernels.
 errno_name_to_val()
 {
 	case "$1" in
-	# kmod calls modprobe and upon of a module not found
-	# modprobe returns just 1... However in the kernel we
-	# *sometimes* see 256...
-	MODULE_NOT_FOUND)
+	OLD_FAILURE)
 		echo 256;;
+	FAILURE)
+		echo 1;;
 	SUCCESS)
 		echo 0;;
 	-EPERM)
@@ -181,7 +188,9 @@ errno_name_to_val()
 errno_val_to_name()
 	case "$1" in
 	256)
-		echo MODULE_NOT_FOUND;;
+		echo OLD_FAILURE;;
+	1)
+		echo FAILURE;;
 	0)
 		echo SUCCESS;;
 	-1)
@@ -335,6 +344,28 @@ kmod_defaults_fs()
 	config_set_test_case_fs
 }
 
+check_umh()
+{
+	NAME=''
+
+	kmod_defaults_driver
+	config_num_threads 1
+	printf '\0' >"$DIR"/config_test_driver
+	config_trigger ${FUNCNAME[0]}
+	RC=$(config_get_test_result)
+	if [[ "$RC" == "256" ]]; then
+		MODULE_NOT_FOUND="OLD_FAILURE"
+		echo "check_umh: you have and old umh which didn't wrap errors"
+		echo "           with WEXITSTATUS(). This is OK!"
+	elif [[ "$RC" != "1" ]]; then
+		echo "check_umh: Unexpected return value with no modprobe argument: $RC"
+		exit
+	else
+		echo "check_umh: You have a new umh which wraps erros with"
+		echo "           WEXITSTATUS(). This is OK!"
+	fi
+}
+
 kmod_test_0001_driver()
 {
 	NAME='\000'
@@ -343,7 +374,7 @@ kmod_test_0001_driver()
 	config_num_threads 1
 	printf $NAME >"$DIR"/config_test_driver
 	config_trigger ${FUNCNAME[0]}
-	config_expect_result ${FUNCNAME[0]} MODULE_NOT_FOUND
+	config_expect_result ${FUNCNAME[0]} $MODULE_NOT_FOUND
 }
 
 kmod_test_0001_fs()
@@ -371,7 +402,7 @@ kmod_test_0002_driver()
 	config_set_driver $NAME
 	config_num_threads 1
 	config_trigger ${FUNCNAME[0]}
-	config_expect_result ${FUNCNAME[0]} MODULE_NOT_FOUND
+	config_expect_result ${FUNCNAME[0]} $MODULE_NOT_FOUND
 }
 
 kmod_test_0002_fs()
@@ -648,6 +679,7 @@ load_req_mod
 MODPROBE=$(</proc/sys/kernel/modprobe)
 trap "test_finish" EXIT
 
+check_umh
 parse_args $@
 
 exit 0
_

Patches currently in -mm which might be from mcgrof@kernel.org are
