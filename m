Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D28C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  5 Jan 2022 23:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245348AbiAEXX2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Jan 2022 18:23:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52570 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245364AbiAEXX1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2022 18:23:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81E8561909
        for <mm-commits@vger.kernel.org>; Wed,  5 Jan 2022 23:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBF5C36AE9;
        Wed,  5 Jan 2022 23:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641425006;
        bh=L4k8vsbO4D4v7nVdqOSg1DSjsmSq6kgDNi2pgIOToRg=;
        h=Date:From:To:Subject:From;
        b=m/6YwwbLakaKurx5lm+G12rV5KhT7NjVz0Toq4rYjpmocbI8Eoqzk8BssE932Z77c
         TpHXvxSH9BdBOLVVxLpWeUbCiD7MajpnWA9Bmi6dsLIJB2iv/uwhbPYS0ltNvve8/z
         qiNDQS34Br3eHjx4fQM5HmyGX7ourYaC0X0VI8vI=
Date:   Wed, 05 Jan 2022 15:23:26 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com
Subject:  + memcg-add-per-memcg-vmalloc-stat-v4.patch added to -mm
 tree
Message-ID: <20220105232326.8Z_vB7bEu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-add-per-memcg-vmalloc-stat-v4
has been added to the -mm tree.  Its filename is
     memcg-add-per-memcg-vmalloc-stat-v4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-add-per-memcg-vmalloc-stat-v4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-add-per-memcg-vmalloc-stat-v4.patch

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
Subject: memcg-add-per-memcg-vmalloc-stat-v4

Remove area->page[0] checks and moved to page by page accounting as
suggested by Michal.

Link: https://lkml.kernel.org/r/20220104222341.3972772-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/mm/vmalloc.c~memcg-add-per-memcg-vmalloc-stat-v4
+++ a/mm/vmalloc.c
@@ -2624,15 +2624,13 @@ static void __vunmap(const void *addr, i
 
 	if (deallocate_pages) {
 		unsigned int page_order = vm_area_page_order(area);
-		int i;
+		int i, step = 1U << page_order;
 
-		mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
-				     -area->nr_pages);
-
-		for (i = 0; i < area->nr_pages; i += 1U << page_order) {
+		for (i = 0; i < area->nr_pages; i += step) {
 			struct page *page = area->pages[i];
 
 			BUG_ON(!page);
+			mod_memcg_page_state(page, MEMCG_VMALLOC, -step);
 			__free_pages(page, page_order);
 			cond_resched();
 		}
@@ -2959,7 +2957,13 @@ static void *__vmalloc_area_node(struct
 		page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
-	mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC, area->nr_pages);
+	if (gfp_mask & __GFP_ACCOUNT) {
+		int i, step = 1U << page_order;
+
+		for (i = 0; i < area->nr_pages; i += step)
+			mod_memcg_page_state(area->pages[i], MEMCG_VMALLOC,
+					     step);
+	}
 
 	/*
 	 * If not enough pages were obtained to accomplish an
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-better-bounds-on-the-memcg-stats-updates.patch
memcg-add-per-memcg-vmalloc-stat.patch
memcg-add-per-memcg-vmalloc-stat-v2.patch
memcg-add-per-memcg-vmalloc-stat-v4.patch

