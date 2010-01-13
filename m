From: akpm@linux-foundation.org
Subject: + usb-fhci-avoid-null-pointer-dereference.patch added to -mm tree
Date: Wed, 13 Jan 2010 13:37:00 -0800
Message-ID: <201001132137.o0DLb05N029926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755280Ab0AMVhe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 16:37:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, avorontsov@ru.mvista.com, gregkh@suse.de


The patch titled
     usb: fhci: avoid NULL pointer dereference
has been added to the -mm tree.  Its filename is
     usb-fhci-avoid-null-pointer-dereference.patch

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

linux-next.patch
usb-fhci-avoid-null-pointer-dereference.patch
rtc-mxc-fix-memory-leak.patch

