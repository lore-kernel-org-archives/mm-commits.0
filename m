From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 lib-test_sysctl-support-testing-of-sysctl-boot-parameter-fix.patch added to
 -mm tree
Date: Fri, 15 May 2020 12:29:18 -0700
Message-ID: <20200515192918.oKaPZWmB0%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgEOT3T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 May 2020 15:29:19 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: lib-test_sysctl-support-testing-of-sysctl-boot-parameter-fix
has been added to the -mm tree.  Its filename is
     lib-test_sysctl-support-testing-of-sysctl-boot-parameter-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_sysctl-support-testing-of-sysctl-boot-parameter-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_sysctl-support-testing-of-sysctl-boot-parameter-fix.patch

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
@@ -756,10 +756,15 @@ sysctl_test_0006()
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
@@ -785,6 +790,7 @@ sysctl_test_0007()
 
 	echo "Skipping test, expected kernel parameter missing."
 	echo "To perform this test, make sure kernel is booted with parameter: sysctl.debug.test_sysctl.boot_int=1"
+	return $ksft_skip
 }
 
 list_tests()
_

Patches currently in -mm which might be from vbabka@suse.cz are

usercopy-mark-dma-kmalloc-caches-as-usercopy-caches.patch
mm-dump_page-do-not-crash-with-invalid-mapping-pointer.patch
kernel-sysctl-support-setting-sysctl-parameters-from-kernel-command-line.patch
kernel-sysctl-support-handling-command-line-aliases.patch
kernel-hung_task-convert-hung_task_panic-boot-parameter-to-sysctl.patch
tools-testing-selftests-sysctl-sysctlsh-support-config_test_sysctl=y.patch
lib-test_sysctl-support-testing-of-sysctl-boot-parameter.patch
lib-test_sysctl-support-testing-of-sysctl-boot-parameter-fix.patch
