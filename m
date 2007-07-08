From: akpm@linux-foundation.org
Subject: - clean-up-e7520-7320-7525-quirk-printk.patch removed from -mm tree
Date: Sun, 08 Jul 2007 01:11:39 -0700
Message-ID: <200707080811.l688Bdps014785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51256 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102AbXGHILz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jul 2007 04:11:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Clean up E7520/7320/7525 quirk printk
has been removed from the -mm tree.  Its filename was
     clean-up-e7520-7320-7525-quirk-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up E7520/7320/7525 quirk printk
From: Dave Jones <davej@redhat.com>

The printk level in this printk is bogus, as the previous printk
didn't have a terminating \n resulting in ..

Intel E7520/7320/7525 detected.<6>Disabling irq balancing and affinity

It also never printed a \n at all in the case where we didn't do
the quirk.

Change it to only make noise if it actually does something useful.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/quirks.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/quirks.c~clean-up-e7520-7320-7525-quirk-printk arch/i386/kernel/quirks.c
--- a/arch/i386/kernel/quirks.c~clean-up-e7520-7320-7525-quirk-printk
+++ a/arch/i386/kernel/quirks.c
@@ -20,8 +20,6 @@ static void __devinit quirk_intel_irqbal
 	if (rev > 0x9)
 		return;
 
-	printk(KERN_INFO "Intel E7520/7320/7525 detected.");
-
 	/* enable access to config space*/
 	pci_read_config_byte(dev, 0xf4, &config);
 	pci_write_config_byte(dev, 0xf4, config|0x2);
@@ -30,7 +28,8 @@ static void __devinit quirk_intel_irqbal
 	raw_pci_ops->read(0, 0, 0x40, 0x4c, 2, &word);
 
 	if (!(word & (1 << 13))) {
-		printk(KERN_INFO "Disabling irq balancing and affinity\n");
+		printk(KERN_INFO "Intel E7520/7320/7525 detected. "
+			"Disabling irq balancing and affinity\n");
 #ifdef CONFIG_IRQBALANCE
 		irqbalance_disable("");
 #endif
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
fix-empty-macros-in-acpi.patch
git-alsa.patch
git-cpufreq.patch
i386-remove-support-for-the-rise-cpu.patch
fix-up-codingstyle-in-isofs.patch
undeprecate-raw-driver.patch
fix-typo-in-prefetchh.patch
allow-softlockup-to-be-runtime-disabled.patch
add-werror-implicit-function-declaration.patch
