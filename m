From: akpm@linux-foundation.org
Subject: - pm-document-use-of-rtc-in-pm_trace.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:10:56 -0700
Message-ID: <200810182310.m9INAuKP027637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbYJRXLK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     pm: document use of RTC in pm_trace
has been removed from the -mm tree.  Its filename was
     pm-document-use-of-rtc-in-pm_trace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: document use of RTC in pm_trace
From: Frans Pop <elendil@planet.nl>

As pm_trace uses the system's hardware clock to save its magic value,
users of that option should be warned that using this debug option will
result in an incorrect system time after resume.

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/s2ram.txt |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN Documentation/power/s2ram.txt~pm-document-use-of-rtc-in-pm_trace Documentation/power/s2ram.txt
--- a/Documentation/power/s2ram.txt~pm-document-use-of-rtc-in-pm_trace
+++ a/Documentation/power/s2ram.txt
@@ -54,3 +54,21 @@ used to run with "radeonfb" (it's an ATI
 that "radeonfb" simply cannot resume that device - it tries to set the
 PLL's, and it just _hangs_. Using the regular VGA console and letting X
 resume it instead works fine.
+
+NOTE
+====
+pm_trace uses the system's Real Time Clock (RTC) to save the magic number.
+Reason for this is that the RTC is the only reliably available piece of
+hardware during resume operations where a value can be set that will
+survive a reboot.
+
+Consequence is that after a resume (even if it is successful) your system
+clock will have a value corresponding to the magic mumber instead of the
+correct date/time! It is therefore advisable to use a program like ntp-date
+or rdate to reset the correct date/time from an external time source when
+using this trace option.
+
+As the clock keeps ticking it is also essential that the reboot is done
+quickly after the resume failure. The trace option does not use the seconds
+or the low order bits of the minutes of the RTC, but a too long delay will
+corrupt the magic value.
_

Patches currently in -mm which might be from elendil@planet.nl are

origin.patch

