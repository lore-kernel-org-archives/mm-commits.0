From: akpm@linux-foundation.org
Subject: + acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch added to -mm tree
Date: Wed, 11 Jul 2012 14:55:35 -0700
Message-ID: <20120711215536.BB3105C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:63768 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030285Ab2GKVzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 17:55:39 -0400
Received: by mail-lb0-f202.google.com with SMTP id gp10so103025lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 14:55:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, konrad.wilk@oracle.com, len.brown@intel.com, lenb@kernel.org, rientjes@google.com


The patch titled
     Subject: acpi_memhotplug.c: auto bind the memory device which is hotplugged before the driver is loaded
has been added to the -mm tree.  Its filename is
     acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: acpi_memhotplug.c: auto bind the memory device which is hotplugged before the driver is loaded

If the memory device is hotplugged before the driver is loaded, the user
cannot see this device under the directory /sys/bus/acpi/devices/, and the
user cannot bind it by hand after the driver is loaded.  This patch
introduces a new feature to bind such device when the driver is being
loaded.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |   37 ++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/acpi_memhotplug.c~acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded drivers/acpi/acpi_memhotplug.c
--- a/drivers/acpi/acpi_memhotplug.c~acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -52,6 +52,9 @@ MODULE_LICENSE("GPL");
 #define MEMORY_POWER_ON_STATE	1
 #define MEMORY_POWER_OFF_STATE	2
 
+static bool auto_probe;
+module_param(auto_probe, bool, S_IRUGO | S_IWUSR);
+
 static int acpi_memory_device_add(struct acpi_device *device);
 static int acpi_memory_device_remove(struct acpi_device *device, int type);
 
@@ -543,12 +546,44 @@ acpi_memory_register_notify_handler(acpi
 				    u32 level, void *ctxt, void **retv)
 {
 	acpi_status status;
-
+	struct acpi_memory_device *mem_device = NULL;
+	unsigned long long current_status;
 
 	status = is_memory_device(handle);
 	if (ACPI_FAILURE(status))
 		return AE_OK;	/* continue */
 
+	if (auto_probe) {
+		/* Get device present/absent information from the _STA */
+		status = acpi_evaluate_integer(handle, "_STA", NULL,
+					       &current_status);
+		if (ACPI_FAILURE(status))
+			goto install;
+
+		/*
+		 * Check for device status. Device should be
+		 * present/enabled/functioning.
+		 */
+		if (!(current_status &
+		      (ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED |
+		       ACPI_STA_DEVICE_FUNCTIONING)))
+			goto install;
+
+		if (acpi_memory_get_device(handle, &mem_device))
+			goto install;
+
+		/* We have bound this device while we register the driver */
+		if (mem_device->state == MEMORY_POWER_ON_STATE)
+			goto install;
+
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				  "\nauto probe memory device\n"));
+
+		if (acpi_memory_enable_device(mem_device))
+			pr_err(PREFIX "Cannot enable memory device\n");
+	}
+
+install:
 	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 					     acpi_memory_device_notify, NULL);
 	/* continue */
_
Subject: Subject: acpi_memhotplug.c: auto bind the memory device which is hotplugged before the driver is loaded

Patches currently in -mm which might be from wency@cn.fujitsu.com are

mm-memory_hotplugc-release-memory-resources-if-hotadd_new_pgdat-fails.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch

