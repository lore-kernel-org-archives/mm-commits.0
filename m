From: akpm@linux-foundation.org
Subject: - m68k-kill-page-walker-compile-warning.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:10:15 -0800
Message-ID: <200802080809.m1889ura014887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59836 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761115AbYBHITz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, haveblue@us.ibm.com, mpm@selenic.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     m68k: kill page walker compile warning
has been removed from the -mm tree.  Its filename was
     m68k-kill-page-walker-compile-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: kill page walker compile warning
From: Geert Uytterhoeven <geert@linux-m68k.org>

The recently introduced page walker (walk_page_range()) calls pgd_offset
with a const struct mm_struct pointer, causing the following compile
warning on m68k:

    mm/pagewalk.c:111: warning: passing argument 1 of 'pgd_offset' discards qualifiers from pointer target type

Make the `mm' parameter of the inline function pgd_offset() const to shut
it up.

As cris also uses an inline function, I expect a similar warning to show up
there. All other archs use a macro to define pgd_offset.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68k/motorola_pgtable.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/asm-m68k/motorola_pgtable.h~m68k-kill-page-walker-compile-warning include/asm-m68k/motorola_pgtable.h
--- a/include/asm-m68k/motorola_pgtable.h~m68k-kill-page-walker-compile-warning
+++ a/include/asm-m68k/motorola_pgtable.h
@@ -191,7 +191,8 @@ static inline pte_t pte_mkcache(pte_t pt
 #define pgd_index(address)     ((address) >> PGDIR_SHIFT)
 
 /* to find an entry in a page-table-directory */
-static inline pgd_t *pgd_offset(struct mm_struct *mm, unsigned long address)
+static inline pgd_t *pgd_offset(const struct mm_struct *mm,
+				unsigned long address)
 {
 	return mm->pgd + pgd_index(address);
 }
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
procfs-constify-function-pointer-tables.patch
avoid-overflows-in-kernel-timec.patch
