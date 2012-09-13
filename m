From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-arch-x86.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:37:04 -0700
Message-ID: <20120913233705.672FF1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:33886 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759107Ab2IMXhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:37:06 -0400
Received: by mail-yx0-f202.google.com with SMTP id q6so389740yen.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:37:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Subject: sections: fix section conflicts in arch/x86
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-arch-x86.patch

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

