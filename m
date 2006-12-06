From: akpm@osdl.org
Subject: - aic94xx-dont-call-pci_map_sg-for-already-mapped-scatterlists.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:23:51 -0800
Message-ID: <200612062223.kB6MNph8018563@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48249 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937726AbWLFWXz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:23:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     aic94xx: Don't call pci_map_sg for already-mapped scatterlists
has been removed from the -mm tree.  Its filename was
     aic94xx-dont-call-pci_map_sg-for-already-mapped-scatterlists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: aic94xx: Don't call pci_map_sg for already-mapped scatterlists
From: "Darrick J. Wong" <djwong@us.ibm.com>

It turns out that libata has already dma_map_sg'd the scatterlist entries
that go with an ata_queued_cmd by the time it calls sas_ata_qc_issue. 
sas_ata_qc_issue passes this scatterlist to aic94xx.  Unfortunately,
aic94xx assumes that any scatterlist passed to it needs to be
pci_map_sg'd...  which blows away the mapping that libata created!  This
causes (on a x260) Calgary IOMMU table leaks and duplicate frees when
aic94xx and libata try to {pci,dma}_unmap_sg the scatterlist.

Since dma_map_sg and pci_map_sg are fed the same struct device, I think
it's safe to add a flag to sas_task that tells aic94xx that it need not map
the scatterlist.  It didn't break anything on the x260, though I don't have
any SATAPI devices to test with.  Is this the correct approach to fixing
this problem?

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic94xx/aic94xx_task.c |   17 +++++++++++------
 drivers/scsi/libsas/sas_ata.c       |    1 +
 include/scsi/libsas.h               |    3 +--
 3 files changed, 13 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/aic94xx/aic94xx_task.c~aic94xx-dont-call-pci_map_sg-for-already-mapped-scatterlists drivers/scsi/aic94xx/aic94xx_task.c
--- a/drivers/scsi/aic94xx/aic94xx_task.c~aic94xx-dont-call-pci_map_sg-for-already-mapped-scatterlists
+++ a/drivers/scsi/aic94xx/aic94xx_task.c
@@ -74,8 +74,11 @@ static inline int asd_map_scatterlist(st
 		return 0;
 	}
 
-	num_sg = pci_map_sg(asd_ha->pcidev, task->scatter, task->num_scatter,
-			    task->data_dir);
+	if (task->external_sg)
+		num_sg = task->num_scatter;
+	else
+		num_sg = pci_map_sg(asd_ha->pcidev, task->scatter,
+				    task->num_scatter, task->data_dir);
 	if (num_sg == 0)
 		return -ENOMEM;
 
@@ -120,8 +123,9 @@ static inline int asd_map_scatterlist(st
 
 	return 0;
 err_unmap:
-	pci_unmap_sg(asd_ha->pcidev, task->scatter, task->num_scatter,
-		     task->data_dir);
+	if (!task->external_sg)
+		pci_unmap_sg(asd_ha->pcidev, task->scatter, task->num_scatter,
+			     task->data_dir);
 	return res;
 }
 
@@ -142,8 +146,9 @@ static inline void asd_unmap_scatterlist
 	}
 
 	asd_free_coherent(asd_ha, ascb->sg_arr);
-	pci_unmap_sg(asd_ha->pcidev, task->scatter, task->num_scatter,
-		     task->data_dir);
+	if (!task->external_sg)
+		pci_unmap_sg(asd_ha->pcidev, task->scatter, task->num_scatter,
+			     task->data_dir);
 }
 
 /* ---------- Task complete tasklet ---------- */
diff -puN drivers/scsi/libsas/sas_ata.c~aic94xx-dont-call-pci_map_sg-for-already-mapped-scatterlists drivers/scsi/libsas/sas_ata.c
--- a/drivers/scsi/libsas/sas_ata.c~aic94xx-dont-call-pci_map_sg-for-already-mapped-scatterlists
+++ a/drivers/scsi/libsas/sas_ata.c
@@ -158,6 +158,7 @@ static unsigned int sas_ata_qc_issue(str
 		task->num_scatter = num;
 	}
 
+	task->external_sg = 1;
 	task->data_dir = qc->dma_dir;
 	task->scatter = qc->__sg;
 	task->ata_task.retry_count = 1;
diff -puN include/scsi/libsas.h~aic94xx-dont-call-pci_map_sg-for-already-mapped-scatterlists include/scsi/libsas.h
--- a/include/scsi/libsas.h~aic94xx-dont-call-pci_map_sg-for-already-mapped-scatterlists
+++ a/include/scsi/libsas.h
@@ -537,12 +537,11 @@ struct sas_task {
 
 	void   *lldd_task;	  /* for use by LLDDs */
 	void   *uldd_task;
+	int    external_sg;
 
 	struct work_struct abort_work;
 };
 
-
-
 #define SAS_TASK_STATE_PENDING      1
 #define SAS_TASK_STATE_DONE         2
 #define SAS_TASK_STATE_ABORTED      4
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
libata-simulate-report-luns-for-atapi-devices.patch
git-sas.patch
git-sas-kconfig-fix.patch

