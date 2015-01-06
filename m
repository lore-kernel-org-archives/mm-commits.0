From: akpm@linux-foundation.org
Subject: + hexagon-drop-_page_file-and-pte_file-related-helpers.patch
 added to -mm tree
Date: Tue, 06 Jan 2015 15:34:24 -0800
Message-ID: <54ac7100.bjjvdFWn+VmOgdhr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbbAFXeZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, rkuo@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: drop _PAGE_FILE and pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     hexagon-drop-_page_file-and-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hexagon-drop-_page_file-and-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hexagon-drop-_page_file-and-pte_file-related-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: hexagon: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

This patch also increase number of bits availble for swap offset.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/include/asm/pgtable.h |   60 +++++++--------------------
 1 file changed, 16 insertions(+), 44 deletions(-)

diff -puN arch/hexagon/include/asm/pgtable.h~hexagon-drop-_page_file-and-pte_file-related-helpers arch/hexagon/include/asm/pgtable.h
--- a/arch/hexagon/include/asm/pgtable.h~hexagon-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/hexagon/include/asm/pgtable.h
@@ -62,13 +62,6 @@ extern unsigned long zero_page_mask;
 #define _PAGE_ACCESSED	(1<<2)
 
 /*
- * _PAGE_FILE is only meaningful if _PAGE_PRESENT is false, while
- * _PAGE_DIRTY is only meaningful if _PAGE_PRESENT is true.
- * So we can overload the bit...
- */
-#define _PAGE_FILE	_PAGE_DIRTY /* set:  pagecache, unset = swap */
-
-/*
  * For now, let's say that Valid and Present are the same thing.
  * Alternatively, we could say that it's the "or" of R, W, and X
  * permissions.
@@ -456,57 +449,36 @@ static inline int pte_exec(pte_t pte)
 #define pgtable_cache_init()    do { } while (0)
 
 /*
- * Swap/file PTE definitions.  If _PAGE_PRESENT is zero, the rest of the
- * PTE is interpreted as swap information.  Depending on the _PAGE_FILE
- * bit, the remaining free bits are eitehr interpreted as a file offset
- * or a swap type/offset tuple.  Rather than have the TLB fill handler
- * test _PAGE_PRESENT, we're going to reserve the permissions bits
- * and set them to all zeros for swap entries, which speeds up the
- * miss handler at the cost of 3 bits of offset.  That trade-off can
- * be revisited if necessary, but Hexagon processor architecture and
- * target applications suggest a lot of TLB misses and not much swap space.
+ * Swap/file PTE definitions.  If _PAGE_PRESENT is zero, the rest of the PTE is
+ * interpreted as swap information.  The remaining free bits are interpreted as
+ * swap type/offset tuple.  Rather than have the TLB fill handler test
+ * _PAGE_PRESENT, we're going to reserve the permissions bits and set them to
+ * all zeros for swap entries, which speeds up the miss handler at the cost of
+ * 3 bits of offset.  That trade-off can be revisited if necessary, but Hexagon
+ * processor architecture and target applications suggest a lot of TLB misses
+ * and not much swap space.
  *
  * Format of swap PTE:
  *	bit	0:	Present (zero)
- *	bit	1:	_PAGE_FILE (zero)
- *	bits	2-6:	swap type (arch independent layer uses 5 bits max)
- *	bits	7-9:	bits 2:0 of offset
- *	bits 10-12:	effectively _PAGE_PROTNONE (all zero)
- *	bits 13-31:  bits 21:3 of swap offset
- *
- * Format of file PTE:
- *	bit	0:	Present (zero)
- *	bit	1:	_PAGE_FILE (zero)
- *	bits	2-9:	bits 7:0 of offset
- *	bits 10-12:	effectively _PAGE_PROTNONE (all zero)
- *	bits 13-31:  bits 26:8 of swap offset
+ *	bits	1-5:	swap type (arch independent layer uses 5 bits max)
+ *	bits	6-9:	bits 3:0 of offset
+ *	bits	10-12:	effectively _PAGE_PROTNONE (all zero)
+ *	bits	13-31:  bits 22:4 of swap offset
  *
  * The split offset makes some of the following macros a little gnarly,
  * but there's plenty of precedent for this sort of thing.
  */
