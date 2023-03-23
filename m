Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9E3C6FD1F
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 01:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjCWBdm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 21:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjCWBd3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 21:33:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC2E2691
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 18:33:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E157362397
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 01:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40011C433EF;
        Thu, 23 Mar 2023 01:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535126;
        bh=cu88BSgqKwnqGQHqyOm0yxSjYfEkq/78n3AHNkV3TbU=;
        h=Date:To:From:Subject:From;
        b=h84U+HOIvZMfLsVnnYtYEQuGgI/5O/ICVZPA3uvtZnQr2z8wCpwSFSuS0g6hDsc0L
         kk9f2vV1KNry3iXujzn/jEwt1irQ1pCZ3/oBF65d7BbPyg97A5mzx8udDryt7rHrDy
         YWsu21s5LnI/rs76UaozXHmX9kvtnmNyEHAdoLKw=
Date:   Wed, 22 Mar 2023 18:32:05 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, urezki@gmail.com,
        mgorman@techsingularity.net, hsiangkao@linux.alibaba.com,
        hch@lst.de, bhe@redhat.com, mhocko@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-fix-high-order-__gfp_nofail-allocations.patch removed from -mm tree
Message-Id: <20230323013206.40011C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, vmalloc: fix high order __GFP_NOFAIL allocations
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-high-order-__gfp_nofail-allocations.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmalloc: fix high order __GFP_NOFAIL allocations
Date: Mon, 6 Mar 2023 09:15:17 +0100

Gao Xiang has reported that the page allocator complains about high order
__GFP_NOFAIL request coming from the vmalloc core:

 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5549
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2286
 vm_area_alloc_pages mm/vmalloc.c:2989 [inline]
 __vmalloc_area_node mm/vmalloc.c:3057 [inline]
 __vmalloc_node_range+0x978/0x13c0 mm/vmalloc.c:3227
 kvmalloc_node+0x156/0x1a0 mm/util.c:606
 kvmalloc include/linux/slab.h:737 [inline]
 kvmalloc_array include/linux/slab.h:755 [inline]
 kvcalloc include/linux/slab.h:760 [inline]

it seems that I have completely missed high order allocation backing
vmalloc areas case when implementing __GFP_NOFAIL support.  This means
that [k]vmalloc at al.  can allocate higher order allocations with
__GFP_NOFAIL which can trigger OOM killer for non-costly orders easily or
cause a lot of reclaim/compaction activity if those requests cannot be
satisfied.

Fix the issue by falling back to zero order allocations for __GFP_NOFAIL
requests if the high order request fails.

Link: https://lkml.kernel.org/r/ZAXynvdNqcI0f6Us@dhcp22.suse.cz
Fixes: 9376130c390a ("mm/vmalloc: add support for __GFP_NOFAIL")
Reported-by: Gao Xiang <hsiangkao@linux.alibaba.com>
  Link: https://lkml.kernel.org/r/20230305053035.1911-1-hsiangkao@linux.alibaba.com
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-vmalloc-fix-high-order-__gfp_nofail-allocations
+++ a/mm/vmalloc.c
@@ -2883,6 +2883,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		unsigned int order, unsigned int nr_pages, struct page **pages)
 {
 	unsigned int nr_allocated = 0;
+	gfp_t alloc_gfp = gfp;
+	bool nofail = false;
 	struct page *page;
 	int i;
 
@@ -2893,6 +2895,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	 * more permissive.
 	 */
 	if (!order) {
+		/* bulk allocator doesn't support nofail req. officially */
 		gfp_t bulk_gfp = gfp & ~__GFP_NOFAIL;
 
 		while (nr_allocated < nr_pages) {
@@ -2931,20 +2934,35 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			if (nr != nr_pages_request)
 				break;
 		}
+	} else if (gfp & __GFP_NOFAIL) {
+		/*
+		 * Higher order nofail allocations are really expensive and
+		 * potentially dangerous (pre-mature OOM, disruptive reclaim
+		 * and compaction etc.
+		 */
+		alloc_gfp &= ~__GFP_NOFAIL;
+		nofail = true;
 	}
 
 	/* High-order pages or fallback path if "bulk" fails. */
-
 	while (nr_allocated < nr_pages) {
 		if (fatal_signal_pending(current))
 			break;
 
 		if (nid == NUMA_NO_NODE)
-			page = alloc_pages(gfp, order);
+			page = alloc_pages(alloc_gfp, order);
 		else
-			page = alloc_pages_node(nid, gfp, order);
-		if (unlikely(!page))
-			break;
+			page = alloc_pages_node(nid, alloc_gfp, order);
+		if (unlikely(!page)) {
+			if (!nofail)
+				break;
+
+			/* fall back to the zero order allocations */
+			alloc_gfp |= __GFP_NOFAIL;
+			order = 0;
+			continue;
+		}
+
 		/*
 		 * Higher order allocations must be able to be treated as
 		 * indepdenent small pages by callers (as they can with
_

Patches currently in -mm which might be from mhocko@suse.com are

memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus.patch

