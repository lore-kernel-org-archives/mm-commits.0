Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF5FC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EC62206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027219;
	bh=xhBj2LYa2W3/xFtMJy0PLOmiAPFrzmdGWUVcujcZlH0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Pg66l6fa1+GT1+bZskd3qymf06z+3Xlkd+lgNDyXd4MIAw8lRHjNngIi8Itmq8A5O
	 ezdQvQCU5CHUh01fgz+4L9sUGWzKoebxnNUnf9LlTFc8LrkepBhI/KuUjfqeNj2g51
	 dsOUs6FEAnk+cbnojmISGzulYuEURGIKHQg860V0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgHJCkS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCkS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:40:18 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DD1B2065D;
        Mon, 10 Aug 2020 02:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027217;
        bh=xhBj2LYa2W3/xFtMJy0PLOmiAPFrzmdGWUVcujcZlH0=;
        h=Date:From:To:Subject:From;
        b=wEY1dBaA2AQDo7TBBtWzT+GW0BAKdvPKuK4jJTvulcnR0impEHdZ/owsyc4njCy9G
         BLxWyw9uDdkf7vI1I1RQgzNGYO9FQi6Kaz8/09KZCswIp6hCPYtHJN3SxoJvYFMNPJ
         n4DQ8McskNuFYKBhbInqptntq/42to+f5iCBIxT0=
Date:   Sun, 09 Aug 2020 19:40:17 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, penberg@kernel.org,
        songmuchun@bytedance.com
Subject:  [merged]
 mm-page_alloc-skip-setting-nodemask-when-we-are-in-interrupt.patch removed
 from -mm tree
Message-ID: <20200810024017.xy6ZXDmyD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: skip setting nodemask when we are in interrupt
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-skip-setting-nodemask-when-we-are-in-interrupt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/page_alloc.c: skip setting nodemask when we are in interrupt

When we are in the interrupt context, it is irrelevant to the current task
context.  If we use current task's mems_allowed, we can be fair to alloc
pages in the fast path and fall back to slow path memory allocation when
the current node(which is the current task mems_allowed) does not have
enough memory to allocate.  In this case, it slows down the memory
allocation speed of interrupt context.  So we can skip setting the
nodemask to allow any node to allocate memory, so that fast path
allocation can success.

Link: http://lkml.kernel.org/r/20200706025921.53683-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-skip-setting-nodemask-when-we-are-in-interrupt
+++ a/mm/page_alloc.c
@@ -4788,7 +4788,11 @@ static inline bool prepare_alloc_pages(g
 
 	if (cpusets_enabled()) {
 		*alloc_mask |= __GFP_HARDWALL;
-		if (!ac->nodemask)
+		/*
+		 * When we are in the interrupt context, it is irrelevant
+		 * to the current task context. It means that any node ok.
+		 */
+		if (!in_interrupt() && !ac->nodemask)
 			ac->nodemask = &cpuset_current_mems_allowed;
 		else
 			*alloc_flags |= ALLOC_CPUSET;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-add-mempolicy-check-in-the-reservation-routine.patch

