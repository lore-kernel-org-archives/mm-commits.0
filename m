From: akpm@linux-foundation.org
Subject: + drivers-rtc-remove-unneeded-ifdef-config_pm.patch added to -mm tree
Date: Wed, 21 Jul 2010 14:16:09 -0700
Message-ID: <201007212116.o6LLG9RN015690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143Ab0GUVQy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 17:16:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qy03fugy@stud.informatik.uni-erlangen.de, a.zummo@towertech.it, mcuos.com@gmail.com


The patch titled
     drivers/rtc: remove unneeded ifdef CONFIG_PM
has been added to the -mm tree.  Its filename is
     drivers-rtc-remove-unneeded-ifdef-config_pm.patch

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
Subject: drivers/rtc: remove unneeded ifdef CONFIG_PM
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>

Because CONFIG_PM is a precondition to CONFIG_ACPI, the ifdef CONFIG_PM
within ifdef CONFIG_ACPI is redundant.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Acked-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-remove-unneeded-ifdef-config_pm drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-remove-unneeded-ifdef-config_pm
+++ a/drivers/rtc/rtc-cmos.c
@@ -970,7 +970,6 @@ static inline int cmos_poweroff(struct d
 
 #include <linux/acpi.h>
 
-#ifdef	CONFIG_PM
 static u32 rtc_handler(void *context)
 {
 	acpi_clear_event(ACPI_EVENT_RTC);
@@ -999,11 +998,6 @@ static void rtc_wake_off(struct device *
 {
 	acpi_disable_event(ACPI_EVENT_RTC, 0);
 }
-#else
-#define rtc_wake_setup()	do{}while(0)
-#define rtc_wake_on		NULL
-#define rtc_wake_off		NULL
-#endif
 
 /* Every ACPI platform has a mc146818 compatible "cmos rtc".  Here we find
  * its device node and pass extra config data.  This helps its driver use
_

Patches currently in -mm which might be from qy03fugy@stud.informatik.uni-erlangen.de are

drivers-rtc-remove-unneeded-ifdef-config_pm.patch

