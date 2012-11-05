From: akpm@linux-foundation.org
Subject: [wrecked] acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch removed from -mm tree
Date: Mon, 05 Nov 2012 11:36:51 -0800
Message-ID: <20121105193651.BCFB8100088@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:52949 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab2KETgx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 14:36:53 -0500
Received: by mail-gh0-f202.google.com with SMTP id z15so713200ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 11:36:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, konrad.wilk@oracle.com, len.brown@intel.com, lenb@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: acpi_memhotplug.c: auto bind the memory device which is hotplugged before the driver is loaded
has been removed from the -mm tree.  Its filename was
     acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch

This patch was dropped because other changes were merged, which wrecked this patch

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

Patches currently in -mm which might be from wency@cn.fujitsu.com are

linux-next.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
documentation-kernel-parameterstxt-update-mem=-options-spec-according-to-its-implementation.patch

