From: akpm@linux-foundation.org
Subject: - drivers-video-add-missing-pci_dev_get.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:28:43 -0800
Message-ID: <200802070028.m170SOFB007164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933652AbYBGAp2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, adaplas@pol.net, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     drivers/video: add missing pci_dev_get
has been removed from the -mm tree.  Its filename was
     drivers-video-add-missing-pci_dev_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video: add missing pci_dev_get
From: Julia Lawall <julia@diku.dk>

pci_get_device does a pci_dev_get, so pci_dev_put needs to be called in an
error case

The problem was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@exists@
type T1,T2;
identifier E;
statement S,S1;
expression x1,x2,x3;
expression test;
int ret != 0;
@@

  struct pci_dev *E;
  ...
(
  E = \(pci_get_slot\|pci_get_device\|pci_get_bus_and_slot\)(...);
  if (E == NULL) S
|
  if ((E = \(pci_get_slot\|pci_get_device\|pci_get_bus_and_slot\)(...)) == NULL) S
)
  ... when != pci_dev_put(...,(T1)E,...)
      when != if (E != NULL) { ... pci_dev_put(...,(T1)E,...); ...}
      when != x1 = (T1)E
      when != E = x3;
      when any
(
  if (E == NULL) S1
|
  if (test)
+   {
(
+   pci_dev_put(E);
    return;
|
+   pci_dev_put(E);
    return ret;
)
+   }
|
  if (test) {
    ... when != pci_dev_put(...,(T2)E,...)
        when != if (E != NULL) { ... pci_dev_put(...,(T2)E,...); ...}
        when != x2 = (T2)E
(
+   pci_dev_put(E);
    return;
|
+   pci_dev_put(E);
    return ret;
)
  }
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/igafb.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/video/igafb.c~drivers-video-add-missing-pci_dev_get drivers/video/igafb.c
--- a/drivers/video/igafb.c~drivers-video-add-missing-pci_dev_get
+++ a/drivers/video/igafb.c
@@ -400,6 +400,7 @@ int __init igafb_init(void)
         info = kzalloc(size, GFP_ATOMIC);
         if (!info) {
                 printk("igafb_init: can't alloc fb_info\n");
+		 pci_dev_put(pdev);
                 return -ENOMEM;
         }
 
@@ -409,12 +410,14 @@ int __init igafb_init(void)
 	if ((addr = pdev->resource[0].start) == 0) {
                 printk("igafb_init: no memory start\n");
 		kfree(info);
+		pci_dev_put(pdev);
 		return -ENXIO;
 	}
 
 	if ((info->screen_base = ioremap(addr, 1024*1024*2)) == 0) {
                 printk("igafb_init: can't remap %lx[2M]\n", addr);
 		kfree(info);
+		pci_dev_put(pdev);
 		return -ENXIO;
 	}
 
@@ -449,6 +452,7 @@ int __init igafb_init(void)
                 printk("igafb_init: can't remap %lx[4K]\n", igafb_fix.mmio_start);
 		iounmap((void *)info->screen_base);
 		kfree(info);
+		pci_dev_put(pdev);
 		return -ENXIO;
 	}
 
@@ -466,6 +470,7 @@ int __init igafb_init(void)
 		iounmap((void *)par->io_base);
 		iounmap(info->screen_base);
 		kfree(info);
+		pci_dev_put(pdev);
 		return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch
arch-powerpc-platforms-pseries-add-missing-of_node_put.patch
arch-powerpc-sysdev-add-missing-of_node_put.patch
arch-powerpc-platforms-82xx-add-missing-of_node_put.patch
git-input.patch
git-mtd.patch
