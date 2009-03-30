From: akpm@linux-foundation.org
Subject: [merged] cpqarray-enable-bus-mastering.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:06:28 -0700
Message-ID: <200903301906.n2UJ6Sbn019060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757951AbZC3Tb3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:31:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, jens.axboe@oracle.com, kyle@redhat.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cpqarray: enable bus mastering
has been removed from the -mm tree.  Its filename was
     cpqarray-enable-bus-mastering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpqarray: enable bus mastering
From: Dave Jones <davej@redhat.com>

We've been carrying this patch for the last 3 years in Fedora, long past time
we got it upstream...

Call pci_set_master to enable bus-mastering if the BIOS hasn't done it
already.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cpqarray.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/cpqarray.c~cpqarray-enable-bus-mastering drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c~cpqarray-enable-bus-mastering
+++ a/drivers/block/cpqarray.c
@@ -617,6 +617,7 @@ static int cpqarray_pci_init(ctlr_info_t
 	int i;
 
 	c->pci_dev = pdev;
+	pci_set_master(pdev);
 	if (pci_enable_device(pdev)) {
 		printk(KERN_ERR "cpqarray: Unable to Enable PCI device\n");
 		return -1;
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch

