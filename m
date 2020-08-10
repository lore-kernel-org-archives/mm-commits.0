Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519C2C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E0DA206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027027;
	bh=0mGCBbW31xGqT1tPo1HU80QsM522q2QqS/sVgcHQ+D0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mNRJQVB36cq2ZwOCWC7jWgv4N51ZsAh32so98oPjk8yRqRP0XB/Dw41eAC2Xw9lpI
	 K/HB4YQbWky6Md7U81tUD7FlaGVmZgpUDE/JUzVyXypLRjt5nR2+BsJ+bCqQRgu+bp
	 B3TQpAiOCD/6hbyNx8jwk57x7K7R3slLTDbKXsQo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgHJChG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgHJChG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:37:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69C592065D;
        Mon, 10 Aug 2020 02:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027025;
        bh=0mGCBbW31xGqT1tPo1HU80QsM522q2QqS/sVgcHQ+D0=;
        h=Date:From:To:Subject:From;
        b=Df4RpBznBLcMqVAyByQzEwz859jxR/PyOx6rIULm4LG7QLnA3Rd2XYLlEURW0+OK9
         Ykj+QrfLRq0QWAvwgrsBsjPWqX85N6jcBs9qMz3ADaeL5uW61EtWAo7axBfYnjzp4a
         6mWje+QrOHLLQwitRiuKcmWaU8E28orkxTrqN7Do=
Date:   Sun, 09 Aug 2020 19:37:05 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, vbabka@suse.cz
Subject:  [merged]
 mm-memcg-slab-remove-unused-argument-by-charge_slab_page.patch removed from
 -mm tree
Message-ID: <20200810023705.Tgr_FGpFq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: remove unused argument by charge_slab_page()
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-remove-unused-argument-by-charge_slab_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: remove unused argument by charge_slab_page()

charge_slab_page() is not using the gfp argument anymore,
remove it.

Link: http://lkml.kernel.org/r/20200707173612.124425-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 mm/slab.h |    3 +--
 mm/slub.c |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

--- a/mm/slab.c~mm-memcg-slab-remove-unused-argument-by-charge_slab_page
+++ a/mm/slab.c
@@ -1379,7 +1379,7 @@ static struct page *kmem_getpages(struct
 		return NULL;
 	}
 
-	charge_slab_page(page, flags, cachep->gfporder, cachep);
+	charge_slab_page(page, cachep->gfporder, cachep);
 	__SetPageSlab(page);
 	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
 	if (sk_memalloc_socks() && page_is_pfmemalloc(page))
--- a/mm/slab.h~mm-memcg-slab-remove-unused-argument-by-charge_slab_page
+++ a/mm/slab.h
@@ -423,8 +423,7 @@ static inline struct kmem_cache *virt_to
 	return page->slab_cache;
 }
 
-static __always_inline void charge_slab_page(struct page *page,
-					     gfp_t gfp, int order,
+static __always_inline void charge_slab_page(struct page *page, int order,
 					     struct kmem_cache *s)
 {
 	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
--- a/mm/slub.c~mm-memcg-slab-remove-unused-argument-by-charge_slab_page
+++ a/mm/slub.c
@@ -1621,7 +1621,7 @@ static inline struct page *alloc_slab_pa
 		page = __alloc_pages_node(node, flags, order);
 
 	if (page)
-		charge_slab_page(page, flags, order, s);
+		charge_slab_page(page, order, s);
 
 	return page;
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

