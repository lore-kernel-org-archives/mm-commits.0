From: akpm@linux-foundation.org
Subject: - edac-cell-fix-incorrect-edac_mode.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:23 -0700
Message-ID: <200810202037.m9KKbNuE011620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753869AbYJTUiV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:38:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, dougthompson@xmission.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     edac cell: fix incorrect edac_mode
has been removed from the -mm tree.  Its filename was
     edac-cell-fix-incorrect-edac_mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac cell: fix incorrect edac_mode
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

The cell_edac driver is setting the edac_mode field of the csrow's to an
incorrect value, causing the sysfs show routine for that field to go out
of an array bound and Oopsing the kernel when used.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: <stable@kernel.org>		[2.6.27.x, 2.6.26.x. 2.6.25.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/cell_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/cell_edac.c~edac-cell-fix-incorrect-edac_mode drivers/edac/cell_edac.c
--- a/drivers/edac/cell_edac.c~edac-cell-fix-incorrect-edac_mode
+++ a/drivers/edac/cell_edac.c
@@ -142,7 +142,7 @@ static void __devinit cell_edac_init_csr
 		csrow->nr_pages = (r.end - r.start + 1) >> PAGE_SHIFT;
 		csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
 		csrow->mtype = MEM_XDR;
-		csrow->edac_mode = EDAC_FLAG_EC | EDAC_FLAG_SECDED;
+		csrow->edac_mode = EDAC_SECDED;
 		dev_dbg(mci->dev,
 			"Initialized on node %d, chanmask=0x%x,"
 			" first_page=0x%lx, nr_pages=0x%x\n",
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
linux-next.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch

