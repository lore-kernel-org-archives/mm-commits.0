From: akpm@linux-foundation.org
Subject: [merged] tools-testing-selftests-fix-uninitialized-variable.patch removed from -mm tree
Date: Thu, 17 Oct 2013 11:13:15 -0700
Message-ID: <526028bb.L6wAH4f1AG7OMuUC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759356Ab3JQSNP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:13:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fweisbec@gmail.com, felipensp@gmail.com

Subject: [merged] tools-testing-selftests-fix-uninitialized-variable.patch removed from -mm tree
To: felipensp@gmail.com,fweisbec@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:13:15 -0700


The patch titled
     Subject: tools/testing/selftests: fix uninitialized variable
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-fix-uninitialized-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Felipe Pena <felipensp@gmail.com>
Subject: tools/testing/selftests: fix uninitialized variable

The err variable is intended to receive the timer_create() return before
checking it

Signed-off-by: Felipe Pena <felipensp@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/timers/posix_timers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/timers/posix_timers.c~tools-testing-selftests-fix-uninitialized-variable tools/testing/selftests/timers/posix_timers.c
--- a/tools/testing/selftests/timers/posix_timers.c~tools-testing-selftests-fix-uninitialized-variable
+++ a/tools/testing/selftests/timers/posix_timers.c
@@ -151,7 +151,7 @@ static int check_timer_create(int which)
 	fflush(stdout);
 
 	done = 0;
-	timer_create(which, NULL, &id);
+	err = timer_create(which, NULL, &id);
 	if (err < 0) {
 		perror("Can't create timer\n");
 		return -1;
_

Patches currently in -mm which might be from felipensp@gmail.com are

origin.patch

