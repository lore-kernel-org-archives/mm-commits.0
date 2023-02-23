Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0136C61DA4
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 19:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjBWT6x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 14:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBWT6x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 14:58:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33D05BBA6
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 11:58:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B8EBB81AB4
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 19:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC4BC433EF;
        Thu, 23 Feb 2023 19:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677182329;
        bh=NRFg7pq4eSXQqU1qGAm44kKGq3/Aa96SifTvZS0vZQw=;
        h=Date:To:From:Subject:From;
        b=11gIGDDYsRPA6pnXGhWEZEQl04t0jcMCpbtKlZMI44cGNLCkQuLYOpVQNZtcx9q+t
         X7yQeeaWXZLFthB907vEMgQNjM6rv00cQMIhJPXBdGBVWScDjYdpJgqirY+Rfi+o0z
         xqqVgsX2OsylA/4ICb1rQAK+SzHRpixxuLRwZDwo=
Date:   Thu, 23 Feb 2023 11:58:48 -0800
To:     mm-commits@vger.kernel.org, stevensd@chromium.org,
        shy828301@gmail.com, hannes@cmpxchg.org, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch added to mm-unstable branch
Message-Id: <20230223195849.3FC4BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: alloc_charge_hpage() take care of mem charge errors
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/khugepaged: alloc_charge_hpage() take care of mem charge errors
Date: Wed, 22 Feb 2023 14:52:47 -0500

If memory charge failed, instead of returning the hpage but with an error,
allow the function to cleanup the folio properly, which is normally what a
function should do in this case - either return successfully, or return
with no side effect of partial runs with an indicated error.

This will also avoid the caller calling mem_cgroup_uncharge()
unnecessarily with either anon or shmem path (even if it's safe to do so).

Link: https://lkml.kernel.org/r/20230222195247.791227-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Stevens <stevensd@chromium.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors
+++ a/mm/khugepaged.c
@@ -1063,12 +1063,19 @@ static int alloc_charge_hpage(struct pag
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
 	int node = hpage_collapse_find_target_node(cc);
+	struct folio *folio;
 
 	if (!hpage_collapse_alloc_page(hpage, gfp, node, &cc->alloc_nmask))
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
-	if (unlikely(mem_cgroup_charge(page_folio(*hpage), mm, gfp)))
+
+	folio = page_folio(*hpage);
+	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
+		folio_put(folio);
+		*hpage = NULL;
 		return SCAN_CGROUP_CHARGE_FAIL;
+	}
 	count_memcg_page_event(*hpage, THP_COLLAPSE_ALLOC);
+
 	return SCAN_SUCCEED;
 }
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch

