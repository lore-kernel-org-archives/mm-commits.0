Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385F24685
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560102; cv=none; b=A7RifFLAfI8Qga7MmE/wdm2Ri1yupkf4b+8swUn1OTIJXOpi11pKBPONpejPHu8yseeUWXyVfCZbEaLYNYMg15avzhS25DsI+SOZdga09h/V2ru31WOM7xW7/+Xu5uVgmbmYxl7sAb3FgjVIgpFhtyzGlctWpmPgcbQzx/exptg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560102; c=relaxed/simple;
	bh=wWPxYXv9tZ9HNqR2EHOK0ShaTyqwesCd5e6J9VPYzlE=;
	h=Date:To:From:Subject:Message-Id; b=UyClarGmhQBjMTxMP+lN6TCKmhHiQGyi+XJm9zYfssuW9QXX5xkvPO2UWbE4q4sKpZslAr/BvhgR9hf694CvrWPPPFM8iv2Cxj5g/160z8icmpgv3yOqyM0wWwfoJ8v6u5eJcozxydUgepMcB1jAXBcSQy5JfuDtIWWgToSKy60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lo8o3chd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lo8o3chd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBD2C433C7;
	Thu, 22 Feb 2024 00:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560102;
	bh=wWPxYXv9tZ9HNqR2EHOK0ShaTyqwesCd5e6J9VPYzlE=;
	h=Date:To:From:Subject:From;
	b=lo8o3chdgXBGBMnPv0J8yHe00HYUqhIWjblaLJMNRfk0WQh7Q78vh33EwD9bMfYs/
	 T55kn7ptEo4tTjjP3H3fvAZHp22BA5DIBEMFUBt0QEUX36mKMZqX1CnRx4c4wHK+FI
	 jyrHasw6bOKNr+vImd+BQqS0SIfQ7oQ1qCPveh7s=
Date: Wed, 21 Feb 2024 16:01:41 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,osalvador@suse.de,mhocko@suse.com,lizhijian@fujitsu.com,Jonathan.Cameron@huawei.com,gregkh@linuxfoundation.org,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-export-mhp_supports_memmap_on_memory.patch removed from -mm tree
Message-Id: <20240222000142.0EBD2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: export mhp_supports_memmap_on_memory()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-export-mhp_supports_memmap_on_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: mm/memory_hotplug: export mhp_supports_memmap_on_memory()
Date: Wed, 24 Jan 2024 12:03:49 -0800

In preparation for adding sysfs ABI to toggle memmap_on_memory semantics
for drivers adding memory, export the mhp_supports_memmap_on_memory()
helper. This allows drivers to check if memmap_on_memory support is
available before trying to request it, and display an appropriate
message if it isn't available. As part of this, remove the size argument
to this - with recent updates to allow memmap_on_memory for larger
ranges, and the internal splitting of altmaps into respective memory
blocks, the size argument is meaningless.

[akpm@linux-foundation.org: fix build]
Link: https://lkml.kernel.org/r/20240124-vv-dax_abi-v7-4-20d16cb8d23d@intel.com
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    6 ++++++
 mm/memory_hotplug.c            |   17 ++++++-----------
 2 files changed, 12 insertions(+), 11 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-export-mhp_supports_memmap_on_memory
+++ a/include/linux/memory_hotplug.h
@@ -137,6 +137,7 @@ struct mhp_params {
 
 bool mhp_range_allowed(u64 start, u64 size, bool need_mapping);
 struct range mhp_get_pluggable_range(bool need_mapping);
+bool mhp_supports_memmap_on_memory(void);
 
 /*
  * Zone resizing functions
@@ -277,6 +278,11 @@ static inline bool movable_node_is_enabl
 {
 	return false;
 }
+
+static inline bool mhp_supports_memmap_on_memory(void)
+{
+	return false;
+}
 
 static inline void pgdat_kswapd_lock(pg_data_t *pgdat) {}
 static inline void pgdat_kswapd_unlock(pg_data_t *pgdat) {}
--- a/mm/memory_hotplug.c~mm-memory_hotplug-export-mhp_supports_memmap_on_memory
+++ a/mm/memory_hotplug.c
@@ -1337,7 +1337,7 @@ static inline bool arch_supports_memmap_
 }
 #endif
 
-static bool mhp_supports_memmap_on_memory(unsigned long size)
+bool mhp_supports_memmap_on_memory(void)
 {
 	unsigned long vmemmap_size = memory_block_memmap_size();
 	unsigned long memmap_pages = memory_block_memmap_on_memory_pages();
@@ -1346,17 +1346,11 @@ static bool mhp_supports_memmap_on_memor
 	 * Besides having arch support and the feature enabled at runtime, we
 	 * need a few more assumptions to hold true:
 	 *
-	 * a) We span a single memory block: memory onlining/offlinin;g happens
-	 *    in memory block granularity. We don't want the vmemmap of online
-	 *    memory blocks to reside on offline memory blocks. In the future,
-	 *    we might want to support variable-sized memory blocks to make the
-	 *    feature more versatile.
-	 *
-	 * b) The vmemmap pages span complete PMDs: We don't want vmemmap code
+	 * a) The vmemmap pages span complete PMDs: We don't want vmemmap code
 	 *    to populate memory from the altmap for unrelated parts (i.e.,
 	 *    other memory blocks)
 	 *
-	 * c) The vmemmap pages (and thereby the pages that will be exposed to
+	 * b) The vmemmap pages (and thereby the pages that will be exposed to
 	 *    the buddy) have to cover full pageblocks: memory onlining/offlining
 	 *    code requires applicable ranges to be page-aligned, for example, to
 	 *    set the migratetypes properly.
@@ -1368,7 +1362,7 @@ static bool mhp_supports_memmap_on_memor
 	 *       altmap as an alternative source of memory, and we do not exactly
 	 *       populate a single PMD.
 	 */
-	if (!mhp_memmap_on_memory() || size != memory_block_size_bytes())
+	if (!mhp_memmap_on_memory())
 		return false;
 
 	/*
@@ -1391,6 +1385,7 @@ static bool mhp_supports_memmap_on_memor
 
 	return arch_supports_memmap_on_memory(vmemmap_size);
 }
+EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
 
 static void __ref remove_memory_blocks_and_altmaps(u64 start, u64 size)
 {
@@ -1526,7 +1521,7 @@ int __ref add_memory_resource(int nid, s
 	 * Self hosted memmap array
 	 */
 	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY) &&
-	    mhp_supports_memmap_on_memory(memory_block_size_bytes())) {
+	    mhp_supports_memmap_on_memory()) {
 		ret = create_altmaps_and_memory_blocks(nid, group, start, size, mhp_flags);
 		if (ret)
 			goto error;
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are


