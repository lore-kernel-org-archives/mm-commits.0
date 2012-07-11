From: akpm@linux-foundation.org
Subject: + acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch added to -mm tree
Date: Wed, 11 Jul 2012 14:55:21 -0700
Message-ID: <20120711215522.A49F2200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:63768 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360Ab2GKVzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 17:55:25 -0400
Received: by lbbgp10 with SMTP id gp10so103025lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 14:55:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, konrad.wilk@oracle.com, len.brown@intel.com, lenb@kernel.org, rientjes@google.com


The patch titled
     Subject: acpi_memhotplug.c: free memory device if acpi_memory_enable_device() failed
has been added to the -mm tree.  Its filename is
     acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch

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
Subject: acpi_memhotplug.c: free memory device if acpi_memory_enable_device() failed

If acpi_memory_enable_device() fails, acpi_memory_enable_device() will
return a non-zero value, which means we fail to bind the memory device to
this driver.  So we should free memory device before
acpi_memory_device_add() returns.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/acpi_memhotplug.c~acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed drivers/acpi/acpi_memhotplug.c
--- a/drivers/acpi/acpi_memhotplug.c~acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -478,9 +478,11 @@ static int acpi_memory_device_add(struct
 	if (!acpi_memory_check_device(mem_device)) {
 		/* call add_memory func */
 		result = acpi_memory_enable_device(mem_device);
-		if (result)
+		if (result) {
 			printk(KERN_ERR PREFIX
 				"Error in acpi_memory_enable_device\n");
+			acpi_memory_device_free(mem_device);
+		}
 	}
 	return result;
 }
_
Subject: Subject: acpi_memhotplug.c: free memory device if acpi_memory_enable_device() failed

Patches currently in -mm which might be from wency@cn.fujitsu.com are

mm-memory_hotplugc-release-memory-resources-if-hotadd_new_pgdat-fails.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch

