From: akpm@linux-foundation.org
Subject: + of-fdt-mark-hotpluggable-memory.patch added to -mm tree
Date: Mon, 14 Nov 2016 15:05:16 -0800
Message-ID: <582a432c.aXZlmIG3RneIeqMT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56930 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939765AbcKNXFS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 18:05:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, aneesh.kumar@linux.vnet.ibm.com, apopple@au1.ibm.com, benh@kernel.crashing.org, bharata@linux.vnet.ibm.com, bsingharora@gmail.com, frowand.list@gmail.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, nfont@linux.vnet.ibm.com, paulus@samba.org, robh+dt@kernel.org, stewart@linux.vnet.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: of/fdt: mark hotpluggable memory
has been added to the -mm tree.  Its filename is
     of-fdt-mark-hotpluggable-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/of-fdt-mark-hotpluggable-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/of-fdt-mark-hotpluggable-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Reza Arbab <arbab@linux.vnet.ibm.com>
Subject: of/fdt: mark hotpluggable memory

When movable nodes are enabled, any node containing only hotpluggable
memory is made movable at boot time.

On x86, hotpluggable memory is discovered by parsing the ACPI SRAT,
making corresponding calls to memblock_mark_hotplug().

If we introduce a dt property to describe memory as hotpluggable,
configs supporting early fdt may then also do this marking and use
movable nodes.

Link: http://lkml.kernel.org/r/1479160961-25840-5-git-send-email-arbab@linux.vnet.ibm.com
Signed-off-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Tested-by: Balbir Singh <bsingharora@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alistair Popple <apopple@au1.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/fdt.c       |   19 +++++++++++++++++++
 include/linux/of_fdt.h |    1 +
 mm/Kconfig             |    2 +-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff -puN drivers/of/fdt.c~of-fdt-mark-hotpluggable-memory drivers/of/fdt.c
--- a/drivers/of/fdt.c~of-fdt-mark-hotpluggable-memory
+++ a/drivers/of/fdt.c
@@ -1015,6 +1015,7 @@ int __init early_init_dt_scan_memory(uns
 	const char *type = of_get_flat_dt_prop(node, "device_type", NULL);
 	const __be32 *reg, *endp;
 	int l;
+	bool hotpluggable;
 
 	/* We are scanning "memory" nodes only */
 	if (type == NULL) {
@@ -1034,6 +1035,7 @@ int __init early_init_dt_scan_memory(uns
 		return 0;
 
 	endp = reg + (l / sizeof(__be32));
+	hotpluggable = of_get_flat_dt_prop(node, "hotpluggable", NULL);
 
 	pr_debug("memory scan node %s, reg size %d,\n", uname, l);
 
@@ -1049,6 +1051,13 @@ int __init early_init_dt_scan_memory(uns
 		    (unsigned long long)size);
 
 		early_init_dt_add_memory_arch(base, size);
+
+		if (!hotpluggable)
+			continue;
+
+		if (early_init_dt_mark_hotplug_memory_arch(base, size))
+			pr_warn("failed to mark hotplug range 0x%llx - 0x%llx\n",
+				base, base + size);
 	}
 
 	return 0;
@@ -1146,6 +1155,11 @@ void __init __weak early_init_dt_add_mem
 	memblock_add(base, size);
 }
 
+int __init __weak early_init_dt_mark_hotplug_memory_arch(u64 base, u64 size)
+{
+	return memblock_mark_hotplug(base, size);
+}
+
 int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
 					phys_addr_t size, bool nomap)
 {
@@ -1168,6 +1182,11 @@ void __init __weak early_init_dt_add_mem
 	WARN_ON(1);
 }
 
+int __init __weak early_init_dt_mark_hotplug_memory_arch(u64 base, u64 size)
+{
+	return -ENOSYS;
+}
+
 int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
 					phys_addr_t size, bool nomap)
 {
diff -puN include/linux/of_fdt.h~of-fdt-mark-hotpluggable-memory include/linux/of_fdt.h
--- a/include/linux/of_fdt.h~of-fdt-mark-hotpluggable-memory
+++ a/include/linux/of_fdt.h
@@ -71,6 +71,7 @@ extern int early_init_dt_scan_chosen_std
 extern void early_init_fdt_scan_reserved_mem(void);
 extern void early_init_fdt_reserve_self(void);
 extern void early_init_dt_add_memory_arch(u64 base, u64 size);
+extern int early_init_dt_mark_hotplug_memory_arch(u64 base, u64 size);
 extern int early_init_dt_reserve_memory_arch(phys_addr_t base, phys_addr_t size,
 					     bool no_map);
 extern void * early_init_dt_alloc_memory_arch(u64 size, u64 align);
diff -puN mm/Kconfig~of-fdt-mark-hotpluggable-memory mm/Kconfig
--- a/mm/Kconfig~of-fdt-mark-hotpluggable-memory
+++ a/mm/Kconfig
@@ -153,7 +153,7 @@ config MOVABLE_NODE
 	bool "Enable to assign a node which has only movable memory"
 	depends on HAVE_MEMBLOCK
 	depends on NO_BOOTMEM
-	depends on X86_64 || MEMORY_HOTPLUG
+	depends on X86_64 || OF_EARLY_FLATTREE || MEMORY_HOTPLUG
 	depends on NUMA
 	default n
 	help
_

Patches currently in -mm which might be from arbab@linux.vnet.ibm.com are

powerpc-mm-allow-memory-hotplug-into-a-memoryless-node.patch
mm-remove-x86-only-restriction-of-movable_node.patch
mm-enable-config_movable_node-on-non-x86-arches.patch
of-fdt-mark-hotpluggable-memory.patch
dt-add-documentation-of-hotpluggable-memory-property.patch

