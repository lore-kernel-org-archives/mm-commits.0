From: akpm@osdl.org
Subject: - atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy.patch removed from -mm tree
Date: Fri, 05 Jan 2007 16:13:50 -0800
Message-ID: <200701060014.l060EGFb011401@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44799 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbXAFAO0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 19:14:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, alan@redhat.com, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy
has been removed from the -mm tree.  Its filename was
     atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy.patch

This patch was dropped because it was folded into atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang.patch

------------------------------------------------------
Subject: atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy
From: Andrew Morton <akpm@osdl.org>

Cc: Alan Cox <alan@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/atiixp.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/ide/pci/atiixp.c~atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy drivers/ide/pci/atiixp.c
--- a/drivers/ide/pci/atiixp.c~atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy
+++ a/drivers/ide/pci/atiixp.c
@@ -46,7 +46,7 @@ static atiixp_ide_timing mdma_timing[] =
 
 static int save_mdma_mode[4];
 
-static spinlock_t atiixp_lock;
+static DEFINE_SPINLOCK(atiixp_lock);
 
 /**
  *	atiixp_ratemask		-	compute rate mask for ATIIXP IDE
@@ -382,7 +382,6 @@ static struct pci_driver driver = {
 
 static int atiixp_ide_init(void)
 {
-	spin_lock_init(&atiixp_lock);
 	return ide_pci_register_driver(&driver);
 }
 
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again.patch
kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs.patch
pci-prevent-down_read-when-pci_devices-is-empty.patch
atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang.patch
atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy.patch
ip2-warning-fix.patch
shrink_all_memory-fix-lru_pages-handling.patch
