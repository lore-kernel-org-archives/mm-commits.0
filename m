From: akpm@linux-foundation.org
Subject: - pcmcia-irq-probe-can-be-done-without-risking-an-irq-storm.patch removed from -mm tree
Date: Wed, 25 Apr 2007 21:16:55 -0700
Message-ID: <200704260419.l3Q4JaHn020606@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754411AbXDZETt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 00:19:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     pcmcia: irq probe can be done without risking an IRQ storm
has been removed from the -mm tree.  Its filename was
     pcmcia-irq-probe-can-be-done-without-risking-an-irq-storm.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: pcmcia: irq probe can be done without risking an IRQ storm
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Nowdays you can ask for an IRQ to be allocated but not enabled, when PCMCIA
was written this was not true and this feature is thus not used

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/pcmcia_resource.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/pcmcia/pcmcia_resource.c~pcmcia-irq-probe-can-be-done-without-risking-an-irq-storm drivers/pcmcia/pcmcia_resource.c
--- a/drivers/pcmcia/pcmcia_resource.c~pcmcia-irq-probe-can-be-done-without-risking-an-irq-storm
+++ a/drivers/pcmcia/pcmcia_resource.c
@@ -812,6 +812,9 @@ int pcmcia_request_irq(struct pcmcia_dev
 		type = IRQF_SHARED;
 
 #ifdef CONFIG_PCMCIA_PROBE
+	if (!(req->Attributes & IRQ_HANDLE_PRESENT))
+		type |= IRQ_NOAUTOEN;
+
 	if (s->irq.AssignedIRQ != 0) {
 		/* If the interrupt is already assigned, it must be the same */
 		irq = s->irq.AssignedIRQ;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-agpgart.patch
git-agp-build-fix.patch
git-powerpc.patch
git-libata-all.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
ata_timing-ensure-t-cycle-is-always-correct.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma-fix.patch
pata_ali-more-work.patch
git-netdev-all.patch
pcmcia-irq-probe-can-be-done-without-risking-an-irq-storm.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
protect-tty-drivers-list-with-tty_mutex.patch
fix-82875-pci-setup.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
remove-redundant-check-from-proc_sys_setattr.patch
apm-fix-incorrect-comment.patch
upper-32-bits.patch
console-utf-8-fixes.patch
add-pci_try_set_mwi.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
