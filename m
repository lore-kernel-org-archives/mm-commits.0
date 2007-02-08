From: akpm@linux-foundation.org
Subject: - slip-replace-kmalloc-memset-pairs-with-the.patch removed from -mm tree
Date: Thu, 08 Feb 2007 13:52:38 -0800
Message-ID: <200702082152.l18Lqc2k027651@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41403 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423459AbXBHVwo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 16:52:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe.jin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     slip: Replace kmalloc() + memset() pairs with the appropriate kzalloc() calls
has been removed from the -mm tree.  Its filename was
     slip-replace-kmalloc-memset-pairs-with-the.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slip: Replace kmalloc() + memset() pairs with the appropriate kzalloc() calls
From: joe jin <joe.jin@oracle.com>

This patch replace kmalloc() + memset() pairs with the appropriate
kzalloc().

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/slip.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

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

git-net.patch
