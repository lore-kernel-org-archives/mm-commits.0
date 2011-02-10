From: akpm@linux-foundation.org
Subject: + init-calibratec-fix-jiffy-calculations-in-calibrate_delay_direct-to-handle-overflow.patch added to -mm tree
Date: Thu, 10 Feb 2011 13:10:09 -0800
Message-ID: <201102102110.p1ALA94R018765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757082Ab1BJVKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Feb 2011 16:10:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Tim.Deegan@citrix.com, jbeulich@novell.com, jeremy@goop.org, jslaby@suse.cz, stable@kernel.org


The patch titled
     init/calibrate.c: fix jiffy calculations in calibrate_delay_direct to handle overflow
has been added to the -mm tree.  Its filename is
     init-calibratec-fix-jiffy-calculations-in-calibrate_delay_direct-to-handle-overflow.patch

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
Subject: init/calibrate.c: fix jiffy calculations in calibrate_delay_direct to handle overflow
From: Tim Deegan <Tim.Deegan@citrix.com>

Fixes a hang when booting as dom0 under Xen, when jiffies can be quite
large by the time the kernel init gets this far.

[jbeulich@novell.com: !time_after() -> time_before_eq() as suggested by Jiri Slaby]
Signed-off-by: Tim Deegan <Tim.Deegan@citrix.com>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN init/calibrate.c~init-calibratec-fix-jiffy-calculations-in-calibrate_delay_direct-to-handle-overflow init/calibrate.c
--- a/init/calibrate.c~init-calibratec-fix-jiffy-calculations-in-calibrate_delay_direct-to-handle-overflow
+++ a/init/calibrate.c
@@ -66,7 +66,7 @@ static unsigned long __cpuinit calibrate
 		pre_start = 0;
 		read_current_timer(&start);
 		start_jiffies = jiffies;
-		while (jiffies <= (start_jiffies + 1)) {
+		while (time_before_eq(jiffies, start_jiffies + 1)) {
 			pre_start = start;
 			read_current_timer(&start);
 		}
@@ -74,8 +74,8 @@ static unsigned long __cpuinit calibrate
 
 		pre_end = 0;
 		end = post_start;
-		while (jiffies <=
-		       (start_jiffies + 1 + DELAY_CALIBRATION_TICKS)) {
+		while (time_before_eq(jiffies, start_jiffies + 1 +
+					       DELAY_CALIBRATION_TICKS)) {
 			pre_end = end;
 			read_current_timer(&end);
 		}
_

Patches currently in -mm which might be from Tim.Deegan@citrix.com are

init-calibratec-fix-jiffy-calculations-in-calibrate_delay_direct-to-handle-overflow.patch

