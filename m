Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03D9C433C1
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 17:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 707E06197E
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 17:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhCSRpm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 13:45:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230090AbhCSRpQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 13:45:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFAE66197D;
        Fri, 19 Mar 2021 17:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616175916;
        bh=IQZxEmO/d7FXl8OfH1BiTfeb+hpF92Pz2Neq+y9lF6M=;
        h=Date:From:To:Subject:From;
        b=CrCgE2kiwOlMPfA8BKPv7S9R2BaSM4VBFtHh8Q7vP0CagPtqTygfanlJmIAxUp3xr
         YegC3zL2Lx9dQk1iEnIgoFNYTw+QDYYnNXjtc8B/wU+kaXapmNuMxHw9afeeTu62QN
         8qbm9FXX6PI6R0AKYMWhIFbzAr7oKsxFSFTqrUzw=
Date:   Fri, 19 Mar 2021 10:45:15 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        willy@infradead.org, zhouguanghui1@huawei.com, ziy@nvidia.com
Subject:  +
 mm-page_alloc-fix-memcg-accounting-leak-in-speculative-cache-lookup.patch
 added to -mm tree
Message-ID: <20210319174515.PqOfKgJhs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: fix memcg accounting leak in speculative cache lookup
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-memcg-accounting-leak-in-speculative-cache-lookup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-memcg-accounting-leak-in-speculative-cache-lookup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-memcg-accounting-leak-in-speculative-cache-lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: fix memcg accounting leak in speculative cache lookup

When the freeing of a higher-order page block (non-compound) races with a
speculative page cache lookup, __free_pages() needs to leave the first
order-0 page in the chunk to the lookup but free the buddy pages that the
lookup doesn't know about separately.

However, if such a higher-order page is charged to a memcg (e.g.  !vmap
kernel stack)), only the first page of the block has page->memcg set. 
That means we'll uncharge only one order-0 page from the entire block, and
leak the remainder.

Add a split_page_memcg() to __free_pages() right before it starts taking
the higher-order page apart and freeing its individual constituent pages. 
This ensures all of them will have the memcg linkage set up for correct
uncharging.  Also update the comments a bit to clarify what exactly is
happening to the page during that race.

This bug is old and has its roots in the speculative page cache patch and
adding cgroup accounting of kernel pages.  There are no known user
reports.  A backport to stable is therefor not warranted.

Link: https://lkml.kernel.org/r/20210319071547.60973-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Zhou Guanghui <zhouguanghui1@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
CC: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-memcg-accounting-leak-in-speculative-cache-lookup
+++ a/mm/page_alloc.c
@@ -5111,10 +5111,9 @@ static inline void free_the_page(struct
  * the allocation, so it is easy to leak memory.  Freeing more memory
  * than was allocated will probably emit a warning.
  *
- * If the last reference to this page is speculative, it will be released
- * by put_page() which only frees the first page of a non-compound
- * allocation.  To prevent the remaining pages from being leaked, we free
- * the subsequent pages here.  If you want to use the page's reference
+ * This function isn't a put_page(). Don't let the put_page_testzero()
+ * fool you, it's only to deal with speculative cache references. It
+ * WILL free pages directly. If you want to use the page's reference
  * count to decide when to free the allocation, you should allocate a
  * compound page, and use put_page() instead of __free_pages().
  *
@@ -5123,11 +5122,33 @@ static inline void free_the_page(struct
  */
 void __free_pages(struct page *page, unsigned int order)
 {
-	if (put_page_testzero(page))
+	/*
+	 * Drop the base reference from __alloc_pages and free. In
+	 * case there is an outstanding speculative reference, from
+	 * e.g. the page cache, it will put and free the page later.
+	 */
+	if (likely(put_page_testzero(page))) {
 		free_the_page(page, order);
-	else if (!PageHead(page))
+		return;
+	}
+
+	/*
+	 * The speculative reference will put and free the page.
+	 *
+	 * However, if the speculation was into a higher-order page
+	 * chunk that isn't marked compound, the other side will know
+	 * nothing about our buddy pages and only free the order-0
+	 * page at the start of our chunk! We must split off and free
+	 * the buddy pages here.
+	 *
+	 * The buddy pages aren't individually refcounted, so they
+	 * can't have any pending speculative references themselves.
+	 */
+	if (!PageHead(page) && order > 0) {
+		split_page_memcg(page, 1 << order);
 		while (order-- > 0)
 			free_the_page(page + (1 << order), order);
+	}
 }
 EXPORT_SYMBOL(__free_pages);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page-writeback-simplify-memcg-handling-in-test_clear_page_writeback.patch
mm-memcontrol-fix-cpuhotplug-statistics-flushing.patch
mm-memcontrol-kill-mem_cgroup_nodeinfo.patch
mm-memcontrol-privatize-memcg_page_state-query-functions.patch
cgroup-rstat-support-cgroup1.patch
cgroup-rstat-punt-root-level-optimization-to-individual-controllers.patch
mm-memcontrol-switch-to-rstat.patch
mm-memcontrol-switch-to-rstat-fix-2.patch
mm-memcontrol-consolidate-lruvec-stat-flushing.patch
kselftests-cgroup-update-kmem-test-for-new-vmstat-implementation.patch
mm-page_alloc-fix-memcg-accounting-leak-in-speculative-cache-lookup.patch

