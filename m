From: akpm@linux-foundation.org
Subject: [merged] drivers-mtd-use-kasprintf.patch removed from -mm tree
Date: Mon, 22 Mar 2010 11:31:30 -0400
Message-ID: <201003221832.o2MIWK3N019999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755658Ab0CVScx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 14:32:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/mtd: use kasprintf
has been removed from the -mm tree.  Its filename was
     drivers-mtd-use-kasprintf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mtd: use kasprintf
From: Julia Lawall <julia@diku.dk>

kasprintf combines kmalloc and sprintf, and takes care of the size
calculation itself.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression a,flag;
expression list args;
statement S;
@@

  a =
-  \(kmalloc\|kzalloc\)(...,flag)
+  kasprintf(flag,args)
  <... when != a
  if (a == NULL || ...) S
  ...>
- sprintf(a,args);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/block2mtd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/mtd/devices/block2mtd.c~drivers-mtd-use-kasprintf drivers/mtd/devices/block2mtd.c
--- a/drivers/mtd/devices/block2mtd.c~drivers-mtd-use-kasprintf
+++ a/drivers/mtd/devices/block2mtd.c
@@ -275,12 +275,10 @@ static struct block2mtd_dev *add_device(
 
 	/* Setup the MTD structure */
 	/* make the name contain the block device in */
-	name = kmalloc(sizeof("block2mtd: ") + strlen(devname) + 1,
-			GFP_KERNEL);
+	name = kasprintf(GFP_KERNEL, "block2mtd: %s", devname);
 	if (!name)
 		goto devinit_err;
 
-	sprintf(name, "block2mtd: %s", devname);
 	dev->mtd.name = name;
 
 	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-acpi-use-kasprintf.patch
drivers-acpi-use-kasprintf-fix.patch
arch-x86-pci-use-kasprintf.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
arch-powerpc-platforms-pseries-use-kasprintf.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-char-ppdevc-use-kasprintf.patch
drivers-edac-introduce-missing-kfree.patch

