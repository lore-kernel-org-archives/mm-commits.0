Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E881C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 525162073E
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027030;
	bh=gZfcTGS8jv0OFNgSJtxDD+SE79fAQBPkMu1GMWuuGIw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=RVATC6JD7LDdJglUQtPdzmeyy3h+9X80T4Xc/tBx0l2wx71sdCPwqEwbWonOCtNZF
	 ho/mBLhidC/oxUMsPwu+BdWRjWaNKW9YikEGtsvC4XrqfWgdpWzKgM7/PE3XcnL6ez
	 SbS40xXDMliCcJH4JBJkQNZ7EQTFwlVDoR8ya0dE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgHJChK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgHJChJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:37:09 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96B7F206C3;
        Mon, 10 Aug 2020 02:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027029;
        bh=gZfcTGS8jv0OFNgSJtxDD+SE79fAQBPkMu1GMWuuGIw=;
        h=Date:From:To:Subject:From;
        b=zZuHHNIyLkx+obudoMVrGZBOg5KJBQb8Rdc8KJxzKP6mjQD4+neDQcwheeDyr0uFh
         Ockx3eZzHsgxLNvuPGeUHLKOdF59EY4mCmfRzP53x1+rqE1/WOQPyP9zDnr0C2JoiU
         qF/1qqHipJLhs5nm+zfLZhhkH7JTQC+9s3IRHgMQ=
Date:   Sun, 09 Aug 2020 19:37:08 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, vbabka@suse.cz
Subject:  [merged]
 mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page.patch removed from
 -mm tree
Message-ID: <20200810023708.favjTXL_2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slab: rename (un)charge_slab_page() to (un)account_slab_page()
has been removed from the -mm tree.  Its filename was
     mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: slab: rename (un)charge_slab_page() to (un)account_slab_page()

charge_slab_page() and uncharge_slab_page() are not related anymore to
memcg charging and uncharging.  In order to make their names less
confusing, let's rename them to account_slab_page() and
unaccount_slab_page() respectively.

Link: http://lkml.kernel.org/r/20200707173612.124425-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 mm/slab.h |    8 ++++----
 mm/slub.c |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/mm/slab.c~mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page
+++ a/mm/slab.c
@@ -1379,7 +1379,7 @@ static struct page *kmem_getpages(struct
 		return NULL;
 	}
 
-	charge_slab_page(page, cachep->gfporder, cachep);
+	account_slab_page(page, cachep->gfporder, cachep);
 	__SetPageSlab(page);
 	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
 	if (sk_memalloc_socks() && page_is_pfmemalloc(page))
@@ -1403,7 +1403,7 @@ static void kmem_freepages(struct kmem_c
 
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += 1 << order;
-	uncharge_slab_page(page, order, cachep);
+	unaccount_slab_page(page, order, cachep);
 	__free_pages(page, order);
 }
 
--- a/mm/slab.h~mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page
+++ a/mm/slab.h
@@ -423,15 +423,15 @@ static inline struct kmem_cache *virt_to
 	return page->slab_cache;
 }
 
-static __always_inline void charge_slab_page(struct page *page, int order,
-					     struct kmem_cache *s)
+static __always_inline void account_slab_page(struct page *page, int order,
+					      struct kmem_cache *s)
 {
 	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
 			    PAGE_SIZE << order);
 }
 
-static __always_inline void uncharge_slab_page(struct page *page, int order,
-					       struct kmem_cache *s)
+static __always_inline void unaccount_slab_page(struct page *page, int order,
+						struct kmem_cache *s)
 {
 	if (memcg_kmem_enabled())
 		memcg_free_page_obj_cgroups(page);
--- a/mm/slub.c~mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page
+++ a/mm/slub.c
@@ -1621,7 +1621,7 @@ static inline struct page *alloc_slab_pa
 		page = __alloc_pages_node(node, flags, order);
 
 	if (page)
-		charge_slab_page(page, order, s);
+		account_slab_page(page, order, s);
 
 	return page;
 }
@@ -1844,7 +1844,7 @@ static void __free_slab(struct kmem_cach
 	page->mapping = NULL;
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
-	uncharge_slab_page(page, order, s);
+	unaccount_slab_page(page, order, s);
 	__free_pages(page, order);
 }
 
_

Patches currently in -mm which might be from guro@fb.com are

percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

