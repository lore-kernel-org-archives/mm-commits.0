Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773443FA5CA
	for <mm-commits@vger.kernel.org>; Wed,  8 Jul 2026 21:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783545931; cv=none; b=CAWlWg9Ux+N1ZeBFDhvskkqKt4DVFUfVXoqp77uuYIfK3FSk3LxJavGkcMZmida3RqINZuZ7w8Oi7Vva7QjYsh4ToxkbFOfzNGBcOlbpyhilxZx/SbbCR4uyrYj5E0egt6g2B4Tz/+lVqt39m00ZIoOG8sCnYttMUHvvI+e3ADc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783545931; c=relaxed/simple;
	bh=G6vC4UBrZdZ8D+CMBoepWWxYOCF803KHhCO5GekHnhU=;
	h=Date:To:From:Subject:Message-Id; b=f84HFHVZDBUKrF+cr4YiTyARHm3OhbkSXbAFYlzTfya8EOZkhbpHT/6HQIyrZIRoKslDkNss5Nk91GbpoPd67F3/E7LPs+wrXhfitrkb7TNdXWa1Yn47S2JqcOYn9CkRustVczcddUQy/vOkM2Gf9zAKZ6MuqRLXUg/lOKtCNhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a2FpvFo2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a2FpvFo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121C41F00A3A;
	Wed,  8 Jul 2026 21:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783545929;
	bh=A1KWtCJ3ZAlCrJkHWPUR2KSEDKbBvWSl/tokZ+cJHgY=;
	h=Date:To:From:Subject;
	b=a2FpvFo2SMqghJWRewM8MYcDs9erMudBYtmGPojX66WjY4Ta4fLGwKH6a9UAXNCff
	 THUYbi6D+EbqFb42BXWyolV2SIrWkrz2J3fi1ngaxU5+wJIh5zL+U6nLWOBJwCjXCQ
	 U22aYiSU/5+OSqHg4VTy4tucM1yqscrVPYSmgrD4=
Date: Wed, 08 Jul 2026 14:25:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hpa@zytor.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,bp@alien8.de,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-provide-free_reserved_pages-removing-x86-variant.patch added to mm-new branch
Message-Id: <20260708212529.121C41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: provide free_reserved_pages(), removing x86 variant
has been added to the -mm mm-new branch.  Its filename is
     mm-provide-free_reserved_pages-removing-x86-variant.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-provide-free_reserved_pages-removing-x86-variant.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: provide free_reserved_pages(), removing x86 variant
Date: Wed, 08 Jul 2026 16:10:57 +0200

Let's extend free_reserved_page() in page_alloc.c to
free_reserved_pages(), dropping the custom x86 variant.  The common-code
variant will consume an order, so adjust the x86 callers accordingly.

Make free_reserved_pages() assume that we are freeing ordinary high-order
pages, just with the special "reserved" flavor.  The target use case for
now is freeing vmemmap PMD pages.

Set the refcount directly to 0 (instead of 1) and call
__free_frozen_pages().  Add some kerneldoc.  Use a single
adjust_managed_page_count() call.

Link: https://lore.kernel.org/20260708-bootmem_info_part2-v1-2-156ce4986598@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    8 +-------
 include/linux/mm.h    |    8 ++++++--
 mm/page_alloc.c       |   33 ++++++++++++++++++++++++++-------
 3 files changed, 33 insertions(+), 16 deletions(-)

--- a/arch/x86/mm/init_64.c~mm-provide-free_reserved_pages-removing-x86-variant
+++ a/arch/x86/mm/init_64.c
@@ -1000,12 +1000,6 @@ int arch_add_memory(int nid, u64 start,
 	return add_pages(nid, start_pfn, nr_pages, params);
 }
 
-static void free_reserved_pages(struct page *page, unsigned long nr_pages)
-{
-	while (nr_pages--)
-		free_reserved_page(page++);
-}
-
 static void __meminit free_pagetable(struct page *page)
 {
 	/* bootmem page has reserved flag */
@@ -1038,7 +1032,7 @@ static void __meminit free_vmemmap_pages
 			while (nr_pages--)
 				put_page_bootmem(page++);
 		} else {
-			free_reserved_pages(page, nr_pages);
+			free_reserved_pages(page, order);
 		}
 	} else {
 		__free_pages(page, order);
--- a/include/linux/mm.h~mm-provide-free_reserved_pages-removing-x86-variant
+++ a/include/linux/mm.h
@@ -3993,8 +3993,12 @@ extern unsigned long free_reserved_area(
 
 extern void adjust_managed_page_count(struct page *page, long count);
 
-/* Free the reserved page into the buddy system, so it gets managed. */
-void free_reserved_page(struct page *page);
+void free_reserved_pages(struct page *page, unsigned int order);
+
+static inline void free_reserved_page(struct page *page)
+{
+	free_reserved_pages(page, 0);
+}
 
 static inline void mark_page_reserved(struct page *page)
 {
--- a/mm/page_alloc.c~mm-provide-free_reserved_pages-removing-x86-variant
+++ a/mm/page_alloc.c
@@ -6388,15 +6388,34 @@ void adjust_managed_page_count(struct pa
 }
 EXPORT_SYMBOL(adjust_managed_page_count);
 
-void free_reserved_page(struct page *page)
+/**
+ * free_reserved_pages - free reserved pages
+ * @page: First page to free.
+ * @order: The page order to free.
+ *
+ * Free pages allocated through memblock during boot, letting the buddy
+ * manage them from now on.
+ *
+ * @page must be naturally aligned to the order and the order must not
+ * exceed MAX_PAGE_ORDER. All pages must be reserved.
+ */
+void free_reserved_pages(struct page *page, unsigned int order)
 {
-	clear_page_tag_ref(page);
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	adjust_managed_page_count(page, 1);
+	const unsigned long nr_pages = 1UL << order;
+	int i;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(page_to_pfn(page), nr_pages));
+	VM_WARN_ON_ONCE(order > MAX_PAGE_ORDER);
+
+	for (i = 0; i < nr_pages; i++) {
+		clear_page_tag_ref(page + i);
+		ClearPageReserved(page + i);
+		set_page_count(page + i, 0);
+	}
+	adjust_managed_page_count(page, nr_pages);
+	__free_frozen_pages(page, order, FPI_NONE);
 }
-EXPORT_SYMBOL(free_reserved_page);
+EXPORT_SYMBOL(free_reserved_pages);
 
 static int page_alloc_cpu_dead(unsigned int cpu)
 {
_

Patches currently in -mm which might be from david@kernel.org are

sparc-mm-drop-custom-pte_clear_not_present_full.patch
mm-drop-pte_clear_not_present_full.patch
mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch
x86-mm-drop-order-parameter-from-free_pagetable.patch
mm-provide-free_reserved_pages-removing-x86-variant.patch
s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch
mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch
x86-mm-stop-marking-vmemmap-as-section_info.patch
x86-mm-stop-marking-page-tables-as-mix_section_info.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch

