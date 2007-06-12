From: akpm@linux-foundation.org
Subject: + page-table-handling-cleanup.patch added to -mm tree
Date: Tue, 12 Jun 2007 13:23:43 -0700
Message-ID: <200706122023.l5CKNhc2020534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36872 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756792AbXFLUYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 16:24:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, andi@firstfloor.org, hch@infradead.org


The patch titled
     page table handling cleanup
has been added to the -mm tree.  Its filename is
     page-table-handling-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: page table handling cleanup
From: "Jan Beulich" <jbeulich@novell.com>

Kill pte_rdprotect(), pte_exprotect(), pte_mkread(), pte_mkexec(), pte_read(),
pte_exec(), and pte_user() except where arch-specific code is making use of
them.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/srmmu.c               |    4 ---
 arch/sparc/mm/sun4c.c               |    6 ----
 include/asm-alpha/pgtable.h         |    6 ----
 include/asm-arm/pgtable.h           |    6 ----
 include/asm-arm26/pgtable.h         |    4 ---
 include/asm-avr32/pgtable.h         |   28 ---------------------
 include/asm-cris/pgtable.h          |   30 ----------------------
 include/asm-frv/pgtable.h           |    6 ----
 include/asm-i386/pgtable-2level.h   |    8 ------
 include/asm-i386/pgtable-3level.h   |   17 -------------
 include/asm-i386/pgtable.h          |    6 ----
 include/asm-ia64/pgtable.h          |    3 --
 include/asm-m32r/pgtable.h          |   34 --------------------------
 include/asm-m68k/motorola_pgtable.h |    6 ----
 include/asm-m68k/sun3_pgtable.h     |    6 ----
 include/asm-mips/pgtable.h          |   34 --------------------------
 include/asm-parisc/pgtable.h        |    4 ---
 include/asm-powerpc/pgtable-ppc32.h |   10 -------
 include/asm-powerpc/pgtable-ppc64.h |   10 -------
 include/asm-ppc/pgtable.h           |   10 -------
 include/asm-s390/pgtable.h          |    8 ------
 include/asm-sh/pgtable.h            |   12 ---------
 include/asm-sh64/pgtable.h          |    7 -----
 include/asm-sparc/pgtable.h         |    2 -
 include/asm-sparc64/pgtable.h       |   18 -------------
 include/asm-um/pgtable.h            |   18 -------------
 include/asm-x86_64/pgtable.h        |    6 ----
 include/asm-xtensa/pgtable.h        |    3 --
 28 files changed, 1 insertion(+), 311 deletions(-)

diff -puN arch/sparc/mm/srmmu.c~page-table-handling-cleanup arch/sparc/mm/srmmu.c
--- a/arch/sparc/mm/srmmu.c~page-table-handling-cleanup
+++ a/arch/sparc/mm/srmmu.c
@@ -160,9 +160,6 @@ static inline int srmmu_pte_none(pte_t p
 static inline int srmmu_pte_present(pte_t pte)
 { return ((pte_val(pte) & SRMMU_ET_MASK) == SRMMU_ET_PTE); }
 
-static inline int srmmu_pte_read(pte_t pte)
-{ return !(pte_val(pte) & SRMMU_NOREAD); }
-
 static inline void srmmu_pte_clear(pte_t *ptep)
 { srmmu_set_pte(ptep, __pte(0)); }
 
@@ -2181,7 +2178,6 @@ void __init ld_mmu_srmmu(void)
 
 	BTFIXUPSET_CALL(pte_present, srmmu_pte_present, BTFIXUPCALL_NORM);
 	BTFIXUPSET_CALL(pte_clear, srmmu_pte_clear, BTFIXUPCALL_SWAPO0G0);
-	BTFIXUPSET_CALL(pte_read, srmmu_pte_read, BTFIXUPCALL_NORM);
 
 	BTFIXUPSET_CALL(pmd_bad, srmmu_pmd_bad, BTFIXUPCALL_NORM);
 	BTFIXUPSET_CALL(pmd_present, srmmu_pmd_present, BTFIXUPCALL_NORM);
diff -puN arch/sparc/mm/sun4c.c~page-table-handling-cleanup arch/sparc/mm/sun4c.c
--- a/arch/sparc/mm/sun4c.c~page-table-handling-cleanup
+++ a/arch/sparc/mm/sun4c.c
@@ -1748,11 +1748,6 @@ static int sun4c_pte_present(pte_t pte)
 }
 static void sun4c_pte_clear(pte_t *ptep)	{ *ptep = __pte(0); }
 
-static int sun4c_pte_read(pte_t pte)
-{
-	return (pte_val(pte) & _SUN4C_PAGE_READ);
-}
-
 static int sun4c_pmd_bad(pmd_t pmd)
 {
 	return (((pmd_val(pmd) & ~PAGE_MASK) != PGD_TABLE) ||
@@ -2212,7 +2207,6 @@ void __init ld_mmu_sun4c(void)
 
 	BTFIXUPSET_CALL(pte_present, sun4c_pte_present, BTFIXUPCALL_NORM);
 	BTFIXUPSET_CALL(pte_clear, sun4c_pte_clear, BTFIXUPCALL_STG0O0);
-	BTFIXUPSET_CALL(pte_read, sun4c_pte_read, BTFIXUPCALL_NORM);
 
 	BTFIXUPSET_CALL(pmd_bad, sun4c_pmd_bad, BTFIXUPCALL_NORM);
 	BTFIXUPSET_CALL(pmd_present, sun4c_pmd_present, BTFIXUPCALL_NORM);
diff -puN include/asm-alpha/pgtable.h~page-table-handling-cleanup include/asm-alpha/pgtable.h
--- a/include/asm-alpha/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-alpha/pgtable.h
@@ -264,21 +264,15 @@ extern inline void pgd_clear(pgd_t * pgd
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-extern inline int pte_read(pte_t pte)		{ return !(pte_val(pte) & _PAGE_FOR); }
 extern inline int pte_write(pte_t pte)		{ return !(pte_val(pte) & _PAGE_FOW); }
-extern inline int pte_exec(pte_t pte)		{ return !(pte_val(pte) & _PAGE_FOE); }
 extern inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 extern inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 extern inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
 
 extern inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) |= _PAGE_FOW; return pte; }
-extern inline pte_t pte_rdprotect(pte_t pte)	{ pte_val(pte) |= _PAGE_FOR; return pte; }
-extern inline pte_t pte_exprotect(pte_t pte)	{ pte_val(pte) |= _PAGE_FOE; return pte; }
 extern inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~(__DIRTY_BITS); return pte; }
 extern inline pte_t pte_mkold(pte_t pte)	{ pte_val(pte) &= ~(__ACCESS_BITS); return pte; }
 extern inline pte_t pte_mkwrite(pte_t pte)	{ pte_val(pte) &= ~_PAGE_FOW; return pte; }
-extern inline pte_t pte_mkread(pte_t pte)	{ pte_val(pte) &= ~_PAGE_FOR; return pte; }
-extern inline pte_t pte_mkexec(pte_t pte)	{ pte_val(pte) &= ~_PAGE_FOE; return pte; }
 extern inline pte_t pte_mkdirty(pte_t pte)	{ pte_val(pte) |= __DIRTY_BITS; return pte; }
 extern inline pte_t pte_mkyoung(pte_t pte)	{ pte_val(pte) |= __ACCESS_BITS; return pte; }
 
diff -puN include/asm-arm/pgtable.h~page-table-handling-cleanup include/asm-arm/pgtable.h
--- a/include/asm-arm/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-arm/pgtable.h
@@ -257,9 +257,7 @@ extern struct page *empty_zero_page;
  * Undefined behaviour if not..
  */
 #define pte_present(pte)	(pte_val(pte) & L_PTE_PRESENT)
-#define pte_read(pte)		(pte_val(pte) & L_PTE_USER)
 #define pte_write(pte)		(pte_val(pte) & L_PTE_WRITE)
-#define pte_exec(pte)		(pte_val(pte) & L_PTE_EXEC)
 #define pte_dirty(pte)		(pte_val(pte) & L_PTE_DIRTY)
 #define pte_young(pte)		(pte_val(pte) & L_PTE_YOUNG)
 
@@ -275,12 +273,8 @@ extern struct page *empty_zero_page;
 #define PTE_BIT_FUNC(fn,op) \
 static inline pte_t pte_##fn(pte_t pte) { pte_val(pte) op; return pte; }
 
-/*PTE_BIT_FUNC(rdprotect, &= ~L_PTE_USER);*/
-/*PTE_BIT_FUNC(mkread,    |= L_PTE_USER);*/
 PTE_BIT_FUNC(wrprotect, &= ~L_PTE_WRITE);
 PTE_BIT_FUNC(mkwrite,   |= L_PTE_WRITE);
-PTE_BIT_FUNC(exprotect, &= ~L_PTE_EXEC);
-PTE_BIT_FUNC(mkexec,    |= L_PTE_EXEC);
 PTE_BIT_FUNC(mkclean,   &= ~L_PTE_DIRTY);
 PTE_BIT_FUNC(mkdirty,   |= L_PTE_DIRTY);
 PTE_BIT_FUNC(mkold,     &= ~L_PTE_YOUNG);
diff -puN include/asm-arm26/pgtable.h~page-table-handling-cleanup include/asm-arm26/pgtable.h
--- a/include/asm-arm26/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-arm26/pgtable.h
@@ -218,9 +218,7 @@ extern struct page *empty_zero_page;
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-#define pte_read(pte)                   (!(pte_val(pte) & _PAGE_NOT_USER))
 #define pte_write(pte)                  (!(pte_val(pte) & _PAGE_READONLY))
-#define pte_exec(pte)                   (!(pte_val(pte) & _PAGE_NOT_USER))
 #define pte_dirty(pte)                  (!(pte_val(pte) & _PAGE_CLEAN))
 #define pte_young(pte)                  (!(pte_val(pte) & _PAGE_OLD))
 //ONLY when !pte_present() I think. nicked from arm32 (FIXME!)
@@ -231,8 +229,6 @@ static inline pte_t pte_##fn(pte_t pte) 
 
 PTE_BIT_FUNC(wrprotect, |=  _PAGE_READONLY);
 PTE_BIT_FUNC(mkwrite,   &= ~_PAGE_READONLY);
-PTE_BIT_FUNC(exprotect, |=  _PAGE_NOT_USER);
-PTE_BIT_FUNC(mkexec,    &= ~_PAGE_NOT_USER);
 PTE_BIT_FUNC(mkclean,   |=  _PAGE_CLEAN);
 PTE_BIT_FUNC(mkdirty,   &= ~_PAGE_CLEAN);
 PTE_BIT_FUNC(mkold,     |=  _PAGE_OLD);
diff -puN include/asm-avr32/pgtable.h~page-table-handling-cleanup include/asm-avr32/pgtable.h
--- a/include/asm-avr32/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-avr32/pgtable.h
@@ -201,18 +201,10 @@ extern struct page *empty_zero_page;
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-static inline int pte_read(pte_t pte)
-{
-	return pte_val(pte) & _PAGE_USER;
-}
 static inline int pte_write(pte_t pte)
 {
 	return pte_val(pte) & _PAGE_RW;
 }
-static inline int pte_exec(pte_t pte)
-{
-	return pte_val(pte) & _PAGE_EXECUTE;
-}
 static inline int pte_dirty(pte_t pte)
 {
 	return pte_val(pte) & _PAGE_DIRTY;
@@ -231,21 +223,11 @@ static inline int pte_file(pte_t pte)
 }
 
 /* Mutator functions for PTE bits */
-static inline pte_t pte_rdprotect(pte_t pte)
-{
-	set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_USER));
-	return pte;
-}
 static inline pte_t pte_wrprotect(pte_t pte)
 {
 	set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_RW));
 	return pte;
 }
-static inline pte_t pte_exprotect(pte_t pte)
-{
-	set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_EXECUTE));
-	return pte;
-}
 static inline pte_t pte_mkclean(pte_t pte)
 {
 	set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_DIRTY));
@@ -256,21 +238,11 @@ static inline pte_t pte_mkold(pte_t pte)
 	set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_ACCESSED));
 	return pte;
 }
-static inline pte_t pte_mkread(pte_t pte)
-{
-	set_pte(&pte, __pte(pte_val(pte) | _PAGE_USER));
-	return pte;
-}
 static inline pte_t pte_mkwrite(pte_t pte)
 {
 	set_pte(&pte, __pte(pte_val(pte) | _PAGE_RW));
 	return pte;
 }
