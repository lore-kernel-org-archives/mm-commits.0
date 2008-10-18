From: akpm@linux-foundation.org
Subject: - cirrusfb-add-__devinit-attribute-to-probing-functions.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:18 -0700
Message-ID: <200810182317.m9INHIwV029066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219AbYJRXRU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: add __devinit attribute to probing functions
has been removed from the -mm tree.  Its filename was
     cirrusfb-add-__devinit-attribute-to-probing-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: add __devinit attribute to probing functions
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add __devinit attribute to probing functions.  This fixed section mismatch
warning from my previous patch.

Kill one redundant forward declaration.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-add-__devinit-attribute-to-probing-functions drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-add-__devinit-attribute-to-probing-functions
+++ a/drivers/video/cirrusfb.c
@@ -417,10 +417,6 @@ static struct fb_ops cirrusfb_ops = {
 	.fb_imageblit	= cirrusfb_imageblit,
 };
 
-/*--- Hardware Specific Routines -------------------------------------------*/
-static int cirrusfb_decode_var(const struct fb_var_screeninfo *var,
-				struct cirrusfb_regs *regs,
-				struct fb_info *info);
 /*--- Internal routines ----------------------------------------------------*/
 static void init_vgachip(struct fb_info *info);
 static void switch_monitor(struct cirrusfb_info *cinfo, int on);
@@ -2020,7 +2016,7 @@ static int release_io_ports;
  * based on the DRAM bandwidth bit and DRAM bank switching bit.  This
  * works with 1MB, 2MB and 4MB configurations (which the Motorola boards
  * seem to have. */
-static unsigned int cirrusfb_get_memsize(u8 __iomem *regbase)
+static unsigned int __devinit cirrusfb_get_memsize(u8 __iomem *regbase)
 {
 	unsigned long mem;
 	unsigned char SRF;
@@ -2117,7 +2113,7 @@ static void __devexit cirrusfb_zorro_unm
 }
 #endif /* CONFIG_ZORRO */
 
-static int cirrusfb_set_fbinfo(struct fb_info *info)
+static int __devinit cirrusfb_set_fbinfo(struct fb_info *info)
 {
 	struct cirrusfb_info *cinfo = info->par;
 	struct fb_var_screeninfo *var = &info->var;
@@ -2161,7 +2157,7 @@ static int cirrusfb_set_fbinfo(struct fb
 	return 0;
 }
 
-static int cirrusfb_register(struct fb_info *info)
+static int __devinit cirrusfb_register(struct fb_info *info)
 {
 	struct cirrusfb_info *cinfo = info->par;
 	int err;
@@ -2232,8 +2228,8 @@ static void __devexit cirrusfb_cleanup(s
 }
 
 #ifdef CONFIG_PCI
-static int cirrusfb_pci_register(struct pci_dev *pdev,
-				  const struct pci_device_id *ent)
+static int __devinit cirrusfb_pci_register(struct pci_dev *pdev,
+					   const struct pci_device_id *ent)
 {
 	struct cirrusfb_info *cinfo;
 	struct fb_info *info;
@@ -2360,8 +2356,8 @@ static struct pci_driver cirrusfb_pci_dr
 #endif /* CONFIG_PCI */
 
 #ifdef CONFIG_ZORRO
-static int cirrusfb_zorro_register(struct zorro_dev *z,
-				   const struct zorro_device_id *ent)
+static int __devinit cirrusfb_zorro_register(struct zorro_dev *z,
+					     const struct zorro_device_id *ent)
 {
 	struct cirrusfb_info *cinfo;
 	struct fb_info *info;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

