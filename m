From: akpm@linux-foundation.org
Subject: + pata_sc1200-fix-crash-on-boot.patch added to -mm tree
Date: Tue, 13 Oct 2009 18:56:43 -0700
Message-ID: <200910140156.n9E1uhW2024923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086AbZJNB6o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 21:58:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, alex@ozo.com, jeff@garzik.org, stable@kernel.org, tj@kernel.org


The patch titled
     pata_sc1200: fix crash on boot
has been added to the -mm tree.  Its filename is
     pata_sc1200-fix-crash-on-boot.patch

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
Subject: pata_sc1200: fix crash on boot
From: Alan Cox <alan@linux.intel.com>

The SC1200 needs a NULL terminator or it may cause a crash on boot.

Also correct a bogus comment as the driver had serializing added so can
run dual port.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14227

Reported-by: Alexandros C. Couloumbis <alex@ozo.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_sc1200.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/ata/pata_sc1200.c~pata_sc1200-fix-crash-on-boot drivers/ata/pata_sc1200.c
--- a/drivers/ata/pata_sc1200.c~pata_sc1200-fix-crash-on-boot
+++ a/drivers/ata/pata_sc1200.c
@@ -235,8 +235,7 @@ static int sc1200_init_one(struct pci_de
 		.udma_mask = ATA_UDMA2,
 		.port_ops = &sc1200_port_ops
 	};
-	/* Can't enable port 2 yet, see top comments */
-	const struct ata_port_info *ppi[] = { &info, };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	return ata_pci_sff_init_one(dev, ppi, &sc1200_sht, NULL);
 }
_

Patches currently in -mm which might be from alan@linux.intel.com are

linux-next.patch
atmel_serial-fix-bad-build_bug_on-usage.patch
pata_sc1200-fix-crash-on-boot.patch

