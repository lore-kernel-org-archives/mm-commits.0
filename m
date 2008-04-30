From: akpm@linux-foundation.org
Subject: - powerpc-hotplug-memory-notifications-for-ppc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:51:28 -0700
Message-ID: <200804300551.m3U5pSRR030222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755740AbYD3F5o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:57:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, benh@kernel.crashing.org, michael@ellerman.id.au, paulus@samba.org, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     powerpc: hotplug memory notifications for ppc
has been removed from the -mm tree.  Its filename was
     powerpc-hotplug-memory-notifications-for-ppc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: hotplug memory notifications for ppc
From: Badari Pulavarty <pbadari@us.ibm.com>

Hotplug memory notifier for ppc64.  This gets invoked by writing the
device-node that needs to be removed to /proc/ppc64/ofdt.  We need to adjust
the sections and remove sysfs entries by calling __remove_pages().  Then call
arch specific code to get rid of htab mappings for the section of memory.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Reviewed-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/Makefile         |    1 
 arch/powerpc/platforms/pseries/hotplug-memory.c |   98 ++++++++++++++
 2 files changed, 99 insertions(+)

diff -puN arch/powerpc/platforms/pseries/Makefile~powerpc-hotplug-memory-notifications-for-ppc arch/powerpc/platforms/pseries/Makefile
--- a/arch/powerpc/platforms/pseries/Makefile~powerpc-hotplug-memory-notifications-for-ppc
+++ a/arch/powerpc/platforms/pseries/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_PCI)	+= pci.o pci_dlpar.o
 obj-$(CONFIG_PCI_MSI)	+= msi.o
 
 obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug-cpu.o
+obj-$(CONFIG_MEMORY_HOTPLUG)	+= hotplug-memory.o
 
 obj-$(CONFIG_HVC_CONSOLE)	+= hvconsole.o
 obj-$(CONFIG_HVCS)		+= hvcserver.o
diff -puN /dev/null arch/powerpc/platforms/pseries/hotplug-memory.c
--- /dev/null
+++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -0,0 +1,98 @@
+/*
+ * pseries Memory Hotplug infrastructure.
+ *
+ * Copyright (C) 2008 Badari Pulavarty, IBM Corporation
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/of.h>
+#include <asm/firmware.h>
+#include <asm/machdep.h>
+#include <asm/pSeries_reconfig.h>
+
+static int pseries_remove_memory(struct device_node *np)
+{
+	const char *type;
+	const unsigned int *my_index;
+	const unsigned int *regs;
+	u64 start_pfn, start;
+	struct zone *zone;
+	int ret = -EINVAL;
+
+	/*
+	 * Check to see if we are actually removing memory
+	 */
+	type = of_get_property(np, "device_type", NULL);
+	if (type == NULL || strcmp(type, "memory") != 0)
+		return 0;
+
+	/*
+	 * Find the memory index and size of the removing section
+	 */
+	my_index = of_get_property(np, "ibm,my-drc-index", NULL);
+	if (!my_index)
+		return ret;
+
+	regs = of_get_property(np, "reg", NULL);
+	if (!regs)
+		return ret;
+
+	start_pfn = section_nr_to_pfn(*my_index & 0xffff);
+	zone = page_zone(pfn_to_page(start_pfn));
+
+	/*
+	 * Remove section mappings and sysfs entries for the
+	 * section of the memory we are removing.
+	 *
+	 * NOTE: Ideally, this should be done in generic code like
+	 * remove_memory(). But remove_memory() gets called by writing
+	 * to sysfs "state" file and we can't remove sysfs entries
+	 * while writing to it. So we have to defer it to here.
+	 */
+	ret = __remove_pages(zone, start_pfn, regs[3] >> PAGE_SHIFT);
+	if (ret)
+		return ret;
+
+	/*
+	 * Remove htab bolted mappings for this section of memory
+	 */
+ 	start = (unsigned long)__va(start_pfn << PAGE_SHIFT);
+ 	ret = remove_section_mapping(start, start + regs[3]);
+	return ret;
+}
+
+static int pseries_memory_notifier(struct notifier_block *nb,
+				unsigned long action, void *node)
+{
+	int err = NOTIFY_OK;
+
+	switch (action) {
+	case PSERIES_RECONFIG_ADD:
+		break;
+	case PSERIES_RECONFIG_REMOVE:
+		if (pseries_remove_memory(node))
+			err = NOTIFY_BAD;
+		break;
+	default:
+		err = NOTIFY_DONE;
+		break;
+	}
+	return err;
+}
+
+static struct notifier_block pseries_mem_nb = {
+	.notifier_call = pseries_memory_notifier,
+};
+
+static int __init pseries_memory_hotplug_init(void)
+{
+	if (firmware_has_feature(FW_FEATURE_LPAR))
+		pSeries_reconfig_notifier_register(&pseries_mem_nb);
+
+	return 0;
+}
+machine_device_initcall(pseries, pseries_memory_hotplug_init);
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

origin.patch

