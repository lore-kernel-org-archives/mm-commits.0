From: akpm@linux-foundation.org
Subject: - aacraid-fix-endianness-warnings.patch removed from -mm tree
Date: Fri, 09 Nov 2007 10:49:36 -0800
Message-ID: <200711091849.lA9InaXp027133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38149 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842AbXKISue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 13:50:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@infradead.org, hch@lst.de, mark_salyzyn@adaptec.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     aacraid: fix endianness warnings
has been removed from the -mm tree.  Its filename was
     aacraid-fix-endianness-warnings.patch

This patch was dropped because of rejects

------------------------------------------------------
Subject: aacraid: fix endianness warnings
From: Christoph Hellwig <hch@infradead.org>

There are a lot of endianess warnings, fortunately most of them harmless. 
The patch below fixes all of them up (including the ones in the patch I
replied to), except for aac_init_adapter which is really odd and I don't
know what to do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/aachba.c  |    8 ++---
 drivers/scsi/aacraid/commsup.c |   48 +++++++++++++++----------------
 drivers/scsi/aacraid/dpcsup.c  |    8 +----
 drivers/scsi/aacraid/linit.c   |    4 +-
 drivers/scsi/aacraid/rx.c      |    2 -
 5 files changed, 34 insertions(+), 36 deletions(-)

