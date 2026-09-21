Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3669D475341
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030995; cv=none; b=QKR05+IdStxg/98Y/AoscOuJvCmEuHCztTZbYpwbDUQc5qAL7i69nP5DdOYY9WJnMwZVmm9528ZqKkzLL84RPdWUMP+fg7kF27YDeOV+6qBR4fSJEtfuKnb0hfxixtlthjicrbrNtC3TQWe4YwirMIwyOi6rqw0tqvyaFPo/WRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030995; c=relaxed/simple;
	bh=sUX1gYeTE35KJSpnZ5/KY950/vkp/vQzarsZHpqyiyU=;
	h=Date:To:From:Subject:Message-Id; b=TnkQSI9m1QpksiDv5adlhRyHcq8Mr330J5zt3j/Zw6Gf0RtqvsgLJplnNRHH8RpRWhkdIoymo+zjvuC5tYYwnT3lZ3poxclUoHrINOy5ThOv/tpRweJ8YBiX95uvPcfC0qllwpslvStAuHTysYqee5pKkXD/Ny/Hn7liDeaF2GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0cCbNURD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0cCbNURD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0B01F00893;
	Mon, 21 Sep 2026 22:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790030990;
	bh=2ezpfvjHLTllzifMkO+yNvdNHTgNuBudH1QOQ0PrSho=;
	h=Date:To:From:Subject;
	b=0cCbNURDE03sKNCBdm8RNUVAPOtwFdrQp1Hh6BkY23Dwig7eoEjoxsLuw2Jlxahht
	 PtG2tQzp7GezwvjuQUoYO+3gBUt0FmQerd4L1GgQKgwa58dqb94T7VMNJ4gIehCaKY
	 zKp1FGEOESSN9AoX17kj+ItAURtswIckM3MBses8=
Date: Mon, 21 Sep 2026 15:49:49 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-remove-section_marked_present.patch added to mm-new branch
Message-Id: <20260921224950.1C0B01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: remove SECTION_MARKED_PRESENT
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-remove-section_marked_present.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-remove-section_marked_present.patch

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
Subject: mm/sparse: remove SECTION_MARKED_PRESENT
Date: Mon, 21 Sep 2026 21:59:02 +0200

All present section iterators run before memory hotplug added any further
memory sections, Therefore, we can simply use the SECTION_IS_EARLY flag by
setting that flag earlier in sparse_sections_init().

Get rid of SECTION_MARKED_PRESENT entirely and rename
for_each_present_section_nr() to for_each_early_section_nr().

Take care of the .clang-format for_each_present_section_nr() handling.

No functional change intended.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-10-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
---

 .clang-format          |    2 +-
 drivers/base/memory.c  |    2 +-
 include/linux/mmzone.h |   27 ++++++++++-----------------
 mm/sparse-vmemmap.c    |    1 -
 mm/sparse.c            |   17 ++++++++---------
 mm/sparse.h            |    6 ------
 6 files changed, 20 insertions(+), 35 deletions(-)

--- a/.clang-format~mm-sparse-remove-section_marked_present
+++ a/.clang-format
@@ -282,6 +282,7 @@ ForEachMacros:
   - 'for_each_dpcm_fe'
   - 'for_each_drhd_unit'
   - 'for_each_dss_dev'
+  - 'for_each_early_section_nr'
   - 'for_each_efi_memory_desc'
   - 'for_each_efi_memory_desc_in_map'
   - 'for_each_element'
@@ -403,7 +404,6 @@ ForEachMacros:
   - 'for_each_possible_cpu_wrap'
   - 'for_each_present_blessed_reg'
   - 'for_each_present_cpu'
-  - 'for_each_present_section_nr'
   - 'for_each_prime_number'
   - 'for_each_prime_number_from'
   - 'for_each_probe_cache_entry'
--- a/drivers/base/memory.c~mm-sparse-remove-section_marked_present
+++ a/drivers/base/memory.c
@@ -972,7 +972,7 @@ void __init memory_dev_init(void)
 	 * block so that it can be covered.
 	 */
 	block_id = ULONG_MAX;
-	for_each_present_section_nr(0, nr) {
+	for_each_early_section_nr(0, nr) {
 		if (block_id != ULONG_MAX && memory_block_id(nr) == block_id)
 			continue;
 
--- a/include/linux/mmzone.h~mm-sparse-remove-section_marked_present
+++ a/include/linux/mmzone.h
@@ -2085,7 +2085,6 @@ static inline struct mem_section *__nr_t
  * accommodate SECTION_MAP_LAST_BIT. We use BUILD_BUG_ON() to ensure this.
  */
 enum {
-	SECTION_MARKED_PRESENT_BIT,
 	SECTION_HAS_MEM_MAP_BIT,
 	SECTION_IS_ONLINE_BIT,
 	SECTION_IS_EARLY_BIT,
@@ -2095,7 +2094,6 @@ enum {
 	SECTION_MAP_LAST_BIT,
 };
 
-#define SECTION_MARKED_PRESENT		BIT(SECTION_MARKED_PRESENT_BIT)
 #define SECTION_HAS_MEM_MAP		BIT(SECTION_HAS_MEM_MAP_BIT)
 #define SECTION_IS_ONLINE		BIT(SECTION_IS_ONLINE_BIT)
 #define SECTION_IS_EARLY		BIT(SECTION_IS_EARLY_BIT)
@@ -2112,16 +2110,6 @@ static inline struct page *__section_mem
 	return (struct page *)map;
 }
 
-static inline int present_section(const struct mem_section *section)
-{
-	return (section && (section->section_mem_map & SECTION_MARKED_PRESENT));
-}
-
-static inline int present_section_nr(unsigned long nr)
-{
-	return present_section(__nr_to_section(nr));
-}
-
 static inline int valid_section(const struct mem_section *section)
 {
 	return (section && (section->section_mem_map & SECTION_HAS_MEM_MAP));
@@ -2137,6 +2125,11 @@ static inline int valid_section_nr(unsig
 	return valid_section(__nr_to_section(nr));
 }
 
+static inline int early_section_nr(unsigned long nr)
+{
+	return early_section(__nr_to_section(nr));
+}
+
 static inline int online_section(const struct mem_section *section)
 {
 	return (section && (section->section_mem_map & SECTION_IS_ONLINE));
@@ -2326,20 +2319,20 @@ static inline unsigned long next_valid_p
 
 #endif
 
-static inline unsigned long next_present_section_nr(unsigned long section_nr)
+static inline unsigned long next_early_section_nr(unsigned long section_nr)
 {
 	while (++section_nr <= __highest_used_section_nr) {
-		if (present_section_nr(section_nr))
+		if (early_section_nr(section_nr))
 			return section_nr;
 	}
 
 	return -1;
 }
 
-#define for_each_present_section_nr(start, section_nr)		\
-	for (section_nr = next_present_section_nr(start - 1);	\
+#define for_each_early_section_nr(start, section_nr)		\
+	for (section_nr = next_early_section_nr(start - 1);	\
 	     section_nr != -1;					\
-	     section_nr = next_present_section_nr(section_nr))
+	     section_nr = next_early_section_nr(section_nr))
 
 /*
  * These are _only_ used during initialisation, therefore they
--- a/mm/sparse.c~mm-sparse-remove-section_marked_present
+++ a/mm/sparse.c
@@ -170,13 +170,14 @@ static void __init mminit_validate_memmo
  */
 unsigned long __highest_used_section_nr;
 
-static inline unsigned long first_present_section_nr(void)
+static inline unsigned long first_early_section_nr(void)
 {
-	return next_present_section_nr(-1);
+	return next_early_section_nr(-1);
 }
 
 void __init sparse_sections_init(void)
 {
+	const unsigned long flags = SECTION_IS_EARLY | SECTION_IS_ONLINE;
 	unsigned long pfn, start_pfn, end_pfn, section_nr;
 	int i, nid;
 
@@ -196,9 +197,7 @@ void __init sparse_sections_init(void)
 				continue;
 
 			set_section_nid(section_nr, nid);
-			ms->section_mem_map = sparse_encode_early_nid(nid) |
-							SECTION_IS_ONLINE;
-			__section_mark_present(ms, section_nr);
+			ms->section_mem_map = sparse_encode_early_nid(nid) | flags;
 		}
 	}
 	__highest_used_section_nr = section_nr;
@@ -230,7 +229,7 @@ static void __init sparse_metadata_init_
 	if (!usage)
 		panic("Failed to allocate usemap for node %d\n", nid);
 
-	for_each_present_section_nr(start_section_nr, section_nr) {
+	for_each_early_section_nr(start_section_nr, section_nr) {
 		const unsigned long pfn = section_nr_to_pfn(section_nr);
 		struct page *mem_map;
 
@@ -244,18 +243,18 @@ static void __init sparse_metadata_init_
 			      section_nr);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 		sparse_init_one_section(__nr_to_section(section_nr), section_nr,
-					mem_map, usage, SECTION_IS_EARLY);
+					mem_map, usage, 0);
 		usage = (void *)usage + mem_section_usage_size();
 	}
 }
 
 static void __init sparse_metadata_init(void)
 {
-	unsigned long start_section_nr = first_present_section_nr();
+	unsigned long start_section_nr = first_early_section_nr();
 	int nid_begin = sparse_early_nid(__nr_to_section(start_section_nr));
 	unsigned long section_nr, nr_sections = 1;
 
-	for_each_present_section_nr(start_section_nr + 1, section_nr) {
+	for_each_early_section_nr(start_section_nr + 1, section_nr) {
 		const int nid = sparse_early_nid(__nr_to_section(section_nr));
 
 		if (nid == nid_begin) {
--- a/mm/sparse.h~mm-sparse-remove-section_marked_present
+++ a/mm/sparse.h
@@ -42,12 +42,6 @@ static inline void sparse_init_one_secti
 	ms->usage = usage;
 }
 
-static inline void __section_mark_present(struct mem_section *ms,
-		unsigned long section_nr)
-{
-	ms->section_mem_map |= SECTION_MARKED_PRESENT;
-}
-
 static inline size_t mem_section_usage_size(void)
 {
 	return struct_size_t(struct mem_section_usage, pageblock_flags,
--- a/mm/sparse-vmemmap.c~mm-sparse-remove-section_marked_present
+++ a/mm/sparse-vmemmap.c
@@ -864,7 +864,6 @@ int __meminit sparse_add_section(int nid
 	if (!section_vmemmap_optimizable(ms))
 		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
-	__section_mark_present(ms, section_nr);
 	__highest_used_section_nr = max(section_nr, __highest_used_section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
_

Patches currently in -mm which might be from david@kernel.org are

maintainers-split-up-memory-management-memory-policy-and-migration.patch
maintainers-move-memory-tiering-under-memory-management-numa-placement.patch
maintainers-make-gregory-a-co-maintainer-of-memory-management-numa-placement.patch
selftests-mm-khugepaged-remove-str_dup-usage.patch
mm-sparse-move-mem_section-init-to-sparse_extreme_init.patch
mm-sparse-refactor-sparse_sections_init.patch
mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch
mm-sparse-rename-and-cleanup-sparse_init_nid.patch
mm-sparse-cleanup-sparse_init_one_section.patch
mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch
mm-sparse-remove-pfn_in_present_section.patch
mm-sparse-move-__highest_used_section_nr-handling.patch
scripts-gdb-mmpy-remove-fallbacks-for-section_has_mem_map-and-section_is_early.patch
mm-sparse-remove-section_marked_present.patch
mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch
fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch
mm-memory_hotplug-drop-config_have_arch_pfn_valid-handling-from-pfn_to_online_page.patch

