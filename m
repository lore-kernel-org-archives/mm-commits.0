Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838ADC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E8BF61474
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238523AbhGAB4Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB4Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:56:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCC0261241;
        Thu,  1 Jul 2021 01:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104434;
        bh=yr/BES2r1OLP3gTpr5e8JAFHenZo65BslROVqtKgAIo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MqrjW8MocjoeMMezmi1b08j7SUYL0QICceE5ifjlTitE6h+wY1eCTTayCo324WfZi
         j9I5LNx8eRfXw1Z7+qhap03gx9ehYJXeqjjO/Ww719e3WHSz+4NPgdxhwWXfvdUCnK
         +KW0jjc8hMbaonW3wu5AiyLHqXtn2bQ+mjQdHptM=
Date:   Wed, 30 Jun 2021 18:53:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, ddstreet@ieee.org,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 126/192] mm/page_alloc: move prototype for
 find_suitable_fallback
Message-ID: <20210701015353.P4XRjHhzz%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
