From: akpm@linux-foundation.org
Subject: [merged] scsi-lpfc-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:18 -0800
Message-ID: <20130228201518.B933F31C211@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:34498 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab3B1UPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:19 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so261370qaj.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, James.Bottomley@HansenPartnership.com, james.smart@emulex.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi/lpfc: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     scsi-lpfc-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: scsi/lpfc: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: James Smart <james.smart@emulex.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_init.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_init.c~scsi-lpfc-convert-to-idr_alloc drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~scsi-lpfc-convert-to-idr_alloc
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -3165,14 +3165,10 @@ destroy_port(struct lpfc_vport *vport)
 int
 lpfc_get_instance(void)
 {
-	int instance = 0;
+	int ret;
 
-	/* Assign an unused number */
-	if (!idr_pre_get(&lpfc_hba_index, GFP_KERNEL))
-		return -1;
-	if (idr_get_new(&lpfc_hba_index, NULL, &instance))
-		return -1;
-	return instance;
+	ret = idr_alloc(&lpfc_hba_index, NULL, 0, 0, GFP_KERNEL);
+	return ret < 0 ? -1 : ret;
 }
 
 /**
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

