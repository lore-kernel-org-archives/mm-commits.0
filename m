From: akpm@linux-foundation.org
Subject: + libata-core-make-sure-that-ata_force_tbl-is-freed-in-case-of-an-error.patch added to -mm tree
Date: Wed, 30 Jul 2008 00:32:24 -0700
Message-ID: <200807300732.m6U7WOQE014068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556AbYG3HeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 03:34:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eo@nebensachen.de, alan@lxorguk.ukuu.org.uk, jeff@garzik.org, tj@kernel.org


The patch titled
     libata-core: make sure that ata_force_tbl is freed in case of an error
has been added to the -mm tree.  Its filename is
     libata-core-make-sure-that-ata_force_tbl-is-freed-in-case-of-an-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

libata-core-make-sure-that-ata_force_tbl-is-freed-in-case-of-an-error.patch

