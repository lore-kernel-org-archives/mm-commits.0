From: akpm@linux-foundation.org
Subject: + usb-make-usb_buffer_map_sg-consistent-with-doc.patch added to -mm tree
Date: Mon, 24 Aug 2009 13:53:16 -0700
Message-ID: <200908242053.n7OKrGhl005537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753484AbZHXUxU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 16:53:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, gregkh@suse.de


The patch titled
     usb: make usb_buffer_map_sg consistent with doc
has been added to the -mm tree.  Its filename is
     usb-make-usb_buffer_map_sg-consistent-with-doc.patch

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

linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
usb-make-usb_buffer_map_sg-consistent-with-doc.patch
char-riscom8-fix-shutdown-declaration.patch
kcore-use-registerd-physmem-information-define-node__pfn-for-non-numa-builds.patch
kcore-use-registerd-physmem-information-fix2.patch
video-console-use-div_round_up.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
reiser4.patch

