From: akpm@linux-foundation.org
Subject: [merged] breakpoint-selftests-print-failure-status-instead-of-cause-make-error.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:12:20 -0800
Message-ID: <20121218201220.989ED82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:48188 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab2LRUMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:12:21 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so126392ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:12:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dyoung@redhat.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: breakpoint selftests: print failure status instead of cause make error
has been removed from the -mm tree.  Its filename was
     breakpoint-selftests-print-failure-status-instead-of-cause-make-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: breakpoint selftests: print failure status instead of cause make error

In case breakpoint test exit non zero value it will cause make error.
Better way is just print the test failure status.

Signed-off-by: Dave Young <dyoung@redhat.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/breakpoints/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/breakpoints/Makefile~breakpoint-selftests-print-failure-status-instead-of-cause-make-error tools/testing/selftests/breakpoints/Makefile
--- a/tools/testing/selftests/breakpoints/Makefile~breakpoint-selftests-print-failure-status-instead-of-cause-make-error
+++ a/tools/testing/selftests/breakpoints/Makefile
@@ -17,7 +17,7 @@ else
 endif
 
 run_tests:
-	./breakpoint_test
+	@./breakpoint_test || echo "breakpoints selftests: [FAIL]"
 
 clean:
 	rm -fr breakpoint_test
_

Patches currently in -mm which might be from dyoung@redhat.com are

origin.patch

