From: akpm@linux-foundation.org
Subject: + mn10300-drop-_page_file-and-pte_file-related-helpers.patch
 added to -mm tree
Date: Tue, 06 Jan 2015 15:34:38 -0800
Message-ID: <54ac710e.sg9VF2FvzAhD6oKz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbAFXej (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dhowells@redhat.com, hughd@google.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: drop _PAGE_FILE and pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     mn10300-drop-_page_file-and-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mn10300-drop-_page_file-and-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mn10300-drop-_page_file-and-pte_file-related-helpers.patch

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
Subject: mn10300: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

This patch also increases the number of bits availble for swap offset.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/pgtable.h |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff -puN arch/mn10300/include/asm/pgtable.h~mn10300-drop-_page_file-and-pte_file-related-helpers arch/mn10300/include/asm/pgtable.h
--- a/arch/mn10300/include/asm/pgtable.h~mn10300-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/mn10300/include/asm/pgtable.h
@@ -134,7 +134,6 @@ extern pte_t kernel_vmalloc_ptes[(VMALLO
 #define _PAGE_NX		0			/* no-execute bit */
 
 /* If _PAGE_VALID is clear, we use these: */
-#define _PAGE_FILE		xPTEL2_C	/* set:pagecache unset:swap */
 #define _PAGE_PROTNONE		0x000		/* If not present */
 
 #define __PAGE_PROT_UWAUX	0x010
@@ -241,11 +240,6 @@ static inline int pte_young(pte_t pte)	{
 static inline int pte_write(pte_t pte)	{ return pte_val(pte) & __PAGE_PROT_WRITE; }
 static inline int pte_special(pte_t pte){ return 0; }
 
-/*
- * The following only works if pte_present() is not true.
- */
-static inline int pte_file(pte_t pte)	{ return pte_val(pte) & _PAGE_FILE; }
-
 static inline pte_t pte_rdprotect(pte_t pte)
 {
 	pte_val(pte) &= ~(__PAGE_PROT_USER|__PAGE_PROT_UWAUX); return pte;
@@ -338,16 +332,11 @@ static inline int pte_exec_kernel(pte_t
 	return 1;
 }
 
-#define PTE_FILE_MAX_BITS	30
-
-#define pte_to_pgoff(pte)	(pte_val(pte) >> 2)
-#define pgoff_to_pte(off)	__pte((off) << 2 | _PAGE_FILE)
-
 /* Encode and de-code a swap entry */
-#define __swp_type(x)			(((x).val >> 2) & 0x3f)
-#define __swp_offset(x)			((x).val >> 8)
+#define __swp_type(x)			(((x).val >> 1) & 0x3f)
+#define __swp_offset(x)			((x).val >> 7)
 #define __swp_entry(type, offset) \
-	((swp_entry_t) { ((type) << 2) | ((offset) << 8) })
+	((swp_entry_t) { ((type) << 1) | ((offset) << 7) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		__pte((x).val)
 
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

