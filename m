From: akpm@linux-foundation.org
Subject: +
 tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i.patch
 added to -mm tree
Date: Tue, 31 May 2016 12:53:12 -0700
Message-ID: <574deba8.zR8CCLFO5NvXZxnM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbcEaTxO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:53:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, benh@kernel.crashing.org, blogic@openwrt.org, catalin.marinas@arm.com, cmetcalf@mellanox.com, dalias@libc.org, davem@davemloft.net, deller@gmx.de, gxt@mprc.pku.edu.cn, heiko.carstens@de.ibm.com, hpa@zytor.com, jack@suse.cz, jejb@parisc-linux.org, lennox.wu@gmail.com, lftan@altera.com, linux@arm.linux.org.uk, liqin.linux@gmail.com, luto@kernel.org, matt@codeblueprint.co.uk, mingo@redhat.com, ralf@linux-mips.org, schwidefsky@de.ibm.com, tglx@linutronix.de, tytso@mit.edu, vgupta@synopsys.com, will.deacon@arm.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: tree wide: get rid of __GFP_REPEAT for order-0 allocations part I
has been added to the -mm tree.  Its filename is
     tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: tree wide: get rid of __GFP_REPEAT for order-0 allocations part I

This is the third version of the patchset previously sent [1].  I have
basically only rebased it on top of 4.7-rc1 tree and dropped "dm: get rid
of superfluous gfp flags" which went through dm tree.  I am sending it now
because it is tree wide and chances for conflicts are reduced considerably
when we want to target rc2.  I plan to send the next step and rename the
flag and move to a better semantic later during this release cycle so we
will have a new semantic ready for 4.8 merge window hopefully.

Motivation:

While working on something unrelated I've checked the current usage of
__GFP_REPEAT in the tree.  It seems that a majority of the usage is and
always has been bogus because __GFP_REPEAT has always been about costly
high order allocations while we are using it for order-0 or very small
orders very often.  It seems that a big pile of them is just a copy&paste
when a code has been adopted from one arch to another.

I think it makes some sense to get rid of them because they are just
making the semantic more unclear. Please note that GFP_REPEAT is
documented as

* __GFP_REPEAT: Try hard to allocate the memory, but the allocation attempt

* _might_ fail.  This depends upon the particular VM implementation. 
  while !costly requests have basically nofail semantic.  So one could
  reasonably expect that order-0 request with __GFP_REPEAT will not loop
  for ever.  This is not implemented right now though.

I would like to move on with __GFP_REPEAT and define a better semantic for
it.

$ git grep __GFP_REPEAT origin/master | wc -l
111
$ git grep __GFP_REPEAT | wc -l
36

So we are down to the third after this patch series.  The remaining places
really seem to be relying on __GFP_REPEAT due to large allocation
requests.  This still needs some double checking which I will do later
after all the simple ones are sorted out.

I am touching a lot of arch specific code here and I hope I got it right
but as a matter of fact I even didn't compile test for some archs as I do
not have cross compiler for them.  Patches should be quite trivial to
review for stupid compile mistakes though.  The tricky parts are usually
hidden by macro definitions and thats where I would appreciate help from
arch maintainers.

[1] http://lkml.kernel.org/r/1461849846-27209-1-git-send-email-mhocko@kernel.org



This patch (of 19):

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.  Yet we have
the full kernel tree with its usage for apparently order-0 allocations. 
This is really confusing because __GFP_REPEAT is explicitly documented to
allow allocation failures which is a weaker semantic than the current
order-0 has (basically nofail).

Let's simply drop __GFP_REPEAT from those places.  This would allow to
identify place which really need allocator to retry harder and formulate a
more specific semantic for what the flag is supposed to do actually.

