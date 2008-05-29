From: akpm@linux-foundation.org
Subject: + suspend-vs-iommu-prevent-suspend-if-we-could-not-resume.patch added to -mm tree
Date: Thu, 29 May 2008 00:30:21 -0700
Message-ID: <200805290730.m4T7ULO0022592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbYE2Had (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 03:30:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, ragamuffin@datacomm.ch


The patch titled
     suspend vs. iommu: prevent suspend if we could not resume
has been added to the -mm tree.  Its filename is
     suspend-vs-iommu-prevent-suspend-if-we-could-not-resume.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: suspend vs. iommu: prevent suspend if we could not resume
From: Pavel Machek <pavel@suse.cz>

iommu/gart support misses suspend/resume code, which can do bad stuff,
including memory corruption on resume.  Prevent system suspend in case we
would be unable to resume.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Tested-by: Patrick <ragamuffin@datacomm.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-gart_64.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

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
@@ -546,6 +547,28 @@ static __init unsigned read_aperture(str
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
+
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
@@ -556,7 +579,7 @@ static __init int init_k8_gatt(struct ag
 	unsigned aper_base, new_aper_base;
 	struct pci_dev *dev;
 	void *gatt;
-	int i;
+	int i, error;
 
 	printk(KERN_INFO "PCI-DMA: Disabling AGP.\n");
 	aper_size = aper_base = info->aper_size = 0;
@@ -593,6 +616,12 @@ static __init int init_k8_gatt(struct ag
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
suspend-vs-iommu-prevent-suspend-if-we-could-not-resume.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch

