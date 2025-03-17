Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DC8215771
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188286; cv=none; b=k27b7JfRnhIp2RxMaDFzE0mnKWrCNd+W31IabDwWHs30ShYmPHwD7lHMkFRZaDeaatoB/XuJY1Us/d7JBL4d/XjTjeo4deg59MbFdUsdCR5F1eHdxZ3V3BfJHPOh60MXJr7r+HFhTRD5VEGGmvl7j9nC7k3N2Ds4N56PQSPK3rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188286; c=relaxed/simple;
	bh=7hy3NUWNdg++WNRl32AWgHFPO5MQ1mKuWV2Gd0U8y/U=;
	h=Date:To:From:Subject:Message-Id; b=jGTf8lJR5CJp6y48YPfR8FofgvwX3aJ1TjWON0Gg49CpmUNphxPEaSsDSTgF7+gjw/1FvbE7Tr4DP1RiXyabMvwg8zXDwPpAvwyBlYVACHoUs8Oemst6WU0Upy9epcckCuPx+WQVL6iZLMVeSrFpFYx9T6cf/4omFbCXIctlHPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xUk1UZgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xUk1UZgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC82C4CEEC;
	Mon, 17 Mar 2025 05:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188286;
	bh=7hy3NUWNdg++WNRl32AWgHFPO5MQ1mKuWV2Gd0U8y/U=;
	h=Date:To:From:Subject:From;
	b=xUk1UZgtcJECV6D2bvIbUZOgT8wtWL2tN0M7m38wIitCqU0NmAcwKxh2swYNE06Vq
	 s0CJGJwIoZ55zHBEnOEyXHZ5nquhLUZtrHrujqrZNhsod/G6Ah58CmgPPSAuHN7BVG
	 crfOilb0TM/diJCl45rQNvjjd92nuW9v9raqq0Zw=
Date: Sun, 16 Mar 2025 22:11:25 -0700
To: mm-commits@vger.kernel.org,shivankg@amd.com,rppt@kernel.org,david@redhat.com,anshuman.khandual@arm.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-use-round_up-to-calculate-usermap-size.patch removed from -mm tree
Message-Id: <20250317051126.6AC82C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: use round_up() to calculate usermap size
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-use-round_up-to-calculate-usermap-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mm_init.c: use round_up() to calculate usermap size
Date: Wed, 12 Feb 2025 01:38:18 +0000

Since pageblock_nr_pages and BITS_PER_LONG are power of 2, we could use
round_up() to calculate it.

Also we have renamed blockflags to pageblock_flags, adjust the comment
accordingly.

Link: https://lkml.kernel.org/r/20250212013818.873-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-use-round_up-to-calculate-usermap-size
+++ a/mm/mm_init.c
@@ -1431,7 +1431,7 @@ void __meminit init_currently_empty_zone
 
 #ifndef CONFIG_SPARSEMEM
 /*
- * Calculate the size of the zone->blockflags rounded to an unsigned long
+ * Calculate the size of the zone->pageblock_flags rounded to an unsigned long
  * Start by making sure zonesize is a multiple of pageblock_order by rounding
  * up. Then use 1 NR_PAGEBLOCK_BITS worth of bits per pageblock, finally
  * round what is now in bits to nearest long in bits, then return it in
@@ -1442,10 +1442,10 @@ static unsigned long __init usemap_size(
 	unsigned long usemapsize;
 
 	zonesize += zone_start_pfn & (pageblock_nr_pages-1);
-	usemapsize = roundup(zonesize, pageblock_nr_pages);
+	usemapsize = round_up(zonesize, pageblock_nr_pages);
 	usemapsize = usemapsize >> pageblock_order;
 	usemapsize *= NR_PAGEBLOCK_BITS;
-	usemapsize = roundup(usemapsize, BITS_PER_LONG);
+	usemapsize = round_up(usemapsize, BITS_PER_LONG);
 
 	return usemapsize / BITS_PER_BYTE;
 }
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

lib-rbtree-enable-userland-test-suite-for-rbtree-related-data-structure.patch
lib-rbtree-split-tests.patch
lib-rbtree-add-random-seed.patch
lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers.patch
lib-interval_tree-add-test-case-for-span-iteration.patch
lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch
lib-interval_tree-fix-the-comment-of-interval_tree_span_iter_next_gap.patch

