From: akpm@linux-foundation.org
Subject: - drivers-mtd-nand-pasemi_nandc-add-missing-pci_dev_put.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:05:27 -0800
Message-ID: <200812070005.mB705Rub021398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531AbYLGAFm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:05:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/mtd/nand/pasemi_nand.c: Add missing pci_dev_put
has been removed from the -mm tree.  Its filename was
     drivers-mtd-nand-pasemi_nandc-add-missing-pci_dev_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mtd/nand/pasemi_nand.c: Add missing pci_dev_put
From: Julia Lawall <julia@diku.dk>

pci_get_device increments a reference count that should be decremented
using pci_dev_put.

The semantic patch that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S,S1;
position p1,p2,p3;
expression E,E1;
type T,T1;
expression *ptr != NULL;
@@

(
 if ((x@p1 = pci_get_device(...)) == NULL) S
|
 x@p1 = pci_get_device(...);
)
 ... when != pci_dev_put(...,(T)x,...)
     when != if (...) { <+... pci_dev_put(...,(T)x,...) ...+> }
     when != true x == NULL || ...
     when != x = E
     when != E = (T)x
     when any
(
 if (x == NULL || ...) S1
|
 if@p2 (...) {
  ... when != pci_dev_put(...,(T1)x,...)
      when != if (...) { <+... pci_dev_put(...,(T1)x,...) ...+> }
      when != x = E1
      when != E1 = (T1)x
(
  return \(0\|<+...x...+>\|ptr\);
|
  return@p3 ...;
)
}
)

@ script:python @
p1 << r.p1;
p3 << r.p3;
@@

print "* file: %s pci_get_device: %s return: %s" % (p1[0].file,p1[0].line,p3[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/pasemi_nand.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mtd/nand/pasemi_nand.c~drivers-mtd-nand-pasemi_nandc-add-missing-pci_dev_put drivers/mtd/nand/pasemi_nand.c
--- a/drivers/mtd/nand/pasemi_nand.c~drivers-mtd-nand-pasemi_nandc-add-missing-pci_dev_put
+++ a/drivers/mtd/nand/pasemi_nand.c
@@ -141,6 +141,7 @@ static int __devinit pasemi_nand_probe(s
 	}
 
 	lpcctl = pci_resource_start(pdev, 0);
+	pci_dev_put(pdev);
 
 	if (!request_region(lpcctl, 4, driver_name)) {
 		err = -EBUSY;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
arch-arm-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-media-video-cx88-cx88-alsac-adjust-error-handling-code.patch
arch-ia64-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-mtd-maps-nettelc-use-array_size.patch
net-tipc-bcasth-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch

