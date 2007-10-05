From: akpm@linux-foundation.org
Subject: - exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch removed from -mm tree
Date: Fri, 05 Oct 2007 11:24:57 -0700
Message-ID: <200710051824.l95IOvK3018880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40944 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880AbXJESZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 14:25:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trenn@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Exit ACPI processor module gracefully if acpi is disabled
has been removed from the -mm tree.  Its filename was
     exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch

This patch was dropped because it looks wrong and isn't chagelogged

------------------------------------------------------
Subject: Exit ACPI processor module gracefully if acpi is disabled
From: Thomas Renninger <trenn@suse.de>

akpm: needs a changelog

Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_core.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/acpi/processor_core.c~exit-acpi-processor-module-gracefully-if-acpi-is-disabled drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~exit-acpi-processor-module-gracefully-if-acpi-is-disabled
+++ a/drivers/acpi/processor_core.c
@@ -1030,6 +1030,8 @@ void acpi_processor_uninstall_hotplug_no
  * ACPI, but needs symbols from this driver
  */
 
+static int processor_driver_registered;
+
 static int __init acpi_processor_init(void)
 {
 	int result = 0;
@@ -1055,6 +1057,8 @@ static int __init acpi_processor_init(vo
 		return result;
 	}
 
+	processor_driver_registered = 1;
+
 	acpi_processor_install_hotplug_notify();
 
 	acpi_thermal_cpufreq_init();
@@ -1068,15 +1072,12 @@ static void __exit acpi_processor_exit(v
 {
 
 	acpi_processor_ppc_exit();
-
-	acpi_thermal_cpufreq_exit();
-
-	acpi_processor_uninstall_hotplug_notify();
-
-	acpi_bus_unregister_driver(&acpi_processor_driver);
-
-	remove_proc_entry(ACPI_PROCESSOR_CLASS, acpi_root_dir);
-
+	if (processor_driver_registered) {
+		acpi_thermal_cpufreq_exit();
+		acpi_processor_uninstall_hotplug_notify();
+		acpi_bus_unregister_driver(&acpi_processor_driver);
+		remove_proc_entry(ACPI_PROCESSOR_CLASS, acpi_root_dir);
+	}
 	return;
 }
 
_

Patches currently in -mm which might be from trenn@suse.de are

exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch
git-cpufreq.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
