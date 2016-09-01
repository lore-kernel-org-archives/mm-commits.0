From: akpm@linux-foundation.org
Subject: [patch 07/14] drivers/scsi/wd719x.c: remove last declaration
 using DEFINE_PCI_DEVICE_TABLE
Date: Thu, 01 Sep 2016 16:14:58 -0700
Message-ID: <57c8b672.DKjQRrV7611XDFFv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59859 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbcIAXO7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2016 19:14:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com, bart.vanassche@sandisk.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

From: Joe Perches <joe@perches.com>
Subject: drivers/scsi/wd719x.c: remove last declaration using DEFINE_PCI_DEVICE_TABLE

Convert it to the preferred const struct pci_device_id instead.

Link: http://lkml.kernel.org/r/95c5e4100c3cd4eda643624f5b70e8d7abceb86c.1472660229.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/wd719x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/wd719x.c~wd719x-remove-last-declaration-using-define_pci_device_table drivers/scsi/wd719x.c
--- a/drivers/scsi/wd719x.c~wd719x-remove-last-declaration-using-define_pci_device_table
+++ a/drivers/scsi/wd719x.c
@@ -962,7 +962,7 @@ static void wd719x_pci_remove(struct pci
 	scsi_host_put(sh);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(wd719x_pci_table) = {
+static const struct pci_device_id wd719x_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_WD, 0x3296) },
 	{}
 };
_
