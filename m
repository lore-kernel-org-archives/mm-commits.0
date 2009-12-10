From: akpm@linux-foundation.org
Subject: + scsi-lpfc-fix-memory-leak.patch added to -mm tree
Date: Thu, 10 Dec 2009 15:07:45 -0800
Message-ID: <200912102307.nBAN7jwo023046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933088AbZLJXHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Dec 2009 18:07:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, James.Bottomley@HansenPartnership.com, james.smart@emulex.com


The patch titled
     scsi: lpfc, fix memory leak
has been added to the -mm tree.  Its filename is
     scsi-lpfc-fix-memory-leak.patch

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
Subject: scsi: lpfc, fix memory leak
From: Jiri Slaby <jirislaby@gmail.com>

Stanse found a memory leak on one fail path in lpfc_sli4_read_rev.

Add there kfree.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: James Smart <james.smart@emulex.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_sli.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/lpfc/lpfc_sli.c~scsi-lpfc-fix-memory-leak drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c~scsi-lpfc-fix-memory-leak
+++ a/drivers/scsi/lpfc/lpfc_sli.c
@@ -4110,6 +4110,7 @@ lpfc_sli4_read_rev(struct lpfc_hba *phba
 	if (rc) {
 		dma_free_coherent(&phba->pcidev->dev, dma_size,
 				  dmabuf->virt, dmabuf->phys);
+		kfree(dmabuf);
 		return -EIO;
 	}
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
scsi-aacraid-fix-memory-leak.patch
scsi-remove-unnecessary-null-test.patch
scsi-lpfc-fix-memory-leak.patch
swap_info-include-first_swap_extent-fix.patch
swap_info-include-first_swap_extent-fix-fix.patch
char-cyclades-fix-compiler-warning.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
char-mxser-remove-unnecessary-tty-test.patch
isicomc-use-pr_fmt-and-pr_level.patch
moxa-remove-ifdef-module-completely.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

