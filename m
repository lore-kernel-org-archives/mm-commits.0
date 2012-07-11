From: akpm@linux-foundation.org
Subject: + acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch added to -mm tree
Date: Wed, 11 Jul 2012 14:55:29 -0700
Message-ID: <20120711215530.63C6B1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:46357 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933330Ab2GKVzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 17:55:32 -0400
Received: by yenl3 with SMTP id l3so173350yen.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 14:55:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, konrad.wilk@oracle.com, len.brown@intel.com, lenb@kernel.org, rientjes@google.com


The patch titled
     Subject: acpi_memhotplug.c: don't allow to eject the memory device if it is being used
has been added to the -mm tree.  Its filename is
     acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch

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
Subject: acpi_memhotplug.c: don't allow to eject the memory device if it is being used

We eject the memory device even if it is in use.  It is very dangerous,
and it will cause the kernel to panic.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |   38 +++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff -puN drivers/acpi/acpi_memhotplug.c~acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used drivers/acpi/acpi_memhotplug.c
--- a/drivers/acpi/acpi_memhotplug.c~acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -78,6 +78,7 @@ struct acpi_memory_info {
 	unsigned short caching;	/* memory cache attribute */
 	unsigned short write_protect;	/* memory read/write attribute */
 	unsigned int enabled:1;
+	unsigned int failed:1;
 };
 
 struct acpi_memory_device {
@@ -257,9 +258,23 @@ static int acpi_memory_enable_device(str
 			node = memory_add_physaddr_to_nid(info->start_addr);
 
 		result = add_memory(node, info->start_addr, info->length);
-		if (result)
+
+		/*
+		 * If the memory block has been used by the kernel, add_memory()
+		 * returns -EEXIST. If add_memory() returns the other error, it
+		 * means that this memory block is not used by the kernel.
+		 */
+		if (result && result != -EEXIST) {
+			info->failed = 1;
 			continue;
-		info->enabled = 1;
+		}
+
+		if (!result)
+			info->enabled = 1;
+		/*
+		 * Add num_enable even if add_memory() returns -EEXIST, so the
+		 * device is bound to this driver.
+		 */
 		num_enabled++;
 	}
 	if (!num_enabled) {
@@ -323,11 +338,20 @@ static int acpi_memory_disable_device(st
 	 * Note: Assume that this function returns zero on success
 	 */
 	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
-		if (info->enabled) {
-			result = remove_memory(info->start_addr, info->length);
-			if (result)
-				return result;
-		}
+		if (info->failed)
+			/* The kernel does not use this memory block */
+			continue;
+
+		if (!info->enabled)
+			/*
+			 * The kernel uses this memory block, but it may be not
+			 * managed by us.
+			 */
+			return -EBUSY;
+
+		result = remove_memory(info->start_addr, info->length);
+		if (result)
+			return result;
 		list_del(&info->list);
 		kfree(info);
 	}
_
Subject: Subject: acpi_memhotplug.c: don't allow to eject the memory device if it is being used

Patches currently in -mm which might be from wency@cn.fujitsu.com are

mm-memory_hotplugc-release-memory-resources-if-hotadd_new_pgdat-fails.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch

