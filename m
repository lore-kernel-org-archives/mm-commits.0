From: akpm@linux-foundation.org
Subject: +
 rtc-ds1685-fix-conditional-in-ds1685_rtc_sysfs_time_regs_showstore.patch
 added to -mm tree
Date: Fri, 20 Feb 2015 15:09:43 -0800
Message-ID: <54e7beb7.wztmVPWoHhQRrqER%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbbBTXJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Feb 2015 18:09:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kumba@gentoo.org, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds1685.c: fix conditional in ds1685_rtc_sysfs_time_regs_{show,store}
has been added to the -mm tree.  Its filename is
     rtc-ds1685-fix-conditional-in-ds1685_rtc_sysfs_time_regs_showstore.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-ds1685-fix-conditional-in-ds1685_rtc_sysfs_time_regs_showstore.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-ds1685-fix-conditional-in-ds1685_rtc_sysfs_time_regs_showstore.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joshua Kinard <kumba@gentoo.org>
Subject: drivers/rtc/rtc-ds1685.c: fix conditional in ds1685_rtc_sysfs_time_regs_{show,store}

Fix a conditional statement checking for NULL in both
ds1685_rtc_sysfs_time_regs_show and ds1685_rtc_sysfs_time_regs_store that
was using a logical AND when it should be using a logical OR so that we
fail out of the function properly if the condition ever evaluates to true.

Fixes: aaaf5fbf56f1 ("rtc: add driver for DS1685 family of real time clocks")
Signed-off-by: Joshua Kinard <kumba@gentoo.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1685.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1685.c~rtc-ds1685-fix-conditional-in-ds1685_rtc_sysfs_time_regs_showstore drivers/rtc/rtc-ds1685.c
--- a/drivers/rtc/rtc-ds1685.c~rtc-ds1685-fix-conditional-in-ds1685_rtc_sysfs_time_regs_showstore
+++ a/drivers/rtc/rtc-ds1685.c
@@ -1610,7 +1610,7 @@ ds1685_rtc_sysfs_time_regs_show(struct d
 		ds1685_rtc_sysfs_time_regs_lookup(attr->attr.name, false);
 
 	/* Make sure we actually matched something. */
-	if (!bcd_reg_info && !bin_reg_info)
+	if (!bcd_reg_info || !bin_reg_info)
 		return -EINVAL;
 
 	/* bcd_reg_info->reg == bin_reg_info->reg. */
@@ -1648,7 +1648,7 @@ ds1685_rtc_sysfs_time_regs_store(struct
 		return -EINVAL;
 
 	/* Make sure we actually matched something. */
-	if (!bcd_reg_info && !bin_reg_info)
+	if (!bcd_reg_info || !bin_reg_info)
 		return -EINVAL;
 
 	/* Check for a valid range. */
_

Patches currently in -mm which might be from kumba@gentoo.org are

origin.patch
rtc-ds1685-fix-ds1685_rtc_alarm_irq_enable-build-error.patch
rtc-ds1685-remove-superfluous-checks-for-out-of-range-u8-values.patch
rtc-ds1685-fix-conditional-in-ds1685_rtc_sysfs_time_regs_showstore.patch
mips-ip32-add-platform-data-hooks-to-use-ds1685-driver.patch

