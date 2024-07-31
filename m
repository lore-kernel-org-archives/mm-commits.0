Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17358BE0
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 01:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722388731; cv=none; b=Q5uN3nW9pAmjJYxVLZjEi09WqsegsnrnlZg3S01Czgujd+s7b2VKMgX93gdYbbqwiQaA9T28lyaYI6axfWD4qMhVWlwAR6uNzBzEuRziq5fJrQn2ET4iYbXZfVZAeTI5BeDrfD6ZiVzuN9XAKLp+vLiI9EbaczXQdfSVFfWvaoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722388731; c=relaxed/simple;
	bh=2/Qf1ZZ3yD7HsoxG0U813mhQTNh6jvN/KUyLl1bpO7s=;
	h=Date:To:From:Subject:Message-Id; b=FxuX0AFG6IYckXgfth8BLger0yucYR2n+Xso5oeFUA0OoWW5E/ogigBTC/QuSQalYWWfk0m4U6JXEKDFP/8A9q9txrOq/HJ+vghM2srg2Ee6G1FkRp+qbsj8xwcnTaF70aimykvLlPqbgi+fUDbJVpIqB6gGghYm/OHW9cKi2Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WCehgqAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WCehgqAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5599FC32782;
	Wed, 31 Jul 2024 01:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722388731;
	bh=2/Qf1ZZ3yD7HsoxG0U813mhQTNh6jvN/KUyLl1bpO7s=;
	h=Date:To:From:Subject:From;
	b=WCehgqAv6vOIU1LrjWSt7BLzXIXVRNpf+mmh5/tqW4sXi396dLFUA02rZVYcsdiRZ
	 3IAIFGrxFsSiTln7opDKjJfIOYYdHsaPJLNtupULGsb1I4bjKv+cy8fr6hIq39hr3y
	 hVyzkw/sItWQDLgWiHXPG5VPnWLD/uDr6F3gbo4k=
Date: Tue, 30 Jul 2024 18:18:50 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,masahiroy@kernel.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-get-rid-of-__ref.patch added to mm-unstable branch
Message-Id: <20240731011851.5599FC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory_hotplug: get rid of __ref
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-get-rid-of-__ref.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-get-rid-of-__ref.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memory_hotplug: get rid of __ref
Date: Fri, 26 Jul 2024 01:01:57 +0000

After commit 73db3abdca58 ("init/modpost: conditionally check section
mismatch to __meminit*"), we can get rid of __ref annotations.

Link: https://lkml.kernel.org/r/20240726010157.6177-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-get-rid-of-__ref
+++ a/mm/memory_hotplug.c
@@ -366,7 +366,7 @@ struct page *pfn_to_online_page(unsigned
 }
 EXPORT_SYMBOL_GPL(pfn_to_online_page);
 
-int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
+int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		struct mhp_params *params)
 {
 	const unsigned long end_pfn = pfn + nr_pages;
@@ -524,7 +524,7 @@ static void update_pgdat_span(struct pgl
 	pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
 }
 
-void __ref remove_pfn_range_from_zone(struct zone *zone,
+void remove_pfn_range_from_zone(struct zone *zone,
 				      unsigned long start_pfn,
 				      unsigned long nr_pages)
 {
@@ -629,7 +629,7 @@ int restore_online_page_callback(online_
 EXPORT_SYMBOL_GPL(restore_online_page_callback);
 
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
-void __ref generic_online_page(struct page *page, unsigned int order)
+void generic_online_page(struct page *page, unsigned int order)
 {
 	__free_pages_core(page, order, MEMINIT_HOTPLUG);
 }
@@ -741,7 +741,7 @@ static inline void section_taint_zone_de
  * (usually MIGRATE_MOVABLE). Besides setting the migratetype, no related
  * zone stats (e.g., nr_isolate_pageblock) are touched.
  */
-void __ref move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
+void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 				  unsigned long nr_pages,
 				  struct vmem_altmap *altmap, int migratetype)
 {
@@ -1143,7 +1143,7 @@ void mhp_deinit_memmap_on_memory(unsigne
 /*
  * Must be called with mem_hotplug_lock in write mode.
  */
-int __ref online_pages(unsigned long pfn, unsigned long nr_pages,
+int online_pages(unsigned long pfn, unsigned long nr_pages,
 		       struct zone *zone, struct memory_group *group)
 {
 	unsigned long flags;
@@ -1233,7 +1233,7 @@ failed_addition:
 }
 
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
-static pg_data_t __ref *hotadd_init_pgdat(int nid)
+static pg_data_t *hotadd_init_pgdat(int nid)
 {
 	struct pglist_data *pgdat;
 
@@ -1386,7 +1386,7 @@ bool mhp_supports_memmap_on_memory(void)
 }
 EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
 
-static void __ref remove_memory_blocks_and_altmaps(u64 start, u64 size)
+static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 {
 	unsigned long memblock_size = memory_block_size_bytes();
 	u64 cur_start;
@@ -1473,7 +1473,7 @@ out:
  *
  * we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG
  */
-int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
+int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
@@ -1580,7 +1580,7 @@ error_mem_hotplug_end:
 }
 
 /* requires device_hotplug_lock, see add_memory_resource() */
-int __ref __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
+int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
 {
 	struct resource *res;
 	int ret;
@@ -1939,7 +1939,7 @@ static int count_system_ram_pages_cb(uns
 /*
  * Must be called with mem_hotplug_lock in write mode.
  */
-int __ref offline_pages(unsigned long start_pfn, unsigned long nr_pages,
+int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 			struct zone *zone, struct memory_group *group)
 {
 	const unsigned long end_pfn = start_pfn + nr_pages;
@@ -2240,7 +2240,7 @@ static int memory_blocks_have_altmaps(u6
 	return 1;
 }
 
-static int __ref try_remove_memory(u64 start, u64 size)
+static int try_remove_memory(u64 start, u64 size)
 {
 	int rc, nid = NUMA_NO_NODE;
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-improve-code-consistency-with-zonelist_-helper-functions.patch
mm-memory_hotplug-get-rid-of-__ref.patch

