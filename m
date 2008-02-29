From: akpm@linux-foundation.org
Subject: - gdth-fix-to-internal-commands-execution.patch removed from -mm tree
Date: Fri, 29 Feb 2008 00:38:08 -0800
Message-ID: <200802290838.m1T8c89J013802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890AbYB2Ijy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 03:39:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharrosh@panasas.com, jchelton@ffpglobal.com, joerg@dorchain.net, s.priebe@allied-internet.ag, mm-commits@vger.kernel.org


The patch titled
     gdth: fix to internal commands execution
has been removed from the -mm tree.  Its filename was
     gdth-fix-to-internal-commands-execution.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gdth: fix to internal commands execution
From: Boaz Harrosh <bharrosh@panasas.com>

The recent patch named:
  [SCSI] gdth: !use_sg cleanup and use of scsi accessors

Has done a bad job in handling internal commands issued by gdth_execute().

Internal commands are issued with device gdth_cmd_str ready made directly to
the card, without any mapping or translations of scsi commands.  So here I
added a gdth_cmd_str pointer to the gdth_cmndinfo private structure which is
then copied directly to host.

following this patch is a cleanup that removes the home cooked accessors and
reverts them to regular scsi_cmnd accessors.  Since they are not used anymore.
 After review maybe the 2 patches should be squashed together.

FIXME: There is still a problem with gdth_get_info(). as reported there
   is a WARN_ON trigerd in dma_free_coherent() when doing:
   $ cat /proc/sys/gdth/0

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Tested-by: Joerg Dorchain: <joerg@dorchain.net>
Tested-by: Stefan Priebe <s.priebe@allied-internet.ag>
Tested-by: Jon Chelton <jchelton@ffpglobal.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |   30 ++++++++++++------------------
 drivers/scsi/gdth.h |    1 +
 2 files changed, 13 insertions(+), 18 deletions(-)

diff -puN drivers/scsi/gdth.c~gdth-fix-to-internal-commands-execution drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~gdth-fix-to-internal-commands-execution
+++ a/drivers/scsi/gdth.c
@@ -160,7 +160,7 @@ static void gdth_readapp_event(gdth_ha_s
 static void gdth_clear_events(void);
 
 static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
-                                    char *buffer, ushort count, int to_buffer);
+                                    char *buffer, ushort count);
 static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
 static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive);
 
@@ -438,8 +438,8 @@ static struct gdth_cmndinfo *gdth_get_cm
 	for (i=0; i<GDTH_MAXCMDS; ++i) {
 		if (ha->cmndinfo[i].index == 0) {
 			priv = &ha->cmndinfo[i];
-			priv->index = i+1;
 			memset(priv, 0, sizeof(*priv));
+			priv->index = i+1;
 			break;
 		}
 	}
