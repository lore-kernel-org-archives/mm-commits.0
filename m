From: akpm@linux-foundation.org
Subject: + init-calibratec-remove-annoying-printk.patch added to -mm tree
Date: Tue, 07 Jun 2011 16:20:44 -0700
Message-ID: <201106072320.p57NKi6D001274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142Ab1FGXVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 19:21:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: borislav.petkov@amd.com, amworsley@gmail.com, ext-phil.2.carmody@nokia.com, peterz@infradead.org


The patch titled
     init/calibrate.c: remove annoying printk
has been added to the -mm tree.  Its filename is
     init-calibratec-remove-annoying-printk.patch

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
Subject: init/calibrate.c: remove annoying printk
From: Borislav Petkov <borislav.petkov@amd.com>

Remove calibrate_delay_direct()'s KERN_DEBUG printk related to bogomips
calculation as it appears when booting every core on setups with
'ignore_loglevel' which dmesg people scan for possible issues.  As the
message doesn't show very useful information to the widest audience of
kernel boot message gazers, it should be removed.

Introduced by d2b463135f84d15 ("init/calibrate.c: fix for critical
bogoMIPS intermittent calculation failure").

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andrew Worsley <amworsley@gmail.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN init/calibrate.c~init-calibratec-remove-annoying-printk init/calibrate.c
--- a/init/calibrate.c~init-calibratec-remove-annoying-printk
+++ a/init/calibrate.c
@@ -93,9 +93,6 @@ static unsigned long __cpuinit calibrate
 		 * If the upper limit and lower limit of the timer_rate is
 		 * >= 12.5% apart, redo calibration.
 		 */
-		printk(KERN_DEBUG "calibrate_delay_direct() timer_rate_max=%lu "
-			    "timer_rate_min=%lu pre_start=%lu pre_end=%lu\n",
-			  timer_rate_max, timer_rate_min, pre_start, pre_end);
 		if (start >= post_end)
 			printk(KERN_NOTICE "calibrate_delay_direct() ignoring "
 					"timer_rate as we had a TSC wrap around"
_

Patches currently in -mm which might be from borislav.petkov@amd.com are

init-calibratec-remove-annoying-printk.patch

