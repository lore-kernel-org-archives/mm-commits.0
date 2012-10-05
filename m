From: akpm@linux-foundation.org
Subject: [merged] sections-disable-const-sections-for-pa-risc-v2.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:08 -0700
Message-ID: <20121005201209.2BED020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:46749 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab2JEUML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:11 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so139738wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, deller@gmx.de, jejb@parisc-linux.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: disable const sections for PA-RISC v2
has been removed from the -mm tree.  Its filename was
     sections-disable-const-sections-for-pa-risc-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: disable const sections for PA-RISC v2

The PA-RISC tool chain seems to have some problem with correct read/write
attributes on sections. This causes problems when the const sections
are fixed up for other architecture to only contain truly read-only
data.

Disable const sections for PA-RISC

This can cause a bit of noise with modpost.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/Kconfig  |    1 +
 include/linux/init.h |   27 +++++++++++++++++++--------
 init/Kconfig         |    6 ++++++
 3 files changed, 26 insertions(+), 8 deletions(-)

diff -puN arch/parisc/Kconfig~sections-disable-const-sections-for-pa-risc-v2 arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~sections-disable-const-sections-for-pa-risc-v2
+++ a/arch/parisc/Kconfig
@@ -13,6 +13,7 @@ config PARISC
 	select HAVE_PERF_EVENTS
 	select GENERIC_ATOMIC64 if !64BIT
 	select HAVE_GENERIC_HARDIRQS
+	select BROKEN_RODATA
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PCI_IOMAP
 	select IRQ_PER_CPU
diff -puN include/linux/init.h~sections-disable-const-sections-for-pa-risc-v2 include/linux/init.h
--- a/include/linux/init.h~sections-disable-const-sections-for-pa-risc-v2
+++ a/include/linux/init.h
@@ -43,11 +43,22 @@
    discard it in modules) */
 #define __init		__section(.init.text) __cold notrace
 #define __initdata	__section(.init.data)
-#define __initconst	__section(.init.rodata)
+#define __initconst	__constsection(.init.rodata)
 #define __exitdata	__section(.exit.data)
 #define __exit_call	__used __section(.exitcall.exit)
 
 /*
+ * Some architecture have tool chains which do not handle rodata attributes
+ * correctly. For those disable special sections for const, so that other
+ * architectures can annotate correctly.
+ */
+#ifdef CONFIG_BROKEN_RODATA
+#define __constsection(x)
+#else
+#define __constsection(x) __section(x)
+#endif
+
+/*
  * modpost check for section mismatches during the kernel build.
  * A section mismatch happens when there are references from a
  * code or data section to an init section (both code or data).
@@ -66,7 +77,7 @@
  */
 #define __ref            __section(.ref.text) noinline
 #define __refdata        __section(.ref.data)
-#define __refconst       __section(.ref.rodata)
+#define __refconst       __constsection(.ref.rodata)
 
 /* compatibility defines */
 #define __init_refok     __ref
@@ -85,26 +96,26 @@
 /* Used for HOTPLUG */
 #define __devinit        __section(.devinit.text) __cold notrace
 #define __devinitdata    __section(.devinit.data)
-#define __devinitconst   __section(.devinit.rodata)
+#define __devinitconst   __constsection(.devinit.rodata)
 #define __devexit        __section(.devexit.text) __exitused __cold notrace
 #define __devexitdata    __section(.devexit.data)
-#define __devexitconst   __section(.devexit.rodata)
+#define __devexitconst   __constsection(.devexit.rodata)
 
 /* Used for HOTPLUG_CPU */
 #define __cpuinit        __section(.cpuinit.text) __cold notrace
 #define __cpuinitdata    __section(.cpuinit.data)
-#define __cpuinitconst   __section(.cpuinit.rodata)
+#define __cpuinitconst   __constsection(.cpuinit.rodata)
 #define __cpuexit        __section(.cpuexit.text) __exitused __cold notrace
 #define __cpuexitdata    __section(.cpuexit.data)
-#define __cpuexitconst   __section(.cpuexit.rodata)
+#define __cpuexitconst   __constsection(.cpuexit.rodata)
 
 /* Used for MEMORY_HOTPLUG */
 #define __meminit        __section(.meminit.text) __cold notrace
 #define __meminitdata    __section(.meminit.data)
-#define __meminitconst   __section(.meminit.rodata)
+#define __meminitconst   __constsection(.meminit.rodata)
 #define __memexit        __section(.memexit.text) __exitused __cold notrace
 #define __memexitdata    __section(.memexit.data)
-#define __memexitconst   __section(.memexit.rodata)
+#define __memexitconst   __constsection(.memexit.rodata)
 
 /* For assembly routines */
 #define __HEAD		.section	".head.text","ax"
diff -puN init/Kconfig~sections-disable-const-sections-for-pa-risc-v2 init/Kconfig
--- a/init/Kconfig~sections-disable-const-sections-for-pa-risc-v2
+++ a/init/Kconfig
@@ -1581,4 +1581,10 @@ config PADATA
 	depends on SMP
 	bool
 
+# Can be selected by architectures with broken toolchains
+# that get confused by correct const<->read_only section
+# mappings
+config BROKEN_RODATA
+	bool
+
 source "kernel/Kconfig.locks"
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

