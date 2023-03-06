Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D92C64EC4
	for <mm-commits@archiver.kernel.org>; Mon,  6 Mar 2023 21:31:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjCFVbQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbjCFVaz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2023 16:30:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C76B86141
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 13:29:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88B4D60BC3
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 21:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1483C433EF;
        Mon,  6 Mar 2023 21:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678138151;
        bh=NybSBJRASu81rraTmGnvQ9G7xUGm9B2QcfY6MPTOmeo=;
        h=Date:To:From:Subject:From;
        b=J4QcO+ehDEI/WcOCXpQ323ONWU/tBjLosfJBQQD/iRt0o0m/gzVdsApIoJ6lUV6VF
         FZxufgdLR+26E10aQ3iqxeh0qbSB17S36a6+lV6TJpG8oU6ne2OyW0bUVgbQhk0DzC
         nLjRWNaQUye9pMlhKdAh2Rd9Q0/ekOty51SgSsAo=
Date:   Mon, 06 Mar 2023 13:29:10 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, urezki@gmail.com,
        mgorman@techsingularity.net, hsiangkao@linux.alibaba.com,
        hch@lst.de, bhe@redhat.com, mhocko@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-high-order-__gfp_nofail-allocations.patch added to mm-hotfixes-unstable branch
Message-Id: <20230306212910.E1483C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] mm, vmalloc: fix high order __GFP_NOFAIL allocations
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-fix-high-order-__gfp_nofail-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-fix-high-order-__gfp_nofail-allocations.patch

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
From: Michal Hocko <mhocko@suse.com>
Subject: [PATCH] mm, vmalloc: fix high order __GFP_NOFAIL allocations
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

mm-vmalloc-fix-high-order-__gfp_nofail-allocations.patch

