From: akpm@linux-foundation.org
Subject: + tile-drop-pte_file-related-helpers.patch added to -mm tree
Date: Tue, 06 Jan 2015 15:34:56 -0800
Message-ID: <54ac7120.Ai4kJwNBbnFgTOuv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbAFXe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, cmetcalf@ezchip.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: drop pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     tile-drop-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tile-drop-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tile-drop-pte_file-related-helpers.patch

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
Subject: tile: drop pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Chris Metcalf <cmetcalf@ezchip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/asm/pgtable.h |   11 -----------
 arch/tile/mm/homecache.c        |    4 ----
 2 files changed, 15 deletions(-)

diff -puN arch/tile/include/asm/pgtable.h~tile-drop-pte_file-related-helpers arch/tile/include/asm/pgtable.h
--- a/arch/tile/include/asm/pgtable.h~tile-drop-pte_file-related-helpers
+++ a/arch/tile/include/asm/pgtable.h
@@ -285,17 +285,6 @@ extern void start_mm_caching(struct mm_s
 extern void check_mm_caching(struct mm_struct *prev, struct mm_struct *next);
 
 /*
- * Support non-linear file mappings (see sys_remap_file_pages).
- * This is defined by CLIENT1 set but CLIENT0 and _PAGE_PRESENT clear, and the
- * file offset in the 32 high bits.
- */
-#define _PAGE_FILE        HV_PTE_CLIENT1
-#define PTE_FILE_MAX_BITS 32
-#define pte_file(pte)     (hv_pte_get_client1(pte) && !hv_pte_get_client0(pte))
-#define pte_to_pgoff(pte) ((pte).val >> 32)
-#define pgoff_to_pte(off) ((pte_t) { (((long long)(off)) << 32) | _PAGE_FILE })
-
-/*
  * Encode and de-code a swap entry (see <linux/swapops.h>).
  * We put the swap file type+offset in the 32 high bits;
  * I believe we can just leave the low bits clear.
diff -puN arch/tile/mm/homecache.c~tile-drop-pte_file-related-helpers arch/tile/mm/homecache.c
--- a/arch/tile/mm/homecache.c~tile-drop-pte_file-related-helpers
+++ a/arch/tile/mm/homecache.c
@@ -263,10 +263,6 @@ static int pte_to_home(pte_t pte)
 /* Update the home of a PTE if necessary (can also be used for a pgprot_t). */
 pte_t pte_set_home(pte_t pte, int home)
 {
-	/* Check for non-linear file mapping "PTEs" and pass them through. */
-	if (pte_file(pte))
-		return pte;
-
 #if CHIP_HAS_MMIO()
 	/* Check for MMIO mappings and pass them through. */
 	if (hv_pte_get_mode(pte) == HV_PTE_MODE_MMIO)
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

