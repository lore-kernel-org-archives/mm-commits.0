Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36D2219C9B
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019120; cv=none; b=kaDWc87UGraN53LVEAFGq6fXuPT8YlK+qGhHCcvmOyG2s+ftXbXf4ts40iQXB7Ap4ZpUsNbY//yD0wLns97ID/yTSPN95l69xUP+rwlEUojQW7kNmFK6XxdtyL0nEoY2BpNiOp1apGPEw8aRf7G4qIyVGsZ9gx6fdzylFAh9y38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019120; c=relaxed/simple;
	bh=Q1BZFMIuNYDjAgOCfTgysEtPgwEsSNxvJw4wejJauxg=;
	h=Date:To:From:Subject:Message-Id; b=spWoaFcOr0L8wDgppmiJqW4nLg/QSxa+MJDO563xybDLGBL/ZtlJYk+5JR3CPcGVmJ4hHsN4zUF3jtd2u5wB+lOwy6/mo1xpefVZ9r9xOwL4MqXfvqWALFD102Yue3BWD1PR76PI2NS1euVXrOQ01kdAoCsDOQ+LvY82FeLSzzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OlEh8qfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OlEh8qfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C83EC4CECC;
	Thu,  7 Nov 2024 22:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731019120;
	bh=Q1BZFMIuNYDjAgOCfTgysEtPgwEsSNxvJw4wejJauxg=;
	h=Date:To:From:Subject:From;
	b=OlEh8qfLDDBoRBZNmoA6/JxX8EoU7ohAdnpXVx+a6ZpvnEcYY0NOau/YP3rMUV4cT
	 VJInV1mqpSUK88Yt4JdRJ6KvO+MBNg3sPNLZNLDSWxG+k0pNchkjfRdNu5p2EuKruw
	 3jQBhdm64NGLQ9fDRXrc4zk9mcqAOxr/cb/0xpu0=
Date: Thu, 07 Nov 2024 14:38:39 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,arnd@arndb.de,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] bootmem-stop-using-page-index.patch removed from -mm tree
Message-Id: <20241107223840.3C83EC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bootmem: stop using page->index
has been removed from the -mm tree.  Its filename was
     bootmem-stop-using-page-index.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: bootmem: stop using page->index
Date: Sat, 5 Oct 2024 21:01:16 +0100

Encode the type into the bottom four bits of page->private and the info
into the remaining bits.  Also turn the bootmem type into a named enum.

[arnd@arndb.de: bootmem: add bootmem_type stub function]
  Link: https://lkml.kernel.org/r/20241015143802.577613-1-arnd@kernel.org
[akpm@linux-foundation.org: fix build with !CONFIG_HAVE_BOOTMEM_INFO_NODE]
 Link: https://lore.kernel.org/oe-kbuild-all/202410090311.eaqcL7IZ-lkp@intel.com/
Link: https://lkml.kernel.org/r/20241005200121.3231142-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c        |   28 +++++++++++++++++---------
 include/linux/bootmem_info.h |   35 +++++++++++++++++++++++++--------
 mm/bootmem_info.c            |   11 +++++-----
 mm/sparse.c                  |    8 +++----
 4 files changed, 56 insertions(+), 26 deletions(-)

--- a/arch/x86/mm/init_64.c~bootmem-stop-using-page-index
+++ a/arch/x86/mm/init_64.c
@@ -985,22 +985,32 @@ int arch_add_memory(int nid, u64 start,
 	return add_pages(nid, start_pfn, nr_pages, params);
 }
 
-static void __meminit free_pagetable(struct page *page, int order)
+static void free_reserved_pages(struct page *page, unsigned long nr_pages)
 {
-	unsigned long magic;
-	unsigned int nr_pages = 1 << order;
+	while (nr_pages--)
+		free_reserved_page(page++);
+}
 
+static void __meminit free_pagetable(struct page *page, int order)
+{
 	/* bootmem page has reserved flag */
 	if (PageReserved(page)) {
-		magic = page->index;
-		if (magic == SECTION_INFO || magic == MIX_SECTION_INFO) {
+		unsigned long nr_pages = 1 << order;
+#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
+		enum bootmem_type type = bootmem_type(page);
+
+		if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
 			while (nr_pages--)
 				put_page_bootmem(page++);
-		} else
-			while (nr_pages--)
-				free_reserved_page(page++);
-	} else
+		} else {
+			free_reserved_pages(page, nr_pages);
+		}
+#else
+		free_reserved_pages(page, nr_pages);
+#endif
+	} else {
 		free_pages((unsigned long)page_address(page), order);
+	}
 }
 
 static void __meminit free_hugepage_table(struct page *page,
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
@@ -53,8 +62,18 @@ static inline void put_page_bootmem(stru
 {
 }
 
+static inline enum bootmem_type bootmem_type(const struct page *page)
+{
+	return SECTION_INFO;
+}
+
+static inline unsigned long bootmem_info(const struct page *page)
+{
+	return 0;
+}
+
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


