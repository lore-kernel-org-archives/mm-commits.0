Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E274C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39AFE6113E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbhICVAG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350048AbhICVAA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A48B9610FD;
        Fri,  3 Sep 2021 20:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702740;
        bh=Ot4ig74/dnRQsnh7RC6mvy5QdoG/EZL+LwqtJNrAgfE=;
        h=Date:From:To:Subject:From;
        b=Nhm4f9miAKbM+beDEJepB1ndTt3l+RYYmGIvPon4ewNVteKZJCXRBM9J/ZnLwYSQ9
         A3tGxl3OEGHxmzgLmGQNl5WxsCIwcM6mOV7LbzaSSN6HU66oD/K8J0HB6yPDhk9qTh
         7LvN7Ce1iq5wHRkCu20laE9Fqe5r0O8uhEQrUFtE=
Date:   Fri, 03 Sep 2021 13:58:59 -0700
From:   akpm@linux-foundation.org
To:     hch@infradead.org, hdanton@sina.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject:  [merged]
 mm-vmalloc-use-batched-page-requests-in-bulk-allocator.patch removed from
 -mm tree
Message-ID: <20210903205859.8X3y_PM4s%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: use batched page requests in bulk-allocator
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-batched-page-requests-in-bulk-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: use batched page requests in bulk-allocator

In case of simultaneous vmalloc allocations, for example it is 1GB and 12
CPUs my system is able to hit "BUG: soft lockup" for !CONFIG_PREEMPT
kernel.

<snip>
[   62.512621] RIP: 0010:__alloc_pages_bulk+0xa9f/0xbb0
[   62.512628] Code: ff 8b 44 24 48 44 29 f8 83 f8 01 0f 84 ea fe ff ff e9 07 f6 ff ff 48 8b 44 24 60 48 89 28 e9 00 f9 ff ff fb 66 0f 1f 44 00 00 <e9> e8 fd ff ff 65 48 01 51 10 e9 3e fe ff ff 48 8b 44 24 78 4d 89
[   62.512629] RSP: 0018:ffffa7bfc29ffd20 EFLAGS: 00000206
[   62.512631] RAX: 0000000000000200 RBX: ffffcd5405421888 RCX: ffff8c36ffdeb928
[   62.512632] RDX: 0000000000040000 RSI: ffffa896f06b2ff8 RDI: ffffcd5405421880
[   62.512633] RBP: ffffcd5405421880 R08: 000000000000007d R09: ffffffffffffffff
[   62.512634] R10: ffffffff9d63c084 R11: 00000000ffffffff R12: ffff8c373ffaeb80
[   62.512635] R13: ffff8c36ffdf65f8 R14: ffff8c373ffaeb80 R15: 0000000000040000
[   62.512637] FS:  0000000000000000(0000) GS:ffff8c36ffdc0000(0000) knlGS:0000000000000000
[   62.512638] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   62.512639] CR2: 000055c8e2fe8610 CR3: 0000000c13e10000 CR4: 00000000000006e0
[   62.512641] Call Trace:
[   62.512646]  __vmalloc_node_range+0x11c/0x2d0
[   62.512649]  ? full_fit_alloc_test+0x140/0x140 [test_vmalloc]
[   62.512654]  __vmalloc_node+0x4b/0x70
[   62.512656]  ? fix_size_alloc_test+0x44/0x60 [test_vmalloc]
[   62.512659]  fix_size_alloc_test+0x44/0x60 [test_vmalloc]
[   62.512662]  test_func+0xe7/0x1f0 [test_vmalloc]
[   62.512666]  ? fix_align_alloc_test+0x50/0x50 [test_vmalloc]
[   62.512668]  kthread+0x11a/0x140
[   62.512671]  ? set_kthread_struct+0x40/0x40
[   62.512672]  ret_from_fork+0x22/0x30
<snip>

To address this issue invoke a bulk-allocator many times until all pages
are obtained, i.e.  do batched page requests adding cond_resched()
meanwhile to reschedule.  Batched value is hard-coded and is 100 pages per
call.

Link: https://lkml.kernel.org/r/20210707182639.31282-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-batched-page-requests-in-bulk-allocator
+++ a/mm/vmalloc.c
@@ -2779,7 +2779,7 @@ EXPORT_SYMBOL_GPL(vmap_pfn);
 
 static inline unsigned int
 vm_area_alloc_pages(gfp_t gfp, int nid,
-		unsigned int order, unsigned long nr_pages, struct page **pages)
+		unsigned int order, unsigned int nr_pages, struct page **pages)
 {
 	unsigned int nr_allocated = 0;
 
@@ -2789,10 +2789,32 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	 * to fails, fallback to a single page allocator that is
 	 * more permissive.
 	 */
-	if (!order)
-		nr_allocated = alloc_pages_bulk_array_node(
-			gfp, nid, nr_pages, pages);
-	else
+	if (!order) {
+		while (nr_allocated < nr_pages) {
+			unsigned int nr, nr_pages_request;
+
+			/*
+			 * A maximum allowed request is hard-coded and is 100
+			 * pages per call. That is done in order to prevent a
+			 * long preemption off scenario in the bulk-allocator
+			 * so the range is [1:100].
+			 */
+			nr_pages_request = min(100U, nr_pages - nr_allocated);
+
+			nr = alloc_pages_bulk_array_node(gfp, nid,
+				nr_pages_request, pages + nr_allocated);
+
+			nr_allocated += nr;
+			cond_resched();
+
+			/*
+			 * If zero or pages were obtained partly,
+			 * fallback to a single page allocator.
+			 */
+			if (nr != nr_pages_request)
+				break;
+		}
+	} else
 		/*
 		 * Compound pages required for remap_vmalloc_page if
 		 * high-order pages.
_

Patches currently in -mm which might be from urezki@gmail.com are


