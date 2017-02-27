From: akpm@linux-foundation.org
Subject: [merged]
 memblock-embed-memblock-type-name-within-struct-memblock_type.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:24:28 -0800
Message-ID: <58b48afc.jxbQX4urfeGaSp53%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60406 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751529AbdB0UYq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:24:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, phacht@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: embed memblock type name within struct memblock_type
has been removed from the -mm tree.  Its filename was
     memblock-embed-memblock-type-name-within-struct-memblock_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: memblock: embed memblock type name within struct memblock_type

Provide the name of each memblock type with struct memblock_type. This
allows to get rid of the function memblock_type_name() and duplicating
the type names in __memblock_dump_all().

The only memblock_type usage out of mm/memblock.c seems to be
arch/s390/kernel/crash_dump.c. While at it, give it a name.

Link: http://lkml.kernel.org/r/20170120123456.46508-4-heiko.carstens@de.ibm.com
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/crash_dump.c |    1 
 include/linux/memblock.h      |    1 
 mm/memblock.c                 |   35 ++++++++++----------------------
 3 files changed, 13 insertions(+), 24 deletions(-)

diff -puN arch/s390/kernel/crash_dump.c~memblock-embed-memblock-type-name-within-struct-memblock_type arch/s390/kernel/crash_dump.c
--- a/arch/s390/kernel/crash_dump.c~memblock-embed-memblock-type-name-within-struct-memblock_type
+++ a/arch/s390/kernel/crash_dump.c
@@ -32,6 +32,7 @@ static struct memblock_type oldmem_type
 	.max = 1,
 	.total_size = 0,
 	.regions = &oldmem_region,
+	.name = "oldmem",
 };
 
 struct save_area {
diff -puN include/linux/memblock.h~memblock-embed-memblock-type-name-within-struct-memblock_type include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-embed-memblock-type-name-within-struct-memblock_type
+++ a/include/linux/memblock.h
@@ -42,6 +42,7 @@ struct memblock_type {
 	unsigned long max;	/* size of the allocated array */
 	phys_addr_t total_size;	/* size of all regions */
 	struct memblock_region *regions;
+	char *name;
 };
 
 struct memblock {
diff -puN mm/memblock.c~memblock-embed-memblock-type-name-within-struct-memblock_type mm/memblock.c
--- a/mm/memblock.c~memblock-embed-memblock-type-name-within-struct-memblock_type
+++ a/mm/memblock.c
@@ -35,15 +35,18 @@ struct memblock memblock __initdata_memb
 	.memory.regions		= memblock_memory_init_regions,
 	.memory.cnt		= 1,	/* empty dummy entry */
 	.memory.max		= INIT_MEMBLOCK_REGIONS,
+	.memory.name		= "memory",
 
 	.reserved.regions	= memblock_reserved_init_regions,
 	.reserved.cnt		= 1,	/* empty dummy entry */
 	.reserved.max		= INIT_MEMBLOCK_REGIONS,
+	.reserved.name		= "reserved",
 
 #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
 	.physmem.regions	= memblock_physmem_init_regions,
 	.physmem.cnt		= 1,	/* empty dummy entry */
 	.physmem.max		= INIT_PHYSMEM_REGIONS,
+	.physmem.name		= "physmem",
 #endif
 
 	.bottom_up		= false,
@@ -64,22 +67,6 @@ ulong __init_memblock choose_memblock_fl
 	return system_has_some_mirror ? MEMBLOCK_MIRROR : MEMBLOCK_NONE;
 }
 
-/* inline so we don't get a warning when pr_debug is compiled out */
-static __init_memblock const char *
-memblock_type_name(struct memblock_type *type)
-{
-	if (type == &memblock.memory)
-		return "memory";
-	else if (type == &memblock.reserved)
-		return "reserved";
-#ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
-	else if (type == &memblock.physmem)
-		return "physmem";
-#endif
-	else
-		return "unknown";
-}
-
 /* adjust *@size so that (@base + *@size) doesn't overflow, return new size */
 static inline phys_addr_t memblock_cap_size(phys_addr_t base, phys_addr_t *size)
 {
@@ -406,12 +393,12 @@ static int __init_memblock memblock_doub
 	}
 	if (!addr) {
 		pr_err("memblock: Failed to double %s array from %ld to %ld entries !\n",
-		       memblock_type_name(type), type->max, type->max * 2);
+		       type->name, type->max, type->max * 2);
 		return -1;
 	}
 
 	memblock_dbg("memblock: %s is doubled to %ld at [%#010llx-%#010llx]",
-			memblock_type_name(type), type->max * 2, (u64)addr,
+			type->name, type->max * 2, (u64)addr,
 			(u64)addr + new_size - 1);
 
 	/*
@@ -1697,14 +1684,14 @@ phys_addr_t __init_memblock memblock_get
 	return memblock.current_limit;
 }
 
-static void __init_memblock memblock_dump(struct memblock_type *type, char *name)
+static void __init_memblock memblock_dump(struct memblock_type *type)
 {
 	phys_addr_t base, end, size;
 	unsigned long flags;
 	int idx;
 	struct memblock_region *rgn;
 
-	pr_info(" %s.cnt  = 0x%lx\n", name, type->cnt);
+	pr_info(" %s.cnt  = 0x%lx\n", type->name, type->cnt);
 
 	for_each_memblock_type(type, rgn) {
 		char nid_buf[32] = "";
@@ -1719,7 +1706,7 @@ static void __init_memblock memblock_dum
 				 memblock_get_region_node(rgn));
 #endif
 		pr_info(" %s[%#x]\t[%pa-%pa], %pa bytes%s flags: %#lx\n",
-			name, idx, &base, &end, &size, nid_buf, flags);
+			type->name, idx, &base, &end, &size, nid_buf, flags);
 	}
 }
 
@@ -1730,10 +1717,10 @@ void __init_memblock __memblock_dump_all
 		&memblock.memory.total_size,
 		&memblock.reserved.total_size);
 
-	memblock_dump(&memblock.memory, "memory");
-	memblock_dump(&memblock.reserved, "reserved");
+	memblock_dump(&memblock.memory);
+	memblock_dump(&memblock.reserved);
 #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
-	memblock_dump(&memblock.physmem, "physmem");
+	memblock_dump(&memblock.physmem);
 #endif
 }
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are


