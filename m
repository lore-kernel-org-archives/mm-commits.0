From: akpm@linux-foundation.org
Subject: + intel_menlow-fix-memory-leaks-in-error-path.patch added to -mm tree
Date: Tue, 25 May 2010 13:38:35 -0700
Message-ID: <201005252038.o4PKcZml013692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106Ab0EYUir (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 16:38:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, len.brown@intel.com, mjg@redhat.com, rui.zhang@intel.com, sujith.thomas@intel.com


The patch titled
     intel_menlow: fix memory leaks in error path
has been added to the -mm tree.  Its filename is
     intel_menlow-fix-memory-leaks-in-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel_menlow: fix memory leaks in error path
From: Axel Lin <axel.lin@gmail.com>

This patch includes below fixes in error path:

1. fix a memory leak if device_create_file failed in
   intel_menlow_add_one_attribute

2. properly free added attributes before return error in
   intel_menlow_register_sensor error handler

3. properly call acpi_bus_unregister_driver before return error in
   intel_menlow_module_init

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/intel_menlow.c |   33 +++++++++++++++++---------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff -puN drivers/platform/x86/intel_menlow.c~intel_menlow-fix-memory-leaks-in-error-path drivers/platform/x86/intel_menlow.c
--- a/drivers/platform/x86/intel_menlow.c~intel_menlow-fix-memory-leaks-in-error-path
+++ a/drivers/platform/x86/intel_menlow.c
@@ -53,6 +53,8 @@ MODULE_LICENSE("GPL");
 #define MEMORY_ARG_CUR_BANDWIDTH 1
 #define MEMORY_ARG_MAX_BANDWIDTH 0
 
+static void intel_menlow_unregister_sensor(void);
+
 /*
  * GTHS returning 'n' would mean that [0,n-1] states are supported
  * In that case max_cstate would be n-1
@@ -406,8 +408,10 @@ static int intel_menlow_add_one_attribut
 	attr->handle = handle;
 
 	result = device_create_file(dev, &attr->attr);
-	if (result)
+	if (result) {
+		kfree(attr);
 		return result;
+	}
 
 	mutex_lock(&intel_menlow_attr_lock);
 	list_add_tail(&attr->node, &intel_menlow_attr_list);
@@ -431,11 +435,11 @@ static acpi_status intel_menlow_register
 	/* _TZ must have the AUX0/1 methods */
 	status = acpi_get_handle(handle, GET_AUX0, &dummy);
 	if (ACPI_FAILURE(status))
-		goto not_found;
+		return (status == AE_NOT_FOUND) ? AE_OK : status;
 
 	status = acpi_get_handle(handle, SET_AUX0, &dummy);
 	if (ACPI_FAILURE(status))
-		goto not_found;
+		return (status == AE_NOT_FOUND) ? AE_OK : status;
 
 	result = intel_menlow_add_one_attribute("aux0", 0644,
 						aux0_show, aux0_store,
@@ -445,17 +449,19 @@ static acpi_status intel_menlow_register
 
 	status = acpi_get_handle(handle, GET_AUX1, &dummy);
 	if (ACPI_FAILURE(status))
-		goto not_found;
+		goto aux1_not_found;
 
 	status = acpi_get_handle(handle, SET_AUX1, &dummy);
 	if (ACPI_FAILURE(status))
-		goto not_found;
+		goto aux1_not_found;
 
 	result = intel_menlow_add_one_attribute("aux1", 0644,
 						aux1_show, aux1_store,
 						&thermal->device, handle);
-	if (result)
+	if (result) {
+		intel_menlow_unregister_sensor();
 		return AE_ERROR;
+	}
 
 	/*
 	 * create the "dabney_enabled" attribute which means the user app
@@ -465,14 +471,17 @@ static acpi_status intel_menlow_register
 	result = intel_menlow_add_one_attribute("bios_enabled", 0444,
 						bios_enabled_show, NULL,
 						&thermal->device, handle);
-	if (result)
+	if (result) {
+		intel_menlow_unregister_sensor();
 		return AE_ERROR;
+	}
 
- not_found:
+ aux1_not_found:
 	if (status == AE_NOT_FOUND)
 		return AE_OK;
-	else
-		return status;
+
+	intel_menlow_unregister_sensor();
+	return status;
 }
 
 static void intel_menlow_unregister_sensor(void)
@@ -513,8 +522,10 @@ static int __init intel_menlow_module_in
 	status = acpi_walk_namespace(ACPI_TYPE_THERMAL, ACPI_ROOT_OBJECT,
 				     ACPI_UINT32_MAX,
 				     intel_menlow_register_sensor, NULL, NULL, NULL);
-	if (ACPI_FAILURE(status))
+	if (ACPI_FAILURE(status)) {
+		acpi_bus_unregister_driver(&intel_menlow_memory_driver);
 		return -ENODEV;
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
intel_menlow-fix-memory-leaks-in-error-path.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
pl061-fix-offset-value-range-checking.patch
max732x-correct-nr_port-checking-off-by-one-error.patch

