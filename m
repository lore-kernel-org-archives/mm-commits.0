From: akpm@linux-foundation.org
Subject: +
 wd719x-remove-last-declaration-using-define_pci_device_table.patch added to -mm tree
Date: Wed, 31 Aug 2016 13:11:39 -0700
Message-ID: <57c739fb.B6MEXjOtp7uLpmQ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48735 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932200AbcHaULk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2016 16:11:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/wd719x.c: remove last declaration using DEFINE_PCI_DEVICE_TABLE
has been added to the -mm tree.  Its filename is
     wd719x-remove-last-declaration-using-define_pci_device_table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/wd719x-remove-last-declaration-using-define_pci_device_table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/wd719x-remove-last-declaration-using-define_pci_device_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: drivers/scsi/wd719x.c: remove last declaration using DEFINE_PCI_DEVICE_TABLE

Convert it to the preferred const struct pci_device_id instead.

Link: http://lkml.kernel.org/r/95c5e4100c3cd4eda643624f5b70e8d7abceb86c.1472660229.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
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

wd719x-remove-last-declaration-using-define_pci_device_table.patch
treewide-remove-references-to-the-now-unnecessary-define_pci_device_table.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char.patch
meminfo-break-apart-a-very-long-seq_printf-with-ifdefs.patch
spellingtxt-modeled-is-spelt-correctly.patch
checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers.patch
checkpatch-look-for-symbolic-permissions-and-suggest-octal-instead.patch
checkpatch-test-multiple-line-block-comment-alignment.patch

