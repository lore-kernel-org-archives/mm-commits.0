From: akpm@linux-foundation.org
Subject: + hpilo-open-close-fix.patch added to -mm tree
Date: Thu, 15 Jan 2009 14:55:14 -0800
Message-ID: <200901152255.n0FMtExc000924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764963AbZAOWzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 17:55:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.altobelli@hp.com, greg@kroah.com


The patch titled
     hpilo: open/close fix
has been added to the -mm tree.  Its filename is
     hpilo-open-close-fix.patch

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
Subject: hpilo: open/close fix
From: David Altobelli <david.altobelli@hp.com>

The device can take a while to respond to an open/close request, so
increase the time kernel will wait for response (1 ms to 10ms).

Also, properly clean up a channel on a failed open, by calling the channel
close routine.  Just freeing the memory isn't sufficient, the device needs
to be informed that the channel is no longer open, and the device memory
cleared of references to freed dma buffer.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hpilo.c |    6 +++---
 drivers/misc/hpilo.h |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/misc/hpilo.c~hpilo-open-close-fix drivers/misc/hpilo.c
--- a/drivers/misc/hpilo.c~hpilo-open-close-fix
+++ a/drivers/misc/hpilo.c
@@ -207,7 +207,7 @@ static void ilo_ccb_close(struct pci_dev
 		  &device_ccb->recv_ctrl);
 
 	/* give iLO some time to process stop request */
-	for (retries = 1000; retries > 0; retries--) {
+	for (retries = MAX_WAIT; retries > 0; retries--) {
 		doorbell_set(driver_ccb);
 		udelay(1);
 		if (!(ioread32(&device_ccb->send_ctrl) & (1 << CTRL_BITPOS_A))
@@ -309,7 +309,7 @@ static int ilo_ccb_open(struct ilo_hwinf
 	doorbell_clr(driver_ccb);
 
 	/* make sure iLO is really handling requests */
-	for (i = 1000; i > 0; i--) {
+	for (i = MAX_WAIT; i > 0; i--) {
 		if (ilo_pkt_dequeue(hw, driver_ccb, SENDQ, &pkt_id, NULL, NULL))
 			break;
 		udelay(1);
@@ -326,7 +326,7 @@ static int ilo_ccb_open(struct ilo_hwinf
 
 	return 0;
 free:
-	pci_free_consistent(pdev, data->dma_size, data->dma_va, data->dma_pa);
+	ilo_ccb_close(pdev, data);
 out:
 	return error;
 }
diff -puN drivers/misc/hpilo.h~hpilo-open-close-fix drivers/misc/hpilo.h
--- a/drivers/misc/hpilo.h~hpilo-open-close-fix
+++ a/drivers/misc/hpilo.h
@@ -19,6 +19,8 @@
 #define MAX_ILO_DEV	1
 /* max number of files */
 #define MAX_OPEN	(MAX_CCB * MAX_ILO_DEV)
+/* spin counter for open/close delay */
+#define MAX_WAIT	10000
 
 /*
  * Per device, used to track global memory allocations.
_

Patches currently in -mm which might be from david.altobelli@hp.com are

hpilo-open-close-fix.patch

