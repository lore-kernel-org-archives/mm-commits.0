Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE310C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Nov 2022 22:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiKVWk2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 17:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbiKVWk0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 17:40:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F94C78C5
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 14:40:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 603C8B81DEC
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 22:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCE6C433D6;
        Tue, 22 Nov 2022 22:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669156823;
        bh=D12225qDBaGNNZ3gC0JwBIPyCKem+YlMkKRiMYyJ9Pg=;
        h=Date:To:From:Subject:From;
        b=EYA05cK0h9wK9jB7S9pMbK+LI9n3IKXZsLnXs7Nq9QZyvirELavgffKZE0saBOG2b
         H32SsPBaM6Fed9Dhhg24FgUk0gvuuYzwET6F36qsBsIO0mYU90e35CShdo/JCdgjx1
         QjAY6XBedWFyRvqln+Ia9cRFtNBAPwTnf0WLpxCs=
Date:   Tue, 22 Nov 2022 14:40:22 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-simplify-locking-during-free_unref_page_list.patch added to mm-unstable branch
Message-Id: <20221122224022.DDCE6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: simplify locking during free_unref_page_list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-simplify-locking-during-free_unref_page_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-simplify-locking-during-free_unref_page_list.patch

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
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: simplify locking during free_unref_page_list
Date: Tue, 22 Nov 2022 13:12:29 +0000

While freeing a large list, the zone lock will be released and reacquired
to avoid long hold times since commit c24ad77d962c ("mm/page_alloc.c:
avoid excessive IRQ disabled times in free_unref_page_list()").  As
suggested by Vlastimil Babka, the lockrelease/reacquire logic can be
simplified by reusing the logic that acquires a different lock when
changing zones.

Link: https://lkml.kernel.org/r/20221122131229.5263-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simplify-locking-during-free_unref_page_list
+++ a/mm/page_alloc.c
@@ -3540,13 +3540,19 @@ void free_unref_page_list(struct list_he
 		list_del(&page->lru);
 		migratetype = get_pcppage_migratetype(page);
 
-		/* Different zone, different pcp lock. */
-		if (zone != locked_zone) {
+		/*
+		 * Either different zone requiring a different pcp lock or
+		 * excessive lock hold times when freeing a large list of
+		 * pages.
+		 */
+		if (zone != locked_zone || batch_count == SWAP_CLUSTER_MAX) {
 			if (pcp) {
 				pcp_spin_unlock(pcp);
 				pcp_trylock_finish(UP_flags);
 			}
 
+			batch_count = 0;
+
 			/*
 			 * trylock is necessary as pages may be getting freed
 			 * from IRQ or SoftIRQ context after an IO completion.
@@ -3561,7 +3567,6 @@ void free_unref_page_list(struct list_he
 				continue;
 			}
 			locked_zone = zone;
-			batch_count = 0;
 		}
 
 		/*
@@ -3573,19 +3578,7 @@ void free_unref_page_list(struct list_he
 
 		trace_mm_page_free_batched(page);
 		free_unref_page_commit(zone, pcp, page, migratetype, 0);
-
-		/*
-		 * Guard against excessive lock hold times when freeing
-		 * a large list of pages. Lock will be reacquired if
-		 * necessary on the next iteration.
-		 */
-		if (++batch_count == SWAP_CLUSTER_MAX) {
-			pcp_spin_unlock(pcp);
-			pcp_trylock_finish(UP_flags);
-			batch_count = 0;
-			pcp = NULL;
-			locked_zone = NULL;
-		}
+		batch_count++;
 	}
 
 	if (pcp) {
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-always-remove-pages-from-temporary-list.patch
mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations.patch
mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations-fix.patch
mm-page_alloc-simplify-locking-during-free_unref_page_list.patch

