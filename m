From: akpm@linux-foundation.org
Subject: - alpha-more-fixes-for-specific-machine-types.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:01:52 -0700
Message-ID: <200704192001.l3JK1qnU029321@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766991AbXDSUCd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:02:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     ALPHA: more fixes for specific machine types
has been removed from the -mm tree.  Its filename was
     alpha-more-fixes-for-specific-machine-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ALPHA: more fixes for specific machine types
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

arch/alpha/kernel/sys_sx164.c

	Earlier firmware revisions need MVI fix as well.

arch/alpha/kernel/sys_nautilus.c

	On UP1500 firmware reports wrong AGP IRQ (10 instead of 5).
	This causes interrupt storm if there is a PCI device that
	uses IRQ 5.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/sys_nautilus.c |    6 ++++++
 arch/alpha/kernel/sys_sx164.c    |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/alpha/kernel/sys_nautilus.c~alpha-more-fixes-for-specific-machine-types arch/alpha/kernel/sys_nautilus.c
--- a/arch/alpha/kernel/sys_nautilus.c~alpha-more-fixes-for-specific-machine-types
+++ a/arch/alpha/kernel/sys_nautilus.c
@@ -70,6 +70,12 @@ nautilus_map_irq(struct pci_dev *dev, u8
 	/* Preserve the IRQ set up by the console.  */
 
 	u8 irq;
+	/* UP1500: AGP INTA is actually routed to IRQ 5, not IRQ 10 as
+	   console reports. Check the device id of AGP bridge to distinguish
+	   UP1500 from UP1000/1100. Note: 'pin' is 2 due to bridge swizzle. */
+	if (slot == 1 && pin == 2 &&
+	    dev->bus->self && dev->bus->self->device == 0x700f)
+		return 5;
 	pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &irq);
 	return irq;
 }
diff -puN arch/alpha/kernel/sys_sx164.c~alpha-more-fixes-for-specific-machine-types arch/alpha/kernel/sys_sx164.c
--- a/arch/alpha/kernel/sys_sx164.c~alpha-more-fixes-for-specific-machine-types
+++ a/arch/alpha/kernel/sys_sx164.c
@@ -132,7 +132,7 @@ sx164_init_arch(void)
 
 	if (amask(AMASK_MAX) != 0
 	    && alpha_using_srm
-	    && (cpu->pal_revision & 0xffff) == 0x117) {
+	    && (cpu->pal_revision & 0xffff) <= 0x117) {
 		__asm__ __volatile__(
 		"lda	$16,8($31)\n"
 		"call_pal 9\n"		/* Allow PALRES insns in kernel mode */
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

origin.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
alpha-fix-bootp-image-creation.patch
alpha-prctl-macros.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
deflate-stack-usage-in-lib-inflatec.patch
lutimesat-extend-do_utimes-with-flags.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
local_t-alpha-extension.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
make-sure-nobodys-leaking-resources.patch
