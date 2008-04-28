From: akpm@linux-foundation.org
Subject: - mm-introduce-pte_special-pte-bit.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:52:44 -0700
Message-ID: <200804282152.m3SLqjC1017798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934799AbYD1Vw4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, cotte@de.ibm.com, heiko.carstens@de.ibm.com, jaredeh@gmail.com, schwidefsky@de.ibm.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     mm: introduce pte_special pte bit
has been removed from the -mm tree.  Its filename was
     mm-introduce-pte_special-pte-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: introduce pte_special pte bit
From: Nick Piggin <npiggin@suse.de>

s390 for one, cannot implement VM_MIXEDMAP with pfn_valid, due to their memory
model (which is more dynamic than most).  Instead, they had proposed to
implement it with an additional path through vm_normal_page(), using a bit in
the pte to determine whether or not the page should be refcounted:

vm_normal_page()
{
	...
        if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
                if (vma->vm_flags & VM_MIXEDMAP) {
#ifdef s390
			if (!mixedmap_refcount_pte(pte))
				return NULL;
#else
                        if (!pfn_valid(pfn))
                                return NULL;
#endif
                        goto out;
                }
	...
}

This is fine, however if we are allowed to use a bit in the pte to determine
refcountedness, we can use that to _completely_ replace all the vma based
schemes.  So instead of adding more cases to the already complex vma-based
scheme, we can have a clearly seperate and simple pte-based scheme (and get
slightly better code generation in the process):

vm_normal_page()
{
#ifdef s390
	if (!mixedmap_refcount_pte(pte))
		return NULL;
	return pte_page(pte);
#else
	...
#endif
}

And finally, we may rather make this concept usable by any architecture rather
than making it s390 only, so implement a new type of pte state for this. 
Unfortunately the old vma based code must stay, because some architectures may
not be able to spare pte bits.  This makes vm_normal_page a little bit more
ugly than we would like, but the 2 cases are clearly seperate.

So introduce a pte_special pte state, and use it in mm/memory.c.  It is
currently a noop for all architectures, so this doesn't actually result in any
compiled code changes to mm/memory.o.

BTW:
I haven't put vm_normal_page() into arch code as-per an earlier suggestion.
The reason is that, regardless of where vm_normal_page is actually
implemented, the *abstraction* is still exactly the same. Also, while it
depends on whether the architecture has pte_special or not, that is the
only two possible cases, and it really isn't an arch specific function --
the role of the arch code should be to provide primitive functions and
accessors with which to build the core code; pte_special does that. We do
not want architectures to know or care about vm_normal_page itself, and
we definitely don't want them being able to invent something new there
out of sight of mm/ code. If we made vm_normal_page an arch function, then
we have to make vm_insert_mixed (next patch) an arch function too. So I
don't think moving it to arch code fundamentally improves any abstractions,
while it does practically make the code more difficult to follow, for both
mm and arch developers, and easier to misuse.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jared Hulbert <jaredeh@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/pgtable.h         |    2 
 include/asm-arm/pgtable.h           |    3 
 include/asm-avr32/pgtable.h         |    8 ++
 include/asm-cris/pgtable.h          |    2 
 include/asm-frv/pgtable.h           |    2 
 include/asm-ia64/pgtable.h          |    3 
 include/asm-m32r/pgtable.h          |   10 ++
 include/asm-m68k/motorola_pgtable.h |    2 
 include/asm-m68k/sun3_pgtable.h     |    2 
 include/asm-mips/pgtable.h          |    2 
 include/asm-mn10300/pgtable.h       |    3 
 include/asm-parisc/pgtable.h        |    2 
 include/asm-powerpc/pgtable-ppc32.h |    3 
 include/asm-powerpc/pgtable-ppc64.h |    3 
 include/asm-ppc/pgtable.h           |    3 
 include/asm-s390/pgtable.h          |   10 ++
 include/asm-sh/pgtable_32.h         |    3 
 include/asm-sh/pgtable_64.h         |   10 +-
 include/asm-sparc/pgtable.h         |    7 +
 include/asm-sparc64/pgtable.h       |   10 ++
 include/asm-um/pgtable.h            |   10 ++
 include/asm-x86/pgtable.h           |   10 ++
 include/asm-xtensa/pgtable.h        |    4 +
 include/linux/mm.h                  |    4 -
 mm/memory.c                         |  101 ++++++++++++++------------
 25 files changed, 169 insertions(+), 50 deletions(-)

