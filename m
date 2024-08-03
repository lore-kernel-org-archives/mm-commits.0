Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F46134AB
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 18:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722710536; cv=none; b=VU8dOUkNjUWiwagVILLBUo7KBtsktg1+wpz4YxFvaEWaMHgZY3qNLustcshLTG9k6KMfJ6lUfDqu4jNTiFyucuGwqxjYvGlghLRnKjc+WmKPsp3Y4RNGbaU55pnN/sJz5D38PVOt7OkiujKF5MczYGEnbVPt1s7DOqZuzExh8VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722710536; c=relaxed/simple;
	bh=GW5hqgYzGMR/IPteFue8vo0iecqcB288BzTpaMr1bRI=;
	h=Date:To:From:Subject:Message-Id; b=rBGBAXDAF0wyEBNqd4wyHhb+92/+PdeAphzAA3Nh4Oc4j4fif8hYZUMt7E+Kq/QhSXQcvL1ieJ3oHCKHsca3v6VNjJvSELoXR4ETTWv1XwWVx8drPRFQMzwo7eIgZ3e7aYNVLkqWBMX0yBQBDaVGj3Nn9q6agDQBt6zEjb4dDpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hoF4W6qm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hoF4W6qm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C86FC4AF09;
	Sat,  3 Aug 2024 18:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722710536;
	bh=GW5hqgYzGMR/IPteFue8vo0iecqcB288BzTpaMr1bRI=;
	h=Date:To:From:Subject:From;
	b=hoF4W6qmaTsquwqAgDVhtiOlSO34mTMaOGnZLjHzBHJTIWMePI3fdHie8Crbl+HQ7
	 wQqqdsGaMMbgfml0A+NJk7L4VguA+8ZAucDEHGMYpqMuDlVO0YK9qXGWuPvWfJQ/4D
	 JPrbCXYQgQqjtyDoK3lZyGA60WRVog1GAK1MQVHY=
Date: Sat, 03 Aug 2024 11:42:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-mm-move-definition-of-node_data-to-generic-code.patch added to mm-unstable branch
Message-Id: <20240803184216.5C86FC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch, mm: move definition of node_data to generic code
has been added to the -mm mm-unstable branch.  Its filename is
     arch-mm-move-definition-of-node_data-to-generic-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-mm-move-definition-of-node_data-to-generic-code.patch

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
Subject: arch, mm: move definition of node_data to generic code
Date: Thu, 1 Aug 2024 09:08:08 +0300

Every architecture that supports NUMA defines node_data in the same way:

	struct pglist_data *node_data[MAX_NUMNODES];

No reason to keep multiple copies of this definition and its forward
declarations, especially when such forward declaration is the only thing
in include/asm/mmzone.h for many architectures.

Add definition and declaration of node_data to generic code and drop
architecture-specific versions.

Link: https://lkml.kernel.org/r/20240801060826.559858-9-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> [arm64 + CXL via QEMU]
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Tested-by: Zi Yan <ziy@nvidia.com>	[x86_64 and arm64]
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
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

 arch/arm64/include/asm/Kbuild                  |    1 
 arch/arm64/include/asm/mmzone.h                |   13 ----------
 arch/arm64/include/asm/topology.h              |    1 
 arch/loongarch/include/asm/Kbuild              |    1 
 arch/loongarch/include/asm/mmzone.h            |   16 -------------
 arch/loongarch/include/asm/topology.h          |    1 
 arch/loongarch/kernel/numa.c                   |    3 --
 arch/mips/include/asm/mach-ip27/mmzone.h       |    4 ---
 arch/mips/include/asm/mach-loongson64/mmzone.h |    4 ---
 arch/mips/loongson64/numa.c                    |    2 -
 arch/mips/sgi-ip27/ip27-memory.c               |    3 --
 arch/powerpc/include/asm/mmzone.h              |    6 -----
 arch/powerpc/mm/numa.c                         |    2 -
 arch/riscv/include/asm/Kbuild                  |    1 
 arch/riscv/include/asm/mmzone.h                |   13 ----------
 arch/riscv/include/asm/topology.h              |    4 +++
 arch/s390/include/asm/Kbuild                   |    1 
 arch/s390/include/asm/mmzone.h                 |   17 --------------
 arch/s390/kernel/numa.c                        |    3 --
 arch/sh/include/asm/mmzone.h                   |    3 --
 arch/sh/mm/numa.c                              |    3 --
 arch/sparc/include/asm/mmzone.h                |    4 ---
 arch/sparc/mm/init_64.c                        |    2 -
 arch/x86/include/asm/Kbuild                    |    1 
 arch/x86/include/asm/mmzone.h                  |    6 -----
 arch/x86/include/asm/mmzone_32.h               |   17 --------------
 arch/x86/include/asm/mmzone_64.h               |   18 ---------------
 arch/x86/mm/numa.c                             |    3 --
 drivers/base/arch_numa.c                       |    2 -
 include/asm-generic/mmzone.h                   |    5 ++++
 include/linux/numa.h                           |    3 ++
 mm/numa.c                                      |    3 ++
 32 files changed, 22 insertions(+), 144 deletions(-)

