From: akpm@linux-foundation.org
Subject: + acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch added to -mm tree
Date: Wed, 11 Jul 2012 14:55:18 -0700
Message-ID: <20120711215519.2B50E10004A@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:33555 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab2GKVzU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 17:55:20 -0400
Received: by vbnl22 with SMTP id l22so173362vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 14:55:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, konrad.wilk@oracle.com, len.brown@intel.com, lenb@kernel.org, rientjes@google.com


The patch titled
     Subject: acpi_memhotplug.c: fix memory leak when memory device is unbound from the module acpi_memhotplug
has been added to the -mm tree.  Its filename is
     acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch

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
Subject: acpi_memhotplug.c: fix memory leak when memory device is unbound from the module acpi_memhotplug

We allocate memory to store acpi_memory_info, so we should free it before
freeing mem_device.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff -puN drivers/acpi/acpi_memhotplug.c~acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug drivers/acpi/acpi_memhotplug.c
--- a/drivers/acpi/acpi_memhotplug.c~acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -125,12 +125,20 @@ acpi_memory_get_resource(struct acpi_res
 	return AE_OK;
 }
 
+static void
+acpi_memory_free_device_resources(struct acpi_memory_device *mem_device)
+{
+	struct acpi_memory_info *info, *n;
+
+	list_for_each_entry_safe(info, n, &mem_device->res_list, list)
+		kfree(info);
+	INIT_LIST_HEAD(&mem_device->res_list);
+}
+
 static int
 acpi_memory_get_device_resources(struct acpi_memory_device *mem_device)
 {
 	acpi_status status;
-	struct acpi_memory_info *info, *n;
-
 
 	if (!list_empty(&mem_device->res_list))
 		return 0;
@@ -138,9 +146,7 @@ acpi_memory_get_device_resources(struct 
 	status = acpi_walk_resources(mem_device->device->handle, METHOD_NAME__CRS,
 				     acpi_memory_get_resource, mem_device);
 	if (ACPI_FAILURE(status)) {
-		list_for_each_entry_safe(info, n, &mem_device->res_list, list)
-			kfree(info);
-		INIT_LIST_HEAD(&mem_device->res_list);
+		acpi_memory_free_device_resources(mem_device);
 		return -EINVAL;
 	}
 
@@ -420,6 +426,15 @@ static void acpi_memory_device_notify(ac
 	return;
 }
 
+static void acpi_memory_device_free(struct acpi_memory_device *mem_device)
+{
+	if (!mem_device)
+		return;
+
+	acpi_memory_free_device_resources(mem_device);
+	kfree(mem_device);
+}
+
 static int acpi_memory_device_add(struct acpi_device *device)
 {
 	int result;
@@ -472,14 +487,10 @@ static int acpi_memory_device_add(struct
 
 static int acpi_memory_device_remove(struct acpi_device *device, int type)
 {
-	struct acpi_memory_device *mem_device = NULL;
-
