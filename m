Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5591CC11F67
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3918E61D0D
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhF2Cni (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhF2Cnh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:43:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43A25611AE;
        Tue, 29 Jun 2021 02:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934471;
        bh=qxUSIKFqxFA0UeD8NL5XjNfNuRTUNkEADefjr07GDIA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=r9koi1QweSFwrlYFrd1scM64VXrH/LzUeIgd/lTdsz/p22zRxl7iciyuFxCAG7H4d
         A1+45ipOOERL+5Jdny3spuHK1arE2U4i/lO294jeBObCmWSkxgyjEQu9bIk70ohMmo
         rtBI1lyjMIhJrjz1xK8ZaUJFUN1T5syN4rbQX7MU=
Date:   Mon, 28 Jun 2021 19:41:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, atomlin@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 151/192] mm/page_alloc: bail out on fatal signal
 during reclaim/compaction retry attempt
Message-ID: <20210629024110.9HbnhEkvF%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>
Subject: mm/page_alloc: bail out on fatal signal during reclaim/compaction retry attempt

A customer experienced a low-memory situation and decided to issue a
SIGKILL (i.e.  a fatal signal).  Instead of promptly terminating as one
would expect, the aforementioned task remained unresponsive.

Further investigation indicated that the task was "stuck" in the
reclaim/compaction retry loop.  Now, it does not make sense to retry
compaction when a fatal signal is pending.

In the context of try_to_compact_pages(), indeed COMPACT_SKIPPED can be
returned; albeit, not every zone, on the zone list, would be considered in
the case a fatal signal is found to be pending.  Yet, in
should_compact_retry(), given the last known compaction result, each zone,
on the zone list, can be considered/or checked (see
compaction_zonelist_suitable()).  For example, if a zone was found to
succeed, then reclaim/compaction would be tried again (notwithstanding the
above).

This patch ensures that compaction is not needlessly retried irrespective
of the last known compaction result e.g.  if it was skipped, in the
unlikely case a fatal signal is found pending.  So, OOM is at least
attempted.

Link: https://lkml.kernel.org/r/20210520142901.3371299-1-atomlin@redhat.com
Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-bail-out-on-fatal-signal-during-reclaim-compaction-retry-attempt
+++ a/mm/page_alloc.c
@@ -4251,6 +4251,9 @@ should_compact_retry(struct alloc_contex
 	if (!order)
 		return false;
 
+	if (fatal_signal_pending(current))
+		return false;
+
 	if (compaction_made_progress(compact_result))
 		(*compaction_retries)++;
 
_
