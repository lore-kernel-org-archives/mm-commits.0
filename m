From: akpm@linux-foundation.org
Subject: - gdth-remove-gdth-cooked-up-command-accessors.patch removed from -mm tree
Date: Fri, 29 Feb 2008 00:38:14 -0800
Message-ID: <200802290838.m1T8cEng013815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873AbYB2Ijy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 03:39:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharrosh@panasas.com, jchelton@ffpglobal.com, joerg@dorchain.net, s.priebe@allied-internet.ag, mm-commits@vger.kernel.org


The patch titled
     gdth: remove gdth cooked up command accessors
has been removed from the -mm tree.  Its filename was
     gdth-remove-gdth-cooked-up-command-accessors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gdth: remove gdth cooked up command accessors
From: Boaz Harrosh <bharrosh@panasas.com>

Last patch rendered these to stupid status.  So bye bye.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Tested-by: Joerg Dorchain: <joerg@dorchain.net>
Tested-by: Stefan Priebe <s.priebe@allied-internet.ag>
Tested-by: Jon Chelton <jchelton@ffpglobal.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |   73 ++++++++----------------------------------
 1 file changed, 14 insertions(+), 59 deletions(-)

diff -puN drivers/scsi/gdth.c~gdth-remove-gdth-cooked-up-command-accessors drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~gdth-remove-gdth-cooked-up-command-accessors
+++ a/drivers/scsi/gdth.c
@@ -85,10 +85,10 @@
 
 /* The meaning of the Scsi_Pointer members in this driver is as follows:
  * ptr:                     Chaining
- * this_residual:           gdth_bufflen
- * buffer:                  gdth_sglist
+ * this_residual:           unused
+ * buffer:                  unused
  * dma_handle:              unused
- * buffers_residual:        gdth_sg_count
+ * buffers_residual:        unused
  * Status:                  unused
  * Message:                 unused
  * have_data_in:            unused
@@ -372,47 +372,6 @@ static const struct file_operations gdth
     .release = gdth_close,
 };
 
-/*
- * gdth scsi_command access wrappers.
- *   below 6 functions are used throughout the driver to access scsi_command's
- *   io parameters. The reason we do not use the regular accessors from
- *   scsi_cmnd.h is because of gdth_execute(). Since it is unrecommended for
- *   llds to directly set scsi_cmnd's IO members. This driver will use SCp
- *   members for IO parameters, and will copy scsi_cmnd's members to Scp
- *   members in queuecommand. For internal commands through gdth_execute()
- *   SCp's members will be set directly.
- */
-static inline unsigned gdth_bufflen(struct scsi_cmnd *cmd)
-{
-	return (unsigned)cmd->SCp.this_residual;
-}
-
-static inline void gdth_set_bufflen(struct scsi_cmnd *cmd, unsigned bufflen)
-{
-	cmd->SCp.this_residual = bufflen;
-}
-
-static inline unsigned gdth_sg_count(struct scsi_cmnd *cmd)
-{
-	return (unsigned)cmd->SCp.buffers_residual;
-}
-
-static inline void gdth_set_sg_count(struct scsi_cmnd *cmd, unsigned sg_count)
-{
-	cmd->SCp.buffers_residual = sg_count;
-}
-
-static inline struct scatterlist *gdth_sglist(struct scsi_cmnd *cmd)
-{
-	return cmd->SCp.buffer;
-}
-
-static inline void gdth_set_sglist(struct scsi_cmnd *cmd,
-                                   struct scatterlist *sglist)
-{
-	cmd->SCp.buffer = sglist;
-}
-
 #include "gdth_proc.h"
 #include "gdth_proc.c"
 
