From: akpm@linux-foundation.org
Subject: [folded] floppy-request-only-the-ports-we-actually-use-fix.patch removed from -mm tree
Date: Tue, 17 Feb 2009 14:03:24 -0800
Message-ID: <200902172203.n1HM3Ont003132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755254AbZBQWD7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 17:03:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phdm@macqel.be, abelay@mit.edu, bjorn.helgaas@hp.com, hancockrwd@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     floppy: release only the ports we actually requested
has been removed from the -mm tree.  Its filename was
     floppy-request-only-the-ports-we-actually-use-fix.patch

This patch was dropped because it was folded into floppy-request-only-the-ports-we-actually-use.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: floppy: release only the ports we actually requested
From: Philippe De Muyter <phdm@macqel.be>

With the last floppy patch, the floppy driver requests only the ports that
it really uses, but the code contains yet places where it releases those
unrequested ports.  I don't know if it is harmfull, but I think it is
cleaner that the parameters of the release_region calls match the
request_region ones.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Robert Hancock <hancockrwd@gmail.com>
Cc: <stable@kernel.org>	[2.6.25.x, 2.6.26.x, 2.6.27.x, 2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/block/floppy.c~floppy-request-only-the-ports-we-actually-use-fix drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-request-only-the-ports-we-actually-use-fix
+++ a/drivers/block/floppy.c
@@ -4273,7 +4273,8 @@ static int __init floppy_init(void)
 		FDCS->rawcmd = 2;
 		if (user_reset_fdc(-1, FD_RESET_ALWAYS, 0)) {
 			/* free ioports reserved by floppy_grab_irq_and_dma() */
-			release_region(FDCS->address + 2, 4);
+			release_region(FDCS->address + 2, 1);
+			release_region(FDCS->address + 4, 2);
 			release_region(FDCS->address + 7, 1);
 			FDCS->address = -1;
 			FDCS->version = FDC_NONE;
@@ -4283,7 +4284,8 @@ static int __init floppy_init(void)
 		FDCS->version = get_fdc_version();
 		if (FDCS->version == FDC_NONE) {
 			/* free ioports reserved by floppy_grab_irq_and_dma() */
-			release_region(FDCS->address + 2, 4);
+			release_region(FDCS->address + 2, 1);
+			release_region(FDCS->address + 4, 2);
 			release_region(FDCS->address + 7, 1);
 			FDCS->address = -1;
 			continue;
@@ -4509,7 +4511,8 @@ static void floppy_release_irq_and_dma(v
 	old_fdc = fdc;
 	for (fdc = 0; fdc < N_FDC; fdc++)
 		if (FDCS->address != -1) {
-			release_region(FDCS->address + 2, 4);
+			release_region(FDCS->address + 2, 1);
+			release_region(FDCS->address + 4, 2);
 			release_region(FDCS->address + 7, 1);
 		}
 	fdc = old_fdc;
_

Patches currently in -mm which might be from phdm@macqel.be are

floppy-request-only-the-ports-we-actually-use.patch
floppy-request-only-the-ports-we-actually-use-fix.patch

