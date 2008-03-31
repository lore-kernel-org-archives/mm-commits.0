From: akpm@linux-foundation.org
Subject: + s390-implement-pte-special-bit.patch added to -mm tree
Date: Mon, 31 Mar 2008 15:04:51 -0700
Message-ID: <200803312204.m2VM4q6i028387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648AbYCaWE7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 18:04:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, cotte@de.ibm.com, heiko.carstens@de.ibm.com, jaredeh@gmail.com, schwidefsky@de.ibm.com, torvalds@linux-foundation.org


The patch titled
     s390: implement pte special bit
has been added to the -mm tree.  Its filename is
     s390-implement-pte-special-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390: implement pte special bit
From: Nick Piggin <npiggin@suse.de>

Convert XIP to support non-struct page backed memory, using VM_MIXEDMAP for
the user mappings.

This requires the get_xip_page API to be changed to an address based one. 
Improve the API layering a little bit too, while we're here.

This is required in order to support XIP filesystems on memory that isn't
backed with struct page (but memory with struct page is still supported too).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Cc: Jared Hulbert <jaredeh@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-s390/pgtable.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/asm-s390/pgtable.h~s390-implement-pte-special-bit include/asm-s390/pgtable.h
--- a/include/asm-s390/pgtable.h~s390-implement-pte-special-bit
+++ a/include/asm-s390/pgtable.h
@@ -220,6 +220,8 @@ extern char empty_zero_page[PAGE_SIZE];
 /* Software bits in the page table entry */
 #define _PAGE_SWT	0x001		/* SW pte type bit t */
 #define _PAGE_SWX	0x002		/* SW pte type bit x */
+#define _PAGE_SPECIAL	0x004		/* SW associated with special page */
+#define __HAVE_ARCH_PTE_SPECIAL
 
 /* Six different types of pages. */
 #define _PAGE_TYPE_EMPTY	0x400
@@ -532,7 +534,7 @@ static inline int pte_file(pte_t pte)
 
 static inline int pte_special(pte_t pte)
 {
-	return 0;
+	return (pte_val(pte) & _PAGE_SPECIAL);
 }
 
 #define __HAVE_ARCH_PTE_SAME
@@ -734,6 +736,7 @@ static inline pte_t pte_mkyoung(pte_t pt
 
 static inline pte_t pte_mkspecial(pte_t pte)
 {
+	pte_val(pte) |= _PAGE_SPECIAL;
 	return pte;
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
git-kvm.patch
git-nfsd.patch
mm-remove-nopage.patch
mm-introduce-vm_mixedmap.patch
mm-introduce-pte_special-pte-bit.patch
mm-add-vm_insert_mixed.patch
return-pfn-from-direct_access-for-xip.patch
xip-support-non-struct-page-backed-memory.patch
s390-implement-pte-special-bit.patch
fuse-implement-perform_write.patch
reiser4.patch
reiser4-correct-references-to-filemap_nopage.patch
likeliness-accounting-change-and-cleanup.patch

