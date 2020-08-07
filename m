Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D298C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E64822CB3
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781524;
	bh=JrWsDxbOEAxWwAegEG8Wu9h0J/CyaYop9PRWOmspqQg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ukBLhJp357tMnU9YvAJXU5+5K/hXDcRe1puXFE+US6TYenPptCjT1eoOx62SaN3A+
	 55qsxeOzRUHxe7eAGqytZx/or7YMHeaXjZn7ZxSxfgKax5kjZ7P9UFhRFLYtqi4WcV
	 QqeSrPRACTn/TGX2K1KNYIlhJsz1gtPaa4rBg6K8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgHGGZX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGGZW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 191CA22CAE;
        Fri,  7 Aug 2020 06:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781521;
        bh=JrWsDxbOEAxWwAegEG8Wu9h0J/CyaYop9PRWOmspqQg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nOC3bCAj4uQkMlAQPD1A5aoOkZlxgy3d6qrIL04BJt7Hc7oeVJcJXoPo2biNlDiqr
         S5fArpPPQkT4Bn182yiGc3klH2fhr4wU/e4EiFnupQChSvzEiQoQ3SkV0uNyUUINcK
         8WYaozCcoBV6hTrW5KJ72qGSJxc2cSvoan+mp9Y4=
Date:   Thu, 06 Aug 2020 23:25:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, hannes@cmpxchg.org,
        jaewon31.kim@samsung.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, ytk.lee@samsung.com
Subject:  [patch 142/163] page_alloc: consider highatomic reserve
 in watermark fast
Message-ID: <20200807062520.aaMX9WK3X%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: page_alloc: consider highatomic reserve in watermark fast

