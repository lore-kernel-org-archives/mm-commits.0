Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 902E1CE7AA5
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 17:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjIYRBH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 13:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjIYRBG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 13:01:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C77910F
        for <mm-commits@vger.kernel.org>; Mon, 25 Sep 2023 10:01:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BC5C433C7;
        Mon, 25 Sep 2023 17:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695661259;
        bh=4FuiQafel0Oq2DF/3MLXmZOn5BZskG/qwUEaJyc+yA0=;
        h=Date:To:From:Subject:From;
        b=BEdxFQZgqkLXosybWch1WpJjL42Nq6xdwKCQj39AjTJNQScHd+TBRs3R+3ITSFgxI
         xQfPRX/ZIWN3o999MVYQI+zNfPfdU8U0Y/B9DTmqj1dzwV8iGbbfWZzHc7rhEFaqOC
         rR+MEmtMf8wBN+a25Z2lnZ5pVzTg1gwdaS6bFAx0=
Date:   Mon, 25 Sep 2023 10:00:59 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, vbabka@suse.cz,
        tjmercier@google.com, rostedt@goodmis.org, kaleshsingh@google.com,
        jaewon31.kim@samsung.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-add-trace-events-for-lru_gen-fix.patch added to mm-unstable branch
Message-Id: <20230925170059.B2BC5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan-add-trace-events-for-lru_gen-fix
has been added to the -mm mm-unstable branch.  Its filename is
     vmscan-add-trace-events-for-lru_gen-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmscan-add-trace-events-for-lru_gen-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmscan-add-trace-events-for-lru_gen-fix
Date: Mon Sep 25 10:00:20 AM PDT 2023

ISOLATE_UNMAPPED was removed

Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/vmscan.c~vmscan-add-trace-events-for-lru_gen-fix
+++ a/mm/vmscan.c
@@ -4390,9 +4390,6 @@ static int scan_folios(struct lruvec *lr
 	__count_memcg_events(memcg, PGREFILL, sorted);
 	__count_vm_events(PGSCAN_ANON + type, isolated);
 
-	trace_mm_vmscan_lru_gen_scan(sc->reclaim_idx, sc->order, MAX_LRU_BATCH,
-			scanned, skipped, isolated,
-			sc->may_unmap ? 0 : ISOLATE_UNMAPPED, type);
 	/*
 	 * There might not be eligible folios due to reclaim_idx. Check the
 	 * remaining to prevent livelock if it's not making progress.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch
vmscan-add-trace-events-for-lru_gen-fix.patch
kthread-add-kthread_stop_put-v2-fix.patch

