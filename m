From: akpm@linux-foundation.org
Subject: [wrecked] acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch removed from -mm tree
Date: Mon, 05 Nov 2012 11:36:42 -0800
Message-ID: <20121105193643.2896C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:37211 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab2KETgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 14:36:46 -0500
Received: by mail-we0-f202.google.com with SMTP id x43so402597wey.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 11:36:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, konrad.wilk@oracle.com, len.brown@intel.com, lenb@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: acpi_memhotplug.c: don't allow to eject the memory device if it is being used
has been removed from the -mm tree.  Its filename was
     acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch

This patch was dropped because other changes were merged, which wrecked this patch

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

Patches currently in -mm which might be from wency@cn.fujitsu.com are

linux-next.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
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

