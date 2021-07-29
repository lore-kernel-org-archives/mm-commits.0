Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D14A9C4338F
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 21:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA99E60F6F
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 21:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhG2Vx4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Jul 2021 17:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhG2Vx4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 29 Jul 2021 17:53:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45BD76069E;
        Thu, 29 Jul 2021 21:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627595631;
        bh=JOo25OngLLrs4W+VceUGVk6vb3Od7FZzKu09unCNkGE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Hz6eJxUBAcpLV74vs1X6DjVhzLFG9Bm7S28VyUr0misqEX1Ti2K/Xw5Ilpu4ALx5q
         fIXAg16iF6JovI4wmyjbVLzKsW9XcNgDr3fVY2Y/RqBnIodmjX4G6dIWC6jzv9Fp/J
         EHx9GwX8sml6VZZgPWhg4cjWlVd3uZsS6w5FZocM=
Date:   Thu, 29 Jul 2021 14:53:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 6/7] slub: fix unreclaimable slab stat for bulk
 free
Message-ID: <20210729215350.SZC9InNuL%akpm@linux-foundation.org>
In-Reply-To: <20210729145259.24681c326dc3ed18194cf9e5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>
Subject: slub: fix unreclaimable slab stat for bulk free

SLUB uses page allocator for higher order allocations and update
unreclaimable slab stat for such allocations.  At the moment, the bulk
free for SLUB does not share code with normal free code path for these
type of allocations and have missed the stat update.  So, fix the stat
update by common code.  The user visible impact of the bug is the
potential of inconsistent unreclaimable slab stat visible through meminfo
and vmstat.

Link: https://lkml.kernel.org/r/20210728155354.3440560-1-shakeelb@google.com
Fixes: 6a486c0ad4dc ("mm, sl[ou]b: improve memory accounting")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/slub.c~slub-fix-unreclaimable-slab-stat-for-bulk-free
+++ a/mm/slub.c
@@ -3236,6 +3236,16 @@ struct detached_freelist {
 	struct kmem_cache *s;
 };
 
+static inline void free_nonslab_page(struct page *page)
+{
+	unsigned int order = compound_order(page);
+
+	VM_BUG_ON_PAGE(!PageCompound(page), page);
+	kfree_hook(page_address(page));
+	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B, -(PAGE_SIZE << order));
+	__free_pages(page, order);
+}
+
 /*
  * This function progressively scans the array with free objects (with
  * a limited look ahead) and extract objects belonging to the same
@@ -3272,9 +3282,7 @@ int build_detached_freelist(struct kmem_
 	if (!s) {
 		/* Handle kalloc'ed objects */
 		if (unlikely(!PageSlab(page))) {
-			BUG_ON(!PageCompound(page));
-			kfree_hook(object);
-			__free_pages(page, compound_order(page));
+			free_nonslab_page(page);
 			p[size] = NULL; /* mark object processed */
 			return size;
 		}
@@ -4250,13 +4258,7 @@ void kfree(const void *x)
 
 	page = virt_to_head_page(x);
 	if (unlikely(!PageSlab(page))) {
-		unsigned int order = compound_order(page);
-
-		BUG_ON(!PageCompound(page));
-		kfree_hook(object);
-		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
-				      -(PAGE_SIZE << order));
-		__free_pages(page, order);
+		free_nonslab_page(page);
 		return;
 	}
 	slab_free(page->slab_cache, page, object, NULL, 1, _RET_IP_);
_