--- a/arch/arm64/include/asm/Kbuild~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/arm64/include/asm/Kbuild
@@ -9,6 +9,7 @@ syscall-y += unistd_compat_32.h
 
 generic-y += early_ioremap.h
 generic-y += mcs_spinlock.h
+generic-y += mmzone.h
 generic-y += qrwlock.h
 generic-y += qspinlock.h
 generic-y += parport.h
diff --git a/arch/arm64/include/asm/mmzone.h a/arch/arm64/include/asm/mmzone.h
deleted file mode 100644
--- a/arch/arm64/include/asm/mmzone.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __ASM_MMZONE_H
-#define __ASM_MMZONE_H
-
-#ifdef CONFIG_NUMA
-
-#include <asm/numa.h>
-
-extern struct pglist_data *node_data[];
-#define NODE_DATA(nid)		(node_data[(nid)])
-
-#endif /* CONFIG_NUMA */
-#endif /* __ASM_MMZONE_H */
--- a/arch/arm64/include/asm/topology.h~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/arm64/include/asm/topology.h
@@ -5,6 +5,7 @@
 #include <linux/cpumask.h>
 
 #ifdef CONFIG_NUMA
+#include <asm/numa.h>
 
 struct pci_bus;
 int pcibus_to_node(struct pci_bus *bus);
--- a/arch/loongarch/include/asm/Kbuild~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/loongarch/include/asm/Kbuild
@@ -9,5 +9,6 @@ generic-y += qrwlock.h
 generic-y += qspinlock.h
 generic-y += user.h
 generic-y += ioctl.h
+generic-y += mmzone.h
 generic-y += statfs.h
 generic-y += param.h
diff --git a/arch/loongarch/include/asm/mmzone.h a/arch/loongarch/include/asm/mmzone.h
deleted file mode 100644
--- a/arch/loongarch/include/asm/mmzone.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Author: Huacai Chen (chenhuacai@loongson.cn)
- * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
- */
-#ifndef _ASM_MMZONE_H_
-#define _ASM_MMZONE_H_
-
-#include <asm/page.h>
-#include <asm/numa.h>
-
-extern struct pglist_data *node_data[];
-
-#define NODE_DATA(nid)	(node_data[(nid)])
-
-#endif /* _ASM_MMZONE_H_ */
--- a/arch/loongarch/include/asm/topology.h~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/loongarch/include/asm/topology.h
@@ -8,6 +8,7 @@
 #include <linux/smp.h>
 
 #ifdef CONFIG_NUMA
+#include <asm/numa.h>
 
 extern cpumask_t cpus_on_node[];
 
--- a/arch/loongarch/kernel/numa.c~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/loongarch/kernel/numa.c
@@ -27,10 +27,7 @@
 #include <asm/time.h>
 
 int numa_off;
-struct pglist_data *node_data[MAX_NUMNODES];
 unsigned char node_distances[MAX_NUMNODES][MAX_NUMNODES];
-
-EXPORT_SYMBOL(node_data);
 EXPORT_SYMBOL(node_distances);
 
 static struct numa_meminfo numa_meminfo;
--- a/arch/mips/include/asm/mach-ip27/mmzone.h~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/mips/include/asm/mach-ip27/mmzone.h
@@ -24,8 +24,4 @@ extern struct node_data *__node_data[];
 
 #define hub_data(n)		(&__node_data[(n)]->hub)
 
-extern struct pglist_data *node_data[];
-
-#define NODE_DATA(nid)		(node_data[nid])
-
 #endif /* _ASM_MACH_MMZONE_H */
--- a/arch/mips/include/asm/mach-loongson64/mmzone.h~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/mips/include/asm/mach-loongson64/mmzone.h
@@ -14,10 +14,6 @@
 #define pa_to_nid(addr)  (((addr) & 0xf00000000000) >> NODE_ADDRSPACE_SHIFT)
 #define nid_to_addrbase(nid) ((unsigned long)(nid) << NODE_ADDRSPACE_SHIFT)
 
-extern struct pglist_data *node_data[];
-
-#define NODE_DATA(n)		(node_data[n])
-
 extern void __init prom_init_numa_memory(void);
 
 #endif /* _ASM_MACH_MMZONE_H */
--- a/arch/mips/loongson64/numa.c~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/mips/loongson64/numa.c
@@ -29,8 +29,6 @@
 
 unsigned char __node_distances[MAX_NUMNODES][MAX_NUMNODES];
 EXPORT_SYMBOL(__node_distances);
-struct pglist_data *node_data[MAX_NUMNODES];
-EXPORT_SYMBOL(node_data);
 
 cpumask_t __node_cpumask[MAX_NUMNODES];
 EXPORT_SYMBOL(__node_cpumask);
--- a/arch/mips/sgi-ip27/ip27-memory.c~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -34,9 +34,6 @@
 #define SLOT_PFNSHIFT		(SLOT_SHIFT - PAGE_SHIFT)
 #define PFN_NASIDSHFT		(NASID_SHFT - PAGE_SHIFT)
 
-struct pglist_data *node_data[MAX_NUMNODES];
-EXPORT_SYMBOL(node_data);
-
 struct node_data *__node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(__node_data);
 
--- a/arch/powerpc/include/asm/mmzone.h~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/powerpc/include/asm/mmzone.h
@@ -20,12 +20,6 @@
 
 #ifdef CONFIG_NUMA
 
-extern struct pglist_data *node_data[];
-/*
- * Return a pointer to the node data for node n.
- */
-#define NODE_DATA(nid)		(node_data[nid])
-
 /*
  * Following are specific to this numa platform.
  */
--- a/arch/powerpc/mm/numa.c~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/powerpc/mm/numa.c
@@ -43,11 +43,9 @@ static char *cmdline __initdata;
 
 int numa_cpu_lookup_table[NR_CPUS];
 cpumask_var_t node_to_cpumask_map[MAX_NUMNODES];
-struct pglist_data *node_data[MAX_NUMNODES];
 
 EXPORT_SYMBOL(numa_cpu_lookup_table);
 EXPORT_SYMBOL(node_to_cpumask_map);
-EXPORT_SYMBOL(node_data);
 
 static int primary_domain_index;
 static int n_mem_addr_cells, n_mem_size_cells;
--- a/arch/riscv/include/asm/Kbuild~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/riscv/include/asm/Kbuild
@@ -5,6 +5,7 @@ syscall-y += syscall_table_64.h
 generic-y += early_ioremap.h
 generic-y += flat.h
 generic-y += kvm_para.h
+generic-y += mmzone.h
 generic-y += parport.h
 generic-y += spinlock.h
 generic-y += spinlock_types.h
diff --git a/arch/riscv/include/asm/mmzone.h a/arch/riscv/include/asm/mmzone.h
deleted file mode 100644
--- a/arch/riscv/include/asm/mmzone.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __ASM_MMZONE_H
-#define __ASM_MMZONE_H
-
-#ifdef CONFIG_NUMA
-
-#include <asm/numa.h>
-
-extern struct pglist_data *node_data[];
-#define NODE_DATA(nid)		(node_data[(nid)])
-
-#endif /* CONFIG_NUMA */
-#endif /* __ASM_MMZONE_H */
--- a/arch/riscv/include/asm/topology.h~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/riscv/include/asm/topology.h
@@ -4,6 +4,10 @@
 
 #include <linux/arch_topology.h>
 
+#ifdef CONFIG_NUMA
+#include <asm/numa.h>
+#endif
+
 /* Replace task scheduler's default frequency-invariant accounting */
 #define arch_scale_freq_tick		topology_scale_freq_tick
 #define arch_set_freq_scale		topology_set_freq_scale
--- a/arch/s390/include/asm/Kbuild~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/s390/include/asm/Kbuild
@@ -7,3 +7,4 @@ generated-y += unistd_nr.h
 generic-y += asm-offsets.h
 generic-y += kvm_types.h
 generic-y += mcs_spinlock.h
+generic-y += mmzone.h
diff --git a/arch/s390/include/asm/mmzone.h a/arch/s390/include/asm/mmzone.h
deleted file mode 100644
--- a/arch/s390/include/asm/mmzone.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * NUMA support for s390
- *
- * Copyright IBM Corp. 2015
- */
-
-#ifndef _ASM_S390_MMZONE_H
-#define _ASM_S390_MMZONE_H
-
-#ifdef CONFIG_NUMA
-
-extern struct pglist_data *node_data[];
-#define NODE_DATA(nid) (node_data[nid])
-
-#endif /* CONFIG_NUMA */
-#endif /* _ASM_S390_MMZONE_H */
--- a/arch/s390/kernel/numa.c~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/s390/kernel/numa.c
@@ -14,9 +14,6 @@
 #include <linux/node.h>
 #include <asm/numa.h>
 
