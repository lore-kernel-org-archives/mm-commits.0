Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D336C4338F
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 20:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3B7460F5C
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 20:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhHPUfc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 16:35:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231760AbhHPUfb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 16:35:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A990660F39;
        Mon, 16 Aug 2021 20:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629146100;
        bh=DtJc0BpjKkK0La3npcDRW4HoRDauvQoYfvySa9XhcDQ=;
        h=Date:From:To:Subject:From;
        b=J8y5AJHYIzL1Ha4m4hV9e9F6RLfug+ZLVGVOWjIj6Y9/YuyxiYK8bdzAd5RwiP3J8
         OfQq4JzItaN2R6X5edqR7IKcwYkEmED7AgyCqs+qHc9oHU0SDEpl9HzEQ3VkZppgDY
         OGjiJl5bpRCUj599mKnyirEFcmty8pF9nl7ORUAo=
Date:   Mon, 16 Aug 2021 13:34:59 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, nathan@kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, songmuchun@bytedance.com,
        vbabka@suse.cz
Subject:  [merged]
 slub-fix-kmalloc_pagealloc_invalid_free-unit-test.patch removed from -mm
 tree
Message-ID: <20210816203459.F3Uvm86T6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: fix kmalloc_pagealloc_invalid_free unit test
has been removed from the -mm tree.  Its filename was
     slub-fix-kmalloc_pagealloc_invalid_free-unit-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: slub: fix kmalloc_pagealloc_invalid_free unit test

The unit test kmalloc_pagealloc_invalid_free makes sure that for the
higher order slub allocation which goes to page allocator, the free is
called with the correct address i.e.  the virtual address of the head
page.

The commit f227f0faf63b ("slub: fix unreclaimable slab stat for bulk
free") unified the free code paths for page allocator based slub
allocations but instead of using the address passed by the caller, it
extracted the address from the page.  Thus making the unit test
kmalloc_pagealloc_invalid_free moot.  So, fix this by using the address
passed by the caller.

Should we fix this?  I think yes because dev expect kasan to catch these
type of programming bugs.

Link: https://lkml.kernel.org/r/20210802180819.1110165-1-shakeelb@google.com
Fixes: f227f0faf63b ("slub: fix unreclaimable slab stat for bulk free")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/slub.c~slub-fix-kmalloc_pagealloc_invalid_free-unit-test
+++ a/mm/slub.c
@@ -3236,12 +3236,12 @@ struct detached_freelist {
 	struct kmem_cache *s;
 };
 
-static inline void free_nonslab_page(struct page *page)
+static inline void free_nonslab_page(struct page *page, void *object)
 {
 	unsigned int order = compound_order(page);
 
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
-	kfree_hook(page_address(page));
+	kfree_hook(object);
 	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B, -(PAGE_SIZE << order));
 	__free_pages(page, order);
 }
@@ -3282,7 +3282,7 @@ int build_detached_freelist(struct kmem_
 	if (!s) {
 		/* Handle kalloc'ed objects */
 		if (unlikely(!PageSlab(page))) {
-			free_nonslab_page(page);
+			free_nonslab_page(page, object);
 			p[size] = NULL; /* mark object processed */
 			return size;
 		}
@@ -4258,7 +4258,7 @@ void kfree(const void *x)
 
 	page = virt_to_head_page(x);
 	if (unlikely(!PageSlab(page))) {
-		free_nonslab_page(page);
+		free_nonslab_page(page, object);
 		return;
 	}
 	slab_free(page->slab_cache, page, object, NULL, 1, _RET_IP_);
_

Patches currently in -mm which might be from shakeelb@google.com are

writeback-memcg-simplify-cgroup_writeback_by_id.patch
memcg-switch-lruvec-stats-to-rstat.patch
memcg-infrastructure-to-flush-memcg-stats.patch
memcg-infrastructure-to-flush-memcg-stats-v5.patch
memcg-cleanup-racy-sum-avoidance-code.patch

