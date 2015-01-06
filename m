From: akpm@linux-foundation.org
Subject: + frv-drop-_page_file-and-pte_file-related-helpers.patch added to -mm tree
Date: Tue, 06 Jan 2015 15:34:22 -0800
Message-ID: <54ac70fe.2OI8s+cP0+D13CD4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbbAFXeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: drop _PAGE_FILE and pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     frv-drop-_page_file-and-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frv-drop-_page_file-and-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/frv-drop-_page_file-and-pte_file-related-helpers.patch

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
Subject: frv: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

This patch also increase number of bits availble for swap offset.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/pgtable.h |   29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff -puN arch/frv/include/asm/pgtable.h~frv-drop-_page_file-and-pte_file-related-helpers arch/frv/include/asm/pgtable.h
--- a/arch/frv/include/asm/pgtable.h~frv-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/frv/include/asm/pgtable.h
@@ -62,10 +62,6 @@ typedef pte_t *pte_addr_t;
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
 
-#ifndef __ASSEMBLY__
-static inline int pte_file(pte_t pte) { return 0; }
-#endif
-
 #define ZERO_PAGE(vaddr)	({ BUG(); NULL; })
 
 #define swapper_pg_dir		((pgd_t *) NULL)
@@ -298,7 +294,6 @@ static inline pmd_t *pmd_offset(pud_t *d
 
 #define _PAGE_RESERVED_MASK	(xAMPRx_RESERVED8 | xAMPRx_RESERVED13)
 
-#define _PAGE_FILE		0x002	/* set:pagecache unset:swap */
 #define _PAGE_PROTNONE		0x000	/* If not present */
 
 #define _PAGE_CHG_MASK		(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
@@ -463,27 +458,15 @@ static inline pte_t pte_modify(pte_t pte
  * Handle swap and file entries
  * - the PTE is encoded in the following format:
  *	bit 0:		Must be 0 (!_PAGE_PRESENT)
- *	bit 1:		Type: 0 for swap, 1 for file (_PAGE_FILE)
- *	bits 2-7:	Swap type
- *	bits 8-31:	Swap offset
- *	bits 2-31:	File pgoff
- */
-#define __swp_type(x)			(((x).val >> 2) & 0x1f)
-#define __swp_offset(x)			((x).val >> 8)
-#define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 2) | ((offset) << 8) })
+ *	bits 1-6:	Swap type
+ *	bits 7-31:	Swap offset
+ */
+#define __swp_type(x)			(((x).val >> 1) & 0x1f)
+#define __swp_offset(x)			((x).val >> 7)
+#define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 1) | ((offset) << 7) })
 #define __pte_to_swp_entry(_pte)	((swp_entry_t) { (_pte).pte })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-static inline int pte_file(pte_t pte)
-{
-	return pte.pte & _PAGE_FILE;
-}
-
-#define PTE_FILE_MAX_BITS	29
-
-#define pte_to_pgoff(PTE)	((PTE).pte >> 2)
-#define pgoff_to_pte(off)	__pte((off) << 2 | _PAGE_FILE)
-
 /* Needs to be defined here and not in linux/mm.h, as it is arch dependent */
 #define PageSkip(page)		(0)
 #define kern_addr_valid(addr)	(1)
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

