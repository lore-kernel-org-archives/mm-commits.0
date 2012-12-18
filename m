From: akpm@linux-foundation.org
Subject: [merged] tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:12:23 -0800
Message-ID: <20121218201223.9917D82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:39777 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab2LRUMY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:12:24 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so126534yen.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:12:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, gorcunov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/kcmp/kcmp_test.c: print reason for failure in kcmp_test
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: tools/testing/selftests/kcmp/kcmp_test.c: print reason for failure in kcmp_test

I was curious why sys_kcmp wasn't working, which led me to the testcase. 
It turned out I hadn't enabled CHECKPOINT_RESTORE in the kernel I was
testing.  Add a decoding of errno to the testcase to make that obvious.

Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kcmp/kcmp_test.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/kcmp/kcmp_test.c~tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test tools/testing/selftests/kcmp/kcmp_test.c
--- a/tools/testing/selftests/kcmp/kcmp_test.c~tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test
+++ a/tools/testing/selftests/kcmp/kcmp_test.c
@@ -72,7 +72,8 @@ int main(int argc, char **argv)
 		/* This one should return same fd */
 		ret = sys_kcmp(pid1, pid2, KCMP_FILE, fd1, fd1);
 		if (ret) {
-			printf("FAIL: 0 expected but %d returned\n", ret);
+			printf("FAIL: 0 expected but %d returned (%s)\n",
+				ret, strerror(errno));
 			ret = -1;
 		} else
 			printf("PASS: 0 returned as expected\n");
@@ -80,7 +81,8 @@ int main(int argc, char **argv)
 		/* Compare with self */
 		ret = sys_kcmp(pid1, pid1, KCMP_VM, 0, 0);
 		if (ret) {
-			printf("FAIL: 0 expected but %li returned\n", ret);
+			printf("FAIL: 0 expected but %li returned (%s)\n",
+				ret, strerror(errno));
 			ret = -1;
 		} else
 			printf("PASS: 0 returned as expected\n");
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
linux-next.patch

