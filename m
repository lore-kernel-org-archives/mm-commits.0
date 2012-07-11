From: akpm@linux-foundation.org
Subject: + acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch added to -mm tree
Date: Wed, 11 Jul 2012 14:55:32 -0700
Message-ID: <20120711215533.21969100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:57885 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323Ab2GKVze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 17:55:34 -0400
Received: by ggeh3 with SMTP id h3so173752gge.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 14:55:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, konrad.wilk@oracle.com, len.brown@intel.com, lenb@kernel.org, rientjes@google.com


The patch titled
     Subject: acpi_memhotplug.c: bind the memory device when the driver is being loaded
has been added to the -mm tree.  Its filename is
     acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch

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
Subject: acpi_memhotplug.c: bind the memory device when the driver is being loaded

We had introduced acpi_hotmem_initialized to avoid strange add_memory fail
message.  But the memory device may not be used by the kernel, and the
device should be bound when the driver is being loaded.  Remove
acpi_hotmem_initialized to allow that the device can be bound when the
driver is being loaded.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN drivers/acpi/acpi_memhotplug.c~acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded drivers/acpi/acpi_memhotplug.c
--- a/drivers/acpi/acpi_memhotplug.c~acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -87,8 +87,6 @@ struct acpi_memory_device {
 	struct list_head res_list;
 };
 
-static int acpi_hotmem_initialized;
-
 static acpi_status
 acpi_memory_get_resource(struct acpi_resource *resource, void *context)
 {
@@ -491,15 +489,6 @@ static int acpi_memory_device_add(struct
 
 	printk(KERN_DEBUG "%s \n", acpi_device_name(device));
 
-	/*
-	 * Early boot code has recognized memory area by EFI/E820.
-	 * If DSDT shows these memory devices on boot, hotplug is not necessary
-	 * for them. So, it just returns until completion of this driver's
-	 * start up.
-	 */
-	if (!acpi_hotmem_initialized)
-		return 0;
