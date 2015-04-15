From: akpm@linux-foundation.org
Subject: [merged] lib-add-huge-i-o-map-capability-interfaces.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:11:15 -0700
Message-ID: <552eb7d3.iOmWUDEdol7jiNkj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933377AbbDOTLQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:11:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, arnd@arndb.de, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/ioremap.c: add huge I/O map capability interfaces
has been removed from the -mm tree.  Its filename was
     lib-add-huge-i-o-map-capability-interfaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: lib/ioremap.c: add huge I/O map capability interfaces

Add ioremap_pud_enabled() and ioremap_pmd_enabled(), which return 1 when
I/O mappings with pud/pmd are enabled on the kernel.

ioremap_huge_init() calls arch_ioremap_pud_supported() and
arch_ioremap_pmd_supported() to initialize the capabilities at boot-time.

A new kernel option "nohugeiomap" is also added, so that user can disable
the huge I/O map capabilities when necessary.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Robert Elliott <Elliott@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 +
 arch/Kconfig                        |    3 ++
 include/linux/io.h                  |    8 +++++
 init/main.c                         |    2 +
 lib/ioremap.c                       |   37 ++++++++++++++++++++++++++
 5 files changed, 52 insertions(+)

diff -puN Documentation/kernel-parameters.txt~lib-add-huge-i-o-map-capability-interfaces Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~lib-add-huge-i-o-map-capability-interfaces
+++ a/Documentation/kernel-parameters.txt
@@ -2323,6 +2323,8 @@ bytes respectively. Such letter suffixes
 			register save and restore. The kernel will only save
 			legacy floating-point registers on task switch.
 
+	nohugeiomap	[KNL,x86] Disable kernel huge I/O mappings.
+
 	noxsave		[BUGS=X86] Disables x86 extended register state save
 			and restore using xsave. The kernel will fallback to
 			enabling legacy floating-point and sse state.
diff -puN arch/Kconfig~lib-add-huge-i-o-map-capability-interfaces arch/Kconfig
--- a/arch/Kconfig~lib-add-huge-i-o-map-capability-interfaces
+++ a/arch/Kconfig
@@ -446,6 +446,9 @@ config HAVE_IRQ_TIME_ACCOUNTING
 config HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	bool
 
+config HAVE_ARCH_HUGE_VMAP
+	bool
+
 config HAVE_ARCH_SOFT_DIRTY
 	bool
 
diff -puN include/linux/io.h~lib-add-huge-i-o-map-capability-interfaces include/linux/io.h
--- a/include/linux/io.h~lib-add-huge-i-o-map-capability-interfaces
+++ a/include/linux/io.h
@@ -38,6 +38,14 @@ static inline int ioremap_page_range(uns
 }
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
+void __init ioremap_huge_init(void);
+int arch_ioremap_pud_supported(void);
+int arch_ioremap_pmd_supported(void);
+#else
+static inline void ioremap_huge_init(void) { }
+#endif
+
 /*
  * Managed iomap interface
  */
diff -puN init/main.c~lib-add-huge-i-o-map-capability-interfaces init/main.c
--- a/init/main.c~lib-add-huge-i-o-map-capability-interfaces
+++ a/init/main.c
@@ -80,6 +80,7 @@
 #include <linux/list.h>
 #include <linux/integrity.h>
 #include <linux/proc_ns.h>
+#include <linux/io.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -484,6 +485,7 @@ static void __init mm_init(void)
 	percpu_init_late();
 	pgtable_init();
 	vmalloc_init();
+	ioremap_huge_init();
 }
 
 asmlinkage __visible void __init start_kernel(void)
diff -puN lib/ioremap.c~lib-add-huge-i-o-map-capability-interfaces lib/ioremap.c
--- a/lib/ioremap.c~lib-add-huge-i-o-map-capability-interfaces
+++ a/lib/ioremap.c
@@ -13,6 +13,43 @@
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
+int __read_mostly ioremap_pud_capable;
+int __read_mostly ioremap_pmd_capable;
+int __read_mostly ioremap_huge_disabled;
+
+static int __init set_nohugeiomap(char *str)
+{
+	ioremap_huge_disabled = 1;
+	return 0;
+}
+early_param("nohugeiomap", set_nohugeiomap);
+
+void __init ioremap_huge_init(void)
+{
+	if (!ioremap_huge_disabled) {
+		if (arch_ioremap_pud_supported())
+			ioremap_pud_capable = 1;
+		if (arch_ioremap_pmd_supported())
+			ioremap_pmd_capable = 1;
+	}
+}
+
+static inline int ioremap_pud_enabled(void)
+{
+	return ioremap_pud_capable;
+}
+
+static inline int ioremap_pmd_enabled(void)
+{
+	return ioremap_pmd_capable;
+}
+
+#else	/* !CONFIG_HAVE_ARCH_HUGE_VMAP */
+static inline int ioremap_pud_enabled(void) { return 0; }
+static inline int ioremap_pmd_enabled(void) { return 0; }
+#endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
+
 static int ioremap_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
_

Patches currently in -mm which might be from toshi.kani@hp.com are

origin.patch
mm-x86-document-return-values-of-mapping-funcs.patch
mtrr-x86-fix-mtrr-lookup-to-handle-inclusive-entry.patch
mtrr-x86-remove-a-wrong-address-check-in-__mtrr_type_lookup.patch
mtrr-x86-fix-mtrr-state-checks-in-mtrr_type_lookup.patch
mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup.patch
mtrr-x86-clean-up-mtrr_type_lookup.patch
mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping.patch