zone_watermark_fast was introduced by commit 48ee5f3696f6 ("mm,
page_alloc: shortcut watermark checks for order-0 pages").  The commit
simply checks if free pages is bigger than watermark without additional
calculation such like reducing watermark.

It considered free cma pages but it did not consider highatomic reserved. 
This may incur exhaustion of free pages except high order atomic free
pages.

Assume that reserved_highatomic pageblock is bigger than watermark min,
and there are only few free pages except high order atomic free.  Because
zone_watermark_fast passes the allocation without considering high order
atomic free, normal reclaimable allocation like GFP_HIGHUSER will consume
all the free pages.  Then finally order-0 atomic allocation may fail on
allocation.

This means watermark min is not protected against non-atomic allocation. 
The order-0 atomic allocation with ALLOC_HARDER unwantedly can be failed. 
Additionally the __GFP_MEMALLOC allocation with ALLOC_NO_WATERMARKS also
can be failed.

To avoid the problem, zone_watermark_fast should consider highatomic
reserve.  If the actual size of high atomic free is counted accurately
like cma free, we may use it.  On this patch just use
nr_reserved_highatomic.  Additionally introduce
__zone_watermark_unusable_free to factor out common parts between
zone_watermark_fast and __zone_watermark_ok.

This is an example of ALLOC_HARDER allocation failure using v4.19 based
kernel.

 Binder:9343_3: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
 Call trace:
 [<ffffff8008f40f8c>] dump_stack+0xb8/0xf0
 [<ffffff8008223320>] warn_alloc+0xd8/0x12c
 [<ffffff80082245e4>] __alloc_pages_nodemask+0x120c/0x1250
 [<ffffff800827f6e8>] new_slab+0x128/0x604
 [<ffffff800827b0cc>] ___slab_alloc+0x508/0x670
 [<ffffff800827ba00>] __kmalloc+0x2f8/0x310
 [<ffffff80084ac3e0>] context_struct_to_string+0x104/0x1cc
 [<ffffff80084ad8fc>] security_sid_to_context_core+0x74/0x144
 [<ffffff80084ad880>] security_sid_to_context+0x10/0x18
 [<ffffff800849bd80>] selinux_secid_to_secctx+0x20/0x28
 [<ffffff800849109c>] security_secid_to_secctx+0x3c/0x70
 [<ffffff8008bfe118>] binder_transaction+0xe68/0x454c
 Mem-Info:
 active_anon:102061 inactive_anon:81551 isolated_anon:0
  active_file:59102 inactive_file:68924 isolated_file:64
  unevictable:611 dirty:63 writeback:0 unstable:0
  slab_reclaimable:13324 slab_unreclaimable:44354
  mapped:83015 shmem:4858 pagetables:26316 bounce:0
  free:2727 free_pcp:1035 free_cma:178
 Node 0 active_anon:408244kB inactive_anon:326204kB active_file:236408kB inactive_file:275696kB unevictable:2444kB isolated(anon):0kB isolated(file):256kB mapped:332060kB dirty:252kB writeback:0kB shmem:19432kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
 Normal free:10908kB min:6192kB low:44388kB high:47060kB active_anon:409160kB inactive_anon:325924kB active_file:235820kB inactive_file:276628kB unevictable:2444kB writepending:252kB present:3076096kB managed:2673676kB mlocked:2444kB kernel_stack:62512kB pagetables:105264kB bounce:0kB free_pcp:4140kB local_pcp:40kB free_cma:712kB
 lowmem_reserve[]: 0 0
 Normal: 505*4kB (H) 357*8kB (H) 201*16kB (H) 65*32kB (H) 1*64kB (H) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10236kB
 138826 total pagecache pages
 5460 pages in swap cache
 Swap cache stats: add 8273090, delete 8267506, find 1004381/4060142

This is an example of ALLOC_NO_WATERMARKS allocation failure using v4.14
based kernel.

 kswapd0: page allocation failure: order:0, mode:0x140000a(GFP_NOIO|__GFP_HIGHMEM|__GFP_MOVABLE), nodemask=(null)
 kswapd0 cpuset=/ mems_allowed=0
 CPU: 4 PID: 1221 Comm: kswapd0 Not tainted 4.14.113-18770262-userdebug #1
 Call trace:
 [<0000000000000000>] dump_backtrace+0x0/0x248
 [<0000000000000000>] show_stack+0x18/0x20
 [<0000000000000000>] __dump_stack+0x20/0x28
 [<0000000000000000>] dump_stack+0x68/0x90
 [<0000000000000000>] warn_alloc+0x104/0x198
 [<0000000000000000>] __alloc_pages_nodemask+0xdc0/0xdf0
 [<0000000000000000>] zs_malloc+0x148/0x3d0
 [<0000000000000000>] zram_bvec_rw+0x410/0x798
 [<0000000000000000>] zram_rw_page+0x88/0xdc
 [<0000000000000000>] bdev_write_page+0x70/0xbc
 [<0000000000000000>] __swap_writepage+0x58/0x37c
 [<0000000000000000>] swap_writepage+0x40/0x4c
 [<0000000000000000>] shrink_page_list+0xc30/0xf48
 [<0000000000000000>] shrink_inactive_list+0x2b0/0x61c
 [<0000000000000000>] shrink_node_memcg+0x23c/0x618
 [<0000000000000000>] shrink_node+0x1c8/0x304
 [<0000000000000000>] kswapd+0x680/0x7c4
 [<0000000000000000>] kthread+0x110/0x120
 [<0000000000000000>] ret_from_fork+0x10/0x18
 Mem-Info:
 active_anon:111826 inactive_anon:65557 isolated_anon:0\x0a active_file:44260 inactive_file:83422 isolated_file:0\x0a unevictable:4158 dirty:117 writeback:0 unstable:0\x0a            slab_reclaimable:13943 slab_unreclaimable:43315\x0a mapped:102511 shmem:3299 pagetables:19566 bounce:0\x0a free:3510 free_pcp:553 free_cma:0
 Node 0 active_anon:447304kB inactive_anon:262228kB active_file:177040kB inactive_file:333688kB unevictable:16632kB isolated(anon):0kB isolated(file):0kB mapped:410044kB d irty:468kB writeback:0kB shmem:13196kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
 Normal free:14040kB min:7440kB low:94500kB high:98136kB reserved_highatomic:32768KB active_anon:447336kB inactive_anon:261668kB active_file:177572kB inactive_file:333768k           B unevictable:16632kB writepending:480kB present:4081664kB managed:3637088kB mlocked:16632kB kernel_stack:47072kB pagetables:78264kB bounce:0kB free_pcp:2280kB local_pcp:720kB free_cma:0kB        [ 4738.329607] lowmem_reserve[]: 0 0
 Normal: 860*4kB (H) 453*8kB (H) 180*16kB (H) 26*32kB (H) 34*64kB (H) 6*128kB (H) 2*256kB (H) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 14232kB

This is trace log which shows GFP_HIGHUSER consumes free pages right
before ALLOC_NO_WATERMARKS.

  <...>-22275 [006] ....   889.213383: mm_page_alloc: page=00000000d2be5665 pfn=970744 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
  <...>-22275 [006] ....   889.213385: mm_page_alloc: page=000000004b2335c2 pfn=970745 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
  <...>-22275 [006] ....   889.213387: mm_page_alloc: page=00000000017272e1 pfn=970278 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
  <...>-22275 [006] ....   889.213389: mm_page_alloc: page=00000000c4be79fb pfn=970279 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
  <...>-22275 [006] ....   889.213391: mm_page_alloc: page=00000000f8a51d4f pfn=970260 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
  <...>-22275 [006] ....   889.213393: mm_page_alloc: page=000000006ba8f5ac pfn=970261 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
  <...>-22275 [006] ....   889.213395: mm_page_alloc: page=00000000819f1cd3 pfn=970196 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
  <...>-22275 [006] ....   889.213396: mm_page_alloc: page=00000000f6b72a64 pfn=970197 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
kswapd0-1207  [005] ...1   889.213398: mm_page_alloc: page= (null) pfn=0 order=0 migratetype=1 nr_free=3650 gfp_flags=GFP_NOWAIT|__GFP_HIGHMEM|__GFP_NOWARN|__GFP_MOVABLE

[jaewon31.kim@samsung.com: remove redundant code for high-order]
  Link: http://lkml.kernel.org/r/20200623035242.27232-1-jaewon31.kim@samsung.com
Link: http://lkml.kernel.org/r/20200619235958.11283-1-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Reported-by: Yong-Taek Lee <ytk.lee@samsung.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yong-Taek Lee <ytk.lee@samsung.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   66 +++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 30 deletions(-)

--- a/mm/page_alloc.c~page_alloc-consider-highatomic-reserve-in-watermark-fast
+++ a/mm/page_alloc.c
@@ -3486,6 +3486,29 @@ static noinline bool should_fail_alloc_p
 }
 ALLOW_ERROR_INJECTION(should_fail_alloc_page, TRUE);
 
+static inline long __zone_watermark_unusable_free(struct zone *z,
+				unsigned int order, unsigned int alloc_flags)
+{
+	const bool alloc_harder = (alloc_flags & (ALLOC_HARDER|ALLOC_OOM));
+	long unusable_free = (1 << order) - 1;
+
+	/*
+	 * If the caller does not have rights to ALLOC_HARDER then subtract
+	 * the high-atomic reserves. This will over-estimate the size of the
+	 * atomic reserve but it avoids a search.
+	 */
+	if (likely(!alloc_harder))
+		unusable_free += z->nr_reserved_highatomic;
+
+#ifdef CONFIG_CMA
+	/* If allocation can't use CMA areas don't use free CMA pages */
+	if (!(alloc_flags & ALLOC_CMA))
+		unusable_free += zone_page_state(z, NR_FREE_CMA_PAGES);
+#endif
+
+	return unusable_free;
+}
+
 /*
  * Return true if free base pages are above 'mark'. For high-order checks it
  * will return true of the order-0 watermark is reached and there is at least
@@ -3501,19 +3524,12 @@ bool __zone_watermark_ok(struct zone *z,
 	const bool alloc_harder = (alloc_flags & (ALLOC_HARDER|ALLOC_OOM));
 
 	/* free_pages may go negative - that's OK */
-	free_pages -= (1 << order) - 1;
+	free_pages -= __zone_watermark_unusable_free(z, order, alloc_flags);
 
 	if (alloc_flags & ALLOC_HIGH)
 		min -= min / 2;
 
-	/*
-	 * If the caller does not have rights to ALLOC_HARDER then subtract
-	 * the high-atomic reserves. This will over-estimate the size of the
-	 * atomic reserve but it avoids a search.
-	 */
-	if (likely(!alloc_harder)) {
-		free_pages -= z->nr_reserved_highatomic;
-	} else {
+	if (unlikely(alloc_harder)) {
 		/*
 		 * OOM victims can try even harder than normal ALLOC_HARDER
 		 * users on the grounds that it's definitely going to be in
@@ -3526,13 +3542,6 @@ bool __zone_watermark_ok(struct zone *z,
 			min -= min / 4;
 	}
 
-
-#ifdef CONFIG_CMA
-	/* If allocation can't use CMA areas don't use free CMA pages */
-	if (!(alloc_flags & ALLOC_CMA))
-		free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);
-#endif
-
 	/*
 	 * Check watermarks for an order-0 allocation request. If these
 	 * are not met, then a high-order request also cannot go ahead
@@ -3581,25 +3590,22 @@ static inline bool zone_watermark_fast(s
 				unsigned long mark, int highest_zoneidx,
 				unsigned int alloc_flags)
 {
-	long free_pages = zone_page_state(z, NR_FREE_PAGES);
-	long cma_pages = 0;
+	long free_pages;
 
-#ifdef CONFIG_CMA
-	/* If allocation can't use CMA areas don't use free CMA pages */
-	if (!(alloc_flags & ALLOC_CMA))
-		cma_pages = zone_page_state(z, NR_FREE_CMA_PAGES);
-#endif
+	free_pages = zone_page_state(z, NR_FREE_PAGES);
 
 	/*
 	 * Fast check for order-0 only. If this fails then the reserves
-	 * need to be calculated. There is a corner case where the check
-	 * passes but only the high-order atomic reserve are free. If
-	 * the caller is !atomic then it'll uselessly search the free
-	 * list. That corner case is then slower but it is harmless.
+	 * need to be calculated.
 	 */
-	if (!order && (free_pages - cma_pages) >
-				mark + z->lowmem_reserve[highest_zoneidx])
-		return true;
+	if (!order) {
+		long fast_free;
+
+		fast_free = free_pages;
+		fast_free -= __zone_watermark_unusable_free(z, 0, alloc_flags);
+		if (fast_free > mark + z->lowmem_reserve[highest_zoneidx])
+			return true;
+	}
 
 	return __zone_watermark_ok(z, order, mark, highest_zoneidx, alloc_flags,
 					free_pages);
_
