From: akpm@linux-foundation.org
Subject: + drivers-mtd-nand-pasemi_nandc-add-missing-pci_dev_put.patch added to -mm tree
Date: Tue, 02 Dec 2008 11:34:11 -0800
Message-ID: <200812021934.mB2JYBZh005512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754418AbYLBTew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 14:34:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, dwmw2@infradead.org


The patch titled
     drivers/mtd/nand/pasemi_nand.c: Add missing pci_dev_put
has been added to the -mm tree.  Its filename is
     drivers-mtd-nand-pasemi_nandc-add-missing-pci_dev_put.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mtd/nand/pasemi_nand.c: Add missing pci_dev_put
From: Julia Lawall <julia@diku.dk>

pci_get_device increments a reference count that should be decremented
using pci_dev_put.  I have thus added an extra label in the error handling
code to do this.  I don't know, however, whether there should be a
pci_dev_put before the return 0 as well.

The semantic match that finds the problem is as follows:
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

 drivers/mtd/nand/pasemi_nand.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/nand/pasemi_nand.c~drivers-mtd-nand-pasemi_nandc-add-missing-pci_dev_put drivers/mtd/nand/pasemi_nand.c
--- a/drivers/mtd/nand/pasemi_nand.c~drivers-mtd-nand-pasemi_nandc-add-missing-pci_dev_put
+++ a/drivers/mtd/nand/pasemi_nand.c
@@ -144,7 +144,7 @@ static int __devinit pasemi_nand_probe(s
 
 	if (!request_region(lpcctl, 4, driver_name)) {
 		err = -EBUSY;
-		goto out_ior;
+		goto out_pdev;
 	}
 
 	chip->cmd_ctrl = pasemi_hwcontrol;
@@ -176,6 +176,8 @@ static int __devinit pasemi_nand_probe(s
 
  out_lpc:
 	release_region(lpcctl, 4);
+ out_pdev:
+	pci_dev_put(pdev);
  out_ior:
 	iounmap(chip->IO_ADDR_R);
  out_mtd:
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-char-agp-add-missing-pci_dev_get.patch
arch-arm-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-powerpc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-ia64-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-mtd-maps-nettelc-use-array_size.patch
drivers-mtd-nand-pasemi_nandc-add-missing-pci_dev_put.patch
net-tipc-bcasth-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch

