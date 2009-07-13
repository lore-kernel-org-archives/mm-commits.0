From: akpm@linux-foundation.org
Subject: + drivers-usb-host-xhci-dbgc-less-and-greater-than-confusion.patch added to -mm tree
Date: Mon, 13 Jul 2009 16:02:56 -0700
Message-ID: <200907132302.n6DN2uDE021814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753342AbZGMXDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 19:03:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, gregkh@suse.de, sarah.a.sharp@linux.intel.com


The patch titled
     drivers/usb/host/xhci-dbg.c: less- and greater than confusion
has been added to the -mm tree.  Its filename is
     drivers-usb-host-xhci-dbgc-less-and-greater-than-confusion.patch

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
Subject: drivers/usb/host/xhci-dbg.c: less- and greater than confusion
From: Roel Kluin <roel.kluin@gmail.com>

Without this change the loops won't start

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/xhci-dbg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/host/xhci-dbg.c~drivers-usb-host-xhci-dbgc-less-and-greater-than-confusion drivers/usb/host/xhci-dbg.c
--- a/drivers/usb/host/xhci-dbg.c~drivers-usb-host-xhci-dbgc-less-and-greater-than-confusion
+++ a/drivers/usb/host/xhci-dbg.c
@@ -419,7 +419,7 @@ void xhci_dbg_ctx(struct xhci_hcd *xhci,
 			&ctx->add_flags, (unsigned long long)dma,
 			ctx->add_flags);
 	dma += field_size;
-	for (i = 0; i > 6; ++i) {
+	for (i = 0; i < 6; ++i) {
 		xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - rsvd[%d]\n",
 				&ctx->rsvd[i], (unsigned long long)dma,
 				ctx->rsvd[i], i);
@@ -443,7 +443,7 @@ void xhci_dbg_ctx(struct xhci_hcd *xhci,
 			&ctx->slot.dev_state,
 			(unsigned long long)dma, ctx->slot.dev_state);
 	dma += field_size;
-	for (i = 0; i > 4; ++i) {
+	for (i = 0; i < 4; ++i) {
 		xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - rsvd[%d]\n",
 				&ctx->slot.reserved[i], (unsigned long long)dma,
 				ctx->slot.reserved[i], i);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ext4-remove-redundant-test-on-unsigned.patch
drivers-gpu-drm-ttm-ttm_bo_vmc-fix-misplaced-parentheses.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
adfs-remove-redundant-test-on-unsigned.patch
drivers-usb-host-xhci-dbgc-less-and-greater-than-confusion.patch

