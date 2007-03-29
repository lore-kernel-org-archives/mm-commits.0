From: akpm@linux-foundation.org
Subject: - uml-fix-pte-bit-collision.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:37:14 -0700
Message-ID: <200703292337.l2TNbEVN015081@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42949 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945918AbXC2XhT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:37:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix pte bit collision
has been removed from the -mm tree.  Its filename was
     uml-fix-pte-bit-collision.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix pte bit collision
From: Miklos Szeredi <mszeredi@suse.cz>

_PAGE_PROTNONE conflicts with the lowest bit of pgoff.  This causes all sorts
of weirdness when nonlinear mappings are used.

Took me a good half day to track this down.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Acked-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/pgtable-2level.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/asm-um/pgtable-2level.h~uml-fix-pte-bit-collision include/asm-um/pgtable-2level.h
--- a/include/asm-um/pgtable-2level.h~uml-fix-pte-bit-collision
+++ a/include/asm-um/pgtable-2level.h
@@ -45,12 +45,12 @@ static inline void pgd_mkuptodate(pgd_t 
 	((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
 
 /*
- * Bits 0 through 3 are taken
+ * Bits 0 through 4 are taken
  */
-#define PTE_FILE_MAX_BITS	28
+#define PTE_FILE_MAX_BITS	27
 
-#define pte_to_pgoff(pte) (pte_val(pte) >> 4)
+#define pte_to_pgoff(pte) (pte_val(pte) >> 5)
 
-#define pgoff_to_pte(off) ((pte_t) { ((off) << 4) + _PAGE_FILE })
+#define pgoff_to_pte(off) ((pte_t) { ((off) << 5) + _PAGE_FILE })
 
 #endif
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-filesystem-subtype-support.patch
add-file-position-info-to-proc.patch
consolidate-generic_writepages-and-mpage_writepages.patch
