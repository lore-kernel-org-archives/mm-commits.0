From: akpm@linux-foundation.org
Subject: [merged] init-calibratec-fix-jiffy-calculations-in-calibrate_delay_direct-to-handle-overflow.patch removed from -mm tree
Date: Fri, 11 Feb 2011 09:18:07 -0800
Message-ID: <201102111718.p1BHI8kG004859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757775Ab1BKRSt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Feb 2011 12:18:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Tim.Deegan@citrix.com, jbeulich@novell.com, jeremy@goop.org, jslaby@suse.cz, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     init/calibrate.c: fix jiffy calculations in calibrate_delay_direct to handle overflow
has been removed from the -mm tree.  Its filename was
     init-calibratec-fix-jiffy-calculations-in-calibrate_delay_direct-to-handle-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

