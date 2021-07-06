Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB63C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65E0761CA2
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhGFTXx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230408AbhGFTXx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F1EF61C9C;
        Tue,  6 Jul 2021 19:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599274;
        bh=9S9Wyx62ZflfrP33jpE9CqpKm9/emIYrXqvhVIXf/V8=;
        h=Date:From:To:Subject:From;
        b=xka+U6iYagZHGWiH53yU9HxGePlMYix6HCacSlabvnjnuiK2xYtZxwbF8ZC30uY8R
         zB0ERJqgzH4fvL8fGrBBktlreS33iuENdeXgfGgcM2XQneLafo/M7ew8zpsPw2KNXH
         VA4RjAlkcpP9EBCFfTxRFGMNovMn0OUdfixsY38o=
Date:   Tue, 06 Jul 2021 12:21:14 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, ddstreet@ieee.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shy828301@gmail.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-move-prototype-for-find_suitable_fallback.patch removed from
 -mm tree
Message-ID: <20210706192114.ncBwx1Oil%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: move prototype for find_suitable_fallback
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-prototype-for-find_suitable_fallback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: move prototype for find_suitable_fallback

make W=1 generates the following warning in mmap_lock.c for allnoconfig

  mm/page_alloc.c:2670:5: warning: no previous prototype for `find_suitable_fallback' [-Wmissing-prototypes]
   int find_suitable_fallback(struct free_area *area, unsigned int order,
       ^~~~~~~~~~~~~~~~~~~~~~

find_suitable_fallback is only shared outside of page_alloc.c for
CONFIG_COMPACTION but to suppress the warning, move the protype outside of
CONFIG_COMPACTION.  It is not worth the effort at this time to find a
clever way of allowing compaction.c to share the code or avoid the use
entirely as the function is called on relatively slow paths.

Link: https://lkml.kernel.org/r/20210520084809.8576-14-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/internal.h~mm-page_alloc-move-prototype-for-find_suitable_fallback
+++ a/mm/internal.h
@@ -274,11 +274,10 @@ isolate_freepages_range(struct compact_c
 int
 isolate_migratepages_range(struct compact_control *cc,
 			   unsigned long low_pfn, unsigned long end_pfn);
+#endif
 int find_suitable_fallback(struct free_area *area, unsigned int order,
 			int migratetype, bool only_stealable, bool *can_steal);
 
-#endif
-
 /*
  * This function returns the order of a free page in the buddy system. In
  * general, page_zone(page)->lock must be held by the caller to prevent the
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


