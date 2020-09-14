Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BECC2D0F6
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 03:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C272321D1B
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 03:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600053397;
	bh=Fn4DIPD3URiH9zicPU0v+C8loLVH5cOP8PHDD0/FMtI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SNxXm5zaXthlYjPyBH0GWUlIe5HInx468PskK3lBCLnfLPz8cwnIgrUh/R4C9cGlV
	 5rzyJaSwv0TvfzTh16WbPtRVX8+S7HJybWeUfY5D/KwtLbsXbmff+4mXz+T3J0WsnS
	 WmweZnv+uBOmupTo8LffBAYSOk3poGFZp64ATkdk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgINDQh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Sep 2020 23:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:32868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbgINDQg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Sep 2020 23:16:36 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB586208C7;
        Mon, 14 Sep 2020 03:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600053395;
        bh=Fn4DIPD3URiH9zicPU0v+C8loLVH5cOP8PHDD0/FMtI=;
        h=Date:From:To:Subject:From;
        b=S6ItMeE/nUvCuRCRaqxYnnz7k2qZMUw5YVqTAHs4Y2m3sVmmjKchcK9mja/D0kuMQ
         8zDCixCm+o78gdF23i3hXlweM/lSGwxjwuJtdwLoqabiJNepPMBQhT3DF3cTFVTIcU
         8rKlCWdeaVFf9PejjjyBPe6NVyd+7PYEUpDWnjco=
Date:   Sun, 13 Sep 2020 20:16:35 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        osalvador@suse.com, naoya.horiguchi@nec.com, mhocko@kernel.org,
        cai@lca.pw, osalvador@suse.de
Subject:  + mmhwpoison-remove-stale-code.patch added to -mm tree
Message-ID: <20200914031635.pH1LK%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: remove stale code
has been added to the -mm tree.  Its filename is
     mmhwpoison-remove-stale-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-remove-stale-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-remove-stale-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: remove stale code

Currently we call shake_page and then check whether the page is Buddy
because shake_page calls drain_all_pages, which sends pcp-pages back to
the buddy freelists, so we could have a chance to handle free pages.

get_hwpoison_page already calls drain_all_pages, and we do call
get_hwpoison_page right before coming here, so we should be on the safe
side.

Link: https://lkml.kernel.org/r/20200908075626.11976-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-remove-stale-code
+++ a/mm/memory-failure.c
@@ -1421,18 +1421,6 @@ try_again:
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
 	shake_page(p, 0);
-	/* shake_page could have turned it free. */
-	if (!PageLRU(p) && is_free_buddy_page(p)) {
-		if (!take_page_off_buddy(p))
-			res = -EBUSY;
-
-		if (flags & MF_COUNT_INCREASED)
-			action_result(pfn, MF_MSG_BUDDY, res ? MF_IGNORED : MF_RECOVERED);
-		else
-			action_result(pfn, MF_MSG_BUDDY_2ND, res ? MF_IGNORED : MF_RECOVERED);
-
-		return res;
-	}
 
 	lock_page(p);
 
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-remove-stale-code.patch

