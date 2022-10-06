Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96361C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  6 Oct 2022 20:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiJFU2w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Oct 2022 16:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiJFU2v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2022 16:28:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F2ABEAFD
        for <mm-commits@vger.kernel.org>; Thu,  6 Oct 2022 13:28:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76061B82186
        for <mm-commits@vger.kernel.org>; Thu,  6 Oct 2022 20:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337EBC433C1;
        Thu,  6 Oct 2022 20:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665088124;
        bh=4GubiEUdPfWjEK0pMP0BJ0QK8GJEdfO4vn44LK0rpnA=;
        h=Date:To:From:Subject:From;
        b=chmcbGc4+sxB6Z3pOxSndQvLfoSLJvmSy932QAoz/ICFyLJKMww8oKzL7HmK2Tc2s
         fbxQfDtPSaWQqAbR3Ka2c+cl+oppMkA0aeTUXNK+4uxT/asPXOxvWE6BC1EAoZ51J7
         +MjGUiJYEryx+dlfuU0vrY+9YpxldpLZANJTDzyQ=
Date:   Thu, 06 Oct 2022 13:28:43 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        laoar.shao@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-incorrect-pgfree-and-pgalloc-for-high-order-page.patch added to mm-unstable branch
Message-Id: <20221006202844.337EBC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix incorrect PGFREE and PGALLOC for high-order page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-fix-incorrect-pgfree-and-pgalloc-for-high-order-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-incorrect-pgfree-and-pgalloc-for-high-order-page.patch

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
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm/page_alloc: fix incorrect PGFREE and PGALLOC for high-order page
Date: Thu, 6 Oct 2022 10:15:40 +0000

PGFREE and PGALLOC represent the number of freed and allocated pages.  So
the page order must be considered.

Link: https://lkml.kernel.org/r/20221006101540.40686-1-laoar.shao@gmail.com
Fixes: 44042b449872 ("mm/page_alloc: allow high-order pages to be stored on the per-cpu lists")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-incorrect-pgfree-and-pgalloc-for-high-order-page
+++ a/mm/page_alloc.c
@@ -3446,7 +3446,7 @@ static void free_unref_page_commit(struc
 	int pindex;
 	bool free_high;
 
-	__count_vm_event(PGFREE);
+	__count_vm_events(PGFREE, 1 << order);
 	pindex = order_to_pindex(migratetype, order);
 	list_add(&page->pcp_list, &pcp->lists[pindex]);
 	pcp->count += 1 << order;
@@ -3803,7 +3803,7 @@ static struct page *rmqueue_pcplist(stru
 	pcp_spin_unlock_irqrestore(pcp, flags);
 	pcp_trylock_finish(UP_flags);
 	if (page) {
-		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1);
+		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 		zone_statistics(preferred_zone, zone, 1);
 	}
 	return page;
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-page_alloc-fix-incorrect-pgfree-and-pgalloc-for-high-order-page.patch

