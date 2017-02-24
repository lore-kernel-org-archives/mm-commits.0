From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 24 Feb 2017 14:36:17 -0800
Message-ID: <58b0b561.Xwg2SOzR4phL1CWD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33814 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbdBXWg1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:36:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk-checkpatch-fixes

WARNING: line over 80 characters
#98: FILE: mm/migrate.c:222:
+		/* Recheck VMA as permissions can change since migration started  */

total: 0 errors, 1 warnings, 127 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk-checkpatch-fixes mm/migrate.c
--- a/mm/migrate.c~mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk-checkpatch-fixes
+++ a/mm/migrate.c
@@ -216,7 +216,9 @@ static int remove_migration_pte(struct p
 		if (pte_swp_soft_dirty(*pvmw.pte))
 			pte = pte_mksoft_dirty(pte);
 
-		/* Recheck VMA as permissions can change since migration started  */
+		/*
+		 * Recheck VMA as permissions can change since migration started
+		 */
 		entry = pte_to_swp_entry(*pvmw.pte);
 		if (is_write_migration_entry(entry))
 			pte = maybe_mkwrite(pte, vma);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplugc-unexport-__remove_pages.patch
z3fold-add-kref-refcounting-checkpatch-fixes.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix.patch
mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
lib-update-lz4-compressor-module.patch
lib-update-lz4-compressor-module-fix-fix.patch
lib-update-lz4-compressor-module-fix-fix-fix.patch

