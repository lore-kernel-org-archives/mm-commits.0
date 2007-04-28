From: akpm@linux-foundation.org
Subject: - plan-b-switch-to-refcounting-pci-api.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:51:47 -0700
Message-ID: <200704281051.l3SApl41020004@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965654AbXD1KwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     plan-b: Switch to refcounting PCI API
has been removed from the -mm tree.  Its filename was
     plan-b-switch-to-refcounting-pci-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: plan-b: Switch to refcounting PCI API
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/planb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/planb.c~plan-b-switch-to-refcounting-pci-api drivers/media/video/planb.c
--- a/drivers/media/video/planb.c~plan-b-switch-to-refcounting-pci-api
+++ a/drivers/media/video/planb.c
@@ -2210,7 +2210,7 @@ static int find_planb(void)
 		"membase 0x%x (base reg. 0x%x)\n",
 		bus, PCI_SLOT(dev_fn), PCI_FUNC(dev_fn), old_base, confreg);
 
-	pdev = pci_find_slot (bus, dev_fn);
+	pdev = pci_get_bus_and_slot(bus, dev_fn);
 	if (!pdev) {
 		printk(KERN_ERR "planb: cannot find slot\n");
 		goto err_out;
@@ -2240,6 +2240,7 @@ static int find_planb(void)
 	pb->planb_base = planb_regs;
 	pb->planb_base_phys = (struct planb_registers *)new_base;
 	pb->irq	= irq;
+	pb->dev = pdev;
 
 	return planb_num;
 
@@ -2247,6 +2248,7 @@ err_out_disable:
 	pci_disable_device(pdev);
 err_out:
 	/* FIXME handle error */   /* comment moved from pci_find_slot, above */
+	pci_dev_put(pdev);
 	return 0;
 }
 
@@ -2274,6 +2276,8 @@ static void release_planb(void)
 		printk(KERN_INFO "PlanB: unregistering with v4l\n");
 		video_unregister_device(&pb->video_dev);
 
+		pci_dev_put(pb->dev);
+
 		/* note that iounmap() does nothing on the PPC right now */
 		iounmap ((void *)pb->planb_base);
 	}
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-agpgart.patch
git-powerpc.patch
git-dvb.patch
git-libata-all.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
ata_timing-ensure-t-cycle-is-always-correct.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
sl82c105-switch-to-ref-counting-api.patch
git-netdev-all.patch
vioc_irq-switch-to-pci-refcount-safe-api.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
pci-syscallc-switch-to-refcounting-api.patch
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
edd-switch-to-refcounting-pci-apis.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