Link: http://lkml.kernel.org/r/1464599699-30131-2-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com> [for tile]
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: John Crispin <blogic@openwrt.org>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Ley Foon Tan <lftan@altera.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgalloc.h             |    4 ++--
 arch/arm/include/asm/pgalloc.h               |    2 +-
 arch/avr32/include/asm/pgalloc.h             |    6 +++---
 arch/cris/include/asm/pgalloc.h              |    4 ++--
 arch/frv/mm/pgalloc.c                        |    6 +++---
 arch/hexagon/include/asm/pgalloc.h           |    4 ++--
 arch/m68k/include/asm/mcf_pgalloc.h          |    4 ++--
 arch/m68k/include/asm/motorola_pgalloc.h     |    4 ++--
 arch/m68k/include/asm/sun3_pgalloc.h         |    4 ++--
 arch/metag/include/asm/pgalloc.h             |    5 ++---
 arch/microblaze/include/asm/pgalloc.h        |    4 ++--
 arch/microblaze/mm/pgtable.c                 |    3 +--
 arch/mn10300/mm/pgtable.c                    |    6 +++---
 arch/openrisc/include/asm/pgalloc.h          |    2 +-
 arch/openrisc/mm/ioremap.c                   |    2 +-
 arch/parisc/include/asm/pgalloc.h            |    4 ++--
 arch/powerpc/include/asm/book3s/64/pgalloc.h |    2 +-
 arch/powerpc/include/asm/nohash/64/pgalloc.h |    2 +-
 arch/powerpc/mm/pgtable_32.c                 |    4 ++--
 arch/powerpc/mm/pgtable_64.c                 |    3 +--
 arch/sh/include/asm/pgalloc.h                |    4 ++--
 arch/sparc/mm/init_64.c                      |    6 ++----
 arch/um/kernel/mem.c                         |    4 ++--
 arch/x86/include/asm/pgalloc.h               |    4 ++--
 arch/x86/xen/p2m.c                           |    2 +-
 arch/xtensa/include/asm/pgalloc.h            |    2 +-
 drivers/block/aoe/aoecmd.c                   |    2 +-
 27 files changed, 47 insertions(+), 52 deletions(-)

