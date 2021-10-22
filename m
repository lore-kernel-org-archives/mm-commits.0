Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8938FC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73428610EA
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbhJVT2T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Oct 2021 15:28:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233564AbhJVT2S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 Oct 2021 15:28:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECE926109D;
        Fri, 22 Oct 2021 19:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634930760;
        bh=B02oi7m3r34ud8/nPex1eD/kIjQEC6tMf8atPxjjHsg=;
        h=Date:From:To:Subject:From;
        b=bGHsV4xQ3h9V29HAKYjsbIrlgCEjZAhkt+/wPHBmKYyxTGUxtIfK9f2I84LowY4zX
         NYbPACD1W3ECXVV2tqO2tpNZvz8QFLtWUFkNfwDvnLJ4JLPbAOD97a9Wp1woCVgUqS
         4AWW+16TxYBP6a0SizsXDCUkmqBigwcQyWao7DMs=
Date:   Fri, 22 Oct 2021 12:25:59 -0700
From:   akpm@linux-foundation.org
To:     adilger.kernel@dilger.ca, corbet@lwn.net, david@fromorbit.com,
        djwong@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de,
        riel@surriel.com, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  +
 mm-vmscan-delay-waking-of-tasks-throttled-on-noprogress.patch added to -mm
 tree
Message-ID: <20211022192559.sbrTKmd5a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: delay waking of tasks throttled on NOPROGRESS
has been added to the -mm tree.  Its filename is
     mm-vmscan-delay-waking-of-tasks-throttled-on-noprogress.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-delay-waking-of-tasks-throttled-on-noprogress.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-delay-waking-of-tasks-throttled-on-noprogress.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3355,8 +3355,11 @@ static inline bool compaction_ready(stru
 
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

mm-vmscan-throttle-reclaim-until-some-writeback-completes-if-congested.patch
mm-vmscan-throttle-reclaim-and-compaction-when-too-may-pages-are-isolated.patch
mm-vmscan-throttle-reclaim-when-no-progress-is-being-made.patch
mm-writeback-throttle-based-on-page-writeback-instead-of-congestion.patch
mm-page_alloc-remove-the-throttling-logic-from-the-page-allocator.patch
mm-vmscan-centralise-timeout-values-for-reclaim_throttle.patch
mm-vmscan-increase-the-timeout-if-page-reclaim-is-not-making-progress.patch
mm-vmscan-delay-waking-of-tasks-throttled-on-noprogress.patch

