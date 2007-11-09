From: akpm@linux-foundation.org
Subject: + libsas-fix-various-sparse-complaints.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:30:41 -0800
Message-ID: <200711090430.lA94UgPv029374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbXKIEbP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:31:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, James.Bottomley@steeleye.com, jeff@garzik.org


The patch titled
     libsas: fix various sparse complaints
has been added to the -mm tree.  Its filename is
     libsas-fix-various-sparse-complaints.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libsas: fix various sparse complaints
From: "Darrick J. Wong" <djwong@us.ibm.com>

Annotate sas_queuecommand with locking details, and clean up a few
more sparse warnings about static/non-static declarations.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libsas/sas_scsi_host.c |    6 +++++-
 include/scsi/libsas.h               |    4 +---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/libsas/sas_scsi_host.c~libsas-fix-various-sparse-complaints drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c~libsas-fix-various-sparse-complaints
+++ a/drivers/scsi/libsas/sas_scsi_host.c
@@ -200,6 +200,10 @@ int sas_queue_up(struct sas_task *task)
  */
 int sas_queuecommand(struct scsi_cmnd *cmd,
 		     void (*scsi_done)(struct scsi_cmnd *))
+	__releases(host->host_lock)
+	__acquires(dev->sata_dev.ap->lock)
+	__releases(dev->sata_dev.ap->lock)
+	__acquires(host->host_lock)
 {
 	int res = 0;
 	struct domain_device *dev = cmd_to_domain_dev(cmd);
@@ -410,7 +414,7 @@ static int sas_recover_I_T(struct domain
 }
 
 /* Find the sas_phy that's attached to this device */
-struct sas_phy *find_local_sas_phy(struct domain_device *dev)
+static struct sas_phy *find_local_sas_phy(struct domain_device *dev)
 {
 	struct domain_device *pdev = dev->parent;
 	struct ex_phy *exphy = NULL;
diff -puN include/scsi/libsas.h~libsas-fix-various-sparse-complaints include/scsi/libsas.h
--- a/include/scsi/libsas.h~libsas-fix-various-sparse-complaints
+++ a/include/scsi/libsas.h
@@ -563,7 +563,7 @@ struct sas_task {
 	struct work_struct abort_work;
 };
 
-
+extern struct kmem_cache *sas_task_cache;
 
 #define SAS_TASK_STATE_PENDING      1
 #define SAS_TASK_STATE_DONE         2
@@ -573,7 +573,6 @@ struct sas_task {
 
 static inline struct sas_task *sas_alloc_task(gfp_t flags)
 {
-	extern struct kmem_cache *sas_task_cache;
 	struct sas_task *task = kmem_cache_zalloc(sas_task_cache, flags);
 
 	if (task) {
@@ -590,7 +589,6 @@ static inline struct sas_task *sas_alloc
 static inline void sas_free_task(struct sas_task *task)
 {
 	if (task) {
-		extern struct kmem_cache *sas_task_cache;
 		BUG_ON(!list_empty(&task->list));
 		kmem_cache_free(sas_task_cache, task);
 	}
_

Patches currently in -mm which might be from djwong@us.ibm.com are

git-hwmon.patch
mptbase-reset-ioc-initiator-during-pci-resume.patch
libsas-convert-sas_proto-users-to-sas_protocol.patch
libsas-fix-various-sparse-complaints.patch
i5000_edac-no-need-to-__stringify-kbuild_basename.patch
