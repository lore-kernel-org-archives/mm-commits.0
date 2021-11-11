Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213B7C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0818E610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbhKKCub (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:50:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234421AbhKKCua (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:50:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7A1760F26;
        Thu, 11 Nov 2021 02:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598862;
        bh=Gz6UeQp5lL2oMlGYu1FbMyLRXqvT79WlJIUnHqGfDNw=;
        h=Date:From:To:Subject:From;
        b=PstJ5fQOU6/bjTkSpb4293tAwNfrS3stQTDLdWnGtWwyw1wWOGACDbKcY1h/1QmWc
         90H0pVH887vkAndcBWtECtwNPWrabP0gD1w63F437yRGmcNWpagYmRJ4MTPdhKJUrL
         FSDh8XjpYGPshmnuPwNfXdf0JlbvpbP5ZbuXdEKU=
Date:   Wed, 10 Nov 2021 18:47:41 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, arnd@arndb.de, borntraeger@de.ibm.com,
        chenhuacai@kernel.org, david@redhat.com, ebiederm@xmission.com,
        geert@linux-m68k.org, gor@linux.ibm.com, hca@linux.ibm.com,
        Jianyong.Wu@arm.com, jiaxun.yang@flygoat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@linux.ibm.com,
        shahab@synopsys.com, tsbogend@alpha.franken.de, vgupta@kernel.org
Subject:  [merged]
 memblock-allow-to-specify-flags-with-memblock_add_node.patch removed from
 -mm tree
Message-ID: <20211111024741.RUa4Yyi6W%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: allow to specify flags with memblock_add_node()
has been removed from the -mm tree.  Its filename was
     memblock-allow-to-specify-flags-with-memblock_add_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: memblock: allow to specify flags with memblock_add_node()

We want to specify flags when hotplugging memory.  Let's prepare to pass
flags to memblock_add_node() by adjusting all existing users.

Note that when hotplugging memory the system is already up and running and
we might have concurrent memblock users: for example, while we're
hotplugging memory, kexec_file code might search for suitable memory
regions to place kexec images.  It's important to add the memory directly
to memblock via a single call with the right flags, instead of adding the
memory first and apply flags later: otherwise, concurrent memblock users
might temporarily stumble over memblocks with wrong flags, which will be
important in a follow-up patch that introduces a new flag to properly
handle add_memory_driver_managed().

Link: https://lkml.kernel.org/r/20211004093605.5830-4-david@redhat.com
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Shahab Vahedi <shahab@synopsys.com>	[arch/arc]
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jianyong Wu <Jianyong.Wu@arm.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/init.c               |    4 ++--
 arch/ia64/mm/contig.c            |    2 +-
 arch/ia64/mm/init.c              |    2 +-
 arch/m68k/mm/mcfmmu.c            |    3 ++-
 arch/m68k/mm/motorola.c          |    6 ++++--
 arch/mips/loongson64/init.c      |    4 +++-
 arch/mips/sgi-ip27/ip27-memory.c |    3 ++-
 arch/s390/kernel/setup.c         |    3 ++-
 include/linux/memblock.h         |    3 ++-
 include/linux/mm.h               |    2 +-
 mm/memblock.c                    |    9 +++++----
 mm/memory_hotplug.c              |    2 +-
 12 files changed, 26 insertions(+), 17 deletions(-)

--- a/arch/arc/mm/init.c~memblock-allow-to-specify-flags-with-memblock_add_node
+++ a/arch/arc/mm/init.c
@@ -59,13 +59,13 @@ void __init early_init_dt_add_memory_arc
 
 		low_mem_sz = size;
 		in_use = 1;
-		memblock_add_node(base, size, 0);
+		memblock_add_node(base, size, 0, MEMBLOCK_NONE);
 	} else {
 #ifdef CONFIG_HIGHMEM
 		high_mem_start = base;
 		high_mem_sz = size;
 		in_use = 1;
-		memblock_add_node(base, size, 1);
+		memblock_add_node(base, size, 1, MEMBLOCK_NONE);
 		memblock_reserve(base, size);
 #endif
 	}
--- a/arch/ia64/mm/contig.c~memblock-allow-to-specify-flags-with-memblock_add_node
+++ a/arch/ia64/mm/contig.c
@@ -153,7 +153,7 @@ find_memory (void)
 	efi_memmap_walk(find_max_min_low_pfn, NULL);
 	max_pfn = max_low_pfn;
 
-	memblock_add_node(0, PFN_PHYS(max_low_pfn), 0);
+	memblock_add_node(0, PFN_PHYS(max_low_pfn), 0, MEMBLOCK_NONE);
 
 	find_initrd();
 
--- a/arch/ia64/mm/init.c~memblock-allow-to-specify-flags-with-memblock_add_node
+++ a/arch/ia64/mm/init.c
@@ -378,7 +378,7 @@ int __init register_active_ranges(u64 st
 #endif
 
 	if (start < end)
-		memblock_add_node(__pa(start), end - start, nid);
+		memblock_add_node(__pa(start), end - start, nid, MEMBLOCK_NONE);
 	return 0;
 }
 
--- a/arch/m68k/mm/mcfmmu.c~memblock-allow-to-specify-flags-with-memblock_add_node
+++ a/arch/m68k/mm/mcfmmu.c
@@ -174,7 +174,8 @@ void __init cf_bootmem_alloc(void)
 	m68k_memory[0].addr = _rambase;
 	m68k_memory[0].size = _ramend - _rambase;
 
-	memblock_add_node(m68k_memory[0].addr, m68k_memory[0].size, 0);
+	memblock_add_node(m68k_memory[0].addr, m68k_memory[0].size, 0,
+			  MEMBLOCK_NONE);
 
 	/* compute total pages in system */
 	num_pages = PFN_DOWN(_ramend - _rambase);
--- a/arch/m68k/mm/motorola.c~memblock-allow-to-specify-flags-with-memblock_add_node
+++ a/arch/m68k/mm/motorola.c
@@ -410,7 +410,8 @@ void __init paging_init(void)
 
 	min_addr = m68k_memory[0].addr;
 	max_addr = min_addr + m68k_memory[0].size;
-	memblock_add_node(m68k_memory[0].addr, m68k_memory[0].size, 0);
+	memblock_add_node(m68k_memory[0].addr, m68k_memory[0].size, 0,
+			  MEMBLOCK_NONE);
 	for (i = 1; i < m68k_num_memory;) {
 		if (m68k_memory[i].addr < min_addr) {
 			printk("Ignoring memory chunk at 0x%lx:0x%lx before the first chunk\n",
@@ -421,7 +422,8 @@ void __init paging_init(void)
 				(m68k_num_memory - i) * sizeof(struct m68k_mem_info));
 			continue;
 		}
-		memblock_add_node(m68k_memory[i].addr, m68k_memory[i].size, i);
+		memblock_add_node(m68k_memory[i].addr, m68k_memory[i].size, i,
+				  MEMBLOCK_NONE);
 		addr = m68k_memory[i].addr + m68k_memory[i].size;
 		if (addr > max_addr)
 			max_addr = addr;
--- a/arch/mips/loongson64/init.c~memblock-allow-to-specify-flags-with-memblock_add_node
+++ a/arch/mips/loongson64/init.c
@@ -77,7 +77,9 @@ void __init szmem(unsigned int node)
 				(u32)node_id, mem_type, mem_start, mem_size);
 			pr_info("       start_pfn:0x%llx, end_pfn:0x%llx, num_physpages:0x%lx\n",
 				start_pfn, end_pfn, num_physpages);
-			memblock_add_node(PFN_PHYS(start_pfn), PFN_PHYS(node_psize), node);
+			memblock_add_node(PFN_PHYS(start_pfn),
+					  PFN_PHYS(node_psize), node,
+					  MEMBLOCK_NONE);
 			break;
 		case SYSTEM_RAM_RESERVED:
 			pr_info("Node%d: mem_type:%d, mem_start:0x%llx, mem_size:0x%llx MB\n",
--- a/arch/mips/sgi-ip27/ip27-memory.c~memblock-allow-to-specify-flags-with-memblock_add_node
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -341,7 +341,8 @@ static void __init szmem(void)
 				continue;
 			}
 			memblock_add_node(PFN_PHYS(slot_getbasepfn(node, slot)),
-					  PFN_PHYS(slot_psize), node);
+					  PFN_PHYS(slot_psize), node,
+					  MEMBLOCK_NONE);
 		}
 	}
 }
--- a/arch/s390/kernel/setup.c~memblock-allow-to-specify-flags-with-memblock_add_node
+++ a/arch/s390/kernel/setup.c
@@ -593,7 +593,8 @@ static void __init setup_resources(void)
 	 * part of the System RAM resource.
 	 */
 	if (crashk_res.end) {
-		memblock_add_node(crashk_res.start, resource_size(&crashk_res), 0);
+		memblock_add_node(crashk_res.start, resource_size(&crashk_res),
+				  0, MEMBLOCK_NONE);
 		memblock_reserve(crashk_res.start, resource_size(&crashk_res));
 		insert_resource(&iomem_resource, &crashk_res);
 	}
--- a/include/linux/memblock.h~memblock-allow-to-specify-flags-with-memblock_add_node
+++ a/include/linux/memblock.h
@@ -104,7 +104,8 @@ static inline void memblock_discard(void
 #endif
 
 void memblock_allow_resize(void);
-int memblock_add_node(phys_addr_t base, phys_addr_t size, int nid);
+int memblock_add_node(phys_addr_t base, phys_addr_t size, int nid,
+		      enum memblock_flags flags);
 int memblock_add(phys_addr_t base, phys_addr_t size);
 int memblock_remove(phys_addr_t base, phys_addr_t size);
 int memblock_phys_free(phys_addr_t base, phys_addr_t size);
--- a/include/linux/mm.h~memblock-allow-to-specify-flags-with-memblock_add_node
+++ a/include/linux/mm.h
@@ -2425,7 +2425,7 @@ static inline unsigned long get_num_phys
  * unsigned long max_zone_pfns[MAX_NR_ZONES] = {max_dma, max_normal_pfn,
  * 							 max_highmem_pfn};
  * for_each_valid_physical_page_range()
- * 	memblock_add_node(base, size, nid)
+ *	memblock_add_node(base, size, nid, MEMBLOCK_NONE)
  * free_area_init(max_zone_pfns);
  */
 void free_area_init(unsigned long *max_zone_pfn);
--- a/mm/memblock.c~memblock-allow-to-specify-flags-with-memblock_add_node
+++ a/mm/memblock.c
@@ -655,6 +655,7 @@ repeat:
  * @base: base address of the new region
  * @size: size of the new region
  * @nid: nid of the new region
+ * @flags: flags of the new region
  *
  * Add new memblock region [@base, @base + @size) to the "memory"
  * type. See memblock_add_range() description for mode details
@@ -663,14 +664,14 @@ repeat:
  * 0 on success, -errno on failure.
  */
 int __init_memblock memblock_add_node(phys_addr_t base, phys_addr_t size,
-				       int nid)
+				      int nid, enum memblock_flags flags)
 {
 	phys_addr_t end = base + size - 1;
 
-	memblock_dbg("%s: [%pa-%pa] nid=%d %pS\n", __func__,
-		     &base, &end, nid, (void *)_RET_IP_);
+	memblock_dbg("%s: [%pa-%pa] nid=%d flags=%x %pS\n", __func__,
+		     &base, &end, nid, flags, (void *)_RET_IP_);
 
-	return memblock_add_range(&memblock.memory, base, size, nid, 0);
+	return memblock_add_range(&memblock.memory, base, size, nid, flags);
 }
 
 /**
--- a/mm/memory_hotplug.c~memblock-allow-to-specify-flags-with-memblock_add_node
+++ a/mm/memory_hotplug.c
@@ -1370,7 +1370,7 @@ int __ref add_memory_resource(int nid, s
 	mem_hotplug_begin();
 
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
-		ret = memblock_add_node(start, size, nid);
+		ret = memblock_add_node(start, size, nid, MEMBLOCK_NONE);
 		if (ret)
 			goto error_mem_hotplug_end;
 	}
_

Patches currently in -mm which might be from david@redhat.com are


