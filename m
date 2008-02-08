From: akpm@linux-foundation.org
Subject: - char-applicom-use-pci_resource_start.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:19 -0800
Message-ID: <200802082020.m18KK08Z011104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38653 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932696AbYBHUlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:41:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, dwmw2@infradead.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: applicom, use pci_resource_start
has been removed from the -mm tree.  Its filename was
     char-applicom-use-pci_resource_start.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: applicom, use pci_resource_start
From: Jiri Slaby <jirislaby@gmail.com>

Use pci_resource_start instead of accessing pci_dev struct internals.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/applicom.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/char/applicom.c~char-applicom-use-pci_resource_start drivers/char/applicom.c
--- a/drivers/char/applicom.c~char-applicom-use-pci_resource_start
+++ a/drivers/char/applicom.c
@@ -206,22 +206,23 @@ static int __init applicom_init(void)
 		if (pci_enable_device(dev))
 			return -EIO;
 
-		RamIO = ioremap(dev->resource[0].start, LEN_RAM_IO);
+		RamIO = ioremap(pci_resource_start(dev, 0), LEN_RAM_IO);
 
 		if (!RamIO) {
 			printk(KERN_INFO "ac.o: Failed to ioremap PCI memory "
 				"space at 0x%llx\n",
-				(unsigned long long)dev->resource[0].start);
+				(unsigned long long)pci_resource_start(dev, 0));
 			pci_disable_device(dev);
 			return -EIO;
 		}
 
 		printk(KERN_INFO "Applicom %s found at mem 0x%llx, irq %d\n",
 		       applicom_pci_devnames[dev->device-1],
-			   (unsigned long long)dev->resource[0].start,
+			   (unsigned long long)pci_resource_start(dev, 0),
 		       dev->irq);
 
-		boardno = ac_register_board(dev->resource[0].start, RamIO,0);
+		boardno = ac_register_board(pci_resource_start(dev, 0),
+				RamIO, 0);
 		if (!boardno) {
 			printk(KERN_INFO "ac.o: PCI Applicom device doesn't have correct signature.\n");
 			iounmap(RamIO);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
