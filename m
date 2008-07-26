From: akpm@linux-foundation.org
Subject: - isa-set-24-bit-dma_mask-for-isa-devices.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:23 -0700
Message-ID: <200807262113.m6QLDNrx019592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757414AbYGZVNn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:13:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rene.herman@keyaccess.nl, alan@lxorguk.ukuu.org.uk, bjorn.helgaas@hp.com, rene.herman@gmail.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     isa: set 24-bit dma_mask for ISA devices
has been removed from the -mm tree.  Its filename was
     isa-set-24-bit-dma_mask-for-isa-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isa: set 24-bit dma_mask for ISA devices
From: Rene Herman <rene.herman@keyaccess.nl>

dma_alloc_coherent() on x86 currently takes a passed in NULL device
pointer to mean that it should allocate an ISA compatible (24-bit) buffer
which is a bit of a hack.

The ALSA ISA drivers are the main consumers of this but have a struct
device in fact readily available.

For the legacy drivers, this sets the device dma_mask in preparation for
using the actual device with the DMA API so as to eventually not need the
NULL hack in dma_alloc_coherent().

This does not fix a current bug -- 2.6.26-rc1 stumbled over the NULL hack
in dma_alloc_coherent() but this has already been fixed in commit
4a367f3a9dbf2e7ffcee4702203479809236ee6e by Takashi Iwai.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
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

origin.patch

