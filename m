From: akpm@linux-foundation.org
Subject: + acpi-suspend-fix-acpi_sleep-states.patch added to -mm tree
Date: Tue, 25 Sep 2007 10:37:54 -0700
Message-ID: <200709251737.l8PHbstn029058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53268 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbXIYRiP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 13:38:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: astarikovskiy@suse.de, akpm@linux-foundation.org, lenb@kernel.org, rjw@sisk.pl


The patch titled
     ACPI: suspend: fix ACPI_SLEEP states
has been added to the -mm tree.  Its filename is
     acpi-suspend-fix-acpi_sleep-states.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: suspend: fix ACPI_SLEEP states
From: Alexey Starikovskiy <astarikovskiy@suse.de>

Fix for commit f216cc3748a3a22c2b99390fddcdafa0583791a2, allow S5 power-off,
even if ACPI_SLEEP/PM_SLEEP is not selected.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/Makefile |    2 +-
 drivers/acpi/sleep/main.c   |    4 ++++
 include/acpi/acpi_drivers.h |    4 ----
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/acpi/sleep/Makefile~acpi-suspend-fix-acpi_sleep-states drivers/acpi/sleep/Makefile
--- a/drivers/acpi/sleep/Makefile~acpi-suspend-fix-acpi_sleep-states
+++ a/drivers/acpi/sleep/Makefile
@@ -1,5 +1,5 @@
 obj-y					:= wakeup.o
-obj-$(CONFIG_ACPI_SLEEP)		+= main.o
+obj-y					+= main.o
 obj-$(CONFIG_ACPI_SLEEP)		+= proc.o
 
 EXTRA_CFLAGS += $(ACPI_CFLAGS)
diff -puN drivers/acpi/sleep/main.c~acpi-suspend-fix-acpi_sleep-states drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-suspend-fix-acpi_sleep-states
+++ a/drivers/acpi/sleep/main.c
@@ -24,7 +24,9 @@
 
 u8 sleep_states[ACPI_S_STATE_COUNT];
 
+#ifdef CONFIG_PM_SLEEP
 static u32 acpi_target_sleep_state = ACPI_STATE_S0;
+#endif
 
 int acpi_sleep_prepare(u32 acpi_state)
 {
@@ -299,6 +301,7 @@ int acpi_suspend(u32 acpi_state)
 	return -EINVAL;
 }
 
+#ifdef CONFIG_PM_SLEEP
 /**
  *	acpi_pm_device_sleep_state - return preferred power state of ACPI device
  *		in the system sleep state given by %acpi_target_sleep_state
@@ -373,6 +376,7 @@ int acpi_pm_device_sleep_state(struct de
 		*d_min_p = d_min;
 	return d_max;
 }
+#endif
 
 static void acpi_power_off_prepare(void)
 {
diff -puN include/acpi/acpi_drivers.h~acpi-suspend-fix-acpi_sleep-states include/acpi/acpi_drivers.h
--- a/include/acpi/acpi_drivers.h~acpi-suspend-fix-acpi_sleep-states
+++ a/include/acpi/acpi_drivers.h
@@ -147,10 +147,6 @@ static inline void unregister_hotplug_do
 /*--------------------------------------------------------------------------
                                   Suspend/Resume
   -------------------------------------------------------------------------- */
-#ifdef CONFIG_ACPI_SLEEP
 extern int acpi_sleep_init(void);
-#else
-static inline int acpi_sleep_init(void) { return 0; }
-#endif
 
 #endif /*__ACPI_DRIVERS_H__*/
_

Patches currently in -mm which might be from astarikovskiy@suse.de are

acpi-suspend-move-acpi_sleep_prepare-outside-of-config_suspend.patch
acpi-suspend-fix-acpi_sleep-states.patch
git-acpi.patch
acpi-sbs-fix-sbs-add-alarm-patch.patch
