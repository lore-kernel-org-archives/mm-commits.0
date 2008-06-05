From: akpm@linux-foundation.org
Subject: + powerpc-implement-pte_special.patch added to -mm tree
Date: Thu, 05 Jun 2008 13:35:11 -0700
Message-ID: <200806052035.m55KZBIO028519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754483AbYFEUgp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 16:36:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, benh@kernel.crashing.org, hugh@veritas.com, paulmck@us.ibm.com, paulus@samba.org


The patch titled
     powerpc: implement pte_special
has been added to the -mm tree.  Its filename is
     powerpc-implement-pte_special.patch

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
Subject: powerpc: implement pte_special
From: Nick Piggin <npiggin@suse.de>

Implement PTE_SPECIAL for powerpc.  At the moment I only have a spare bit
for the 4k pages config, but Ben has freed up another one for 64k pages
that I can use, so this patch should include that before it goes upstream.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/pgtable-4k.h    |    2 ++
 include/asm-powerpc/pgtable-64k.h   |    1 +
 include/asm-powerpc/pgtable-ppc64.h |    4 ++--
 3 files changed, 5 insertions(+), 2 deletions(-)

diff -puN include/asm-powerpc/pgtable-4k.h~powerpc-implement-pte_special include/asm-powerpc/pgtable-4k.h
--- a/include/asm-powerpc/pgtable-4k.h~powerpc-implement-pte_special
+++ a/include/asm-powerpc/pgtable-4k.h
@@ -45,6 +45,8 @@
 #define _PAGE_GROUP_IX  0x7000 /* software: HPTE index within group */
 #define _PAGE_F_SECOND  _PAGE_SECONDARY
 #define _PAGE_F_GIX     _PAGE_GROUP_IX
+#define _PAGE_SPECIAL	0x10000 /* software: special page */
+#define __HAVE_ARCH_PTE_SPECIAL
 
 /* PTE flags to conserve for HPTE identification */
 #define _PAGE_HPTEFLAGS (_PAGE_BUSY | _PAGE_HASHPTE | \
diff -puN include/asm-powerpc/pgtable-64k.h~powerpc-implement-pte_special include/asm-powerpc/pgtable-64k.h
--- a/include/asm-powerpc/pgtable-64k.h~powerpc-implement-pte_special
+++ a/include/asm-powerpc/pgtable-64k.h
@@ -74,6 +74,7 @@ static inline struct subpage_prot_table 
 #define _PAGE_HPTE_SUB0	0x08000000 /* combo only: first sub page */
 #define _PAGE_COMBO	0x10000000 /* this is a combo 4k page */
 #define _PAGE_4K_PFN	0x20000000 /* PFN is for a single 4k page */
+#define _PAGE_SPECIAL	0x0	   /* don't have enough room for this yet */
 
 /* Note the full page bits must be in the same location as for normal
  * 4k pages as the same asssembly will be used to insert 64K pages
diff -puN include/asm-powerpc/pgtable-ppc64.h~powerpc-implement-pte_special include/asm-powerpc/pgtable-ppc64.h
--- a/include/asm-powerpc/pgtable-ppc64.h~powerpc-implement-pte_special
+++ a/include/asm-powerpc/pgtable-ppc64.h
@@ -243,7 +243,7 @@ static inline int pte_write(pte_t pte) {
 static inline int pte_dirty(pte_t pte) { return pte_val(pte) & _PAGE_DIRTY;}
 static inline int pte_young(pte_t pte) { return pte_val(pte) & _PAGE_ACCESSED;}
 static inline int pte_file(pte_t pte) { return pte_val(pte) & _PAGE_FILE;}
-static inline int pte_special(pte_t pte) { return 0; }
+static inline int pte_special(pte_t pte) { return pte_val(pte) & _PAGE_SPECIAL; }
 
 static inline void pte_uncache(pte_t pte) { pte_val(pte) |= _PAGE_NO_CACHE; }
 static inline void pte_cache(pte_t pte)   { pte_val(pte) &= ~_PAGE_NO_CACHE; }
@@ -263,7 +263,7 @@ static inline pte_t pte_mkyoung(pte_t pt
 static inline pte_t pte_mkhuge(pte_t pte) {
 	return pte; }
 static inline pte_t pte_mkspecial(pte_t pte) {
-	return pte; }
+	pte_val(pte) |= _PAGE_SPECIAL; return pte; }
 static inline unsigned long pte_pgprot(pte_t pte)
 {
 	return __pgprot(pte_val(pte)) & PAGE_PROT_BITS;
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
vt-fix-vc_resize-locking.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

