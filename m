From: akpm@linux-foundation.org
Subject: + tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch added to -mm tree
Date: Thu, 18 Oct 2012 14:36:35 -0700
Message-ID: <20121018213635.A01B6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:57026 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab2JRVgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 17:36:36 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so275082qae.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 14:36:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, gorcunov@openvz.org


The patch titled
     Subject: tools/testing/selftests/kcmp/kcmp_test.c: print reason for failure in kcmp_test
has been added to the -mm tree.  Its filename is
     tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-mempolicy-avoid-taking-mutex-inside-spinlock-when-reading-numa_maps.patch
linux-next.patch
selinux-fix-sel_netnode_insert-suspicious-rcu-dereference.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

