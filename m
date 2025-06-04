Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C98230BE3
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 03:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749006480; cv=none; b=PWwvDB5rr2ectx+AzPesxQeS1907rq645u5JX3Gr2mC0Sch24W94PUHVfMpuwEvftX2qpaHvZNIWi5EwkzTl45JSvLT5ckosdGrFIiN47FMJQ7XprDeqp8rSeWCGdr+/ZRc4SbatNxNNkpCm2LUG7S1zI6WitAchiaD8X+D0LbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749006480; c=relaxed/simple;
	bh=w95rophXGfhHPG7C9LOZ1uRytiEa0PHfmd2VQ5xtzr4=;
	h=Date:To:From:Subject:Message-Id; b=JxX2ANyBEJ6oXfcnJOhG2EILJv9yUH0dq+gIGisVPlKnaAg1YILH6UKhs4TVqthJ5J0RX8dd7PpYjZ4m9/5vJt/xepwO8E9g8c8C9WBKz4OA0kfn2p5DjDaobUFSo9l8qhhbhjowY3cKDimf2OiDXDVYg1t30vbt9S8/fGkmmPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=otput3dT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="otput3dT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458CCC4CEED;
	Wed,  4 Jun 2025 03:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749006480;
	bh=w95rophXGfhHPG7C9LOZ1uRytiEa0PHfmd2VQ5xtzr4=;
	h=Date:To:From:Subject:From;
	b=otput3dT3RTZQoTXOwGWAUp35fwnvViqtJWfKzEbLfZvZLF7j+Br9xKy+tRVAeOKC
	 5Qz0SbtIxrPHkXXqbT84C8uNIzbHwqWz5Zs5vBj2q4jXolVkKKRchqRM9k0axnyhxJ
	 kpskSJ8kq+nmtXhS/GE36V9BYCZJLr9oKUXKujmQ=
Date: Tue, 03 Jun 2025 20:07:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,osalvador@suse.de,david@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-node-remove-register_mem_block_under_node_early.patch added to mm-new branch
Message-Id: <20250604030800.458CCC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base/node: remove register_mem_block_under_node_early()
has been added to the -mm mm-new branch.  Its filename is
     drivers-base-node-remove-register_mem_block_under_node_early.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-node-remove-register_mem_block_under_node_early.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: drivers/base/node: remove register_mem_block_under_node_early()
Date: Wed, 28 May 2025 12:18:01 -0500

The function register_mem_block_under_node_early() is no longer used, as
register_memory_blocks_under_node_early() now handles memory block
registration during early boot.

Removed register_mem_block_under_node_early() and get_nid_for_pfn(), the
latter was only used by the former.

Link: https://lkml.kernel.org/r/22e0c5d20f1d33a91d0436ad22d96628cf084d1b.1748452242.git.donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |   58 ------------------------------------------
 1 file changed, 1 insertion(+), 57 deletions(-)

--- a/drivers/base/node.c~drivers-base-node-remove-register_mem_block_under_node_early
+++ a/drivers/base/node.c
@@ -778,15 +778,6 @@ int unregister_cpu_under_node(unsigned i
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-static int __ref get_nid_for_pfn(unsigned long pfn)
-{
-#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
-	if (system_state < SYSTEM_RUNNING)
-		return early_pfn_to_nid(pfn);
-#endif
-	return pfn_to_nid(pfn);
-}
-
 static void do_register_memory_block_under_node(int nid,
 						struct memory_block *mem_blk,
 						enum meminit_context context)
@@ -813,46 +804,6 @@ static void do_register_memory_block_und
 				    ret);
 }
 
-/* register memory section under specified node if it spans that node */
-static int register_mem_block_under_node_early(struct memory_block *mem_blk,
-					       void *arg)
-{
-	unsigned long memory_block_pfns = memory_block_size_bytes() / PAGE_SIZE;
-	unsigned long start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
-	unsigned long end_pfn = start_pfn + memory_block_pfns - 1;
-	int nid = *(int *)arg;
-	unsigned long pfn;
-
-	for (pfn = start_pfn; pfn <= end_pfn; pfn++) {
-		int page_nid;
-
-		/*
-		 * memory block could have several absent sections from start.
-		 * skip pfn range from absent section
-		 */
-		if (!pfn_in_present_section(pfn)) {
-			pfn = round_down(pfn + PAGES_PER_SECTION,
-					 PAGES_PER_SECTION) - 1;
-			continue;
-		}
-
-		/*
-		 * We need to check if page belongs to nid only at the boot
-		 * case because node's ranges can be interleaved.
-		 */
-		page_nid = get_nid_for_pfn(pfn);
-		if (page_nid < 0)
-			continue;
-		if (page_nid != nid)
-			continue;
-
-		do_register_memory_block_under_node(nid, mem_blk, MEMINIT_EARLY);
-		return 0;
-	}
-	/* mem section does not span the specified node */
-	return 0;
-}
-
 /*
  * During hotplug we know that all pages in the memory block belong to the same
  * node.
@@ -913,15 +864,8 @@ void register_memory_blocks_under_node(i
 				       unsigned long end_pfn,
 				       enum meminit_context context)
 {
-	walk_memory_blocks_func_t func;
-
-	if (context == MEMINIT_HOTPLUG)
-		func = register_mem_block_under_node_hotplug;
-	else
-		func = register_mem_block_under_node_early;
-
 	walk_memory_blocks(PFN_PHYS(start_pfn), PFN_PHYS(end_pfn - start_pfn),
-			   (void *)&nid, func);
+			   (void *)&nid, register_mem_block_under_node_hotplug);
 	return;
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time.patch
drivers-base-node-remove-register_mem_block_under_node_early.patch
drivers-base-node-remove-register_memory_blocks_under_node-function-call-from-register_one_node.patch
drivers-base-node-rename-register_memory_blocks_under_node-and-remove-context-argument.patch
drivers-base-node-rename-__register_one_node-to-register_one_node.patch

