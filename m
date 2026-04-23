Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B9530EF8F;
	Thu, 23 Apr 2026 11:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776944148; cv=none; b=tz/YpttOlUzg2VzZohH00tHk2+4AsQkKBQsYrBcFOBSSVSJNjQ4uDjlZwECGd/ZWTrRw7+23f7mn5eqdUu9JMu1zWJ5V7LwM3oqhDeeScvQaW+mVi639ApwadR0C78V07dcTeWbuRzbhx6K8wBglK+P3Tv+obL6nJRHk0npO96s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776944148; c=relaxed/simple;
	bh=VhspuBBVeCMZ7cVKQ7OO5c/C0hcEdDLBwLRdNqCEUik=;
	h=Date:To:From:Subject:Message-Id; b=JpeTJaCqvOWJQla4xBWvrSdpHV+viNapeCwTdHWoVpkhBIQDgUzqmoktZaemM8CjXeQLEH46FMjU35h5wlKzgFCqOp9sfR6EptkXsq147jWZuttLdVSkQf1l+okDRBj/Bu6+kMXIpWqqqjgYVM7xXmRGtL8Y/PBze5k+IOk7VTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ztg0YlTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ztg0YlTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6F9C2BCAF;
	Thu, 23 Apr 2026 11:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776944147;
	bh=VhspuBBVeCMZ7cVKQ7OO5c/C0hcEdDLBwLRdNqCEUik=;
	h=Date:To:From:Subject:From;
	b=Ztg0YlTFe0oquXA2QebT3XQqE+YZEBEcE+YXfu+fa6LC+Zq7rea/ehEcf8E/nyg+F
	 IdOZj2COcvWfy4/86BTGMWZvN+vYdO5nddbgTs3KrsdM28MqZ56gfyCUZ0XWCILiDd
	 XM3KbzMHWS2w7ZSOx8nswdiFcbnwU9bTcE8YivxI=
Date: Thu, 23 Apr 2026 04:35:47 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cma-round-up-per_node-before-logging-it.patch added to mm-hotfixes-unstable branch
Message-Id: <20260423113547.AD6F9C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_cma: round up per_node before logging it
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb_cma-round-up-per_node-before-logging-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cma-round-up-per_node-before-logging-it.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-hugetlb_cma-round-up-per_node-before-logging-it.patch