-struct pglist_data *node_data[MAX_NUMNODES];
-EXPORT_SYMBOL(node_data);
-
 void __init numa_setup(void)
 {
 	int nid;
--- a/arch/sh/include/asm/mmzone.h~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/sh/include/asm/mmzone.h
@@ -5,9 +5,6 @@
 #ifdef CONFIG_NUMA
 #include <linux/numa.h>
 
-extern struct pglist_data *node_data[];
-#define NODE_DATA(nid)		(node_data[nid])
-
 static inline int pfn_to_nid(unsigned long pfn)
 {
 	int nid;
--- a/arch/sh/mm/numa.c~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/sh/mm/numa.c
@@ -14,9 +14,6 @@
 #include <linux/pfn.h>
 #include <asm/sections.h>
 
-struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
-EXPORT_SYMBOL_GPL(node_data);
-
 /*
  * On SH machines the conventional approach is to stash system RAM
  * in node 0, and other memory blocks in to node 1 and up, ordered by
--- a/arch/sparc/include/asm/mmzone.h~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/sparc/include/asm/mmzone.h
@@ -6,10 +6,6 @@
 
 #include <linux/cpumask.h>
 
-extern struct pglist_data *node_data[];
-
-#define NODE_DATA(nid)		(node_data[nid])
-
 extern int numa_cpu_lookup_table[];
 extern cpumask_t numa_cpumask_lookup_table[];
 
--- a/arch/sparc/mm/init_64.c~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/sparc/mm/init_64.c
@@ -1115,11 +1115,9 @@ static void init_node_masks_nonnuma(void
 }
 
 #ifdef CONFIG_NUMA
-struct pglist_data *node_data[MAX_NUMNODES];
 
 EXPORT_SYMBOL(numa_cpu_lookup_table);
 EXPORT_SYMBOL(numa_cpumask_lookup_table);
-EXPORT_SYMBOL(node_data);
 
 static int scan_pio_for_cfg_handle(struct mdesc_handle *md, u64 pio,
 				   u32 cfg_handle)
--- a/arch/x86/include/asm/Kbuild~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/x86/include/asm/Kbuild
@@ -11,3 +11,4 @@ generated-y += xen-hypercalls.h
 
 generic-y += early_ioremap.h
 generic-y += mcs_spinlock.h
+generic-y += mmzone.h
diff --git a/arch/x86/include/asm/mmzone_32.h a/arch/x86/include/asm/mmzone_32.h
deleted file mode 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Written by Pat Gaughen (gone@us.ibm.com) Mar 2002
- *
- */
-
-#ifndef _ASM_X86_MMZONE_32_H
-#define _ASM_X86_MMZONE_32_H
-
-#include <asm/smp.h>
-
-#ifdef CONFIG_NUMA
-extern struct pglist_data *node_data[];
-#define NODE_DATA(nid)	(node_data[nid])
-#endif /* CONFIG_NUMA */
-
-#endif /* _ASM_X86_MMZONE_32_H */
diff --git a/arch/x86/include/asm/mmzone_64.h a/arch/x86/include/asm/mmzone_64.h
deleted file mode 100644
--- a/arch/x86/include/asm/mmzone_64.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* K8 NUMA support */
-/* Copyright 2002,2003 by Andi Kleen, SuSE Labs */
-/* 2.5 Version loosely based on the NUMAQ Code by Pat Gaughen. */
-#ifndef _ASM_X86_MMZONE_64_H
-#define _ASM_X86_MMZONE_64_H
-
-#ifdef CONFIG_NUMA
-
-#include <linux/mmdebug.h>
-#include <asm/smp.h>
-
-extern struct pglist_data *node_data[];
-
-#define NODE_DATA(nid)		(node_data[nid])
-
-#endif
-#endif /* _ASM_X86_MMZONE_64_H */
diff --git a/arch/x86/include/asm/mmzone.h a/arch/x86/include/asm/mmzone.h
deleted file mode 100644
--- a/arch/x86/include/asm/mmzone.h
+++ /dev/null
@@ -1,6 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifdef CONFIG_X86_32
-# include <asm/mmzone_32.h>
-#else
-# include <asm/mmzone_64.h>
-#endif
--- a/arch/x86/mm/numa.c~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/arch/x86/mm/numa.c
@@ -24,9 +24,6 @@
 int numa_off;
 nodemask_t numa_nodes_parsed __initdata;
 
-struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
-EXPORT_SYMBOL(node_data);
-
 static struct numa_meminfo numa_meminfo __initdata_or_meminfo;
 static struct numa_meminfo numa_reserved_meminfo __initdata_or_meminfo;
 
--- a/drivers/base/arch_numa.c~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/drivers/base/arch_numa.c
@@ -15,8 +15,6 @@
 
 #include <asm/sections.h>
 
-struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
-EXPORT_SYMBOL(node_data);
 nodemask_t numa_nodes_parsed __initdata;
 static int cpu_to_node_map[NR_CPUS] = { [0 ... NR_CPUS-1] = NUMA_NO_NODE };
 
diff --git a/include/asm-generic/mmzone.h a/include/asm-generic/mmzone.h
new file mode 100644
--- /dev/null
+++ a/include/asm-generic/mmzone.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_GENERIC_MMZONE_H
+#define _ASM_GENERIC_MMZONE_H
+
+#endif
--- a/include/linux/numa.h~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/include/linux/numa.h
@@ -30,6 +30,9 @@ static inline bool numa_valid_node(int n
 #ifdef CONFIG_NUMA
 #include <asm/sparsemem.h>
 
+extern struct pglist_data *node_data[];
+#define NODE_DATA(nid)	(node_data[nid])
+
 /* Generic implementation available */
 int numa_nearest_node(int node, unsigned int state);
 
--- a/mm/numa.c~arch-mm-move-definition-of-node_data-to-generic-code
+++ a/mm/numa.c
@@ -3,6 +3,9 @@
 #include <linux/printk.h>
 #include <linux/numa.h>
 
+struct pglist_data *node_data[MAX_NUMNODES];
+EXPORT_SYMBOL(node_data);
+
 /* Stub functions: */
 
 #ifndef memory_add_physaddr_to_nid
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-move-kernel-numac-to-mm.patch
mips-sgi-ip27-make-node_data-the-same-as-on-all-other-architectures.patch
mips-sgi-ip27-ensure-node_possible_map-only-contains-valid-nodes.patch
mips-sgi-ip27-drop-have_arch_nodedata_extension.patch
mips-loongson64-rename-__node_data-to-node_data.patch
mips-loongson64-drop-have_arch_nodedata_extension.patch
mm-drop-config_have_arch_nodedata_extension.patch
arch-mm-move-definition-of-node_data-to-generic-code.patch
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
mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks.patch
docs-move-numa=fake-description-to-kernel-parameterstxt.patch

