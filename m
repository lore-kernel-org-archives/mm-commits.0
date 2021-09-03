Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F89C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D98861107
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350002AbhICU7f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349941AbhICU73 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF1AE610FB;
        Fri,  3 Sep 2021 20:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702709;
        bh=QmEmovDT0ayloXEoJ6YsxoE2nJmaT8rUbFCsqXgsD/o=;
        h=Date:From:To:Subject:From;
        b=PqerT3Uuuz3zh2IbieRBIbaXI7JL7GnJdJ7FS+PLnT4rpRJmqRs7v02a0EmygOUf4
         nAhH5RuaK1wuMmZp+ciiuIICDezw0lorIlM/xMQnOR0ltgVUcCIjWVxU3Ok4dB0txs
         5W+eT8snuT1NHkcY6OPxQVTZSQxBBh3nzOBxQdLg=
Date:   Fri, 03 Sep 2021 13:58:28 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, dalias@libc.org, deanbo422@gmail.com,
        deller@gmx.de, geoff@infradead.org, green.hu@gmail.com,
        guoren@kernel.org, hch@lst.de, ira.weiny@intel.com,
        James.Bottomley@HansenPartnership.com, linux@armlinux.org.uk,
        mm-commits@vger.kernel.org, nickhu@andestech.com,
        paul@crapouillou.net, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, ulf.hansson@linaro.org,
        ysato@users.osdn.me
Subject:  [merged] mm-remove-flush_kernel_dcache_page.patch removed
 from -mm tree
Message-ID: <20210903205828.Lmz-N_v-N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove flush_kernel_dcache_page
has been removed from the -mm tree.  Its filename was
     mm-remove-flush_kernel_dcache_page.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Christoph Hellwig <hch@lst.de>
Subject: mm: remove flush_kernel_dcache_page

flush_kernel_dcache_page is a rather confusing interface that implements a
subset of flush_dcache_page by not being able to properly handle page
cache mapped pages.

The only callers left are in the exec code as all other previous callers
were incorrect as they could have dealt with page cache pages.  Replace
the calls to flush_kernel_dcache_page with calls to flush_dcache_page,
which for all architectures does either exactly the same thing, can
contains one or more of the following:

 1) an optimization to defer the cache flush for page cache pages not
    mapped into userspace
 2) additional flushing for mapped page cache pages if cache aliases
    are possible

Link: https://lkml.kernel.org/r/20210712060928.4161649-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/cachetlb.rst                    |   86 ++++------
 Documentation/translations/zh_CN/core-api/cachetlb.rst |    9 -
 arch/arm/include/asm/cacheflush.h                      |    4=20
 arch/arm/mm/flush.c                                    |   33 ---
 arch/arm/mm/nommu.c                                    |    6=20
 arch/csky/abiv1/cacheflush.c                           |   11 -
 arch/csky/abiv1/inc/abi/cacheflush.h                   |    4=20
 arch/mips/include/asm/cacheflush.h                     |    8=20
 arch/nds32/include/asm/cacheflush.h                    |    3=20
 arch/nds32/mm/cacheflush.c                             |    9 -
 arch/parisc/include/asm/cacheflush.h                   |    8=20
 arch/parisc/kernel/cache.c                             |    3=20
 arch/sh/include/asm/cacheflush.h                       |    8=20
 block/blk-map.c                                        |    2=20
 fs/exec.c                                              |    6=20
 include/linux/highmem.h                                |    5=20
 tools/testing/scatterlist/linux/mm.h                   |    1=20
 17 files changed, 51 insertions(+), 155 deletions(-)

--- a/arch/arm/include/asm/cacheflush.h~mm-remove-flush_kernel_dcache_page
+++ a/arch/arm/include/asm/cacheflush.h
@@ -291,6 +291,7 @@ extern void flush_cache_page(struct vm_a
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *);
=20
+#define ARCH_IMPLEMENTS_FLUSH_KERNEL_VMAP_RANGE 1
 static inline void flush_kernel_vmap_range(void *addr, int size)
 {
 	if ((cache_is_vivt() || cache_is_vipt_aliasing()))
@@ -312,9 +313,6 @@ static inline void flush_anon_page(struc
 		__flush_anon_page(vma, page, vmaddr);
 }
=20
-#define ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
-extern void flush_kernel_dcache_page(struct page *);
-
 #define flush_dcache_mmap_lock(mapping)		xa_lock_irq(&mapping->i_pages)
 #define flush_dcache_mmap_unlock(mapping)	xa_unlock_irq(&mapping->i_pages)
=20
--- a/arch/arm/mm/flush.c~mm-remove-flush_kernel_dcache_page
+++ a/arch/arm/mm/flush.c
@@ -346,39 +346,6 @@ void flush_dcache_page(struct page *page
 EXPORT_SYMBOL(flush_dcache_page);
=20
 /*
- * Ensure cache coherency for the kernel mapping of this page. We can
- * assume that the page is pinned via kmap.
- *
- * If the page only exists in the page cache and there are no user
- * space mappings, this is a no-op since the page was already marked
- * dirty at creation.  Otherwise, we need to flush the dirty kernel
- * cache lines directly.
- */
-void flush_kernel_dcache_page(struct page *page)
-{
-	if (cache_is_vivt() || cache_is_vipt_aliasing()) {
-		struct address_space *mapping;
-
-		mapping =3D page_mapping_file(page);
-
-		if (!mapping || mapping_mapped(mapping)) {
-			void *addr;
-
-			addr =3D page_address(page);
-			/*
-			 * kmap_atomic() doesn't set the page virtual
-			 * address for highmem pages, and
-			 * kunmap_atomic() takes care of cache
-			 * flushing already.
-			 */
-			if (!IS_ENABLED(CONFIG_HIGHMEM) || addr)
-				__cpuc_flush_dcache_area(addr, PAGE_SIZE);
-		}
-	}
-}
-EXPORT_SYMBOL(flush_kernel_dcache_page);
-
-/*
  * Flush an anonymous page so that users of get_user_pages()
  * can safely access the data.  The expected sequence is:
  *
--- a/arch/arm/mm/nommu.c~mm-remove-flush_kernel_dcache_page
+++ a/arch/arm/mm/nommu.c
@@ -166,12 +166,6 @@ void flush_dcache_page(struct page *page
 }
 EXPORT_SYMBOL(flush_dcache_page);
=20
-void flush_kernel_dcache_page(struct page *page)
-{
-	__cpuc_flush_dcache_area(page_address(page), PAGE_SIZE);
-}
-EXPORT_SYMBOL(flush_kernel_dcache_page);
-
 void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
 		       unsigned long uaddr, void *dst, const void *src,
 		       unsigned long len)
--- a/arch/csky/abiv1/cacheflush.c~mm-remove-flush_kernel_dcache_page
+++ a/arch/csky/abiv1/cacheflush.c
@@ -56,17 +56,6 @@ void update_mmu_cache(struct vm_area_str
 	}
 }
=20
-void flush_kernel_dcache_page(struct page *page)
-{
-	struct address_space *mapping;
-
-	mapping =3D page_mapping_file(page);
-
-	if (!mapping || mapping_mapped(mapping))
-		dcache_wbinv_all();
-}
-EXPORT_SYMBOL(flush_kernel_dcache_page);
-
 void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
 	unsigned long end)
 {
--- a/arch/csky/abiv1/inc/abi/cacheflush.h~mm-remove-flush_kernel_dcache_pa=
ge
+++ a/arch/csky/abiv1/inc/abi/cacheflush.h
@@ -14,12 +14,10 @@ extern void flush_dcache_page(struct pag
 #define flush_cache_page(vma, page, pfn)	cache_wbinv_all()
 #define flush_cache_dup_mm(mm)			cache_wbinv_all()
=20
-#define ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
-extern void flush_kernel_dcache_page(struct page *);
-
 #define flush_dcache_mmap_lock(mapping)		xa_lock_irq(&mapping->i_pages)
 #define flush_dcache_mmap_unlock(mapping)	xa_unlock_irq(&mapping->i_pages)
=20
+#define ARCH_IMPLEMENTS_FLUSH_KERNEL_VMAP_RANGE 1
 static inline void flush_kernel_vmap_range(void *addr, int size)
 {
 	dcache_wbinv_all();
--- a/arch/mips/include/asm/cacheflush.h~mm-remove-flush_kernel_dcache_page
+++ a/arch/mips/include/asm/cacheflush.h
@@ -125,13 +125,7 @@ static inline void kunmap_noncoherent(vo
 	kunmap_coherent();
 }
=20
-#define ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
-static inline void flush_kernel_dcache_page(struct page *page)
-{
-	BUG_ON(cpu_has_dc_aliases && PageHighMem(page));
-	flush_dcache_page(page);
-}
-
+#define ARCH_IMPLEMENTS_FLUSH_KERNEL_VMAP_RANGE 1
 /*
  * For now flush_kernel_vmap_range and invalidate_kernel_vmap_range both d=
o a
  * cache writeback and invalidate operation.
--- a/arch/nds32/include/asm/cacheflush.h~mm-remove-flush_kernel_dcache_page
+++ a/arch/nds32/include/asm/cacheflush.h
@@ -36,8 +36,7 @@ void copy_from_user_page(struct vm_area_
 void flush_anon_page(struct vm_area_struct *vma,
 		     struct page *page, unsigned long vaddr);
=20
-#define ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
-void flush_kernel_dcache_page(struct page *page);
+#define ARCH_IMPLEMENTS_FLUSH_KERNEL_VMAP_RANGE 1
 void flush_kernel_vmap_range(void *addr, int size);
 void invalidate_kernel_vmap_range(void *addr, int size);
 #define flush_dcache_mmap_lock(mapping)   xa_lock_irq(&(mapping)->i_pages)
--- a/arch/nds32/mm/cacheflush.c~mm-remove-flush_kernel_dcache_page
+++ a/arch/nds32/mm/cacheflush.c
@@ -318,15 +318,6 @@ void flush_anon_page(struct vm_area_stru
 	local_irq_restore(flags);
 }
=20
-void flush_kernel_dcache_page(struct page *page)
-{
-	unsigned long flags;
-	local_irq_save(flags);
-	cpu_dcache_wbinval_page((unsigned long)page_address(page));
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL(flush_kernel_dcache_page);
-
 void flush_kernel_vmap_range(void *addr, int size)
 {
 	unsigned long flags;
--- a/arch/parisc/include/asm/cacheflush.h~mm-remove-flush_kernel_dcache_pa=
ge
+++ a/arch/parisc/include/asm/cacheflush.h
@@ -36,16 +36,12 @@ void flush_cache_all_local(void);
 void flush_cache_all(void);
 void flush_cache_mm(struct mm_struct *mm);
=20
-#define ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
 void flush_kernel_dcache_page_addr(void *addr);
-static inline void flush_kernel_dcache_page(struct page *page)
-{
-	flush_kernel_dcache_page_addr(page_address(page));
-}
=20
 #define flush_kernel_dcache_range(start,size) \
 	flush_kernel_dcache_range_asm((start), (start)+(size));
=20
+#define ARCH_IMPLEMENTS_FLUSH_KERNEL_VMAP_RANGE 1
 void flush_kernel_vmap_range(void *vaddr, int size);
 void invalidate_kernel_vmap_range(void *vaddr, int size);
=20
@@ -59,7 +55,7 @@ extern void flush_dcache_page(struct pag
 #define flush_dcache_mmap_unlock(mapping)	xa_unlock_irq(&mapping->i_pages)
=20
 #define flush_icache_page(vma,page)	do { 		\
-	flush_kernel_dcache_page(page);			\
+	flush_kernel_dcache_page_addr(page_address(page)); \
 	flush_kernel_icache_page(page_address(page)); 	\
 } while (0)
=20
--- a/arch/parisc/kernel/cache.c~mm-remove-flush_kernel_dcache_page
+++ a/arch/parisc/kernel/cache.c
@@ -334,7 +334,7 @@ void flush_dcache_page(struct page *page
 		return;
 	}
=20
-	flush_kernel_dcache_page(page);
+	flush_kernel_dcache_page_addr(page_address(page));
=20
 	if (!mapping)
 		return;
@@ -375,7 +375,6 @@ EXPORT_SYMBOL(flush_dcache_page);
=20
 /* Defined in arch/parisc/kernel/pacache.S */
 EXPORT_SYMBOL(flush_kernel_dcache_range_asm);
-EXPORT_SYMBOL(flush_kernel_dcache_page_asm);
 EXPORT_SYMBOL(flush_data_cache_local);
 EXPORT_SYMBOL(flush_kernel_icache_range_asm);
=20
--- a/arch/sh/include/asm/cacheflush.h~mm-remove-flush_kernel_dcache_page
+++ a/arch/sh/include/asm/cacheflush.h
@@ -63,6 +63,8 @@ static inline void flush_anon_page(struc
 	if (boot_cpu_data.dcache.n_aliases && PageAnon(page))
 		__flush_anon_page(page, vmaddr);
 }
+
+#define ARCH_IMPLEMENTS_FLUSH_KERNEL_VMAP_RANGE 1
 static inline void flush_kernel_vmap_range(void *addr, int size)
 {
 	__flush_wback_region(addr, size);
@@ -72,12 +74,6 @@ static inline void invalidate_kernel_vma
 	__flush_invalidate_region(addr, size);
 }
=20
-#define ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
-static inline void flush_kernel_dcache_page(struct page *page)
-{
-	flush_dcache_page(page);
-}
-
 extern void copy_to_user_page(struct vm_area_struct *vma,
 	struct page *page, unsigned long vaddr, void *dst, const void *src,
 	unsigned long len);
--- a/block/blk-map.c~mm-remove-flush_kernel_dcache_page
+++ a/block/blk-map.c
@@ -309,7 +309,7 @@ static int bio_map_user_iov(struct reque
=20
 static void bio_invalidate_vmalloc_pages(struct bio *bio)
 {
-#ifdef ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
+#ifdef ARCH_IMPLEMENTS_FLUSH_KERNEL_VMAP_RANGE
 	if (bio->bi_private && !op_is_write(bio_op(bio))) {
 		unsigned long i, len =3D 0;
=20
--- a/Documentation/core-api/cachetlb.rst~mm-remove-flush_kernel_dcache_page
+++ a/Documentation/core-api/cachetlb.rst
@@ -271,10 +271,15 @@ maps this page at its virtual address.
=20
   ``void flush_dcache_page(struct page *page)``
=20
-	Any time the kernel writes to a page cache page, _OR_
-	the kernel is about to read from a page cache page and
-	user space shared/writable mappings of this page potentially
-	exist, this routine is called.
+        This routines must be called when:
+
+	  a) the kernel did write to a page that is in the page cache page
+	     and / or in high memory
+	  b) the kernel is about to read from a page cache page and user space
+	     shared/writable mappings of this page potentially exist.  Note
+	     that {get,pin}_user_pages{_fast} already call flush_dcache_page
+	     on any page found in the user address space and thus driver
+	     code rarely needs to take this into account.
=20
 	.. note::
=20
@@ -284,38 +289,34 @@ maps this page at its virtual address.
 	      handling vfs symlinks in the page cache need not call
 	      this interface at all.
=20
-	The phrase "kernel writes to a page cache page" means,
-	specifically, that the kernel executes store instructions
-	that dirty data in that page at the page->virtual mapping
-	of that page.  It is important to flush here to handle
-	D-cache aliasing, to make sure these kernel stores are
-	visible to user space mappings of that page.
-
-	The corollary case is just as important, if there are users
-	which have shared+writable mappings of this file, we must make
-	sure that kernel reads of these pages will see the most recent
-	stores done by the user.
-
-	If D-cache aliasing is not an issue, this routine may
-	simply be defined as a nop on that architecture.
-
-        There is a bit set aside in page->flags (PG_arch_1) as
-	"architecture private".  The kernel guarantees that,
-	for pagecache pages, it will clear this bit when such
-	a page first enters the pagecache.
-
-	This allows these interfaces to be implemented much more
-	efficiently.  It allows one to "defer" (perhaps indefinitely)
-	the actual flush if there are currently no user processes
-	mapping this page.  See sparc64's flush_dcache_page and
-	update_mmu_cache implementations for an example of how to go
-	about doing this.
-
-	The idea is, first at flush_dcache_page() time, if
-	page->mapping->i_mmap is an empty tree, just mark the architecture
-	private page flag bit.  Later, in update_mmu_cache(), a check is
-	made of this flag bit, and if set the flush is done and the flag
-	bit is cleared.
+	The phrase "kernel writes to a page cache page" means, specifically,
+	that the kernel executes store instructions that dirty data in that
+	page at the page->virtual mapping of that page.  It is important to
+	flush here to handle D-cache aliasing, to make sure these kernel stores
+	are visible to user space mappings of that page.
+
+	The corollary case is just as important, if there are users which have
+	shared+writable mappings of this file, we must make sure that kernel
+	reads of these pages will see the most recent stores done by the user.
+
+	If D-cache aliasing is not an issue, this routine may simply be defined
+	as a nop on that architecture.
+
+        There is a bit set aside in page->flags (PG_arch_1) as "architectu=
re
+	private".  The kernel guarantees that, for pagecache pages, it will
+	clear this bit when such a page first enters the pagecache.
+
+	This allows these interfaces to be implemented much more efficiently.
+	It allows one to "defer" (perhaps indefinitely) the actual flush if
+	there are currently no user processes mapping this page.  See sparc64's
+	flush_dcache_page and update_mmu_cache implementations for an example
+	of how to go about doing this.
+
+	The idea is, first at flush_dcache_page() time, if page_file_mapping()
+	returns a mapping, and mapping_mapped on that mapping returns %false,
+	just mark the architecture private page flag bit.  Later, in
+	update_mmu_cache(), a check is made of this flag bit, and if set the
+	flush is done and the flag bit is cleared.
=20
 	.. important::
=20
@@ -351,19 +352,6 @@ maps this page at its virtual address.
 	architectures).  For incoherent architectures, it should flush
 	the cache of the page at vmaddr.
=20
-  ``void flush_kernel_dcache_page(struct page *page)``
-
-	When the kernel needs to modify a user page is has obtained
-	with kmap, it calls this function after all modifications are
-	complete (but before kunmapping it) to bring the underlying
-	page up to date.  It is assumed here that the user has no
-	incoherent cached copies (i.e. the original page was obtained
-	from a mechanism like get_user_pages()).  The default
-	implementation is a nop and should remain so on all coherent
-	architectures.  On incoherent architectures, this should flush
-	the kernel cache for page (using page_address(page)).
-
-
   ``void flush_icache_range(unsigned long start, unsigned long end)``
=20
   	When the kernel stores into addresses that it will execute
--- a/Documentation/translations/zh_CN/core-api/cachetlb.rst~mm-remove-flus=
h_kernel_dcache_page
+++ a/Documentation/translations/zh_CN/core-api/cachetlb.rst
@@ -298,15 +298,6 @@ =E9=97=AE=E9=A2=98=E6=9C=89=E5=8F=AF=E8=83=BD=E5=AD=98=
=E5=9C=A8=EF=BC=8C=E5=9B=A0=E4=B8=BA=E5=86=85=E6=A0=B8=E5=B7=B2=E7
 	=E7=94=A8=E3=80=82=E9=BB=98=E8=AE=A4=E7=9A=84=E5=AE=9E=E7=8E=B0=E6=98=AFn=
op=EF=BC=88=E5=AF=B9=E4=BA=8E=E6=89=80=E6=9C=89=E7=9B=B8=E5=B9=B2=E7=9A=84=
=E6=9E=B6=E6=9E=84=E5=BA=94=E8=AF=A5=E4=BF=9D=E6=8C=81=E8=BF=99=E6=A0=B7=EF=
=BC=89=E3=80=82=E5=AF=B9=E4=BA=8E=E4=B8=8D=E4=B8=80=E8=87=B4=E6=80=A7
 	=E7=9A=84=E6=9E=B6=E6=9E=84=EF=BC=8C=E5=AE=83=E5=BA=94=E8=AF=A5=E5=88=B7=
=E6=96=B0vmaddr=E5=A4=84=E7=9A=84=E9=A1=B5=E9=9D=A2=E7=BC=93=E5=AD=98=E3=80=
=82
=20
-  ``void flush_kernel_dcache_page(struct page *page)``
-
-	=E5=BD=93=E5=86=85=E6=A0=B8=E9=9C=80=E8=A6=81=E4=BF=AE=E6=94=B9=E4=B8=80=
=E4=B8=AA=E7=94=A8kmap=E8=8E=B7=E5=BE=97=E7=9A=84=E7=94=A8=E6=88=B7=E9=A1=
=B5=E6=97=B6=EF=BC=8C=E5=AE=83=E4=BC=9A=E5=9C=A8=E6=89=80=E6=9C=89=E4=BF=AE=
=E6=94=B9=E5=AE=8C=E6=88=90=E5=90=8E=EF=BC=88=E4=BD=86=E5=9C=A8
-	kunmapping=E4=B9=8B=E5=89=8D=EF=BC=89=E8=B0=83=E7=94=A8=E8=BF=99=E4=B8=AA=
=E5=87=BD=E6=95=B0=EF=BC=8C=E4=BB=A5=E4=BD=BF=E5=BA=95=E5=B1=82=E9=A1=B5=E9=
=9D=A2=E8=BE=BE=E5=88=B0=E6=9C=80=E6=96=B0=E7=8A=B6=E6=80=81=E3=80=82=E8=BF=
=99=E9=87=8C=E5=81=87=E5=AE=9A=E7=94=A8
-	=E6=88=B7=E6=B2=A1=E6=9C=89=E4=B8=8D=E4=B8=80=E8=87=B4=E6=80=A7=E7=9A=84=
=E7=BC=93=E5=AD=98=E5=89=AF=E6=9C=AC=EF=BC=88=E5=8D=B3=E5=8E=9F=E5=A7=8B=E9=
=A1=B5=E9=9D=A2=E6=98=AF=E4=BB=8E=E7=B1=BB=E4=BC=BCget_user_pages()=E7=9A=
=84=E6=9C=BA=E5=88=B6
-	=E4=B8=AD=E8=8E=B7=E5=BE=97=E7=9A=84=EF=BC=89=E3=80=82=E9=BB=98=E8=AE=A4=
=E7=9A=84=E5=AE=9E=E7=8E=B0=E6=98=AF=E4=B8=80=E4=B8=AAnop=EF=BC=8C=E5=9C=A8=
=E6=89=80=E6=9C=89=E7=9B=B8=E5=B9=B2=E7=9A=84=E6=9E=B6=E6=9E=84=E4=B8=8A=E9=
=83=BD=E5=BA=94=E8=AF=A5=E5=A6=82=E6=AD=A4=E3=80=82=E5=9C=A8=E4=B8=8D
-	=E4=B8=80=E8=87=B4=E6=80=A7=E7=9A=84=E6=9E=B6=E6=9E=84=E4=B8=8A=EF=BC=8C=
=E8=BF=99=E5=BA=94=E8=AF=A5=E5=88=B7=E6=96=B0=E5=86=85=E6=A0=B8=E7=BC=93=E5=
=AD=98=E4=B8=AD=E7=9A=84=E9=A1=B5=E9=9D=A2=EF=BC=88=E4=BD=BF=E7=94=A8page_a=
ddress(page)=EF=BC=89=E3=80=82
-
-
   ``void flush_icache_range(unsigned long start, unsigned long end)``
=20
 	=E5=BD=93=E5=86=85=E6=A0=B8=E5=AD=98=E5=82=A8=E5=88=B0=E5=AE=83=E5=B0=86=
=E6=89=A7=E8=A1=8C=E7=9A=84=E5=9C=B0=E5=9D=80=E4=B8=AD=E6=97=B6=EF=BC=88=E4=
=BE=8B=E5=A6=82=E5=9C=A8=E5=8A=A0=E8=BD=BD=E6=A8=A1=E5=9D=97=E6=97=B6=EF=BC=
=89=EF=BC=8C=E8=BF=99=E4=B8=AA=E5=87=BD=E6=95=B0=E8=A2=AB=E8=B0=83=E7=94=A8=
=E3=80=82
--- a/fs/exec.c~mm-remove-flush_kernel_dcache_page
+++ a/fs/exec.c
@@ -574,7 +574,7 @@ static int copy_strings(int argc, struct
 				}
=20
 				if (kmapped_page) {
-					flush_kernel_dcache_page(kmapped_page);
+					flush_dcache_page(kmapped_page);
 					kunmap(kmapped_page);
 					put_arg_page(kmapped_page);
 				}
@@ -592,7 +592,7 @@ static int copy_strings(int argc, struct
 	ret =3D 0;
 out:
 	if (kmapped_page) {
-		flush_kernel_dcache_page(kmapped_page);
+		flush_dcache_page(kmapped_page);
 		kunmap(kmapped_page);
 		put_arg_page(kmapped_page);
 	}
@@ -634,7 +634,7 @@ int copy_string_kernel(const char *arg,
 		kaddr =3D kmap_atomic(page);
 		flush_arg_page(bprm, pos & PAGE_MASK, page);
 		memcpy(kaddr + offset_in_page(pos), arg, bytes_to_copy);
-		flush_kernel_dcache_page(page);
+		flush_dcache_page(page);
 		kunmap_atomic(kaddr);
 		put_arg_page(page);
 	}
--- a/include/linux/highmem.h~mm-remove-flush_kernel_dcache_page
+++ a/include/linux/highmem.h
@@ -130,10 +130,7 @@ static inline void flush_anon_page(struc
 }
 #endif
=20
-#ifndef ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
-static inline void flush_kernel_dcache_page(struct page *page)
-{
-}
+#ifndef ARCH_IMPLEMENTS_FLUSH_KERNEL_VMAP_RANGE
 static inline void flush_kernel_vmap_range(void *vaddr, int size)
 {
 }
--- a/tools/testing/scatterlist/linux/mm.h~mm-remove-flush_kernel_dcache_pa=
ge
+++ a/tools/testing/scatterlist/linux/mm.h
@@ -127,7 +127,6 @@ kmalloc_array(unsigned int n, unsigned i
 #define kmemleak_free(a)
=20
 #define PageSlab(p) (0)
-#define flush_kernel_dcache_page(p)
=20
 #define MAX_ERRNO	4095
=20
_

Patches currently in -mm which might be from hch@lst.de are

riscv-only-select-generic_ioremap-if-mmu-support-is-enabled.patch
mm-move-ioremap_page_range-to-vmallocc.patch
mm-dont-allow-executable-ioremap-mappings.patch
proc-stop-using-seq_get_buf-in-proc_task_name.patch
kernel-unexport-get_mmtask_exe_file.patch
mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

