From: akpm@osdl.org
Subject: + exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch added to -mm tree
Date: Fri, 05 Jan 2007 11:37:32 -0800
Message-ID: <200701051937.l05JbWdg030167@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54343 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422699AbXAETiJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 14:38:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trenn@suse.de, lenb@kernel.org


The patch titled
     Exit ACPI processor module gracefully if acpi is disabled
has been added to the -mm tree.  Its filename is
     exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Exit ACPI processor module gracefully if acpi is disabled
From: Thomas Renninger <trenn@suse.de>

Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/processor_core.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/processor_core.c~exit-acpi-processor-module-gracefully-if-acpi-is-disabled drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~exit-acpi-processor-module-gracefully-if-acpi-is-disabled
+++ a/drivers/acpi/processor_core.c
@@ -890,6 +890,8 @@ void acpi_processor_uninstall_hotplug_no
  * ACPI, but needs symbols from this driver
  */
 
+static int processor_driver_registered = 0;
+
 static int __init acpi_processor_init(void)
 {
 	int result = 0;
@@ -909,6 +911,8 @@ static int __init acpi_processor_init(vo
 		return result;
 	}
 
+	processor_driver_registered = 1;
+
 	acpi_processor_install_hotplug_notify();
 
 	acpi_thermal_cpufreq_init();
@@ -925,12 +929,13 @@ static void __exit acpi_processor_exit(v
 
 	acpi_thermal_cpufreq_exit();
 
+	if (processor_driver_registered){
 	acpi_processor_uninstall_hotplug_notify();
 
 	acpi_bus_unregister_driver(&acpi_processor_driver);
 
 	remove_proc_entry(ACPI_PROCESSOR_CLASS, acpi_root_dir);
-
+	}
 	return;
 }
 
_

Patches currently in -mm which might be from trenn@suse.de are

exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch
