From: akpm@linux-foundation.org
Subject: + make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch added to -mm tree
Date: Wed, 30 May 2007 11:00:20 -0700
Message-ID: <200705301800.l4UI0KLW001190@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbXE3SAX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 14:00:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, greg@kroah.com


The patch titled
     Make usb-autosuspend timer 1 sec jiffy aligned
has been added to the -mm tree.  Its filename is
     make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -982,7 +982,7 @@ static int autosuspend_check(struct usb_
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

make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
make-mce-polling-timers-1-sec-jiffy-aligned.patch
