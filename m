From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-arch-ia64.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:36:47 -0700
Message-ID: <20120913233648.8EDAF5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:39069 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759088Ab2IMXgv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:36:51 -0400
Received: by eaac1 with SMTP id c1so219756eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:36:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, tony.luck@intel.com


The patch titled
     Subject: sections: fix section conflicts in arch/ia64
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-arch-ia64.patch

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
Subject: sections: fix section conflicts in arch/ia64

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/xen/irq_xen.c |    2 +-
 arch/ia64/xen/irq_xen.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/ia64/xen/irq_xen.c~sections-fix-section-conflicts-in-arch-ia64 arch/ia64/xen/irq_xen.c
--- a/arch/ia64/xen/irq_xen.c~sections-fix-section-conflicts-in-arch-ia64
+++ a/arch/ia64/xen/irq_xen.c
@@ -433,7 +433,7 @@ xen_resend_irq(unsigned int vector)
 	(void)resend_irq_on_evtchn(vector);
 }
 
-const struct pv_irq_ops xen_irq_ops __initdata = {
+const struct pv_irq_ops xen_irq_ops __initconst = {
 	.register_ipi = xen_register_ipi,
 
 	.assign_irq_vector = xen_assign_irq_vector,
diff -puN arch/ia64/xen/irq_xen.h~sections-fix-section-conflicts-in-arch-ia64 arch/ia64/xen/irq_xen.h
--- a/arch/ia64/xen/irq_xen.h~sections-fix-section-conflicts-in-arch-ia64
+++ a/arch/ia64/xen/irq_xen.h
@@ -27,7 +27,7 @@ extern void (*late_time_init)(void);
 extern char xen_event_callback;
 void __init xen_init_IRQ(void);
 
-extern const struct pv_irq_ops xen_irq_ops __initdata;
+extern const struct pv_irq_ops xen_irq_ops __initconst;
 extern void xen_smp_intr_init(void);
 extern void xen_send_ipi(int cpu, int vec);
 
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

