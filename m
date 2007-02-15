From: akpm@linux-foundation.org
Subject: + mincore-vma-crossing-fix.patch added to -mm tree
Date: Wed, 14 Feb 2007 19:06:04 -0800
Message-ID: <200702150306.l1F364m4018284@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60040 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964886AbXBODGH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 22:06:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mincore: vma crossing fix
has been added to the -mm tree.  Its filename is
     mincore-vma-crossing-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
mincore-config_swap=n-fix.patch
mincore-fill-in-results-properly.patch
mincore-vma-crossing-fix.patch
git-block.patch
mm-remove-gcc-workaround.patch
fs-fix-__block_write_full_page-error-case-buffer-submission.patch
