From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-arch-x86.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:40 -0700
Message-ID: <20121005201241.1B551200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:52293 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JEUMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:43 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so138307fae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in arch/x86
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-arch-x86.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in arch/x86

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/apic.h          |    2 +-
 arch/x86/kernel/apic/apic_numachip.c |    4 ++--
 arch/x86/kernel/rtc.c                |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/apic.h~sections-fix-section-conflicts-in-arch-x86 arch/x86/include/asm/apic.h
--- a/arch/x86/include/asm/apic.h~sections-fix-section-conflicts-in-arch-x86
+++ a/arch/x86/include/asm/apic.h
@@ -409,7 +409,7 @@ extern struct apic *apic;
  * to enforce the order with in them.
  */
 #define apic_driver(sym)					\
-	static struct apic *__apicdrivers_##sym __used		\
+	static const struct apic *__apicdrivers_##sym __used		\
 	__aligned(sizeof(struct apic *))			\
 	__section(.apicdrivers) = { &sym }
 
diff -puN arch/x86/kernel/apic/apic_numachip.c~sections-fix-section-conflicts-in-arch-x86 arch/x86/kernel/apic/apic_numachip.c
--- a/arch/x86/kernel/apic/apic_numachip.c~sections-fix-section-conflicts-in-arch-x86
+++ a/arch/x86/kernel/apic/apic_numachip.c
@@ -30,7 +30,7 @@
 
 static int numachip_system __read_mostly;
 
-static struct apic apic_numachip __read_mostly;
+static const struct apic apic_numachip __read_mostly;
 
 static unsigned int get_apic_id(unsigned long x)
 {
@@ -199,7 +199,7 @@ static int numachip_acpi_madt_oem_check(
 	return 0;
 }
 
-static struct apic apic_numachip __refconst = {
+static const struct apic apic_numachip __refconst = {
 
 	.name				= "NumaConnect system",
 	.probe				= numachip_probe,
diff -puN arch/x86/kernel/rtc.c~sections-fix-section-conflicts-in-arch-x86 arch/x86/kernel/rtc.c
--- a/arch/x86/kernel/rtc.c~sections-fix-section-conflicts-in-arch-x86
+++ a/arch/x86/kernel/rtc.c
@@ -225,7 +225,7 @@ static struct platform_device rtc_device
 static __init int add_rtc_cmos(void)
 {
 #ifdef CONFIG_PNP
-	static const char *ids[] __initconst =
+	static const char * const  const ids[] __initconst =
 	    { "PNP0b00", "PNP0b01", "PNP0b02", };
 	struct pnp_dev *dev;
 	struct pnp_id *id;
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

