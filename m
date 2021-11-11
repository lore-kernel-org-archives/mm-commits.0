Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3142FC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FD536113B
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhKKCsr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhKKCsr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82E0761108;
        Thu, 11 Nov 2021 02:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598758;
        bh=W6+B5DVwDwJhF/1n3kYOJ17xAyiiSnWRBVZZSkFdd6c=;
        h=Date:From:To:Subject:From;
        b=LZdQBHcgZM6TajCXfzubzzOI6Y8u+prl9jAMjOpRnuuiGR9c4ydYftFlO/xXw4aeL
         2D8J3ROckmTS40kWlxyfjYcUQxB+RwzWvLGSXAxLIXJy9ZO956XK/AqZkwd0akgDqJ
         eGxlrgSETvWX+RrVeBiZnF84FbE32BchpevP/W8Y=
Date:   Wed, 10 Nov 2021 18:45:58 -0800
From:   akpm@linux-foundation.org
To:     adilger.kernel@dilger.ca, corbet@lwn.net, david@fromorbit.com,
        djwong@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de,
        riel@surriel.com, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  [merged]
 mm-vmscan-delay-waking-of-tasks-throttled-on-noprogress.patch removed from
 -mm tree
Message-ID: <20211111024558.qu-e-GpuU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: delay waking of tasks throttled on NOPROGRESS
has been removed from the -mm tree.  Its filename was
     mm-vmscan-delay-waking-of-tasks-throttled-on-noprogress.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/vmscan: delay waking of tasks throttled on NOPROGRESS

Tracing indicates that tasks throttled on NOPROGRESS are woken prematurely
resulting in occasional massive spikes in direct reclaim activity.  This
patch wakes tasks throttled on NOPROGRESS if reclaim efficiency is at
least 12%.

Link: https://lkml.kernel.org/r/20211022144651.19914-9-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: "Darrick J . Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-delay-waking-of-tasks-throttled-on-noprogress
+++ a/mm/vmscan.c
@@ -3348,8 +3348,11 @@ static inline bool compaction_ready(stru
 
 static void consider_reclaim_throttle(pg_data_t *pgdat, struct scan_control *sc)
 {
-	/* If reclaim is making progress, wake any throttled tasks. */
-	if (sc->nr_reclaimed) {
+	/*
+	 * If reclaim is making progress greater than 12% efficiency then
+	 * wake all the NOPROGRESS throttled tasks.
+	 */
+	if (sc->nr_reclaimed > (sc->nr_scanned >> 3)) {
 		wait_queue_head_t *wqh;
 
 		wqh = &pgdat->reclaim_wait[VMSCAN_THROTTLE_NOPROGRESS];
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


