From: akpm@google.com
Subject: [merged] drivers-block-cpqarrayc-use-pci_dev-revision.patch removed from -mm tree
Date: Thu, 22 Sep 2011 14:00:34 -0700
Message-ID: <201109222100.p8ML0YG9003069@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:10538 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1IVVA4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Sep 2011 17:00:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, axboe@kernel.dk, chirag.kantharia@hp.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/block/cpqarray.c: use pci_dev->revision
has been removed from the -mm tree.  Its filename was
     drivers-block-cpqarrayc-use-pci_dev-revision.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: drivers/block/cpqarray.c: use pci_dev->revision

This driver uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so it
wasn't converted by commit 44c10138fd4bbc4b6 ("PCI: Change all drivers to
use pci_device->revision").

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Cc: Chirag Kantharia <chirag.kantharia@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/block/cpqarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cpqarray.c~drivers-block-cpqarrayc-use-pci_dev-revision drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c~drivers-block-cpqarrayc-use-pci_dev-revision
+++ a/drivers/block/cpqarray.c
@@ -620,6 +620,7 @@ static int cpqarray_pci_init(ctlr_info_t
 	}
 	vendor_id = pdev->vendor;
 	device_id = pdev->device;
+	revision  = pdev->revision;
 	irq = pdev->irq;
 
 	for(i=0; i<6; i++)
@@ -632,7 +633,6 @@ static int cpqarray_pci_init(ctlr_info_t
 	}
 
 	pci_read_config_word(pdev, PCI_COMMAND, &command);
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
 	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &cache_line_size);
 	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &latency_timer);
 
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

origin.patch
linux-next.patch

