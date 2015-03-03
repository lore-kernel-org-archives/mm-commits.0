From: akpm@linux-foundation.org
Subject: + lib-add-huge-i-o-map-capability-interfaces.patch added to -mm
 tree
Date: Tue, 03 Mar 2015 14:45:58 -0800
Message-ID: <54f639a6.QKLEgaPb39RIxTRA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbbCCWp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 17:45:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, arnd@arndb.de, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/ioremap.c: add huge I/O map capability interfaces
has been added to the -mm tree.  Its filename is
     lib-add-huge-i-o-map-capability-interfaces.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-huge-i-o-map-capability-interfaces.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-huge-i-o-map-capability-interfaces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 include/linux/io.h                  |    7 ++++
 init/main.c                         |    2 +
 lib/ioremap.c                       |   38 ++++++++++++++++++++++++++
 5 files changed, 52 insertions(+)

diff -puN Documentation/kernel-parameters.txt~lib-add-huge-i-o-map-capability-interfaces Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~lib-add-huge-i-o-map-capability-interfaces
+++ a/Documentation/kernel-parameters.txt
@@ -2322,6 +2322,8 @@ bytes respectively. Such letter suffixes
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
@@ -38,6 +38,13 @@ static inline int ioremap_page_range(uns
 }
 #endif
 
+void __init ioremap_huge_init(void);
+
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
+int arch_ioremap_pud_supported(void);
+int arch_ioremap_pmd_supported(void);
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
@@ -13,6 +13,44 @@
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
+void __init ioremap_huge_init(void) { }
+static inline int ioremap_pud_enabled(void) { return 0; }
+static inline int ioremap_pmd_enabled(void) { return 0; }
+#endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
+
 static int ioremap_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
_

Patches currently in -mm which might be from toshi.kani@hp.com are

mm-change-__get_vm_area_node-to-use-fls_long.patch
lib-add-huge-i-o-map-capability-interfaces.patch
mm-change-ioremap-to-set-up-huge-i-o-mappings.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings.patch
x86-mm-support-huge-i-o-mapping-capability-i-f.patch
x86-mm-support-huge-kva-mappings-on-x86.patch

