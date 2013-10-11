From: akpm@linux-foundation.org
Subject: + tools-testing-selftests-fix-uninitialized-variable.patch added
 to -mm tree
Date: Fri, 11 Oct 2013 11:38:15 -0700
Message-ID: <52584597.cuZWWvJij2JTsbqx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3JKSiQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Oct 2013 14:38:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fweisbec@gmail.com, felipensp@gmail.com

Subject: + tools-testing-selftests-fix-uninitialized-variable.patch added to -mm tree
To: felipensp@gmail.com,fweisbec@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 11 Oct 2013 11:38:15 -0700


The patch titled
     Subject: tools/testing/selftests: fix uninitialized variable
has been added to the -mm tree.  Its filename is
     tools-testing-selftests-fix-uninitialized-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-testing-selftests-fix-uninitialized-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-testing-selftests-fix-uninitialized-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tools-testing-selftests-fix-uninitialized-variable.patch

