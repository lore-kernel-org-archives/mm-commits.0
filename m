From: akpm@linux-foundation.org
Subject: + x86-fix-config_smp-warning-in-processorc.patch added to -mm tree
Date: Wed, 24 Oct 2007 16:23:19 -0700
Message-ID: <200710242323.l9ONNJpW017762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012AbXJXXXy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 19:23:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, jgarzik@redhat.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     X86: fix !CONFIG_SMP warning in processor.c
has been added to the -mm tree.  Its filename is
     x86-fix-config_smp-warning-in-processorc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
git-wireless.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
x86-fix-config_smp-warning-in-processorc.patch
acpi-sbs-fix-retval-warning.patch
riscom8-fix-smp-brokenness.patch
isdn-sc-fix-longstanding-warning.patch
mac80211-fix-warning-created-by-bit.patch
