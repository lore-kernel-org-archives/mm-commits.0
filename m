From: akpm@linux-foundation.org
Subject: + drivers-scsi-hpsac-fix-section-mismatch.patch added to -mm tree
Date: Wed, 13 Jan 2010 17:10:12 -0800
Message-ID: <201001140110.o0E1ACJK007467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651Ab0ANBK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 20:10:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, James.Bottomley@HansenPartnership.com, scameron@beardog.cce.hp.com


The patch titled
     drivers/scsi/hpsa.c: fix section mismatch
has been added to the -mm tree.  Its filename is
     drivers-scsi-hpsac-fix-section-mismatch.patch

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
Subject: drivers/scsi/hpsa.c: fix section mismatch
From: Jeff Mahoney <jeffm@suse.com>

hpsa_pci_init() calls hpsa_interrupt_mode() which is a __devinit function.
 hpsa_pci_init() is only called by hpsa_init_one() which is also
__devinit, so mark it __devinit as well.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: "Stephen M.Cameron" <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hpsa.c~drivers-scsi-hpsac-fix-section-mismatch drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~drivers-scsi-hpsac-fix-section-mismatch
+++ a/drivers/scsi/hpsa.c
@@ -3111,7 +3111,7 @@ default_int_mode:
 	return;
 }
 
-static int hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
+static int __devinit hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
 {
 	ushort subsystem_vendor_id, subsystem_device_id, command;
 	__u32 board_id, scratchpad = 0;
_

Patches currently in -mm which might be from jeffm@suse.com are

virtio-fix-section-mismatch-warnings.patch
acpi-fix-section-mismatch.patch
drivers-scsi-hpsac-fix-section-mismatch.patch
hugetlb-fix-section-mismatches-2.patch

