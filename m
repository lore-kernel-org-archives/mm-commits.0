Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E30C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  1 Nov 2021 18:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A891960F45
	for <mm-commits@archiver.kernel.org>; Mon,  1 Nov 2021 18:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhKAS0h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Nov 2021 14:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229760AbhKAS0g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Nov 2021 14:26:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1A8860F42;
        Mon,  1 Nov 2021 18:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635791043;
        bh=S3Sx7iKEsEPkkOqJu84ijnSj9FvkKPVgygbCXOAh2cU=;
        h=Date:From:To:Subject:From;
        b=urjfteI8wkC4AL0jQ51EEduEkrttxlGuSmU/g/3vdIInVSevo9Q4Z+0/zOCzUV9V6
         Pn1LB3Aydijlk+DdnPOuuJ7fe/ULrDn2bDsjz7ClYcrEZkxE6PqJzuuriobFCDAXiB
         WqDmwR67B9U7Yra/tTvCr5yY14YwuJFK8vtRAo3E=
Date:   Mon, 01 Nov 2021 11:24:02 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, vvs@virtuozzo.com
Subject:  [merged]
 memcg-page_alloc-skip-bulk-allocator-for-__gfp_account.patch removed from
 -mm tree
Message-ID: <20211101182402.Nx85k14Lc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT
has been removed from the -mm tree.  Its filename was
     memcg-page_alloc-skip-bulk-allocator-for-__gfp_account.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
memcg-kmem-further-deprecate-kmemlimit_in_bytes.patch

