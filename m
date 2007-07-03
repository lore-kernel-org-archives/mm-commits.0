From: akpm@linux-foundation.org
Subject: + unregister_blkdev-delete-redundant-message.patch added to -mm tree
Date: Tue, 03 Jul 2007 12:56:04 -0700
Message-ID: <200707031956.l63Ju598012157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756991AbXGCT4O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 15:56:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, grant.likely@secretlab.ca


The patch titled
     unregister_blkdev(): delete redundant message
has been added to the -mm tree.  Its filename is
     unregister_blkdev-delete-redundant-message.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 3 deletions(-)

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

git-dvb.patch
git-netdev-all.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-add-min-order-parameter-to-fail_page_alloc.patch
fault-injection-fix-example-scripts-in-documentation.patch
unregister_chrdev-ignore-the-return-value.patch
unregister_chrdev-return-void.patch
unregister_blkdev-do-warn_on-on-failure.patch
unregister_blkdev-delete-redundant-messages-in-callers.patch
unregister_blkdev-delete-redundant-message.patch
unregister_blkdev-return-void.patch
