Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E3E331EDF
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465753; cv=none; b=VZP2zmey4EblrVsse6r+T71zbrESwR+fjDEVcv4iKoSQ3PfFyfRU5GsEg9TTyZDcjttcejHUw0zkLPiOGm+8S4L/glgHogXO9wZ6/YHxkEL181Prs11SCxOJQJ7Ph7maWVUENtl0M8DgC2fSIdkqr/z55Ggg9udmxigDyFUoJVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465753; c=relaxed/simple;
	bh=c0fH2jKXdo2xu/v7ruC2XTkTseH7V2fyVRAp0mJ929k=;
	h=Date:To:From:Subject:Message-Id; b=Uoli5H3cYhzou3cRSDiVpywIRtMpRX21Sy33oB+G6zEJQLHsVWwTaMA69dDBoNweW6NJAfDBfkCm/YRaXDzMTVX+pUhG6ABiIMouYO4wul0GvKf1Beq4qPSLVSiDG1HEcKwCYw4iN7UyfcQp7XzdNFHeTFLXq1z9IMBE9spQABE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k4kGywgc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k4kGywgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8951F00A3D;
	Fri, 31 Jul 2026 02:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465750;
	bh=6MYE0JZtOeKgLyTApw7VyI55pKhu0sC7vzKHoT8cu1Y=;
	h=Date:To:From:Subject;
	b=k4kGywgcwio1f3To6kwJeayRdLJvVcKx+hMc2LWbHi5gPm2ezGuwxTEJje0GYRIuq
	 L+Zk9cZjZJpl1knV7LfZ5m9LEUHJZm9hx6DY+hqE9UbkTnf73xyS4NaLBLcQrr0QVo
	 s3jtdiTTYOcKwcP1GjF3/QtAcX5zjLVg66tiu/Fs=
Date: Thu, 30 Jul 2026 19:42:29 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer.patch removed from -mm tree
Message-Id: <20260731024230.3A8951F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix ASSERT_EXCLUSIVE_BITS by passing memdesc_flags_t by pointer
has been removed from the -mm tree.  Its filename was
     mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm: fix ASSERT_EXCLUSIVE_BITS by passing memdesc_flags_t by pointer
Date: Tue, 30 Jun 2026 15:08:10 +0800

KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
page->flags and folio_trylock()/folio_lock() concurrently doing
test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:

  BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp

The race is benign: nid/zone bits are set once at page init and never
overlap with PG_locked.  However, ASSERT_EXCLUSIVE_BITS() inside
memdesc_nid/zonenum() was checking a by-value copy of the flags word, not
the live page->flags, so it failed to annotate the real access.

Change memdesc_nid(), memdesc_zonenum(), memdesc_section(), and
memdesc_is_zone_device() to take a const memdesc_flags_t * and update all
callers to pass &page->flags / &folio->flags, so ASSERT_EXCLUSIVE_BITS()
operates on the actual shared word.

Guard the ASSERT_EXCLUSIVE_BITS() call in memdesc_zonenum() under
ZONES_WIDTH != 0 to avoid a zero-mask check on configs where the zone
field is absent.  memdesc_section() needs no such guard, since
SECTIONS_WIDTH is never 0 wherever SECTION_IN_PAGE_FLAGS is defined. 
Under CONFIG_NUMA=n, memdesc_nid() itself is stubbed to "return 0" instead
of reading page->flags, since NODES_MASK is 0 and the check can never
fire; page_to_nid()/folio_nid() now just call memdesc_nid()
unconditionally and rely on that stub, instead of duplicating the
CONFIG_NUMA split at each call site.

[zhuhui@kylinos.cn: v11]
  Link: https://lore.kernel.org/20260708083308.747930-1-hui.zhu@linux.dev
[ziy@nvidia.com: build fix]
  Link: https://lore.kernel.org/DJSGLP9VFLRI.355AAWR2VHIEL@nvidia.com
Link: https://lore.kernel.org/20260630070810.470763-1-hui.zhu@linux.dev
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/memory_model.h |    2 +-
 include/linux/mm.h                 |   26 ++++++++++++++++++--------
 include/linux/mm_inline.h          |    4 ++--
 include/linux/mmzone.h             |   26 ++++++++++++++------------
 mm/page_alloc.c                    |    6 +++---
 mm/page_owner.c                    |    2 +-
 mm/slab.h                          |    2 +-
 mm/sparse.c                        |    2 +-
 8 files changed, 41 insertions(+), 29 deletions(-)

--- a/include/asm-generic/memory_model.h~mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer
+++ a/include/asm-generic/memory_model.h
@@ -53,7 +53,7 @@ static inline int pfn_valid(unsigned lon
  */
 #define __page_to_pfn(pg)					\
 ({	const struct page *__pg = (pg);				\
-	int __sec = memdesc_section(__pg->flags);		\
+	int __sec = memdesc_section(&__pg->flags);		\
 	(unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec)));	\
 })
 
--- a/include/linux/mm.h~mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer
+++ a/include/linux/mm.h
@@ -37,6 +37,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
+#include <linux/kcsan-checks.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -2286,22 +2287,30 @@ static inline int page_zone_id(struct pa
 }
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
-int memdesc_nid(memdesc_flags_t mdf);
+int memdesc_nid(const memdesc_flags_t *mdf);
 #else
-static inline int memdesc_nid(memdesc_flags_t mdf)
+#ifdef CONFIG_NUMA
+static inline int memdesc_nid(const memdesc_flags_t *mdf)
+{
+	ASSERT_EXCLUSIVE_BITS(mdf->f, NODES_MASK << NODES_PGSHIFT);
+	return (mdf->f >> NODES_PGSHIFT) & NODES_MASK;
+}
+#else
+static inline int memdesc_nid(const memdesc_flags_t *mdf)
 {
-	return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
+	return 0;
 }
 #endif
+#endif
 
 static inline int page_to_nid(const struct page *page)
 {
-	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
+	return memdesc_nid(&(PF_POISONED_CHECK(page)->flags));
 }
 
 static inline int folio_nid(const struct folio *folio)
 {
-	return memdesc_nid(folio->flags);
+	return memdesc_nid(&folio->flags);
 }
 
 #ifdef CONFIG_NUMA_BALANCING
@@ -2541,12 +2550,13 @@ static inline void set_page_section(stru
 	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
 }
 
-static inline unsigned long memdesc_section(memdesc_flags_t mdf)
+static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
 {
-	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
+	ASSERT_EXCLUSIVE_BITS(mdf->f, SECTIONS_MASK << SECTIONS_PGSHIFT);
+	return (mdf->f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
 #else /* !SECTION_IN_PAGE_FLAGS */
-static inline unsigned long memdesc_section(memdesc_flags_t mdf)
+static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
 {
 	return 0;
 }
--- a/include/linux/mm_inline.h~mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer
+++ a/include/linux/mm_inline.h
@@ -650,7 +650,7 @@ static inline bool vma_has_recency(const
 static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
 {
 	struct page *cur_page = pages[0];
-	unsigned long section = memdesc_section(cur_page->flags);
+	unsigned long section = memdesc_section(&cur_page->flags);
 	size_t i;
 
 	for (i = 1; i < nr_pages; i++) {
@@ -660,7 +660,7 @@ static inline size_t num_pages_contiguou
 		 * In unproblematic kernel configs, page_to_section() == 0 and
 		 * the whole check will get optimized out.
 		 */
-		if (memdesc_section(cur_page->flags) != section)
+		if (memdesc_section(&cur_page->flags) != section)
 			break;
 	}
 
--- a/include/linux/mmzone.h~mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer
+++ a/include/linux/mmzone.h
@@ -1272,31 +1272,33 @@ static inline bool zone_is_empty(const s
 #define KASAN_TAG_MASK		((1UL << KASAN_TAG_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
-static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
+static inline enum zone_type memdesc_zonenum(const memdesc_flags_t *flags)
 {
-	ASSERT_EXCLUSIVE_BITS(flags.f, ZONES_MASK << ZONES_PGSHIFT);
-	return (flags.f >> ZONES_PGSHIFT) & ZONES_MASK;
+#if ZONES_WIDTH != 0
+	ASSERT_EXCLUSIVE_BITS(flags->f, ZONES_MASK << ZONES_PGSHIFT);
+#endif
+	return (flags->f >> ZONES_PGSHIFT) & ZONES_MASK;
 }
 
 static inline enum zone_type page_zonenum(const struct page *page)
 {
-	return memdesc_zonenum(page->flags);
+	return memdesc_zonenum(&page->flags);
 }
 
 static inline enum zone_type folio_zonenum(const struct folio *folio)
 {
-	return memdesc_zonenum(folio->flags);
+	return memdesc_zonenum(&folio->flags);
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static inline bool memdesc_is_zone_device(memdesc_flags_t mdf)
+static inline bool memdesc_is_zone_device(const memdesc_flags_t *mdf)
 {
 	return memdesc_zonenum(mdf) == ZONE_DEVICE;
 }
 
 static inline struct dev_pagemap *page_pgmap(const struct page *page)
 {
-	VM_WARN_ON_ONCE_PAGE(!memdesc_is_zone_device(page->flags), page);
+	VM_WARN_ON_ONCE_PAGE(!memdesc_is_zone_device(&page->flags), page);
 	return page_folio(page)->pgmap;
 }
 
@@ -1311,9 +1313,9 @@ static inline struct dev_pagemap *page_p
 static inline bool zone_device_pages_have_same_pgmap(const struct page *a,
 						     const struct page *b)
 {
-	if (memdesc_is_zone_device(a->flags) != memdesc_is_zone_device(b->flags))
+	if (memdesc_is_zone_device(&a->flags) != memdesc_is_zone_device(&b->flags))
 		return false;
-	if (!memdesc_is_zone_device(a->flags))
+	if (!memdesc_is_zone_device(&a->flags))
 		return true;
 	return page_pgmap(a) == page_pgmap(b);
 }
@@ -1321,7 +1323,7 @@ static inline bool zone_device_pages_hav
 extern void memmap_init_zone_device(struct zone *, unsigned long,
 				    unsigned long, struct dev_pagemap *);
 #else
-static inline bool memdesc_is_zone_device(memdesc_flags_t mdf)
+static inline bool memdesc_is_zone_device(const memdesc_flags_t *mdf)
 {
 	return false;
 }
@@ -1338,12 +1340,12 @@ static inline struct dev_pagemap *page_p
 
 static inline bool is_zone_device_page(const struct page *page)
 {
-	return memdesc_is_zone_device(page->flags);
+	return memdesc_is_zone_device(&page->flags);
 }
 
 static inline bool folio_is_zone_device(const struct folio *folio)
 {
-	return memdesc_is_zone_device(folio->flags);
+	return memdesc_is_zone_device(&folio->flags);
 }
 
 static inline bool is_zone_movable_page(const struct page *page)
--- a/mm/page_alloc.c~mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer
+++ a/mm/page_alloc.c
@@ -6913,15 +6913,15 @@ static void __free_contig_range_common(u
 			continue;
 		}
 
-		if (start && memdesc_section(page->flags) != start_sec) {
+		if (start && memdesc_section(&page->flags) != start_sec) {
 			free_prepared_contig_range(start, i - nr_start);
 			start = page;
 			nr_start = i;
-			start_sec = memdesc_section(page->flags);
+			start_sec = memdesc_section(&page->flags);
 		} else if (!start) {
 			start = page;
 			nr_start = i;
-			start_sec = memdesc_section(page->flags);
+			start_sec = memdesc_section(&page->flags);
 		}
 	}
 
--- a/mm/page_owner.c~mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer
+++ a/mm/page_owner.c
@@ -815,7 +815,7 @@ read_page_owner(struct file *file, char
 			 */
 			if (page_flags.f == PAGE_POISON_PATTERN)
 				goto ext_put_continue;
-			nid = memdesc_nid(page_flags);
+			nid = memdesc_nid(&page_flags);
 			if (!node_isset(nid, state->nid_filter))
 				goto ext_put_continue;
 		}
--- a/mm/slab.h~mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer
+++ a/mm/slab.h
@@ -180,7 +180,7 @@ static inline void *slab_address(const s
 
 static inline int slab_nid(const struct slab *slab)
 {
-	return memdesc_nid(slab->flags);
+	return memdesc_nid(&slab->flags);
 }
 
 static inline pg_data_t *slab_pgdat(const struct slab *slab)
--- a/mm/sparse.c~mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer
+++ a/mm/sparse.c
@@ -43,7 +43,7 @@ static u8 section_to_node_table[NR_MEM_S
 static u16 section_to_node_table[NR_MEM_SECTIONS] __cacheline_aligned;
 #endif
 
-int memdesc_nid(memdesc_flags_t mdf)
+int memdesc_nid(const memdesc_flags_t *mdf)
 {
 	return section_to_node_table[memdesc_section(mdf)];
 }
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are


