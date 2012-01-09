From: akpm@linux-foundation.org
Subject: - scsi-fix-unused-variable-warning-in-mpt2sas_scsihc.patch removed from -mm tree
Date: Mon, 09 Jan 2012 14:58:51 -0800
Message-ID: <20120109234103.DF88F200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:51630 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab2AIXlG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2012 18:41:06 -0500
Received: by faar15 with SMTP id r15so131747faa.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jan 2012 15:41:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/mpt2sas/mpt2sas_scsih.c: fix unused variable warning
has been removed from the -mm tree.  Its filename was
     scsi-fix-unused-variable-warning-in-mpt2sas_scsihc.patch

This patch was dropped because this couldn't have been tested?

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Rakib Mullick <rakib.mullick@gmail.com>
Subject: drivers/scsi/mpt2sas/mpt2sas_scsih.c: fix unused variable warning

drivers/scsi/mpt2sas/mpt2sas_scsih.c: In function `_scsih_sas_broadcast_primative_event':
drivers/scsi/mpt2sas/mpt2sas_scsih.c:5729:40: warning: unused variable `event_data'

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/mpt2sas/mpt2sas_scsih.c~scsi-fix-unused-variable-warning-in-mpt2sas_scsihc drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c~scsi-fix-unused-variable-warning-in-mpt2sas_scsihc
+++ a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5763,7 +5763,6 @@ _scsih_sas_broadcast_primative_event(str
 	u32 termination_count;
 	u32 query_count;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
-	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event->event_data;
 	u16 ioc_status;
 	unsigned long flags;
 	int r;
@@ -5772,8 +5771,8 @@ _scsih_sas_broadcast_primative_event(str
 
 	mutex_lock(&ioc->tm_cmds.mutex);
 	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter: phy number(%d), "
-	    "width(%d)\n", ioc->name, __func__, event_data->PhyNum,
-	     event_data->PortWidth));
+	    "width(%d)\n", ioc->name, __func__, fw_event->event_data->PhyNum,
+	     fw_event->event_data->PortWidth));
 
 	_scsih_block_io_all_device(ioc);
 
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch

