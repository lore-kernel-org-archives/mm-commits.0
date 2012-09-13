From: akpm@linux-foundation.org
Subject: + sections-disable-const-sections-for-pa-risc-v2.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:36:35 -0700
Message-ID: <20120913233636.43F191E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:45426 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759117Ab2IMXgh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:36:37 -0400
Received: by ghbz15 with SMTP id z15so201480ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:36:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, deller@gmx.de, jejb@parisc-linux.org, sam@ravnborg.org


The patch titled
     Subject: sections: disable const sections for PA-RISC v2
has been added to the -mm tree.  Its filename is
     sections-disable-const-sections-for-pa-risc-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1614,4 +1614,10 @@ config PADATA
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

compilerh-add-__visible.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
sections-disable-const-sections-for-pa-risc-v2.patch
sections-fix-section-conflicts-in-arch-arm.patch
sections-fix-section-conflicts-in-arch-frv.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-arch-ia64.patch
sections-fix-section-conflicts-in-arch-mips.patch
sections-fix-section-conflicts-in-arch-powerpc.patch
sections-fix-section-conflicts-in-arch-score.patch
sections-fix-section-conflicts-in-arch-sh.patch
sections-fix-section-conflicts-in-arch-x86.patch
sections-fix-section-conflicts-in-drivers-atm.patch
sections-fix-section-conflicts-in-drivers-char.patch
sections-fix-section-conflicts-in-drivers-cpufreq.patch
sections-fix-section-conflicts-in-drivers-ide.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sections-fix-section-conflicts-in-drivers-mfd.patch
sections-fix-section-conflicts-in-drivers-mmc.patch
sections-fix-section-conflicts-in-drivers-net.patch
sections-fix-section-conflicts-in-drivers-net-hamradio.patch
sections-fix-section-conflicts-in-drivers-net-wan.patch
sections-fix-section-conflicts-in-drivers-platform-x86.patch
sections-fix-section-conflicts-in-drivers-scsi.patch
sections-fix-section-conflicts-in-drivers-video.patch
sections-fix-section-conflicts-in-mm-percpuc.patch
sections-fix-section-conflicts-in-net-can.patch
sections-fix-section-conflicts-in-net.patch
sections-fix-section-conflicts-in-sound.patch
sectons-fix-const-sections-for-crc32-table.patch
compat_ioctl-remove-unused-local-typedef.patch

