From: akpm@linux-foundation.org
Subject: + x86-x86_physvirt_bits-field-also-for-i386.patch added to -mm tree
Date: Tue, 02 Sep 2008 15:08:55 -0700
Message-ID: <200809022208.m82M8te6015254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbYIBWJw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 18:09:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: x86_{phys,virt}_bits field also for i386
has been added to the -mm tree.  Its filename is
     x86-x86_physvirt_bits-field-also-for-i386.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: x86_{phys,virt}_bits field also for i386
From: Jan Beulich <jbeulich@novell.com>

Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use the
former in ioremap's phys_addr_valid() check also on 32bit/PAE.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/common.c |   18 ++++++++++++++++++
 arch/x86/mm/ioremap.c        |   15 ++++++---------
 include/asm-x86/processor.h  |    4 ++--
 3 files changed, 26 insertions(+), 11 deletions(-)

diff -puN arch/x86/kernel/cpu/common.c~x86-x86_physvirt_bits-field-also-for-i386 arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~x86-x86_physvirt_bits-field-also-for-i386
+++ a/arch/x86/kernel/cpu/common.c
@@ -306,6 +306,18 @@ static void __cpuinit early_get_cap(stru
 				c->x86_capability[1] = cpuid_edx(0x80000001);
 				c->x86_capability[6] = cpuid_ecx(0x80000001);
 			}
+			if (xlvl >= 0x80000008) {
+				u32 eax = cpuid_eax(0x80000008);
+
+				c->x86_phys_bits = eax & 0xff;
+				c->x86_virt_bits = (eax >> 8) & 0xff;
+				/* CPUID workaround for Intel 0F33/0F34 CPU */
+				if (c->x86_vendor == X86_VENDOR_INTEL
+				    && c->x86 == 0xF && c->x86_model == 0x3
+				    && (c->x86_mask == 0x3
+					|| c->x86_mask == 0x4))
+					c->x86_phys_bits = 36;
+			}
 		}
 
 	}
@@ -327,6 +339,12 @@ static void __init early_cpu_detect(void
 
 	c->x86_cache_alignment = 32;
 	c->x86_clflush_size = 32;
+#ifdef CONFIG_X86_PAE
+	c->x86_phys_bits = 36;
+#else
+	c->x86_phys_bits = 32;
+#endif
+	c->x86_virt_bits = 32;
 
 	if (!have_cpuid_p())
 		return;
diff -puN arch/x86/mm/ioremap.c~x86-x86_physvirt_bits-field-also-for-i386 arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-x86_physvirt_bits-field-also-for-i386
+++ a/arch/x86/mm/ioremap.c
@@ -32,19 +32,16 @@ unsigned long __phys_addr(unsigned long 
 }
 EXPORT_SYMBOL(__phys_addr);
 
-static inline int phys_addr_valid(unsigned long addr)
-{
-	return addr < (1UL << boot_cpu_data.x86_phys_bits);
-}
-
-#else
+#endif
 
-static inline int phys_addr_valid(unsigned long addr)
+static inline int phys_addr_valid(resource_size_t addr)
 {
+#ifdef CONFIG_RESOURCES_64BIT
+	return !(addr >> boot_cpu_data.x86_phys_bits);
+#else
 	return 1;
-}
-
 #endif
+}
 
 int page_is_ram(unsigned long pagenr)
 {
diff -puN include/asm-x86/processor.h~x86-x86_physvirt_bits-field-also-for-i386 include/asm-x86/processor.h
--- a/include/asm-x86/processor.h~x86-x86_physvirt_bits-field-also-for-i386
+++ a/include/asm-x86/processor.h
@@ -73,8 +73,6 @@ struct cpuinfo_x86 {
 #else
 	/* Number of 4K pages in DTLB/ITLB combined(in pages): */
 	int			 x86_tlbsize;
-	__u8			x86_virt_bits;
-	__u8			x86_phys_bits;
 	/* CPUID returned core id bits: */
 	__u8			x86_coreid_bits;
 	/* Max extended CPUID function supported: */
@@ -99,6 +97,8 @@ struct cpuinfo_x86 {
 	u16			apicid;
 	u16			initial_apicid;
 	u16			x86_clflush_size;
+	u8			x86_virt_bits;
+	u8			x86_phys_bits;
 #ifdef CONFIG_SMP
 	/* number of cores as seen by the OS: */
 	u16			booted_cores;
_

Patches currently in -mm which might be from jbeulich@novell.com are

linux-next.patch
x86-init-annotations-in-early_printk-setup.patch
x86-adjust-dependencies-for-config_x86_cmov.patch
x86-pgd_cdtor-cleanup.patch
x86-x86_physvirt_bits-field-also-for-i386.patch
x86-adjust-vmalloc_sync_all-for-xen-2nd-try.patch
x86-fix-ticket-spin-lock-asm-constraints.patch
x86-64-reduce-boot-fixmap-space.patch
x86-64-add-two-__cpuinit-annotations.patch
x86-64-eliminate-dead-code.patch
x86-64-slightly-streamline-32-bit-syscall-entry-code.patch
adjust-init-section-definitions.patch
kconfig-eliminate-def_bool-n-constructs.patch

