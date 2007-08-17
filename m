From: akpm@linux-foundation.org
Subject: + enable-gpes-before-calling-_wak-on-resume.patch added to -mm tree
Date: Fri, 17 Aug 2007 13:36:38 -0700
Message-ID: <200708172036.l7HKacS7028326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58576 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760696AbXHQUh2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 16:37:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trenn@suse.de, akpm@linux-foundation.org, lenb@kernel.org, rjw@sisk.pl


The patch titled
     acpi: enable GPEs before calling _WAK on resume
has been added to the -mm tree.  Its filename is
     enable-gpes-before-calling-_wak-on-resume.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi: enable GPEs before calling _WAK on resume
From: Thomas Renninger <trenn@suse.de>

It seems it's required to enable GPEs before _WAK.  E.g.  X60 triggers a
LID related GPE instead of doing a Notify in WAK.  Now the GPE reaches the
kernel and the Notify for LID status change gets thrown from there.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/hardware/hwsleep.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/acpi/hardware/hwsleep.c~enable-gpes-before-calling-_wak-on-resume drivers/acpi/hardware/hwsleep.c
--- a/drivers/acpi/hardware/hwsleep.c~enable-gpes-before-calling-_wak-on-resume
+++ a/drivers/acpi/hardware/hwsleep.c
@@ -576,13 +576,10 @@ acpi_status acpi_leave_sleep_state(u8 sl
 		ACPI_EXCEPTION((AE_INFO, status, "During Method _BFS"));
 	}
 
-	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		ACPI_EXCEPTION((AE_INFO, status, "During Method _WAK"));
-	}
-	/* TBD: _WAK "sometimes" returns stuff - do we want to look at it? */
-
 	/*
+	 * GPEs must be enabled before _WAK is called as GPEs
+	 * might get fired there
+	 *
 	 * Restore the GPEs:
 	 * 1) Disable/Clear all GPEs
 	 * 2) Enable all runtime GPEs
@@ -591,13 +588,19 @@ acpi_status acpi_leave_sleep_state(u8 sl
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
 	}
-	acpi_gbl_system_awake_and_running = TRUE;
-
 	status = acpi_hw_enable_all_runtime_gpes();
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
 	}
 
+	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+		ACPI_EXCEPTION((AE_INFO, status, "During Method _WAK"));
+	}
+	/* TBD: _WAK "sometimes" returns stuff - do we want to look at it? */
+
+	acpi_gbl_system_awake_and_running = TRUE;
+
 	/* Enable power button */
 
 	(void)
_

Patches currently in -mm which might be from trenn@suse.de are

exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch
enable-gpes-before-calling-_wak-on-resume.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
