Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33B1335C7
	for <mm-commits@vger.kernel.org>; Sat, 12 Oct 2024 22:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728770738; cv=none; b=ogi8D4yZnBswOdy9aZ8mNpt7ESGvJNedJy0XopPXVlZPzqwI+vPhQlynWYKARKiaE+6j8Wlc1azR0/9xNXCcyEewTAY8lHWPhR3yjTzHF267/7IrXEkvIpn8kF5NVkrHGAA51EYkrD5zotjGm1v4kPmCfCGiNefDjRQAVm9nyTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728770738; c=relaxed/simple;
	bh=APm0oF4BU9lQurzDGzAicZaKGoIZz6KEbf3q1vu9bSs=;
	h=Date:To:From:Subject:Message-Id; b=txZDlifg5YDnnjlTDp7nlvLWlNMEZysi9lx3KR+lLOuxRb39sB3gH4LYkGeZT+bkiT1LdrGVUxdFel7n42cRAHDQJAzUz9e7gbqpg7yyfUMWRbWem96C25cuSv+ijEu1ji7o1bRt3PEKjDXQ2Y6R4P4EB+c1cawVs/WE/6sSLUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RDSpLhg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RDSpLhg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E31C4CEC6;
	Sat, 12 Oct 2024 22:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728770738;
	bh=APm0oF4BU9lQurzDGzAicZaKGoIZz6KEbf3q1vu9bSs=;
	h=Date:To:From:Subject:From;
	b=RDSpLhg/ErOOxr+SuqEpx5FOjjFzX9nDVnJAkwaS8B7vY8WeaVj7zlSPQ1NSGandx
	 XIrFZb9/OIjTxL50yNHGrWsnIv1I10blDTJ2/x/niUS+EO9B62DIEQneYvXWmFjN/S
	 1feLbNNKg99iz82YpoRtW0cM4mMKjhqOvEQh9SAU=
Date: Sat, 12 Oct 2024 15:05:37 -0700
To: mm-commits@vger.kernel.org,suhua1@kingsoft.com,muchun.song@linux.dev,suhua.tanke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-perform-vmemmap-optimization-batchly-for-specific-node-allocation.patch added to mm-unstable branch
Message-Id: <20241012220538.27E31C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: perform vmemmap optimization batchly for specific node allocation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-perform-vmemmap-optimization-batchly-for-specific-node-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-perform-vmemmap-optimization-batchly-for-specific-node-allocation.patch

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
From: suhua <suhua.tanke@gmail.com>
Subject: mm/hugetlb: perform vmemmap optimization batchly for specific node allocation
Date: Sat, 12 Oct 2024 15:08:02 +0800

When HVO is enabled and huge page memory allocs are made, the freed memory
can be aggregated into higher order memory in the following paths, which
facilitates further allocs for higher order memory.

echo 200000 > /proc/sys/vm/nr_hugepages
echo 200000 > /sys/devices/system/node/node*/hugepages/hugepages-2048kB/nr_hugepages
grub： default_hugepagesz=2M hugepagesz=2M hugepages=200000

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

Patches currently in -mm which might be from suhua.tanke@gmail.com are

mm-hugetlb-perform-vmemmap-optimization-batchly-for-specific-node-allocation.patch

