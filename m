From: akpm@linux-foundation.org
Subject: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Date: Fri, 30 Nov 2007 13:53:35 -0800
Message-ID: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56847 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675AbXK3V7w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 16:59:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkml@rtr.ca, abelay@novell.com, lenb@kernel.org, mlord@pobox.com, rjw@sisk.pl, venkatesh.pallipadi@intel.com


The patch titled
     restore missing sysfs max_cstate attr
has been added to the -mm tree.  Its filename is
     restore-missing-sysfs-max_cstate-attr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: restore missing sysfs max_cstate attr
From: Mark Lord <lkml@rtr.ca>

Restore visibility of /sys/module/processor/parameters/max_cstate
for compatibility with kernels prior to 2.6.24.

Signed-off-by: Mark Lord <mlord@pobox.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Adam Belay <abelay@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 acpi/processor_idle.c.orig    |    0 
 drivers/acpi/processor_idle.c |    2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/processor_idle.c~restore-missing-sysfs-max_cstate-attr drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~restore-missing-sysfs-max_cstate-attr
+++ a/drivers/acpi/processor_idle.c
@@ -76,7 +76,7 @@ static void (*pm_idle_save) (void) __rea
 #define PM_TIMER_TICKS_TO_US(p)		(((p) * 1000)/(PM_TIMER_FREQUENCY/1000))
 
 static unsigned int max_cstate __read_mostly = ACPI_PROCESSOR_MAX_POWER;
-module_param(max_cstate, uint, 0000);
+module_param(max_cstate, uint, 0644);
 static unsigned int nocst __read_mostly;
 module_param(nocst, uint, 0000);
 
diff -puN drivers/acpi/processor_idle.c.orig~restore-missing-sysfs-max_cstate-attr drivers/acpi/processor_idle.c.orig
_

Patches currently in -mm which might be from lkml@rtr.ca are

rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
pcie-fix-double-initialization-bug.patch
restore-missing-sysfs-max_cstate-attr.patch
