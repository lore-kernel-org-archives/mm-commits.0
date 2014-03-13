From: akpm@linux-foundation.org
Subject: + mm-create-generic-early_ioremap-support.patch added to -mm tree
Date: Thu, 13 Mar 2014 13:51:58 -0700
Message-ID: <53221a6e.4szgbuGWQNbNGS6E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaCMUv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Mar 2014 16:51:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, dyoung@redhat.com, catalin.marinas@arm.com, borislav.petkov@amd.com, msalter@redhat.com

Subject: + mm-create-generic-early_ioremap-support.patch added to -mm tree
To: msalter@redhat.com,borislav.petkov@amd.com,catalin.marinas@arm.com,dyoung@redhat.com,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,will.deacon@arm.com
From: akpm@linux-foundation.org
Date: Thu, 13 Mar 2014 13:51:58 -0700


The patch titled
     Subject: mm: create generic early_ioremap() support
has been added to the -mm tree.  Its filename is
     mm-create-generic-early_ioremap-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-create-generic-early_ioremap-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-create-generic-early_ioremap-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: mm: create generic early_ioremap() support

This patch creates a generic implementation of early_ioremap() support
based on the existing x86 implementation.  early_ioremp() is useful for
early boot code which needs to temporarily map I/O or memory regions
before normal mapping functions such as ioremap() are available.

Some architectures have optional MMU.  In the no-MMU case, the remap
functions simply return the passed in physical address and the unmap
functions do nothing.

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/early_ioremap.h |   42 ++++
 mm/Kconfig                          |    3 
 mm/Makefile                         |    1 
 mm/early_ioremap.c                  |  245 ++++++++++++++++++++++++++
 4 files changed, 291 insertions(+)

diff -puN /dev/null include/asm-generic/early_ioremap.h
--- /dev/null
+++ a/include/asm-generic/early_ioremap.h
@@ -0,0 +1,42 @@
+#ifndef _ASM_EARLY_IOREMAP_H_
+#define _ASM_EARLY_IOREMAP_H_
+
+#include <linux/types.h>
+
+/*
+ * early_ioremap() and early_iounmap() are for temporary early boot-time
+ * mappings, before the real ioremap() is functional.
+ */
+extern void __iomem *early_ioremap(resource_size_t phys_addr,
+				   unsigned long size);
+extern void *early_memremap(resource_size_t phys_addr,
+			    unsigned long size);
+extern void early_iounmap(void __iomem *addr, unsigned long size);
+extern void early_memunmap(void *addr, unsigned long size);
+
+/*
+ * Weak function called by early_ioremap_reset(). It does nothing, but
+ * architectures may provide their own version to do any needed cleanups.
+ */
+extern void early_ioremap_shutdown(void);
+
+#if defined(CONFIG_GENERIC_EARLY_IOREMAP) && defined(CONFIG_MMU)
+/* Arch-specific initialization */
+extern void early_ioremap_init(void);
+
+/* Generic initialization called by architecture code */
+extern void early_ioremap_setup(void);
+
+/*
+ * Called as last step in paging_init() so library can act
+ * accordingly for subsequent map/unmap requests.
+ */
+extern void early_ioremap_reset(void);
+
+#else
+static inline void early_ioremap_init(void) { }
+static inline void early_ioremap_setup(void) { }
+static inline void early_ioremap_reset(void) { }
+#endif
+
+#endif /* _ASM_EARLY_IOREMAP_H_ */
diff -puN mm/Kconfig~mm-create-generic-early_ioremap-support mm/Kconfig
--- a/mm/Kconfig~mm-create-generic-early_ioremap-support
+++ a/mm/Kconfig
@@ -578,3 +578,6 @@ config PGTABLE_MAPPING
 
 	  You can check speed with zsmalloc benchmark:
 	  https://github.com/spartacus06/zsmapbench
