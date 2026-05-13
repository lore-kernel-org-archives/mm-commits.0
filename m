Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3191991D4
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 04:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778646374; cv=none; b=U81e65tLpkLGFA2AHdIyCnkVR5VU7KebLvQetX43Ta3GZBEchUNG5cG5I6IJGXC6TnPl0i1qsQxvodJezBO78V2MEkAjRx5+tE3xDR/BkgJ6wmz/B9IhQw23VUf1QZ0rqMbvmm5V7UEbLbn/3sp13veBnJxWpO8mCt8lyxQGDtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778646374; c=relaxed/simple;
	bh=qBM0+u3s6nJHVR5SgPjCmw32kkJ8ig2nU/GZkZjWql0=;
	h=Date:To:From:Subject:Message-Id; b=EAj9YYgYCEP3V9W29xftT5tQYQ6NOwXi2Ff0yU8tVhIMANdzt30qF6rm7XGvCC3JnfQ1Q9Ai70/il0mwX4qCCk0XygvLgsTDOKdQt7DRFvQ+c5jKvYw5MM7w9JWUfLibqbe1zjpj7aaKJ3tQrEzFLfU9AVLv7sM5xi3mTpdpNVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xVHYv2D/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xVHYv2D/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CECC2BCB7;
	Wed, 13 May 2026 04:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778646374;
	bh=qBM0+u3s6nJHVR5SgPjCmw32kkJ8ig2nU/GZkZjWql0=;
	h=Date:To:From:Subject:From;
	b=xVHYv2D/w+0bB3J6Ck/RTTRKbqMUA90MKG/cO7u+NhlTJcetWgq0KoSSqCjPiI8ZF
	 Ac/Mv3x9GzrkTnDfpCKkwEKlHw3QuQrOgS7c5/jFIbzCQpf5I6TKf3IK5NFzcmREOc
	 9i8D/i4bvf7paYixeCdE8MsnL3fktzu6RcCCeVgU=
Date: Tue, 12 May 2026 21:26:13 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cma-restrict-hugetlb_cma-parameter-to-gigantic-page-alignment.patch added to mm-new branch
Message-Id: <20260513042614.10CECC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_cma: restrict hugetlb_cma parameter to gigantic-page alignment
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_cma-restrict-hugetlb_cma-parameter-to-gigantic-page-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cma-restrict-hugetlb_cma-parameter-to-gigantic-page-alignment.patch

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/hugetlb_cma: restrict hugetlb_cma parameter to gigantic-page alignment
Date: Sun, 3 May 2026 17:42:25 +0900

Existing hugetlb_cma parameter handling logic rejects sizes smaller than
one gigantic page, but rounds up larger sizes that are not a multiple of
it.  The two behaviors are inconsistent and neither is documented.

To remove existing inconsistent and undefined behavior, restrict
hugetlb_cma parameter to only accept multiples of the gigantic page size.

After this restriction, the redundant round_up() in the allocation loop
can be removed.

The new restriction is also documented in kernel-parameters.txt.

Also, including other minor changes for readability improvement with no
functional change.

Link: https://lore.kernel.org/20260503084225.415980-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    4 +
 mm/hugetlb_cma.c                                |   35 ++++++--------
 2 files changed, 20 insertions(+), 19 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-hugetlb_cma-restrict-hugetlb_cma-parameter-to-gigantic-page-alignment
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2100,6 +2100,10 @@ Kernel parameters
 			Format: nn[KMGTPE] or (node format)
 				<node>:nn[KMGTPE][,<node>:nn[KMGTPE]]
 
+			The size must be a multiple of the gigantic page size.
+			When using node format, this applies to each per-node size.
+			Missaligned values are dropped with a warning.
+
 			Reserve a CMA area of given size and allocate gigantic
 			hugepages using the CMA allocator. If enabled, the
 			boot-time allocation of gigantic hugepages is skipped.
--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-restrict-hugetlb_cma-parameter-to-gigantic-page-alignment
+++ a/mm/hugetlb_cma.c
@@ -142,7 +142,7 @@ unsigned int __weak arch_hugetlb_cma_ord
 
 void __init hugetlb_cma_reserve(void)
 {
-	unsigned long size, reserved, per_node, order;
+	unsigned long size, reserved, per_node, order, gigantic_page_size;
 	bool node_specific_cma_alloc = false;
 	int nid;
 
@@ -162,37 +162,36 @@ void __init hugetlb_cma_reserve(void)
 	 * breaking this assumption.
 	 */
 	VM_WARN_ON(order <= MAX_PAGE_ORDER);
+	gigantic_page_size = PAGE_SIZE << order;
 
 	hugetlb_bootmem_set_nodes();
 
 	for (nid = 0; nid < MAX_NUMNODES; nid++) {
-		if (hugetlb_cma_size_in_node[nid] == 0)
+		size = hugetlb_cma_size_in_node[nid];
+		if (size == 0)
 			continue;
 
 		if (!node_isset(nid, hugetlb_bootmem_nodes)) {
 			pr_warn("hugetlb_cma: invalid node %d specified\n", nid);
-			hugetlb_cma_size -= hugetlb_cma_size_in_node[nid];
-			hugetlb_cma_size_in_node[nid] = 0;
-			continue;
-		}
-
-		if (hugetlb_cma_size_in_node[nid] < (PAGE_SIZE << order)) {
-			pr_warn("hugetlb_cma: cma area of node %d should be at least %lu MiB\n",
-				nid, (PAGE_SIZE << order) / SZ_1M);
-			hugetlb_cma_size -= hugetlb_cma_size_in_node[nid];
-			hugetlb_cma_size_in_node[nid] = 0;
+		} else if (!IS_ALIGNED(size, gigantic_page_size)) {
+			pr_warn("hugetlb_cma: cma area of node %d must be a multiple of %lu MiB\n",
+				nid, gigantic_page_size / SZ_1M);
 		} else {
 			node_specific_cma_alloc = true;
+			continue;
 		}
+
+		hugetlb_cma_size -= size;
+		hugetlb_cma_size_in_node[nid] = 0;
 	}
 
 	/* Validate the CMA size again in case some invalid nodes specified. */
 	if (!hugetlb_cma_size)
 		return;
 
-	if (hugetlb_cma_size < (PAGE_SIZE << order)) {
-		pr_warn("hugetlb_cma: cma area should be at least %lu MiB\n",
-			(PAGE_SIZE << order) / SZ_1M);
+	if (!IS_ALIGNED(hugetlb_cma_size, gigantic_page_size)) {
+		pr_warn("hugetlb_cma: cma area must be a multiple of %lu MiB\n",
+			gigantic_page_size / SZ_1M);
 		hugetlb_cma_size = 0;
 		return;
 	}
@@ -204,7 +203,7 @@ void __init hugetlb_cma_reserve(void)
 		 */
 		per_node = DIV_ROUND_UP(hugetlb_cma_size,
 					nodes_weight(hugetlb_bootmem_nodes));
-		per_node = round_up(per_node, PAGE_SIZE << order);
+		per_node = round_up(per_node, gigantic_page_size);
 		pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
 			hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
 	}
@@ -223,15 +222,13 @@ void __init hugetlb_cma_reserve(void)
 			size = min(per_node, hugetlb_cma_size - reserved);
 		}
 
-		size = round_up(size, PAGE_SIZE << order);
-
 		snprintf(name, sizeof(name), "hugetlb%d", nid);
 		/*
 		 * Note that 'order per bit' is based on smallest size that
 		 * may be returned to CMA allocator in the case of
 		 * huge page demotion.
 		 */
-		res = cma_declare_contiguous_multi(size, PAGE_SIZE << order,
+		res = cma_declare_contiguous_multi(size, gigantic_page_size,
 					HUGETLB_PAGE_ORDER, name,
 					&hugetlb_cma[nid], nid);
 		if (res) {
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-sparse-remove-unnecessary-null-check-before-allocating-mem_section.patch
mm-hugetlb_cma-restrict-hugetlb_cma-parameter-to-gigantic-page-alignment.patch

