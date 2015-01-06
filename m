From: akpm@linux-foundation.org
Subject: + sparc-drop-pte_file-related-helpers.patch added to -mm tree
Date: Tue, 06 Jan 2015 15:34:54 -0800
Message-ID: <54ac711e.C/Eb0bjJQt94EdUB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbAFXez (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: drop pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     sparc-drop-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc-drop-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc-drop-pte_file-related-helpers.patch

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
Subject: sparc: drop pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

This patch also increase number of bits availble for swap offset.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_32.h |   24 ---------------
 arch/sparc/include/asm/pgtable_64.h |   40 --------------------------
 arch/sparc/include/asm/pgtsrmmu.h   |   14 +++------
 3 files changed, 5 insertions(+), 73 deletions(-)

diff -puN arch/sparc/include/asm/pgtable_32.h~sparc-drop-pte_file-related-helpers arch/sparc/include/asm/pgtable_32.h
--- a/arch/sparc/include/asm/pgtable_32.h~sparc-drop-pte_file-related-helpers
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -221,14 +221,6 @@ static inline int pte_young(pte_t pte)
 	return pte_val(pte) & SRMMU_REF;
 }
 
-/*
- * The following only work if pte_present() is not true.
- */
-static inline int pte_file(pte_t pte)
-{
-	return pte_val(pte) & SRMMU_FILE;
-}
-
 static inline int pte_special(pte_t pte)
 {
 	return 0;
@@ -375,22 +367,6 @@ static inline swp_entry_t __swp_entry(un
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-/* file-offset-in-pte helpers */
-static inline unsigned long pte_to_pgoff(pte_t pte)
-{
-	return pte_val(pte) >> SRMMU_PTE_FILE_SHIFT;
-}
-
-static inline pte_t pgoff_to_pte(unsigned long pgoff)
-{
-	return __pte((pgoff << SRMMU_PTE_FILE_SHIFT) | SRMMU_FILE);
-}
-
-/*
- * This is made a constant because mm/fremap.c required a constant.
- */
-#define PTE_FILE_MAX_BITS 24
-
 static inline unsigned long
 __get_phys (unsigned long addr)
 {
diff -puN arch/sparc/include/asm/pgtable_64.h~sparc-drop-pte_file-related-helpers arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~sparc-drop-pte_file-related-helpers
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -137,7 +137,6 @@ bool kern_addr_valid(unsigned long addr)
 #define _PAGE_SOFT_4U	  _AC(0x0000000000001F80,UL) /* Software bits:       */
 #define _PAGE_EXEC_4U	  _AC(0x0000000000001000,UL) /* Executable SW bit    */
 #define _PAGE_MODIFIED_4U _AC(0x0000000000000800,UL) /* Modified (dirty)     */
-#define _PAGE_FILE_4U	  _AC(0x0000000000000800,UL) /* Pagecache page       */
 #define _PAGE_ACCESSED_4U _AC(0x0000000000000400,UL) /* Accessed (ref'd)     */
 #define _PAGE_READ_4U	  _AC(0x0000000000000200,UL) /* Readable SW Bit      */
 #define _PAGE_WRITE_4U	  _AC(0x0000000000000100,UL) /* Writable SW Bit      */
@@ -167,7 +166,6 @@ bool kern_addr_valid(unsigned long addr)
 #define _PAGE_EXEC_4V	  _AC(0x0000000000000080,UL) /* Executable Page      */
 #define _PAGE_W_4V	  _AC(0x0000000000000040,UL) /* Writable             */
 #define _PAGE_SOFT_4V	  _AC(0x0000000000000030,UL) /* Software bits        */
-#define _PAGE_FILE_4V	  _AC(0x0000000000000020,UL) /* Pagecache page       */
 #define _PAGE_PRESENT_4V  _AC(0x0000000000000010,UL) /* Present              */
 #define _PAGE_RESV_4V	  _AC(0x0000000000000008,UL) /* Reserved             */
 #define _PAGE_SZ16GB_4V	  _AC(0x0000000000000007,UL) /* 16GB Page            */
@@ -332,22 +330,6 @@ static inline pmd_t pmd_modify(pmd_t pmd
 }
 #endif
 
-static inline pte_t pgoff_to_pte(unsigned long off)
-{
-	off <<= PAGE_SHIFT;
-
-	__asm__ __volatile__(
-	"\n661:	or		%0, %2, %0\n"
-	"	.section	.sun4v_1insn_patch, \"ax\"\n"
-	"	.word		661b\n"
-	"	or		%0, %3, %0\n"
-	"	.previous\n"
-	: "=r" (off)
-	: "0" (off), "i" (_PAGE_FILE_4U), "i" (_PAGE_FILE_4V));
-
-	return __pte(off);
-}
-
 static inline pgprot_t pgprot_noncached(pgprot_t prot)
 {
 	unsigned long val = pgprot_val(prot);
@@ -609,22 +591,6 @@ static inline unsigned long pte_exec(pte
 	return (pte_val(pte) & mask);
 }
 
-static inline unsigned long pte_file(pte_t pte)
-{
-	unsigned long val = pte_val(pte);
-
-	__asm__ __volatile__(
-	"\n661:	and		%0, %2, %0\n"
-	"	.section	.sun4v_1insn_patch, \"ax\"\n"
-	"	.word		661b\n"
-	"	and		%0, %3, %0\n"
-	"	.previous\n"
-	: "=r" (val)
-	: "0" (val), "i" (_PAGE_FILE_4U), "i" (_PAGE_FILE_4V));
-
-	return val;
-}
-
 static inline unsigned long pte_present(pte_t pte)
 {
 	unsigned long val = pte_val(pte);
@@ -971,12 +937,6 @@ pgtable_t pgtable_trans_huge_withdraw(st
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-/* File offset in PTE support. */
-unsigned long pte_file(pte_t);
-#define pte_to_pgoff(pte)	(pte_val(pte) >> PAGE_SHIFT)
-pte_t pgoff_to_pte(unsigned long);
-#define PTE_FILE_MAX_BITS	(64UL - PAGE_SHIFT - 1UL)
-
 int page_in_phys_avail(unsigned long paddr);
 
 /*
diff -puN arch/sparc/include/asm/pgtsrmmu.h~sparc-drop-pte_file-related-helpers arch/sparc/include/asm/pgtsrmmu.h
--- a/arch/sparc/include/asm/pgtsrmmu.h~sparc-drop-pte_file-related-helpers
+++ a/arch/sparc/include/asm/pgtsrmmu.h
@@ -80,10 +80,6 @@
 #define SRMMU_PRIV         0x1c
 #define SRMMU_PRIV_RDONLY  0x18
 
-#define SRMMU_FILE         0x40	/* Implemented in software */
-
-#define SRMMU_PTE_FILE_SHIFT     8	/* == 32-PTE_FILE_MAX_BITS */
-
 #define SRMMU_CHG_MASK    (0xffffff00 | SRMMU_REF | SRMMU_DIRTY)
 
 /* SRMMU swap entry encoding
@@ -94,13 +90,13 @@
  * oooooooooooooooooootttttRRRRRRRR
  * fedcba9876543210fedcba9876543210
  *
- * The bottom 8 bits are reserved for protection and status bits, especially
- * FILE and PRESENT.
+ * The bottom 7 bits are reserved for protection and status bits, especially
+ * PRESENT.
  */
 #define SRMMU_SWP_TYPE_MASK	0x1f
-#define SRMMU_SWP_TYPE_SHIFT	SRMMU_PTE_FILE_SHIFT
-#define SRMMU_SWP_OFF_MASK	0x7ffff
-#define SRMMU_SWP_OFF_SHIFT	(SRMMU_PTE_FILE_SHIFT + 5)
+#define SRMMU_SWP_TYPE_SHIFT	7
+#define SRMMU_SWP_OFF_MASK	0xfffff
+#define SRMMU_SWP_OFF_SHIFT	(SRMMU_SWP_TYPE_SHIFT + 5)
 
 /* Some day I will implement true fine grained access bits for
  * user pages because the SRMMU gives us the capabilities to
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

