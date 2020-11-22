Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67629C63798
	for <mm-commits@archiver.kernel.org>; Sun, 22 Nov 2020 06:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31AAA2078B
	for <mm-commits@archiver.kernel.org>; Sun, 22 Nov 2020 06:17:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QcIjaQpy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgKVGRI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Nov 2020 01:17:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbgKVGRI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Nov 2020 01:17:08 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B962E2078B;
        Sun, 22 Nov 2020 06:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606025826;
        bh=9f8CeuTifjf5+5/WpjCZmyVs1VSOzRMH1+Q6rCo7bIs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QcIjaQpypZU1ppceZxbP7uag1/Lm6CMirun1pSKwuRTCNB8+6Dx/1KJX4AXlvG7P9
         Qlr9DuzC46i1l+fVJinovHX73m4DRwpG5pgW1qj9mGArZMwTfKD0p+HbFlKG9+IcSm
         Fla9IQYyzl+4oM+pZOABEceVXYuU/DbhtgltXHm4=
Date:   Sat, 21 Nov 2020 22:17:05 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, benh@kernel.crashing.org,
        dan.j.williams@intel.com, fenghua.yu@intel.com, hch@infradead.org,
        hch@lst.de, joao.m.martins@oracle.com, linux-mm@kvack.org,
        lkp@intel.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paulus@samba.org, rdunlap@infradead.org, sfr@canb.auug.org.au,
        tglx@linutronix.de, tony.luck@intel.com,
        torvalds@linux-foundation.org, vishal.l.verma@intel.com
Subject:  [patch 3/8] mm: fix phys_to_target_node() and
 memory_add_physaddr_to_nid() exports
Message-ID: <20201122061705.TKqNOM6WY%akpm@linux-foundation.org>
In-Reply-To: <20201121221631.948ae4655e913a319d61700a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: fix phys_to_target_node() and memory_add_physaddr_to_nid() exports

The core-mm has a default __weak implementation of phys_to_target_node()
to mirror the weak definition of memory_add_physaddr_to_nid().  That
symbol is exported for modules.  However, while the export in
mm/memory_hotplug.c exported the symbol in the configuration cases of:

	CONFIG_NUMA_KEEP_MEMINFO=y
	CONFIG_MEMORY_HOTPLUG=y

...and:

	CONFIG_NUMA_KEEP_MEMINFO=n
	CONFIG_MEMORY_HOTPLUG=y

...it failed to export the symbol in the case of:

	CONFIG_NUMA_KEEP_MEMINFO=y
	CONFIG_MEMORY_HOTPLUG=n

Not only is that broken, but Christoph points out that the kernel should
not be exporting any __weak symbol, which means that
memory_add_physaddr_to_nid() example that phys_to_target_node() copied is
broken too.

Rework the definition of phys_to_target_node() and
memory_add_physaddr_to_nid() to not require weak symbols.  Move to the
common arch override design-pattern of an asm header defining a symbol to
replace the default implementation.

The only common header that all memory_add_physaddr_to_nid() producing
architectures implement is asm/sparsemem.h.  In fact, powerpc already
defines its memory_add_physaddr_to_nid() helper in sparsemem.h. 
Double-down on that observation and define phys_to_target_node() where
necessary in asm/sparsemem.h.  An alternate consideration that was
discarded was to put this override in asm/numa.h, but that entangles with
the definition of MAX_NUMNODES relative to the inclusion of
linux/nodemask.h, and requires powerpc to grow a new header.

The dependency on NUMA_KEEP_MEMINFO for DEV_DAX_HMEM_DEVICES is invalid
now that the symbol is properly exported / stubbed in all combinations of
CONFIG_NUMA_KEEP_MEMINFO and CONFIG_MEMORY_HOTPLUG.

[dan.j.williams@intel.com: v4]
  Link: https://lkml.kernel.org/r/160461461867.1505359.5301571728749534585.stgit@dwillia2-desk3.amr.corp.intel.com
[dan.j.williams@intel.com: powerpc: fix create_section_mapping compile warning]
  Link: https://lkml.kernel.org/r/160558386174.2948926.2740149041249041764.stgit@dwillia2-desk3.amr.corp.intel.com
Link: https://lkml.kernel.org/r/160447639846.1133764.7044090803980177548.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: a035b6bf863e ("mm/memory_hotplug: introduce default phys_to_target_node() implementation")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/sparsemem.h    |    6 +++++
 arch/powerpc/include/asm/mmzone.h    |    5 ++++
 arch/powerpc/include/asm/sparsemem.h |    5 +---
 arch/powerpc/mm/mem.c                |    1 
 arch/x86/include/asm/sparsemem.h     |   10 ++++++++
 arch/x86/mm/numa.c                   |    2 +
 drivers/dax/Kconfig                  |    1 
 include/linux/memory_hotplug.h       |   14 -----------
 include/linux/numa.h                 |   30 ++++++++++++++++++++++++-
 mm/memory_hotplug.c                  |   18 ---------------
 10 files changed, 55 insertions(+), 37 deletions(-)

--- a/arch/ia64/include/asm/sparsemem.h~mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports
+++ a/arch/ia64/include/asm/sparsemem.h
@@ -18,4 +18,10 @@
 #endif
 
 #endif /* CONFIG_SPARSEMEM */
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+int memory_add_physaddr_to_nid(u64 addr);
+#define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
+#endif
+
 #endif /* _ASM_IA64_SPARSEMEM_H */