+
+config GENERIC_EARLY_IOREMAP
+	bool
diff -puN mm/Makefile~mm-create-generic-early_ioremap-support mm/Makefile
--- a/mm/Makefile~mm-create-generic-early_ioremap-support
+++ a/mm/Makefile
@@ -61,3 +61,4 @@ obj-$(CONFIG_CLEANCACHE) += cleancache.o
 obj-$(CONFIG_MEMORY_ISOLATION) += page_isolation.o
 obj-$(CONFIG_ZBUD)	+= zbud.o
 obj-$(CONFIG_ZSMALLOC)	+= zsmalloc.o
+obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
diff -puN /dev/null mm/early_ioremap.c
--- /dev/null
+++ a/mm/early_ioremap.c
@@ -0,0 +1,245 @@
+/*
+ * Provide common bits of early_ioremap() support for architectures needing
+ * temporary mappings during boot before ioremap() is available.
+ *
+ * This is mostly a direct copy of the x86 early_ioremap implementation.
+ *
+ * (C) Copyright 1995 1996, 2014 Linus Torvalds
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <asm/fixmap.h>
+
+#ifdef CONFIG_MMU
+static int early_ioremap_debug __initdata;
+
+static int __init early_ioremap_debug_setup(char *str)
+{
+	early_ioremap_debug = 1;
+
+	return 0;
+}
+early_param("early_ioremap_debug", early_ioremap_debug_setup);
+
+static int after_paging_init __initdata;
+
+void __init __weak early_ioremap_shutdown(void)
+{
+}
+
+void __init early_ioremap_reset(void)
+{
+	early_ioremap_shutdown();
+	after_paging_init = 1;
+}
+
+/*
+ * Generally, ioremap() is available after paging_init() has been called.
+ * Architectures wanting to allow early_ioremap after paging_init() can
+ * define __late_set_fixmap and __late_clear_fixmap to do the right thing.
+ */
+#ifndef __late_set_fixmap
+static inline void __init __late_set_fixmap(enum fixed_addresses idx,
+					    phys_addr_t phys, pgprot_t prot)
+{
+	BUG();
+}
+#endif
+
+#ifndef __late_clear_fixmap
+static inline void __init __late_clear_fixmap(enum fixed_addresses idx)
+{
+	BUG();
+}
+#endif
+
+static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
+static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
+static unsigned long slot_virt[FIX_BTMAPS_SLOTS] __initdata;
+
+void __init early_ioremap_setup(void)
+{
+	int i;
+
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
+		if (WARN_ON(prev_map[i]))
+			break;
+
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
+		slot_virt[i] = __fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
+}
+
+static int __init check_early_ioremap_leak(void)
+{
+	int count = 0;
+	int i;
+
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
+		if (prev_map[i])
+			count++;
+
+	if (WARN(count, KERN_WARNING
+		 "Debug warning: early ioremap leak of %d areas detected.\n"
+		 "please boot with early_ioremap_debug and report the dmesg.\n",
+		 count))
+		return 1;
+	return 0;
+}
+late_initcall(check_early_ioremap_leak);
+
+static void __init __iomem *
+__early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
+{
+	unsigned long offset;
+	resource_size_t last_addr;
+	unsigned int nrpages;
+	enum fixed_addresses idx;
+	int i, slot;
+
+	WARN_ON(system_state != SYSTEM_BOOTING);
+
+	slot = -1;
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (!prev_map[i]) {
+			slot = i;
+			break;
+		}
+	}
+
+	if (WARN(slot < 0, "%s(%08llx, %08lx) not found slot\n",
+		 __func__, (u64)phys_addr, size))
+		return NULL;
+
+	/* Don't allow wraparound or zero size */
+	last_addr = phys_addr + size - 1;
+	if (WARN_ON(!size || last_addr < phys_addr))
+		return NULL;
+
+	prev_size[slot] = size;
+	/*
+	 * Mappings have to be page-aligned
+	 */
+	offset = phys_addr & ~PAGE_MASK;
+	phys_addr &= PAGE_MASK;
+	size = PAGE_ALIGN(last_addr + 1) - phys_addr;
+
+	/*
+	 * Mappings have to fit in the FIX_BTMAP area.
+	 */
+	nrpages = size >> PAGE_SHIFT;
+	if (WARN_ON(nrpages > NR_FIX_BTMAPS))
+		return NULL;
+
+	/*
+	 * Ok, go for it..
+	 */
+	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
+	while (nrpages > 0) {
+		if (after_paging_init)
+			__late_set_fixmap(idx, phys_addr, prot);
+		else
+			__early_set_fixmap(idx, phys_addr, prot);
+		phys_addr += PAGE_SIZE;
+		--idx;
+		--nrpages;
+	}
+	WARN(early_ioremap_debug, "%s(%08llx, %08lx) [%d] => %08lx + %08lx\n",
+	     __func__, (u64)phys_addr, size, slot, offset, slot_virt[slot]);
+
+	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
+	return prev_map[slot];
+}
+
+void __init early_iounmap(void __iomem *addr, unsigned long size)
+{
+	unsigned long virt_addr;
+	unsigned long offset;
+	unsigned int nrpages;
+	enum fixed_addresses idx;
+	int i, slot;
+
+	slot = -1;
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (prev_map[i] == addr) {
+			slot = i;
+			break;
+		}
+	}
+
+	if (WARN(slot < 0, "early_iounmap(%p, %08lx) not found slot\n",
+		 addr, size))
+		return;
+
+	if (WARN(prev_size[slot] != size,
+		 "early_iounmap(%p, %08lx) [%d] size not consistent %08lx\n",
+		 addr, size, slot, prev_size[slot]))
+		return;
+
+	WARN(early_ioremap_debug, "early_iounmap(%p, %08lx) [%d]\n",
+	     addr, size, slot);
+
+	virt_addr = (unsigned long)addr;
+	if (WARN_ON(virt_addr < fix_to_virt(FIX_BTMAP_BEGIN)))
+		return;
+
+	offset = virt_addr & ~PAGE_MASK;
+	nrpages = PAGE_ALIGN(offset + size) >> PAGE_SHIFT;
+
+	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
+	while (nrpages > 0) {
+		if (after_paging_init)
+			__late_clear_fixmap(idx);
+		else
+			__early_set_fixmap(idx, 0, FIXMAP_PAGE_CLEAR);
+		--idx;
+		--nrpages;
+	}
+	prev_map[slot] = NULL;
+}
+
+/* Remap an IO device */
+void __init __iomem *
+early_ioremap(resource_size_t phys_addr, unsigned long size)
+{
+	return __early_ioremap(phys_addr, size, FIXMAP_PAGE_IO);
+}
+
+/* Remap memory */
+void __init *
+early_memremap(resource_size_t phys_addr, unsigned long size)
+{
+	return (__force void *)__early_ioremap(phys_addr, size,
+					       FIXMAP_PAGE_NORMAL);
+}
+#else /* CONFIG_MMU */
+
+void __init __iomem *
+early_ioremap(resource_size_t phys_addr, unsigned long size)
+{
+	return (__force void __iomem *)phys_addr;
+}
+
+/* Remap memory */
+void __init *
+early_memremap(resource_size_t phys_addr, unsigned long size)
+{
+	return (void *)phys_addr;
+}
+
+void __init early_iounmap(void __iomem *addr, unsigned long size)
+{
+}
+
+#endif /* CONFIG_MMU */
+
+
+void __init early_memunmap(void *addr, unsigned long size)
+{
+	early_iounmap((__force void __iomem *)addr, size);
+}
_

Patches currently in -mm which might be from msalter@redhat.com are

arm-use-generic-fixmaph.patch
x86-mm-sparse-warning-fix-for-early_memremap.patch
mm-create-generic-early_ioremap-support.patch
x86-use-generic-early_ioremap.patch
arm64-initialize-pgprot-info-earlier-in-boot.patch
arm64-add-early_ioremap-support.patch
doc-kernel-parameterstxt-add-early_ioremap_debug.patch

