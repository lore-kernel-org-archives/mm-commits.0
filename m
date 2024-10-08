Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220B9EC4
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 01:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352571; cv=none; b=Z+lmV1/Pi/HpF6i7FERJM2EfZeX3yV9Hhq84slx7ksMb3UbC3VvLaPe3PH5cP0L1fHluaYLUepoErJvI31XKHmvmva4epMTlEzrT7XzpxJkCwC9JdXNqHLtR95AmznvcJ81y9SGUBwKEC+z105JJsEedczIRnf7VqCewAQGQ12c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352571; c=relaxed/simple;
	bh=RqKAPUE8ZVeY238Xj5sOkSg0ov1cumKofmegQn5giAo=;
	h=Date:To:From:Subject:Message-Id; b=rt2b3XHADwccQHS6szE5R5welb9XITBhhJV+aCylK53gnZxZMQ/BP2yaCyTGkBUiymsBToO3TQ3jAKxzj0opKtEZ1VGqBuLmH9zWBAFje+tUDNnM1l2OxESVNzHpm7tSEtYKyCA7+Nk9aaoB69MeQHoMtmF/98anJuYmqWVs1b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=toUJV0uN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="toUJV0uN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E89C4CEC6;
	Tue,  8 Oct 2024 01:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728352571;
	bh=RqKAPUE8ZVeY238Xj5sOkSg0ov1cumKofmegQn5giAo=;
	h=Date:To:From:Subject:From;
	b=toUJV0uNfMJUE/qiSCLLexO6ABtAulwzF1HqQkfocQJ1LTNqnf0ZmgkXF28rc/XN+
	 Odv86bO60LDuRto516VDUp8gHDEb4P1PH2k6HyQLCXBM7IoYaNQyaoMLREkc97cA8h
	 mjkZ20M1JvdOB/oYoNpZCkoQgzDomTdk8u8VrjQw=
Date: Mon, 07 Oct 2024 18:56:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bootmem-stop-using-page-index.patch added to mm-unstable branch
Message-Id: <20241008015610.E9E89C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bootmem: stop using page->index
has been added to the -mm mm-unstable branch.  Its filename is
     bootmem-stop-using-page-index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bootmem-stop-using-page-index.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: bootmem: stop using page->index
Date: Sat, 5 Oct 2024 21:01:16 +0100

Encode the type into the bottom four bits of page->private and the info
into the remaining bits.  Also turn the bootmem type into a named enum.

Link: https://lkml.kernel.org/r/20241005200121.3231142-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c        |    9 ++++-----
 include/linux/bootmem_info.h |   25 +++++++++++++++++--------
 mm/bootmem_info.c            |   11 ++++++-----
 mm/sparse.c                  |    8 ++++----
 4 files changed, 31 insertions(+), 22 deletions(-)

