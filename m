From: akpm@linux-foundation.org
Subject: - make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:33:22 -0700
Message-ID: <200707132233.l6DMXMGB025074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52220 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932929AbXGMWpF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:45:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Make usb-autosuspend timer 1 sec jiffy aligned
has been removed from the -mm tree.  Its filename was
     make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make usb-autosuspend timer 1 sec jiffy aligned
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Make usb autosuspend timers 1sec jiffy aligned.

This helps to reduce the frequency at which the CPU must be taken out of a
lower-power state.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/driver.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/core/driver.c~make-usb-autosuspend-timer-1-sec-jiffy-aligned drivers/usb/core/driver.c
--- a/drivers/usb/core/driver.c~make-usb-autosuspend-timer-1-sec-jiffy-aligned
+++ a/drivers/usb/core/driver.c
@@ -1010,7 +1010,7 @@ static int autosuspend_check(struct usb_
 			 * or for the past.
 			 */
 			queue_delayed_work(ksuspend_usb_wq, &udev->autosuspend,
-					suspend_time - jiffies);
+				round_jiffies_relative(suspend_time - jiffies));
 			}
 		return -EAGAIN;
 	}
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

origin.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
git-cpufreq.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
x86_64-convert-to-cleckevents.patch
x86_64-block-irq-balancing-for-timer.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
