From: akpm@osdl.org
Subject: + slip-replace-kmalloc-memset-pairs-with-the.patch added to -mm tree
Date: Tue, 23 Jan 2007 12:51:08 -0800
Message-ID: <200701232051.l0NKp8d9030924@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54659 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933134AbXAWUvM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 15:51:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe.jin@oracle.com


The patch titled
     slip: Replace kmalloc() + memset() pairs with the appropriate kzalloc() calls
has been added to the -mm tree.  Its filename is
     slip-replace-kmalloc-memset-pairs-with-the.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slip: Replace kmalloc() + memset() pairs with the appropriate kzalloc() calls
From: joe jin <joe.jin@oracle.com>

This patch replace kmalloc() + memset() pairs with the appropriate
kzalloc().

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/slip.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/net/slip.c~slip-replace-kmalloc-memset-pairs-with-the drivers/net/slip.c
--- a/drivers/net/slip.c~slip-replace-kmalloc-memset-pairs-with-the
+++ a/drivers/net/slip.c
@@ -1343,15 +1343,12 @@ static int __init slip_init(void)
 	printk(KERN_INFO "SLIP linefill/keepalive option.\n");
 #endif
 
-	slip_devs = kmalloc(sizeof(struct net_device *)*slip_maxdev, GFP_KERNEL);
+	slip_devs = kzalloc(sizeof(struct net_device *)*slip_maxdev, GFP_KERNEL);
 	if (!slip_devs) {
 		printk(KERN_ERR "SLIP: Can't allocate slip devices array!  Uaargh! (-> No SLIP available)\n");
 		return -ENOMEM;
 	}
 
-	/* Clear the pointer array, we allocate devices when we need them */
-	memset(slip_devs, 0, sizeof(struct net_device *)*slip_maxdev);
-
 	/* Fill in our line protocol discipline, and register it */
 	if ((status = tty_register_ldisc(N_SLIP, &sl_ldisc)) != 0)  {
 		printk(KERN_ERR "SLIP: can't register line discipline (err = %d)\n", status);
_

Patches currently in -mm which might be from joe.jin@oracle.com are

slip-replace-kmalloc-memset-pairs-with-the.patch
