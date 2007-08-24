From: akpm@linux-foundation.org
Subject: - enable-gpes-before-calling-_wak-on-resume.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:57:28 -0700
Message-ID: <200708242057.l7OKvS83014223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760181AbXHXVIk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trenn@suse.de, lenb@kernel.org, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     acpi: enable GPEs before calling _WAK on resume
has been removed from the -mm tree.  Its filename was
     enable-gpes-before-calling-_wak-on-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-acpi.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
