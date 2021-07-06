Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0FAC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8AE860FEE
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhGFTQp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:16:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231819AbhGFTQp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:16:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75AFF60C3D;
        Tue,  6 Jul 2021 19:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598846;
        bh=kanr9EFMmf3ylP29F4upi1rngnY4EcqYbiu1QvCRlWs=;
        h=Date:From:To:Subject:From;
        b=kPD48AVKOq/o8D9z0NKgGeP6FicQaIeQFx+/m1dzVFRvm8wrjNjzNvRYqXsathUwE
         w0UjXN8LUCMKsyXKGpltptsE4O5TBA8ZNs2AeikMhzr9ZT9QespqATnm2Oj2JLh8SD
         q5U1c1yvblEODTs25Rt0PIIRaPAecOgGGI7nIiRE=
Date:   Tue, 06 Jul 2021 12:14:06 -0700
From:   akpm@linux-foundation.org
To:     atomlin@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz, willy@infradead.org
Subject:  [merged]
 =?US-ASCII?Q?mm-page=5Falloc-bail-out-on-fatal-signal-during-reclaim-co?=
 =?US-ASCII?Q?mpaction-retry-attempt.patch?= removed from -mm tree
Message-ID: <20210706191406.caxr300U7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: bail out on fatal signal during reclaim/compaction retry attempt
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-bail-out-on-fatal-signal-during-reclaim-compaction-retry-attempt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from atomlin@redhat.com are


