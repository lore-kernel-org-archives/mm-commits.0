Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA96C433E2
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 00:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECDF621BE5
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 00:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600043933;
	bh=44TpdO0Lv/36dz5wFjU89mfsvkImLSUhsmHNBydQVf4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=piWaooQ6TuzNlRb1LWRPiJhkWHhZ2KUUbgI8M6IQ4/1Q0lyqwTZ2HKVzG3HjHFGRv
	 mwFAGysDA6FzTjjLFfRnbw1hthApWApFZpRjcdgmJDGJ6I7D6ilxGE8v/i5cQBpJGO
	 1C7mPkNCfsfBXF87bNITRYzuhSOsc+akVveJCzTE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgINAiw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Sep 2020 20:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgINAiv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Sep 2020 20:38:51 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7C9A21897;
        Mon, 14 Sep 2020 00:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600043931;
        bh=44TpdO0Lv/36dz5wFjU89mfsvkImLSUhsmHNBydQVf4=;
        h=Date:From:To:Subject:From;
        b=Au8NQ6OnUDVgufvNasf1my992yw3YvOP38cSzoBm2g+IFBZsqew0rY3k5PSCwiOQm
         I1p/2nxlBSRnYP28OYpUhd3gcWpzvteAcpm04fkbaYv8hZa6l6PNldP+oEmuMHEpFa
         3bTdWa9XaTWfD0tPFGXJrQ7CQtNnicXH3rjI/gkQ=
Date:   Sun, 13 Sep 2020 17:38:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rientjes@google.com,
        mgorman@suse.de, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org,
        mateusznosek0@gmail.com
Subject:  +
 mm-compactionc-micro-optimization-remove-unnecessary-branch.patch added to
 -mm tree
Message-ID: <20200914003850.wVRe7%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: micro-optimization remove unnecessary branch
has been added to the -mm tree.  Its filename is
     mm-compactionc-micro-optimization-remove-unnecessary-branch.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compactionc-micro-optimization-remove-unnecessary-branch.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compactionc-micro-optimization-remove-unnecessary-branch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/compaction.c: micro-optimization remove unnecessary branch

The same code can work both for 'zone->compact_considered > defer_limit'
and 'zone->compact_considered >= defer_limit'.  In the latter there is one
branch less which is more effective considering performance.

Link: https://lkml.kernel.org/r/20200913190448.28649-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compactionc-micro-optimization-remove-unnecessary-branch
+++ a/mm/compaction.c
@@ -180,11 +180,10 @@ bool compaction_deferred(struct zone *zo
 		return false;
 
 	/* Avoid possible overflow */
-	if (++zone->compact_considered > defer_limit)
+	if (++zone->compact_considered >= defer_limit) {
 		zone->compact_considered = defer_limit;
-
-	if (zone->compact_considered >= defer_limit)
 		return false;
+	}
 
 	trace_mm_compaction_deferred(zone, order);
 
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch
mm-page_allocc-micro-optimization-remove-unnecessary-branch.patch
mm-compactionc-micro-optimization-remove-unnecessary-branch.patch

