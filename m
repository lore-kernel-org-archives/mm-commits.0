From: akpm@linux-foundation.org
Subject: [merged] rapidio-fix-use-after-free-in-rio_unregister_scan.patch
 removed from -mm tree
Date: Mon, 05 Aug 2013 12:05:45 -0700
Message-ID: <51fff789.hrx3wtb4GG421C+N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3HETFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 15:05:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rmallon@gmail.com, mporter@kernel.crashing.org, alexandre.bounine@idt.com, dan.carpenter@oracle.com

Subject: [merged] rapidio-fix-use-after-free-in-rio_unregister_scan.patch removed from -mm tree
To: dan.carpenter@oracle.com,alexandre.bounine@idt.com,mporter@kernel.crashing.org,rmallon@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 12:05:45 -0700


The patch titled
     Subject: rapidio: fix use after free in rio_unregister_scan()
has been removed from the -mm tree.  Its filename was
     rapidio-fix-use-after-free-in-rio_unregister_scan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: rapidio: fix use after free in rio_unregister_scan()

We're freeing the list iterator so we can't move to the next entry.  Since
there is only one matching mport_id, we can just break after finding it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Ryan Mallon <rmallon@gmail.com>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/rapidio/rio.c~rapidio-fix-use-after-free-in-rio_unregister_scan drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-fix-use-after-free-in-rio_unregister_scan
+++ a/drivers/rapidio/rio.c
@@ -1715,11 +1715,13 @@ int rio_unregister_scan(int mport_id, st
 		    (mport_id == RIO_MPORT_ANY && port->nscan == scan_ops))
 			port->nscan = NULL;
 
-	list_for_each_entry(scan, &rio_scans, node)
+	list_for_each_entry(scan, &rio_scans, node) {
 		if (scan->mport_id == mport_id) {
 			list_del(&scan->node);
 			kfree(scan);
+			break;
 		}
+	}
 
 	mutex_unlock(&rio_mport_list_lock);
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

ocfs2-use-list_for_each_entry-instead-of-list_for_each.patch
fs-binfmts-better-handling-of-binfmt-loops-fix.patch
pktcdvd-convert-printk-to-pr_level.patch
linux-next.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch

