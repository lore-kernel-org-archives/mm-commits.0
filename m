Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832345;
	b=zUUrNKrsVGlPIx4tCi7xQmN6fC4q/+WCsWIY3PbgINKZzp6VCo2AFtgLSUf06uQFFGv2
	 4JVXo56aZgjCVOfo5CyUiHBHYimI0OyaEO36E5bmxlNqV/APbCLZFqEvzMcoeT9kOt2Ze
	 gJrqzZzEx4ZbByJwoRGqDVP2VmO9xYoFgWQVFnyq5/lbV4A53tUMlR7UgQQgVnFS5er1k
	 wbnsyVYLBeH1uVar87v1VdcAJVSj2rSVoGxBvw2qUBI47zgRD741umZQkEWqliT4c5YoJ
	 toq6DCVUBZlePwPgzG4V95IiovrXhlRRXlKMa78DXNnTGjB+MnLrDcNwQ0ijzd/8Oog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832345;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3ab51I+fsmr5L7+Z1e7QMNQCfocT/aAUlSrnMyryDpY=;
	b=zEsH0Y+6oXYK0jZoUfZ8XSQe8h9bpRvnchumFwRoFTa2sKaBFKBUowscNQXWULi7jJfi
	 e+9vLfRtHYe6IA4gINmCKpSZHKbhk9rJYBs8LCcDC4xPd8rHTZqgAOzXKaooPiY24kPnq
	 dv0l/rS2KNo34LHQ1I1wC2QCNqnfpzPQt3/F2Uct1LidnqbB01ejXFRksmycq1OmlmzGz
	 e8oNqzVO9+TlNBz2MXIyT2aK16bgzmq1yfySKHkXf8fHTLBaLNtu5jGFDx80UpNoTT3iA
	 ReobyJmBkYp6KJwvL+xuS3d5ZSbkt+tfWrh2e31dDJVIEe38RlMivSDsEWTy90CAyLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ft9fkJ1C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72E7606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ft9fkJ1C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7F51F01828;
	Sat, 24 Oct 2026 08:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832344;
	bh=3ab51I+fsmr5L7+Z1e7QMNQCfocT/aAUlSrnMyryDpY=;
	h=Date:To:From:Subject;
	b=ft9fkJ1CUppAzXKZ18hWjzpJi7IFwxiZQL5wOmqiRfwEmljDq9C0SD3HNsQvVxkA2
	 Ig34EWYM2tg9X7HV4NJfmDkNhu9sk6jwBPj8cyzZYz4yxoNK5YOVO6eIjsC8TTYIeP
	 0GidybRYL5A5v2WjgST7I/cH+tboOTD/6YeJhF4I=
Date: Sat, 24 Oct 2026 01:59:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kbingham@kernel.org,kasong@tencent.com,jan.kiszka@siemens.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-remove-section_marked_present.patch removed from -mm tree
Message-Id: <20261024085904.8B7F51F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/sparse: remove SECTION_MARKED_PRESENT
has been removed from the -mm tree.  Its filename was
     mm-sparse-remove-section_marked_present.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2059,7 +2059,6 @@ static inline struct mem_section *__nr_t
  * accommodate SECTION_MAP_LAST_BIT. We use BUILD_BUG_ON() to ensure this.
  */
 enum {
-	SECTION_MARKED_PRESENT_BIT,
 	SECTION_HAS_MEM_MAP_BIT,
 	SECTION_IS_ONLINE_BIT,
 	SECTION_IS_EARLY_BIT,
@@ -2069,7 +2068,6 @@ enum {
 	SECTION_MAP_LAST_BIT,
 };
 
-#define SECTION_MARKED_PRESENT		BIT(SECTION_MARKED_PRESENT_BIT)
 #define SECTION_HAS_MEM_MAP		BIT(SECTION_HAS_MEM_MAP_BIT)
 #define SECTION_IS_ONLINE		BIT(SECTION_IS_ONLINE_BIT)
 #define SECTION_IS_EARLY		BIT(SECTION_IS_EARLY_BIT)
@@ -2086,16 +2084,6 @@ static inline struct page *__section_mem
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
@@ -2111,6 +2099,11 @@ static inline int valid_section_nr(unsig
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
@@ -2300,20 +2293,20 @@ static inline unsigned long next_valid_p
 
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
@@ -903,7 +903,6 @@ int __meminit sparse_add_section(int nid
 	if (!section_vmemmap_optimizable(ms))
 		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
-	__section_mark_present(ms, section_nr);
 	__highest_used_section_nr = max(section_nr, __highest_used_section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