-#define PTE_FILE_MAX_BITS     27
 
 /* Used for swap PTEs */
-#define __swp_type(swp_pte)		(((swp_pte).val >> 2) & 0x1f)
+#define __swp_type(swp_pte)		(((swp_pte).val >> 1) & 0x1f)
 
 #define __swp_offset(swp_pte) \
-	((((swp_pte).val >> 7) & 0x7) | (((swp_pte).val >> 10) & 0x003ffff8))
+	((((swp_pte).val >> 6) & 0xf) | (((swp_pte).val >> 9) & 0x7ffff0))
 
 #define __swp_entry(type, offset) \
 	((swp_entry_t)	{ \
-		((type << 2) | \
-		 ((offset & 0x3ffff8) << 10) | ((offset & 0x7) << 7)) })
-
-/* Used for file PTEs */
-#define pte_file(pte) \
-	((pte_val(pte) & (_PAGE_FILE | _PAGE_PRESENT)) == _PAGE_FILE)
-
-#define pte_to_pgoff(pte) \
-	(((pte_val(pte) >> 2) & 0xff) | ((pte_val(pte) >> 5) & 0x07ffff00))
-
-#define pgoff_to_pte(off) \
-	((pte_t) { ((((off) & 0x7ffff00) << 5) | (((off) & 0xff) << 2)\
-	| _PAGE_FILE) })
+		((type << 1) | \
+		 ((offset & 0x7ffff0) << 9) | ((offset & 0xf) << 6)) })
 
 /*  Oh boy.  There are a lot of possible arch overrides found in this file.  */
 #include <asm-generic/pgtable.h>
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch
mm-drop-support-of-non-linear-mapping-from-fault-codepath.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch
proc-drop-handling-non-linear-mappings.patch
rmap-drop-support-of-non-linear-mappings.patch
mm-replace-vma-shareadlinear-with-vma-shared.patch
mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch
asm-generic-drop-unused-pte_file-helpers.patch
alpha-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers.patch
arm64-drop-pte_file-and-pte_file-related-helpers.patch
arm-drop-l_pte_file-and-pte_file-related-helpers.patch
avr32-drop-_page_file-and-pte_file-related-helpers.patch
blackfin-drop-pte_file.patch
c6x-drop-pte_file.patch
cris-drop-_page_file-and-pte_file-related-helpers.patch
frv-drop-_page_file-and-pte_file-related-helpers.patch
hexagon-drop-_page_file-and-pte_file-related-helpers.patch
ia64-drop-_page_file-and-pte_file-related-helpers.patch
m32r-drop-_page_file-and-pte_file-related-helpers.patch
m68k-drop-_page_file-and-pte_file-related-helpers.patch
metag-drop-_page_file-and-pte_file-related-helpers.patch
microblaze-drop-_page_file-and-pte_file-related-helpers.patch
mips-drop-_page_file-and-pte_file-related-helpers.patch
mn10300-drop-_page_file-and-pte_file-related-helpers.patch
nios2-drop-_page_file-and-pte_file-related-helpers.patch
openrisc-drop-_page_file-and-pte_file-related-helpers.patch
parisc-drop-_page_file-and-pte_file-related-helpers.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch
s390-drop-pte_file-related-helpers.patch
score-drop-_page_file-and-pte_file-related-helpers.patch
sh-drop-_page_file-and-pte_file-related-helpers.patch
sparc-drop-pte_file-related-helpers.patch
tile-drop-pte_file-related-helpers.patch
um-drop-_page_file-and-pte_file-related-helpers.patch
unicore32-drop-pte_file-related-helpers.patch
x86-drop-_page_file-and-pte_file-related-helpers.patch
xtensa-drop-_page_file-and-pte_file-related-helpers.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch

