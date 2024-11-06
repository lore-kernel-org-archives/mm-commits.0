Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D2113B284
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854797; cv=none; b=SjYJ6/NTRb2fZt6ads9zZiWlIoLq1wwR0UTAgFWDZw4j96D62qNn7Xk4AsNKK7LKV0pPBmw0eCNqHx8HmNRG2woryCzp6jKiDofxMWnI0Ex/YLq+98r1m6dqEIQGuVZ+3oa0vIFvS/GpCeA7V433wWQ8UUbxU/TxmkglT/bePcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854797; c=relaxed/simple;
	bh=UOMs7KVUQbeyPk6VlYDj50vttOk2rAaCycyC1MlIJsg=;
	h=Date:To:From:Subject:Message-Id; b=QJZxgS/XRHmj/Un/WL3IiWPdklIINaaAMvnjVnLcQBbdIZtVC1FPavTKuSD2PJePbNbbmVKTx9oUYJQwzmY/Mvixr+92YeCoQqp15fQAB8ekcdegcowuiKlfEkmKIj0EO2rHhNiZvNE0k5MpaHN41UaP9gTsSUtWJTOowkXcew0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EwkTgZ5N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EwkTgZ5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2F9C4CED1;
	Wed,  6 Nov 2024 00:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854796;
	bh=UOMs7KVUQbeyPk6VlYDj50vttOk2rAaCycyC1MlIJsg=;
	h=Date:To:From:Subject:From;
	b=EwkTgZ5N2rRUE8bRaQGuiMr7hmPt0Rn9m9s42orexi/36WTmkgGcGrqiip6yHnTtb
	 CkKqdlTFAX7AigGWs+QY154OEp8K5+ojtf5ycXFQIfQrVRQNtxkyPnmde24xhJYV3w
	 1SwGbcDpMi/5dcjid4VsxOogi2KjDtjP+/7xz9dg=
Date: Tue, 05 Nov 2024 16:59:56 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,suhua1@kingsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-perform-vmemmap-optimization-batchly-for-specific-node-allocation.patch removed from -mm tree
Message-Id: <20241106005956.CB2F9C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: perform vmemmap optimization batchly for specific node allocation
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-perform-vmemmap-optimization-batchly-for-specific-node-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: suhua <suhua1@kingsoft.com>
Subject: mm/hugetlb: perform vmemmap optimization batchly for specific node allocation
Date: Sat, 12 Oct 2024 15:08:02 +0800

When HVO is enabled and huge page memory allocs are made, the freed memory
can be aggregated into higher order memory in the following paths, which
facilitates further allocs for higher order memory.

echo 200000 > /proc/sys/vm/nr_hugepages
echo 200000 > /sys/devices/system/node/node*/hugepages/hugepages-2048kB/nr_hugepages
grub default_hugepagesz=2M hugepagesz=2M hugepages=200000

Currently not support for releasing aggregations to higher order in the
following way, which will releasing to lower order.

grub: default_hugepagesz=2M hugepagesz=2M hugepages=0:100000,1:100000

This patch supports the release of huge page optimizations aggregates to
higher order memory.

eg:
cat /proc/cmdline
BOOT_IMAGE=/boot/vmlinuz-xxx ... default_hugepagesz=2M hugepagesz=2M hugepages=0:100000,1:100000

Before:
Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10
...
Node    0, zone   Normal, type    Unmovable  55282  97039  99307      0      1      1      0      1      1      1      0
Node    0, zone   Normal, type      Movable     25     11    345     87     48     21      2     20      9      3  75061
Node    0, zone   Normal, type  Reclaimable      4      2      2      4      3      0      2      1      1      1      0
Node    0, zone   Normal, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
...
Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10
Node    1, zone   Normal, type    Unmovable  98888  99650  99679      2      3      1      2      2      2      0      0
Node    1, zone   Normal, type      Movable      1      1      0      1      1      0      1      0      1      1  75937
Node    1, zone   Normal, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0
Node    1, zone   Normal, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0

After:
Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10
...
Node    0, zone   Normal, type    Unmovable    152    158     37      2      2      0      3      4      2      6    717
Node    0, zone   Normal, type      Movable      1     37     53      3     55     49     16      6      2      1  75000
Node    0, zone   Normal, type  Reclaimable      1      4      3      1      2      1      1      1      1      1      0
Node    0, zone   Normal, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
...
Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10
Node    1, zone   Normal, type    Unmovable      5      3      2      1      3      4      2      2      2      0    779
Node    1, zone   Normal, type      Movable      1      0      1      1      1      0      1      0      1      1  75849
Node    1, zone   Normal, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0
Node    1, zone   Normal, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0

Link: https://lkml.kernel.org/r/20241012070802.1876-1-suhua1@kingsoft.com
Signed-off-by: suhua <suhua1@kingsoft.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-perform-vmemmap-optimization-batchly-for-specific-node-allocation
+++ a/mm/hugetlb.c
@@ -3301,6 +3301,7 @@ static void __init hugetlb_hstate_alloc_
 {
 	unsigned long i;
 	char buf[32];
+	LIST_HEAD(folio_list);
 
 	for (i = 0; i < h->max_huge_pages_node[nid]; ++i) {
 		if (hstate_is_gigantic(h)) {
@@ -3310,14 +3311,18 @@ static void __init hugetlb_hstate_alloc_
 			struct folio *folio;
 			gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 
-			folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
-					&node_states[N_MEMORY]);
+			folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
+					&node_states[N_MEMORY], NULL);
 			if (!folio)
 				break;
-			free_huge_folio(folio); /* free it into the hugepage allocator */
+			list_add(&folio->lru, &folio_list);
 		}
 		cond_resched();
 	}
+
+	if (!list_empty(&folio_list))
+		prep_and_add_allocated_folios(h, &folio_list);
+
 	if (i == h->max_huge_pages_node[nid])
 		return;
 
_

Patches currently in -mm which might be from suhua1@kingsoft.com are


