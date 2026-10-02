Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8FD29DB8F
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 21:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975560; cv=none; b=C5YigJrllyF4SML9HUX5pCc5MG2OOBNzAaR7kuVYFQXx0/oM7I6pwKL0ZmHyfRCJvUd0X7BNtgcQ/WIU2JDxWTaisTK2kjpCG0sesb2DBEYKLRi1Cd3AnQJYwkjl0B+TMNejYlzlfBaknL3G4wRe3piVnYwckwRFl3kdZjlhK+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975560; c=relaxed/simple;
	bh=NA9uca34ayStaQiGiJuy6+ec9CnxZbGGDyTPKJK/cDk=;
	h=Date:To:From:Subject:Message-Id; b=OZc3eX9jV6Q2wC322AMQOzls968F3mYs3vEiqrObYJWqMnlN9/Y6zAHBABtw/4yP+nb5yHld12Vp5L80d6hhwGQqLLJrUCxZec39Y5jAWIa86x+v+8eTSOBO8OIMLAcriVHh4hlPPuwNXz8AoWauJqKG4Knml48hmqxDNuRtxdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JmgUMoSt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JmgUMoSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B341F000FF;
	Fri,  2 Oct 2026 21:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790975558;
	bh=Ia8soiAiUfFKcsS7Uj1qcKGlV+Y9BRHGC+rHBm2xTY0=;
	h=Date:To:From:Subject;
	b=JmgUMoSt9AouKVNPjzIjtVqkOXHyZHbbVlt0XaxD9KtQ81xZOo4/cmNX+xHkCy4/k
	 xTLLXCMLy4CIp6OOZ7K4d3tqMRxvRLaNI/OD3lRpEPl2IWA3IsEIzshwYtyNjdDF//
	 PoERD1u3YnW1QEuNJU+UX75ITmPYHFHlYz57vvA0=
Date: Fri, 02 Oct 2026 14:12:37 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,dmytrokoziuk68@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-fix-iounmap-metadata-teardown.patch added to mm-new branch
Message-Id: <20261002211238.48B341F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmsan: fix iounmap metadata teardown
has been added to the -mm mm-new branch.  Its filename is
     mm-kmsan-fix-iounmap-metadata-teardown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-fix-iounmap-metadata-teardown.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dima Koziuk <dmytrokoziuk68@gmail.com>
Subject: mm: kmsan: fix iounmap metadata teardown
Date: Fri,  2 Oct 2026 23:05:07 +0300

kmsan_vmalloc_to_page_or_null() rejects addresses outside the regular
vmalloc and module ranges, including the shadow and origin addresses
passed by its callers.  As a result, iounmap does not free the metadata
backing pages.  Also, the first iteration of the teardown loop unmaps the
entire metadata range, preventing subsequent iterations from finding their
pages even if the address lookup is fixed.

Factor the page-table walk out of vmalloc_to_page() into
__vmalloc_to_page(), keeping the address check in the public wrapper.  Use
the unchecked helper in kmsan_vmalloc_to_page_or_null() and check for NULL
before converting the returned page to a PFN.  Mark __vmalloc_to_page() as
__always_inline to avoid an additional function call in vmalloc_to_page().

Move metadata teardown into kmsan_iounmap_pages().  Free the backing
blocks while their mappings are still available, then unmap each metadata
range once and flush its TLB entries.

Link: https://lore.kernel.org/20261002200508.546-1-dmytrokoziuk68@gmail.com
Fixes: b073d7f8aee4 ("mm: kmsan: maintain KMSAN metadata for page operations")
Signed-off-by: Dima Koziuk <dmytrokoziuk68@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Alexander Potapenko <glider@google.com>
Link: https://lkml.iu.edu/2609.3/12748.html
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
---

 mm/kmsan/core.c  |    8 ++-----
 mm/kmsan/hooks.c |   51 +++++++++++++++++++++++++++++----------------
 mm/vmalloc.c     |   21 +++++++++++-------
 mm/vmalloc.h     |    1 
 4 files changed, 50 insertions(+), 31 deletions(-)

--- a/mm/kmsan/core.c~mm-kmsan-fix-iounmap-metadata-teardown
+++ a/mm/kmsan/core.c
@@ -27,6 +27,7 @@
 #include <linux/vmalloc.h>
 
 #include "../slab.h"
+#include "../vmalloc.h"
 #include "kmsan.h"
 
 bool kmsan_enabled __read_mostly;
@@ -240,11 +241,8 @@ struct page *kmsan_vmalloc_to_page_or_nu
 {
 	struct page *page;
 
-	if (!kmsan_internal_is_vmalloc_addr(vaddr) &&
-	    !kmsan_internal_is_module_addr(vaddr))
-		return NULL;
-	page = vmalloc_to_page(vaddr);
-	if (pfn_valid(page_to_pfn(page)))
+	page = __vmalloc_to_page(vaddr);
+	if (page && pfn_valid(page_to_pfn(page)))
 		return page;
 	else
 		return NULL;
--- a/mm/kmsan/hooks.c~mm-kmsan-fix-iounmap-metadata-teardown
+++ a/mm/kmsan/hooks.c
@@ -20,6 +20,8 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 
+#include <asm/tlbflush.h>
+
 #include "../internal.h"
 #include "../vmalloc.h"
 #include "../slab.h"
@@ -142,6 +144,36 @@ void kmsan_vunmap_range_noflush(unsigned
 	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
 }
 
+#define KMSAN_IOREMAP_META_ORDER 1
+
+static void kmsan_iounmap_pages(unsigned long start, unsigned long end)
+{
+	unsigned long shadow_start = vmalloc_shadow(start),
+		      shadow_end = vmalloc_shadow(end);
+	unsigned long origin_start = vmalloc_origin(start),
+		      origin_end = vmalloc_origin(end);
+	unsigned long v_shadow, v_origin;
+	struct page *shadow, *origin;
+	int nr;
+
+	nr = (end - start) / PAGE_SIZE;
+	v_shadow = shadow_start;
+	v_origin = origin_start;
+	for (int i = 0; i < nr;
+	     i++, v_shadow += PAGE_SIZE, v_origin += PAGE_SIZE) {
+		shadow = kmsan_vmalloc_to_page_or_null((void *)v_shadow);
+		origin = kmsan_vmalloc_to_page_or_null((void *)v_origin);
+		if (shadow)
+			__free_pages(shadow, KMSAN_IOREMAP_META_ORDER);
+		if (origin)
+			__free_pages(origin, KMSAN_IOREMAP_META_ORDER);
+	}
+	__vunmap_range_noflush(shadow_start, shadow_end);
+	__vunmap_range_noflush(origin_start, origin_end);
+	flush_tlb_kernel_range(shadow_start, shadow_end);
+	flush_tlb_kernel_range(origin_start, origin_end);
+}
+
 /*
  * This function creates new shadow/origin pages for the physical pages mapped
  * into the virtual memory. If those physical pages already had shadow/origin,
@@ -219,28 +251,11 @@ ret:
 
 void kmsan_iounmap_page_range(unsigned long start, unsigned long end)
 {
-	unsigned long v_shadow, v_origin;
-	struct page *shadow, *origin;
-	int nr;
-
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
 
-	nr = (end - start) / PAGE_SIZE;
 	kmsan_enter_runtime();
-	v_shadow = (unsigned long)vmalloc_shadow(start);
-	v_origin = (unsigned long)vmalloc_origin(start);
-	for (int i = 0; i < nr;
-	     i++, v_shadow += PAGE_SIZE, v_origin += PAGE_SIZE) {
-		shadow = kmsan_vmalloc_to_page_or_null((void *)v_shadow);
-		origin = kmsan_vmalloc_to_page_or_null((void *)v_origin);
-		__vunmap_range_noflush(v_shadow, vmalloc_shadow(end));
-		__vunmap_range_noflush(v_origin, vmalloc_origin(end));
-		if (shadow)
-			__free_pages(shadow, 1);
-		if (origin)
-			__free_pages(origin, 1);
-	}
+	kmsan_iounmap_pages(start, end);
 	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
 	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
 	kmsan_leave_runtime();
--- a/mm/vmalloc.c~mm-kmsan-fix-iounmap-metadata-teardown
+++ a/mm/vmalloc.c
@@ -817,9 +817,10 @@ EXPORT_SYMBOL_GPL(is_vmalloc_or_module_a
 /*
  * Walk a vmap address to the struct page it maps. Huge vmap mappings will
  * return the tail page that corresponds to the base page address, which
- * matches small vmap mappings.
+ * matches small vmap mappings. Unlike vmalloc_to_page(), this also accepts
+ * addresses outside the vmalloc and module ranges, such as KMSAN metadata.
  */
-struct page *vmalloc_to_page(const void *vmalloc_addr)
+__always_inline struct page *__vmalloc_to_page(const void *vmalloc_addr)
 {
 	unsigned long addr = (unsigned long) vmalloc_addr;
 	struct page *page = NULL;
@@ -829,12 +830,6 @@ struct page *vmalloc_to_page(const void
 	pmd_t *pmd;
 	pte_t *ptep, pte;
 
-	/*
-	 * XXX we might need to change this if we add VIRTUAL_BUG_ON for
-	 * architectures that do not vmalloc module space
-	 */
-	VIRTUAL_BUG_ON(!is_vmalloc_or_module_addr(vmalloc_addr));
-
 	if (pgd_none(*pgd))
 		return NULL;
 	if (WARN_ON_ONCE(pgd_leaf(*pgd)))
@@ -873,6 +868,16 @@ struct page *vmalloc_to_page(const void
 
 	return page;
 }
+
+struct page *vmalloc_to_page(const void *vmalloc_addr)
+{
+	/*
+	 * XXX we might need to change this if we add VIRTUAL_BUG_ON for
+	 * architectures that do not vmalloc module space
+	 */
+	VIRTUAL_BUG_ON(!is_vmalloc_or_module_addr(vmalloc_addr));
+	return __vmalloc_to_page(vmalloc_addr);
+}
 EXPORT_SYMBOL(vmalloc_to_page);
 
 /*
--- a/mm/vmalloc.h~mm-kmsan-fix-iounmap-metadata-teardown
+++ a/mm/vmalloc.h
@@ -8,6 +8,7 @@
 #include <linux/vmalloc.h>
 
 #ifdef CONFIG_MMU
+struct page *__vmalloc_to_page(const void *vmalloc_addr);
 void __init vmalloc_init(void);
 int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages,
_

Patches currently in -mm which might be from dmytrokoziuk68@gmail.com are

mm-kmsan-fix-iounmap-metadata-teardown.patch
mm-kmsan-fix-ioremap-error-cleanup.patch

