Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24C813AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744934; cv=none; b=P/nqFRD6Bh1YbqziU9upJsSeVDN7HkDlNUMM99U9MjPES4uHmNbTNEYavhUFtaDQaVuMrwkq++p2RccxCtOL4lFUY11z6hZRjTV5UHSxSdXtqLZt0rOKwTPbrOnyOAzVJsnZD8CbiaHHt9YZ0eJv7XypemGCJFNG3M15Lx48ybk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744934; c=relaxed/simple;
	bh=+wyvBT0NSZyhBCEeW4Yzx2BXNFngZkIBkPpIg3GFRgI=;
	h=Date:To:From:Subject:Message-Id; b=cHRM/S63u4XyYg530+zVL+XIZporP/qULqsFg3ve3z72fHPkvWqtoWdIN8l9vUcZV91yGNwVc+KnNrpNAN7cqjwOEIzv20wY/oN/E/zqkxCPFgfNxP9VDLhyK3M/yrzEVfZlgct0mkz1BirzvMmAmYirA0clz8iOO7YPvgUjVu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aOjhAb2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aOjhAb2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988A2C4CEF7;
	Sun, 29 Mar 2026 00:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744934;
	bh=+wyvBT0NSZyhBCEeW4Yzx2BXNFngZkIBkPpIg3GFRgI=;
	h=Date:To:From:Subject:From;
	b=aOjhAb2IzzMg9SzYFb8J55rkV/T362ji8NIpdxTQV0KX6aupclAihtKvAtWLjWJNg
	 /n2G/ZDKxaxHxiOGywOXDE0W1E3tu/l8h0UUaHC6lkM+o5aWFvJaaUGmsNj9yj5QkI
	 tFjDbW5iGAzG03ZK4S0Md+8vwbOlJphQfGhzb7tE=
Date: Sat, 28 Mar 2026 17:42:14 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sidhartha.kumar@oracle.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-remove-config_memory_hotplug-specific-usemap-allocation-handling.patch removed from -mm tree
Message-Id: <20260329004214.988A2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: remove CONFIG_MEMORY_HOTPLUG-specific usemap allocation handling
has been removed from the -mm tree.  Its filename was
     mm-sparse-remove-config_memory_hotplug-specific-usemap-allocation-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: remove CONFIG_MEMORY_HOTPLUG-specific usemap allocation handling
Date: Fri, 20 Mar 2026 23:13:42 +0100

In 2008, we added through commit 48c906823f39 ("memory hotplug: allocate
usemap on the section with pgdat") quite some complexity to try allocating
memory for the "usemap" (storing pageblock information per memory section)
for a memory section close to the memory of the "pgdat" of the node.

The goal was to make memory hotunplug of boot memory more likely to
succeed.  That commit also added some checks for circular dependencies
between two memory sections, whereby two memory sections would contain
each others usemap, turning both boot memory sections un-removable.

However, in 2010, commit a4322e1bad91 ("sparsemem: Put usemap for one node
together") started allocating the usemap for multiple memory sections on
the same node in one chunk, effectively grouping all usemap allocations of
the same node in a single memblock allocation.

We don't really give guarantees about memory hotunplug of boot memory, and
with the change in 2010, it is impossible in practice to get any circular
dependencies.

So let's simply remove this complexity.

Link: https://lkml.kernel.org/r/20260320-sparsemem_cleanups-v2-10-096addc8800d@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |  100 --------------------------------------------------
 1 file changed, 1 insertion(+), 99 deletions(-)

--- a/mm/sparse.c~mm-sparse-remove-config_memory_hotplug-specific-usemap-allocation-handling
+++ a/mm/sparse.c
@@ -294,102 +294,6 @@ size_t mem_section_usage_size(void)
 	return sizeof(struct mem_section_usage) + usemap_size();
 }
 
-#ifdef CONFIG_MEMORY_HOTREMOVE
-static inline phys_addr_t pgdat_to_phys(struct pglist_data *pgdat)
-{
-#ifndef CONFIG_NUMA
-	VM_BUG_ON(pgdat != &contig_page_data);
-	return __pa_symbol(&contig_page_data);
-#else
-	return __pa(pgdat);
-#endif
-}
-
-static struct mem_section_usage * __init
-sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
-					 unsigned long size)
-{
-	struct mem_section_usage *usage;
-	unsigned long goal, limit;
-	int nid;
-	/*
-	 * A page may contain usemaps for other sections preventing the
-	 * page being freed and making a section unremovable while
-	 * other sections referencing the usemap remain active. Similarly,
-	 * a pgdat can prevent a section being removed. If section A
-	 * contains a pgdat and section B contains the usemap, both
-	 * sections become inter-dependent. This allocates usemaps
-	 * from the same section as the pgdat where possible to avoid
-	 * this problem.
-	 */
-	goal = pgdat_to_phys(pgdat) & (PAGE_SECTION_MASK << PAGE_SHIFT);
-	limit = goal + (1UL << PA_SECTION_SHIFT);
-	nid = early_pfn_to_nid(goal >> PAGE_SHIFT);
-again:
-	usage = memblock_alloc_try_nid(size, SMP_CACHE_BYTES, goal, limit, nid);
-	if (!usage && limit) {
-		limit = MEMBLOCK_ALLOC_ACCESSIBLE;
-		goto again;
-	}
-	return usage;
-}
-
-static void __init check_usemap_section_nr(int nid,
-		struct mem_section_usage *usage)
-{
-	unsigned long usemap_snr, pgdat_snr;
-	static unsigned long old_usemap_snr;
-	static unsigned long old_pgdat_snr;
-	struct pglist_data *pgdat = NODE_DATA(nid);
-	int usemap_nid;
-
-	/* First call */
-	if (!old_usemap_snr) {
-		old_usemap_snr = NR_MEM_SECTIONS;
-		old_pgdat_snr = NR_MEM_SECTIONS;
-	}
-
-	usemap_snr = pfn_to_section_nr(__pa(usage) >> PAGE_SHIFT);
-	pgdat_snr = pfn_to_section_nr(pgdat_to_phys(pgdat) >> PAGE_SHIFT);
-	if (usemap_snr == pgdat_snr)
-		return;
-
-	if (old_usemap_snr == usemap_snr && old_pgdat_snr == pgdat_snr)
-		/* skip redundant message */
-		return;
-
-	old_usemap_snr = usemap_snr;
-	old_pgdat_snr = pgdat_snr;
-
-	usemap_nid = sparse_early_nid(__nr_to_section(usemap_snr));
-	if (usemap_nid != nid) {
-		pr_info("node %d must be removed before remove section %ld\n",
-			nid, usemap_snr);
-		return;
-	}
-	/*
-	 * There is a circular dependency.
-	 * Some platforms allow un-removable section because they will just
-	 * gather other removable sections for dynamic partitioning.
-	 * Just notify un-removable section's number here.
-	 */
-	pr_info("Section %ld and %ld (node %d) have a circular dependency on usemap and pgdat allocations\n",
-		usemap_snr, pgdat_snr, nid);
-}
-#else
-static struct mem_section_usage * __init
-sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
-					 unsigned long size)
-{
-	return memblock_alloc_node(size, SMP_CACHE_BYTES, pgdat->node_id);
-}
-
-static void __init check_usemap_section_nr(int nid,
-		struct mem_section_usage *usage)
-{
-}
-#endif /* CONFIG_MEMORY_HOTREMOVE */
-
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 unsigned long __init section_map_size(void)
 {
@@ -486,7 +390,6 @@ void __init sparse_init_early_section(in
 				      unsigned long pnum, unsigned long flags)
 {
 	BUG_ON(!sparse_usagebuf || sparse_usagebuf >= sparse_usagebuf_end);
-	check_usemap_section_nr(nid, sparse_usagebuf);
 	sparse_init_one_section(__nr_to_section(pnum), pnum, map,
 			sparse_usagebuf, SECTION_IS_EARLY | flags);
 	sparse_usagebuf = (void *)sparse_usagebuf + mem_section_usage_size();
@@ -497,8 +400,7 @@ static int __init sparse_usage_init(int
 	unsigned long size;
 
 	size = mem_section_usage_size() * map_count;
-	sparse_usagebuf = sparse_early_usemaps_alloc_pgdat_section(
-				NODE_DATA(nid), size);
+	sparse_usagebuf = memblock_alloc_node(size, SMP_CACHE_BYTES, nid);
 	if (!sparse_usagebuf) {
 		sparse_usagebuf_end = NULL;
 		return -ENOMEM;
_

Patches currently in -mm which might be from david@kernel.org are


