Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDE5C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiANWKy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiANWKx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:10:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89039C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:10:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 521CDB8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7957C36AE9;
        Fri, 14 Jan 2022 22:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198251;
        bh=ldj3WX+CtmHXViybAkVKj1BnaVhm96z7FxJvSl8RpVk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DWzsDz0IJtlWEFLEOr6KneXtbQqPjm4cOLDkmCVGy+aWEOAV5hAK89CFKfcj42ZuE
         PL39hjWgrDQbW/cmOpsnfu76T9Jns+t3JpGAD3kiSzJtiVQ9+DR2oz99J2WF9E4p1D
         EmCNk51m9+vRxK3rmvjfRXWl0Op6SI4ewnHu0z7o=
Date:   Fri, 14 Jan 2022 14:10:50 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 146/146] mm/damon: hide kernel pointer from
 tracepoint event
Message-ID: <20220114221050.qcGC9jBnT%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: hide kernel pointer from tracepoint event

DAMON's virtual address spaces monitoring primitive uses 'struct pid *' of
the target process as its monitoring target id.  The kernel address is
exposed as-is to the user space via the DAMON tracepoint,
'damon_aggregated'.

Though primarily only privileged users are allowed to access that, it
would be better to avoid unnecessarily exposing kernel pointers so. 
Because the trace result is only required to be able to distinguish each
target, we aren't need to use the pointer as-is.

This commit makes the tracepoint to use the index of the target in the
context's targets list as its id in the tracepoint, to hide the kernel
space address.

Link: https://lkml.kernel.org/r/20211229131016.23641-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |    8 ++++----
 mm/damon/core.c              |    4 +++-
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/include/trace/events/damon.h~mm-damon-hide-kernel-pointer-from-tracepoint-event
+++ a/include/trace/events/damon.h
@@ -11,10 +11,10 @@
 
 TRACE_EVENT(damon_aggregated,
 
-	TP_PROTO(struct damon_target *t, struct damon_region *r,
-		unsigned int nr_regions),
+	TP_PROTO(struct damon_target *t, unsigned int target_id,
+		struct damon_region *r, unsigned int nr_regions),
 
-	TP_ARGS(t, r, nr_regions),
+	TP_ARGS(t, target_id, r, nr_regions),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, target_id)
@@ -26,7 +26,7 @@ TRACE_EVENT(damon_aggregated,
 	),
 
 	TP_fast_assign(
-		__entry->target_id = t->id;
+		__entry->target_id = target_id;
 		__entry->nr_regions = nr_regions;
 		__entry->start = r->ar.start;
 		__entry->end = r->ar.end;
--- a/mm/damon/core.c~mm-damon-hide-kernel-pointer-from-tracepoint-event
+++ a/mm/damon/core.c
@@ -514,15 +514,17 @@ static bool kdamond_aggregate_interval_p
 static void kdamond_reset_aggregated(struct damon_ctx *c)
 {
 	struct damon_target *t;
+	unsigned int ti = 0;	/* target's index */
 
 	damon_for_each_target(t, c) {
 		struct damon_region *r;
 
 		damon_for_each_region(r, t) {
-			trace_damon_aggregated(t, r, damon_nr_regions(t));
+			trace_damon_aggregated(t, ti, r, damon_nr_regions(t));
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
 		}
+		ti++;
 	}
 }
 
_
