Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3204128DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489832; cv=none; b=g67VM94TPIe9psvWQRYXooI9bkUb7SfOwx4oTscCA2F8XEcqe/oSVw3Y8mZGDMIjIyiGFUSJ0WK4KnEWxcFkQ0Nzs1itXgwAhnVgpszu2sot0r4a97p0FiFzFdNw1Rfm3ytVpuxVugTPVQK6AmMHfW35UaLhjqMJzxUOEou6jhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489832; c=relaxed/simple;
	bh=EfuLriSuVsJRfHaAYIC+HP2WI+vDHp6CLiwwm7qgAI4=;
	h=Date:To:From:Subject:Message-Id; b=KISYU93soBuVNO3qlamt3Wd7UqLjkYGnYzjJCDUyoOGI923s9s0wTc48wal37j2n3zsDDrrmsvJG98HhyvzJnLZZeoAqefvAyKUmDsnB5r//q17I8LdYDgDvvGCyPh0kDDk0uDsp26s0eFwIDgiaK6Els1i9vk1mOg58+lj3SGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MDJTSbPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MDJTSbPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05804C4CEE7;
	Sun, 21 Sep 2025 21:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489832;
	bh=EfuLriSuVsJRfHaAYIC+HP2WI+vDHp6CLiwwm7qgAI4=;
	h=Date:To:From:Subject:From;
	b=MDJTSbPWMxr3zAXYMmijNah92/mIDIDKBt67bM2UNwBPBFhkI+fldfF5ZytsLjBIL
	 WwpdrwfTBEA8y5PZb1/ndgUCAlfsF2qYAs4rkHXnW7HLlGU5CnUvRRANfEeC9Ihni7
	 tULuhPEMxqU8LCyX60VR+A6xsxIfX29YQneUU3n4=
Date: Sun, 21 Sep 2025 14:23:51 -0700
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mips-mm-convert-__flush_dcache_pages-to-__flush_dcache_folio_pages.patch removed from -mm tree
Message-Id: <20250921212352.05804C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: mm: convert __flush_dcache_pages() to __flush_dcache_folio_pages()
has been removed from the -mm tree.  Its filename was
     mips-mm-convert-__flush_dcache_pages-to-__flush_dcache_folio_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mips: mm: convert __flush_dcache_pages() to __flush_dcache_folio_pages()
Date: Mon, 1 Sep 2025 17:03:42 +0200

Let's make it clearer that we are operating within a single folio by
providing both the folio and the page.

This implies that for flush_dcache_folio() we'll now avoid one more
page->folio lookup, and that we can safely drop the "nth_page" usage.

While at it, drop the "extern" from the function declaration.

Link: https://lkml.kernel.org/r/20250901150359.867252-22-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/cacheflush.h |   11 +++++++----
 arch/mips/mm/cache.c               |    8 ++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

--- a/arch/mips/include/asm/cacheflush.h~mips-mm-convert-__flush_dcache_pages-to-__flush_dcache_folio_pages
+++ a/arch/mips/include/asm/cacheflush.h
@@ -50,13 +50,14 @@ extern void (*flush_cache_mm)(struct mm_
 extern void (*flush_cache_range)(struct vm_area_struct *vma,
 	unsigned long start, unsigned long end);
 extern void (*flush_cache_page)(struct vm_area_struct *vma, unsigned long page, unsigned long pfn);
-extern void __flush_dcache_pages(struct page *page, unsigned int nr);
+void __flush_dcache_folio_pages(struct folio *folio, struct page *page, unsigned int nr);
 
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 static inline void flush_dcache_folio(struct folio *folio)
 {
 	if (cpu_has_dc_aliases)
-		__flush_dcache_pages(&folio->page, folio_nr_pages(folio));
+		__flush_dcache_folio_pages(folio, folio_page(folio, 0),
+					   folio_nr_pages(folio));
 	else if (!cpu_has_ic_fills_f_dc)
 		folio_set_dcache_dirty(folio);
 }
@@ -64,10 +65,12 @@ static inline void flush_dcache_folio(st
 
 static inline void flush_dcache_page(struct page *page)
 {
+	struct folio *folio = page_folio(page);
+
 	if (cpu_has_dc_aliases)
-		__flush_dcache_pages(page, 1);
+		__flush_dcache_folio_pages(folio, page, 1);
 	else if (!cpu_has_ic_fills_f_dc)
-		folio_set_dcache_dirty(page_folio(page));
+		folio_set_dcache_dirty(folio);
 }
 
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
--- a/arch/mips/mm/cache.c~mips-mm-convert-__flush_dcache_pages-to-__flush_dcache_folio_pages
+++ a/arch/mips/mm/cache.c
@@ -99,9 +99,9 @@ SYSCALL_DEFINE3(cacheflush, unsigned lon
 	return 0;
 }
 
-void __flush_dcache_pages(struct page *page, unsigned int nr)
+void __flush_dcache_folio_pages(struct folio *folio, struct page *page,
+		unsigned int nr)
 {
-	struct folio *folio = page_folio(page);
 	struct address_space *mapping = folio_flush_mapping(folio);
 	unsigned long addr;
 	unsigned int i;
@@ -117,12 +117,12 @@ void __flush_dcache_pages(struct page *p
 	 * get faulted into the tlb (and thus flushed) anyways.
 	 */
 	for (i = 0; i < nr; i++) {
-		addr = (unsigned long)kmap_local_page(nth_page(page, i));
+		addr = (unsigned long)kmap_local_page(page + i);
 		flush_data_cache_page(addr);
 		kunmap_local((void *)addr);
 	}
 }
-EXPORT_SYMBOL(__flush_dcache_pages);
+EXPORT_SYMBOL(__flush_dcache_folio_pages);
 
 void __flush_anon_page(struct page *page, unsigned long vmaddr)
 {
_

Patches currently in -mm which might be from david@redhat.com are


