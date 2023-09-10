Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B41EEB580
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 20:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjIJUsT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 16:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjIJUsT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 16:48:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE5118B
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 13:48:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29603C433C8;
        Sun, 10 Sep 2023 20:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694378893;
        bh=1VhXSaAGuqwomzh0C6RcIMsE7BRW+1kvdP9NENQ11JQ=;
        h=Date:To:From:Subject:From;
        b=ZNH4WYlAq5n1HC7sSfu+u350bIF/uBZ+o5zDXf3/axEF/WsGPWga8LtKfAfn3hTCz
         +8I+er1cFnaaoW+CdxB6hpaRdXjdBmm47kvM3zybfdLsGCjdFy1SK5cWjytzTh6QXQ
         bnAmr5OYrP+VnuxCRGTuXekhFZdTyICme71D909s=
Date:   Sun, 10 Sep 2023 13:48:12 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint.patch added to mm-unstable branch
Message-Id: <20230910204813.29603C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: remove 'struct target *' parameter from damon_aggregated tracepoint
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: remove 'struct target *' parameter from damon_aggregated tracepoint
Date: Thu, 7 Sep 2023 02:29:29 +0000

damon_aggregateed tracepoint is receiving 'struct target *', but doesn't
use it.  Remove it from the prototype.

Link: https://lkml.kernel.org/r/20230907022929.91361-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |    6 +++---
 mm/damon/core.c              |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/trace/events/damon.h~mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint
+++ a/include/trace/events/damon.h
@@ -11,10 +11,10 @@
 
 TRACE_EVENT(damon_aggregated,
 
-	TP_PROTO(struct damon_target *t, unsigned int target_id,
-		struct damon_region *r, unsigned int nr_regions),
+	TP_PROTO(unsigned int target_id, struct damon_region *r,
+		unsigned int nr_regions),
 
-	TP_ARGS(t, target_id, r, nr_regions),
+	TP_ARGS(target_id, r, nr_regions),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, target_id)
--- a/mm/damon/core.c~mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint
+++ a/mm/damon/core.c
@@ -776,7 +776,7 @@ static void kdamond_reset_aggregated(str
 		struct damon_region *r;
 
 		damon_for_each_region(r, t) {
-			trace_damon_aggregated(t, ti, r, damon_nr_regions(t));
+			trace_damon_aggregated(ti, r, damon_nr_regions(t));
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
 		}
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword.patch
docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom.patch
docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section.patch
docs-mm-damon-design-explicitly-introduce-nr_accesses.patch
docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint.patch
docs-mm-damon-design-add-a-section-for-kdamond-and-damon-context.patch
docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context.patch
mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings.patch
mm-damon-core-add-more-comments-for-nr_accesses.patch
mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation.patch
mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint.patch

