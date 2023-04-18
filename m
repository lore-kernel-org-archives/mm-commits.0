Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3916C77B7E
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbjDRXiw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjDRXgz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C2DAD32
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB345634A5
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C42EC433EF;
        Tue, 18 Apr 2023 23:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860944;
        bh=cgzeso/N6a7fPMDgN8CrauGvCX5xKvoXcUtTPYcIp74=;
        h=Date:To:From:Subject:From;
        b=r3zAVL7pbCQHBXjki4qXagueKSDSFd6IuBPGGBH4aPnDt6sg+fxAhA6S6naDJDtkX
         vYHzTN1QZQkEFAWjt0WAMoh5Tk0uym8eA/BY2eNPDMG6DJBQutbc/ICNDa7qA8HnEo
         sZVbTUVmA96Y5lDtDc0lbtA6U4TpDqPkTBNWDjx4=
Date:   Tue, 18 Apr 2023 16:35:43 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vdavydov.dev@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, naoya.horiguchi@nec.com,
        muchun.song@linux.dev, mhocko@kernel.org, linmiaohe@huawei.com,
        hughd@google.com, hannes@cmpxchg.org, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-page_cgroup_ino-get-memcg-from-the-pages-folio.patch removed from -mm tree
Message-Id: <20230418233544.3C42EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: page_cgroup_ino() get memcg from the page's folio
has been removed from the -mm tree.  Its filename was
     memcg-page_cgroup_ino-get-memcg-from-the-pages-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: memcg: page_cgroup_ino() get memcg from the page's folio
Date: Wed, 12 Apr 2023 00:34:51 +0000

In a kernel with added WARN_ON_ONCE(PageTail) in page_memcg_check(), we
observed a warning from page_cgroup_ino() when reading /proc/kpagecgroup. 
This warning was added to catch fragile reads of a page memcg.  Make
page_cgroup_ino() get memcg from the page's folio using
folio_memcg_check(): that gives it the correct memcg for each page of a
folio, so is the right fix.

Note that page_folio() is racy, the page's folio can change from under us,
but the entire function is racy and documented as such.

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

This is based on a patch originally written by Hugh Dickins and retains
most of the original commit log [1]

The patch was changed to use folio_memcg_check(page_folio(page)) instead
of page_memcg_check(compound_head(page)) based on discussions with Matthew
Wilcox; where he stated that callers of page_memcg_check() should stop
using it due to the ambiguity around tail pages -- instead they should use
folio_memcg_check() and handle tail pages themselves.

Link: https://lkml.kernel.org/r/20230412003451.4018887-1-yosryahmed@google.com
Link: https://lore.kernel.org/linux-mm/20230313083452.1319968-1-yosryahmed@google.com/ [1]
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-page_cgroup_ino-get-memcg-from-the-pages-folio
+++ a/mm/memcontrol.c
@@ -396,7 +396,8 @@ ino_t page_cgroup_ino(struct page *page)
 	unsigned long ino = 0;
 
 	rcu_read_lock();
-	memcg = page_memcg_check(page);
+	/* page_folio() is racy here, but the entire function is racy anyway */
+	memcg = folio_memcg_check(page_folio(page));
 
 	while (memcg && !(memcg->css.flags & CSS_ONLINE))
 		memcg = parent_mem_cgroup(memcg);
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-vmscan-ignore-non-lru-based-reclaim-in-memcg-reclaim.patch
mm-vmscan-move-set_task_reclaim_state-near-flush_reclaim_state.patch
mm-vmscan-refactor-updating-current-reclaim_state.patch

