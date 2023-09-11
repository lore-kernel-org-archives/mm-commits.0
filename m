Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219CFCA0EC8
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 02:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbjILC2f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237612AbjILC2J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 22:28:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2F5138942
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 18:52:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733CDC433BC;
        Mon, 11 Sep 2023 21:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694468526;
        bh=SEaxrFBY5p9vqOhbayvK/rK6R+2hLcXYCFMm/3K8Yl4=;
        h=Date:To:From:Subject:From;
        b=bIsGrdlNo6ohcIGB/VSfrSRxUO/Xj3/fXxs7oxR1BJdtLXipV5UCZMsWMWPzn8Emw
         rwTY71Qhhkrw2VoNXpQOEqvfCtGWp4urEJ8mF4OKCk+w1zvNoUNhzTQze8W0DBAPj/
         BkLnDZWFDS4/iHwMZ5vSeJdaMlH9GAnIbwe+TQ+8=
Date:   Mon, 11 Sep 2023 14:42:05 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        wangkefeng.wang@huawei.com, vbabka@suse.cz,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-pcppage-migratetype-caching-fix.patch added to mm-unstable branch
Message-Id: <20230911214206.733CDC433BC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-remove-pcppage-migratetype-caching-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-pcppage-migratetype-caching-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-pcppage-migratetype-caching-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-remove-pcppage-migratetype-caching-fix
Date: Mon Sep 11 02:40:43 PM PDT 2023

fix free_unref_page()

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-pcppage-migratetype-caching-fix
+++ a/mm/page_alloc.c
@@ -2429,7 +2429,7 @@ void free_unref_page(struct page *page,
 		 * must be rechecked.
 		 */
 		free_one_page(zone, page, pfn, order,
-			      get_pcppage_migratetype(page), FPI_NONE);
+			      get_pfnblock_migratetype(page, pfn), FPI_NONE);
 	}
 	pcp_trylock_finish(UP_flags);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-page_alloc-remove-pcppage-migratetype-caching-fix.patch

