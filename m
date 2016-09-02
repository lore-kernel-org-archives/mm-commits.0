From: akpm@linux-foundation.org
Subject: [merged]
 wd719x-remove-last-declaration-using-define_pci_device_table.patch removed
 from -mm tree
Date: Fri, 02 Sep 2016 12:01:02 -0700
Message-ID: <57c9cc6e.SB2XDaLXGdlP3heC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32996 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754109AbcIBTBD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2016 15:01:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bart.vanassche@sandisk.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/wd719x.c: remove last declaration using DEFINE_PCI_DEVICE_TABLE
has been removed from the -mm tree.  Its filename was
     wd719x-remove-last-declaration-using-define_pci_device_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from joe@perches.com are

seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char.patch
meminfo-break-apart-a-very-long-seq_printf-with-ifdefs.patch
spellingtxt-modeled-is-spelt-correctly.patch
checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers.patch
checkpatch-look-for-symbolic-permissions-and-suggest-octal-instead.patch
checkpatch-test-multiple-line-block-comment-alignment.patch
checkpatch-dont-test-for-prefer-ether_addr_foo.patch
checkpatch-externalize-the-structs-that-should-be-const.patch
const_structscheckpatch-add-frequently-used-from-julia-lawalls-list.patch
checkpatch-speed-up-checking-for-filenames-in-sections-marked-obsolete.patch

