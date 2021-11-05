Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F872C43219
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FDB361288
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhKEUpa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233705AbhKEUp3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:45:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71D406127C;
        Fri,  5 Nov 2021 20:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144969;
        bh=pAeVSQE+ghUrkBGpE6kpmbVNqnlEmUQ8UwhxuJRCBAE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=i9NTeDdeUyWHI15/x7jR2PdVd/DaDPNCfT299892+cNmcK1wni0yivTOXd+IGZKrz
         8FZpImO6jbH6r2jgA9ZR7C0bHixmhFhB+r/2jMuedC6fkwnHKYf+gjStkV8WR6dU8w
         Dllv8zIgabzrKb2Xwo+5AFg9Pne8jLbAoUDvBBxo=
Date:   Fri, 05 Nov 2021 13:42:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        corbet@lwn.net, david@fromorbit.com, djwong@kernel.org,
        hannes@cmpxchg.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de, riel@surriel.com,
        torvalds@linux-foundation.org, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  [patch 156/262] mm/vmscan: delay waking of tasks
 throttled on NOPROGRESS
Message-ID: <20211105204249.YEXCXrK3w%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
