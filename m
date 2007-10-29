From: akpm@linux-foundation.org
Subject: - x86-fix-config_smp-warning-in-processorc.patch removed from -mm tree
Date: Mon, 29 Oct 2007 13:31:28 -0700
Message-ID: <200710292031.l9TKVSLQ021851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44122 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303AbXJ2Ucn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:32:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, jgarzik@redhat.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     X86: fix !CONFIG_SMP warning in processor.c
has been removed from the -mm tree.  Its filename was
     x86-fix-config_smp-warning-in-processorc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: X86: fix !CONFIG_SMP warning in processor.c
From: Jeff Garzik <jeff@garzik.org>

Fix !CONFIG_SMP warning:

arch/x86/kernel/acpi/processor.c: In function `arch_acpi_processor_init_pdc':
arch/x86/kernel/acpi/processor.c:65: warning: unused variable `cpu'

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/acpi/processor.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/kernel/acpi/processor.c~x86-fix-config_smp-warning-in-processorc arch/x86/kernel/acpi/processor.c
--- a/arch/x86/kernel/acpi/processor.c~x86-fix-config_smp-warning-in-processorc
+++ a/arch/x86/kernel/acpi/processor.c
@@ -62,7 +62,9 @@ static void init_intel_pdc(struct acpi_p
 /* Initialize _PDC data based on the CPU vendor */
 void arch_acpi_processor_init_pdc(struct acpi_processor *pr)
 {
+#ifdef CONFIG_SMP
 	unsigned int cpu = pr->id;
+#endif
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	pr->pdc = NULL;
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-sbs-fix-retval-warning.patch
git-arm.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-scsi-misc-vs-git-libata-all.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
git-wireless.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-pointless-casts-from-void-pointers.patch
