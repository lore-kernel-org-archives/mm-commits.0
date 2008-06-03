From: akpm@linux-foundation.org
Subject: - suspend-vs-iommu-prevent-suspend-if-we-could-not-resume.patch removed from -mm tree
Date: Tue, 03 Jun 2008 12:02:54 -0700
Message-ID: <200806031902.m53J2s2t014827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753231AbYFCTHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:07:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, airlied@linux.ie, andi@firstfloor.org, mingo@elte.hu, ragamuffin@datacomm.ch, rjw@sisk.pl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     suspend vs. iommu: prevent suspend if we could not resume
has been removed from the -mm tree.  Its filename was
     suspend-vs-iommu-prevent-suspend-if-we-could-not-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: suspend vs. iommu: prevent suspend if we could not resume
From: Pavel Machek <pavel@suse.cz>

iommu/gart support misses suspend/resume code, which can do bad stuff,
including memory corruption on resume.  Prevent system suspend in case we
would be unable to resume.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Tested-by: Patrick <ragamuffin@datacomm.ch>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-gart_64.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/pci-gart_64.c~suspend-vs-iommu-prevent-suspend-if-we-could-not-resume arch/x86/kernel/pci-gart_64.c
--- a/arch/x86/kernel/pci-gart_64.c~suspend-vs-iommu-prevent-suspend-if-we-could-not-resume
+++ a/arch/x86/kernel/pci-gart_64.c
@@ -26,6 +26,7 @@
 #include <linux/kdebug.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
+#include <linux/sysdev.h>
 #include <asm/atomic.h>
 #include <asm/io.h>
 #include <asm/mtrr.h>
@@ -546,6 +547,27 @@ static __init unsigned read_aperture(str
 	return aper_base;
 }
 
+static int gart_resume(struct sys_device *dev)
+{
+	return 0;
+}
+
+static int gart_suspend(struct sys_device *dev, pm_message_t state)
+{
+	return -EINVAL;
+}
+
+static struct sysdev_class gart_sysdev_class = {
+	.name = "gart",
+	.suspend = gart_suspend,
+	.resume = gart_resume,
+};
+
+static struct sys_device device_gart = {
+	.id	= 0,
+	.cls	= &gart_sysdev_class,
+};
+
 /*
  * Private Northbridge GATT initialization in case we cannot use the
  * AGP driver for some reason.
@@ -556,7 +578,7 @@ static __init int init_k8_gatt(struct ag
 	unsigned aper_base, new_aper_base;
 	struct pci_dev *dev;
 	void *gatt;
-	int i;
+	int i, error;
 
 	printk(KERN_INFO "PCI-DMA: Disabling AGP.\n");
 	aper_size = aper_base = info->aper_size = 0;
@@ -593,6 +615,12 @@ static __init int init_k8_gatt(struct ag
 		dev = k8_northbridges[i];
 		enable_gart_translation(dev, __pa(gatt));
 	}
+
+	error = sysdev_class_register(&gart_sysdev_class);
+	if (!error)
+		error = sysdev_register(&device_gart);
+	if (error)
+		panic("Could not register gart_sysdev -- would corrupt data on next suspend");
 	flush_gart();
 
 	printk(KERN_INFO "PCI-DMA: aperture base @ %x size %u KB\n",
_

Patches currently in -mm which might be from pavel@suse.cz are

linux-next.patch
aperture_64c-corner-case-wrong.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
pm-boot-time-suspend-selftest.patch