diff -puN include/asm-alpha/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-alpha/pgtable.h
--- a/include/asm-alpha/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-alpha/pgtable.h
@@ -268,6 +268,7 @@ extern inline int pte_write(pte_t pte)		
 extern inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 extern inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 extern inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
+extern inline int pte_special(pte_t pte)	{ return 0; }
 
 extern inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) |= _PAGE_FOW; return pte; }
 extern inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~(__DIRTY_BITS); return pte; }
@@ -275,6 +276,7 @@ extern inline pte_t pte_mkold(pte_t pte)
 extern inline pte_t pte_mkwrite(pte_t pte)	{ pte_val(pte) &= ~_PAGE_FOW; return pte; }
 extern inline pte_t pte_mkdirty(pte_t pte)	{ pte_val(pte) |= __DIRTY_BITS; return pte; }
 extern inline pte_t pte_mkyoung(pte_t pte)	{ pte_val(pte) |= __ACCESS_BITS; return pte; }
+extern inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
 
 #define PAGE_DIR_OFFSET(tsk,address) pgd_offset((tsk),(address))
 
diff -puN include/asm-arm/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-arm/pgtable.h
--- a/include/asm-arm/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-arm/pgtable.h
@@ -260,6 +260,7 @@ extern struct page *empty_zero_page;
 #define pte_write(pte)		(pte_val(pte) & L_PTE_WRITE)
 #define pte_dirty(pte)		(pte_val(pte) & L_PTE_DIRTY)
 #define pte_young(pte)		(pte_val(pte) & L_PTE_YOUNG)
+#define pte_special(pte)	(0)
 
 /*
  * The following only works if pte_present() is not true.
@@ -280,6 +281,8 @@ PTE_BIT_FUNC(mkdirty,   |= L_PTE_DIRTY);
 PTE_BIT_FUNC(mkold,     &= ~L_PTE_YOUNG);
 PTE_BIT_FUNC(mkyoung,   |= L_PTE_YOUNG);
 
+static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
+
 /*
  * Mark the prot value as uncacheable and unbufferable.
  */
diff -puN include/asm-avr32/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-avr32/pgtable.h
--- a/include/asm-avr32/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-avr32/pgtable.h
@@ -212,6 +212,10 @@ static inline int pte_young(pte_t pte)
 {
 	return pte_val(pte) & _PAGE_ACCESSED;
 }
+static inline int pte_special(pte_t pte)
+{
+	return 0;
+}
 
 /*
  * The following only work if pte_present() is not true.
@@ -252,6 +256,10 @@ static inline pte_t pte_mkyoung(pte_t pt
 	set_pte(&pte, __pte(pte_val(pte) | _PAGE_ACCESSED));
 	return pte;
 }
+static inline pte_t pte_mkspecial(pte_t pte)
+{
+	return pte;
+}
 
 #define pmd_none(x)	(!pmd_val(x))
 #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
diff -puN include/asm-cris/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-cris/pgtable.h
--- a/include/asm-cris/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-cris/pgtable.h
@@ -115,6 +115,7 @@ static inline int pte_write(pte_t pte)  
 static inline int pte_dirty(pte_t pte)          { return pte_val(pte) & _PAGE_MODIFIED; }
 static inline int pte_young(pte_t pte)          { return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte)           { return pte_val(pte) & _PAGE_FILE; }
+static inline int pte_special(pte_t pte)	{ return 0; }
 
 static inline pte_t pte_wrprotect(pte_t pte)
 {
@@ -162,6 +163,7 @@ static inline pte_t pte_mkyoung(pte_t pt
         }
         return pte;
 }
+static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
diff -puN include/asm-frv/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-frv/pgtable.h
--- a/include/asm-frv/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-frv/pgtable.h
@@ -380,6 +380,7 @@ static inline pmd_t *pmd_offset(pud_t *d
 static inline int pte_dirty(pte_t pte)		{ return (pte).pte & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return (pte).pte & _PAGE_ACCESSED; }
 static inline int pte_write(pte_t pte)		{ return !((pte).pte & _PAGE_WP); }
+static inline int pte_special(pte_t pte)	{ return 0; }
 
 static inline pte_t pte_mkclean(pte_t pte)	{ (pte).pte &= ~_PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkold(pte_t pte)	{ (pte).pte &= ~_PAGE_ACCESSED; return pte; }
@@ -387,6 +388,7 @@ static inline pte_t pte_wrprotect(pte_t 
 static inline pte_t pte_mkdirty(pte_t pte)	{ (pte).pte |= _PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkyoung(pte_t pte)	{ (pte).pte |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte)	{ (pte).pte &= ~_PAGE_WP; return pte; }
+static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
 
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
 {
diff -puN include/asm-ia64/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-ia64/pgtable.h
--- a/include/asm-ia64/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-ia64/pgtable.h
@@ -302,6 +302,8 @@ ia64_phys_addr_valid (unsigned long addr
 #define pte_dirty(pte)		((pte_val(pte) & _PAGE_D) != 0)
 #define pte_young(pte)		((pte_val(pte) & _PAGE_A) != 0)
 #define pte_file(pte)		((pte_val(pte) & _PAGE_FILE) != 0)
+#define pte_special(pte)	0
+
 /*
  * Note: we convert AR_RWX to AR_RX and AR_RW to AR_R by clearing the 2nd bit in the
  * access rights:
@@ -313,6 +315,7 @@ ia64_phys_addr_valid (unsigned long addr
 #define pte_mkclean(pte)	(__pte(pte_val(pte) & ~_PAGE_D))
 #define pte_mkdirty(pte)	(__pte(pte_val(pte) | _PAGE_D))
 #define pte_mkhuge(pte)		(__pte(pte_val(pte)))
+#define pte_mkspecial(pte)	(pte)
 
 /*
  * Because ia64's Icache and Dcache is not coherent (on a cpu), we need to
diff -puN include/asm-m32r/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-m32r/pgtable.h
--- a/include/asm-m32r/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-m32r/pgtable.h
@@ -214,6 +214,11 @@ static inline int pte_file(pte_t pte)
 	return pte_val(pte) & _PAGE_FILE;
 }
 
+static inline int pte_special(pte_t pte)
+{
+	return 0;
+}
+
 static inline pte_t pte_mkclean(pte_t pte)
 {
 	pte_val(pte) &= ~_PAGE_DIRTY;
@@ -250,6 +255,11 @@ static inline pte_t pte_mkwrite(pte_t pt
 	return pte;
 }
 
+static inline pte_t pte_mkspecial(pte_t pte)
+{
+	return pte;
+}
+
 static inline  int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
 {
 	return test_and_clear_bit(_PAGE_BIT_ACCESSED, ptep);
diff -puN include/asm-m68k/motorola_pgtable.h~mm-introduce-pte_special-pte-bit include/asm-m68k/motorola_pgtable.h
--- a/include/asm-m68k/motorola_pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-m68k/motorola_pgtable.h
@@ -168,6 +168,7 @@ static inline int pte_write(pte_t pte)		
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
+static inline int pte_special(pte_t pte)	{ return 0; }
 
 static inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) |= _PAGE_RONLY; return pte; }
 static inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~_PAGE_DIRTY; return pte; }
@@ -185,6 +186,7 @@ static inline pte_t pte_mkcache(pte_t pt
 	pte_val(pte) = (pte_val(pte) & _CACHEMASK040) | m68k_supervisor_cachemode;
 	return pte;
 }
+static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
 
 #define PAGE_DIR_OFFSET(tsk,address) pgd_offset((tsk),(address))
 
diff -puN include/asm-m68k/sun3_pgtable.h~mm-introduce-pte_special-pte-bit include/asm-m68k/sun3_pgtable.h
--- a/include/asm-m68k/sun3_pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-m68k/sun3_pgtable.h
@@ -169,6 +169,7 @@ static inline int pte_write(pte_t pte)		
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & SUN3_PAGE_MODIFIED; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & SUN3_PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & SUN3_PAGE_ACCESSED; }
+static inline int pte_special(pte_t pte)	{ return 0; }
 
 static inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) &= ~SUN3_PAGE_WRITEABLE; return pte; }
 static inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~SUN3_PAGE_MODIFIED; return pte; }
@@ -181,6 +182,7 @@ static inline pte_t pte_mknocache(pte_t 
 //static inline pte_t pte_mkcache(pte_t pte)	{ pte_val(pte) &= SUN3_PAGE_NOCACHE; return pte; }
 // until then, use:
 static inline pte_t pte_mkcache(pte_t pte)	{ return pte; }
+static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern pgd_t kernel_pg_dir[PTRS_PER_PGD];
diff -puN include/asm-mips/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-mips/pgtable.h
--- a/include/asm-mips/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-mips/pgtable.h
@@ -285,6 +285,8 @@ static inline pte_t pte_mkyoung(pte_t pt
 	return pte;
 }
 #endif
+static inline int pte_special(pte_t pte)	{ return 0; }
+static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
 
 /*
  * Macro to make mark a page protection value as "uncacheable".  Note
diff -puN include/asm-mn10300/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-mn10300/pgtable.h
--- a/include/asm-mn10300/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-mn10300/pgtable.h
@@ -224,6 +224,7 @@ static inline int pte_read(pte_t pte)	{ 
 static inline int pte_dirty(pte_t pte)	{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)	{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_write(pte_t pte)	{ return pte_val(pte) & __PAGE_PROT_WRITE; }
+static inline int pte_special(pte_t pte){ return 0; }
 
 /*
  * The following only works if pte_present() is not true.
@@ -265,6 +266,8 @@ static inline pte_t pte_mkwrite(pte_t pt
 	return pte;
 }
 
+static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
+
 #define pte_ERROR(e) \
 	printk(KERN_ERR "%s:%d: bad pte %08lx.\n", \
 	       __FILE__, __LINE__, pte_val(e))
diff -puN include/asm-parisc/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-parisc/pgtable.h
--- a/include/asm-parisc/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-parisc/pgtable.h
@@ -323,6 +323,7 @@ static inline int pte_dirty(pte_t pte)		
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_WRITE; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
+static inline int pte_special(pte_t pte)	{ return 0; }
 
 static inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~_PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkold(pte_t pte)	{ pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
@@ -330,6 +331,7 @@ static inline pte_t pte_wrprotect(pte_t 
 static inline pte_t pte_mkdirty(pte_t pte)	{ pte_val(pte) |= _PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkyoung(pte_t pte)	{ pte_val(pte) |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte)	{ pte_val(pte) |= _PAGE_WRITE; return pte; }
+static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
diff -puN include/asm-powerpc/pgtable-ppc32.h~mm-introduce-pte_special-pte-bit include/asm-powerpc/pgtable-ppc32.h
--- a/include/asm-powerpc/pgtable-ppc32.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-powerpc/pgtable-ppc32.h
@@ -504,6 +504,7 @@ static inline int pte_write(pte_t pte)		
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
+static inline int pte_special(pte_t pte)	{ return 0; }
 
 static inline void pte_uncache(pte_t pte)       { pte_val(pte) |= _PAGE_NO_CACHE; }
 static inline void pte_cache(pte_t pte)         { pte_val(pte) &= ~_PAGE_NO_CACHE; }
@@ -521,6 +522,8 @@ static inline pte_t pte_mkdirty(pte_t pt
 	pte_val(pte) |= _PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkyoung(pte_t pte) {
 	pte_val(pte) |= _PAGE_ACCESSED; return pte; }
+static inline pte_t pte_mkspecial(pte_t pte) {
+	return pte; }
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
diff -puN include/asm-powerpc/pgtable-ppc64.h~mm-introduce-pte_special-pte-bit include/asm-powerpc/pgtable-ppc64.h
--- a/include/asm-powerpc/pgtable-ppc64.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-powerpc/pgtable-ppc64.h
@@ -239,6 +239,7 @@ static inline int pte_write(pte_t pte) {
 static inline int pte_dirty(pte_t pte) { return pte_val(pte) & _PAGE_DIRTY;}
 static inline int pte_young(pte_t pte) { return pte_val(pte) & _PAGE_ACCESSED;}
 static inline int pte_file(pte_t pte) { return pte_val(pte) & _PAGE_FILE;}
+static inline int pte_special(pte_t pte) { return 0; }
 
 static inline void pte_uncache(pte_t pte) { pte_val(pte) |= _PAGE_NO_CACHE; }
 static inline void pte_cache(pte_t pte)   { pte_val(pte) &= ~_PAGE_NO_CACHE; }
@@ -257,6 +258,8 @@ static inline pte_t pte_mkyoung(pte_t pt
 	pte_val(pte) |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkhuge(pte_t pte) {
 	return pte; }
+static inline pte_t pte_mkspecial(pte_t pte) {
+	return pte; }
 
 /* Atomic PTE updates */
 static inline unsigned long pte_update(struct mm_struct *mm,
diff -puN include/asm-ppc/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-ppc/pgtable.h
--- a/include/asm-ppc/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-ppc/pgtable.h
@@ -483,6 +483,7 @@ static inline int pte_write(pte_t pte)		
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
+static inline int pte_special(pte_t pte)	{ return 0; }
 
 static inline void pte_uncache(pte_t pte)       { pte_val(pte) |= _PAGE_NO_CACHE; }
 static inline void pte_cache(pte_t pte)         { pte_val(pte) &= ~_PAGE_NO_CACHE; }
@@ -500,6 +501,8 @@ static inline pte_t pte_mkdirty(pte_t pt
 	pte_val(pte) |= _PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkyoung(pte_t pte) {
 	pte_val(pte) |= _PAGE_ACCESSED; return pte; }
+static inline pte_t pte_mkspecial(pte_t pte) {
+	return pte; }
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
diff -puN include/asm-s390/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-s390/pgtable.h
--- a/include/asm-s390/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-s390/pgtable.h
@@ -518,6 +518,11 @@ static inline int pte_file(pte_t pte)
 	return (pte_val(pte) & mask) == _PAGE_TYPE_FILE;
 }
 
+static inline int pte_special(pte_t pte)
+{
+	return 0;
+}
+
 #define __HAVE_ARCH_PTE_SAME
 #define pte_same(a,b)  (pte_val(a) == pte_val(b))
 
@@ -715,6 +720,11 @@ static inline pte_t pte_mkyoung(pte_t pt
 	return pte;
 }
 
+static inline pte_t pte_mkspecial(pte_t pte)
+{
+	return pte;
+}
+
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long addr, pte_t *ptep)
diff -puN include/asm-sh/pgtable_32.h~mm-introduce-pte_special-pte-bit include/asm-sh/pgtable_32.h
--- a/include/asm-sh/pgtable_32.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-sh/pgtable_32.h
@@ -326,6 +326,7 @@ static inline void set_pte(pte_t *ptep, 
 #define pte_dirty(pte)		((pte).pte_low & _PAGE_DIRTY)
 #define pte_young(pte)		((pte).pte_low & _PAGE_ACCESSED)
 #define pte_file(pte)		((pte).pte_low & _PAGE_FILE)
+#define pte_special(pte)	(0)
 
 #ifdef CONFIG_X2TLB
 #define pte_write(pte)		((pte).pte_high & _PAGE_EXT_USER_WRITE)
@@ -356,6 +357,8 @@ PTE_BIT_FUNC(low, mkdirty, |= _PAGE_DIRT
 PTE_BIT_FUNC(low, mkold, &= ~_PAGE_ACCESSED);
 PTE_BIT_FUNC(low, mkyoung, |= _PAGE_ACCESSED);
 
+static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
+
 /*
  * Macro and implementation to make a page protection as uncachable.
  */
diff -puN include/asm-sh/pgtable_64.h~mm-introduce-pte_special-pte-bit include/asm-sh/pgtable_64.h
--- a/include/asm-sh/pgtable_64.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-sh/pgtable_64.h
@@ -254,10 +254,11 @@ extern void __handle_bad_pmd_kernel(pmd_
 /*
  * The following have defined behavior only work if pte_present() is true.
  */
-static inline int pte_dirty(pte_t pte){ return pte_val(pte) & _PAGE_DIRTY; }
-static inline int pte_young(pte_t pte){ return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_file(pte_t pte) { return pte_val(pte) & _PAGE_FILE; }
-static inline int pte_write(pte_t pte){ return pte_val(pte) & _PAGE_WRITE; }
+static inline int pte_dirty(pte_t pte)  { return pte_val(pte) & _PAGE_DIRTY; }
+static inline int pte_young(pte_t pte)  { return pte_val(pte) & _PAGE_ACCESSED; }
+static inline int pte_file(pte_t pte)   { return pte_val(pte) & _PAGE_FILE; }
+static inline int pte_write(pte_t pte)  { return pte_val(pte) & _PAGE_WRITE; }
+static inline int pte_special(pte_t pte){ return 0; }
 
 static inline pte_t pte_wrprotect(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_WRITE)); return pte; }
 static inline pte_t pte_mkclean(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_DIRTY)); return pte; }
@@ -266,6 +267,7 @@ static inline pte_t pte_mkwrite(pte_t pt
 static inline pte_t pte_mkdirty(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_DIRTY)); return pte; }
 static inline pte_t pte_mkyoung(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_ACCESSED)); return pte; }
 static inline pte_t pte_mkhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_SZHUGE)); return pte; }
+static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
 
 
 /*
diff -puN include/asm-sparc/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-sparc/pgtable.h
--- a/include/asm-sparc/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-sparc/pgtable.h
@@ -219,6 +219,11 @@ static inline int pte_file(pte_t pte)
 	return pte_val(pte) & BTFIXUP_HALF(pte_filei);
 }
 
+static inline int pte_special(pte_t pte)
+{
+	return 0;
+}
+
 /*
  */
 BTFIXUPDEF_HALF(pte_wrprotecti)
@@ -251,6 +256,8 @@ BTFIXUPDEF_CALL_CONST(pte_t, pte_mkyoung
 #define pte_mkdirty(pte) BTFIXUP_CALL(pte_mkdirty)(pte)
 #define pte_mkyoung(pte) BTFIXUP_CALL(pte_mkyoung)(pte)
 
+#define pte_mkspecial(pte)    (pte)
+
 #define pfn_pte(pfn, prot)		mk_pte(pfn_to_page(pfn), prot)
 
 BTFIXUPDEF_CALL(unsigned long,	 pte_pfn, pte_t)
diff -puN include/asm-sparc64/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-sparc64/pgtable.h
--- a/include/asm-sparc64/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-sparc64/pgtable.h
@@ -506,6 +506,11 @@ static inline pte_t pte_mkyoung(pte_t pt
 	return __pte(pte_val(pte) | mask);
 }
 
+static inline pte_t pte_mkspecial(pte_t pte)
+{
+	return pte;
+}
+
 static inline unsigned long pte_young(pte_t pte)
 {
 	unsigned long mask;
@@ -608,6 +613,11 @@ static inline unsigned long pte_present(
 	return val;
 }
 
+static inline int pte_special(pte_t pte)
+{
+	return 0;
+}
+
 #define pmd_set(pmdp, ptep)	\
 	(pmd_val(*(pmdp)) = (__pa((unsigned long) (ptep)) >> 11UL))
 #define pud_set(pudp, pmdp)	\
diff -puN include/asm-um/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-um/pgtable.h
--- a/include/asm-um/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-um/pgtable.h
@@ -173,6 +173,11 @@ static inline int pte_newprot(pte_t pte)
 	return(pte_present(pte) && (pte_get_bits(pte, _PAGE_NEWPROT)));
 }
 
+static inline int pte_special(pte_t pte)
+{
+	return 0;
+}
+
 /*
  * =================================
  * Flags setting section.
@@ -241,6 +246,11 @@ static inline pte_t pte_mknewpage(pte_t 
 	return(pte);
 }
 
+static inline pte_t pte_mkspecial(pte_t pte)
+{
+	return(pte);
+}
+
 static inline void set_pte(pte_t *pteptr, pte_t pteval)
 {
 	pte_copy(*pteptr, pteval);
diff -puN include/asm-x86/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-x86/pgtable.h
@@ -195,6 +195,11 @@ static inline int pte_exec(pte_t pte)
 	return !(pte_val(pte) & _PAGE_NX);
 }
 
+static inline int pte_special(pte_t pte)
+{
+	return 0;
+}
+
 static inline int pmd_large(pmd_t pte)
 {
 	return (pmd_val(pte) & (_PAGE_PSE | _PAGE_PRESENT)) ==
@@ -256,6 +261,11 @@ static inline pte_t pte_clrglobal(pte_t 
 	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_GLOBAL);
 }
 
+static inline pte_t pte_mkspecial(pte_t pte)
+{
+	return pte;
+}
+
 extern pteval_t __supported_pte_mask;
 
 static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
diff -puN include/asm-xtensa/pgtable.h~mm-introduce-pte_special-pte-bit include/asm-xtensa/pgtable.h
--- a/include/asm-xtensa/pgtable.h~mm-introduce-pte_special-pte-bit
+++ a/include/asm-xtensa/pgtable.h
@@ -210,6 +210,8 @@ static inline int pte_write(pte_t pte) {
 static inline int pte_dirty(pte_t pte) { return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte) { return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte)  { return pte_val(pte) & _PAGE_FILE; }
+static inline int pte_special(pte_t pte) { return 0; }
+
 static inline pte_t pte_wrprotect(pte_t pte)	
 	{ pte_val(pte) &= ~(_PAGE_WRITABLE | _PAGE_HW_WRITE); return pte; }
 static inline pte_t pte_mkclean(pte_t pte)
@@ -222,6 +224,8 @@ static inline pte_t pte_mkyoung(pte_t pt
 	{ pte_val(pte) |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte)
 	{ pte_val(pte) |= _PAGE_WRITABLE; return pte; }
+static inline pte_t pte_mkspecial(pte_t pte)
+	{ return pte; }
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
diff -puN include/linux/mm.h~mm-introduce-pte_special-pte-bit include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-pte_special-pte-bit
+++ a/include/linux/mm.h
@@ -721,7 +721,9 @@ struct zap_details {
 	unsigned long truncate_count;		/* Compare vm_truncate_count */
 };
 
-struct page *vm_normal_page(struct vm_area_struct *, unsigned long, pte_t);
+struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
+		pte_t pte);
+
 unsigned long zap_page_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size, struct zap_details *);
 unsigned long unmap_vmas(struct mmu_gather **tlb,
diff -puN mm/memory.c~mm-introduce-pte_special-pte-bit mm/memory.c
--- a/mm/memory.c~mm-introduce-pte_special-pte-bit
+++ a/mm/memory.c
@@ -371,34 +371,38 @@ static inline int is_cow_mapping(unsigne
 }
 
 /*
- * This function gets the "struct page" associated with a pte or returns
- * NULL if no "struct page" is associated with the pte.
+ * vm_normal_page -- This function gets the "struct page" associated with a pte.
  *
- * A raw VM_PFNMAP mapping (ie. one that is not COWed) may not have any "struct
- * page" backing, and even if they do, they are not refcounted. COWed pages of
- * a VM_PFNMAP do always have a struct page, and they are normally refcounted
- * (they are _normal_ pages).
- *
- * So a raw PFNMAP mapping will have each page table entry just pointing
- * to a page frame number, and as far as the VM layer is concerned, those do
- * not have pages associated with them - even if the PFN might point to memory
- * that otherwise is perfectly fine and has a "struct page".
+ * "Special" mappings do not wish to be associated with a "struct page" (either
+ * it doesn't exist, or it exists but they don't want to touch it). In this
+ * case, NULL is returned here. "Normal" mappings do have a struct page.
+ *
+ * There are 2 broad cases. Firstly, an architecture may define a pte_special()
+ * pte bit, in which case this function is trivial. Secondly, an architecture
+ * may not have a spare pte bit, which requires a more complicated scheme,
+ * described below.
+ *
+ * A raw VM_PFNMAP mapping (ie. one that is not COWed) is always considered a
+ * special mapping (even if there are underlying and valid "struct pages").
+ * COWed pages of a VM_PFNMAP are always normal.
  *
  * The way we recognize COWed pages within VM_PFNMAP mappings is through the
  * rules set up by "remap_pfn_range()": the vma will have the VM_PFNMAP bit
- * set, and the vm_pgoff will point to the first PFN mapped: thus every
- * page that is a raw mapping will always honor the rule
+ * set, and the vm_pgoff will point to the first PFN mapped: thus every special
+ * mapping will always honor the rule
  *
  *	pfn_of_page == vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT)
  *
- * A call to vm_normal_page() will return NULL for such a page.
+ * And for normal mappings this is false.
  *
- * If the page doesn't follow the "remap_pfn_range()" rule in a VM_PFNMAP
- * then the page has been COW'ed.  A COW'ed page _does_ have a "struct page"
- * associated with it even if it is in a VM_PFNMAP range.  Calling
- * vm_normal_page() on such a page will therefore return the "struct page".
+ * This restricts such mappings to be a linear translation from virtual address
+ * to pfn. To get around this restriction, we allow arbitrary mappings so long
+ * as the vma is not a COW mapping; in that case, we know that all ptes are
+ * special (because none can have been COWed).
  *
  *
+ * In order to support COW of arbitrary special mappings, we have VM_MIXEDMAP.
+ *
  * VM_MIXEDMAP mappings can likewise contain memory with or without "struct
  * page" backing, however the difference is that _all_ pages with a struct
  * page (that is, those where pfn_valid is true) are refcounted and considered
@@ -407,16 +411,29 @@ static inline int is_cow_mapping(unsigne
  * advantage is that we don't have to follow the strict linearity rule of
  * PFNMAP mappings in order to support COWable mappings.
  *
- * A call to vm_normal_page() with a VM_MIXEDMAP mapping will return the
- * associated "struct page" or NULL for memory not backed by a "struct page".
- *
- *
- * All other mappings should have a valid struct page, which will be
- * returned by a call to vm_normal_page().
  */
-struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
+#ifdef __HAVE_ARCH_PTE_SPECIAL
+# define HAVE_PTE_SPECIAL 1
+#else
+# define HAVE_PTE_SPECIAL 0
+#endif
+struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
+				pte_t pte)
 {
-	unsigned long pfn = pte_pfn(pte);
+	unsigned long pfn;
+
+	if (HAVE_PTE_SPECIAL) {
+		if (likely(!pte_special(pte))) {
+			VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
+			return pte_page(pte);
+		}
+		VM_BUG_ON(!(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)));
+		return NULL;
+	}
+
+	/* !HAVE_PTE_SPECIAL case follows: */
+
+	pfn = pte_pfn(pte);
 
 	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
 		if (vma->vm_flags & VM_MIXEDMAP) {
@@ -424,7 +441,8 @@ struct page *vm_normal_page(struct vm_ar
 				return NULL;
 			goto out;
 		} else {
-			unsigned long off = (addr-vma->vm_start) >> PAGE_SHIFT;
+			unsigned long off;
+			off = (addr - vma->vm_start) >> PAGE_SHIFT;
 			if (pfn == vma->vm_pgoff + off)
 				return NULL;
 			if (!is_cow_mapping(vma->vm_flags))
@@ -432,25 +450,12 @@ struct page *vm_normal_page(struct vm_ar
 		}
 	}
 
-#ifdef CONFIG_DEBUG_VM
-	/*
-	 * Add some anal sanity checks for now. Eventually,
-	 * we should just do "return pfn_to_page(pfn)", but
-	 * in the meantime we check that we get a valid pfn,
-	 * and that the resulting page looks ok.
-	 */
-	if (unlikely(!pfn_valid(pfn))) {
-		print_bad_pte(vma, pte, addr);
-		return NULL;
-	}
-#endif
+	VM_BUG_ON(!pfn_valid(pfn));
 
 	/*
-	 * NOTE! We still have PageReserved() pages in the page 
-	 * tables. 
+	 * NOTE! We still have PageReserved() pages in the page tables.
 	 *
-	 * The PAGE_ZERO() pages and various VDSO mappings can
-	 * cause them to exist.
+	 * eg. VDSO mappings can cause them to exist.
 	 */
 out:
 	return pfn_to_page(pfn);
@@ -1263,6 +1268,12 @@ int vm_insert_pfn(struct vm_area_struct 
 	pte_t *pte, entry;
 	spinlock_t *ptl;
 
+	/*
+	 * Technically, architectures with pte_special can avoid all these
+	 * restrictions (same for remap_pfn_range).  However we would like
+	 * consistency in testing and feature parity among all, so we should
+	 * try to keep these invariants in place for everybody.
+	 */
 	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
 	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
 						(VM_PFNMAP|VM_MIXEDMAP));
@@ -1278,7 +1289,7 @@ int vm_insert_pfn(struct vm_area_struct 
 		goto out_unlock;
 
 	/* Ok, finally just insert the thing.. */
-	entry = pfn_pte(pfn, vma->vm_page_prot);
+	entry = pte_mkspecial(pfn_pte(pfn, vma->vm_page_prot));
 	set_pte_at(mm, addr, pte, entry);
 	update_mmu_cache(vma, addr, entry);
 
@@ -1309,7 +1320,7 @@ static int remap_pte_range(struct mm_str
 	arch_enter_lazy_mmu_mode();
 	do {
 		BUG_ON(!pte_none(*pte));
-		set_pte_at(mm, addr, pte, pfn_pte(pfn, prot));
+		set_pte_at(mm, addr, pte, pte_mkspecial(pfn_pte(pfn, prot)));
 		pfn++;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
git-kvm.patch
fuse-implement-perform_write.patch
reiser4.patch
reiser4-correct-references-to-filemap_nopage.patch
likeliness-accounting-change-and-cleanup.patch

