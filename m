Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82532C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377906AbiATV3O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38860 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377905AbiATV3N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B00561715
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C184C340E0;
        Thu, 20 Jan 2022 21:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714152;
        bh=XDclI5PIyrSnZa2RU3kmT1eKQHnRrgmGdjMSI6b+qoM=;
        h=Date:From:To:Subject:From;
        b=2WRc8J9df02u5QKM2TDfeY/0RRg922N2dpGbJEEjaZZrkoDNGIpMD2sLz+dDe48Vm
         IrvVXK4W2pxOYZwnGp6YD6LELZhVcYnJc2HWfpe49Vg17OztAI7pogcwWGkukrP6Rb
         RDY0VueDUErIfDofMPpGU34mCao0H4VVM2SGUUrs=
Date:   Thu, 20 Jan 2022 13:29:12 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-hide-kernel-pointer-from-tracepoint-event.patch removed from -mm
 tree
Message-ID: <20220120212912.S2ZFlv6U-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: hide kernel pointer from tracepoint event
has been removed from the -mm tree.  Its filename was
     mm-damon-hide-kernel-pointer-from-tracepoint-event.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sj@kernel.org are


