From: akpm@linux-foundation.org
Subject: + floppy-request-only-the-ports-we-actually-use.patch added to -mm tree
Date: Thu, 05 Feb 2009 14:29:53 -0800
Message-ID: <200902052229.n15MTrmA015782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755474AbZBEWa5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 17:30:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, abelay@mit.edu, hancockrwd@gmail.com, phdm@macqel.be, stable@kernel.org


The patch titled
     floppy: request only the ports we actually use
has been added to the -mm tree.  Its filename is
     floppy-request-only-the-ports-we-actually-use.patch

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
Subject: floppy: request only the ports we actually use
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

The floppy driver requests an I/O port it doesn't need, and sometimes this
causes a conflict with a motherboard device reported by PNPBIOS.

This patch makes the floppy driver request only the ports it actually
uses.

The current floppy driver uses only these ports:
    0x3f2 (FD_DOR)
    0x3f4 (FD_STATUS)
    0x3f5 (FD_DATA)
    0x3f7 (FD_DCR/FD_DIR)
but it requests 0x3f2-0x3f5 and 0x3f7, which includes the
unused port 0x3f3.

Some BIOSes report 0x3f3 as a motherboard resource.  The PNP system driver
reserves that, which causes a conflict when the floppy driver requests
0x3f2-0x3f5 later.

Philippe reported that this conflict broke the floppy driver between
2.6.11 and 2.6.22.  His PNPBIOS reports these devices:

    $ cat 00:07/id 00:07/resources	# motherboard device
    PNP0c02
    state = active
    io 0x80-0x80
    io 0x10-0x1f
    io 0x22-0x3f
    io 0x44-0x5f
    io 0x90-0x9f
    io 0xa2-0xbf
    io 0x3f0-0x3f1
    io 0x3f3-0x3f3

    $ cat 00:03/id 00:03/resources	# floppy device
    PNP0700
    state = active
    io 0x3f4-0x3f5
    io 0x3f2-0x3f2

Reference:
    http://lkml.org/lkml/2009/1/31/162

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Reported-by: Philippe De Muyter <phdm@macqel.be>
Tested-by: Philippe De Muyter <phdm@macqel.be>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Robert Hancock <hancockrwd@gmail.com>
Cc: <stable@kernel.org>	[2.6.25.x, 2.6.26.x, 2.6.27.x, 2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/block/floppy.c~floppy-request-only-the-ports-we-actually-use drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-request-only-the-ports-we-actually-use
+++ a/drivers/block/floppy.c
@@ -4398,15 +4398,20 @@ static int floppy_grab_irq_and_dma(void)
 
 	for (fdc = 0; fdc < N_FDC; fdc++) {
 		if (FDCS->address != -1) {
-			if (!request_region(FDCS->address + 2, 4, "floppy")) {
+			if (!request_region(FDCS->address + 2, 1, "floppy")) {
 				DPRINT("Floppy io-port 0x%04lx in use\n",
 				       FDCS->address + 2);
 				goto cleanup1;
 			}
+			if (!request_region(FDCS->address + 4, 2, "floppy")) {
+				DPRINT("Floppy io-port 0x%04lx in use\n",
+				       FDCS->address + 4);
+				goto cleanup2;
+			}
 			if (!request_region(FDCS->address + 7, 1, "floppy DIR")) {
 				DPRINT("Floppy io-port 0x%04lx in use\n",
 				       FDCS->address + 7);
-				goto cleanup2;
+				goto cleanup3;
 			}
 			/* address + 6 is reserved, and may be taken by IDE.
 			 * Unfortunately, Adaptec doesn't know this :-(, */
@@ -4431,13 +4436,16 @@ static int floppy_grab_irq_and_dma(void)
 	fdc = 0;
 	irqdma_allocated = 1;
 	return 0;
+cleanup3:
+	release_region(FDCS->address + 4, 2);
 cleanup2:
-	release_region(FDCS->address + 2, 4);
+	release_region(FDCS->address + 2, 1);
 cleanup1:
 	fd_free_irq();
 	fd_free_dma();
 	while (--fdc >= 0) {
-		release_region(FDCS->address + 2, 4);
+		release_region(FDCS->address + 2, 1);
+		release_region(FDCS->address + 4, 2);
 		release_region(FDCS->address + 7, 1);
 	}
 	spin_lock_irqsave(&floppy_usage_lock, flags);
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
floppy-request-only-the-ports-we-actually-use.patch
pnpbios-fix-warning-if-no-hotplug.patch
pnpbios-propagate-kthread_run-error.patch

