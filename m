From: akpm@linux-foundation.org
Subject: + cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor-fix.patch added to -mm tree
Date: Sat, 22 May 2010 16:21:18 -0400
Message-ID: <201005222322.o4MNMgjV031005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755006Ab0EVXXD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 May 2010 19:23:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@infradead.org, arjan@linux.intel.com, czoccolo@gmail.com, frank.rowand@am.sony.com


The patch titled
     cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor-fix
has been added to the -mm tree.  Its filename is
     cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor-fix
From: Arjan van de Ven <arjan@infradead.org>

Frank Rowand found a bug in the new pattern detector code where
the average value was looked at before the sum of values got divided
by the number of samples.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/menu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpuidle/governors/menu.c~cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor-fix drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor-fix
+++ a/drivers/cpuidle/governors/menu.c
@@ -205,12 +205,12 @@ static void detect_repeating_patterns(st
 	/* first calculate average and standard deviation of the past */
 	for (i = 0; i < INTERVALS; i++)
 		avg += data->intervals[i];
+	avg = avg / INTERVALS;
 
 	/* if the avg is beyond the known next tick, it's worthless */
 	if (avg > data->expected_us)
 		return;
 
-	avg = avg / INTERVALS;
 	for (i = 0; i < INTERVALS; i++)
 		stddev += (data->intervals[i] - avg) *
 			  (data->intervals[i] - avg);
_

Patches currently in -mm which might be from arjan@infradead.org are

origin.patch
linux-next.patch
timer-add-on-stack-deferrable-timer-interfaces.patch
x86-platform-driver-intelligent-power-sharing-driver.patch
cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor-fix.patch