diff -puN drivers/scsi/aacraid/aachba.c~aacraid-fix-endianness-warnings drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c~aacraid-fix-endianness-warnings
+++ a/drivers/scsi/aacraid/aachba.c
@@ -981,7 +981,7 @@ static int aac_read_block(struct fib * f
 	aac_fib_init(fib);
 	readcmd = (struct aac_read *) fib_data(fib);
 	readcmd->command = cpu_to_le32(VM_CtBlockRead);
-	readcmd->cid = cpu_to_le16(scmd_id(cmd));
+	readcmd->cid = cpu_to_le32(scmd_id(cmd));
 	readcmd->block = cpu_to_le32((u32)(lba&0xffffffff));
 	readcmd->count = cpu_to_le32(count * 512);
 
@@ -1072,7 +1072,7 @@ static int aac_write_block(struct fib * 
 	aac_fib_init(fib);
 	writecmd = (struct aac_write *) fib_data(fib);
 	writecmd->command = cpu_to_le32(VM_CtBlockWrite);
-	writecmd->cid = cpu_to_le16(scmd_id(cmd));
+	writecmd->cid = cpu_to_le32(scmd_id(cmd));
 	writecmd->block = cpu_to_le32((u32)(lba&0xffffffff));
 	writecmd->count = cpu_to_le32(count * 512);
 	writecmd->sg.count = cpu_to_le32(1);
@@ -1317,8 +1317,8 @@ int aac_get_adapter_info(struct aac_dev*
 			  dev->supplement_adapter_info.VpdInfo.Tsid);
 		}
 		if (!aac_check_reset ||
-		  (dev->supplement_adapter_info.SupportedOptions2 &
-		  le32_to_cpu(AAC_OPTION_IGNORE_RESET))) {
+		    (dev->supplement_adapter_info.SupportedOptions2 &
+		     cpu_to_le32(AAC_OPTION_IGNORE_RESET))) {
 			printk(KERN_INFO "%s%d: Reset Adapter Ignored\n",
 			  dev->name, dev->id);
 		}
diff -puN drivers/scsi/aacraid/commsup.c~aacraid-fix-endianness-warnings drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c~aacraid-fix-endianness-warnings
+++ a/drivers/scsi/aacraid/commsup.c
@@ -796,13 +796,13 @@ static void aac_handle_aif(struct aac_de
 	 */
 	switch (le32_to_cpu(aifcmd->command)) {
 	case AifCmdDriverNotify:
-		switch (le32_to_cpu(((u32 *)aifcmd->data)[0])) {
+		switch (le32_to_cpu(((__le32 *)aifcmd->data)[0])) {
 		/*
 		 *	Morph or Expand complete
 		 */
 		case AifDenMorphComplete:
 		case AifDenVolumeExtendComplete:
-			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			container = le32_to_cpu(((__le32 *)aifcmd->data)[1]);
 			if (container >= dev->maximum_num_containers)
 				break;
 
@@ -835,25 +835,25 @@ static void aac_handle_aif(struct aac_de
 			if (container >= dev->maximum_num_containers)
 				break;
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(u32 *)aifcmd->data)) &&
+			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		} else for (container = 0;
 		    container < dev->maximum_num_containers; ++container) {
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(u32 *)aifcmd->data)) &&
+			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		}
 		break;
 
 	case AifCmdEventNotify:
-		switch (le32_to_cpu(((u32 *)aifcmd->data)[0])) {
+		switch (le32_to_cpu(((__le32 *)aifcmd->data)[0])) {
 		/*
 		 *	Add an Array.
 		 */
 		case AifEnAddContainer:
-			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			container = le32_to_cpu(((__le32 *)aifcmd->data)[1]);
 			if (container >= dev->maximum_num_containers)
 				break;
 			dev->fsa_dev[container].config_needed = ADD;
@@ -866,7 +866,7 @@ static void aac_handle_aif(struct aac_de
 		 *	Delete an Array.
 		 */
 		case AifEnDeleteContainer:
-			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			container = le32_to_cpu(((__le32 *)aifcmd->data)[1]);
 			if (container >= dev->maximum_num_containers)
 				break;
 			dev->fsa_dev[container].config_needed = DELETE;
@@ -880,7 +880,7 @@ static void aac_handle_aif(struct aac_de
 		 * waiting on something else, setup to wait on a Config Change.
 		 */
 		case AifEnContainerChange:
-			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			container = le32_to_cpu(((__le32 *)aifcmd->data)[1]);
 			if (container >= dev->maximum_num_containers)
 				break;
 			if (dev->fsa_dev[container].config_waiting_on &&
@@ -905,13 +905,13 @@ static void aac_handle_aif(struct aac_de
 			if (container >= dev->maximum_num_containers)
 				break;
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(u32 *)aifcmd->data)) &&
+			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		} else for (container = 0;
 		    container < dev->maximum_num_containers; ++container) {
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(u32 *)aifcmd->data)) &&
+			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		}
@@ -926,9 +926,9 @@ static void aac_handle_aif(struct aac_de
 		 * wait for a container change.
 		 */
 
-		if ((((u32 *)aifcmd->data)[1] == cpu_to_le32(AifJobCtrZero))
-		 && ((((u32 *)aifcmd->data)[6] == ((u32 *)aifcmd->data)[5])
-		  || (((u32 *)aifcmd->data)[4] == cpu_to_le32(AifJobStsSuccess)))) {
+		if (((__le32 *)aifcmd->data)[1] == cpu_to_le32(AifJobCtrZero) &&
+		    (((__le32 *)aifcmd->data)[6] == ((__le32 *)aifcmd->data)[5] ||
+		     ((__le32 *)aifcmd->data)[4] == cpu_to_le32(AifJobStsSuccess))) {
 			for (container = 0;
 			    container < dev->maximum_num_containers;
 			    ++container) {
@@ -943,9 +943,9 @@ static void aac_handle_aif(struct aac_de
 					jiffies;
 			}
 		}
-		if ((((u32 *)aifcmd->data)[1] == cpu_to_le32(AifJobCtrZero))
-		 && (((u32 *)aifcmd->data)[6] == 0)
-		 && (((u32 *)aifcmd->data)[4] == cpu_to_le32(AifJobStsRunning))) {
+		if (((__le32 *)aifcmd->data)[1] == cpu_to_le32(AifJobCtrZero) &&
+		    ((__le32 *)aifcmd->data)[6] == 0 &&
+		    ((__le32 *)aifcmd->data)[4] == cpu_to_le32(AifJobStsRunning)) {
 			for (container = 0;
 			    container < dev->maximum_num_containers;
 			    ++container) {
@@ -1339,10 +1339,10 @@ int aac_check_health(struct aac_dev * aa
 			aif = (struct aac_aifcmd *)hw_fib->data;
 			aif->command = cpu_to_le32(AifCmdEventNotify);
 		 	aif->seqnum = cpu_to_le32(0xFFFFFFFF);
-		 	aif->data[0] = cpu_to_le32(AifEnExpEvent);
-			aif->data[1] = cpu_to_le32(AifExeFirmwarePanic);
-		 	aif->data[2] = cpu_to_le32(AifHighPriority);
-			aif->data[3] = cpu_to_le32(BlinkLED);
+		 	aif->data[0] = AifEnExpEvent;
+			aif->data[1] = AifExeFirmwarePanic;
+		 	aif->data[2] = AifHighPriority;
+			aif->data[3] = BlinkLED;
 
 			/*
 			 * Put the FIB onto the
@@ -1373,8 +1373,8 @@ int aac_check_health(struct aac_dev * aa
 	printk(KERN_ERR "%s: Host adapter BLINK LED 0x%x\n", aac->name, BlinkLED);
 
 	if (!aac_check_reset ||
-		(aac->supplement_adapter_info.SupportedOptions2 &
-			le32_to_cpu(AAC_OPTION_IGNORE_RESET)))
+	    (aac->supplement_adapter_info.SupportedOptions2 &
+	     cpu_to_le32(AAC_OPTION_IGNORE_RESET)))
 		goto out;
 	host = aac->scsi_host_ptr;
 	if (aac->thread->pid != current->pid)
@@ -1655,11 +1655,11 @@ int aac_command_thread(void *data)
 				struct fib *fibptr;
 
 				if ((fibptr = aac_fib_alloc(dev))) {
-					u32 * info;
+					__le32 *info;
 
 					aac_fib_init(fibptr);
 
-					info = (u32 *) fib_data(fibptr);
+					info = (__le32 *) fib_data(fibptr);
 					if (now.tv_usec > 500000)
 						++now.tv_sec;
 
diff -puN drivers/scsi/aacraid/dpcsup.c~aacraid-fix-endianness-warnings drivers/scsi/aacraid/dpcsup.c
--- a/drivers/scsi/aacraid/dpcsup.c~aacraid-fix-endianness-warnings
+++ a/drivers/scsi/aacraid/dpcsup.c
@@ -229,11 +229,9 @@ unsigned int aac_command_normal(struct a
  *	all QE there are and wake up all the waiters before exiting.
  */
 
-unsigned int aac_intr_normal(struct aac_dev * dev, u32 Index)
+unsigned int aac_intr_normal(struct aac_dev * dev, u32 index)
 {
-	u32 index = le32_to_cpu(Index);
-
-	dprintk((KERN_INFO "aac_intr_normal(%p,%x)\n", dev, Index));
+	dprintk((KERN_INFO "aac_intr_normal(%p,%x)\n", dev, index));
 	if ((index & 0x00000002L)) {
 		struct hw_fib * hw_fib;
 		struct fib * fib;
@@ -301,7 +299,7 @@ unsigned int aac_intr_normal(struct aac_
 
 		if (hwfib->header.Command == cpu_to_le16(NuFileSystem))
 		{
-			u32 *pstatus = (u32 *)hwfib->data;
+			__le32 *pstatus = (__le32 *)hwfib->data;
 			if (*pstatus & cpu_to_le32(0xffff0000))
 				*pstatus = cpu_to_le32(ST_OK);
 		}
diff -puN drivers/scsi/aacraid/linit.c~aacraid-fix-endianness-warnings drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~aacraid-fix-endianness-warnings
+++ a/drivers/scsi/aacraid/linit.c
@@ -590,8 +590,8 @@ static int aac_eh_reset(struct scsi_cmnd
 	 * support a register, instead of a commanded, reset.
 	 */
 	if ((aac->supplement_adapter_info.SupportedOptions2 &
-	  le32_to_cpu(AAC_OPTION_MU_RESET|AAC_OPTION_IGNORE_RESET)) ==
-	  le32_to_cpu(AAC_OPTION_MU_RESET))
+	     cpu_to_le32(AAC_OPTION_MU_RESET|AAC_OPTION_IGNORE_RESET)) ==
+	     cpu_to_le32(AAC_OPTION_MU_RESET))
 		aac_reset_adapter(aac, 2); /* Bypass wait for command quiesce */
 	return SUCCESS; /* Cause an immediate retry of the command with a ten second delay after successful tur */
 }
diff -puN drivers/scsi/aacraid/rx.c~aacraid-fix-endianness-warnings drivers/scsi/aacraid/rx.c
--- a/drivers/scsi/aacraid/rx.c~aacraid-fix-endianness-warnings
+++ a/drivers/scsi/aacraid/rx.c
@@ -465,7 +465,7 @@ static int aac_rx_restart_adapter(struct
 	u32 var;
 
 	if (!(dev->supplement_adapter_info.SupportedOptions2 &
-	  le32_to_cpu(AAC_OPTION_MU_RESET)) || (bled >= 0) || (bled == -2)) {
+	    cpu_to_le32(AAC_OPTION_MU_RESET)) || (bled >= 0) || (bled == -2)) {
 		if (bled)
 			printk(KERN_ERR "%s%d: adapter kernel panic'd %x.\n",
 				dev->name, dev->id, bled);
_

Patches currently in -mm which might be from hch@infradead.org are

git-gfs2-nmw.patch
git-scsi-misc.patch
aacraid-fix-endianness-warnings.patch
aacraid-fix-endianness-warnings-checkpatch-fixes.patch
git-xfs.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
d_path-make-d_path-use-a-struct-path.patch
