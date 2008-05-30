From: akpm@linux-foundation.org
Subject: + isa-set-24-bit-dma_mask-for-isa-devices.patch added to -mm tree
Date: Fri, 30 May 2008 15:55:19 -0700
Message-ID: <200805302255.m4UMtJ9j015581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbYE3W4V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 18:56:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.herman@keyaccess.nl, alan@lxorguk.ukuu.org.uk, bjorn.helgaas@hp.com, rene.herman@gmail.com, tiwai@suse.de


The patch titled
     isa: set 24-bit dma_mask for ISA devices
has been added to the -mm tree.  Its filename is
     isa-set-24-bit-dma_mask-for-isa-devices.patch

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
Subject: isa: set 24-bit dma_mask for ISA devices
From: Rene Herman <rene.herman@keyaccess.nl>

Set the ISA device dma_mask in preparation for using the actual device
with the DMA API.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/isa.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/base/isa.c~isa-set-24-bit-dma_mask-for-isa-devices drivers/base/isa.c
--- a/drivers/base/isa.c~isa-set-24-bit-dma_mask-for-isa-devices
+++ a/drivers/base/isa.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/dma-mapping.h>
 #include <linux/isa.h>
 
 static struct device isa_bus = {
@@ -141,6 +142,9 @@ int isa_register_driver(struct isa_drive
 		isa_dev->dev.release		= isa_dev_release;
 		isa_dev->id			= id;
 
+		isa_dev->dev.coherent_dma_mask = DMA_24BIT_MASK;
+		isa_dev->dev.dma_mask = &isa_dev->dev.coherent_dma_mask;
+
 		error = device_register(&isa_dev->dev);
 		if (error) {
 			put_device(&isa_dev->dev);
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

pnpacpi-fix-irq-flag-decoding-comment-fix.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-make-pnp_portmemetc_start-et-al-work-for-invalid-resources.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch

