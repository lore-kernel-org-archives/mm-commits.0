Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C5D152E00
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 22:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717625831; cv=none; b=IN3cBoXc3I1quj2lyAWb1ifElhjkArzOZgwcMxMlxnnAXtEB19gda0WSVGsrT4M42Km3ZFvYKp1I/xwURUSId90FyddS9PloujOS+1m5Qd4jbftZEMpU+1hLCDYrIgRVTVrRRmPUNnAu0rxLC/uAS4Dwl8aK54BipNI4MO4YJrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717625831; c=relaxed/simple;
	bh=VHpbxh6IVzwqcRMXWCpavv9BWGgE1il25as3e3rTQ3E=;
	h=Date:To:From:Subject:Message-Id; b=EMvF2PXtWp8EgwrO1IY4RMbyINVcT3Yb0FsrfuMP7lIjgPDw0TDlIsZl1TDO+JBxPC+hdLyDkqmEsouT6tSjyD03gheOklOVppqyy1gKwzsooNpp3gM/g38Kmd5RoGiu6ymIB+Uawg1VikUPu9PsmrxoJjHRMTlqY3d0NJTl0b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oOJMNywe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oOJMNywe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A97C2BD11;
	Wed,  5 Jun 2024 22:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717625830;
	bh=VHpbxh6IVzwqcRMXWCpavv9BWGgE1il25as3e3rTQ3E=;
	h=Date:To:From:Subject:From;
	b=oOJMNyweayXt5TiTNUj1qziZBCb/1s1HBAvghRyXREjYQ+2lIFUQktFz53pT9acSv
	 iqHs5Q5PivWNo8NBiqhpzwozQvaag15bUZjIyza6uyWWegvZ9JQFQZw0b8VEkJdJbM
	 2IH3DJ2BGWv8E1r4oZHtbBiuTPdWf/gMkViGpKaA=
Date: Wed, 05 Jun 2024 15:17:09 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-mm_initc-get-the-highest-zone-directly.patch removed from -mm tree
Message-Id: <20240605221710.80A97C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: get the highest zone directly
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-get-the-highest-zone-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mm_init.c: get the highest zone directly
Date: Fri, 31 May 2024 00:26:11 +0000

We have recorded nr_zones in pgdat, just get it directly.

Link: https://lkml.kernel.org/r/20240531002613.5231-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-get-the-highest-zone-directly
+++ a/mm/mm_init.c
@@ -2137,7 +2137,7 @@ static int __init deferred_init_memmap(v
 	unsigned long first_init_pfn, flags;
 	unsigned long start = jiffies;
 	struct zone *zone;
-	int zid, max_threads;
+	int max_threads;
 	u64 i;
 
 	/* Bind memory initialisation thread to a local node if possible */
@@ -2164,12 +2164,8 @@ static int __init deferred_init_memmap(v
 	 */
 	pgdat_resize_unlock(pgdat, &flags);
 
-	/* Only the highest zone is deferred so find it */
-	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-		zone = pgdat->node_zones + zid;
-		if (first_init_pfn < zone_end_pfn(zone))
-			break;
-	}
+	/* Only the highest zone is deferred */
+	zone = pgdat->node_zones + pgdat->nr_zones - 1;
 
 	/* If the zone is empty somebody else may have cleared out the zone */
 	if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
@@ -2197,7 +2193,7 @@ static int __init deferred_init_memmap(v
 	}
 zone_empty:
 	/* Sanity check that the next zone really is unpopulated */
-	WARN_ON(++zid < MAX_NR_ZONES && populated_zone(++zone));
+	WARN_ON(pgdat->nr_zones < MAX_NR_ZONES && populated_zone(++zone));
 
 	pr_info("node %d deferred pages initialised in %ums\n",
 		pgdat->node_id, jiffies_to_msecs(jiffies - start));
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-use-deferred_init_mem_pfn_range_in_zone-to-decide-loop-condition.patch
mm-mm_initc-not-always-search-next-deferred_init_pfn-from-very-beginning.patch

