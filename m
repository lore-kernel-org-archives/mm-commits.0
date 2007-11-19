From: akpm@linux-foundation.org
Subject: - megaraid-sas-convert-aen_mutex-to-the-mutex-api.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:15:53 -0800
Message-ID: <200711192315.lAJNFrIU001721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51944 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313AbXKSXQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:16:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, James.Bottomley@SteelEye.com, megaraidlinux@lsi.com, sumant.patro@lsi.com, mm-commits@vger.kernel.org


The patch titled
     MegaRAID SAS: convert aen_mutex to the mutex API
has been removed from the -mm tree.  Its filename was
     megaraid-sas-convert-aen_mutex-to-the-mutex-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MegaRAID SAS: convert aen_mutex to the mutex API
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

MegaRAID SAS: Convert aen_mutex to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: <megaraidlinux@lsi.com>
Cc: Sumant Patro <sumant.patro@lsi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |    7 ++++---
 drivers/scsi/megaraid/megaraid_sas.h |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~megaraid-sas-convert-aen_mutex-to-the-mutex-api drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~megaraid-sas-convert-aen_mutex-to-the-mutex-api
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -31,6 +31,7 @@
 #include <linux/moduleparam.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/uio.h>
@@ -2358,7 +2359,7 @@ megasas_probe_one(struct pci_dev *pdev, 
 
 	spin_lock_init(&instance->cmd_pool_lock);
 
-	sema_init(&instance->aen_mutex, 1);
+	mutex_init(&instance->aen_mutex);
 	sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
 
 	/*
@@ -2874,10 +2875,10 @@ static int megasas_mgmt_ioctl_aen(struct
 	if (!instance)
 		return -ENODEV;
 
-	down(&instance->aen_mutex);
+	mutex_lock(&instance->aen_mutex);
 	error = megasas_register_aen(instance, aen.seq_num,
 				     aen.class_locale_word);
-	up(&instance->aen_mutex);
+	mutex_unlock(&instance->aen_mutex);
 	return error;
 }
 
diff -puN drivers/scsi/megaraid/megaraid_sas.h~megaraid-sas-convert-aen_mutex-to-the-mutex-api drivers/scsi/megaraid/megaraid_sas.h
--- a/drivers/scsi/megaraid/megaraid_sas.h~megaraid-sas-convert-aen_mutex-to-the-mutex-api
+++ a/drivers/scsi/megaraid/megaraid_sas.h
@@ -1089,7 +1089,7 @@ struct megasas_instance {
 	struct megasas_evt_detail *evt_detail;
 	dma_addr_t evt_detail_h;
 	struct megasas_cmd *aen_cmd;
-	struct semaphore aen_mutex;
+	struct mutex aen_mutex;
 	struct semaphore ioctl_sem;
 
 	struct Scsi_Host *host;
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

git-dvb.patch
qlogic-infinipath-convert-ipath_eep_sem-to-mutex.patch
git-netdev-all.patch
git-scsi-misc.patch
ti-3410-5052-usb-serial-convert-td_open_close_lock-to-mutex.patch
parallel-port-convert-port_mutex-to-the-mutex-api.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
mbcs-convert-algolock-to-mutex.patch
mbcs-convert-dmawritelock-to-mutex.patch
mbcs-convert-dmareadlock-to-mutex.patch
