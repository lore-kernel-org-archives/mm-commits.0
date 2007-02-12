From: akpm@linux-foundation.org
Subject: - ds1302-local_irq_disable-is-redundant-after-local_irq_save.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:44:31 -0800
Message-ID: <200702122244.l1CMiVaF013610@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030266AbXBLWog (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:44:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     DS1302: local_irq_disable() is redundant after local_irq_save()
has been removed from the -mm tree.  Its filename was
     ds1302-local_irq_disable-is-redundant-after-local_irq_save.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: DS1302: local_irq_disable() is redundant after local_irq_save()
From: Jiri Kosina <jkosina@suse.cz>

drivers/char/ds1302.c::get_rtc_time() contains local_irq_disable() call
after local_irq_save(). This looks redundant.

drivers/char/ds1302.c::rtc_ioctl() contains local_irq_disable() call after
local_irq_save(). This looks redundant.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ds1302.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/char/ds1302.c~ds1302-local_irq_disable-is-redundant-after-local_irq_save drivers/char/ds1302.c
--- a/drivers/char/ds1302.c~ds1302-local_irq_disable-is-redundant-after-local_irq_save
+++ a/drivers/char/ds1302.c
@@ -120,7 +120,6 @@ get_rtc_time(struct rtc_time *rtc_tm)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	local_irq_disable();
 
 	rtc_tm->tm_sec = CMOS_READ(RTC_SECONDS);
 	rtc_tm->tm_min = CMOS_READ(RTC_MINUTES);
@@ -219,7 +218,6 @@ rtc_ioctl(struct inode *inode, struct fi
 			BIN_TO_BCD(yrs);
 
 			local_irq_save(flags);
-			local_irq_disable();
 			CMOS_WRITE(yrs, RTC_YEAR);
 			CMOS_WRITE(mon, RTC_MONTH);
 			CMOS_WRITE(day, RTC_DAY_OF_MONTH);
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
git-alsa.patch
git-hid.patch
git-ipwireless_cs.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
