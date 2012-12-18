From: akpm@linux-foundation.org
Subject: [merged] kcmp-selftests-print-fail-status-instead-of-cause-make-error.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:12:17 -0800
Message-ID: <20121218201217.A82BD100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:62011 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab2LRUMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:12:18 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so126446yen.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:12:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dyoung@redhat.com, gorcunov@openvz.org, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kcmp selftests: print fail status instead of cause make error
has been removed from the -mm tree.  Its filename was
     kcmp-selftests-print-fail-status-instead-of-cause-make-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

