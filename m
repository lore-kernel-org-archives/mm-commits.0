From: akpm@linux-foundation.org
Subject: + openrisc-drop-_page_file-and-pte_file-related-helpers.patch
 added to -mm tree
Date: Tue, 06 Jan 2015 15:34:42 -0800
Message-ID: <54ac7112.y4g3RL7N27kdmnZ6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbAFXen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, jonas@southpole.se, mm-commits@vger.kernel.org


The patch titled
     openrisc: drop _PAGE_FILE and pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     openrisc-drop-_page_file-and-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/openrisc-drop-_page_file-and-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/openrisc-drop-_page_file-and-pte_file-related-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> Subject:
openrisc: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jonas Bonn <jonas@southpole.se>
---

index 37bf6a3ef8f4..18994ccb1185 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/include/asm/pgtable.h |    8 --------
 arch/openrisc/kernel/head.S         |    5 -----
 2 files changed, 13 deletions(-)

diff -puN arch/openrisc/include/asm/pgtable.h~openrisc-drop-_page_file-and-pte_file-related-helpers arch/openrisc/include/asm/pgtable.h
--- a/arch/openrisc/include/asm/pgtable.h~openrisc-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/openrisc/include/asm/pgtable.h
@@ -125,7 +125,6 @@ extern void paging_init(void);
 #define _PAGE_CC       0x001 /* software: pte contains a translation */
 #define _PAGE_CI       0x002 /* cache inhibit          */
 #define _PAGE_WBC      0x004 /* write back cache       */
-#define _PAGE_FILE     0x004 /* set: pagecache, unset: swap (when !PRESENT) */
 #define _PAGE_WOM      0x008 /* weakly ordered memory  */
 
 #define _PAGE_A        0x010 /* accessed               */
@@ -240,7 +239,6 @@ static inline int pte_write(pte_t pte) {
 static inline int pte_exec(pte_t pte)  { return pte_val(pte) & _PAGE_EXEC; }
 static inline int pte_dirty(pte_t pte) { return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte) { return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_file(pte_t pte)  { return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_special(pte_t pte) { return 0; }
 static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
 
@@ -438,12 +436,6 @@ static inline void update_mmu_cache(stru
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-/* Encode and decode a nonlinear file mapping entry */
-
-#define PTE_FILE_MAX_BITS               26
-#define pte_to_pgoff(x)	                (pte_val(x) >> 6)
-#define pgoff_to_pte(x)	                __pte(((x) << 6) | _PAGE_FILE)
-
 #define kern_addr_valid(addr)           (1)
 
 #include <asm-generic/pgtable.h>
diff -puN arch/openrisc/kernel/head.S~openrisc-drop-_page_file-and-pte_file-related-helpers arch/openrisc/kernel/head.S
--- a/arch/openrisc/kernel/head.S~openrisc-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/openrisc/kernel/head.S
@@ -754,11 +754,6 @@ _dc_enable:
 
 /* ===============================================[ page table masks ]=== */
 
-/* bit 4 is used in hardware as write back cache bit. we never use this bit
- * explicitly, so we can reuse it as _PAGE_FILE bit and mask it out when
- * writing into hardware pte's
- */
-
 #define DTLB_UP_CONVERT_MASK  0x3fa
 #define ITLB_UP_CONVERT_MASK  0x3a
 
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

