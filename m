Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808441474A2
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 20:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723064379; cv=none; b=suNshhAJM7pupENp1IlzJ16fht1de0CP++BTJAuIjTQMN2xlLHOTe8Mn19Q3O4nWMJar100K1WcbMuaIfOQhLTWZm/opbEgiyhE2fpBSe6R7RG+Ln/9dmPYl39ojC2eW7M6lKhIBxEc7zpFRgU8N3NJn8fUE7R+HUvRktw1vwZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723064379; c=relaxed/simple;
	bh=uI3c2iNHTHJZOnEsO3cYOxfDhU2R5EePgyBm95VXeIg=;
	h=Date:To:From:Subject:Message-Id; b=bp/8BJm4POfy70IBN4SJGCzlIWdE478G02tA+xYRzDfuJsTUujrBtMLJTy6PipQ3oh/IUbGmdCrcjSmxquO2J7099COSva20eHwhQdrl7vWFpkTKGohAPDDgFq9Xf14U49a9tSxT8BQPiOlKesEhXA7Bd9/RDj1y2LFeYPp2BGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HZJXPP5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HZJXPP5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCDBC32781;
	Wed,  7 Aug 2024 20:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723064379;
	bh=uI3c2iNHTHJZOnEsO3cYOxfDhU2R5EePgyBm95VXeIg=;
	h=Date:To:From:Subject:From;
	b=HZJXPP5DBx2v6SmYfTDROU29aMaWzjwyik7QUlwDi43I3tkooT4TZ3IamqzVp3jdG
	 jrPGu8lcBEO8x+T9IfAPYY875O5hEvow5crWy9krCoA8PVSQOylcViUxoL6QUA9U/C
	 ktp9W8Gxxlu/79juOJUqgQ9o7Z6dR/zDxxZXCl/k=
Date: Wed, 07 Aug 2024 13:59:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks.patch added to mm-unstable branch
Message-Id: <20240807205939.4DCDBC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make range-to-target_node lookup facility a part of numa_memblks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm: make range-to-target_node lookup facility a part of numa_memblks
Date: Wed, 7 Aug 2024 09:41:09 +0300

The x86 implementation of range-to-target_node lookup (i.e. 
phys_to_target_node() and memory_add_physaddr_to_nid()) relies on
numa_memblks.

Since numa_memblks are now part of the generic code, move these functions
from x86 to mm/numa_memblks.c and select CONFIG_NUMA_KEEP_MEMINFO when
CONFIG_NUMA_MEMBLKS=y for dax and cxl.

Link: https://lkml.kernel.org/r/20240807064110.1003856-26-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Zi Yan <ziy@nvidia.com> # for x86_64 and arm64
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> [arm64 + CXL via QEMU]
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Rob Herring (Arm) <robh@kernel.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/sparsemem.h |    9 ------
 arch/x86/mm/numa.c               |   38 -----------------------------
 drivers/cxl/Kconfig              |    2 -
 drivers/dax/Kconfig              |    2 -
 include/linux/numa_memblks.h     |    7 +++++
 mm/numa.c                        |    1 
 mm/numa_memblks.c                |   38 +++++++++++++++++++++++++++++
 7 files changed, 48 insertions(+), 49 deletions(-)

--- a/arch/x86/include/asm/sparsemem.h~mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks
+++ a/arch/x86/include/asm/sparsemem.h
@@ -31,13 +31,4 @@
 
 #endif /* CONFIG_SPARSEMEM */
 
-#ifndef __ASSEMBLY__
-#ifdef CONFIG_NUMA_KEEP_MEMINFO
-extern int phys_to_target_node(phys_addr_t start);
-#define phys_to_target_node phys_to_target_node
-extern int memory_add_physaddr_to_nid(u64 start);
-#define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
-#endif
-#endif /* __ASSEMBLY__ */
-
 #endif /* _ASM_X86_SPARSEMEM_H */
--- a/arch/x86/mm/numa.c~mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks
+++ a/arch/x86/mm/numa.c
@@ -453,41 +453,3 @@ u64 __init numa_emu_dma_end(void)
 	return PFN_PHYS(MAX_DMA32_PFN);
 }
 #endif /* CONFIG_NUMA_EMU */
-
-#ifdef CONFIG_NUMA_KEEP_MEMINFO
-static int meminfo_to_nid(struct numa_meminfo *mi, u64 start)
-{
-	int i;
-
-	for (i = 0; i < mi->nr_blks; i++)
-		if (mi->blk[i].start <= start && mi->blk[i].end > start)
-			return mi->blk[i].nid;
-	return NUMA_NO_NODE;
-}
-
-int phys_to_target_node(phys_addr_t start)
-{
-	int nid = meminfo_to_nid(&numa_meminfo, start);
-
-	/*
-	 * Prefer online nodes, but if reserved memory might be
-	 * hot-added continue the search with reserved ranges.
-	 */
-	if (nid != NUMA_NO_NODE)
-		return nid;
-
-	return meminfo_to_nid(&numa_reserved_meminfo, start);
-}
-EXPORT_SYMBOL_GPL(phys_to_target_node);
-
-int memory_add_physaddr_to_nid(u64 start)
-{
-	int nid = meminfo_to_nid(&numa_meminfo, start);
-
-	if (nid == NUMA_NO_NODE)
-		nid = numa_meminfo.blk[0].nid;
-	return nid;
-}
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
-
-#endif
--- a/drivers/cxl/Kconfig~mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks
+++ a/drivers/cxl/Kconfig
@@ -6,7 +6,7 @@ menuconfig CXL_BUS
 	select FW_UPLOAD
 	select PCI_DOE
 	select FIRMWARE_TABLE
