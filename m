Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7790EE7C4F5
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243954AbjJDUSj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244050AbjJDUSi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08309C1
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49628C433C8;
        Wed,  4 Oct 2023 20:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450713;
        bh=0w6jyH+CQRAuXNoJO+mkWIBxF1p/bRb7NeRtC9f27/Y=;
        h=Date:To:From:Subject:From;
        b=K6A1fG37yB6QOm/LD8kg4S19P0bzsEAI8jdzE0z2jYuUkXw0V+AOjDHL5hVSzQbeo
         kCN3l8/IqCDDimETjYi3FWManwt5wkdJM2602w1gesp8ZnyRFFT5XjHJcb0ksAmSYl
         mMThF2GB3IaQKf+q1lDAhRNZQgnIji8ZvYFWcr2A=
Date:   Wed, 04 Oct 2023 13:18:32 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint.patch removed from -mm tree
Message-Id: <20231004201833.49628C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: remove 'struct target *' parameter from damon_aggregated tracepoint
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


