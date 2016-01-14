From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 14 Jan 2016 14:43:18 -0800
Message-ID: <56982486.BtxlXCes8tCWeQj6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493AbcANWnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:43:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes

ERROR: code indent should use tabs where possible
#171: FILE: mm/page_idle.c:75:
+                if (!pmd_present(*pmd))$

WARNING: please, no spaces at the start of a line
#171: FILE: mm/page_idle.c:75:
+                if (!pmd_present(*pmd))$

WARNING: Missing a blank line after declarations
#194: FILE: mm/page_idle.c:93:
+		pmd_t pmde = *pmd;
+		barrier();

WARNING: Missing a blank line after declarations
#304: FILE: mm/rmap.c:867:
+		pmd_t pmde = *pmd;
+		barrier();

total: 1 errors, 3 warnings, 327 lines checked

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_idle.c |    3 ++-
 mm/rmap.c      |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page_idle.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes mm/page_idle.c
--- a/mm/page_idle.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes
+++ a/mm/page_idle.c
@@ -72,7 +72,7 @@ static int page_idle_clear_pte_refs_one(
 
 	if (pmd_trans_huge(*pmd)) {
 		ptl = pmd_lock(mm, pmd);
-                if (!pmd_present(*pmd))
+		if (!pmd_present(*pmd))
 			goto unlock_pmd;
 		if (unlikely(!pmd_trans_huge(*pmd))) {
 			spin_unlock(ptl);
@@ -90,6 +90,7 @@ unlock_pmd:
 		return SWAP_AGAIN;
 	} else {
 		pmd_t pmde = *pmd;
+
 		barrier();
 		if (!pmd_present(pmde) || pmd_trans_huge(pmde))
 			return SWAP_AGAIN;
diff -puN mm/rmap.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes mm/rmap.c
--- a/mm/rmap.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes
+++ a/mm/rmap.c
@@ -866,6 +866,7 @@ unlock_pmd:
 		return ret;
 	} else {
 		pmd_t pmde = *pmd;
+
 		barrier();
 		if (!pmd_present(pmde) || pmd_trans_huge(pmde))
 			return SWAP_AGAIN;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch

