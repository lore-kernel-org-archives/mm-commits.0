Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C37F2609E3
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 03:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961501; cv=none; b=tuCgeiaC/rUTHRIdGoJdMrhCjk4Cmzt/DO7Bkah4H6c5MjuBy136k3qiouUkB8rXrlflcLe0a8tZisJYKOLE3Z7EK2lA8RP1udb5tn2MOo719zLZ+9q7Ao3YuFlE/OZSMPMH6ISYOiUyyRPuJOFx1c0/ZsH9KhSol+Fio+ss2rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961501; c=relaxed/simple;
	bh=3dINcsqTb/hivQdjInNZEdBo5mmwUVNVZbfuX4RjyjQ=;
	h=Date:To:From:Subject:Message-Id; b=bT9HBsPVJChJBqohqx6DgYM6VqGidAwmysFQZmT0mj1wJyXIR0eUpOkKXcYsgyoJTyJB81z0F47qgvKgZ7eI9awigfa6Z5Dw224OdUT3RIC8RVh2bzEbD6WG7pmug3WMzH1giT4bxXZtkRP+5GCDTtbfpmnDWjc4FRRaXSWVfZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=od7uToNl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="od7uToNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DA51F000FF;
	Mon, 21 Sep 2026 03:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789961499;
	bh=4Bo7/2tE3nxdBlbIq5NUG8+mokZvzEqniyYjKTTpd2k=;
	h=Date:To:From:Subject;
	b=od7uToNl8p0+14NomRoz8/c1V4wjtW0n8X7P3vc8DVcesMlP5mUOne4v29tljlP+C
	 /kf8Ei+lpVICWOw/bwQAPkUN7FlooJ6vMgZ7kq8w3M6hbuB6FzoRCEK5qhZXSh8Dwi
	 jUnW7lp8rO8yiwtCNX7BJb/NSiOMu2uHEL/uJBYc=
Date: Sun, 20 Sep 2026 20:31:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page-flags-check-page-folio-private-instead-of-pg_private.patch removed from -mm tree
Message-Id: <20260921033139.D3DA51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page-flags: check page/folio->private instead of PG_private
has been removed from the -mm tree.  Its filename was
     mm-page-flags-check-page-folio-private-instead-of-pg_private.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page-flags: check page/folio->private instead of PG_private
Date: Sun, 13 Sep 2026 22:24:08 -0400

After the changes of the prior commits, page/folio->private != NULL is now
equivalent to checking PG_private.

Stop checking PG_private on pages and folios and use page/folio->private
instead, except swapcache and hugetlb folios, because the former uses a
field (swp_entry_t swap) overlapping with ->private and the latter sets
its flags in ->private.  Exclude swapcache and hugetlb when the code is
meant to check PG_private only.  PG_swapcache and folio->swap.val cannot
be set/clear as a whole, so excluding swapcache with
folio_test_swapcache() is not reliable.  Instead, use
folio_test_swapbacked(), since PG_swapbacked is stable when a folio is
added to/removed from swapcache.  Add a helper,
folio_has_attached_private(), for this check.

folio_expected_ref_count() can be called without folio lock, so annotate
folio_test_private() with data_race() to avoid triggering race condition
checks.  While at it, annotate folio->mapping too.  Add data_race()
annotation for other lockless callers too.

folio_set/clear_private() and Set/ClearPagePrivate() become no-ops. 
PG_private is no longer checked at page free time.

Remove KPF_PRIVATE since PG_private is no longer used.

Assisted-by: LLM
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-10-848550f7574e@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
---

 fs/proc/page.c                    |    1 
 include/linux/kernel-page-flags.h |    1 
 include/linux/mm.h                |   20 +++++++-----
 include/linux/page-flags.h        |   46 ++++++++++++++++++++++++----
 include/trace/events/pagemap.h    |    3 +
 mm/huge_memory.c                  |    3 +
 mm/migrate.c                      |    2 -
 mm/page-writeback.c               |    3 +
 mm/vmscan.c                       |    2 -
 tools/mm/page-types.c             |    2 -
 10 files changed, 62 insertions(+), 21 deletions(-)

--- a/fs/proc/page.c~mm-page-flags-check-page-folio-private-instead-of-pg_private
+++ a/fs/proc/page.c
@@ -232,7 +232,6 @@ u64 stable_page_flags(const struct page
 
 	u |= kpf_copy_bit(k, KPF_RESERVED,	PG_reserved);
 	u |= kpf_copy_bit(k, KPF_OWNER_2,	PG_owner_2);
-	u |= kpf_copy_bit(k, KPF_PRIVATE,	PG_private);
 	u |= kpf_copy_bit(k, KPF_PRIVATE_2,	PG_private_2);
 	u |= kpf_copy_bit(k, KPF_OWNER_PRIVATE,	PG_owner_priv_1);
 	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
--- a/include/linux/kernel-page-flags.h~mm-page-flags-check-page-folio-private-instead-of-pg_private
+++ a/include/linux/kernel-page-flags.h
@@ -11,7 +11,6 @@
 #define KPF_RESERVED		32
 #define KPF_MLOCKED		33
 #define KPF_OWNER_2		34
-#define KPF_PRIVATE		35
 #define KPF_PRIVATE_2		36
 #define KPF_OWNER_PRIVATE	37
 #define KPF_ARCH		38
--- a/include/linux/mm.h~mm-page-flags-check-page-folio-private-instead-of-pg_private
+++ a/include/linux/mm.h
@@ -3004,9 +3004,9 @@ static inline bool folio_maybe_mapped_sh
  * @folio: the folio
  *
  * Calculate the expected folio refcount, taking references from the pagecache,
- * swapcache, PG_private and page table mappings into account. Useful in
- * combination with folio_ref_count() to detect unexpected references (e.g.,
- * GUP or other temporary references).
+ * swapcache, private data (folio->private != NULL) and page table mappings into
+ * account. Useful in combination with folio_ref_count() to detect unexpected
+ * references (e.g., GUP or other temporary references).
  *
  * Does currently not consider references from the LRU cache. If the folio
  * was isolated from the LRU (which is the case during migration or split),
@@ -3044,10 +3044,16 @@ static inline int folio_expected_ref_cou
 	ref_count += folio_test_swapcache(folio) << order;
 
 	if (!folio_test_anon(folio)) {
-		/* One reference per page from the pagecache. */
-		ref_count += !!folio->mapping << order;
-		/* One reference from PG_private. */
-		ref_count += folio_test_private(folio);
+		/*
+		 * One reference per page from the pagecache.
+		 * Use data_race() since folio might not be locked.
+		 */
+		ref_count += !!data_race(folio->mapping) << order;
+		/*
+		 * One reference from filesystem private data.
+		 * Use data_race() since folio might not be locked.
+		 */
+		ref_count += data_race(folio_has_attached_private(folio));
 	}
 
 	/* One reference per page table mapping. */
--- a/include/linux/page-flags.h~mm-page-flags-check-page-folio-private-instead-of-pg_private
+++ a/include/linux/page-flags.h
@@ -577,7 +577,23 @@ FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
  * for its own purposes.
  * - PG_private and PG_private_2 cause release_folio() and co to be invoked
  */
-PAGEFLAG(Private, private, PF_ANY)
+
+static __always_inline bool folio_test_private(const struct folio *folio)
+{
+	return folio->private;
+}
+
+static __always_inline int PagePrivate(const struct page *page)
+{
+	return !!page->private;
+}
+
+/* no-ops during transition */
+static __always_inline void folio_set_private(struct folio *folio) { }
+static __always_inline void folio_clear_private(struct folio *folio) { }
+static __always_inline void SetPagePrivate(struct page *page) { }
+static __always_inline void ClearPagePrivate(struct page *page) { }
+
 FOLIO_FLAG(private_2, FOLIO_HEAD_PAGE)
 
 /* owner_2 can be set on tail pages for anon memory */
@@ -1169,7 +1185,7 @@ static __always_inline void __ClearPageA
  */
 #define PAGE_FLAGS_CHECK_AT_FREE				\
 	(1UL << PG_lru		| 1UL << PG_locked	|	\
-	 1UL << PG_private	| 1UL << PG_private_2	|	\
+	 1UL << PG_private_2	|				\
 	 1UL << PG_writeback	| 1UL << PG_reserved	|	\
 	 1UL << PG_active 	|				\
 	 1UL << PG_unevictable	| __PG_MLOCKED | LRU_GEN_MASK)
@@ -1193,8 +1209,28 @@ static __always_inline void __ClearPageA
 	(0xffUL /* order */		| 1UL << PG_has_hwpoisoned |	\
 	 1UL << PG_large_rmappable	| 1UL << PG_partially_mapped)
 
-#define PAGE_FLAGS_PRIVATE				\
-	(1UL << PG_private | 1UL << PG_private_2)
+/**
+ * folio_has_attached_private - check if the folio has private data attached
+ * @folio: The folio to check.
+ *
+ * Use this in code that may encounter swapcache or hugetlb folios but only
+ * wants to detect attached private data. Swapcache stores swp_entry_t in
+ * folio->swap, a union with folio->private, and hugetlb stores its own flags
+ * in folio->private; both are excluded.
+ *
+ * NOTE: For swapcache, folio->swap.val PG_swapcache are not set as a whole,
+ * so folio_test_swapcache() is not reliable to exclude swapcache.
+ * Use folio_test_swapbacked() instead, since it remains set when a folio is
+ * added to/removed from swapcache.
+ *
+ * Return: true if folio->private is set and the folio is neither swapcache
+ * nor hugetlb.
+ */
+static inline bool folio_has_attached_private(const struct folio *folio)
+{
+	return folio_test_private(folio) && !folio_test_swapbacked(folio) &&
+	       !folio_test_hugetlb(folio);
+}
 /**
  * folio_has_private - Determine if folio has private stuff
  * @folio: The folio to be checked
@@ -1204,7 +1240,7 @@ static __always_inline void __ClearPageA
  */
 static inline int folio_has_private(const struct folio *folio)
 {
-	return !!(folio->flags.f & PAGE_FLAGS_PRIVATE);
+	return folio_has_attached_private(folio) || folio_test_private_2(folio);
 }
 
 #undef PF_ANY
--- a/include/trace/events/pagemap.h~mm-page-flags-check-page-folio-private-instead-of-pg_private
+++ a/include/trace/events/pagemap.h
@@ -22,7 +22,8 @@
 	(folio_test_swapcache(folio)	? PAGEMAP_SWAPCACHE  : 0) | \
 	(folio_test_swapbacked(folio)	? PAGEMAP_SWAPBACKED : 0) | \
 	(folio_test_mappedtodisk(folio)	? PAGEMAP_MAPPEDDISK : 0) | \
-	(folio_test_private(folio)	? PAGEMAP_BUFFERS    : 0) \
+	/* data_race() is used to read attached private locklessly */ \
+	(data_race(folio_has_attached_private(folio))	? PAGEMAP_BUFFERS    : 0) \
 	)
 
 TRACE_EVENT(mm_lru_insertion,
--- a/mm/huge_memory.c~mm-page-flags-check-page-folio-private-instead-of-pg_private
+++ a/mm/huge_memory.c
@@ -4845,8 +4845,9 @@ static int split_huge_pages_pid(int pid,
 		 * For folios with private, split_huge_page_to_list_to_order()
 		 * will try to drop it before split and then check if the folio
 		 * can be split or not. So skip the check here.
+		 * data_race() is used to read attached private locklessly.
 		 */
-		if (!folio_test_private(folio) &&
+		if (!data_race(folio_has_attached_private(folio)) &&
 		    folio_expected_ref_count(folio) != folio_ref_count(folio))
 			goto next;
 
--- a/mm/migrate.c~mm-page-flags-check-page-folio-private-instead-of-pg_private
+++ a/mm/migrate.c
@@ -1327,7 +1327,7 @@ static int migrate_folio_unmap(new_folio
 	 * free the metadata, so the page can be freed.
 	 */
 	if (!src->mapping) {
-		if (folio_test_private(src)) {
+		if (folio_has_attached_private(src)) {
 			try_to_free_buffers(src);
 			goto out;
 		}
--- a/mm/page-writeback.c~mm-page-flags-check-page-folio-private-instead-of-pg_private
+++ a/mm/page-writeback.c
@@ -2705,7 +2705,8 @@ bool filemap_dirty_folio(struct address_
 	if (folio_test_set_dirty(folio))
 		return false;
 
-	__folio_mark_dirty(folio, mapping, !folio_test_private(folio));
+	/* data_race() is used to read attached private locklessly */
+	__folio_mark_dirty(folio, mapping, !data_race(folio_has_attached_private(folio)));
 
 	if (mapping->host) {
 		/* !PageAnon && !swapper_space */
--- a/mm/vmscan.c~mm-page-flags-check-page-folio-private-instead-of-pg_private
+++ a/mm/vmscan.c
@@ -1029,7 +1029,7 @@ static void folio_check_dirty_writeback(
 	*writeback = folio_test_writeback(folio);
 
 	/* Verify dirty/writeback state if the filesystem supports it */
-	if (!folio_test_private(folio))
+	if (!folio_has_attached_private(folio))
 		return;
 
 	mapping = folio_mapping(folio);
--- a/tools/mm/page-types.c~mm-page-flags-check-page-folio-private-instead-of-pg_private
+++ a/tools/mm/page-types.c
@@ -73,7 +73,6 @@
 #define KPF_RESERVED		32
 #define KPF_MLOCKED		33
 #define KPF_OWNER_2		34
-#define KPF_PRIVATE		35
 #define KPF_PRIVATE_2		36
 #define KPF_OWNER_PRIVATE	37
 #define KPF_ARCH		38
@@ -131,7 +130,6 @@ static const char * const page_flag_name
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
 	[KPF_OWNER_2]		= "d:owner_2",
-	[KPF_PRIVATE]		= "P:private",
 	[KPF_PRIVATE_2]		= "p:private_2",
 	[KPF_OWNER_PRIVATE]	= "O:owner_private",
 	[KPF_ARCH]		= "h:arch",
_

Patches currently in -mm which might be from ziy@nvidia.com are

treewide-remove-folio_set-clear_private-usage.patch
ceph-replace-pageprivate-with-page_private.patch
md-md-bitmap-replace-pageprivate-with-page_private.patch
buffer-replace-page_buffer-with-page_private-and-delete-it.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

