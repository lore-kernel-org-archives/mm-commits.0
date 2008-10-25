From: akpm@linux-foundation.org
Subject: + edac-fix-enabling-of-polling-cell-module.patch added to -mm tree
Date: Sat, 25 Oct 2008 00:34:39 -0700
Message-ID: <200810250734.m9P7YdON016164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbYJYHex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Oct 2008 03:34:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, arnd@arndb.de, dougthompson@xmission.com, jens@linux.vnet.ibm.com


The patch titled
     edac: fix enabling of polling cell module
has been added to the -mm tree.  Its filename is
     edac-fix-enabling-of-polling-cell-module.patch

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
Subject: edac: fix enabling of polling cell module
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

The edac driver on cell turned out to be not enabled because of a missing
op_state.  This patch introduces it.  Verified to work on top of Ben's
next branch.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jens Osterkamp <jens@linux.vnet.ibm.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/cell_edac.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/edac/cell_edac.c~edac-fix-enabling-of-polling-cell-module drivers/edac/cell_edac.c
--- a/drivers/edac/cell_edac.c~edac-fix-enabling-of-polling-cell-module
+++ a/drivers/edac/cell_edac.c
@@ -9,6 +9,7 @@
  */
 #undef DEBUG
 
+#include <linux/edac.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
@@ -164,6 +165,8 @@ static int __devinit cell_edac_probe(str
 	if (regs == NULL)
 		return -ENODEV;
 
+	edac_op_state = EDAC_OPSTATE_POLL;
+
 	/* Get channel population */
 	reg = in_be64(&regs->mic_mnt_cfg);
 	dev_dbg(&pdev->dev, "MIC_MNT_CFG = 0x%016lx\n", reg);
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

edac-fix-enabling-of-polling-cell-module.patch
linux-next.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch

