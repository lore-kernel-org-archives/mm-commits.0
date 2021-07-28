Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C99C4338F
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 18:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0507661052
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 18:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhG1Snc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Jul 2021 14:43:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhG1Snb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Jul 2021 14:43:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4EF961038;
        Wed, 28 Jul 2021 18:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627497810;
        bh=UvDNmXlhaMUMBsSorJEw66czAKt0Ylptzveeq6QEs+M=;
        h=Date:From:To:Subject:From;
        b=t7U2lQO5INVsOFF8KHNkvBdeBxYsAklf7WHQ0rBgZ1ArmHwPzQh7T1JTtIlLSpuTn
         8wnxJxPt28loH1xDDS2l9gqP9zikJM774+zMHAitpbNzGX4TvWEzrWfQZdiSsLaqw7
         haSqQk1wXvkvGemJe3gQ8fvEXVjMOrm5wyZA6yhk=
Date:   Wed, 28 Jul 2021 11:43:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rientjes@google.com,
        penberg@kernel.org, mhocko@suse.com, iamjoonsoo.kim@lge.com,
        cl@linux.com, shakeelb@google.com
Subject:  + slub-fix-unreclaimable-slab-stat-for-bulk-free.patch
 added to -mm tree
Message-ID: <20210728184327.mvPrP%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: fix unreclaimable slab stat for bulk free
has been added to the -mm tree.  Its filename is
     slub-fix-unreclaimable-slab-stat-for-bulk-free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/slub-fix-unreclaimable-slab-stat-for-bulk-free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/slub-fix-unreclaimable-slab-stat-for-bulk-free.patch

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

Patches currently in -mm which might be from shakeelb@google.com are

slub-fix-unreclaimable-slab-stat-for-bulk-free.patch
writeback-memcg-simplify-cgroup_writeback_by_id.patch
memcg-switch-lruvec-stats-to-rstat.patch
memcg-infrastructure-to-flush-memcg-stats.patch
memcg-infrastructure-to-flush-memcg-stats-v5.patch

