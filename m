From: akpm@linux-foundation.org
Subject: + cleanup-variable-usage-in-mesh-interrupt-handler.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:39:23 -0800
Message-ID: <200702130539.l1D5dNMo022774@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55347 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161082AbXBMFj1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:39:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de, James.Bottomley@steeleye.com


The patch titled
     cleanup variable usage in mesh interrupt handler
has been added to the -mm tree.  Its filename is
     cleanup-variable-usage-in-mesh-interrupt-handler.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cleanup variable usage in mesh interrupt handler
From: Olaf Hering <olaf@aepfle.de>

_ convert void* to struct mesh_state*

- remove unused irq argument from mesh_interrupt()

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mesh.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/mesh.c~cleanup-variable-usage-in-mesh-interrupt-handler drivers/scsi/mesh.c
--- a/drivers/scsi/mesh.c~cleanup-variable-usage-in-mesh-interrupt-handler
+++ a/drivers/scsi/mesh.c
@@ -185,7 +185,7 @@ struct mesh_state {
  * Driver is too messy, we need a few prototypes...
  */
 static void mesh_done(struct mesh_state *ms, int start_next);
-static void mesh_interrupt(int irq, void *dev_id);
+static void mesh_interrupt(struct mesh_state *ms);
 static void cmd_complete(struct mesh_state *ms);
 static void set_dma_cmds(struct mesh_state *ms, struct scsi_cmnd *cmd);
 static void halt_dma(struct mesh_state *ms);
@@ -466,7 +466,7 @@ static void mesh_start_cmd(struct mesh_s
 				dlog(ms, "intr b4 arb, intr/exc/err/fc=%.8x",
 				     MKWORD(mr->interrupt, mr->exception,
 					    mr->error, mr->fifo_count));
-				mesh_interrupt(0, (void *)ms);
+				mesh_interrupt(ms);
 				if (ms->phase != arbitrating)
 					return;
 			}
@@ -504,7 +504,7 @@ static void mesh_start_cmd(struct mesh_s
 		dlog(ms, "intr after disresel, intr/exc/err/fc=%.8x",
 		     MKWORD(mr->interrupt, mr->exception,
 			    mr->error, mr->fifo_count));
-		mesh_interrupt(0, (void *)ms);
+		mesh_interrupt(ms);
 		if (ms->phase != arbitrating)
 			return;
 		dlog(ms, "after intr after disresel, intr/exc/err/fc=%.8x",
@@ -1018,10 +1018,11 @@ static void handle_reset(struct mesh_sta
 static irqreturn_t do_mesh_interrupt(int irq, void *dev_id)
 {
 	unsigned long flags;
-	struct Scsi_Host *dev = ((struct mesh_state *)dev_id)->host;
+	struct mesh_state *ms = dev_id;
+	struct Scsi_Host *dev = ms->host;
 	
 	spin_lock_irqsave(dev->host_lock, flags);
-	mesh_interrupt(irq, dev_id);
+	mesh_interrupt(ms);
 	spin_unlock_irqrestore(dev->host_lock, flags);
 	return IRQ_HANDLED;
 }
@@ -1661,9 +1662,8 @@ static int mesh_queue(struct scsi_cmnd *
  * handler (do_mesh_interrupt) or by other functions in
  * exceptional circumstances
  */
-static void mesh_interrupt(int irq, void *dev_id)
+static void mesh_interrupt(struct mesh_state *ms)
 {
-	struct mesh_state *ms = (struct mesh_state *) dev_id;
 	volatile struct mesh_regs __iomem *mr = ms->mesh;
 	int intr;
 
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
move-variables-in-drivers-macintosh-to-bss.patch
add-delay-around-sl82c105_reset_engine-calls.patch
cleanup-variable-usage-in-mesh-interrupt-handler.patch