-static inline pte_t pte_mkexec(pte_t pte)
-{
-	set_pte(&pte, __pte(pte_val(pte) | _PAGE_EXECUTE));
-	return pte;
-}
 static inline pte_t pte_mkdirty(pte_t pte)
 {
 	set_pte(&pte, __pte(pte_val(pte) | _PAGE_DIRTY));
diff -puN include/asm-cris/pgtable.h~page-table-handling-cleanup include/asm-cris/pgtable.h
--- a/include/asm-cris/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-cris/pgtable.h
@@ -111,9 +111,7 @@ extern unsigned long empty_zero_page;
  * Undefined behaviour if not..
  */
 
-static inline int pte_read(pte_t pte)           { return pte_val(pte) & _PAGE_READ; }
 static inline int pte_write(pte_t pte)          { return pte_val(pte) & _PAGE_WRITE; }
-static inline int pte_exec(pte_t pte)           { return pte_val(pte) & _PAGE_READ; }
 static inline int pte_dirty(pte_t pte)          { return pte_val(pte) & _PAGE_MODIFIED; }
 static inline int pte_young(pte_t pte)          { return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte)           { return pte_val(pte) & _PAGE_FILE; }
@@ -124,18 +122,6 @@ static inline pte_t pte_wrprotect(pte_t 
         return pte;
 }
 
-static inline pte_t pte_rdprotect(pte_t pte)
-{
-        pte_val(pte) &= ~(_PAGE_READ | _PAGE_SILENT_READ);
-	return pte;
-}
-
-static inline pte_t pte_exprotect(pte_t pte)
-{
-        pte_val(pte) &= ~(_PAGE_READ | _PAGE_SILENT_READ);
-	return pte;
-}
-
 static inline pte_t pte_mkclean(pte_t pte)
 {
 	pte_val(pte) &= ~(_PAGE_MODIFIED | _PAGE_SILENT_WRITE); 
@@ -156,22 +142,6 @@ static inline pte_t pte_mkwrite(pte_t pt
         return pte;
 }
 
-static inline pte_t pte_mkread(pte_t pte)
-{
-        pte_val(pte) |= _PAGE_READ;
-        if (pte_val(pte) & _PAGE_ACCESSED)
-                pte_val(pte) |= _PAGE_SILENT_READ;
-        return pte;
-}
-
-static inline pte_t pte_mkexec(pte_t pte)
-{
-        pte_val(pte) |= _PAGE_READ;
-        if (pte_val(pte) & _PAGE_ACCESSED)
-                pte_val(pte) |= _PAGE_SILENT_READ;
-        return pte;
-}
-
 static inline pte_t pte_mkdirty(pte_t pte)
 {
         pte_val(pte) |= _PAGE_MODIFIED;
diff -puN include/asm-frv/pgtable.h~page-table-handling-cleanup include/asm-frv/pgtable.h
--- a/include/asm-frv/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-frv/pgtable.h
@@ -377,19 +377,13 @@ static inline pmd_t *pmd_offset(pud_t *d
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-static inline int pte_read(pte_t pte)		{ return !((pte).pte & _PAGE_SUPER); }
-static inline int pte_exec(pte_t pte)		{ return !((pte).pte & _PAGE_SUPER); }
 static inline int pte_dirty(pte_t pte)		{ return (pte).pte & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return (pte).pte & _PAGE_ACCESSED; }
 static inline int pte_write(pte_t pte)		{ return !((pte).pte & _PAGE_WP); }
 
-static inline pte_t pte_rdprotect(pte_t pte)	{ (pte).pte |= _PAGE_SUPER; return pte; }
-static inline pte_t pte_exprotect(pte_t pte)	{ (pte).pte |= _PAGE_SUPER; return pte; }
 static inline pte_t pte_mkclean(pte_t pte)	{ (pte).pte &= ~_PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkold(pte_t pte)	{ (pte).pte &= ~_PAGE_ACCESSED; return pte; }
 static inline pte_t pte_wrprotect(pte_t pte)	{ (pte).pte |= _PAGE_WP; return pte; }
-static inline pte_t pte_mkread(pte_t pte)	{ (pte).pte &= ~_PAGE_SUPER; return pte; }
-static inline pte_t pte_mkexec(pte_t pte)	{ (pte).pte &= ~_PAGE_SUPER; return pte; }
 static inline pte_t pte_mkdirty(pte_t pte)	{ (pte).pte |= _PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkyoung(pte_t pte)	{ (pte).pte |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte)	{ (pte).pte &= ~_PAGE_WP; return pte; }
diff -puN include/asm-i386/pgtable-2level.h~page-table-handling-cleanup include/asm-i386/pgtable-2level.h
--- a/include/asm-i386/pgtable-2level.h~page-table-handling-cleanup
+++ a/include/asm-i386/pgtable-2level.h
@@ -57,14 +57,6 @@ static inline pte_t native_ptep_get_and_
 #define pfn_pmd(pfn, prot)	__pmd(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
 /*
- * All present user pages are user-executable:
- */
-static inline int pte_exec(pte_t pte)
-{
-	return pte_user(pte);
-}
-
-/*
  * All present pages are kernel-executable:
  */
 static inline int pte_exec_kernel(pte_t pte)
diff -puN include/asm-i386/pgtable-3level.h~page-table-handling-cleanup include/asm-i386/pgtable-3level.h
--- a/include/asm-i386/pgtable-3level.h~page-table-handling-cleanup
+++ a/include/asm-i386/pgtable-3level.h
@@ -20,26 +20,11 @@
 #define pud_present(pud)			1
 
 /*
- * Is the pte executable?
- */
-static inline int pte_x(pte_t pte)
-{
-	return !(pte_val(pte) & _PAGE_NX);
-}
-
-/*
- * All present user-pages with !NX bit are user-executable:
- */
-static inline int pte_exec(pte_t pte)
-{
-	return pte_user(pte) && pte_x(pte);
-}
-/*
  * All present pages with !NX bit are kernel-executable:
  */
 static inline int pte_exec_kernel(pte_t pte)
 {
-	return pte_x(pte);
+	return !(pte_val(pte) & _PAGE_NX);
 }
 
 /* Rules for using set_pte: the pte being assigned *must* be
diff -puN include/asm-i386/pgtable.h~page-table-handling-cleanup include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-i386/pgtable.h
@@ -220,8 +220,6 @@ extern unsigned long pg0[];
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-static inline int pte_user(pte_t pte)		{ return (pte).pte_low & _PAGE_USER; }
-static inline int pte_read(pte_t pte)		{ return (pte).pte_low & _PAGE_USER; }
 static inline int pte_dirty(pte_t pte)		{ return (pte).pte_low & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return (pte).pte_low & _PAGE_ACCESSED; }
 static inline int pte_write(pte_t pte)		{ return (pte).pte_low & _PAGE_RW; }
@@ -232,13 +230,9 @@ static inline int pte_huge(pte_t pte)		{
  */
 static inline int pte_file(pte_t pte)		{ return (pte).pte_low & _PAGE_FILE; }
 
-static inline pte_t pte_rdprotect(pte_t pte)	{ (pte).pte_low &= ~_PAGE_USER; return pte; }
-static inline pte_t pte_exprotect(pte_t pte)	{ (pte).pte_low &= ~_PAGE_USER; return pte; }
 static inline pte_t pte_mkclean(pte_t pte)	{ (pte).pte_low &= ~_PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkold(pte_t pte)	{ (pte).pte_low &= ~_PAGE_ACCESSED; return pte; }
 static inline pte_t pte_wrprotect(pte_t pte)	{ (pte).pte_low &= ~_PAGE_RW; return pte; }
-static inline pte_t pte_mkread(pte_t pte)	{ (pte).pte_low |= _PAGE_USER; return pte; }
-static inline pte_t pte_mkexec(pte_t pte)	{ (pte).pte_low |= _PAGE_USER; return pte; }
 static inline pte_t pte_mkdirty(pte_t pte)	{ (pte).pte_low |= _PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkyoung(pte_t pte)	{ (pte).pte_low |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte)	{ (pte).pte_low |= _PAGE_RW; return pte; }
diff -puN include/asm-ia64/pgtable.h~page-table-handling-cleanup include/asm-ia64/pgtable.h
--- a/include/asm-ia64/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-ia64/pgtable.h
@@ -297,8 +297,6 @@ ia64_phys_addr_valid (unsigned long addr
 /*
  * The following have defined behavior only work if pte_present() is true.
  */
-#define pte_user(pte)		((pte_val(pte) & _PAGE_PL_MASK) == _PAGE_PL_3)
-#define pte_read(pte)		(((pte_val(pte) & _PAGE_AR_MASK) >> _PAGE_AR_SHIFT) < 6)
 #define pte_write(pte)	((unsigned) (((pte_val(pte) & _PAGE_AR_MASK) >> _PAGE_AR_SHIFT) - 2) <= 4)
 #define pte_exec(pte)		((pte_val(pte) & _PAGE_AR_RX) != 0)
 #define pte_dirty(pte)		((pte_val(pte) & _PAGE_D) != 0)
@@ -310,7 +308,6 @@ ia64_phys_addr_valid (unsigned long addr
  */
 #define pte_wrprotect(pte)	(__pte(pte_val(pte) & ~_PAGE_AR_RW))
 #define pte_mkwrite(pte)	(__pte(pte_val(pte) | _PAGE_AR_RW))
-#define pte_mkexec(pte)		(__pte(pte_val(pte) | _PAGE_AR_RX))
 #define pte_mkold(pte)		(__pte(pte_val(pte) & ~_PAGE_A))
 #define pte_mkyoung(pte)	(__pte(pte_val(pte) | _PAGE_A))
 #define pte_mkclean(pte)	(__pte(pte_val(pte) & ~_PAGE_D))
diff -puN include/asm-m32r/pgtable.h~page-table-handling-cleanup include/asm-m32r/pgtable.h
--- a/include/asm-m32r/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-m32r/pgtable.h
@@ -191,16 +191,6 @@ extern unsigned long empty_zero_page[102
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-static inline int pte_read(pte_t pte)
-{
-	return pte_val(pte) & _PAGE_READ;
-}
-
-static inline int pte_exec(pte_t pte)
-{
-	return pte_val(pte) & _PAGE_EXEC;
-}
-
 static inline int pte_dirty(pte_t pte)
 {
 	return pte_val(pte) & _PAGE_DIRTY;
@@ -224,18 +214,6 @@ static inline int pte_file(pte_t pte)
 	return pte_val(pte) & _PAGE_FILE;
 }
 
-static inline pte_t pte_rdprotect(pte_t pte)
-{
-	pte_val(pte) &= ~_PAGE_READ;
-	return pte;
-}
-
-static inline pte_t pte_exprotect(pte_t pte)
-{
-	pte_val(pte) &= ~_PAGE_EXEC;
-	return pte;
-}
-
 static inline pte_t pte_mkclean(pte_t pte)
 {
 	pte_val(pte) &= ~_PAGE_DIRTY;
@@ -254,18 +232,6 @@ static inline pte_t pte_wrprotect(pte_t 
 	return pte;
 }
 
-static inline pte_t pte_mkread(pte_t pte)
-{
-	pte_val(pte) |= _PAGE_READ;
-	return pte;
-}
-
-static inline pte_t pte_mkexec(pte_t pte)
-{
-	pte_val(pte) |= _PAGE_EXEC;
-	return pte;
-}
-
 static inline pte_t pte_mkdirty(pte_t pte)
 {
 	pte_val(pte) |= _PAGE_DIRTY;
diff -puN include/asm-m68k/motorola_pgtable.h~page-table-handling-cleanup include/asm-m68k/motorola_pgtable.h
--- a/include/asm-m68k/motorola_pgtable.h~page-table-handling-cleanup
+++ a/include/asm-m68k/motorola_pgtable.h
@@ -164,21 +164,15 @@ static inline void pgd_set(pgd_t *pgdp, 
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-static inline int pte_read(pte_t pte)		{ return 1; }
 static inline int pte_write(pte_t pte)		{ return !(pte_val(pte) & _PAGE_RONLY); }
-static inline int pte_exec(pte_t pte)		{ return 1; }
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
 
 static inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) |= _PAGE_RONLY; return pte; }
-static inline pte_t pte_rdprotect(pte_t pte)	{ return pte; }
-static inline pte_t pte_exprotect(pte_t pte)	{ return pte; }
 static inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~_PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkold(pte_t pte)	{ pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte)	{ pte_val(pte) &= ~_PAGE_RONLY; return pte; }
-static inline pte_t pte_mkread(pte_t pte)	{ return pte; }
-static inline pte_t pte_mkexec(pte_t pte)	{ return pte; }
 static inline pte_t pte_mkdirty(pte_t pte)	{ pte_val(pte) |= _PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkyoung(pte_t pte)	{ pte_val(pte) |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mknocache(pte_t pte)
diff -puN include/asm-m68k/sun3_pgtable.h~page-table-handling-cleanup include/asm-m68k/sun3_pgtable.h
--- a/include/asm-m68k/sun3_pgtable.h~page-table-handling-cleanup
+++ a/include/asm-m68k/sun3_pgtable.h
@@ -165,21 +165,15 @@ static inline void pgd_clear (pgd_t *pgd
  * Undefined behaviour if not...
  * [we have the full set here even if they don't change from m68k]
  */
-static inline int pte_read(pte_t pte)		{ return 1; }
 static inline int pte_write(pte_t pte)		{ return pte_val(pte) & SUN3_PAGE_WRITEABLE; }
-static inline int pte_exec(pte_t pte)		{ return 1; }
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & SUN3_PAGE_MODIFIED; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & SUN3_PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & SUN3_PAGE_ACCESSED; }
 
 static inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) &= ~SUN3_PAGE_WRITEABLE; return pte; }
-static inline pte_t pte_rdprotect(pte_t pte)	{ return pte; }
-static inline pte_t pte_exprotect(pte_t pte)	{ return pte; }
 static inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~SUN3_PAGE_MODIFIED; return pte; }
 static inline pte_t pte_mkold(pte_t pte)	{ pte_val(pte) &= ~SUN3_PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte)	{ pte_val(pte) |= SUN3_PAGE_WRITEABLE; return pte; }
-static inline pte_t pte_mkread(pte_t pte)	{ return pte; }
-static inline pte_t pte_mkexec(pte_t pte)	{ return pte; }
 static inline pte_t pte_mkdirty(pte_t pte)	{ pte_val(pte) |= SUN3_PAGE_MODIFIED; return pte; }
 static inline pte_t pte_mkyoung(pte_t pte)	{ pte_val(pte) |= SUN3_PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mknocache(pte_t pte)	{ pte_val(pte) |= SUN3_PAGE_NOCACHE; return pte; }
diff -puN include/asm-mips/pgtable.h~page-table-handling-cleanup include/asm-mips/pgtable.h
--- a/include/asm-mips/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-mips/pgtable.h
@@ -178,9 +178,7 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-static inline int pte_user(pte_t pte)	{ BUG(); return 0; }
 #if defined(CONFIG_64BIT_PHYS_ADDR) && defined(CONFIG_CPU_MIPS32_R1)
-static inline int pte_read(pte_t pte)	{ return pte.pte_low & _PAGE_READ; }
 static inline int pte_write(pte_t pte)	{ return pte.pte_low & _PAGE_WRITE; }
 static inline int pte_dirty(pte_t pte)	{ return pte.pte_low & _PAGE_MODIFIED; }
 static inline int pte_young(pte_t pte)	{ return pte.pte_low & _PAGE_ACCESSED; }
@@ -193,13 +191,6 @@ static inline pte_t pte_wrprotect(pte_t 
 	return pte;
 }
 
-static inline pte_t pte_rdprotect(pte_t pte)
-{
-	pte.pte_low  &= ~(_PAGE_READ | _PAGE_SILENT_READ);
-	pte.pte_high &= ~_PAGE_SILENT_READ;
-	return pte;
-}
-
 static inline pte_t pte_mkclean(pte_t pte)
 {
 	pte.pte_low  &= ~(_PAGE_MODIFIED | _PAGE_SILENT_WRITE);
@@ -224,16 +215,6 @@ static inline pte_t pte_mkwrite(pte_t pt
 	return pte;
 }
 
-static inline pte_t pte_mkread(pte_t pte)
-{
-	pte.pte_low |= _PAGE_READ;
-	if (pte.pte_low & _PAGE_ACCESSED) {
-		pte.pte_low  |= _PAGE_SILENT_READ;
-		pte.pte_high |= _PAGE_SILENT_READ;
-	}
-	return pte;
-}
-
 static inline pte_t pte_mkdirty(pte_t pte)
 {
 	pte.pte_low |= _PAGE_MODIFIED;
@@ -253,7 +234,6 @@ static inline pte_t pte_mkyoung(pte_t pt
 	return pte;
 }
 #else
-static inline int pte_read(pte_t pte)	{ return pte_val(pte) & _PAGE_READ; }
 static inline int pte_write(pte_t pte)	{ return pte_val(pte) & _PAGE_WRITE; }
 static inline int pte_dirty(pte_t pte)	{ return pte_val(pte) & _PAGE_MODIFIED; }
 static inline int pte_young(pte_t pte)	{ return pte_val(pte) & _PAGE_ACCESSED; }
@@ -265,12 +245,6 @@ static inline pte_t pte_wrprotect(pte_t 
 	return pte;
 }
 
-static inline pte_t pte_rdprotect(pte_t pte)
-{
-	pte_val(pte) &= ~(_PAGE_READ | _PAGE_SILENT_READ);
-	return pte;
-}
-
 static inline pte_t pte_mkclean(pte_t pte)
 {
 	pte_val(pte) &= ~(_PAGE_MODIFIED|_PAGE_SILENT_WRITE);
@@ -291,14 +265,6 @@ static inline pte_t pte_mkwrite(pte_t pt
 	return pte;
 }
 
-static inline pte_t pte_mkread(pte_t pte)
-{
-	pte_val(pte) |= _PAGE_READ;
-	if (pte_val(pte) & _PAGE_ACCESSED)
-		pte_val(pte) |= _PAGE_SILENT_READ;
-	return pte;
-}
-
 static inline pte_t pte_mkdirty(pte_t pte)
 {
 	pte_val(pte) |= _PAGE_MODIFIED;
diff -puN include/asm-parisc/pgtable.h~page-table-handling-cleanup include/asm-parisc/pgtable.h
--- a/include/asm-parisc/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-parisc/pgtable.h
@@ -335,18 +335,14 @@ extern inline void pgd_clear(pgd_t * pgd
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-extern inline int pte_read(pte_t pte)		{ return pte_val(pte) & _PAGE_READ; }
 extern inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 extern inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 extern inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_WRITE; }
 extern inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
-extern inline int pte_user(pte_t pte) 		{ return pte_val(pte) & _PAGE_USER; }
 
-extern inline pte_t pte_rdprotect(pte_t pte)	{ pte_val(pte) &= ~_PAGE_READ; return pte; }
 extern inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~_PAGE_DIRTY; return pte; }
 extern inline pte_t pte_mkold(pte_t pte)	{ pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
 extern inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) &= ~_PAGE_WRITE; return pte; }
-extern inline pte_t pte_mkread(pte_t pte)	{ pte_val(pte) |= _PAGE_READ; return pte; }
 extern inline pte_t pte_mkdirty(pte_t pte)	{ pte_val(pte) |= _PAGE_DIRTY; return pte; }
 extern inline pte_t pte_mkyoung(pte_t pte)	{ pte_val(pte) |= _PAGE_ACCESSED; return pte; }
 extern inline pte_t pte_mkwrite(pte_t pte)	{ pte_val(pte) |= _PAGE_WRITE; return pte; }
diff -puN include/asm-powerpc/pgtable-ppc32.h~page-table-handling-cleanup include/asm-powerpc/pgtable-ppc32.h
--- a/include/asm-powerpc/pgtable-ppc32.h~page-table-handling-cleanup
+++ a/include/asm-powerpc/pgtable-ppc32.h
@@ -512,9 +512,7 @@ extern unsigned long empty_zero_page[102
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-static inline int pte_read(pte_t pte)		{ return pte_val(pte) & _PAGE_USER; }
 static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_RW; }
-static inline int pte_exec(pte_t pte)		{ return pte_val(pte) & _PAGE_EXEC; }
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
@@ -522,21 +520,13 @@ static inline int pte_file(pte_t pte)		{
 static inline void pte_uncache(pte_t pte)       { pte_val(pte) |= _PAGE_NO_CACHE; }
 static inline void pte_cache(pte_t pte)         { pte_val(pte) &= ~_PAGE_NO_CACHE; }
 
-static inline pte_t pte_rdprotect(pte_t pte) {
-	pte_val(pte) &= ~_PAGE_USER; return pte; }
 static inline pte_t pte_wrprotect(pte_t pte) {
 	pte_val(pte) &= ~(_PAGE_RW | _PAGE_HWWRITE); return pte; }
-static inline pte_t pte_exprotect(pte_t pte) {
-	pte_val(pte) &= ~_PAGE_EXEC; return pte; }
 static inline pte_t pte_mkclean(pte_t pte) {
 	pte_val(pte) &= ~(_PAGE_DIRTY | _PAGE_HWWRITE); return pte; }
 static inline pte_t pte_mkold(pte_t pte) {
 	pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
 
-static inline pte_t pte_mkread(pte_t pte) {
-	pte_val(pte) |= _PAGE_USER; return pte; }
-static inline pte_t pte_mkexec(pte_t pte) {
-	pte_val(pte) |= _PAGE_USER | _PAGE_EXEC; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte) {
 	pte_val(pte) |= _PAGE_RW; return pte; }
 static inline pte_t pte_mkdirty(pte_t pte) {
diff -puN include/asm-powerpc/pgtable-ppc64.h~page-table-handling-cleanup include/asm-powerpc/pgtable-ppc64.h
--- a/include/asm-powerpc/pgtable-ppc64.h~page-table-handling-cleanup
+++ a/include/asm-powerpc/pgtable-ppc64.h
@@ -232,9 +232,7 @@ static inline pte_t pfn_pte(unsigned lon
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-static inline int pte_read(pte_t pte)  { return pte_val(pte) & _PAGE_USER;}
 static inline int pte_write(pte_t pte) { return pte_val(pte) & _PAGE_RW;}
-static inline int pte_exec(pte_t pte)  { return pte_val(pte) & _PAGE_EXEC;}
 static inline int pte_dirty(pte_t pte) { return pte_val(pte) & _PAGE_DIRTY;}
 static inline int pte_young(pte_t pte) { return pte_val(pte) & _PAGE_ACCESSED;}
 static inline int pte_file(pte_t pte) { return pte_val(pte) & _PAGE_FILE;}
@@ -242,20 +240,12 @@ static inline int pte_file(pte_t pte) { 
 static inline void pte_uncache(pte_t pte) { pte_val(pte) |= _PAGE_NO_CACHE; }
 static inline void pte_cache(pte_t pte)   { pte_val(pte) &= ~_PAGE_NO_CACHE; }
 
-static inline pte_t pte_rdprotect(pte_t pte) {
-	pte_val(pte) &= ~_PAGE_USER; return pte; }
-static inline pte_t pte_exprotect(pte_t pte) {
-	pte_val(pte) &= ~_PAGE_EXEC; return pte; }
 static inline pte_t pte_wrprotect(pte_t pte) {
 	pte_val(pte) &= ~(_PAGE_RW); return pte; }
 static inline pte_t pte_mkclean(pte_t pte) {
 	pte_val(pte) &= ~(_PAGE_DIRTY); return pte; }
 static inline pte_t pte_mkold(pte_t pte) {
 	pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
-static inline pte_t pte_mkread(pte_t pte) {
-	pte_val(pte) |= _PAGE_USER; return pte; }
-static inline pte_t pte_mkexec(pte_t pte) {
-	pte_val(pte) |= _PAGE_USER | _PAGE_EXEC; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte) {
 	pte_val(pte) |= _PAGE_RW; return pte; }
 static inline pte_t pte_mkdirty(pte_t pte) {
diff -puN include/asm-ppc/pgtable.h~page-table-handling-cleanup include/asm-ppc/pgtable.h
--- a/include/asm-ppc/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-ppc/pgtable.h
@@ -533,9 +533,7 @@ static inline int pgd_present(pgd_t pgd)
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-static inline int pte_read(pte_t pte)		{ return pte_val(pte) & _PAGE_USER; }
 static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_RW; }
-static inline int pte_exec(pte_t pte)		{ return pte_val(pte) & _PAGE_EXEC; }
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
@@ -543,21 +541,13 @@ static inline int pte_file(pte_t pte)		{
 static inline void pte_uncache(pte_t pte)       { pte_val(pte) |= _PAGE_NO_CACHE; }
 static inline void pte_cache(pte_t pte)         { pte_val(pte) &= ~_PAGE_NO_CACHE; }
 
-static inline pte_t pte_rdprotect(pte_t pte) {
-	pte_val(pte) &= ~_PAGE_USER; return pte; }
 static inline pte_t pte_wrprotect(pte_t pte) {
 	pte_val(pte) &= ~(_PAGE_RW | _PAGE_HWWRITE); return pte; }
-static inline pte_t pte_exprotect(pte_t pte) {
-	pte_val(pte) &= ~_PAGE_EXEC; return pte; }
 static inline pte_t pte_mkclean(pte_t pte) {
 	pte_val(pte) &= ~(_PAGE_DIRTY | _PAGE_HWWRITE); return pte; }
 static inline pte_t pte_mkold(pte_t pte) {
 	pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
 
-static inline pte_t pte_mkread(pte_t pte) {
-	pte_val(pte) |= _PAGE_USER; return pte; }
-static inline pte_t pte_mkexec(pte_t pte) {
-	pte_val(pte) |= _PAGE_USER | _PAGE_EXEC; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte) {
 	pte_val(pte) |= _PAGE_RW; return pte; }
 static inline pte_t pte_mkdirty(pte_t pte) {
diff -puN include/asm-s390/pgtable.h~page-table-handling-cleanup include/asm-s390/pgtable.h
--- a/include/asm-s390/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-s390/pgtable.h
@@ -530,14 +530,6 @@ static inline int pte_young(pte_t pte)
 	return 0;
 }
 
-static inline int pte_read(pte_t pte)
-{
-	/* All pages are readable since we don't use the fetch
-	 * protection bit in the storage key.
-	 */
-	return 1;
-}
-
 /*
  * pgd/pmd/pte modification functions
  */
diff -puN include/asm-sh/pgtable.h~page-table-handling-cleanup include/asm-sh/pgtable.h
--- a/include/asm-sh/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-sh/pgtable.h
@@ -402,12 +402,8 @@ static inline void set_pte(pte_t *ptep, 
 #define pte_file(pte)		(pte_val(pte) & _PAGE_FILE)
 
 #ifdef CONFIG_X2TLB
-#define pte_read(pte)		((pte).pte_high & _PAGE_EXT_USER_READ)
-#define pte_exec(pte)		((pte).pte_high & _PAGE_EXT_USER_EXEC)
 #define pte_write(pte)		((pte).pte_high & _PAGE_EXT_USER_WRITE)
 #else
-#define pte_read(pte)		(pte_val(pte) & _PAGE_USER)
-#define pte_exec(pte)		(pte_val(pte) & _PAGE_USER)
 #define pte_write(pte)		(pte_val(pte) & _PAGE_RW)
 #endif
 
@@ -420,20 +416,12 @@ static inline pte_t pte_##fn(pte_t pte) 
  * individually toggled (and user permissions are entirely decoupled from
  * kernel permissions), we attempt to couple them a bit more sanely here.
  */
-PTE_BIT_FUNC(high, rdprotect, &= ~_PAGE_EXT_USER_READ);
-PTE_BIT_FUNC(high, mkread, |= _PAGE_EXT_USER_READ | _PAGE_EXT_KERN_READ);
 PTE_BIT_FUNC(high, wrprotect, &= ~_PAGE_EXT_USER_WRITE);
 PTE_BIT_FUNC(high, mkwrite, |= _PAGE_EXT_USER_WRITE | _PAGE_EXT_KERN_WRITE);
-PTE_BIT_FUNC(high, exprotect, &= ~_PAGE_EXT_USER_EXEC);
-PTE_BIT_FUNC(high, mkexec, |= _PAGE_EXT_USER_EXEC | _PAGE_EXT_KERN_EXEC);
 PTE_BIT_FUNC(high, mkhuge, |= _PAGE_SZHUGE);
 #else
-PTE_BIT_FUNC(low, rdprotect, &= ~_PAGE_USER);
-PTE_BIT_FUNC(low, mkread, |= _PAGE_USER);
 PTE_BIT_FUNC(low, wrprotect, &= ~_PAGE_RW);
 PTE_BIT_FUNC(low, mkwrite, |= _PAGE_RW);
-PTE_BIT_FUNC(low, exprotect, &= ~_PAGE_USER);
-PTE_BIT_FUNC(low, mkexec, |= _PAGE_USER);
 PTE_BIT_FUNC(low, mkhuge, |= _PAGE_SZHUGE);
 #endif
 
diff -puN include/asm-sh64/pgtable.h~page-table-handling-cleanup include/asm-sh64/pgtable.h
--- a/include/asm-sh64/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-sh64/pgtable.h
@@ -415,22 +415,15 @@ extern void __handle_bad_pmd_kernel(pmd_
 /*
  * The following have defined behavior only work if pte_present() is true.
  */
-static inline int pte_read(pte_t pte) { return pte_val(pte) & _PAGE_READ; }
-static inline int pte_exec(pte_t pte) { return pte_val(pte) & _PAGE_EXECUTE; }
 static inline int pte_dirty(pte_t pte){ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte){ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte) { return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_write(pte_t pte){ return pte_val(pte) & _PAGE_WRITE; }
 
-static inline pte_t pte_rdprotect(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_READ)); return pte; }
 static inline pte_t pte_wrprotect(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_WRITE)); return pte; }
-static inline pte_t pte_exprotect(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_EXECUTE)); return pte; }
 static inline pte_t pte_mkclean(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_DIRTY)); return pte; }
 static inline pte_t pte_mkold(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_ACCESSED)); return pte; }
-
-static inline pte_t pte_mkread(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_READ)); return pte; }
 static inline pte_t pte_mkwrite(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_WRITE)); return pte; }
-static inline pte_t pte_mkexec(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_EXECUTE)); return pte; }
 static inline pte_t pte_mkdirty(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_DIRTY)); return pte; }
 static inline pte_t pte_mkyoung(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_ACCESSED)); return pte; }
 static inline pte_t pte_mkhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_SZHUGE)); return pte; }
diff -puN include/asm-sparc/pgtable.h~page-table-handling-cleanup include/asm-sparc/pgtable.h
--- a/include/asm-sparc/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-sparc/pgtable.h
@@ -151,7 +151,6 @@ BTFIXUPDEF_CALL_CONST(unsigned long, pgd
 BTFIXUPDEF_SETHI(none_mask)
 BTFIXUPDEF_CALL_CONST(int, pte_present, pte_t)
 BTFIXUPDEF_CALL(void, pte_clear, pte_t *)
-BTFIXUPDEF_CALL(int, pte_read, pte_t)
 
 static inline int pte_none(pte_t pte)
 {
@@ -160,7 +159,6 @@ static inline int pte_none(pte_t pte)
 
 #define pte_present(pte) BTFIXUP_CALL(pte_present)(pte)
 #define pte_clear(mm,addr,pte) BTFIXUP_CALL(pte_clear)(pte)
-#define pte_read(pte) BTFIXUP_CALL(pte_read)(pte)
 
 BTFIXUPDEF_CALL_CONST(int, pmd_bad, pmd_t)
 BTFIXUPDEF_CALL_CONST(int, pmd_present, pmd_t)
diff -puN include/asm-sparc64/pgtable.h~page-table-handling-cleanup include/asm-sparc64/pgtable.h
--- a/include/asm-sparc64/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-sparc64/pgtable.h
@@ -573,24 +573,6 @@ static inline unsigned long pte_exec(pte
 	return (pte_val(pte) & mask);
 }
 
-static inline unsigned long pte_read(pte_t pte)
-{
-	unsigned long mask;
-
-	__asm__ __volatile__(
-	"\n661:	mov		%1, %0\n"
-	"	nop\n"
-	"	.section	.sun4v_2insn_patch, \"ax\"\n"
-	"	.word		661b\n"
-	"	sethi		%%uhi(%2), %0\n"
-	"	sllx		%0, 32, %0\n"
-	"	.previous\n"
-	: "=r" (mask)
-	: "i" (_PAGE_READ_4U), "i" (_PAGE_READ_4V));
-
-	return (pte_val(pte) & mask);
-}
-
 static inline unsigned long pte_file(pte_t pte)
 {
 	unsigned long val = pte_val(pte);
diff -puN include/asm-um/pgtable.h~page-table-handling-cleanup include/asm-um/pgtable.h
--- a/include/asm-um/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-um/pgtable.h
@@ -175,12 +175,6 @@ static inline int pte_none(pte_t pte)
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-static inline int pte_user(pte_t pte)
-{
-	return((pte_get_bits(pte, _PAGE_USER)) &&
-	       !(pte_get_bits(pte, _PAGE_PROTNONE)));
-}
-
 static inline int pte_read(pte_t pte)
 { 
 	return((pte_get_bits(pte, _PAGE_USER)) &&
@@ -238,18 +232,6 @@ static inline pte_t pte_mknewprot(pte_t 
 	return(pte);
 }
 
-static inline pte_t pte_rdprotect(pte_t pte)
-{ 
-	pte_clear_bits(pte, _PAGE_USER);
-	return(pte_mknewprot(pte));
-}
-
-static inline pte_t pte_exprotect(pte_t pte)
-{ 
-	pte_clear_bits(pte, _PAGE_USER);
-	return(pte_mknewprot(pte));
-}
-
 static inline pte_t pte_mkclean(pte_t pte)
 {
 	pte_clear_bits(pte, _PAGE_DIRTY);
diff -puN include/asm-x86_64/pgtable.h~page-table-handling-cleanup include/asm-x86_64/pgtable.h
--- a/include/asm-x86_64/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-x86_64/pgtable.h
@@ -266,21 +266,15 @@ static inline pte_t pfn_pte(unsigned lon
  * Undefined behaviour if not..
  */
 #define __LARGE_PTE (_PAGE_PSE|_PAGE_PRESENT)
-static inline int pte_user(pte_t pte)		{ return pte_val(pte) & _PAGE_USER; }
-static inline int pte_read(pte_t pte)		{ return pte_val(pte) & _PAGE_USER; }
-static inline int pte_exec(pte_t pte)		{ return !(pte_val(pte) & _PAGE_NX); }
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_RW; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_huge(pte_t pte)		{ return pte_val(pte) & _PAGE_PSE; }
 
-static inline pte_t pte_rdprotect(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_USER)); return pte; }
-static inline pte_t pte_exprotect(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_USER)); return pte; }
 static inline pte_t pte_mkclean(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_DIRTY)); return pte; }
 static inline pte_t pte_mkold(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_ACCESSED)); return pte; }
 static inline pte_t pte_wrprotect(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_RW)); return pte; }
-static inline pte_t pte_mkread(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_USER)); return pte; }
 static inline pte_t pte_mkexec(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_NX)); return pte; }
 static inline pte_t pte_mkdirty(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_DIRTY)); return pte; }
 static inline pte_t pte_mkyoung(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_ACCESSED)); return pte; }
diff -puN include/asm-xtensa/pgtable.h~page-table-handling-cleanup include/asm-xtensa/pgtable.h
--- a/include/asm-xtensa/pgtable.h~page-table-handling-cleanup
+++ a/include/asm-xtensa/pgtable.h
@@ -197,16 +197,13 @@ extern pgd_t swapper_pg_dir[PAGE_SIZE/si
 
 /* Note: We use the _PAGE_USER bit to indicate write-protect kernel memory */
 
-static inline int pte_read(pte_t pte)  { return pte_val(pte) & _PAGE_USER; }
 static inline int pte_write(pte_t pte) { return pte_val(pte) & _PAGE_RW; }
 static inline int pte_dirty(pte_t pte) { return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte) { return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte)  { return pte_val(pte) & _PAGE_FILE; }
 static inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) &= ~(_PAGE_RW | _PAGE_WRENABLE); return pte; }
-static inline pte_t pte_rdprotect(pte_t pte)	{ pte_val(pte) &= ~_PAGE_USER; return pte; }
 static inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~_PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkold(pte_t pte)	{ pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
-static inline pte_t pte_mkread(pte_t pte)	{ pte_val(pte) |= _PAGE_USER; return pte; }
 static inline pte_t pte_mkdirty(pte_t pte)	{ pte_val(pte) |= _PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkyoung(pte_t pte)	{ pte_val(pte) |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte)	{ pte_val(pte) |= _PAGE_RW; return pte; }
_

Patches currently in -mm which might be from jbeulich@novell.com are

remove-pci_dac_dma_-apis.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
i386-minor-nx-handling-adjustment.patch
mm-fix-improper-init-type-section-references.patch
page-table-handling-cleanup.patch
modpost-white-list-pattern-adjustment.patch
adjust-nosmp-handling.patch
kill-vmalloc_earlyreserve.patch
x86-fix-change_page_attr-tlb-and-cache-flushing.patch
x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu.patch
x86-64-remove-unused-variable-maxcpus.patch
