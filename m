From: akpm@linux-foundation.org
Subject: [merged] tools-cpu-hotplug-fix-unexpected-operator-error.patch
 removed from -mm tree
Date: Mon, 07 Jul 2014 11:11:18 -0700
Message-ID: <53bae2c6.QhvdR0wI0HN5WbiX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:58604 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaGGSQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 14:16:39 -0400
Received: by mail-ie0-f201.google.com with SMTP id rl12so576290iec.2
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 11:16:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuah.kh@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools: cpu-hotplug fix unexpected operator error
has been removed from the -mm tree.  Its filename was
     tools-cpu-hotplug-fix-unexpected-operator-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shuah Khan <shuah.kh@samsung.com>
Subject: tools: cpu-hotplug fix unexpected operator error

on-off-test is a bash script and invoked from /bin/sh
This results in the following error:

./on-off-test.sh: 9: [: !=: unexpected operator

Chang Makefile to use bash instead.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cpu-hotplug/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/cpu-hotplug/Makefile~tools-cpu-hotplug-fix-unexpected-operator-error tools/testing/selftests/cpu-hotplug/Makefile
--- a/tools/testing/selftests/cpu-hotplug/Makefile~tools-cpu-hotplug-fix-unexpected-operator-error
+++ a/tools/testing/selftests/cpu-hotplug/Makefile
@@ -1,6 +1,6 @@
 all:
 
 run_tests:
-	@/bin/sh ./on-off-test.sh || echo "cpu-hotplug selftests: [FAIL]"
+	@/bin/bash ./on-off-test.sh || echo "cpu-hotplug selftests: [FAIL]"
 
 clean:
_

Patches currently in -mm which might be from shuah.kh@samsung.com are


