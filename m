Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79CFFC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 20:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BDB260FE3
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 20:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbhJOU4k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 16:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233367AbhJOU4k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 16:56:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5B8860F39;
        Fri, 15 Oct 2021 20:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634331273;
        bh=YAnwCS6inRTkRdSQu2zlhHWWC5FpmyC1RC7DVu8K3CU=;
        h=Date:From:To:Subject:From;
        b=jV9/rmGZKB8cauLN123uI97m2nImPpkQ1eKHYywpc/ISZxcISBPI+U2OmYyLiRA48
         fvKNdg3rIg5NNHEpTta6KeekH7nbk6XniA3n9rxsr3gU1lyg8wc2KV2gvb0s3RMkS6
         nLGWWIqoyO2h9Q8Vacg7k5X4IGPN2YzI6aIG+yI8=
Date:   Fri, 15 Oct 2021 13:54:32 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, vvs@virtuozzo.com
Subject:  +
 memcg-page_alloc-skip-bulk-allocator-for-__gfp_account.patch added to -mm
 tree
Message-ID: <20211015205432.qXPVCtUvD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT
has been added to the -mm tree.  Its filename is
     memcg-page_alloc-skip-bulk-allocator-for-__gfp_account.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-page_alloc-skip-bulk-allocator-for-__gfp_account.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-page_alloc-skip-bulk-allocator-for-__gfp_account.patch

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
Subject: memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT

commit 5c1f4e690eec ("mm/vmalloc: switch to bulk allocator in
__vmalloc_area_node()") switched to bulk page allocator for order 0
allocation backing vmalloc.  However bulk page allocator does not support
__GFP_ACCOUNT allocations and there are several users of
kvmalloc(__GFP_ACCOUNT).

For now make __GFP_ACCOUNT allocations bypass bulk page allocator.  In
future if there is workload that can be significantly improved with the
bulk page allocator with __GFP_ACCCOUNT support, we can revisit the
decision.

Link: https://lkml.kernel.org/r/20211014151607.2171970-1-shakeelb@google.com
Fixes: 5c1f4e690eec ("mm/vmalloc: switch to bulk allocator in __vmalloc_area_node()")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Vasily Averin <vvs@virtuozzo.com>
Tested-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_alloc.c~memcg-page_alloc-skip-bulk-allocator-for-__gfp_account
+++ a/mm/page_alloc.c
@@ -5223,6 +5223,10 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	if (unlikely(page_array && nr_pages - nr_populated == 0))
 		goto out;
 
+	/* Bulk allocator does not support memcg accounting. */
+	if (memcg_kmem_enabled() && (gfp & __GFP_ACCOUNT))
+		goto failed;
+
 	/* Use the single page allocator for one page. */
 	if (nr_pages - nr_populated == 1)
 		goto failed;
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-flush-stats-only-if-updated.patch
memcg-unify-memcg-stat-flushing.patch
memcg-page_alloc-skip-bulk-allocator-for-__gfp_account.patch

