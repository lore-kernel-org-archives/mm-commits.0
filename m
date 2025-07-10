Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C5728467B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126234; cv=none; b=kiQg0B88BB+V/ICulUzWjU5/mtAinByWBNkqJ1mllqrUWh0cPeduJdqJnX7ihWHGirtXN/MjfLF4NnKfEUWdxROkWX4u3dOWx91n00zLlaekXjgn1A4u5dzc3HruI34x7x4J2a3MT3Gh8a0DOx/cSUQBJM/7EGB716UdxIc+N1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126234; c=relaxed/simple;
	bh=TNmEJzmrE/KZ+x8lB+NbWQsX8/TX8HtZcw6gluzx5X0=;
	h=Date:To:From:Subject:Message-Id; b=Qyw03LIDRKUfbedEGtR2zG06ORuUmGCTefjZC2V+vCHSWREY5hEYyZFB0cNIUNp6T5b86Jg5OLXNdVpktrxePApD1gKbmi0HJ+9Fpe9ByNlFi0K8CrwwrnetHjfFj/Yly23i6Dv/Mh3HbovTyEHNo+9zPAs3iPSV7eJj8tXyDMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x4QciY7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x4QciY7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0459BC4CEE3;
	Thu, 10 Jul 2025 05:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126234;
	bh=TNmEJzmrE/KZ+x8lB+NbWQsX8/TX8HtZcw6gluzx5X0=;
	h=Date:To:From:Subject:From;
	b=x4QciY7X0KtOIoodYobEwV/80FjrcxaLu2X7nWKgnLjM/HbPP+CvgNMLde/nGneWF
	 9eaWDPOzmUMd+hwJKrYdKQ0Hb4d9K4kAOi8Le2Z0ryS0nII0WW7D/GfVRiPOYzsTPF
	 lQ84aTQvHPy7ILf8y8qtV9ZGVJu4bvb3OzA/ONX0=
Date: Wed, 09 Jul 2025 22:43:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,osalvador@suse.de,david@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-node-remove-register_mem_block_under_node_early.patch removed from -mm tree
Message-Id: <20250710054354.0459BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/node: remove register_mem_block_under_node_early()
has been removed from the -mm tree.  Its filename was
     drivers-base-node-remove-register_mem_block_under_node_early.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -757,15 +757,6 @@ int unregister_cpu_under_node(unsigned i
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
@@ -792,46 +783,6 @@ static void do_register_memory_block_und
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
@@ -892,15 +843,8 @@ void register_memory_blocks_under_node(i
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


