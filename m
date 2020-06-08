From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-test_sysctl-support-testing-of-sysctl-boot-parameter-fix.patch removed
 from -mm tree
Date: Sun, 07 Jun 2020 21:18:01 -0700
Message-ID: <20200608041801.n4l_VF0iY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbgFHESC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:18:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: lib-test_sysctl-support-testing-of-sysctl-boot-parameter-fix
has been removed from the -mm tree.  Its filename was
     lib-test_sysctl-support-testing-of-sysctl-boot-parameter-fix.patch

This patch was dropped because it was folded into lib-test_sysctl-support-testing-of-sysctl-boot-parameter.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: lib-test_sysctl-support-testing-of-sysctl-boot-parameter-fix

Skip the new test if boot_int sysctl is not present, otherwise, per Luis,
"This would fail if someone uses this script to test an older kernel, and
the scripts in selftests are supposed to work with older kernels."

Link: http://lkml.kernel.org/r/305af605-1e60-cf84-fada-6ce1ca37c102@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/sysctl/sysctl.sh |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/sysctl/sysctl.sh~lib-test_sysctl-support-testing-of-sysctl-boot-parameter-fix
+++ a/tools/testing/selftests/sysctl/sysctl.sh
@@ -748,10 +748,15 @@ sysctl_test_0006()
 sysctl_test_0007()
 {
 	TARGET="${SYSCTL}/boot_int"
+	if [ ! -f $TARGET ]; then
+		echo "Skipping test for $TARGET as it is not present ..."
+		return $ksft_skip
+	fi
+
 	if [ -d $DIR ]; then
 		echo "Boot param test only possible sysctl_test is built-in, not module:"
 		cat $TEST_DIR/config >&2
-		return 0
+		return $ksft_skip
 	fi
 
 	echo -n "Testing if $TARGET is set to 1 ..."
@@ -777,6 +782,7 @@ sysctl_test_0007()
 
 	echo "Skipping test, expected kernel parameter missing."
 	echo "To perform this test, make sure kernel is booted with parameter: sysctl.debug.test_sysctl.boot_int=1"
+	return $ksft_skip
 }
 
 list_tests()
_

Patches currently in -mm which might be from vbabka@suse.cz are

kernel-sysctl-support-setting-sysctl-parameters-from-kernel-command-line.patch
kernel-sysctl-support-handling-command-line-aliases.patch
kernel-hung_task-convert-hung_task_panic-boot-parameter-to-sysctl.patch
tools-testing-selftests-sysctl-sysctlsh-support-config_test_sysctl=y.patch
lib-test_sysctl-support-testing-of-sysctl-boot-parameter.patch
