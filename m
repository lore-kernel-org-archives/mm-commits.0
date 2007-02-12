From: akpm@linux-foundation.org
Subject: - kernel-shut-up-the-irq-mismatch-messages.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:43:38 -0800
Message-ID: <200702122243.l1CMhcan013517@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44914 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030252AbXBLWoF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:44:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, arjan@infradead.org, dwmw2@infradead.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kernel: shut up the IRQ mismatch messages
has been removed from the -mm tree.  Its filename was
     kernel-shut-up-the-irq-mismatch-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel: shut up the IRQ mismatch messages
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The problem is various drivers legally validly and sensibly try to claim
IRQs but the kernel insists on vomiting forth a giant irrelevant debugging
spew when the types clash.

Edit kernel/irq/manage.c go down to mismatch: in setup_irq() and ifdef out
the if clause that checks for mismatches.  It'll then just do the right
thing and work sanely.

For the current -mm kernel this will do the trick (and moves it into shared
irq debugging as in debug mode the info spew is useful).  I've had a
variant of this in my private tree for some time as I got fed up on the
mess on boxes where old legacy IRQs get reused.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/irq/manage.c~kernel-shut-up-the-irq-mismatch-messages kernel/irq/manage.c
--- a/kernel/irq/manage.c~kernel-shut-up-the-irq-mismatch-messages
+++ a/kernel/irq/manage.c
@@ -328,12 +328,14 @@ int setup_irq(unsigned int irq, struct i
 	return 0;
 
 mismatch:
+#ifdef CONFIG_DEBUG_SHIRQ
 	if (!(new->flags & IRQF_PROBE_SHARED)) {
 		printk(KERN_ERR "IRQ handler type mismatch for IRQ %d\n", irq);
 		if (old_name)
 			printk(KERN_ERR "current handler: %s\n", old_name);
 		dump_stack();
 	}
+#endif
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return -EBUSY;
 }
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
sis-warning-fixes.patch
libata-add-a-host-flag-to-indicate-lack-of-iordy.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
