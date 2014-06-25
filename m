From: akpm@linux-foundation.org
Subject: + scsi-use-pci_zalloc_consistent.patch added to -mm tree
Date: Wed, 25 Jun 2014 12:30:23 -0700
Message-ID: <53ab234f.4iv1PxvCpEEje4Uy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbaFYTaY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 15:30:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, JBottomley@parallels.com, ballabio_dario@emc.com, jayamohan.kallickal@emulex.com, linuxraid@lsi.com, megaraidlinux@lsi.com, mike@i-Connect.Net, scameron@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: use pci_zalloc_consistent
has been added to the -mm tree.  Its filename is
     scsi-use-pci_zalloc_consistent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scsi-use-pci_zalloc_consistent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scsi-use-pci_zalloc_consistent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: scsi: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Adam Radford <linuxraid@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Cc: Dario Ballabio <ballabio_dario@emc.com>
Cc: Michael Neuffer <mike@i-Connect.Net>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/3w-sas.c                     |    5 ++---
 drivers/scsi/a100u2w.c                    |    8 ++------
 drivers/scsi/be2iscsi/be_main.c           |   10 ++++------
 drivers/scsi/be2iscsi/be_mgmt.c           |    3 +--
 drivers/scsi/csiostor/csio_wr.c           |    8 +-------
 drivers/scsi/eata.c                       |    5 ++---
 drivers/scsi/hpsa.c                       |    8 +++-----
 drivers/scsi/megaraid/megaraid_mbox.c     |   16 +++++++---------
 drivers/scsi/megaraid/megaraid_sas_base.c |    8 +++-----
 drivers/scsi/mesh.c                       |    6 ++----
 drivers/scsi/mvumi.c                      |    9 +++------
 drivers/scsi/pm8001/pm8001_sas.c          |    5 ++---
 12 files changed, 32 insertions(+), 59 deletions(-)

diff -puN drivers/scsi/3w-sas.c~scsi-use-pci_zalloc_consistent drivers/scsi/3w-sas.c
--- a/drivers/scsi/3w-sas.c~scsi-use-pci_zalloc_consistent
+++ a/drivers/scsi/3w-sas.c
@@ -683,14 +683,13 @@ static int twl_allocate_memory(TW_Device
 	unsigned long *cpu_addr;
 	int retval = 1;
 
-	cpu_addr = pci_alloc_consistent(tw_dev->tw_pci_dev, size*TW_Q_LENGTH, &dma_handle);
+	cpu_addr = pci_zalloc_consistent(tw_dev->tw_pci_dev, size * TW_Q_LENGTH,
+					 &dma_handle);
 	if (!cpu_addr) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x5, "Memory allocation failed");
 		goto out;
 	}
 
