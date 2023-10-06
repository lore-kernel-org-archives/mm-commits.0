Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A961CE94125
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbjJFVsn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbjJFVsm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:48:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25787CA
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:48:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6717AC433C9;
        Fri,  6 Oct 2023 21:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628920;
        bh=ArtKX9GEpkuglb92HNvdtN9ML9ls1yiMSdR3c1Ge1X8=;
        h=Date:To:From:Subject:From;
        b=t2QQp13K29PZqu/sfhcwOfcyv6uS8RRP1LDl/T55Wb2oluRvYWeRB3zDXzXQcKqjg
         r+wBZgu+udDZDiVFK/X7rl/urRIoKP+xFz/yUWBgWLCQGu9aLlVbiKiokGc9gAdasl
         rJcTJNS+/BWhIyQqwk//mqU3m5rTkaIfo+MnGdxU=
Date:   Fri, 06 Oct 2023 14:48:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sudeep.holla@arm.com, pasha.tatashin@soleen.com, mhocko@suse.com,
        mgorman@techsingularity.net, jweiner@redhat.com, david@redhat.com,
        dave.hansen@linux.intel.com, cl@linux.com, arjan@linux.intel.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pcp-reduce-lock-contention-for-draining-high-order-pages.patch removed from -mm tree
Message-Id: <20231006214840.6717AC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, pcp: reduce lock contention for draining high-order pages
has been removed from the -mm tree.  Its filename was
     mm-pcp-reduce-lock-contention-for-draining-high-order-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, pcp: reduce lock contention for draining high-order pages
Date: Tue, 26 Sep 2023 14:09:04 +0800

In commit f26b3fa04611 ("mm/page_alloc: limit number of high-order pages
on PCP during bulk free"), the PCP (Per-CPU Pageset) will be drained when
PCP is mostly used for high-order pages freeing to improve the cache-hot
pages reusing between page allocating and freeing CPUs.

On system with small per-CPU data cache, pages shouldn't be cached before
draining to guarantee cache-hot.  But on a system with large per-CPU data
cache, more pages can be cached before draining to reduce zone lock
contention.

So, in this patch, instead of draining without any caching, "batch" pages
will be cached in PCP before draining if the per-CPU data cache size is
more than "4 * batch".

On a 2-socket Intel server with 128 logical CPU, with the patch, the
network bandwidth of the UNIX (AF_UNIX) test case of lmbench test suite
with 16-pair processes increase 72.2%.  The cycles% of the spinlock
contention (mostly for zone lock) decreases from 45.8% to 21.2%.  The
number of PCP draining for high order pages freeing (free_high) decreases
89.8%.  The cache miss rate keeps 0.3%.

Link: https://lkml.kernel.org/r/20230926060911.266511-4-ying.huang@intel.com
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

 drivers/base/cacheinfo.c |    2 ++
 include/linux/gfp.h      |    1 +
 include/linux/mmzone.h   |    1 +
 mm/page_alloc.c          |   37 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 40 insertions(+), 1 deletion(-)

--- a/drivers/base/cacheinfo.c~mm-pcp-reduce-lock-contention-for-draining-high-order-pages
+++ a/drivers/base/cacheinfo.c
@@ -943,6 +943,7 @@ static int cacheinfo_cpu_online(unsigned
 	if (rc)
 		goto err;
 	update_data_cache_size(true, cpu);
+	setup_pcp_cacheinfo();
 	return 0;
 err:
 	free_cache_attributes(cpu);
@@ -956,6 +957,7 @@ static int cacheinfo_cpu_pre_down(unsign
 
 	free_cache_attributes(cpu);
 	update_data_cache_size(false, cpu);
+	setup_pcp_cacheinfo();
 	return 0;
 }
 
--- a/include/linux/gfp.h~mm-pcp-reduce-lock-contention-for-draining-high-order-pages
+++ a/include/linux/gfp.h
@@ -325,6 +325,7 @@ void drain_all_pages(struct zone *zone);
 void drain_local_pages(struct zone *zone);
 
 void page_alloc_init_late(void);
+void setup_pcp_cacheinfo(void);
 
 /*
  * gfp_allowed_mask is set to GFP_BOOT_MASK during early boot to restrict what
--- a/include/linux/mmzone.h~mm-pcp-reduce-lock-contention-for-draining-high-order-pages
+++ a/include/linux/mmzone.h
@@ -675,6 +675,7 @@ enum zone_watermarks {
 #define wmark_pages(z, i) (z->_watermark[i] + z->watermark_boost)
 
 #define	PCPF_PREV_FREE_HIGH_ORDER	0x01
+#define	PCPF_FREE_HIGH_BATCH		0x02
 
 struct per_cpu_pages {
 	spinlock_t lock;	/* Protects lists field */
--- a/mm/page_alloc.c~mm-pcp-reduce-lock-contention-for-draining-high-order-pages
+++ a/mm/page_alloc.c
@@ -52,6 +52,7 @@
 #include <linux/psi.h>
 #include <linux/khugepaged.h>
 #include <linux/delayacct.h>
+#include <linux/cacheinfo.h>
 #include <asm/div64.h>
 #include "internal.h"
 #include "shuffle.h"
@@ -2385,7 +2386,9 @@ static void free_unref_page_commit(struc
 	 */
 	if (order && order <= PAGE_ALLOC_COSTLY_ORDER) {
 		free_high = (pcp->free_factor &&
-			     (pcp->flags & PCPF_PREV_FREE_HIGH_ORDER));
+			     (pcp->flags & PCPF_PREV_FREE_HIGH_ORDER) &&
+			     (!(pcp->flags & PCPF_FREE_HIGH_BATCH) ||
+			      pcp->count >= READ_ONCE(pcp->batch)));
 		pcp->flags |= PCPF_PREV_FREE_HIGH_ORDER;
 	} else if (pcp->flags & PCPF_PREV_FREE_HIGH_ORDER) {
 		pcp->flags &= ~PCPF_PREV_FREE_HIGH_ORDER;
@@ -5418,6 +5421,38 @@ static void zone_pcp_update(struct zone
 	mutex_unlock(&pcp_batch_high_lock);
 }
 
+static void zone_pcp_update_cacheinfo(struct zone *zone)
+{
+	int cpu;
+	struct per_cpu_pages *pcp;
+	struct cpu_cacheinfo *cci;
+
+	for_each_online_cpu(cpu) {
+		pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
+		cci = get_cpu_cacheinfo(cpu);
+		/*
+		 * If per-CPU data cache is large enough, up to
+		 * "batch" high-order pages can be cached in PCP for
+		 * consecutive freeing.  This can reduce zone lock
+		 * contention without hurting cache-hot pages sharing.
+		 */
+		spin_lock(&pcp->lock);
+		if ((cci->size_data >> PAGE_SHIFT) > 4 * pcp->batch)
+			pcp->flags |= PCPF_FREE_HIGH_BATCH;
+		else
+			pcp->flags &= ~PCPF_FREE_HIGH_BATCH;
+		spin_unlock(&pcp->lock);
+	}
+}
+
+void setup_pcp_cacheinfo(void)
+{
+	struct zone *zone;
+
+	for_each_populated_zone(zone)
+		zone_pcp_update_cacheinfo(zone);
+}
+
 /*
  * Allocate per cpu pagesets and initialize them.
  * Before this call only boot pagesets were available.
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-fix-draining-remote-pageset.patch

