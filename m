From: akpm@linux-foundation.org
Subject: + ds1302-local_irq_disable-is-redundant-after-local_irq_save.patch added to -mm tree
Date: Fri, 09 Feb 2007 15:02:17 -0800
Message-ID: <200702092302.l19N2H7d028706@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53094 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbXBIXCV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 18:02:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz


The patch titled
     DS1302: local_irq_disable() is redundant after local_irq_save()
has been added to the -mm tree.  Its filename is
     ds1302-local_irq_disable-is-redundant-after-local_irq_save.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 deletions(-)

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
git-scsi-misc.patch
git-ipwireless_cs.patch
cris-local_irq_disable-is-redundant-after-local_irq_save.patch
cris-turn-local_save_flags-local_irq_disable-into-local_irq_save-in-headers.patch
cris-tlb-handling-turn-local_save_flags-local_irq_disable.patch
char-amiserial-turn-local_save_flags-local_irq_disable-into-local_irq_save.patch
ds1302-local_irq_disable-is-redundant-after-local_irq_save.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
