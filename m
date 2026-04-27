Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52FF3BA24F;
	Mon, 27 Apr 2026 12:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294509; cv=none; b=sjeCGOH2nbWUZlEkYQOZkejOTDHRrLoh1q9hovXzySfEnN2VwkDFTrJPqv+Ty5IKIhMve9VVj7M8sAHzVgENUDDPxVhlnhjFXObBQp2M88eCw4jAbasQZj8+ukrQTGLhJoCDTw7hDTUPQ44oUT7KIHMPJyS1sZfYrAPr7+diUpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294509; c=relaxed/simple;
	bh=88rTZMFUMABbnbOzK9r1HWPvrSruyPxV60HW8XCikAc=;
	h=Date:To:From:Subject:Message-Id; b=jvoxxqkScDquWk3TZ3B5oUUwwmnx1xnoFPM+eylgMHrR8OYL4BUzdSd8SOssXzqBifp4P06s9ajoMDXeInKZ4H9zWcXl0qWYHwVMv2E7hXvUXB2cyf/3cyFBOKe5ycFXWfgRKmWWToP2fg5tABk6Bn3a8FlMoAZEs61uHQl3KVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GV/GvElz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GV/GvElz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3830AC19425;
	Mon, 27 Apr 2026 12:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777294509;
	bh=88rTZMFUMABbnbOzK9r1HWPvrSruyPxV60HW8XCikAc=;
	h=Date:To:From:Subject:From;
	b=GV/GvElzaeL8k58599PZJGK9KcaNhlY7UWvR64+zQniYrL02fsKJbQez69b2z1m8u
	 ftXNr6m9UIVi95qDz68iWFqhP05mHb0laG17ViA0FzS9FV8EKwrHUufAHlOXoj/OHU
	 hTRPUkNbtlqiq0qnHXZBxcVVhYMDahrHuf8Vhvo0=
Date: Mon, 27 Apr 2026 05:55:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb_cma-round-up-per_node-before-logging-it.patch removed from -mm tree
Message-Id: <20260427125509.3830AC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_cma: round up per_node before logging it
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cma-round-up-per_node-before-logging-it.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/hugetlb_cma: round up per_node before logging it
Date: Wed, 22 Apr 2026 23:33:53 +0900

When the user requests a total hugetlb CMA size without per-node
specification, hugetlb_cma_reserve() computes per_node from
hugetlb_cma_size and the number of nodes that have memory

        per_node = DIV_ROUND_UP(hugetlb_cma_size,
                                nodes_weight(hugetlb_bootmem_nodes));

The reservation loop later computes

        size = round_up(min(per_node, hugetlb_cma_size - reserved),
                          PAGE_SIZE << order);

So the actually reserved per_node size is multiple of (PAGE_SIZE <<
order), but the logged per_node is not rounded up, so it may be smaller
than the actual reserved size.

For example, as the existing comment describes, if a 3 GB area is
requested on a machine with 4 NUMA nodes that have memory, 1 GB is
allocated on the first three nodes, but the printed log is

        hugetlb_cma: reserve 3072 MiB, up to 768 MiB per node

Round per_node up to (PAGE_SIZE << order) before logging so that the
printed log always matches the actual reserved size.  No functional change
to the actual reservation size, as the following case analysis shows

1. remaining (hugetlb_cma_size - reserved) >= rounded per_node
 - AS-IS: min() picks unrounded per_node;
    round_up() returns rounded per_node
 - TO-BE: min() picks rounded per_node;
    round_up() returns rounded per_node (no-op)
2. remaining < unrounded per_node
 - AS-IS: min() picks remaining;
    round_up() returns round_up(remaining)
 - TO-BE: min() picks remaining;
    round_up() returns round_up(remaining)
3. unrounded per_node <= remaining < rounded per_node
 - AS-IS: min() picks unrounded per_node;
    round_up() returns rounded per_node
 - TO-BE: min() picks remaining;
    round_up() returns round_up(remaining) equals rounded per_node

Link: https://lore.kernel.org/20260422143353.852257-1-ekffu200098@gmail.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma") # 5.7
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cma.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-round-up-per_node-before-logging-it
+++ a/mm/hugetlb_cma.c
@@ -204,6 +204,7 @@ void __init hugetlb_cma_reserve(void)
 		 */
 		per_node = DIV_ROUND_UP(hugetlb_cma_size,
 					nodes_weight(hugetlb_bootmem_nodes));
+		per_node = round_up(per_node, PAGE_SIZE << order);
 		pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
 			hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
 	}
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-sparse-remove-unnecessary-null-check-before-allocating-mem_section.patch

