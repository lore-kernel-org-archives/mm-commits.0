Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 023AEC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 21:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D128461246
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 21:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhETV6U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 17:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230382AbhETV6T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 17:58:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFDE66135B;
        Thu, 20 May 2021 21:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621547817;
        bh=HLIsgMs+4PiwBUEc66PLBPKt8oOssWZKBx6foCD2nAQ=;
        h=Date:From:To:Subject:From;
        b=PafBZKevDQQ2tBDdTFiDah57ViMdqsp4DSqOVVGG8Hnb2RsvsGqOOx62tIyDLuQ6h
         HGvVmvVqESn3pE1mP6ad1kbtSQ/HEQ1j0VshYmuWi1jo+pJl0rFC8I4Fl8RumBesqc
         81pBLIDrMMrnYF14QOUQIabUp1Mf0dPjl8WP9e+w=
Date:   Thu, 20 May 2021 14:56:57 -0700
From:   akpm@linux-foundation.org
To:     atomlin@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz, willy@infradead.org
Subject:  +
 =?US-ASCII?Q?mm-page=5Falloc-bail-out-on-fatal-signal-during-reclaim-co?=
 =?US-ASCII?Q?mpaction-retry-attempt.patch?= added to -mm tree
Message-ID: <20210520215657.Jrz4CgZ-l%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: bail out on fatal signal during reclaim/compaction retry attempt
has been added to the -mm tree.  Its filename is
     mm-page_alloc-bail-out-on-fatal-signal-during-reclaim-compaction-retry-attempt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-bail-out-on-fatal-signal-during-reclaim-compaction-retry-attempt.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-bail-out-on-fatal-signal-during-reclaim-compaction-retry-attempt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Vlastimil Babka <vbabka@suse.cz>
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

Patches currently in -mm which might be from atomlin@redhat.com are

mm-page_alloc-bail-out-on-fatal-signal-during-reclaim-compaction-retry-attempt.patch

