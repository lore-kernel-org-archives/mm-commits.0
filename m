From: akpm@linux-foundation.org
Subject: + pata_ns87415-initial-cut-at-87415-87560-ide-support-fix.patch added to -mm tree
Date: Wed, 26 Sep 2007 17:37:16 -0700
Message-ID: <200709270037.l8R0bG1w011766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58441 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbXI0Ahe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 20:37:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyle@mcmartin.ca, alan@redhat.com


The patch titled
     pata_ns87415-initial-cut-at-87415-87560-ide-support fix
has been added to the -mm tree.  Its filename is
     pata_ns87415-initial-cut-at-87415-87560-ide-support-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_ns87415-initial-cut-at-87415-87560-ide-support fix
From: Kyle McMartin <kyle@mcmartin.ca>

u8 tmp is undefined, and port should be void __iomem * if we're going to
use pci-iomap accessors.

Works good otherwise, I was able to mount and copy a cd. Patch attached.
Queued a patch to move SUPERIO_IDE_MAX_RETRIES to <asm/superio.h>.

Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/Kconfig        |    2 +-
 drivers/ata/pata_ns87415.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/ata/Kconfig~pata_ns87415-initial-cut-at-87415-87560-ide-support-fix drivers/ata/Kconfig
--- a/drivers/ata/Kconfig~pata_ns87415-initial-cut-at-87415-87560-ide-support-fix
+++ a/drivers/ata/Kconfig
@@ -433,7 +433,7 @@ config PATA_NS87410
 	  If unsure, say N.
 
 config PATA_NS87415
-	tristate "Nat Semi NS87410 PATA support (Experimental)"
+	tristate "Nat Semi NS87415 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the National Semiconductor
diff -puN drivers/ata/pata_ns87415.c~pata_ns87415-initial-cut-at-87415-87560-ide-support-fix drivers/ata/pata_ns87415.c
--- a/drivers/ata/pata_ns87415.c~pata_ns87415-initial-cut-at-87415-87560-ide-support-fix
+++ a/drivers/ata/pata_ns87415.c
@@ -222,8 +222,9 @@ static int ns87415_check_atapi_dma(struc
  *	Work around chipset problems in the 87560 SuperIO chip
  */
 
-static u8 ns87560_read_buggy(unsigned long port)
+static u8 ns87560_read_buggy(void __iomem *port)
 {
+	u8 tmp;
 	int retries = SUPERIO_IDE_MAX_RETRIES;
 	do {
 		tmp = ioread8(port);
_

Patches currently in -mm which might be from kyle@mcmartin.ca are

pata_ns87415-initial-cut-at-87415-87560-ide-support-fix.patch
fix-a-potential-null-pointer-dereference-in-uli526x_interrupt.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
parisc-extern-inline-static-inline.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
bitops-introduce-lock-ops.patch