diff -puN arch/alpha/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/alpha/include/asm/pgalloc.h
--- a/arch/alpha/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/alpha/include/asm/pgalloc.h
@@ -40,7 +40,7 @@ pgd_free(struct mm_struct *mm, pgd_t *pg
 static inline pmd_t *
 pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	pmd_t *ret = (pmd_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+	pmd_t *ret = (pmd_t *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
 	return ret;
 }
 
@@ -53,7 +53,7 @@ pmd_free(struct mm_struct *mm, pmd_t *pm
 static inline pte_t *
 pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
-	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
 	return pte;
 }
 
diff -puN arch/arm/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/arm/include/asm/pgalloc.h
--- a/arch/arm/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/arm/include/asm/pgalloc.h
@@ -29,7 +29,7 @@
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return (pmd_t *)get_zeroed_page(GFP_KERNEL | __GFP_REPEAT);
+	return (pmd_t *)get_zeroed_page(GFP_KERNEL);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
diff -puN arch/avr32/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/avr32/include/asm/pgalloc.h
--- a/arch/avr32/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/avr32/include/asm/pgalloc.h
@@ -43,7 +43,7 @@ static inline void pgd_ctor(void *x)
  */
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	return quicklist_alloc(QUICK_PGD, GFP_KERNEL | __GFP_REPEAT, pgd_ctor);
+	return quicklist_alloc(QUICK_PGD, GFP_KERNEL, pgd_ctor);
 }
 
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
@@ -54,7 +54,7 @@ static inline void pgd_free(struct mm_st
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	return quicklist_alloc(QUICK_PT, GFP_KERNEL | __GFP_REPEAT, NULL);
+	return quicklist_alloc(QUICK_PT, GFP_KERNEL, NULL);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
@@ -63,7 +63,7 @@ static inline pgtable_t pte_alloc_one(st
 	struct page *page;
 	void *pg;
 
-	pg = quicklist_alloc(QUICK_PT, GFP_KERNEL | __GFP_REPEAT, NULL);
+	pg = quicklist_alloc(QUICK_PT, GFP_KERNEL, NULL);
 	if (!pg)
 		return NULL;
 
diff -puN arch/cris/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/cris/include/asm/pgalloc.h
--- a/arch/cris/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/cris/include/asm/pgalloc.h
@@ -24,14 +24,14 @@ static inline void pgd_free(struct mm_st
 
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
-  	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
  	return pte;
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
 	struct page *pte;
-	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
+	pte = alloc_pages(GFP_KERNEL|__GFP_ZERO, 0);
 	if (!pte)
 		return NULL;
 	if (!pgtable_page_ctor(pte)) {
diff -puN arch/frv/mm/pgalloc.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/frv/mm/pgalloc.c
--- a/arch/frv/mm/pgalloc.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/frv/mm/pgalloc.c
@@ -22,7 +22,7 @@ pgd_t swapper_pg_dir[PTRS_PER_PGD] __att
 
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
-	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
+	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL);
 	if (pte)
 		clear_page(pte);
 	return pte;
@@ -33,9 +33,9 @@ pgtable_t pte_alloc_one(struct mm_struct
 	struct page *page;
 
 #ifdef CONFIG_HIGHPTE
-	page = alloc_pages(GFP_KERNEL|__GFP_HIGHMEM|__GFP_REPEAT, 0);
+	page = alloc_pages(GFP_KERNEL|__GFP_HIGHMEM, 0);
 #else
-	page = alloc_pages(GFP_KERNEL|__GFP_REPEAT, 0);
+	page = alloc_pages(GFP_KERNEL, 0);
 #endif
 	if (!page)
 		return NULL;
diff -puN arch/hexagon/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/hexagon/include/asm/pgalloc.h
--- a/arch/hexagon/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/hexagon/include/asm/pgalloc.h
@@ -64,7 +64,7 @@ static inline struct page *pte_alloc_one
 {
 	struct page *pte;
 
-	pte = alloc_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
+	pte = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!pte)
 		return NULL;
 	if (!pgtable_page_ctor(pte)) {
@@ -78,7 +78,7 @@ static inline struct page *pte_alloc_one
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	gfp_t flags =  GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO;
+	gfp_t flags =  GFP_KERNEL | __GFP_ZERO;
 	return (pte_t *) __get_free_page(flags);
 }
 
diff -puN arch/m68k/include/asm/mcf_pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/m68k/include/asm/mcf_pgalloc.h
--- a/arch/m68k/include/asm/mcf_pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/m68k/include/asm/mcf_pgalloc.h
@@ -14,7 +14,7 @@ extern const char bad_pmd_string[];
 extern inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 	unsigned long address)
 {
-	unsigned long page = __get_free_page(GFP_DMA|__GFP_REPEAT);
+	unsigned long page = __get_free_page(GFP_DMA);
 
 	if (!page)
 		return NULL;
@@ -51,7 +51,7 @@ static inline void __pte_free_tlb(struct
 static inline struct page *pte_alloc_one(struct mm_struct *mm,
 	unsigned long address)
 {
-	struct page *page = alloc_pages(GFP_DMA|__GFP_REPEAT, 0);
+	struct page *page = alloc_pages(GFP_DMA, 0);
 	pte_t *pte;
 
 	if (!page)
diff -puN arch/m68k/include/asm/motorola_pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/m68k/include/asm/motorola_pgalloc.h
--- a/arch/m68k/include/asm/motorola_pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/m68k/include/asm/motorola_pgalloc.h
@@ -11,7 +11,7 @@ static inline pte_t *pte_alloc_one_kerne
 {
 	pte_t *pte;
 
-	pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+	pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
 	if (pte) {
 		__flush_page_to_ram(pte);
 		flush_tlb_kernel_page(pte);
@@ -32,7 +32,7 @@ static inline pgtable_t pte_alloc_one(st
 	struct page *page;
 	pte_t *pte;
 
-	page = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
+	page = alloc_pages(GFP_KERNEL|__GFP_ZERO, 0);
 	if(!page)
 		return NULL;
 	if (!pgtable_page_ctor(page)) {
diff -puN arch/m68k/include/asm/sun3_pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/m68k/include/asm/sun3_pgalloc.h
--- a/arch/m68k/include/asm/sun3_pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/m68k/include/asm/sun3_pgalloc.h
@@ -37,7 +37,7 @@ do {							\
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	unsigned long page = __get_free_page(GFP_KERNEL|__GFP_REPEAT);
+	unsigned long page = __get_free_page(GFP_KERNEL);
 
 	if (!page)
 		return NULL;
@@ -49,7 +49,7 @@ static inline pte_t *pte_alloc_one_kerne
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
 					unsigned long address)
 {
-        struct page *page = alloc_pages(GFP_KERNEL|__GFP_REPEAT, 0);
+        struct page *page = alloc_pages(GFP_KERNEL, 0);
 
 	if (page == NULL)
 		return NULL;
diff -puN arch/metag/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/metag/include/asm/pgalloc.h
--- a/arch/metag/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/metag/include/asm/pgalloc.h
@@ -42,8 +42,7 @@ static inline void pgd_free(struct mm_st
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL | __GFP_REPEAT |
-					      __GFP_ZERO);
+	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 	return pte;
 }
 
@@ -51,7 +50,7 @@ static inline pgtable_t pte_alloc_one(st
 				      unsigned long address)
 {
 	struct page *pte;
-	pte = alloc_pages(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO, 0);
+	pte = alloc_pages(GFP_KERNEL  | __GFP_ZERO, 0);
 	if (!pte)
 		return NULL;
 	if (!pgtable_page_ctor(pte)) {
diff -puN arch/microblaze/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/microblaze/include/asm/pgalloc.h
--- a/arch/microblaze/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/microblaze/include/asm/pgalloc.h
@@ -116,9 +116,9 @@ static inline struct page *pte_alloc_one
 	struct page *ptepage;
 
 #ifdef CONFIG_HIGHPTE
-	int flags = GFP_KERNEL | __GFP_HIGHMEM | __GFP_REPEAT;
+	int flags = GFP_KERNEL | __GFP_HIGHMEM;
 #else
-	int flags = GFP_KERNEL | __GFP_REPEAT;
+	int flags = GFP_KERNEL;
 #endif
 
 	ptepage = alloc_pages(flags, 0);
diff -puN arch/microblaze/mm/pgtable.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/microblaze/mm/pgtable.c
--- a/arch/microblaze/mm/pgtable.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/microblaze/mm/pgtable.c
@@ -239,8 +239,7 @@ __init_refok pte_t *pte_alloc_one_kernel
 {
 	pte_t *pte;
 	if (mem_init_done) {
-		pte = (pte_t *)__get_free_page(GFP_KERNEL |
-					__GFP_REPEAT | __GFP_ZERO);
+		pte = (pte_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 	} else {
 		pte = (pte_t *)early_get_page();
 		if (pte)
diff -puN arch/mn10300/mm/pgtable.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/mn10300/mm/pgtable.c
--- a/arch/mn10300/mm/pgtable.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/mn10300/mm/pgtable.c
@@ -63,7 +63,7 @@ void set_pmd_pfn(unsigned long vaddr, un
 
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
-	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
+	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL);
 	if (pte)
 		clear_page(pte);
 	return pte;
@@ -74,9 +74,9 @@ struct page *pte_alloc_one(struct mm_str
 	struct page *pte;
 
 #ifdef CONFIG_HIGHPTE
-	pte = alloc_pages(GFP_KERNEL|__GFP_HIGHMEM|__GFP_REPEAT, 0);
+	pte = alloc_pages(GFP_KERNEL|__GFP_HIGHMEM, 0);
 #else
-	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT, 0);
+	pte = alloc_pages(GFP_KERNEL, 0);
 #endif
 	if (!pte)
 		return NULL;
diff -puN arch/openrisc/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/openrisc/include/asm/pgalloc.h
--- a/arch/openrisc/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/openrisc/include/asm/pgalloc.h
@@ -77,7 +77,7 @@ static inline struct page *pte_alloc_one
 					 unsigned long address)
 {
 	struct page *pte;
-	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT, 0);
+	pte = alloc_pages(GFP_KERNEL, 0);
 	if (!pte)
 		return NULL;
 	clear_page(page_address(pte));
diff -puN arch/openrisc/mm/ioremap.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/openrisc/mm/ioremap.c
--- a/arch/openrisc/mm/ioremap.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/openrisc/mm/ioremap.c
@@ -122,7 +122,7 @@ pte_t __init_refok *pte_alloc_one_kernel
 	pte_t *pte;
 
 	if (likely(mem_init_done)) {
-		pte = (pte_t *) __get_free_page(GFP_KERNEL | __GFP_REPEAT);
+		pte = (pte_t *) __get_free_page(GFP_KERNEL);
 	} else {
 		pte = (pte_t *) alloc_bootmem_low_pages(PAGE_SIZE);
 #if 0
diff -puN arch/parisc/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/parisc/include/asm/pgalloc.h
--- a/arch/parisc/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/parisc/include/asm/pgalloc.h
@@ -124,7 +124,7 @@ pmd_populate_kernel(struct mm_struct *mm
 static inline pgtable_t
 pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	struct page *page = alloc_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+	struct page *page = alloc_page(GFP_KERNEL|__GFP_ZERO);
 	if (!page)
 		return NULL;
 	if (!pgtable_page_ctor(page)) {
@@ -137,7 +137,7 @@ pte_alloc_one(struct mm_struct *mm, unsi
 static inline pte_t *
 pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addr)
 {
-	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
 	return pte;
 }
 
diff -puN arch/powerpc/include/asm/book3s/64/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/powerpc/include/asm/book3s/64/pgalloc.h
--- a/arch/powerpc/include/asm/book3s/64/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/powerpc/include/asm/book3s/64/pgalloc.h
@@ -151,7 +151,7 @@ static inline pgtable_t pmd_pgtable(pmd_
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	return (pte_t *)__get_free_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
+	return (pte_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
diff -puN arch/powerpc/include/asm/nohash/64/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/powerpc/include/asm/nohash/64/pgalloc.h
--- a/arch/powerpc/include/asm/nohash/64/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/powerpc/include/asm/nohash/64/pgalloc.h
@@ -88,7 +88,7 @@ static inline void pmd_populate(struct m
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	return (pte_t *)__get_free_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
+	return (pte_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
diff -puN arch/powerpc/mm/pgtable_32.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/powerpc/mm/pgtable_32.c
--- a/arch/powerpc/mm/pgtable_32.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/powerpc/mm/pgtable_32.c
@@ -84,7 +84,7 @@ __init_refok pte_t *pte_alloc_one_kernel
 	pte_t *pte;
 
 	if (slab_is_available()) {
-		pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+		pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
 	} else {
 		pte = __va(memblock_alloc(PAGE_SIZE, PAGE_SIZE));
 		if (pte)
@@ -97,7 +97,7 @@ pgtable_t pte_alloc_one(struct mm_struct
 {
 	struct page *ptepage;
 
-	gfp_t flags = GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO;
+	gfp_t flags = GFP_KERNEL | __GFP_ZERO;
 
 	ptepage = alloc_pages(flags, 0);
 	if (!ptepage)
diff -puN arch/powerpc/mm/pgtable_64.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/powerpc/mm/pgtable_64.c
--- a/arch/powerpc/mm/pgtable_64.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -350,8 +350,7 @@ static pte_t *get_from_cache(struct mm_s
 static pte_t *__alloc_for_cache(struct mm_struct *mm, int kernel)
 {
 	void *ret = NULL;
-	struct page *page = alloc_page(GFP_KERNEL | __GFP_NOTRACK |
-				       __GFP_REPEAT | __GFP_ZERO);
+	struct page *page = alloc_page(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO);
 	if (!page)
 		return NULL;
 	if (!kernel && !pgtable_page_ctor(page)) {
diff -puN arch/sh/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/sh/include/asm/pgalloc.h
--- a/arch/sh/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/sh/include/asm/pgalloc.h
@@ -34,7 +34,7 @@ static inline void pmd_populate(struct m
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	return quicklist_alloc(QUICK_PT, GFP_KERNEL | __GFP_REPEAT, NULL);
+	return quicklist_alloc(QUICK_PT, GFP_KERNEL, NULL);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
@@ -43,7 +43,7 @@ static inline pgtable_t pte_alloc_one(st
 	struct page *page;
 	void *pg;
 
-	pg = quicklist_alloc(QUICK_PT, GFP_KERNEL | __GFP_REPEAT, NULL);
+	pg = quicklist_alloc(QUICK_PT, GFP_KERNEL, NULL);
 	if (!pg)
 		return NULL;
 	page = virt_to_page(pg);
diff -puN arch/sparc/mm/init_64.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/sparc/mm/init_64.c
@@ -2704,8 +2704,7 @@ void __flush_tlb_all(void)
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 			    unsigned long address)
 {
-	struct page *page = alloc_page(GFP_KERNEL | __GFP_NOTRACK |
-				       __GFP_REPEAT | __GFP_ZERO);
+	struct page *page = alloc_page(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO);
 	pte_t *pte = NULL;
 
 	if (page)
@@ -2717,8 +2716,7 @@ pte_t *pte_alloc_one_kernel(struct mm_st
 pgtable_t pte_alloc_one(struct mm_struct *mm,
 			unsigned long address)
 {
-	struct page *page = alloc_page(GFP_KERNEL | __GFP_NOTRACK |
-				       __GFP_REPEAT | __GFP_ZERO);
+	struct page *page = alloc_page(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO);
 	if (!page)
 		return NULL;
 	if (!pgtable_page_ctor(page)) {
diff -puN arch/um/kernel/mem.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/um/kernel/mem.c
@@ -204,7 +204,7 @@ pte_t *pte_alloc_one_kernel(struct mm_st
 {
 	pte_t *pte;
 
-	pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+	pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
 	return pte;
 }
 
@@ -212,7 +212,7 @@ pgtable_t pte_alloc_one(struct mm_struct
 {
 	struct page *pte;
 
-	pte = alloc_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+	pte = alloc_page(GFP_KERNEL|__GFP_ZERO);
 	if (!pte)
 		return NULL;
 	if (!pgtable_page_ctor(pte)) {
diff -puN arch/x86/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/x86/include/asm/pgalloc.h
--- a/arch/x86/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/x86/include/asm/pgalloc.h
@@ -81,7 +81,7 @@ static inline void pmd_populate(struct m
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
 	struct page *page;
-	page = alloc_pages(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO, 0);
+	page = alloc_pages(GFP_KERNEL |  __GFP_ZERO, 0);
 	if (!page)
 		return NULL;
 	if (!pgtable_pmd_page_ctor(page)) {
@@ -125,7 +125,7 @@ static inline void pgd_populate(struct m
 
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return (pud_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+	return (pud_t *)get_zeroed_page(GFP_KERNEL);
 }
 
 static inline void pud_free(struct mm_struct *mm, pud_t *pud)
diff -puN arch/x86/xen/p2m.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/x86/xen/p2m.c
--- a/arch/x86/xen/p2m.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/x86/xen/p2m.c
@@ -182,7 +182,7 @@ static void * __ref alloc_p2m_page(void)
 	if (unlikely(!slab_is_available()))
 		return alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
 
-	return (void *)__get_free_page(GFP_KERNEL | __GFP_REPEAT);
+	return (void *)__get_free_page(GFP_KERNEL);
 }
 
 static void __ref free_p2m_page(void *p)
diff -puN arch/xtensa/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i arch/xtensa/include/asm/pgalloc.h
--- a/arch/xtensa/include/asm/pgalloc.h~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/arch/xtensa/include/asm/pgalloc.h
@@ -44,7 +44,7 @@ static inline pte_t *pte_alloc_one_kerne
 	pte_t *ptep;
 	int i;
 
-	ptep = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
+	ptep = (pte_t *)__get_free_page(GFP_KERNEL);
 	if (!ptep)
 		return NULL;
 	for (i = 0; i < 1024; i++)
diff -puN drivers/block/aoe/aoecmd.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i
+++ a/drivers/block/aoe/aoecmd.c
@@ -1750,7 +1750,7 @@ aoecmd_init(void)
 	int ret;
 
 	/* get_zeroed_page returns page with ref count 1 */
-	p = (void *) get_zeroed_page(GFP_KERNEL | __GFP_REPEAT);
+	p = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
 	empty_page = virt_to_page(p);
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom_reaper-do-not-use-siglock-in-try_oom_reaper.patch
tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i.patch
x86-get-rid-of-superfluous-__gfp_repeat.patch
x86-efi-get-rid-of-superfluous-__gfp_repeat.patch
arm-get-rid-of-superfluous-__gfp_repeat.patch
arm64-get-rid-of-superfluous-__gfp_repeat.patch
arc-get-rid-of-superfluous-__gfp_repeat.patch
mips-get-rid-of-superfluous-__gfp_repeat.patch
nios2-get-rid-of-superfluous-__gfp_repeat.patch
parisc-get-rid-of-superfluous-__gfp_repeat.patch
score-get-rid-of-superfluous-__gfp_repeat.patch
powerpc-get-rid-of-superfluous-__gfp_repeat.patch
sparc-get-rid-of-superfluous-__gfp_repeat.patch
s390-get-rid-of-superfluous-__gfp_repeat.patch
sh-get-rid-of-superfluous-__gfp_repeat.patch
tile-get-rid-of-superfluous-__gfp_repeat.patch
unicore32-get-rid-of-superfluous-__gfp_repeat.patch
jbd2-get-rid-of-superfluous-__gfp_repeat.patch

