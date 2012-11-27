From: akpm@linux-foundation.org
Subject: + kcmp-selftests-print-fail-status-instead-of-cause-make-error.patch added to -mm tree
Date: Tue, 27 Nov 2012 12:42:02 -0800
Message-ID: <20121127204203.8E5F6200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:49044 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab2K0UmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 15:42:05 -0500
Received: by mail-lb0-f202.google.com with SMTP id i15so890190lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 12:42:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dyoung@redhat.com, gorcunov@openvz.org, penberg@kernel.org


The patch titled
     Subject: kcmp selftests: print fail status instead of cause make error
has been added to the -mm tree.  Its filename is
     kcmp-selftests-print-fail-status-instead-of-cause-make-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: kcmp selftests: print fail status instead of cause make error

In case kcmp_test exit non zero value it will cause make error.
Better way is just print the test failure status.

Signed-off-by: Dave Young <dyoung@redhat.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kcmp/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/kcmp/Makefile~kcmp-selftests-print-fail-status-instead-of-cause-make-error tools/testing/selftests/kcmp/Makefile
--- a/tools/testing/selftests/kcmp/Makefile~kcmp-selftests-print-fail-status-instead-of-cause-make-error
+++ a/tools/testing/selftests/kcmp/Makefile
@@ -22,7 +22,7 @@ else
 endif
 
 run_tests: all
-	./kcmp_test
+	@./kcmp_test || echo "kcmp_test: [FAIL]"
 
 clean:
 	rm -fr ./run_test
_

Patches currently in -mm which might be from dyoung@redhat.com are

vm-selftests-print-failure-status-instead-of-cause-make-error.patch
mqueue-selftests-print-failure-status-instead-of-cause-make-error.patch
cpu-hotplug-selftests-print-failure-status-instead-of-cause-make-error.patch
mem-hotplug-selftests-print-failure-status-instead-of-cause-make-error.patch
kcmp-selftests-make-run_tests-fix.patch
kcmp-selftests-print-fail-status-instead-of-cause-make-error.patch
breakpoint-selftests-print-failure-status-instead-of-cause-make-error.patch

