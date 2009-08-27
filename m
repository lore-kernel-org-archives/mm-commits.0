From: akpm@linux-foundation.org
Subject: [merged] usb-make-usb_buffer_map_sg-consistent-with-doc.patch removed from -mm tree
Date: Thu, 27 Aug 2009 12:18:51 -0700
Message-ID: <200908271918.n7RJIpsp011045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbZH0TSx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 15:18:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     usb: make usb_buffer_map_sg consistent with doc
has been removed from the -mm tree.  Its filename was
     usb-make-usb_buffer_map_sg-consistent-with-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: make usb_buffer_map_sg consistent with doc
From: Jiri Slaby <jirislaby@gmail.com>

usb_buffer_map_sg should return negative on error according to its
documentation.  But dma_map_sg returns 0 on error.  Take this into account
and return -ENOMEM in such situation.

While at it, return -EINVAL instead of -1 when wrong input is passed in.

If this wasn't done, usb_sg_* operations used after usb_sg_init which
returned 0 may cause oopses/deadlocks since we don't init
structures/entries, esp.  completion and status entry.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/core/usb.c~usb-make-usb_buffer_map_sg-consistent-with-doc drivers/usb/core/usb.c
--- a/drivers/usb/core/usb.c~usb-make-usb_buffer_map_sg-consistent-with-doc
+++ a/drivers/usb/core/usb.c
@@ -914,11 +914,11 @@ int usb_buffer_map_sg(const struct usb_d
 			|| !(bus = dev->bus)
 			|| !(controller = bus->controller)
 			|| !controller->dma_mask)
-		return -1;
+		return -EINVAL;
 
 	/* FIXME generic api broken like pci, can't report errors */
 	return dma_map_sg(controller, sg, nents,
-			is_in ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
+			is_in ? DMA_FROM_DEVICE : DMA_TO_DEVICE) ? : -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(usb_buffer_map_sg);
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
video-console-use-div_round_up.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
memstick-move-dev_dbg.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

