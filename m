From: akpm@linux-foundation.org
Subject: + pcmcia-irq-probe-can-be-done-without-risking-an-irq-storm.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:57:35 -0700
Message-ID: <200704070057.l370vZC9024238@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40966 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964793AbXDGA5u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:57:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, linux@dominikbrodowski.net


The patch titled
     pcmcia: irq probe can be done without risking an IRQ storm
has been added to the -mm tree.  Its filename is
     pcmcia-irq-probe-can-be-done-without-risking-an-irq-storm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-libata-all.patch
libata-misc-minor-merge-fixups.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
pata_pdc2027x-bring-into-line-with-changes-add-the-mode.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma-fix.patch
git-netdev-all.patch
pcmcia-irq-probe-can-be-done-without-risking-an-irq-storm.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
provide-dummy-devm_ioport_-if-has_ioport.patch
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
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
