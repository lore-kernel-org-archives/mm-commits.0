Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C18D6C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E6D1610E5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhJ1Vif (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230476AbhJ1Vic (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Oct 2021 17:38:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3670160FF2;
        Thu, 28 Oct 2021 21:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635456965;
        bh=jxWwOHabNnscVRy+r9kwuAbCzrielvvANPWmTQgJG2M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Wcg1c+P1+TuytgC/ZMbnWsQRbXL6nwTrL1/EZnjBmoXN1YRT1PCfDLu3GnJIii2W/
         xqPjXLNo9vhAaYm4usQcJzI6noEWQDo3mcPIrdciN4Vsdetf3g/leZwnpyVSE7EYcr
         fKubFsnjk9W0y32YZhspBIQNjvjzeBrZFxiovHq0=
Date:   Thu, 28 Oct 2021 14:36:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        torvalds@linux-foundation.org, vvs@virtuozzo.com
Subject:  [patch 01/11] memcg: page_alloc: skip bulk allocator for
 __GFP_ACCOUNT
Message-ID: <20211028213604.wxCte4LAl%akpm@linux-foundation.org>
In-Reply-To: <20211028143506.5f5d5e2cd1f768a1da864844@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
