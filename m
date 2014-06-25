From: akpm@linux-foundation.org
Subject: + tools-memory-hotplug-fix-unexpected-operator-error.patch added
 to -mm tree
Date: Wed, 25 Jun 2014 14:36:57 -0700
Message-ID: <53ab40f9.HI+tUmg5x3ThgETy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbaFYVg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 17:36:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuah.kh@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools: memory-hotplug fix unexpected operator error
has been added to the -mm tree.  Its filename is
     tools-memory-hotplug-fix-unexpected-operator-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-memory-hotplug-fix-unexpected-operator-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-memory-hotplug-fix-unexpected-operator-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tools-cpu-hotplug-fix-unexpected-operator-error.patch
tools-memory-hotplug-fix-unexpected-operator-error.patch

