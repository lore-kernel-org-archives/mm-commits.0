From: akpm@linux-foundation.org
Subject: + rtc-ds1685-fix-ds1685_rtc_alarm_irq_enable-build-error.patch
 added to -mm tree
Date: Wed, 18 Feb 2015 12:14:41 -0800
Message-ID: <54e4f2b1.oV1kYQUjR6SKOFEw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbbBRUOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 15:14:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, a.zummo@towertech.it, kumba@gentoo.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: ds1685: fix ds1685_rtc_alarm_irq_enable build error
has been added to the -mm tree.  Its filename is
     rtc-ds1685-fix-ds1685_rtc_alarm_irq_enable-build-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-ds1685-fix-ds1685_rtc_alarm_irq_enable-build-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-ds1685-fix-ds1685_rtc_alarm_irq_enable-build-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: rtc: ds1685: fix ds1685_rtc_alarm_irq_enable build error

The newly added ds1685 driver causes a build error when enabled without
CONFIG_RTC_INTF_DEV:

drivers/rtc/rtc-ds1685.c:919:22: error: 'ds1685_rtc_alarm_irq_enable' undeclared here (not in a function)
  .alarm_irq_enable = ds1685_rtc_alarm_irq_enable,

Apparently the driver was incorrectly changed to reflect the interface
change from 16380c153a69c ("RTC: Convert rtc drivers to use the
alarm_irq_enable method"), which removed the respective #ifdef from all
other rtc drivers.

This does the same change that was merged for the other drivers before and
removes the #ifdef, allowing the interrupts to be enabled through the
in-kernel rtc interface independent of the existence of /dev/rtc.

Fixes: aaaf5fbf56f ("rtc: add driver for DS1685 family of real time clocks")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Joshua Kinard <kumba@gentoo.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1685.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1685.c~rtc-ds1685-fix-ds1685_rtc_alarm_irq_enable-build-error drivers/rtc/rtc-ds1685.c
--- a/drivers/rtc/rtc-ds1685.c~rtc-ds1685-fix-ds1685_rtc_alarm_irq_enable-build-error
+++ a/drivers/rtc/rtc-ds1685.c
@@ -528,7 +528,6 @@ ds1685_rtc_set_alarm(struct device *dev,
 /* ----------------------------------------------------------------------- */
 /* /dev/rtcX Interface functions */
 
-#ifdef CONFIG_RTC_INTF_DEV
 /**
  * ds1685_rtc_alarm_irq_enable - replaces ioctl() RTC_AIE on/off.
  * @dev: pointer to device structure.
@@ -557,7 +556,6 @@ ds1685_rtc_alarm_irq_enable(struct devic
 
 	return 0;
 }
-#endif
 /* ----------------------------------------------------------------------- */
 
 
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
rtc-ds1685-fix-ds1685_rtc_alarm_irq_enable-build-error.patch
ocfs2-use-64bit-variables-to-track-heartbeat-time.patch
linux-next.patch