-	memset(cpu_addr, 0, size*TW_Q_LENGTH);
-
 	for (i = 0; i < TW_Q_LENGTH; i++) {
 		switch(which) {
 		case 0:
diff -puN drivers/scsi/a100u2w.c~scsi-use-pci_zalloc_consistent drivers/scsi/a100u2w.c
--- a/drivers/scsi/a100u2w.c~scsi-use-pci_zalloc_consistent
+++ a/drivers/scsi/a100u2w.c
@@ -1125,23 +1125,19 @@ static int inia100_probe_one(struct pci_
 
 	/* Get total memory needed for SCB */
 	sz = ORC_MAXQUEUE * sizeof(struct orc_scb);
-	host->scb_virt = pci_alloc_consistent(pdev, sz,
-			&host->scb_phys);
+	host->scb_virt = pci_zalloc_consistent(pdev, sz, &host->scb_phys);
 	if (!host->scb_virt) {
 		printk("inia100: SCB memory allocation error\n");
 		goto out_host_put;
 	}
-	memset(host->scb_virt, 0, sz);
 
 	/* Get total memory needed for ESCB */
 	sz = ORC_MAXQUEUE * sizeof(struct orc_extended_scb);
-	host->escb_virt = pci_alloc_consistent(pdev, sz,
-			&host->escb_phys);
+	host->escb_virt = pci_zalloc_consistent(pdev, sz, &host->escb_phys);
 	if (!host->escb_virt) {
 		printk("inia100: ESCB memory allocation error\n");
 		goto out_free_scb_array;
 	}
-	memset(host->escb_virt, 0, sz);
 
 	biosaddr = host->BIOScfg;
 	biosaddr = (biosaddr << 4);
diff -puN drivers/scsi/be2iscsi/be_main.c~scsi-use-pci_zalloc_consistent drivers/scsi/be2iscsi/be_main.c
--- a/drivers/scsi/be2iscsi/be_main.c~scsi-use-pci_zalloc_consistent
+++ a/drivers/scsi/be2iscsi/be_main.c
@@ -3538,10 +3538,9 @@ static int be_queue_alloc(struct beiscsi
 	q->len = len;
 	q->entry_size = entry_size;
 	mem->size = len * entry_size;
-	mem->va = pci_alloc_consistent(phba->pcidev, mem->size, &mem->dma);
+	mem->va = pci_zalloc_consistent(phba->pcidev, mem->size, &mem->dma);
 	if (!mem->va)
 		return -ENOMEM;
-	memset(mem->va, 0, mem->size);
 	return 0;
 }
 
@@ -4318,9 +4317,9 @@ static int beiscsi_get_boot_info(struct
 			    "BM_%d : No boot session\n");
 		return ret;
 	}
-	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
-				sizeof(*session_resp),
-				&nonemb_cmd.dma);
+	nonemb_cmd.va = pci_zalloc_consistent(phba->ctrl.pdev,
+					      sizeof(*session_resp),
+					      &nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
@@ -4330,7 +4329,6 @@ static int beiscsi_get_boot_info(struct
 		return -ENOMEM;
 	}
 
-	memset(nonemb_cmd.va, 0, sizeof(*session_resp));
 	tag = mgmt_get_session_info(phba, s_handle,
 				    &nonemb_cmd);
 	if (!tag) {
diff -puN drivers/scsi/be2iscsi/be_mgmt.c~scsi-use-pci_zalloc_consistent drivers/scsi/be2iscsi/be_mgmt.c
--- a/drivers/scsi/be2iscsi/be_mgmt.c~scsi-use-pci_zalloc_consistent
+++ a/drivers/scsi/be2iscsi/be_mgmt.c
@@ -900,13 +900,12 @@ free_cmd:
 static int mgmt_alloc_cmd_data(struct beiscsi_hba *phba, struct be_dma_mem *cmd,
 			       int iscsi_cmd, int size)
 {
-	cmd->va = pci_alloc_consistent(phba->ctrl.pdev, size, &cmd->dma);
+	cmd->va = pci_zalloc_consistent(phba->ctrl.pdev, size, &cmd->dma);
 	if (!cmd->va) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 			    "BG_%d : Failed to allocate memory for if info\n");
 		return -ENOMEM;
 	}
-	memset(cmd->va, 0, size);
 	cmd->size = size;
 	be_cmd_hdr_prepare(cmd->va, CMD_SUBSYSTEM_ISCSI, iscsi_cmd, size);
 	return 0;
diff -puN drivers/scsi/csiostor/csio_wr.c~scsi-use-pci_zalloc_consistent drivers/scsi/csiostor/csio_wr.c
--- a/drivers/scsi/csiostor/csio_wr.c~scsi-use-pci_zalloc_consistent
+++ a/drivers/scsi/csiostor/csio_wr.c
@@ -232,7 +232,7 @@ csio_wr_alloc_q(struct csio_hw *hw, uint
 
 	q = wrm->q_arr[free_idx];
 
-	q->vstart = pci_alloc_consistent(hw->pdev, qsz, &q->pstart);
+	q->vstart = pci_zalloc_consistent(hw->pdev, qsz, &q->pstart);
 	if (!q->vstart) {
 		csio_err(hw,
 			 "Failed to allocate DMA memory for "
@@ -240,12 +240,6 @@ csio_wr_alloc_q(struct csio_hw *hw, uint
 		return -1;
 	}
 
-	/*
-	 * We need to zero out the contents, importantly for ingress,
-	 * since we start with a generatiom bit of 1 for ingress.
-	 */
-	memset(q->vstart, 0, qsz);
-
 	q->type		= type;
 	q->owner	= owner;
 	q->pidx		= q->cidx = q->inc_idx = 0;
diff -puN drivers/scsi/eata.c~scsi-use-pci_zalloc_consistent drivers/scsi/eata.c
--- a/drivers/scsi/eata.c~scsi-use-pci_zalloc_consistent
+++ a/drivers/scsi/eata.c
@@ -1238,8 +1238,8 @@ static int port_detect(unsigned long por
 		struct eata_config *cf;
 		dma_addr_t cf_dma_addr;
 
-		cf = pci_alloc_consistent(pdev, sizeof(struct eata_config),
-					  &cf_dma_addr);
+		cf = pci_zalloc_consistent(pdev, sizeof(struct eata_config),
+					   &cf_dma_addr);
 
 		if (!cf) {
 			printk
@@ -1249,7 +1249,6 @@ static int port_detect(unsigned long por
 		}
 
 		/* Set board configuration */
-		memset((char *)cf, 0, sizeof(struct eata_config));
 		cf->len = (ushort) H2DEV16((ushort) 510);
 		cf->ocena = 1;
 
diff -puN drivers/scsi/hpsa.c~scsi-use-pci_zalloc_consistent drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~scsi-use-pci_zalloc_consistent
+++ a/drivers/scsi/hpsa.c
@@ -4731,23 +4731,21 @@ static struct CommandList *cmd_special_a
 	union u64bit temp64;
 	dma_addr_t cmd_dma_handle, err_dma_handle;
 
-	c = pci_alloc_consistent(h->pdev, sizeof(*c), &cmd_dma_handle);
+	c = pci_zalloc_consistent(h->pdev, sizeof(*c), &cmd_dma_handle);
 	if (c == NULL)
 		return NULL;
-	memset(c, 0, sizeof(*c));
 
 	c->cmd_type = CMD_SCSI;
 	c->cmdindex = -1;
 
-	c->err_info = pci_alloc_consistent(h->pdev, sizeof(*c->err_info),
-		    &err_dma_handle);
+	c->err_info = pci_zalloc_consistent(h->pdev, sizeof(*c->err_info),
+					    &err_dma_handle);
 
 	if (c->err_info == NULL) {
 		pci_free_consistent(h->pdev,
 			sizeof(*c), c, cmd_dma_handle);
 		return NULL;
 	}
-	memset(c->err_info, 0, sizeof(*c->err_info));
 
 	INIT_LIST_HEAD(&c->list);
 	c->busaddr = (u32) cmd_dma_handle;
diff -puN drivers/scsi/megaraid/megaraid_mbox.c~scsi-use-pci_zalloc_consistent drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c~scsi-use-pci_zalloc_consistent
+++ a/drivers/scsi/megaraid/megaraid_mbox.c
@@ -998,8 +998,9 @@ megaraid_alloc_cmd_packets(adapter_t *ad
 	 * Allocate the common 16-byte aligned memory for the handshake
 	 * mailbox.
 	 */
-	raid_dev->una_mbox64 = pci_alloc_consistent(adapter->pdev,
-			sizeof(mbox64_t), &raid_dev->una_mbox64_dma);
+	raid_dev->una_mbox64 = pci_zalloc_consistent(adapter->pdev,
+						     sizeof(mbox64_t),
+						     &raid_dev->una_mbox64_dma);
 
 	if (!raid_dev->una_mbox64) {
 		con_log(CL_ANN, (KERN_WARNING
@@ -1007,7 +1008,6 @@ megaraid_alloc_cmd_packets(adapter_t *ad
 			__LINE__));
 		return -1;
 	}
-	memset(raid_dev->una_mbox64, 0, sizeof(mbox64_t));
 
 	/*
 	 * Align the mailbox at 16-byte boundary
@@ -1026,8 +1026,8 @@ megaraid_alloc_cmd_packets(adapter_t *ad
 			align;
 
 	// Allocate memory for commands issued internally
-	adapter->ibuf = pci_alloc_consistent(pdev, MBOX_IBUF_SIZE,
-				&adapter->ibuf_dma_h);
+	adapter->ibuf = pci_zalloc_consistent(pdev, MBOX_IBUF_SIZE,
+					      &adapter->ibuf_dma_h);
 	if (!adapter->ibuf) {
 
 		con_log(CL_ANN, (KERN_WARNING
@@ -1036,7 +1036,6 @@ megaraid_alloc_cmd_packets(adapter_t *ad
 
 		goto out_free_common_mbox;
 	}
-	memset(adapter->ibuf, 0, MBOX_IBUF_SIZE);
 
 	// Allocate memory for our SCSI Command Blocks and their associated
 	// memory
@@ -2972,8 +2971,8 @@ megaraid_mbox_product_info(adapter_t *ad
 	 * Issue an ENQUIRY3 command to find out certain adapter parameters,
 	 * e.g., max channels, max commands etc.
 	 */
-	pinfo = pci_alloc_consistent(adapter->pdev, sizeof(mraid_pinfo_t),
-			&pinfo_dma_h);
+	pinfo = pci_zalloc_consistent(adapter->pdev, sizeof(mraid_pinfo_t),
+				      &pinfo_dma_h);
 
 	if (pinfo == NULL) {
 		con_log(CL_ANN, (KERN_WARNING
@@ -2982,7 +2981,6 @@ megaraid_mbox_product_info(adapter_t *ad
 
 		return -1;
 	}
-	memset(pinfo, 0, sizeof(mraid_pinfo_t));
 
 	mbox->xferaddr = (uint32_t)adapter->ibuf_dma_h;
 	memset((void *)adapter->ibuf, 0, MBOX_IBUF_SIZE);
diff -puN drivers/scsi/megaraid/megaraid_sas_base.c~scsi-use-pci_zalloc_consistent drivers/scsi/megaraid/megaraid_sas_base.c
--- a/drivers/scsi/megaraid/megaraid_sas_base.c~scsi-use-pci_zalloc_consistent
+++ a/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2038,9 +2038,9 @@ int megasas_sriov_start_heartbeat(struct
 
 	if (initial) {
 		instance->hb_host_mem =
-			pci_alloc_consistent(instance->pdev,
-					     sizeof(struct MR_CTRL_HB_HOST_MEM),
-					     &instance->hb_host_mem_h);
+			pci_zalloc_consistent(instance->pdev,
+					      sizeof(struct MR_CTRL_HB_HOST_MEM),
+					      &instance->hb_host_mem_h);
 		if (!instance->hb_host_mem) {
 			printk(KERN_DEBUG "megasas: SR-IOV: Couldn't allocate"
 			       " memory for heartbeat host memory for "
@@ -2048,8 +2048,6 @@ int megasas_sriov_start_heartbeat(struct
 			retval = -ENOMEM;
 			goto out;
 		}
-		memset(instance->hb_host_mem, 0,
-		       sizeof(struct MR_CTRL_HB_HOST_MEM));
 	}
 
 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
diff -puN drivers/scsi/mesh.c~scsi-use-pci_zalloc_consistent drivers/scsi/mesh.c
--- a/drivers/scsi/mesh.c~scsi-use-pci_zalloc_consistent
+++ a/drivers/scsi/mesh.c
@@ -1915,14 +1915,12 @@ static int mesh_probe(struct macio_dev *
 	/* We use the PCI APIs for now until the generic one gets fixed
 	 * enough or until we get some macio-specific versions
 	 */
-	dma_cmd_space = pci_alloc_consistent(macio_get_pci_dev(mdev),
-					     ms->dma_cmd_size,
-					     &dma_cmd_bus);
+	dma_cmd_space = pci_zalloc_consistent(macio_get_pci_dev(mdev),
+					      ms->dma_cmd_size, &dma_cmd_bus);
 	if (dma_cmd_space == NULL) {
 		printk(KERN_ERR "mesh: can't allocate DMA table\n");
 		goto out_unmap;
 	}
-	memset(dma_cmd_space, 0, ms->dma_cmd_size);
 
 	ms->dma_cmds = (struct dbdma_cmd *) DBDMA_ALIGN(dma_cmd_space);
        	ms->dma_cmd_space = dma_cmd_space;
diff -puN drivers/scsi/mvumi.c~scsi-use-pci_zalloc_consistent drivers/scsi/mvumi.c
--- a/drivers/scsi/mvumi.c~scsi-use-pci_zalloc_consistent
+++ a/drivers/scsi/mvumi.c
@@ -142,8 +142,8 @@ static struct mvumi_res *mvumi_alloc_mem
 
 	case RESOURCE_UNCACHED_MEMORY:
 		size = round_up(size, 8);
-		res->virt_addr = pci_alloc_consistent(mhba->pdev, size,
-							&res->bus_addr);
+		res->virt_addr = pci_zalloc_consistent(mhba->pdev, size,
+						       &res->bus_addr);
 		if (!res->virt_addr) {
 			dev_err(&mhba->pdev->dev,
 					"unable to allocate consistent mem,"
@@ -151,7 +151,6 @@ static struct mvumi_res *mvumi_alloc_mem
 			kfree(res);
 			return NULL;
 		}
-		memset(res->virt_addr, 0, size);
 		break;
 
 	default:
@@ -258,12 +257,10 @@ static int mvumi_internal_cmd_sgl(struct
 	if (size == 0)
 		return 0;
 
-	virt_addr = pci_alloc_consistent(mhba->pdev, size, &phy_addr);
+	virt_addr = pci_zalloc_consistent(mhba->pdev, size, &phy_addr);
 	if (!virt_addr)
 		return -1;
 
-	memset(virt_addr, 0, size);
-
 	m_sg = (struct mvumi_sgl *) &cmd->frame->payload[0];
 	cmd->frame->sg_counts = 1;
 	cmd->data_buf = virt_addr;
diff -puN drivers/scsi/pm8001/pm8001_sas.c~scsi-use-pci_zalloc_consistent drivers/scsi/pm8001/pm8001_sas.c
--- a/drivers/scsi/pm8001/pm8001_sas.c~scsi-use-pci_zalloc_consistent
+++ a/drivers/scsi/pm8001/pm8001_sas.c
@@ -123,13 +123,12 @@ int pm8001_mem_alloc(struct pci_dev *pde
 	u64 align_offset = 0;
 	if (align)
 		align_offset = (dma_addr_t)align - 1;
-	mem_virt_alloc =
-		pci_alloc_consistent(pdev, mem_size + align, &mem_dma_handle);
+	mem_virt_alloc = pci_zalloc_consistent(pdev, mem_size + align,
+					       &mem_dma_handle);
 	if (!mem_virt_alloc) {
 		pm8001_printk("memory allocation error\n");
 		return -1;
 	}
-	memset((void *)mem_virt_alloc, 0, mem_size+align);
 	*pphys_addr = mem_dma_handle;
 	phys_align = (*pphys_addr + align_offset) & ~align_offset;
 	*virt_addr = (void *)mem_virt_alloc + phys_align - *pphys_addr;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
mm-utilc-add-kstrimdup.patch
kernelh-remove-deprecated-pack_hex_byte.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch

