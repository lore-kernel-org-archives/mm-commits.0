Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D925AC61DA4
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 19:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjCMTp0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Mar 2023 15:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjCMTpX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2023 15:45:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D536C84F66
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 12:45:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 525A561485
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 19:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A747CC433EF;
        Mon, 13 Mar 2023 19:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678736720;
        bh=ntr57BlTfvefItYOk1Rz+/buTxYct+KlnuYv56mUIII=;
        h=Date:To:From:Subject:From;
        b=HBqzcZ3MQis/g1SrZXDwJV65OattZMYMIZ7nhEx8k+mIqybd/SEH+Fp5CitZdydky
         VsZOTVIoNgYe8uXWH6iZ44WhVsXud7xGOh81KEiz/am0ToRhY3Pxu9ixS/mS93gBHn
         xGn+kvqNk9XskLoM7yKJAJBGVmBYaeWYmWYbx0xc=
Date:   Mon, 13 Mar 2023 12:45:20 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vdavydov.dev@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, naoya.horiguchi@nec.com,
        muchun.song@linux.dev, mhocko@kernel.org, linmiaohe@huawei.com,
        hannes@cmpxchg.org, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-page_cgroup_ino-get-memcg-from-compound_headpage.patch added to mm-unstable branch
Message-Id: <20230313194520.A747CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: page_cgroup_ino() get memcg from compound_head(page)
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-page_cgroup_ino-get-memcg-from-compound_headpage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-page_cgroup_ino-get-memcg-from-compound_headpage.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
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

memcg-page_cgroup_ino-get-memcg-from-compound_headpage.patch

