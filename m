From: akpm@linux-foundation.org
Subject: - mincore-vma-crossing-fix.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:02:41 -0800
Message-ID: <200702160802.l1G82faf023952@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58777 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966184AbXBPIC5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:02:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mincore: vma crossing fix
has been removed from the -mm tree.  Its filename was
     mincore-vma-crossing-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mincore: vma crossing fix
From: Nick Piggin <npiggin@suse.de>

My mincore also forgot about crossing vmas.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/mincore.c~mincore-vma-crossing-fix mm/mincore.c
--- a/mm/mincore.c~mincore-vma-crossing-fix
+++ a/mm/mincore.c
@@ -77,8 +77,16 @@ static long do_mincore(unsigned long add
 	 * PTE array for our address.
 	 */
 	nr = PTRS_PER_PTE - ((addr >> PAGE_SHIFT) & (PTRS_PER_PTE-1));
-	if (nr > pages)
-		nr = pages;
+
+	/*
+	 * Don't overrun this vma
+	 */
+	nr = min(nr, (vma->vm_end - addr) >> PAGE_SHIFT);
+
+	/*
+	 * Don't return more than the caller asked for
+	 */
+	nr = min(nr, pages);
 
 	pgd = pgd_offset(vma->vm_mm, addr);
 	if (pgd_none_or_clear_bad(pgd))
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
git-block.patch
fs-fix-__block_write_full_page-error-case-buffer-submission.patch
fs-fix-libfs-data-leak.patch
fs-fix-nobh-data-leak.patch
