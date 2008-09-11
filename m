From: akpm@linux-foundation.org
Subject: + pm-document-use-of-rtc-in-pm_trace.patch added to -mm tree
Date: Thu, 11 Sep 2008 11:58:09 -0700
Message-ID: <200809111858.m8BIw9UD011180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840AbYIKS6P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Sep 2008 14:58:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elendil@planet.nl


The patch titled
     pm: document use of RTC in pm_trace
has been added to the -mm tree.  Its filename is
     pm-document-use-of-rtc-in-pm_trace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: document use of RTC in pm_trace
From: Frans Pop <elendil@planet.nl>

As pm_trace uses the system's hardware clock to save its magic value,
users of that option should be warned that using this debug option will
result in an incorrect system time after resume.

Signed-off-by: Frans Pop <elendil@planet.nl>
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

e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-checkpatch-fixes.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-fix.patch
e100-adapt-to-the-reworked-pci-pm.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
pm-document-use-of-rtc-in-pm_trace.patch

