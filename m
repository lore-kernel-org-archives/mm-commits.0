Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AF31991DB
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 21:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738012849; cv=none; b=AJWxDRaWaX9fM/fCksX9HFN2pa+2oj/+KqwNndAT6T0m5BX2sVD7mkG5fZk0cRgWNU+rX5GesAcmkb+AxDCtc6byVyUEMpnPzobsDZ0d6Kw8yZfAHCtA1Erkw6OAP24y95UQvXXStbP2OQeBGUycv1mUOX/rhUmUVBrq/C6ZLy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738012849; c=relaxed/simple;
	bh=NM8VI48oumMzZcaOnYEOegGydSfYXHCvyCvG/1U6vA0=;
	h=Date:To:From:Subject:Message-Id; b=XLP5TJzhncUhTgBnQa8OIEb+R+AsXixvHQyNYB0Z7UHd8w/Svx/OwUADVh+yQyd/fG8qnymsxGedueSzUfrSNLInzGsZFOe6CmKDst4sDr8mqRHpYaxjPxA/nNH5o371hiJB6uAMoF7xG+lgsQSMVwjonFb6sIP+WRJ/+KDOz7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oUuqtNOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oUuqtNOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048F1C4CED2;
	Mon, 27 Jan 2025 21:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738012849;
	bh=NM8VI48oumMzZcaOnYEOegGydSfYXHCvyCvG/1U6vA0=;
	h=Date:To:From:Subject:From;
	b=oUuqtNOy7U/9NUoahHX/ylKM/sLLlv/pEMdnWIabhyrMAkEq4+vn1VFsdJyzbU/4g
	 7vjq2vL/Fn5v/ZS9EtOXA7wJMRQ1fzuB4RzIOVyV3HCdNangQYVb9zmaX4kN0A98CK
	 4gwH3anzyaqmOFWmGoxOODz6EIH3C7gGJCIW1+54=
Date: Mon, 27 Jan 2025 13:20:48 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-use-the-proper-flag-to-determine-watermarks.patch added to mm-hotfixes-unstable branch
Message-Id: <20250127212049.048F1C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: compaction: use the proper flag to determine watermarks
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-compaction-use-the-proper-flag-to-determine-watermarks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-use-the-proper-flag-to-determine-watermarks.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: yangge <yangge1116@126.com>
Subject: mm: compaction: use the proper flag to determine watermarks
Date: Sat, 25 Jan 2025 14:53:57 +0800

There are 4 NUMA nodes on my machine, and each NUMA node has 32GB of
memory.  I have configured 16GB of CMA memory on each NUMA node, and
starting a 32GB virtual machine with device passthrough is extremely slow,
taking almost an hour.

Long term GUP cannot allocate memory from CMA area, so a maximum of 16 GB
of no-CMA memory on a NUMA node can be used as virtual machine memory. 
There is 16GB of free CMA memory on a NUMA node, which is sufficient to
pass the order-0 watermark check, causing the __compaction_suitable()
function to consistently return true.

For costly allocations, if the __compaction_suitable() function always
returns true, it causes the __alloc_pages_slowpath() function to fail to
exit at the appropriate point.  This prevents timely fallback to
allocating memory on other nodes, ultimately resulting in excessively long
virtual machine startup times.

Call trace:
__alloc_pages_slowpath
    if (compact_result == COMPACT_SKIPPED ||
        compact_result == COMPACT_DEFERRED)
        goto nopage; // should exit __alloc_pages_slowpath() from here

We could use the real unmovable allocation context to have
__zone_watermark_unusable_free() subtract CMA pages, and thus we won't
pass the order-0 check anymore once the non-CMA part is exhausted.  There
is some risk that in some different scenario the compaction could in fact
migrate pages from the exhausted non-CMA part of the zone to the CMA part
and succeed, and we'll skip it instead.  But only __GFP_NORETRY
allocations should be affected in the immediate "goto nopage" when
compaction is skipped, others will attempt with DEF_COMPACT_PRIORITY
anyway and won't fail without trying to compact-migrate the non-CMA
pageblocks into CMA pageblocks first, so it should be fine.

After this fix, it only takes a few tens of seconds to start a 32GB
virtual machine with device passthrough functionality.

Link: https://lore.kernel.org/lkml/1736335854-548-1-git-send-email-yangge1116@126.com/
Link: https://lkml.kernel.org/r/1737788037-8439-1-git-send-email-yangge1116@126.com
Signed-off-by: yangge <yangge1116@126.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-use-the-proper-flag-to-determine-watermarks
+++ a/mm/compaction.c
@@ -2491,7 +2491,8 @@ bool compaction_zonelist_suitable(struct
  */
 static enum compact_result
 compaction_suit_allocation_order(struct zone *zone, unsigned int order,
-				 int highest_zoneidx, unsigned int alloc_flags)
+				 int highest_zoneidx, unsigned int alloc_flags,
+				 bool async)
 {
 	unsigned long watermark;
 
@@ -2500,6 +2501,23 @@ compaction_suit_allocation_order(struct
 			      alloc_flags))
 		return COMPACT_SUCCESS;
 
+	/*
+	 * For unmovable allocations (without ALLOC_CMA), check if there is enough
+	 * free memory in the non-CMA pageblocks. Otherwise compaction could form
+	 * the high-order page in CMA pageblocks, which would not help the
+	 * allocation to succeed. However, limit the check to costly order async
+	 * compaction (such as opportunistic THP attempts) because there is the
+	 * possibility that compaction would migrate pages from non-CMA to CMA
+	 * pageblock.
+	 */
+	if (order > PAGE_ALLOC_COSTLY_ORDER && async &&
+	    !(alloc_flags & ALLOC_CMA)) {
+		watermark = low_wmark_pages(zone) + compact_gap(order);
+		if (!__zone_watermark_ok(zone, 0, watermark, highest_zoneidx,
+					   0, zone_page_state(zone, NR_FREE_PAGES)))
+			return COMPACT_SKIPPED;
+	}
+
 	if (!compaction_suitable(zone, order, highest_zoneidx))
 		return COMPACT_SKIPPED;
 
@@ -2535,7 +2553,8 @@ compact_zone(struct compact_control *cc,
 	if (!is_via_compact_memory(cc->order)) {
 		ret = compaction_suit_allocation_order(cc->zone, cc->order,
 						       cc->highest_zoneidx,
-						       cc->alloc_flags);
+						       cc->alloc_flags,
+						       cc->mode == MIGRATE_ASYNC);
 		if (ret != COMPACT_CONTINUE)
 			return ret;
 	}
@@ -3038,7 +3057,8 @@ static bool kcompactd_node_suitable(pg_d
 
 		ret = compaction_suit_allocation_order(zone,
 				pgdat->kcompactd_max_order,
-				highest_zoneidx, ALLOC_WMARK_MIN);
+				highest_zoneidx, ALLOC_WMARK_MIN,
+				false);
 		if (ret == COMPACT_CONTINUE)
 			return true;
 	}
@@ -3079,7 +3099,8 @@ static void kcompactd_do_work(pg_data_t
 			continue;
 
 		ret = compaction_suit_allocation_order(zone,
-				cc.order, zoneid, ALLOC_WMARK_MIN);
+				cc.order, zoneid, ALLOC_WMARK_MIN,
+				false);
 		if (ret != COMPACT_CONTINUE)
 			continue;
 
_

Patches currently in -mm which might be from yangge1116@126.com are

mm-compaction-use-the-proper-flag-to-determine-watermarks.patch

