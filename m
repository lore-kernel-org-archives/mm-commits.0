Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252E2C4338F
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 20:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B2BC61102
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 20:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbhHBUdJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Aug 2021 16:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhHBUdI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Aug 2021 16:33:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B054D60F93;
        Mon,  2 Aug 2021 20:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627936378;
        bh=MfWKNlyFXIM7aZiBGYJyx9O2relZZjlE8BRzDHFtEKY=;
        h=Date:From:To:Subject:From;
        b=0cgTlVUFnhhHUNyK73QFjhrqp8yNLNjwNyHyZe5A8HnfNV8ietljgFr3WbZFRl0AW
         vYs/TTf05T5s5vqyFLnS2ggWpSiCSJkGz43br8R5rADvh2gOGiuylOMLaJ7JcuYpCl
         Tx3pkSIFS3loajSG2BD3SDTTzR7mKiZvFqQU5DKc=
Date:   Mon, 02 Aug 2021 13:32:55 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        songmuchun@bytedance.com, rientjes@google.com, penberg@kernel.org,
        nathan@kernel.org, mhocko@suse.com, iamjoonsoo.kim@lge.com,
        guro@fb.com, cl@linux.com, shakeelb@google.com
Subject:  + slub-fix-kmalloc_pagealloc_invalid_free-unit-test.patch
 added to -mm tree
Message-ID: <20210802203255.GrOu_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: fix kmalloc_pagealloc_invalid_free unit test
has been added to the -mm tree.  Its filename is
     slub-fix-kmalloc_pagealloc_invalid_free-unit-test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/slub-fix-kmalloc_pagealloc_invalid_free-unit-test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/slub-fix-kmalloc_pagealloc_invalid_free-unit-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
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

slub-fix-kmalloc_pagealloc_invalid_free-unit-test.patch
writeback-memcg-simplify-cgroup_writeback_by_id.patch
memcg-switch-lruvec-stats-to-rstat.patch
memcg-infrastructure-to-flush-memcg-stats.patch
memcg-infrastructure-to-flush-memcg-stats-v5.patch
memcg-cleanup-racy-sum-avoidance-code.patch

