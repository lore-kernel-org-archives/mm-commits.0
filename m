From: akpm@linux-foundation.org
Subject: [merged] usb-fhci-avoid-null-pointer-dereference.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:29:21 -0800
Message-ID: <201001212129.o0LLTLII030800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755374Ab0AUV3g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:29:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, avorontsov@ru.mvista.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     usb: fhci: avoid NULL pointer dereference
has been removed from the -mm tree.  Its filename was
     usb-fhci-avoid-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: fhci: avoid NULL pointer dereference
From: Alexander Beregalov <a.beregalov@gmail.com>

Assign fhci only if usb is not NULL.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/fhci-hcd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/usb/host/fhci-hcd.c~usb-fhci-avoid-null-pointer-dereference drivers/usb/host/fhci-hcd.c
--- a/drivers/usb/host/fhci-hcd.c~usb-fhci-avoid-null-pointer-dereference
+++ a/drivers/usb/host/fhci-hcd.c
@@ -242,9 +242,10 @@ err:
 static void fhci_usb_free(void *lld)
 {
 	struct fhci_usb *usb = lld;
-	struct fhci_hcd *fhci = usb->fhci;
+	struct fhci_hcd *fhci;
 
 	if (usb) {
+		fhci = usb->fhci;
 		fhci_config_transceiver(fhci, FHCI_PORT_POWER_OFF);
 		fhci_ep0_free(usb);
 		kfree(usb->actual_frame);
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

origin.patch
linux-next.patch
rtc-mxc-fix-memory-leak.patch