--- a/arch/x86/mm/init_64.c~bootmem-stop-using-page-index
+++ a/arch/x86/mm/init_64.c
@@ -987,13 +987,12 @@ int arch_add_memory(int nid, u64 start,
 
 static void __meminit free_pagetable(struct page *page, int order)
 {
-	unsigned long magic;
-	unsigned int nr_pages = 1 << order;
-
 	/* bootmem page has reserved flag */
 	if (PageReserved(page)) {
-		magic = page->index;
-		if (magic == SECTION_INFO || magic == MIX_SECTION_INFO) {
+		enum bootmem_type type = bootmem_type(page);
+		unsigned long nr_pages = 1 << order;
+
+		if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
 			while (nr_pages--)
 				put_page_bootmem(page++);
 		} else
--- a/include/linux/bootmem_info.h~bootmem-stop-using-page-index
+++ a/include/linux/bootmem_info.h
@@ -6,11 +6,10 @@
 #include <linux/kmemleak.h>
 
 /*
- * Types for free bootmem stored in page->lru.next. These have to be in
- * some random range in unsigned long space for debugging purposes.
+ * Types for free bootmem stored in the low bits of page->private.
  */
-enum {
-	MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE = 12,
+enum bootmem_type {
+	MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE = 1,
 	SECTION_INFO = MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE,
 	MIX_SECTION_INFO,
 	NODE_INFO,
@@ -21,9 +20,19 @@ enum {
 void __init register_page_bootmem_info_node(struct pglist_data *pgdat);
 
 void get_page_bootmem(unsigned long info, struct page *page,
-		      unsigned long type);
+		enum bootmem_type type);
 void put_page_bootmem(struct page *page);
 
+static inline enum bootmem_type bootmem_type(const struct page *page)
+{
+	return (unsigned long)page->private & 0xf;
+}
+
+static inline unsigned long bootmem_info(const struct page *page)
+{
+	return (unsigned long)page->private >> 4;
+}
+
 /*
  * Any memory allocated via the memblock allocator and not via the
  * buddy will be marked reserved already in the memmap. For those
@@ -31,7 +40,7 @@ void put_page_bootmem(struct page *page)
  */
 static inline void free_bootmem_page(struct page *page)
 {
-	unsigned long magic = page->index;
+	enum bootmem_type type = bootmem_type(page);
 
 	/*
 	 * The reserve_bootmem_region sets the reserved flag on bootmem
@@ -39,7 +48,7 @@ static inline void free_bootmem_page(str
 	 */
 	VM_BUG_ON_PAGE(page_ref_count(page) != 2, page);
 
-	if (magic == SECTION_INFO || magic == MIX_SECTION_INFO)
+	if (type == SECTION_INFO || type == MIX_SECTION_INFO)
 		put_page_bootmem(page);
 	else
 		VM_BUG_ON_PAGE(1, page);
@@ -54,7 +63,7 @@ static inline void put_page_bootmem(stru
 }
 
 static inline void get_page_bootmem(unsigned long info, struct page *page,
-				    unsigned long type)
+				    enum bootmem_type type)
 {
 }
 
--- a/mm/bootmem_info.c~bootmem-stop-using-page-index
+++ a/mm/bootmem_info.c
@@ -14,23 +14,24 @@
 #include <linux/memory_hotplug.h>
 #include <linux/kmemleak.h>
 
-void get_page_bootmem(unsigned long info, struct page *page, unsigned long type)
+void get_page_bootmem(unsigned long info, struct page *page,
+		enum bootmem_type type)
 {
-	page->index = type;
+	BUG_ON(type > 0xf);
+	BUG_ON(info > (ULONG_MAX >> 4));
 	SetPagePrivate(page);
-	set_page_private(page, info);
+	set_page_private(page, info << 4 | type);
 	page_ref_inc(page);
 }
 
 void put_page_bootmem(struct page *page)
 {
-	unsigned long type = page->index;
+	enum bootmem_type type = bootmem_type(page);
 
 	BUG_ON(type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
 	       type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE);
 
 	if (page_ref_dec_return(page) == 1) {
-		page->index = 0;
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
 		INIT_LIST_HEAD(&page->lru);
--- a/mm/sparse.c~bootmem-stop-using-page-index
+++ a/mm/sparse.c
@@ -720,19 +720,19 @@ static void depopulate_section_memmap(un
 static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long maps_section_nr, removing_section_nr, i;
-	unsigned long magic, nr_pages;
+	unsigned long type, nr_pages;
 	struct page *page = virt_to_page(memmap);
 
 	nr_pages = PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
 		>> PAGE_SHIFT;
 
 	for (i = 0; i < nr_pages; i++, page++) {
-		magic = page->index;
+		type = bootmem_type(page);
 
-		BUG_ON(magic == NODE_INFO);
+		BUG_ON(type == NODE_INFO);
 
 		maps_section_nr = pfn_to_section_nr(page_to_pfn(page));
-		removing_section_nr = page_private(page);
+		removing_section_nr = bootmem_info(page);
 
 		/*
 		 * When this function is called, the removing section is
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-add-pageanonnotksm-fix.patch
mm-remove-pageksm.patch
gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch
mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch

