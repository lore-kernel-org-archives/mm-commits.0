Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB26A2165ED
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188364; cv=none; b=AliaivLm2wG6QBU8LkQeHPhbsQyO6wPjRfbTmra3Y0L53e8N76IsjQmfeyqsfCq15uWs70MnBpC57yVrppTJNvfgDG+GtEoY7Ne62JOBmKiVAKRKD9dLiacxgSChTGs2f22D70N0wK3mqNItyFRoJs5hVoj6srJG/Zm/1bZVJ88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188364; c=relaxed/simple;
	bh=V95XKCwK3jWPyzwqtt1ZHGEKDtDOv3dHkyfYMZ7Gs9U=;
	h=Date:To:From:Subject:Message-Id; b=NJcBM/R1bkTU1s4CUno7ERvQGZ3278/GliaojLqhdPPRd8oL6perKzw9AZb9CC5IqfSH63DOonT2NuO+HIl4JF6eqertjkFkialbH4Ri8z5gVB+h9FWk0VJ2CZ01i5zBHYQcHqoJgby0DUYNrKDGjYjI2+LN1Kmyrp65PAr3GWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1pROu0B0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1pROu0B0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE9BC4CEEC;
	Mon, 17 Mar 2025 05:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188364;
	bh=V95XKCwK3jWPyzwqtt1ZHGEKDtDOv3dHkyfYMZ7Gs9U=;
	h=Date:To:From:Subject:From;
	b=1pROu0B0WdZCgapSICqAENiWOXEelH8aSm5VZZfGaYxil8TrznM5Bj6lzC+gKNEF0
	 vHSBB/ukNSutk8mEAzvXCjaSBQIitiKxJMwgoOJly3VeDzlLM2mGNulhZ8QAmHd1Ea
	 ALgLdGtLExVMdUO4HssFvVulHs7D7NYpvMZ6JPpE=
Date: Sun, 16 Mar 2025 22:12:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch removed from -mm tree
Message-Id: <20250317051244.9DE9BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: use online nodes for bootmem allocation
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: use online nodes for bootmem allocation
Date: Fri, 28 Feb 2025 18:29:07 +0000

Later commits will move hugetlb bootmem allocation to earlier in init,
when N_MEMORY has not yet been set on nodes.  Use online nodes instead. 
At most, this wastes just a few cycles once during boot (and most likely
none).

Link: https://lkml.kernel.org/r/20250228182928.2645936-7-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-online-nodes-for-bootmem-allocation
+++ a/mm/hugetlb.c
@@ -3164,7 +3164,7 @@ int __alloc_bootmem_huge_page(struct hst
 		goto found;
 	}
 	/* allocate from next node when distributing huge pages */
-	for_each_node_mask_to_alloc(&h->next_nid_to_alloc, nr_nodes, node, &node_states[N_MEMORY]) {
+	for_each_node_mask_to_alloc(&h->next_nid_to_alloc, nr_nodes, node, &node_states[N_ONLINE]) {
 		m = memblock_alloc_try_nid_raw(
 				huge_page_size(h), huge_page_size(h),
 				0, MEMBLOCK_ALLOC_ACCESSIBLE, node);
@@ -4558,8 +4558,8 @@ void __init hugetlb_add_hstate(unsigned
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 	INIT_LIST_HEAD(&h->hugepage_activelist);
-	h->next_nid_to_alloc = first_memory_node;
-	h->next_nid_to_free = first_memory_node;
+	h->next_nid_to_alloc = first_online_node;
+	h->next_nid_to_free = first_online_node;
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/SZ_1K);
 
_

Patches currently in -mm which might be from fvdl@google.com are