@@ -486,7 +486,6 @@ int __gdth_execute(struct scsi_device *s
     gdth_ha_str *ha = shost_priv(sdev->host);
     Scsi_Cmnd *scp;
     struct gdth_cmndinfo cmndinfo;
-    struct scatterlist one_sg;
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;
 
@@ -500,13 +499,10 @@ int __gdth_execute(struct scsi_device *s
     /* use request field to save the ptr. to completion struct. */
     scp->request = (struct request *)&wait;
     scp->timeout_per_command = timeout*HZ;
-    sg_init_one(&one_sg, gdtcmd, sizeof(*gdtcmd));
-    gdth_set_sglist(scp, &one_sg);
-    gdth_set_sg_count(scp, 1);
-    gdth_set_bufflen(scp, sizeof(*gdtcmd));
     scp->cmd_len = 12;
     memcpy(scp->cmnd, cmnd, 12);
     cmndinfo.priority = IOCTL_PRI;
+    cmndinfo.internal_cmd_str = gdtcmd;
     cmndinfo.internal_command = 1;
 
     TRACE(("__gdth_execute() cmd 0x%x\n", scp->cmnd[0]));
@@ -2332,7 +2328,7 @@ static void gdth_next(gdth_ha_str *ha)
  * buffers, kmap_atomic() as needed.
  */
 static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
-                                    char *buffer, ushort count, int to_buffer)
+                                    char *buffer, ushort count)
 {
     ushort cpcount,i, max_sg = gdth_sg_count(scp);
     ushort cpsum,cpnow;
@@ -2358,10 +2354,7 @@ static void gdth_copy_internal_data(gdth
             }
             local_irq_save(flags);
             address = kmap_atomic(sg_page(sl), KM_BIO_SRC_IRQ) + sl->offset;
-            if (to_buffer)
-                memcpy(buffer, address, cpnow);
-            else
-                memcpy(address, buffer, cpnow);
+            memcpy(address, buffer, cpnow);
             flush_dcache_page(sg_page(sl));
             kunmap_atomic(address, KM_BIO_SRC_IRQ);
             local_irq_restore(flags);
@@ -2415,7 +2408,7 @@ static int gdth_internal_cache_cmd(gdth_
         strcpy(inq.vendor,ha->oem_name);
         sprintf(inq.product,"Host Drive  #%02d",t);
         strcpy(inq.revision,"   ");
-        gdth_copy_internal_data(ha, scp, (char*)&inq, sizeof(gdth_inq_data), 0);
+        gdth_copy_internal_data(ha, scp, (char*)&inq, sizeof(gdth_inq_data));
         break;
 
       case REQUEST_SENSE:
@@ -2425,7 +2418,7 @@ static int gdth_internal_cache_cmd(gdth_
         sd.key       = NO_SENSE;
         sd.info      = 0;
         sd.add_length= 0;
-        gdth_copy_internal_data(ha, scp, (char*)&sd, sizeof(gdth_sense_data), 0);
+        gdth_copy_internal_data(ha, scp, (char*)&sd, sizeof(gdth_sense_data));
         break;
 
       case MODE_SENSE:
@@ -2437,7 +2430,7 @@ static int gdth_internal_cache_cmd(gdth_
         mpd.bd.block_length[0] = (SECTOR_SIZE & 0x00ff0000) >> 16;
         mpd.bd.block_length[1] = (SECTOR_SIZE & 0x0000ff00) >> 8;
         mpd.bd.block_length[2] = (SECTOR_SIZE & 0x000000ff);
-        gdth_copy_internal_data(ha, scp, (char*)&mpd, sizeof(gdth_modep_data), 0);
+        gdth_copy_internal_data(ha, scp, (char*)&mpd, sizeof(gdth_modep_data));
         break;
 
       case READ_CAPACITY:
@@ -2447,7 +2440,7 @@ static int gdth_internal_cache_cmd(gdth_
         else
             rdc.last_block_no = cpu_to_be32(ha->hdr[t].size-1);
         rdc.block_length  = cpu_to_be32(SECTOR_SIZE);
-        gdth_copy_internal_data(ha, scp, (char*)&rdc, sizeof(gdth_rdcap_data), 0);
+        gdth_copy_internal_data(ha, scp, (char*)&rdc, sizeof(gdth_rdcap_data));
         break;
 
       case SERVICE_ACTION_IN:
@@ -2459,7 +2452,7 @@ static int gdth_internal_cache_cmd(gdth_
             rdc16.last_block_no = cpu_to_be64(ha->hdr[t].size-1);
             rdc16.block_length  = cpu_to_be32(SECTOR_SIZE);
             gdth_copy_internal_data(ha, scp, (char*)&rdc16,
-                                                 sizeof(gdth_rdcap16_data), 0);
+                                                 sizeof(gdth_rdcap16_data));
         } else { 
             scp->result = DID_ABORT << 16;
         }
@@ -2829,6 +2822,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str
 static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
 {
     register gdth_cmd_str *cmdp;
+    struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
     int cmd_index;
 
     cmdp= ha->pccb;
@@ -2837,7 +2831,7 @@ static int gdth_special_cmd(gdth_ha_str 
     if (ha->type==GDT_EISA && ha->cmd_cnt>0) 
         return 0;
 
-    gdth_copy_internal_data(ha, scp, (char *)cmdp, sizeof(gdth_cmd_str), 1);
+    *cmdp = *cmndinfo->internal_cmd_str;
     cmdp->RequestBuffer = scp;
 
     /* search free command index */
diff -puN drivers/scsi/gdth.h~gdth-fix-to-internal-commands-execution drivers/scsi/gdth.h
--- a/drivers/scsi/gdth.h~gdth-fix-to-internal-commands-execution
+++ a/drivers/scsi/gdth.h
@@ -913,6 +913,7 @@ typedef struct {
     struct gdth_cmndinfo {                      /* per-command private info */
         int index;
         int internal_command;                   /* don't call scsi_done */
+        gdth_cmd_str *internal_cmd_str;         /* crier for internal messages*/
         dma_addr_t sense_paddr;                 /* sense dma-addr */
         unchar priority;
         int timeout;
_

Patches currently in -mm which might be from bharrosh@panasas.com are

git-scsi-misc.patch

