Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9479BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiANWHE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:07:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59362 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiANWHE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:07:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E6B8B825F5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F71C36AE5;
        Fri, 14 Jan 2022 22:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198022;
        bh=qCFAOoksNK3LHGlC2lmG0KH430b0yql12Aejhm+Z38o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UlVjEyJXdmIIdQZYOFIk+fk8LiDjC35tDFXy3sZsUEpjT+eu1jKdf9OqglR8ZZA/M
         WQa/wTI6m89QbyUvclVJ5fCnc4QMqSJO7eA2gGDYzIw1hE7bJG8pj7q9bqPd32SgPM
         wrsTOtw81z2pMFIS7krTstJ/WftF8ckR5EwotuYE=
Date:   Fri, 14 Jan 2022 14:07:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        david@fromorbit.com, hch@lst.de, idryomov@gmail.com,
        jlayton@kernel.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de,
        torvalds@linux-foundation.org, urezki@gmail.com, vbabka@suse.cz
Subject:  [patch 074/146] mm/vmalloc: add support for __GFP_NOFAIL
Message-ID: <20220114220701.zgLAA-x6k%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>
Subject: mm/vmalloc: add support for __GFP_NOFAIL

Dave Chinner has mentioned that some of the xfs code would benefit from
kvmalloc support for __GFP_NOFAIL because they have allocations that
cannot fail and they do not fit into a single page.

The large part of the vmalloc implementation already complies with the
given gfp flags so there is no work for those to be done.  The area and
page table allocations are an exception to that.  Implement a retry loop
for those.

Add a short sleep before retrying.  1 jiffy is a completely random
timeout.  Ideally the retry would wait for an explicit event - e.g.  a
change to the vmalloc space change if the failure was caused by the space
fragmentation or depletion.  But there are multiple different reasons to
retry and this could become much more complex.  Keep the retry simple for
now and just sleep to prevent from hogging CPUs.

Link: https://lkml.kernel.org/r/20211122153233.9924-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-support-for-__gfp_nofail
+++ a/mm/vmalloc.c
@@ -2847,6 +2847,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	 * more permissive.
 	 */
 	if (!order) {
+		gfp_t bulk_gfp = gfp & ~__GFP_NOFAIL;
+
 		while (nr_allocated < nr_pages) {
 			unsigned int nr, nr_pages_request;
 
@@ -2864,12 +2866,12 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			 * but mempolcy want to alloc memory by interleaving.
 			 */
 			if (IS_ENABLED(CONFIG_NUMA) && nid == NUMA_NO_NODE)
-				nr = alloc_pages_bulk_array_mempolicy(gfp,
+				nr = alloc_pages_bulk_array_mempolicy(bulk_gfp,
 							nr_pages_request,
 							pages + nr_allocated);
 
 			else
-				nr = alloc_pages_bulk_array_node(gfp, nid,
+				nr = alloc_pages_bulk_array_node(bulk_gfp, nid,
 							nr_pages_request,
 							pages + nr_allocated);
 
@@ -2924,6 +2926,7 @@ static void *__vmalloc_area_node(struct
 {
 	const gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
 	const gfp_t orig_gfp_mask = gfp_mask;
+	bool nofail = gfp_mask & __GFP_NOFAIL;
 	unsigned long addr = (unsigned long)area->addr;
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
@@ -2988,8 +2991,12 @@ static void *__vmalloc_area_node(struct
 	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
 		flags = memalloc_noio_save();
 
-	ret = vmap_pages_range(addr, addr + size, prot, area->pages,
+	do {
+		ret = vmap_pages_range(addr, addr + size, prot, area->pages,
 			page_shift);
+		if (nofail && (ret < 0))
+			schedule_timeout_uninterruptible(1);
+	} while (nofail && (ret < 0));
 
 	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
 		memalloc_nofs_restore(flags);
@@ -3084,9 +3091,14 @@ again:
 				  VM_UNINITIALIZED | vm_flags, start, end, node,
 				  gfp_mask, caller);
 	if (!area) {
+		bool nofail = gfp_mask & __GFP_NOFAIL;
 		warn_alloc(gfp_mask, NULL,
-			"vmalloc error: size %lu, vm_struct allocation failed",
-			real_size);
+			"vmalloc error: size %lu, vm_struct allocation failed%s",
+			real_size, (nofail) ? ". Retrying." : "");
+		if (nofail) {
+			schedule_timeout_uninterruptible(1);
+			goto again;
+		}
 		goto fail;
 	}
 
_
