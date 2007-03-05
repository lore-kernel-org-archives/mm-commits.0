From: akpm@linux-foundation.org
Subject: - vmi-smp-fixes.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:55:30 -0800
Message-ID: <200703052355.l25NtUA7005191@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41958 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932579AbXCEXze (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:55:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     vmi: smp fixes
has been removed from the -mm tree.  Its filename was
     vmi-smp-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
make-struct-vmi_ops-static.patch
