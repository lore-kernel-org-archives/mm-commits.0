From: akpm@linux-foundation.org
Subject: + edac-cell-fix-incorrect-edac_mode.patch added to -mm tree
Date: Thu, 16 Oct 2008 16:33:12 -0700
Message-ID: <200810162333.m9GNXCQN006684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756294AbYJPXdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 19:33:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, dougthompson@xmission.com


The patch titled
     edac cell: fix incorrect edac_mode
has been added to the -mm tree.  Its filename is
     edac-cell-fix-incorrect-edac_mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac cell: fix incorrect edac_mode
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

The cell_edac driver is setting the edac_mode field of the csrow's to an
incorrect value, causing the sysfs show routine for that field to go out
of an array bound and Oopsing the kernel when used.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
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
compat-generic-compat-get-settimeofday.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
powerpc-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
powerpc-use-iommu_num_pages-function-in-iommu-code.patch
mpc52xx_psc_spi-remove-code-associated-with-config_ppc_merge.patch
rtc-use-config_ppc-instead-of-config_ppc_merge.patch
radeonfb-revert-fix-radeon-ddc-regression.patch
radeonfb-misc-cleanup-of-engine-and-dst-cache-handling.patch
radeonfb-accelerate-imageblit-and-other-improvements.patch
ibm_newemac-fix-new-mal-feature-handling.patch
mm-cleanup-to-make-remove_memory-arch-neutral.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
edac-cell-fix-incorrect-edac_mode.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch

