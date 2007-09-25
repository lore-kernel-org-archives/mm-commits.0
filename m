From: akpm@linux-foundation.org
Subject: + acpi-suspend-move-acpi_sleep_prepare-outside-of-config_suspend.patch added to -mm tree
Date: Tue, 25 Sep 2007 10:37:52 -0700
Message-ID: <200709251737.l8PHbqhb029053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47117 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394AbXIYRiP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 13:38:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: astarikovskiy@suse.de, akpm@linux-foundation.org, lenb@kernel.org, rjw@sisk.pl


The patch titled
     ACPI: suspend: move acpi_sleep_prepare outside of CONFIG_SUSPEND
has been added to the -mm tree.  Its filename is
     acpi-suspend-move-acpi_sleep_prepare-outside-of-config_suspend.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: suspend: move acpi_sleep_prepare outside of CONFIG_SUSPEND
From: Alexey Starikovskiy <astarikovskiy@suse.de>

Fix for commit f216cc3748a3a22c2b99390fddcdafa0583791a2, breaking builds with
CONFIG_SUSPEND unset.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |   42 ++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff -puN drivers/acpi/sleep/main.c~acpi-suspend-move-acpi_sleep_prepare-outside-of-config_suspend drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-suspend-move-acpi_sleep_prepare-outside-of-config_suspend
+++ a/drivers/acpi/sleep/main.c
@@ -26,6 +26,27 @@ u8 sleep_states[ACPI_S_STATE_COUNT];
 
 static u32 acpi_target_sleep_state = ACPI_STATE_S0;
 
+int acpi_sleep_prepare(u32 acpi_state)
+{
+#ifdef CONFIG_ACPI_SLEEP
+	/* do we have a wakeup address for S2 and S3? */
+	if (acpi_state == ACPI_STATE_S3) {
+		if (!acpi_wakeup_address) {
+			return -EFAULT;
+		}
+		acpi_set_firmware_waking_vector((acpi_physical_address)
+						virt_to_phys((void *)
+							     acpi_wakeup_address));
+
+	}
+	ACPI_FLUSH_CPU_CACHE();
+	acpi_enable_wakeup_device_prep(acpi_state);
+#endif
+	acpi_gpe_sleep_prepare(acpi_state);
+	acpi_enter_sleep_state_prep(acpi_state);
+	return 0;
+}
+
 #ifdef CONFIG_SUSPEND
 static struct pm_ops acpi_pm_ops;
 
@@ -60,27 +81,6 @@ static int acpi_pm_set_target(suspend_st
 	return error;
 }
 
-int acpi_sleep_prepare(u32 acpi_state)
-{
-#ifdef CONFIG_ACPI_SLEEP
-	/* do we have a wakeup address for S2 and S3? */
-	if (acpi_state == ACPI_STATE_S3) {
-		if (!acpi_wakeup_address) {
-			return -EFAULT;
-		}
-		acpi_set_firmware_waking_vector((acpi_physical_address)
-						virt_to_phys((void *)
-							     acpi_wakeup_address));
-
-	}
-	ACPI_FLUSH_CPU_CACHE();
-	acpi_enable_wakeup_device_prep(acpi_state);
-#endif
-	acpi_gpe_sleep_prepare(acpi_state);
-	acpi_enter_sleep_state_prep(acpi_state);
-	return 0;
-}
-
 /**
  *	acpi_pm_prepare - Do preliminary suspend work.
  *	@pm_state: ignored
_

Patches currently in -mm which might be from astarikovskiy@suse.de are

acpi-suspend-move-acpi_sleep_prepare-outside-of-config_suspend.patch
acpi-suspend-fix-acpi_sleep-states.patch
git-acpi.patch
acpi-sbs-fix-sbs-add-alarm-patch.patch
