From: akpm@linux-foundation.org
Subject: - unregister_blkdev-delete-redundant-message.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:11 -0700
Message-ID: <200707172302.l6HN2B3N011542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41064 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936621AbXGQXP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     unregister_blkdev(): delete redundant message
has been removed from the -mm tree.  Its filename was
     unregister_blkdev-delete-redundant-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: unregister_blkdev(): delete redundant message
From: Akinobu Mita <akinobu.mita@gmail.com>

No need to warn unregister_blkdev() failure by caller.  (The previous patch
makes unregister_blkdev() print error message in error case)

Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/xsysace.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/block/xsysace.c~unregister_blkdev-delete-redundant-message drivers/block/xsysace.c
--- a/drivers/block/xsysace.c~unregister_blkdev-delete-redundant-message
+++ a/drivers/block/xsysace.c
@@ -1157,9 +1157,7 @@ static void __exit ace_exit(void)
 {
 	pr_debug("Unregistering Xilinx SystemACE driver\n");
 	driver_unregister(&ace_driver);
-	if (unregister_blkdev(ace_major, "xsysace"))
-		printk(KERN_WARNING "systemace unregister_blkdev(%i) failed\n",
-		       ace_major);
+	unregister_blkdev(ace_major, "xsysace");
 }
 
 module_init(ace_init);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-dvb.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
unregister_chrdev-ignore-the-return-value.patch
unregister_chrdev-return-void.patch
