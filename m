Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9034AC6FD1D
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 22:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjCOWHt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 18:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCOWHs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 18:07:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6195FA42E1
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 15:07:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14AACB81A99
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 22:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED58C433EF;
        Wed, 15 Mar 2023 22:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678918060;
        bh=Ii3X5X2RlxNoYuWu2uPblw6MXMBT5cWyd3St/Y9/0RM=;
        h=Date:To:From:Subject:From;
        b=qkta9mJmgKU67epmJUGbmy/9BfR5WfqGMOj8u/5wAW13MyAMoCJziFXsZ59s7wtt9
         uJgRlc196ubr4eF7cBCCVUcXNu0aj78eeBKj9PnE0WJly/qogoZOV/+2ux1VO0c7Zm
         4UoiRoV3QM3dpsHNcEfFQQQR525Y+7vdYTjjSKew=
Date:   Wed, 15 Mar 2023 15:07:40 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vdavydov.dev@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, naoya.horiguchi@nec.com,
        muchun.song@linux.dev, mhocko@suse.com, linmiaohe@huawei.com,
        hannes@cmpxchg.org, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] memcg-page_cgroup_ino-get-memcg-from-compound_headpage.patch removed from -mm tree
Message-Id: <20230315220740.AED58C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: page_cgroup_ino() get memcg from compound_head(page)
has been removed from the -mm tree.  Its filename was
     memcg-page_cgroup_ino-get-memcg-from-compound_headpage.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: page_cgroup_ino() get memcg from compound_head(page)
Date: Mon, 13 Mar 2023 08:34:52 +0000

In a kernel with added WARN_ON_ONCE(PageTail) in page_memcg_check(), we
observed a warning from page_cgroup_ino() when reading /proc/kpagecgroup. 
This warning was added to catch fragile reads of a page memcg.  Make
page_cgroup_ino() get memcg from compound_head(page): that gives it the
correct memcg for each subpage of a compound page, so is the right fix.

I dithered between the right fix and the safer "fix": it's unlikely but
conceivable that some userspace has learnt that /proc/kpagecgroup gives no
memcg on tail pages, and compensates for that in some (racy) way: so
continuing to give no memcg on tails, without warning, might be safer.

But hwpoison_filter_task(), the only other user of page_cgroup_ino(),
persuaded me.  It looks as if it currently leaves out tail pages of the
selected memcg, by mistake: whereas hwpoison_inject() uses compound_head()
and expects the tails to be included.  So hwpoison testing coverage has
probably been restricted by the wrong output from page_cgroup_ino() (if
that memcg filter is used at all): in the short term, it might be safer
not to enable wider coverage there, but long term we would regret that.

Link: https://lkml.kernel.org/r/20230313083452.1319968-1-yosryahmed@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memcontrol.c~memcg-page_cgroup_ino-get-memcg-from-compound_headpage
+++ a/mm/memcontrol.c
@@ -395,7 +395,7 @@ ino_t page_cgroup_ino(struct page *page)
 	unsigned long ino = 0;
 
 	rcu_read_lock();
-	memcg = page_memcg_check(page);
+	memcg = page_memcg_check(compound_head(page));
 
 	while (memcg && !(memcg->css.flags & CSS_ONLINE))
 		memcg = parent_mem_cgroup(memcg);
_

Patches currently in -mm which might be from hughd@google.com are