@@ -2330,12 +2289,12 @@ static void gdth_next(gdth_ha_str *ha)
 static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
 				    char *buffer, ushort count)
 {
-    ushort cpcount,i, max_sg = gdth_sg_count(scp);
+    ushort cpcount,i, max_sg = scsi_sg_count(scp);
     ushort cpsum,cpnow;
     struct scatterlist *sl;
     char *address;
 
-    cpcount = min_t(ushort, count, gdth_bufflen(scp));
+    cpcount = min_t(ushort, count, scsi_bufflen(scp));
 
     if (cpcount) {
         cpsum=0;
@@ -2343,7 +2302,7 @@ static void gdth_copy_internal_data(gdth
             unsigned long flags;
             cpnow = (ushort)sl->length;
             TRACE(("copy_internal() now %d sum %d count %d %d\n",
-                          cpnow, cpsum, cpcount, gdth_bufflen(scp)));
+                          cpnow, cpsum, cpcount, scsi_bufflen(scp)));
             if (cpsum+cpnow > cpcount) 
                 cpnow = cpcount - cpsum;
             cpsum += cpnow;
@@ -2566,10 +2525,10 @@ static int gdth_fill_cache_cmd(gdth_ha_s
             cmdp->u.cache.BlockCnt = blockcnt;
         }
 
-        if (gdth_bufflen(scp)) {
+        if (scsi_bufflen(scp)) {
             cmndinfo->dma_dir = (read_write == 1 ?
                 PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);   
-            sgcnt = pci_map_sg(ha->pdev, gdth_sglist(scp), gdth_sg_count(scp),
+            sgcnt = pci_map_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),
                                cmndinfo->dma_dir);
             if (mode64) {
                 struct scatterlist *sl;
@@ -2716,7 +2675,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str
             cmdp->u.raw64.lun        = l;
             cmdp->u.raw64.bus        = b;
             cmdp->u.raw64.priority   = 0;
-            cmdp->u.raw64.sdlen      = gdth_bufflen(scp);
+            cmdp->u.raw64.sdlen      = scsi_bufflen(scp);
             cmdp->u.raw64.sense_len  = 16;
             cmdp->u.raw64.sense_data = sense_paddr;
             cmdp->u.raw64.direction  = 
@@ -2733,7 +2692,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str
             cmdp->u.raw.bus        = b;
             cmdp->u.raw.priority   = 0;
             cmdp->u.raw.link_p     = 0;
-            cmdp->u.raw.sdlen      = gdth_bufflen(scp);
+            cmdp->u.raw.sdlen      = scsi_bufflen(scp);
             cmdp->u.raw.sense_len  = 16;
             cmdp->u.raw.sense_data = sense_paddr;
             cmdp->u.raw.direction  = 
@@ -2742,9 +2701,9 @@ static int gdth_fill_raw_cmd(gdth_ha_str
             cmdp->u.raw.sg_ranz    = 0;
         }
 
-        if (gdth_bufflen(scp)) {
+        if (scsi_bufflen(scp)) {
             cmndinfo->dma_dir = PCI_DMA_BIDIRECTIONAL;
-            sgcnt = pci_map_sg(ha->pdev, gdth_sglist(scp), gdth_sg_count(scp),
+            sgcnt = pci_map_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),
                                cmndinfo->dma_dir);
             if (mode64) {
                 struct scatterlist *sl;
@@ -3365,8 +3324,8 @@ static int gdth_sync_event(gdth_ha_str *
             /* retry */
             return 2;
         }
-        if (gdth_bufflen(scp))
-            pci_unmap_sg(ha->pdev, gdth_sglist(scp), gdth_sg_count(scp),
+        if (scsi_bufflen(scp))
+            pci_unmap_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),
                          cmndinfo->dma_dir);
 
         if (cmndinfo->sense_paddr)
@@ -4008,10 +3967,6 @@ static int gdth_queuecommand(struct scsi
     gdth_update_timeout(scp, scp->timeout_per_command * 6);
     cmndinfo->priority = DEFAULT_PRI;
 
-    gdth_set_bufflen(scp, scsi_bufflen(scp));
-    gdth_set_sg_count(scp, scsi_sg_count(scp));
-    gdth_set_sglist(scp, scsi_sglist(scp));