--- a/arch/powerpc/include/asm/mmzone.h~mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports
+++ a/arch/powerpc/include/asm/mmzone.h
@@ -46,5 +46,10 @@ u64 memory_hotplug_max(void);
 #define __HAVE_ARCH_RESERVED_KERNEL_PAGES
 #endif
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+extern int create_section_mapping(unsigned long start, unsigned long end,
+				  int nid, pgprot_t prot);
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_MMZONE_H_ */
--- a/arch/powerpc/include/asm/sparsemem.h~mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports
+++ a/arch/powerpc/include/asm/sparsemem.h
@@ -13,9 +13,9 @@
 #endif /* CONFIG_SPARSEMEM */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-extern int create_section_mapping(unsigned long start, unsigned long end,
-				  int nid, pgprot_t prot);
 extern int remove_section_mapping(unsigned long start, unsigned long end);
+extern int memory_add_physaddr_to_nid(u64 start);
+#define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
 
 #ifdef CONFIG_NUMA
 extern int hot_add_scn_to_nid(unsigned long scn_addr);
@@ -26,6 +26,5 @@ static inline int hot_add_scn_to_nid(uns
 }
 #endif /* CONFIG_NUMA */
 #endif /* CONFIG_MEMORY_HOTPLUG */
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_SPARSEMEM_H */
--- a/arch/powerpc/mm/mem.c~mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports
+++ a/arch/powerpc/mm/mem.c
@@ -50,6 +50,7 @@
 #include <asm/rtas.h>
 #include <asm/kasan.h>
 #include <asm/svm.h>
+#include <asm/mmzone.h>
 
 #include <mm/mmu_decl.h>
 
--- a/arch/x86/include/asm/sparsemem.h~mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports
+++ a/arch/x86/include/asm/sparsemem.h
@@ -28,4 +28,14 @@
 #endif
 
 #endif /* CONFIG_SPARSEMEM */
+
+#ifndef __ASSEMBLY__
+#ifdef CONFIG_NUMA_KEEP_MEMINFO
+extern int phys_to_target_node(phys_addr_t start);
+#define phys_to_target_node phys_to_target_node
+extern int memory_add_physaddr_to_nid(u64 start);
+#define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
+#endif
+#endif /* __ASSEMBLY__ */
+
 #endif /* _ASM_X86_SPARSEMEM_H */
--- a/arch/x86/mm/numa.c~mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports
+++ a/arch/x86/mm/numa.c
@@ -938,6 +938,7 @@ int phys_to_target_node(phys_addr_t star
 
 	return meminfo_to_nid(&numa_reserved_meminfo, start);
 }
+EXPORT_SYMBOL_GPL(phys_to_target_node);
 
 int memory_add_physaddr_to_nid(u64 start)
 {
@@ -947,4 +948,5 @@ int memory_add_physaddr_to_nid(u64 start
 		nid = numa_meminfo.blk[0].nid;
 	return nid;
 }
+EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 #endif
--- a/drivers/dax/Kconfig~mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports
+++ a/drivers/dax/Kconfig
@@ -50,7 +50,6 @@ config DEV_DAX_HMEM
 	  Say M if unsure.
 
 config DEV_DAX_HMEM_DEVICES
-	depends on NUMA_KEEP_MEMINFO # for phys_to_target_node()
 	depends on DEV_DAX_HMEM && DAX=y
 	def_bool y
 
--- a/include/linux/memory_hotplug.h~mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports
+++ a/include/linux/memory_hotplug.h
@@ -281,20 +281,6 @@ static inline bool movable_node_is_enabl
 }
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
-#ifdef CONFIG_NUMA
-extern int memory_add_physaddr_to_nid(u64 start);
-extern int phys_to_target_node(u64 start);
-#else
-static inline int memory_add_physaddr_to_nid(u64 start)
-{
-	return 0;
-}
-static inline int phys_to_target_node(u64 start)
-{
-	return 0;
-}
-#endif
-
 #if defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 /*
  * pgdat resizing functions
--- a/include/linux/numa.h~mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports
+++ a/include/linux/numa.h
@@ -21,13 +21,41 @@
 #endif
 
 #ifdef CONFIG_NUMA
+#include <linux/printk.h>
+#include <asm/sparsemem.h>
+
 /* Generic implementation available */
 int numa_map_to_online_node(int node);
-#else
+
+#ifndef memory_add_physaddr_to_nid
+static inline int memory_add_physaddr_to_nid(u64 start)
+{
+	pr_info_once("Unknown online node for memory at 0x%llx, assuming node 0\n",
+			start);
+	return 0;
+}
+#endif
+#ifndef phys_to_target_node
+static inline int phys_to_target_node(u64 start)
+{
+	pr_info_once("Unknown target node for memory at 0x%llx, assuming node 0\n",
+			start);
+	return 0;
+}
+#endif
+#else /* !CONFIG_NUMA */
 static inline int numa_map_to_online_node(int node)
 {
 	return NUMA_NO_NODE;
 }
+static inline int memory_add_physaddr_to_nid(u64 start)
+{
+	return 0;
+}
+static inline int phys_to_target_node(u64 start)
+{
+	return 0;
+}
 #endif
 
 #endif /* _LINUX_NUMA_H */
--- a/mm/memory_hotplug.c~mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports
+++ a/mm/memory_hotplug.c
@@ -350,24 +350,6 @@ int __ref __add_pages(int nid, unsigned
 	return err;
 }
 
-#ifdef CONFIG_NUMA
-int __weak memory_add_physaddr_to_nid(u64 start)
-{
-	pr_info_once("Unknown online node for memory at 0x%llx, assuming node 0\n",
-			start);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
-
-int __weak phys_to_target_node(u64 start)
-{
-	pr_info_once("Unknown target node for memory at 0x%llx, assuming node 0\n",
-			start);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(phys_to_target_node);
-#endif
-
 /* find the smallest valid pfn in the range [start_pfn, end_pfn) */
 static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
 				     unsigned long start_pfn,
_
