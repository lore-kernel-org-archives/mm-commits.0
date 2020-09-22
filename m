Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4903AC2D0E2
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 19:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CA6D238A1
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 19:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600803808;
	bh=vkYALQBz9PphL4bgScYtyBhM+igIA+7/SIK+9IcyUAY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=NYK4GHB34r188IHfKjncWbkeJF31V4zqhlWbZcpZ03gkKIanqJx4Asu4AvplaPzsA
	 vmdobI/s1rTSJT+v2Xi5PVpaxSm/cfQWS3USL24UkytF4imvIl+db2HMqDUxHockfG
	 3pkJIKVCXuhpK9vf94PFZbF+3KjvLZ+hPeuuMSGg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgIVTn1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 15:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgIVTn1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 15:43:27 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03D74221E8;
        Tue, 22 Sep 2020 19:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600803807;
        bh=vkYALQBz9PphL4bgScYtyBhM+igIA+7/SIK+9IcyUAY=;
        h=Date:From:To:Subject:From;
        b=CuMuTsobSthR/8/IgvzY/gUMNIhkUpW+XBFVWLrsJzwGbh+Bpt4py6P2kgxIH6997
         j6OeL8xp0j8464UsUoINaTZ3iBhfEjKOWD2L4LrRTk0ktuuJDqoCvP8jn6DzTy5j4x
         4wiOXOWrrIQEoHiNWVBzZdB9RZKZmUsVhf93m/+A=
Date:   Tue, 22 Sep 2020 12:43:26 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        osalvador@suse.com, naoya.horiguchi@nec.com, mhocko@kernel.org,
        cai@lca.pw, osalvador@suse.de
Subject:  [to-be-updated] mmhwpoison-remove-stale-code.patch removed
 from -mm tree
Message-ID: <20200922194326._QdQT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: remove stale code
has been removed from the -mm tree.  Its filename was
     mmhwpoison-remove-stale-code.patch

This patch was dropped because an updated version will be merged

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

mmhwpoison-unexport-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-try-to-narrow-window-race-for-free-pages.patch

