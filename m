Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A11E94133
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbjJFVtE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbjJFVs7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:48:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E0CBE
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:48:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA06FC433C8;
        Fri,  6 Oct 2023 21:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628938;
        bh=pnE5mcK7uUsqHSas9HrXG+uH3i6wFbvSEMwDrVJZt3w=;
        h=Date:To:From:Subject:From;
        b=Hev73UVOFjcRuys09kjxv5WVNnGUtnfrTeV1osi6J9FErOX7jZ+KfYzT9T7Pjseio
         WOXeJI8iiQoQcPNDh3fa9Uad5oTjBYJmEp4LKmVdjD8dLyBT8NdBOBMjef9CUs9rs7
         ZganVNyyKQ51oteUtMbxkweCbZaVA6erZfByr6eY=
Date:   Fri, 06 Oct 2023 14:48:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sudeep.holla@arm.com, pasha.tatashin@soleen.com, mhocko@suse.com,
        mgorman@techsingularity.net, jweiner@redhat.com, david@redhat.com,
        dave.hansen@linux.intel.com, cl@linux.com, arjan@linux.intel.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pcp-avoid-to-reduce-pcp-high-unnecessarily.patch removed from -mm tree
Message-Id: <20231006214857.AA06FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, pcp: avoid to reduce PCP high unnecessarily
has been removed from the -mm tree.  Its filename was
     mm-pcp-avoid-to-reduce-pcp-high-unnecessarily.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, pcp: avoid to reduce PCP high unnecessarily
Date: Tue, 26 Sep 2023 14:09:10 +0800

In PCP high auto-tuning algorithm, to minimize idle pages in PCP, in
periodic vmstat updating kworker (via refresh_cpu_vm_stats()), we will
decrease PCP high to try to free possible idle PCP pages.  One issue is
that even if the page allocating/freeing depth is larger than maximal PCP
high, we may reduce PCP high unnecessarily.

To avoid the above issue, in this patch, we will track the minimal PCP
page count.  And, the periodic PCP high decrement will not more than the
recent minimal PCP page count.  So, only detected idle pages will be
freed.

On a 2-socket Intel server with 224 logical CPU, we run 8 kbuild instances
in parallel (each with `make -j 28`) in 8 cgroup.  This simulates the
kbuild server that is used by 0-Day kbuild service.  With the patch, The
number of pages allocated from zone (instead of from PCP) decreases 21.4%.

Link: https://lkml.kernel.org/r/20230926060911.266511-10-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 mm/page_alloc.c        |   15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/include/linux/mmzone.h~mm-pcp-avoid-to-reduce-pcp-high-unnecessarily
+++ a/include/linux/mmzone.h
@@ -680,6 +680,7 @@ enum zone_watermarks {
 struct per_cpu_pages {
 	spinlock_t lock;	/* Protects lists field */
 	int count;		/* number of pages in the list */
+	int count_min;		/* minimal number of pages in the list recently */
 	int high;		/* high watermark, emptying needed */
 	int high_min;		/* min high watermark */
 	int high_max;		/* max high watermark */
--- a/mm/page_alloc.c~mm-pcp-avoid-to-reduce-pcp-high-unnecessarily
+++ a/mm/page_alloc.c
@@ -2166,19 +2166,20 @@ static int rmqueue_bulk(struct zone *zon
  */
 int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
-	int high_min, to_drain, batch;
+	int high_min, decrease, to_drain, batch;
 	int todo = 0;
 
 	high_min = READ_ONCE(pcp->high_min);
 	batch = READ_ONCE(pcp->batch);
 	/*
-	 * Decrease pcp->high periodically to try to free possible
-	 * idle PCP pages.  And, avoid to free too many pages to
-	 * control latency.
+	 * Decrease pcp->high periodically to free idle PCP pages counted
+	 * via pcp->count_min.  And, avoid to free too many pages to
+	 * control latency.  This caps pcp->high decrement too.
 	 */
 	if (pcp->high > high_min) {
+		decrease = min(pcp->count_min, pcp->high / 5);
 		pcp->high = max3(pcp->count - (batch << PCP_BATCH_SCALE_MAX),
-				 pcp->high * 4 / 5, high_min);
+				 pcp->high - decrease, high_min);
 		if (pcp->high > high_min)
 			todo++;
 	}
@@ -2191,6 +2192,8 @@ int decay_pcp_high(struct zone *zone, st
 		todo++;
 	}
 
+	pcp->count_min = pcp->count;
+
 	return todo;
 }
 
@@ -2828,6 +2831,8 @@ struct page *__rmqueue_pcplist(struct zo
 		page = list_first_entry(list, struct page, pcp_list);
 		list_del(&page->pcp_list);
 		pcp->count -= 1 << order;
+		if (pcp->count < pcp->count_min)
+			pcp->count_min = pcp->count;
 	} while (check_new_pages(page, order));
 
 	return page;
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-fix-draining-remote-pageset.patch

