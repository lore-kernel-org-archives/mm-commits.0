From: akpm@linux-foundation.org
Subject: + add-an-option-for-the-via-c7-which-sets-appropriate-l1.patch added to -mm tree
Date: Wed, 14 Feb 2007 13:16:22 -0800
Message-ID: <200702142116.l1ELGMWw009385@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46203 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932617AbXBNVRY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 16:17:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: simon@arlott.org, ak@suse.de, alan@lxorguk.ukuu.org.uk, davej@codemonkey.org.uk, simon@fire.lp0.eu


The patch titled
     Add an option for the VIA C7 which sets appropriate L1 cache
has been added to the -mm tree.  Its filename is
     add-an-option-for-the-via-c7-which-sets-appropriate-l1.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add an option for the VIA C7 which sets appropriate L1 cache
From: Simon Arlott <simon@arlott.org>

The VIA C7 is a 686 (with TSC) that supports MMX, SSE and SSE2, it also has
a cache line length of 64 according to
http://www.digit-life.com/articles2/cpu/rmma-via-c7.html.  This patch sets
gcc to -march=686 and select s the correct cache shift.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig.cpu     |   13 ++++++++++---
 arch/i386/Makefile.cpu    |    1 +
 arch/i386/defconfig       |    1 +
 arch/um/defconfig         |    1 +
 include/asm-i386/module.h |    2 ++
 5 files changed, 15 insertions(+), 3 deletions(-)

diff -puN arch/i386/Kconfig.cpu~add-an-option-for-the-via-c7-which-sets-appropriate-l1 arch/i386/Kconfig.cpu
--- a/arch/i386/Kconfig.cpu~add-an-option-for-the-via-c7-which-sets-appropriate-l1
+++ a/arch/i386/Kconfig.cpu
@@ -43,6 +43,7 @@ config M386
 	  - "Geode GX/LX" For AMD Geode GX and LX processors.
 	  - "CyrixIII/VIA C3" for VIA Cyrix III or VIA C3.
 	  - "VIA C3-2" for VIA C3-2 "Nehemiah" (model 9 and above).
+	  - "VIA C7" for VIA C7.
 
 	  If you don't know what to do, choose "386".
 
@@ -203,6 +204,12 @@ config MVIAC3_2
 	  of SSE and tells gcc to treat the CPU as a 686.
 	  Note, this kernel will not boot on older (pre model 9) C3s.
 
+config MVIAC7
+	bool "VIA C7"
+	help
+	  Select this for a VIA C7.  Selecting this uses the correct cache
+	  shift and tells gcc to treat the CPU as a 686.
+
 endchoice
 
 config X86_GENERIC
@@ -231,7 +238,7 @@ config X86_L1_CACHE_SHIFT
 	default "7" if MPENTIUM4 || X86_GENERIC
 	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
-	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2
+	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
@@ -297,7 +304,7 @@ config X86_ALIGNMENT_16
 
 config X86_GOOD_APIC
 	bool
-	depends on MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || MK8 || MEFFICEON || MCORE2
+	depends on MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || MK8 || MEFFICEON || MCORE2 || MVIAC7
 	default y
 
 config X86_INTEL_USERCOPY
@@ -322,5 +329,5 @@ config X86_OOSTORE
 
 config X86_TSC
 	bool
-	depends on (MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ
+	depends on (MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ
 	default y
diff -puN arch/i386/Makefile.cpu~add-an-option-for-the-via-c7-which-sets-appropriate-l1 arch/i386/Makefile.cpu
--- a/arch/i386/Makefile.cpu~add-an-option-for-the-via-c7-which-sets-appropriate-l1
+++ a/arch/i386/Makefile.cpu
@@ -32,6 +32,7 @@ cflags-$(CONFIG_MWINCHIP2)	+= $(call cc-
 cflags-$(CONFIG_MWINCHIP3D)	+= $(call cc-option,-march=winchip2,-march=i586)
 cflags-$(CONFIG_MCYRIXIII)	+= $(call cc-option,-march=c3,-march=i486) $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MVIAC3_2)	+= $(call cc-option,-march=c3-2,-march=i686)
+cflags-$(CONFIG_MVIAC7)		+= -march=i686
 cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call cc-option,-mtune=core2,$(call cc-option,-mtune=generic,-mtune=i686))
 
 # AMD Elan support
diff -puN arch/i386/defconfig~add-an-option-for-the-via-c7-which-sets-appropriate-l1 arch/i386/defconfig
--- a/arch/i386/defconfig~add-an-option-for-the-via-c7-which-sets-appropriate-l1
+++ a/arch/i386/defconfig
@@ -137,6 +137,7 @@ CONFIG_MPENTIUMIII=y
 # CONFIG_MGEODE_LX is not set
 # CONFIG_MCYRIXIII is not set
 # CONFIG_MVIAC3_2 is not set
+# CONFIG_MVIAC7 is not set
 CONFIG_X86_GENERIC=y
 CONFIG_X86_CMPXCHG=y
 CONFIG_X86_L1_CACHE_SHIFT=7
diff -puN arch/um/defconfig~add-an-option-for-the-via-c7-which-sets-appropriate-l1 arch/um/defconfig
--- a/arch/um/defconfig~add-an-option-for-the-via-c7-which-sets-appropriate-l1
+++ a/arch/um/defconfig
@@ -41,6 +41,7 @@ CONFIG_M686=y
 # CONFIG_MGEODE_LX is not set
 # CONFIG_MCYRIXIII is not set
 # CONFIG_MVIAC3_2 is not set
+# CONFIG_MVIAC7 is not set
 # CONFIG_X86_GENERIC is not set
 CONFIG_X86_CMPXCHG=y
 CONFIG_X86_XADD=y
diff -puN include/asm-i386/module.h~add-an-option-for-the-via-c7-which-sets-appropriate-l1 include/asm-i386/module.h
--- a/include/asm-i386/module.h~add-an-option-for-the-via-c7-which-sets-appropriate-l1
+++ a/include/asm-i386/module.h
@@ -54,6 +54,8 @@ struct mod_arch_specific
 #define MODULE_PROC_FAMILY "CYRIXIII "
 #elif defined CONFIG_MVIAC3_2
 #define MODULE_PROC_FAMILY "VIAC3-2 "
+#elif defined CONFIG_MVIAC7
+#define MODULE_PROC_FAMILY "VIAC7 "
 #elif defined CONFIG_MGEODEGX1
 #define MODULE_PROC_FAMILY "GEODEGX1 "
 #elif defined CONFIG_MGEODE_LX
_

Patches currently in -mm which might be from simon@arlott.org are

add-an-option-for-the-via-c7-which-sets-appropriate-l1.patch
