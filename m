From: akpm@linux-foundation.org
Subject: + cpqarray-use-pci_dev-revision.patch added to -mm tree
Date: Mon, 29 Aug 2011 16:55:44 -0700
Message-ID: <201108292355.p7TNti2h011743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754806Ab1H2X4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 19:56:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sshtylyov@ru.mvista.com, axboe@kernel.dk, chirag.kantharia@hp.com, mike.miller@hp.com


The patch titled
     drivers/block/cpqarray.c: use pci_dev->revision
has been added to the -mm tree.  Its filename is
     cpqarray-use-pci_dev-revision.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/cpqarray.c: use pci_dev->revision
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

This driver uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so it
wasn't converted by commit 44c10138fd4bbc4b6 ("PCI: Change all drivers to
use pci_device->revision").

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Cc: Chirag Kantharia <chirag.kantharia@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cpqarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cpqarray.c~cpqarray-use-pci_dev-revision drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c~cpqarray-use-pci_dev-revision
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

linux-next.patch
cpqarray-use-pci_dev-revision.patch

