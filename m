Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B98C47089
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiLAAIj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiLAAGi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB15010B8
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 851C0B81D69
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4386BC433D6;
        Thu,  1 Dec 2022 00:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852955;
        bh=z+i3p23UObSq/S2tzMTAuCkChnU8wkj75qO3YG73Kcc=;
        h=Date:To:From:Subject:From;
        b=Z/VOjls6MjI+p4x+8dB8SmU7xiRti7BFsHrieVsoQNX3cQki74HCEMXMmjgGMQLaR
         d1gelanqwWFxUwRhVpJEaRJAWpomU+0mszXOzWCmekq/ne8k2AZjWotZ1vHekKPe9I
         a76yDjbIbb7PTvp5HjYiAluV4H9V0nClp7HoB9ng=
Date:   Wed, 30 Nov 2022 16:02:34 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-simplify-locking-during-free_unref_page_list.patch removed from -mm tree
Message-Id: <20221201000235.4386BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: simplify locking during free_unref_page_list
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-simplify-locking-during-free_unref_page_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3525,13 +3525,19 @@ void free_unref_page_list(struct list_he
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
@@ -3546,7 +3552,6 @@ void free_unref_page_list(struct list_he
 				continue;
 			}
 			locked_zone = zone;
-			batch_count = 0;
 		}
 
 		/*
@@ -3558,19 +3563,7 @@ void free_unref_page_list(struct list_he
 
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


