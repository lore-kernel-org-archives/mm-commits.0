From: akpm@linux-foundation.org
Subject: - git-sas.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:27:46 -0700
Message-ID: <200708250327.l7P3Rk36028153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445AbXHYD1z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:27:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, James.Bottomley@HansenPartnership.com, James.Bottomley@SteelEye.comJames.Bottomley@SteelEye.com, jejb@mulgrave.il.steeleye.com, mm-commits@vger.kernel.org


The patch titled
     git-sas.patch
has been removed from the -mm tree.  Its filename was
     git-sas.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: git-sas.patch

GIT 41484f1919e248a6ae4a53425d146c620392fff6 git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jejb/aic94xx-sas-2.6.git

commit 
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Tue Jan 30 01:18:58 2007 -0800

    [SCSI] sas_ata: Implement sas_task_abort for ATA devices
    
    ATA devices need special handling for sas_task_abort.  If the ATA command
    came from SCSI, then we merely need to tell SCSI to abort the scsi_cmnd.
    However, internal commands require a bit more work--we need to fill the qc
    with the appropriate error status and complete the command, and eventually
    post_internal will issue the actual ABORT TASK.
    
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit 7b3e1c8ae29b1f65760bfc273db1e5c143cffdf2
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Tue Jan 30 01:18:55 2007 -0800

    [SCSI] sas_ata: Assign sas_task to scsi_cmnd to enable EH for ATA devices
    
    The SATL should connect the scsi_cmnd to the sas_task (despite the presence
    of libata) so that requests to abort scsi_cmnds headed to the ATA device
    can be processed by the EH and aborted correctly.  The abort status should
    still be propagated from sas -> ata -> scsi.
    
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit 1ae01700f271a7bb944a1d217a0c7a7e578cce57
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Tue Jan 30 01:18:52 2007 -0800

    [SCSI] libsas: Unknown STP devices should be reported to libata as unknown.
    
    When libsas encounters a STP device whose protocol isn't recognized (i.e.
    not ATA or ATAPI), we should set the ata_device's class to ATA_DEV_UNKNOWN
    instead of ATA_DEV_ATA.
    
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit 63030e51dace309002d18ef1864716ef58ad8818
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Tue Jan 30 01:18:49 2007 -0800

    [SCSI] libsas: Accept SAM_GOOD for ATAPI devices in sas_ata_task_done
    
    A sas_task sent to an ATAPI devices returns SAM_GOOD if successful.
    Therefore, we should treat this the same way we treat ATA commands
    that succeed.
    
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit 910ef39cfdac4efab5387328d1f7ce5f36e93d50
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Tue Jan 30 01:18:44 2007 -0800

    [SCSI] sas_ata: Don't copy aic94xx's sactive to ata_port
    
    Since the aic94xx sequencer assigns its own NCQ tags to ATA commands, it
    no longer makes any sense to copy the sactive field in the STP response
    to ata_port->sactive, as that will confuse libata.  Also, libata seems
    to be capable of managing sactive on its own.
    
    The attached patch gets rid of one of the causes of the BUG messages in
    ata_qc_new, and seems to work without problems on an IBM x206m.
    
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit 45c4d491df150e17715c671f1584c051c904eb2a
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Tue Jan 30 01:18:41 2007 -0800

    [SCSI] sas_ata: ata_post_internal should abort the sas_task
    
    This patch adds a new field, lldd_task, to ata_queued_cmd so that libata
    users such as libsas can associate some data with a qc.  The particular
    ambition with this patch is to associate a sas_task with a qc; that way,
    if libata decides to timeout a command, we can come back (in
    sas_ata_post_internal) and abort the sas task.
    
    One question remains: Is it necessary to reset the phy on error, or will
    the libata error handler take care of it?  (Assuming that one is written,
    of course.)  This patch, as it is today, works well enough to clean
    things up when an ATA device probe attempt fails halfway through the probe,
    though I'm not sure this is always the right thing to do.
    
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit 5c107a6df71ae22565336a9a7541d9242f919702
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Tue Jan 30 01:18:38 2007 -0800

    [SCSI] sas_ata: sas_ata_qc_issue should return AC_ERR_*
    
    The sas_ata_qc_issue function was incorrectly written to return error
    codes such as -ENOMEM.  Since libata OR's qc->err_mask with the
    return value, It is necessary to make my code return one of the
    AC_ERR_ codes instead.  For now, use AC_ERR_SYSTEM because an error
    here means that the OS couldn't send the command to the controller.
    
    If anybody has a suggestion for a better AC_ERR_ code to use, please
    suggest it.
    
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit a0305a697e599920c1c4ed9c9c58ff26d207afa2
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Tue Jan 30 01:18:35 2007 -0800

    [SCSI] sas_ata: Satisfy libata qc function locking requirements
    
    ata_qc_complete and ata_sas_queuecmd require that the port lock be held
    when they are called.  sas_ata doesn't do this, leading to BUG messages
    about qc tags newly allocated qc tags already being in use.  This patch
    fixes the locking, which should clean up the rest of those messages.
    
    So far I've tested this against an IBM x206m with two SATA disks with no
    BUG messages and no other signs of things going wrong, and the machine
    finally passed the pounder stress test.
    
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit b2397b7bf751796bae6cbfb8074e12c560b3af51
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Fri Nov 10 16:59:24 2006 -0800

    [SCSI] aic94xx: Don't call pci_map_sg for already-mapped scatterlists
    
    It turns out that libata has already dma_map_sg'd the scatterlist
    entries that go with an ata_queued_cmd by the time it calls
    sas_ata_qc_issue.  sas_ata_qc_issue passes this scatterlist to aic94xx.
    Unfortunately, aic94xx assumes that any scatterlist passed to it needs
    to be pci_map_sg'd... which blows away the mapping that libata created!
    This causes (on a x260) Calgary IOMMU table leaks and duplicate frees
    when aic94xx and libata try to {pci,dma}_unmap_sg the scatterlist.
    
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    
    Key this check off ATA_PROTOCOL_STP
    
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit cb2f6b1ef8d2d6c1aa7c207c83fc72640ae8d2a0
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Wed Oct 18 14:43:37 2006 -0700

    [SCSI] Migrate libsas ATA code into a separate file
    
    This is a respin of my earlier patch that migrates the ATA support code
    into a separate file.  For now, the controversial linking bits have
    been removed per James Bottomley's request for a patch that contains
    only the migration diffs, which means that libsas continues to require
    libata.  I intend to address that problem in a separate patch.
    
    This patch is against the aic94xx-sas-2.6 git tree, and it has been
    sanity tested on my x206m with Seagate SATA and SAS disks without
    uncovering any new problems.
    
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit b2cec263357d8bf34062075cf88784686fd012b3
Author: James Bottomley <James.Bottomley@steeleye.com>
Date:   Mon Oct 16 13:25:30 2006 -0500

    [SCSI] libsas: fixup NCQ for SATA disks
    
    We actually had two problems: the one with the tag (which is fixed by
    zeroing the tag before sending the taskfile to the sequencer) but the
    other with the fact that we sent our first NCQ command to the device
    before the sequencer had been informed of the NCQ tagging
    capabilities.  I fixed the latter by moving the rphy_add() to the
    correct point in the code after the NCQ capabilities are set up.
    
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit ca038c82159e8c867a2298c1bb07cc5583451d0d
Author: James Bottomley <James.Bottomley@steeleye.com>
Date:   Mon Oct 16 10:57:05 2006 -0500

    [SCSI] libsas: better error handling in sas_ex_discover_end_dev()
    
    This replaces a few BUG_ON() statements with the correct failure error
    handling.  There are still many more to do.
    
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit 742e67cade30f9489ad4574aa7f1402bb290e8bb
Author: James Bottomley <James.Bottomley@steeleye.com>
Date:   Sun Oct 15 20:24:35 2006 -0500

    [SCSI] aic94xx: add SATAPI support
    
    It turns out this is fairly easy to plumb in by recognising the three
    command types and copying the CDB.  The protocol response path needs to
    be amended to cope with SAS_PROTO_RESPONSE.
    
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit 1c92d850ca0be56825852cd71e3385a8f58b4cbf
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Fri Oct 13 16:56:25 2006 -0700

    [SCSI] libsas: support NCQ for SATA disks
    
    This patch adds SATAII NCQ support to libsas.  Both the use_ncq and the
    dma_xfer flags in ata_task must be set for NCQ to work correctly on the
    Adaptec SAS controller.  The rest of the patch adds ATA_FLAG_NCQ to
    sata_port_info and sets up ap->scsi_host so that ata_setup_ncq doesn't
    crash.  Please note that this patch is against the aic94xx-sas git tree,
    not scsi-misc.  Thanks also to James Bottomley for providing an earlier
    version of this patch from which to work.
    
    I've tested this patch on a x206m with a ST380819AS SATA2 disk plugged
    into the Adaptec SAS controller.  The drive came up with a queue depth
    of 31, and I successfully ran an I/O flood test to coerce libata into
    sending multiple commands simultaneously.  A kernel probe recorded the
    maximum tag number that had been seen before and after the flood test;
    before the test it was 2 and after it was 30, as I expected.
    
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit b5e50fe4ef6988e9ade04cde7edcc4f1dc628e6e
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Thu Oct 5 15:12:37 2006 -0700

    [SCSI] aic94xx: SATA tag mask not set correctly
    
    The aic94xx controller has a bitmask establishing which tags are ok to
    use with a SATA NCQ disk.  When the queue depth is 32, however, the
    expression that is used sets the mask to zero, not 0xFFFFFFFF.
    This patch widens the width of the integer so that this case is handled
    properly.
    
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit a80328440d1228d925a72a539132fd9dbbff7823
Author: James Bottomley <jejb@mulgrave.il.steeleye.com>
Date:   Thu Sep 7 15:52:09 2006 -0500

    [SCSI] fix up sas_smp_phy_control()
    
    The prototype of this has changed for the link speed setting patch.
    Need to update the SATA use of this.

commit 809dbdeb082e0d608bf7d68e8353d9d76c3dad77
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Tue Aug 22 12:39:19 2006 -0500

    [PATCH] Add SATA support to libsas STP piece for SATA on SAS expanders
    
    This patch adds support for SATA over SAS expanders to the previous two
    SATA support in libsas patches.
    
    There were a couple of nasty non trivial things to sort out before this
    one could be made to work.
    
    Firstly, I'd like to thank Doug Gilbert for diagnosing a problem with
    the LSI expanders where the REPORT_SATA_PHY command was returning the
    D2H FIS in the wrong order (Although, here, I think I have to blame the
    SAS standards which specifies the FIS "shall be returned in little
    endian format" and later on "which means resp[24] shall be FIS type"
    The latter, of course, implying big endian format).  Just to make sure,
    I put a check for the D2H FIS type being in the wrong position and
    reverse the FIS data if it is.
    
    The second is a problem outlined in Annex G of the SAS standard (again,
    a technical point with D2H FIS ... necessitating a phy reset on certain
    conditions).
    
    With the patch, I can now see my SATA-1 disk in a cascaded expander
    configuration.
    
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit 8a3aa860f2ee4f7ddc566285078e187de15697a3
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Thu Aug 10 19:19:47 2006 -0700

    [PATCH] Add SATA support to libsas
    
    Hook the scsi_host_template functions in libsas to delegate
    functionality to libata when appropriate.
    
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    
    Misc code changes and merge fixes and update for libata->drivers/ata
    move
    
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
 drivers/scsi/aic94xx/aic94xx_task.c |   16 ++
 drivers/scsi/libsas/Makefile        |    5 +
 drivers/scsi/libsas/sas_ata.c       |  Unmerged
 drivers/scsi/libsas/sas_discover.c  |  245 +++++++++++++++++++++++++++++++++++
 drivers/scsi/libsas/sas_expander.c  |   10 +
 include/scsi/libsas.h               |    7 +
 include/scsi/sas_ata.h              |  Unmerged
 7 files changed, 283 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index d5d8cab..1241f40 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -74,6 +74,7 @@ static inline int asd_map_scatterlist(st
 		return 0;
 	}
 
+<<<<<<< HEAD/drivers/scsi/aic94xx/aic94xx_task.c
 	/* STP tasks come from libata which has already mapped
 	 * the SG list */
 	if (sas_protocol_ata(task->task_proto))
@@ -81,6 +82,15 @@ static inline int asd_map_scatterlist(st
 	else
 		num_sg = pci_map_sg(asd_ha->pcidev, task->scatter,
 				    task->num_scatter, task->data_dir);
+=======
+	/* STP tasks come from libata which has already mapped
+	 * the SG list */
+	if (task->task_proto == SAS_PROTOCOL_STP)
+		num_sg = task->num_scatter;
+	else
+		num_sg = pci_map_sg(asd_ha->pcidev, task->scatter,
+				    task->num_scatter, task->data_dir);
+>>>>>>> /drivers/scsi/aic94xx/aic94xx_task.c
 	if (num_sg == 0)
 		return -ENOMEM;
 
@@ -125,9 +135,15 @@ static inline int asd_map_scatterlist(st
 
 	return 0;
 err_unmap:
+<<<<<<< HEAD/drivers/scsi/aic94xx/aic94xx_task.c
 	if (sas_protocol_ata(task->task_proto))
 		pci_unmap_sg(asd_ha->pcidev, task->scatter, task->num_scatter,
 			     task->data_dir);
+=======
+	if (task->task_proto != SAS_PROTOCOL_STP)
+		pci_unmap_sg(asd_ha->pcidev, task->scatter, task->num_scatter,
+			     task->data_dir);
+>>>>>>> /drivers/scsi/aic94xx/aic94xx_task.c
 	return res;
 }
 
diff --git a/drivers/scsi/libsas/Makefile b/drivers/scsi/libsas/Makefile
index fd387b9..af8bdb5 100644
--- a/drivers/scsi/libsas/Makefile
+++ b/drivers/scsi/libsas/Makefile
@@ -33,5 +33,10 @@ libsas-y +=  sas_init.o     \
 		sas_dump.o     \
 		sas_discover.o \
 		sas_expander.o \
+<<<<<<< HEAD/drivers/scsi/libsas/Makefile
 		sas_scsi_host.o
 libsas-$(CONFIG_SCSI_SAS_ATA) +=	sas_ata.o
+=======
+		sas_scsi_host.o \
+		sas_ata.o
+>>>>>>> /drivers/scsi/libsas/Makefile
* Unmerged path drivers/scsi/libsas/sas_ata.c
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 7ef0afc..dd7a643 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -157,6 +157,205 @@ static int sas_get_port_device(struct as
 
 /* ---------- Discover and Revalidate ---------- */
 
+<<<<<<< HEAD/drivers/scsi/libsas/sas_discover.c
+=======
+/* ---------- SATA ---------- */
+
+static void sas_get_ata_command_set(struct domain_device *dev)
+{
+	struct dev_to_host_fis *fis =
+		(struct dev_to_host_fis *) dev->frame_rcvd;
+
+	if ((fis->sector_count == 1 && /* ATA */
+	     fis->lbal         == 1 &&
+	     fis->lbam         == 0 &&
+	     fis->lbah         == 0 &&
+	     fis->device       == 0)
+	    ||
+	    (fis->sector_count == 0 && /* CE-ATA (mATA) */
+	     fis->lbal         == 0 &&
+	     fis->lbam         == 0xCE &&
+	     fis->lbah         == 0xAA &&
+	     (fis->device & ~0x10) == 0))
+
+		dev->sata_dev.command_set = ATA_COMMAND_SET;
+
+	else if ((fis->interrupt_reason == 1 &&	/* ATAPI */
+		  fis->lbal             == 1 &&
+		  fis->byte_count_low   == 0x14 &&
+		  fis->byte_count_high  == 0xEB &&
+		  (fis->device & ~0x10) == 0))
+
+		dev->sata_dev.command_set = ATAPI_COMMAND_SET;
+
+	else if ((fis->sector_count == 1 && /* SEMB */
+		  fis->lbal         == 1 &&
+		  fis->lbam         == 0x3C &&
+		  fis->lbah         == 0xC3 &&
+		  fis->device       == 0)
+		||
+		 (fis->interrupt_reason == 1 &&	/* SATA PM */
+		  fis->lbal             == 1 &&
+		  fis->byte_count_low   == 0x69 &&
+		  fis->byte_count_high  == 0x96 &&
+		  (fis->device & ~0x10) == 0))
+
+		/* Treat it as a superset? */
+		dev->sata_dev.command_set = ATAPI_COMMAND_SET;
+}
+
+/**
+ * sas_issue_ata_cmd -- Basic SATA command processing for discovery
+ * @dev: the device to send the command to
+ * @command: the command register
+ * @features: the features register
+ * @buffer: pointer to buffer to do I/O
+ * @size: size of @buffer
+ * @pci_dma_dir: PCI_DMA_...
+ */
+static int sas_issue_ata_cmd(struct domain_device *dev, u8 command,
+			     u8 features, void *buffer, int size,
+			     int pci_dma_dir)
+{
+	int res = 0;
+	struct sas_task *task;
+	struct dev_to_host_fis *d2h_fis = (struct dev_to_host_fis *)
+		&dev->frame_rcvd[0];
+
+	res = -ENOMEM;
+	task = sas_alloc_task(GFP_KERNEL);
+	if (!task)
+		goto out;
+
+	task->dev = dev;
+
+	task->ata_task.fis.fis_type = 0x27;
+	task->ata_task.fis.command = command;
+	task->ata_task.fis.features = features;
+	task->ata_task.fis.device = d2h_fis->device;
+	task->ata_task.retry_count = 1;
+
+	res = sas_execute_task(task, buffer, size, pci_dma_dir);
+
+	sas_free_task(task);
+out:
+	return res;
+}
+
+static void sas_sata_propagate_sas_addr(struct domain_device *dev)
+{
+	unsigned long flags;
+	struct asd_sas_port *port = dev->port;
+	struct asd_sas_phy  *phy;
+
+	BUG_ON(dev->parent);
+
+	memcpy(port->attached_sas_addr, dev->sas_addr, SAS_ADDR_SIZE);
+	spin_lock_irqsave(&port->phy_list_lock, flags);
+	list_for_each_entry(phy, &port->phy_list, port_phy_el)
+		memcpy(phy->attached_sas_addr, dev->sas_addr, SAS_ADDR_SIZE);
+	spin_unlock_irqrestore(&port->phy_list_lock, flags);
+}
+
+#define ATA_IDENTIFY_DEV         0xEC
+#define ATA_IDENTIFY_PACKET_DEV  0xA1
+#define ATA_SET_FEATURES         0xEF
+#define ATA_FEATURE_PUP_STBY_SPIN_UP 0x07
+
+/**
+ * sas_discover_sata_dev -- discover a STP/SATA device (SATA_DEV)
+ * @dev: STP/SATA device of interest (ATA/ATAPI)
+ *
+ * The LLDD has already been notified of this device, so that we can
+ * send FISes to it.  Here we try to get IDENTIFY DEVICE or IDENTIFY
+ * PACKET DEVICE, if ATAPI device, so that the LLDD can fine-tune its
+ * performance for this device.
+ */
+static int sas_discover_sata_dev(struct domain_device *dev)
+{
+	int     res;
+	__le16  *identify_x;
+	u8      command;
+
+	identify_x = kzalloc(512, GFP_KERNEL);
+	if (!identify_x)
+		return -ENOMEM;
+
+	if (dev->sata_dev.command_set == ATA_COMMAND_SET) {
+		dev->sata_dev.identify_device = identify_x;
+		command = ATA_IDENTIFY_DEV;
+	} else {
+		dev->sata_dev.identify_packet_device = identify_x;
+		command = ATA_IDENTIFY_PACKET_DEV;
+	}
+
+	res = sas_issue_ata_cmd(dev, command, 0, identify_x, 512,
+				PCI_DMA_FROMDEVICE);
+	if (res)
+		goto out_err;
+
+	/* lives on the media? */
+	if (le16_to_cpu(identify_x[0]) & 4) {
+		/* incomplete response */
+		SAS_DPRINTK("sending SET FEATURE/PUP_STBY_SPIN_UP to "
+			    "dev %llx\n", SAS_ADDR(dev->sas_addr));
+		if (!le16_to_cpu(identify_x[83] & (1<<6)))
+			goto cont1;
+		res = sas_issue_ata_cmd(dev, ATA_SET_FEATURES,
+					ATA_FEATURE_PUP_STBY_SPIN_UP,
+					NULL, 0, PCI_DMA_NONE);
+		if (res)
+			goto cont1;
+
+		schedule_timeout_interruptible(5*HZ); /* More time? */
+		res = sas_issue_ata_cmd(dev, command, 0, identify_x, 512,
+					PCI_DMA_FROMDEVICE);
+		if (res)
+			goto out_err;
+	}
+cont1:
+	/* Get WWN */
+	if (dev->port->oob_mode != SATA_OOB_MODE) {
+		memcpy(dev->sas_addr, dev->sata_dev.rps_resp.rps.stp_sas_addr,
+		       SAS_ADDR_SIZE);
+	} else if (dev->sata_dev.command_set == ATA_COMMAND_SET &&
+		   (le16_to_cpu(dev->sata_dev.identify_device[108]) & 0xF000)
+		   == 0x5000) {
+		int i;
+
+		for (i = 0; i < 4; i++) {
+			dev->sas_addr[2*i] =
+	     (le16_to_cpu(dev->sata_dev.identify_device[108+i]) & 0xFF00) >> 8;
+			dev->sas_addr[2*i+1] =
+	      le16_to_cpu(dev->sata_dev.identify_device[108+i]) & 0x00FF;
+		}
+	}
+	sas_hash_addr(dev->hashed_sas_addr, dev->sas_addr);
+	if (!dev->parent)
+		sas_sata_propagate_sas_addr(dev);
+
+	/* XXX Hint: register this SATA device with SATL.
+	   When this returns, dev->sata_dev->lu is alive and
+	   present.
+	sas_satl_register_dev(dev);
+	*/
+
+	sas_fill_in_rphy(dev, dev->rphy);
+
+	return 0;
+out_err:
+	dev->sata_dev.identify_packet_device = NULL;
+	dev->sata_dev.identify_device = NULL;
+	kfree(identify_x);
+	return res;
+}
+
+static int sas_discover_sata_pm(struct domain_device *dev)
+{
+	return -ENODEV;
+}
+
+>>>>>>> /drivers/scsi/libsas/sas_discover.c
 int sas_notify_lldd_dev_found(struct domain_device *dev)
 {
 	int res = 0;
@@ -189,6 +388,52 @@ void sas_notify_lldd_dev_gone(struct dom
 
 /* ---------- Common/dispatchers ---------- */
 
+<<<<<<< HEAD/drivers/scsi/libsas/sas_discover.c
+=======
+/**
+ * sas_discover_sata -- discover an STP/SATA domain device
+ * @dev: pointer to struct domain_device of interest
+ *
+ * First we notify the LLDD of this device, so we can send frames to
+ * it.  Then depending on the type of device we call the appropriate
+ * discover functions.  Once device discover is done, we notify the
+ * LLDD so that it can fine-tune its parameters for the device, by
+ * removing it and then adding it.  That is, the second time around,
+ * the driver would have certain fields, that it is looking at, set.
+ * Finally we initialize the kobj so that the device can be added to
+ * the system at registration time.  Devices directly attached to a HA
+ * port, have no parents.  All other devices do, and should have their
+ * "parent" pointer set appropriately before calling this function.
+ */
+int sas_discover_sata(struct domain_device *dev)
+{
+	int res;
+
+	sas_get_ata_command_set(dev);
+
+	res = sas_notify_lldd_dev_found(dev);
+	if (res)
+		return res;
+
+	switch (dev->dev_type) {
+	case SATA_DEV:
+		res = sas_discover_sata_dev(dev);
+		break;
+	case SATA_PM:
+		res = sas_discover_sata_pm(dev);
+		break;
+	default:
+		break;
+	}
+	sas_notify_lldd_dev_gone(dev);
+	if (!res) {
+		sas_notify_lldd_dev_found(dev);
+		res = sas_rphy_add(dev->rphy);
+	}
+
+	return res;
+}
+>>>>>>> /drivers/scsi/libsas/sas_discover.c
 
 /**
  * sas_discover_end_dev -- discover an end device (SSP, etc)
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 8727436..5046295 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -678,6 +678,7 @@ #ifdef CONFIG_SCSI_SAS_ATA
 			goto out_free;
 
 		sas_init_dev(child);
+<<<<<<< HEAD/drivers/scsi/libsas/sas_expander.c
 
 		child->rphy = rphy;
 
@@ -685,6 +686,15 @@ #ifdef CONFIG_SCSI_SAS_ATA
 		list_add_tail(&child->dev_list_node, &parent->port->dev_list);
 		spin_unlock_irq(&parent->port->dev_list_lock);
 
+=======
+
+		child->rphy = rphy;
+
+		spin_lock(&parent->port->dev_list_lock);
+		list_add_tail(&child->dev_list_node, &parent->port->dev_list);
+		spin_unlock(&parent->port->dev_list_lock);
+
+>>>>>>> /drivers/scsi/libsas/sas_expander.c
 		res = sas_discover_sata(child);
 		if (res) {
 			SAS_DPRINTK("sas_discover_sata() for device %16llx at "
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 8dda2d6..2bfb99e 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -670,10 +670,17 @@ int __sas_task_abort(struct sas_task *);
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
 int sas_eh_bus_reset_handler(struct scsi_cmnd *cmd);
 
+<<<<<<< HEAD/include/scsi/libsas.h
 extern void sas_target_destroy(struct scsi_target *);
 extern int sas_slave_alloc(struct scsi_device *);
 extern int sas_ioctl(struct scsi_device *sdev, int cmd, void __user *arg);
 
 extern int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 			   struct request *req);
+=======
+extern void sas_target_destroy(struct scsi_target *);
+extern int sas_slave_alloc(struct scsi_device *);
+extern int sas_ioctl(struct scsi_device *sdev, int cmd, void __user *arg);
+
+>>>>>>> /include/scsi/libsas.h
 #endif /* _SASLIB_H_ */
* Unmerged path include/scsi/sas_ata.h

Patches currently in -mm which might be from djwong@us.ibm.com are

git-hwmon.patch
