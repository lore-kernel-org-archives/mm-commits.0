From: akpm@linux-foundation.org
Subject: + scsi-fix-unused-variable-warning-in-mpt2sas_scsihc.patch added to -mm tree
Date: Tue, 27 Dec 2011 14:46:37 -0800
Message-ID: <20111227224638.217BA5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:49329 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1L0Wqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Dec 2011 17:46:40 -0500
Received: by faar15 with SMTP id r15so384337faa.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Dec 2011 14:46:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com


The patch titled
     From: Rakib Mullick <rakib.mullick@gmail.com>
has been added to the -mm tree.  Its filename is
     scsi-fix-unused-variable-warning-in-mpt2sas_scsihc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5726,7 +5726,6 @@ _scsih_sas_broadcast_primative_event(str
 	u32 termination_count;
 	u32 query_count;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
-	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event->event_data;
 	u16 ioc_status;
 	unsigned long flags;
 	int r;
@@ -5735,8 +5734,8 @@ _scsih_sas_broadcast_primative_event(str
 
 	mutex_lock(&ioc->tm_cmds.mutex);
 	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter: phy number(%d), "
-	    "width(%d)\n", ioc->name, __func__, event_data->PhyNum,
-	     event_data->PortWidth));
+	    "width(%d)\n", ioc->name, __func__, fw_event->event_data->PhyNum,
+	     fw_event->event_data->PortWidth));
 
 	_scsih_block_io_all_device(ioc);
 
_
Subject: From: Rakib Mullick <rakib.mullick@gmail.com>

Patches currently in -mm which might be from rakib.mullick@gmail.com are

scsi-fix-unused-variable-warning-in-mpt2sas_scsihc.patch

