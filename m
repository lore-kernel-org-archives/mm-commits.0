From: akpm@linux-foundation.org
Subject: [merged] tools-memory-hotplug-fix-unexpected-operator-error.patch removed from -mm tree
Date: Mon, 07 Jul 2014 11:11:20 -0700
Message-ID: <53bae2c8.7pYj9wofNUlXanky%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:44587 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaGGSLV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 14:11:21 -0400
Received: by mail-qc0-f201.google.com with SMTP id c9so657293qcz.4
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 11:11:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuah.kh@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools: memory-hotplug fix unexpected operator error
has been removed from the -mm tree.  Its filename was
     tools-memory-hotplug-fix-unexpected-operator-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shuah Khan <shuah.kh@samsung.com>
Subject: tools: memory-hotplug fix unexpected operator error

on-off-test is a bash script and invoked from /bin/sh
This results in the following error:

./on-off-test.sh: 9: [: !=: unexpected operator

Chang Makefile to use bash instead.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memory-hotplug/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/memory-hotplug/Makefile~tools-memory-hotplug-fix-unexpected-operator-error tools/testing/selftests/memory-hotplug/Makefile
--- a/tools/testing/selftests/memory-hotplug/Makefile~tools-memory-hotplug-fix-unexpected-operator-error
+++ a/tools/testing/selftests/memory-hotplug/Makefile
@@ -1,6 +1,6 @@
 all:
 
 run_tests:
-	@/bin/sh ./on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
+	@/bin/bash ./on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
 
 clean:
_

Patches currently in -mm which might be from shuah.kh@samsung.com are


