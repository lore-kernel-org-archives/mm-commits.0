From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-arch-ia64.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:21 -0700
Message-ID: <20121005201221.9DDEA100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:53975 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab2JEUMW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:22 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so235722ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in arch/ia64
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-arch-ia64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

