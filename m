From: akpm@linux-foundation.org
Subject: + fix-stupid-wol-variable-overflow-bug.patch added to -mm tree
Date: Tue, 19 Jun 2007 13:44:33 -0700
Message-ID: <200706192044.l5JKiXcH020796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50421 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756268AbXFSUpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 16:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de


The patch titled
     b44: fix stupid wol variable overflow bug
has been added to the -mm tree.  Its filename is
     fix-stupid-wol-variable-overflow-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: b44: fix stupid wol variable overflow bug
From: Michael Buesch <mb@bu3sch.de>

This bug was introduced by me.  val is 16bit, but the read value is 32bit. 
Seems like I was smoking crack when porting that part of the driver.  I
guess that's the last stupid bug in these 4 lines of code.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/b44.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/b44.c~fix-stupid-wol-variable-overflow-bug drivers/net/b44.c
--- a/drivers/net/b44.c~fix-stupid-wol-variable-overflow-bug
+++ a/drivers/net/b44.c
@@ -1581,8 +1581,7 @@ static void b44_setup_wol_pci(struct b44
 	u16 val;
 
 	if (bp->sdev->bus->bustype != SSB_BUSTYPE_SSB) {
-		val = br32(bp, SSB_TMSLOW);
-		bw32(bp, SSB_TMSLOW, val | SSB_TMSLOW_PE);
+		bw32(bp, SSB_TMSLOW, br32(bp, SSB_TMSLOW) | SSB_TMSLOW_PE);
 		pci_read_config_word(bp->sdev->bus->host_pci, SSB_PMCSR, &val);
 		pci_write_config_word(bp->sdev->bus->host_pci, SSB_PMCSR, val | SSB_PE);
 	}
_

Patches currently in -mm which might be from mb@bu3sch.de are

b44-ssb-fix-irq-routing-bits-on-the-backplane.patch
fix-stupid-wol-variable-overflow-bug.patch
o_cloexec-for-scm_rights.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
intel-rng-undo-mess-made-by-an-80-column-extremist.patch
