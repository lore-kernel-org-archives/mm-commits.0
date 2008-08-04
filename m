From: akpm@linux-foundation.org
Subject: - libata-core-make-sure-that-ata_force_tbl-is-freed-in-case-of-an-error.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:30 -0700
Message-ID: <200808042006.m74K6UUN027697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760704AbYHDUHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eo@nebensachen.de, alan@lxorguk.ukuu.org.uk, jeff@garzik.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     libata-core: make sure that ata_force_tbl is freed in case of an error
has been removed from the -mm tree.  Its filename was
     libata-core-make-sure-that-ata_force_tbl-is-freed-in-case-of-an-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata-core: make sure that ata_force_tbl is freed in case of an error
From: Elias Oltmanns <eo@nebensachen.de>

Fix a potential memory leak when ata_init() encounters an error.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-core-make-sure-that-ata_force_tbl-is-freed-in-case-of-an-error drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-core-make-sure-that-ata_force_tbl-is-freed-in-case-of-an-error
+++ a/drivers/ata/libata-core.c
@@ -6088,16 +6088,20 @@ static int __init ata_init(void)
 
 	ata_wq = create_workqueue("ata");
 	if (!ata_wq)
-		return -ENOMEM;
+		goto free_force_tbl;
 
 	ata_aux_wq = create_singlethread_workqueue("ata_aux");
-	if (!ata_aux_wq) {
-		destroy_workqueue(ata_wq);
-		return -ENOMEM;
-	}
+	if (!ata_aux_wq)
+		goto free_wq;
 
 	printk(KERN_DEBUG "libata version " DRV_VERSION " loaded.\n");
 	return 0;
+
+free_wq:
+	destroy_workqueue(ata_wq);
+free_force_tbl:
+	kfree(ata_force_tbl);
+	return -ENOMEM;
 }
 
 static void __exit ata_exit(void)
_

Patches currently in -mm which might be from eo@nebensachen.de are

origin.patch

