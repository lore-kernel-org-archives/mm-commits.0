From: akpm@linux-foundation.org
Subject: + libata-core-fix-simplex-handling.patch added to -mm tree
Date: Thu, 01 Mar 2007 17:13:14 -0800
Message-ID: <200703020113.l221DEcH028385@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33530 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964800AbXCBBNa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 20:13:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorgukCox, alan@redhat.com


The patch titled
     libata-core: fix simplex handling
has been added to the -mm tree.  Its filename is
     libata-core-fix-simplex-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata-core: fix simplex handling
From: Alan Cox <alan@lxorgukCox .ukuu.org.uk>

The initial simplex handling code is fooled if you suspend and resume.
This also causes problems with some single channel controllers which
claim to be simplex.

The fix is fairly simple, instead of keeping a flag to remember if we
gave away the simplex channel we remember the actual owner. As the owner
is always part of the host_set we don't even need a refcount.

Knowing the owner also means we can reassign simplex DMA channels in
future hotplug code etc if we need to

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    5 ++---
 include/linux/libata.h    |    3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-core-fix-simplex-handling drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-core-fix-simplex-handling
+++ a/drivers/ata/libata-core.c
@@ -2621,12 +2621,11 @@ int ata_do_set_mode(struct ata_port *ap,
 	 * host channels are not permitted to do so.
 	 */
 	if (used_dma && (ap->host->flags & ATA_HOST_SIMPLEX))
-		ap->host->simplex_claimed = 1;
+		ap->host->simplex_claimed = ap;
 
 	/* step5: chip specific finalisation */
 	if (ap->ops->post_set_mode)
 		ap->ops->post_set_mode(ap);
-
  out:
 	if (rc)
 		*r_failed_dev = dev;
@@ -3525,7 +3524,7 @@ static void ata_dev_xfermask(struct ata_
 			       "device is on DMA blacklist, disabling DMA\n");
 	}
 
-	if ((host->flags & ATA_HOST_SIMPLEX) && host->simplex_claimed) {
+	if ((host->flags & ATA_HOST_SIMPLEX) && host->simplex_claimed != ap) {
 		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
 		ata_dev_printk(dev, KERN_WARNING, "simplex DMA is claimed by "
 			       "other device, disabling DMA\n");
diff -puN include/linux/libata.h~libata-core-fix-simplex-handling include/linux/libata.h
--- a/include/linux/libata.h~libata-core-fix-simplex-handling
+++ a/include/linux/libata.h
@@ -403,8 +403,7 @@ struct ata_host {
 	void			*private_data;
 	const struct ata_port_operations *ops;
 	unsigned long		flags;
-	int			simplex_claimed;	/* Keep seperate in case we
-							   ever need to do this locked */
+	struct ata_port		*simplex_claimed;	/* channel owning the DMA */
 	struct ata_port		*ports[0];
 };
 
_

Patches currently in -mm which might be from alan@lxorgukCox are

libata-core-fix-simplex-handling.patch
