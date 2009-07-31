From: akpm@linux-foundation.org
Subject: + drivers-parisc-lba_pcic-fix-faulty-check.patch added to -mm tree
Date: Thu, 30 Jul 2009 17:34:28 -0700
Message-ID: <200907310034.n6V0YSN9007449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178AbZGaAex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 20:34:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgayda2@uiuc.edu, deller@gmx.de, grundler@parisc-linux.org, kyle@mcmartin.ca


The patch titled
     drivers/parisc/lba_pci.c: fix faulty check
has been added to the -mm tree.  Its filename is
     drivers-parisc-lba_pcic-fix-faulty-check.patch

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
Subject: drivers/parisc/lba_pci.c: fix faulty check
From: Stoyan Gaydarov <sgayda2@uiuc.edu>

Fix a spelling error that has resulted from copy and pasting.

The location of the error was found using a semantic patch but the
semantic patch was not trying to find these errors.  After looking things
over it seemed logical that this change was needed.

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/lba_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/parisc/lba_pci.c~drivers-parisc-lba_pcic-fix-faulty-check drivers/parisc/lba_pci.c
--- a/drivers/parisc/lba_pci.c~drivers-parisc-lba_pcic-fix-faulty-check
+++ a/drivers/parisc/lba_pci.c
@@ -992,7 +992,7 @@ lba_pat_resources(struct parisc_device *
 		return;
 
 	io_pdc_cell = kzalloc(sizeof(pdc_pat_cell_mod_maddr_block_t), GFP_KERNEL);
-	if (!pa_pdc_cell) {
+	if (!io_pdc_cell) {
 		kfree(pa_pdc_cell);
 		return;
 	}
_

Patches currently in -mm which might be from sgayda2@uiuc.edu are

drivers-w1-masters-omap_hdqc-fix-missing-mutex-unlock.patch
linux-next.patch
drivers-parisc-lba_pcic-fix-faulty-check.patch

