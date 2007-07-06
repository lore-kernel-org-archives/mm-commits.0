From: akpm@linux-foundation.org
Subject: + clean-up-e7520-7320-7525-quirk-printk.patch added to -mm tree
Date: Fri, 06 Jul 2007 13:39:17 -0700
Message-ID: <200707062039.l66KdHpB018754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754159AbXGFUjh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 16:39:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, ak@suse.de


The patch titled
     Clean up E7520/7320/7525 quirk printk
has been added to the -mm tree.  Its filename is
     clean-up-e7520-7320-7525-quirk-printk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -22,8 +22,6 @@ static void __devinit quirk_intel_irqbal
 	if (rev > 0x9)
 		return;
 
-	printk(KERN_INFO "Intel E7520/7320/7525 detected.");
-
 	/* enable access to config space*/
 	pci_read_config_byte(dev, 0xf4, &config);
 	pci_write_config_byte(dev, 0xf4, config|0x2);
@@ -32,7 +30,8 @@ static void __devinit quirk_intel_irqbal
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

clean-up-e7520-7320-7525-quirk-printk.patch
fix-empty-macros-in-acpi.patch
git-alsa.patch
git-cpufreq.patch
i386-remove-support-for-the-rise-cpu.patch
fix-up-codingstyle-in-isofs.patch
undeprecate-raw-driver.patch
fix-typo-in-prefetchh.patch
allow-softlockup-to-be-runtime-disabled.patch
add-werror-implicit-function-declaration.patch