-	select NUMA_KEEP_MEMINFO if (NUMA && X86)
+	select NUMA_KEEP_MEMINFO if NUMA_MEMBLKS
 	help
 	  CXL is a bus that is electrically compatible with PCI Express, but
 	  layers three protocols on that signalling (CXL.io, CXL.cache, and
--- a/drivers/dax/Kconfig~mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks
+++ a/drivers/dax/Kconfig
@@ -30,7 +30,7 @@ config DEV_DAX_PMEM
 config DEV_DAX_HMEM
 	tristate "HMEM DAX: direct access to 'specific purpose' memory"
 	depends on EFI_SOFT_RESERVE
-	select NUMA_KEEP_MEMINFO if (NUMA && X86)
+	select NUMA_KEEP_MEMINFO if NUMA_MEMBLKS
 	default DEV_DAX
 	help
 	  EFI 2.8 platforms, and others, may advertise 'specific purpose'
--- a/include/linux/numa_memblks.h~mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks
+++ a/include/linux/numa_memblks.h
@@ -46,6 +46,13 @@ static inline int numa_emu_cmdline(char
 }
 #endif /* CONFIG_NUMA_EMU */
 
+#ifdef CONFIG_NUMA_KEEP_MEMINFO
+extern int phys_to_target_node(phys_addr_t start);
+#define phys_to_target_node phys_to_target_node
+extern int memory_add_physaddr_to_nid(u64 start);
+#define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
+#endif /* CONFIG_NUMA_KEEP_MEMINFO */
+
 #endif /* CONFIG_NUMA_MEMBLKS */
 
 #endif	/* __NUMA_MEMBLKS_H */
--- a/mm/numa.c~mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks
+++ a/mm/numa.c
@@ -3,6 +3,7 @@
 #include <linux/memblock.h>
 #include <linux/printk.h>
 #include <linux/numa.h>
+#include <linux/numa_memblks.h>
 
 struct pglist_data *node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(node_data);
--- a/mm/numa_memblks.c~mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks
+++ a/mm/numa_memblks.c
@@ -531,3 +531,41 @@ int __init numa_fill_memblks(u64 start,
 	}
 	return 0;
 }
+
+#ifdef CONFIG_NUMA_KEEP_MEMINFO
+static int meminfo_to_nid(struct numa_meminfo *mi, u64 start)
+{
+	int i;
+
+	for (i = 0; i < mi->nr_blks; i++)
+		if (mi->blk[i].start <= start && mi->blk[i].end > start)
+			return mi->blk[i].nid;
+	return NUMA_NO_NODE;
+}
+
+int phys_to_target_node(phys_addr_t start)
+{
+	int nid = meminfo_to_nid(&numa_meminfo, start);
+
+	/*
+	 * Prefer online nodes, but if reserved memory might be
+	 * hot-added continue the search with reserved ranges.
+	 */
+	if (nid != NUMA_NO_NODE)
+		return nid;
+
+	return meminfo_to_nid(&numa_reserved_meminfo, start);
+}
+EXPORT_SYMBOL_GPL(phys_to_target_node);
+
+int memory_add_physaddr_to_nid(u64 start)
+{
+	int nid = meminfo_to_nid(&numa_meminfo, start);
+
+	if (nid == NUMA_NO_NODE)
+		nid = numa_meminfo.blk[0].nid;
+	return nid;
+}
+EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
+
+#endif /* CONFIG_NUMA_KEEP_MEMINFO */
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-move-kernel-numac-to-mm.patch
mips-sgi-ip27-make-node_data-the-same-as-on-all-other-architectures.patch
mips-sgi-ip27-ensure-node_possible_map-only-contains-valid-nodes.patch
mips-sgi-ip27-drop-have_arch_nodedata_extension.patch
mips-loongson64-rename-__node_data-to-node_data.patch
mips-loongson64-drop-have_arch_nodedata_extension.patch
arch-mm-move-definition-of-node_data-to-generic-code.patch
mm-drop-config_have_arch_nodedata_extension.patch
arch-mm-pull-out-allocation-of-node_data-to-generic-code.patch
x86-numa-simplify-numa_distance-allocation.patch
x86-numa-use-get_pfn_range_for_nid-to-verify-that-node-spans-memory.patch
x86-numa-move-fake_node_-defines-to-numa_emu.patch
x86-numa_emu-simplify-allocation-of-phys_dist.patch
x86-numa_emu-split-__apicid_to_node-update-to-a-helper-function.patch
x86-numa_emu-use-a-helper-function-to-get-max_dma32_pfn.patch
x86-numa-numa_addremove_cpu-make-cpu-parameter-unsigned.patch
mm-introduce-numa_memblks.patch
mm-move-numa_distance-and-related-code-from-x86-to-numa_memblks.patch
mm-introduce-numa_emulation.patch
mm-numa_memblks-introduce-numa_memblks_init.patch
mm-numa_memblks-make-several-functions-and-variables-static.patch
mm-numa_memblks-use-memblock_startend_of_dram-when-sanitizing-meminfo.patch
of-numa-return-einval-when-no-numa-node-id-is-found.patch
arch_numa-switch-over-to-numa_memblks.patch
arch_numa-switch-over-to-numa_memblks-fix.patch
mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks.patch
docs-move-numa=fake-description-to-kernel-parameterstxt.patch

