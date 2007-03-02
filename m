From: akpm@linux-foundation.org
Subject: + vmi-smp-fixes.patch added to -mm tree
Date: Thu, 01 Mar 2007 19:37:30 -0800
Message-ID: <200703020337.l223bUQi031365@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39704 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422805AbXCBDhb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 22:37:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com


The patch titled
     vmi: smp fixes
has been added to the -mm tree.  Its filename is
     vmi-smp-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vmi: smp fixes
From: Zachary Amsden <zach@vmware.com>

Critical fixes for SMP.

Fix a couple functions which needed to be __devinit and fix a bogus parameter
to AP startup that just so happened to work because the low virtual mapping of
memory was still established.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c     |    7 ++++---
 arch/i386/kernel/vmitime.c |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/vmi.c~vmi-smp-fixes arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~vmi-smp-fixes
+++ a/arch/i386/kernel/vmi.c
@@ -525,13 +525,14 @@ void vmi_pmd_clear(pmd_t *pmd)
 #endif
 
 #ifdef CONFIG_SMP
-struct vmi_ap_state ap;
 extern void setup_pda(void);
 
-static void __init /* XXX cpu hotplug */
+static void __devinit
 vmi_startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 		     unsigned long start_esp)
 {
+	struct vmi_ap_state ap;
+
 	/* Default everything to zero.  This is fine for most GPRs. */
 	memset(&ap, 0, sizeof(struct vmi_ap_state));
 
@@ -570,7 +571,7 @@ vmi_startup_ipi_hook(int phys_apicid, un
 	/* Protected mode, paging, AM, WP, NE, MP. */
 	ap.cr0 = 0x80050023;
 	ap.cr4 = mmu_cr4_features;
-	vmi_ops.set_initial_ap_state(__pa(&ap), phys_apicid);
+	vmi_ops.set_initial_ap_state((u32)&ap, phys_apicid);
 }
 #endif
 
diff -puN arch/i386/kernel/vmitime.c~vmi-smp-fixes arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c~vmi-smp-fixes
+++ a/arch/i386/kernel/vmitime.c
@@ -243,7 +243,7 @@ void __init vmi_timer_setup_boot_alarm(v
 
 /* Initialize the time accounting variables for an AP on an SMP system.
  * Also, set the local alarm for the AP. */
-void __init vmi_timer_setup_secondary_alarm(void)
+void __devinit vmi_timer_setup_secondary_alarm(void)
 {
 	int cpu = smp_processor_id();
 
_

Patches currently in -mm which might be from zach@vmware.com are

vmi-timer-fixes-round-two.patch
vmi-sched-clock-paravirt-op-fix.patch
vmi-cpu-cycles-fix.patch
vmi-fix-highpte.patch
vmi-paravirt-drop-udelay-op.patch
vmi-pit-override.patch
vmi-fix-nohz-compile.patch
vmi-apic-ops.patch
vmi-smp-fixes.patch
make-struct-vmi_ops-static.patch
xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
xen-paravirt_ops-add-common-patching-machinery.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
