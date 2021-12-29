Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6BDC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 29 Dec 2021 23:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbhL2XVu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Dec 2021 18:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbhL2XVu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Dec 2021 18:21:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498F4C061574
        for <mm-commits@vger.kernel.org>; Wed, 29 Dec 2021 15:21:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 739D961579
        for <mm-commits@vger.kernel.org>; Wed, 29 Dec 2021 23:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9944C36AEA;
        Wed, 29 Dec 2021 23:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640820108;
        bh=pFhwsUpQ76jjJyecoslmVxOi+iEIZw9NpSiJYGKYJwc=;
        h=Date:From:To:Subject:From;
        b=cWeZa/sFTgAeBWJr7YS+XI5cipwMYBjcjfITTjtIcnfdoCyU2AH24k4Qs0EqruLe1
         FM4sSuRTPoqODpxPsmbSmwskClxC6+ccUcs3NMI5uI/RXbpynMOHgYaptJdZD3bGVZ
         RAdTHQGLZ5qV0KdmtxpHgU/XpeFDcIIyOdZZklDc=
Date:   Wed, 29 Dec 2021 15:21:49 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  + mm-damon-hide-kernel-pointer-from-tracepoint-event.patch
 added to -mm tree
Message-ID: <20211229232149.6HPK4%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: hide kernel pointer from tracepoint event
has been added to the -mm tree.  Its filename is
     mm-damon-hide-kernel-pointer-from-tracepoint-event.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-hide-kernel-pointer-from-tracepoint-event.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-hide-kernel-pointer-from-tracepoint-event.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch
mm-damon-convert-macro-functions-to-static-inline-functions.patch
docs-admin-guide-mm-damon-usage-update-for-scheme-quotas-and-watermarks.patch
docs-admin-guide-mm-damon-usage-remove-redundant-information.patch
docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-for-kdamond_pid-and-mkrm_contexts.patch
mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch
mm-damon-schemes-account-scheme-actions-that-successfully-applied.patch
mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded.patch
mm-damon-reclaim-provide-reclamation-statistics.patch
docs-admin-guide-mm-damon-reclaim-document-statistics-parameters.patch
mm-damon-dbgfs-support-all-damos-stats.patch
docs-admin-guide-mm-damon-usage-update-for-schemes-statistics.patch
mm-damon-dbgfs-remove-a-unnecessary-variable.patch
mm-damon-vaddr-use-pr_debug-for-damon_va_three_regions-failure-logging.patch
mm-damon-vaddr-hide-kernel-pointer-from-damon_va_three_regions-failure-log.patch
mm-damon-hide-kernel-pointer-from-tracepoint-event.patch

