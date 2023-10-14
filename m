Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F6FCDB465
	for <mm-commits@archiver.kernel.org>; Sat, 14 Oct 2023 22:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjJNWdX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Oct 2023 18:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjJNWdW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Oct 2023 18:33:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509D6D6
        for <mm-commits@vger.kernel.org>; Sat, 14 Oct 2023 15:33:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A10CC433C8;
        Sat, 14 Oct 2023 22:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697322801;
        bh=GXHr6pC3GE5aomjijSkJoo2u8e6ES2x1gn1rxf98LAU=;
        h=Date:To:From:Subject:From;
        b=ulBCPZ1eCQxAbSfp5axkOZuFVkwJWQ8q2QJykqRjjxk/0eeGZl6/A7jX0zE3RoL88
         uZrIqLXgnj0yE8MF4loGYC7sOpn3IQr9K2FSLzldAgK1sWAj4KYr3eaQtRn6L3boAe
         C7Elnp3lr3r4I6y9iwznapx9Lm5eXgZnLfYXZU6M=
Date:   Sat, 14 Oct 2023 15:33:17 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-do-not-update-tried-regions-more-than-one-damon-snapshot.patch added to mm-unstable branch
Message-Id: <20231014223320.4A10CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: do not update tried regions more than one DAMON snapshot
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-do-not-update-tried-regions-more-than-one-damon-snapshot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-do-not-update-tried-regions-more-than-one-damon-snapshot.patch

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
Subject: mm/damon/sysfs-schemes: do not update tried regions more than one DAMON snapshot
Date: Thu, 12 Oct 2023 19:22:53 +0000

Patch series "mm/damon/sysfs-schemes: Do DAMOS tried regions update for
only one apply interval".

DAMOS tried regions update feature of DAMON sysfs interface is doing the
update for one aggregation interval after the request is made.  Since the
per-scheme apply interval is supported, that behavior makes no much sense.
That is, the tried regions directory will have regions from multiple
DAMON monitoring results snapshots, or no region for apply intervals that
much shorter than, or longer than the aggregation interval, respectively. 
Update the behavior to update the regions for each scheme for only its
apply interval, and update the document.

Since DAMOS apply interval is the aggregation by default, this change
makes no visible behavioral difference to old users who don't explicitly
set the apply intervals.

Patches Sequence
----------------

The first two patches makes schemes of apply intervals that much shorter
or longer than the aggregation interval to keep the maximum and minimum
times for continuing the update.  After the two patches, the update aligns
with the each scheme's apply interval.

Finally, the third patch updates the document to reflect the behavior.


This patch (of 3):

DAMON_SYSFS exposes every DAMON-found region that eligible for applying
the scheme action for one aggregation interval.  However, each DAMON-based
operation scheme has its own apply interval.  Hence, for a scheme that
having its apply interval much smaller than the aggregation interval,
DAMON_SYSFS will expose the scheme regions that applied to more than one
DAMON monitoring results snapshots.  Since the purpose of DAMON tried
regions is exposing single snapshot, this makes no much sense.  Track
progress of each scheme's tried regions update and avoid the case.

Link: https://lkml.kernel.org/r/20231012192256.33556-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20231012192256.33556-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   77 +++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-do-not-update-tried-regions-more-than-one-damon-snapshot
+++ a/mm/damon/sysfs-schemes.c
@@ -113,11 +113,47 @@ static const struct kobj_type damon_sysf
  * scheme regions directory
  */
 
+/*
+ * enum damos_sysfs_regions_upd_status - Represent DAMOS tried regions update
+ *					 status
+ * @DAMOS_TRIED_REGIONS_UPD_IDLE:		Waiting for next request.
+ * @DAMOS_TRIED_REGIONS_UPD_STARTED:		Update started.
+ * @DAMOS_TRIED_REGIONS_UPD_FINISHED:	Update finished.
+ *
+ * Each DAMON-based operation scheme (&struct damos) has its own apply
+ * interval, and we need to expose the scheme tried regions based on only
+ * single snapshot.  For this, we keep the tried regions update status for each
+ * scheme.  The status becomes 'idle' at the beginning.
+ *
+ * Once the tried regions update request is received, the request handling
+ * start function (damon_sysfs_scheme_update_regions_start()) sets the status
+ * of all schemes as 'idle' again, and register ->before_damos_apply() and
+ * ->after_sampling() callbacks.
+ *
+ * Then, the first followup ->before_damos_apply() callback
+ * (damon_sysfs_before_damos_apply()) sets the status 'started'.  The first
+ * ->after_sampling() callback (damon_sysfs_after_sampling()) after the call
+ * is called only after the scheme is completely applied
+ * to the given snapshot.  Hence the callback knows the situation by showing
+ * 'started' status, and sets the status as 'finished'.  Then,
+ * damon_sysfs_before_damos_apply() understands the situation by showing the
+ * 'finished' status and do nothing.
+ *
+ *  Finally, the tried regions request handling finisher function
+ *  (damon_sysfs_schemes_update_regions_stop()) unregisters the callbacks.
+ */
+enum damos_sysfs_regions_upd_status {
+	DAMOS_TRIED_REGIONS_UPD_IDLE,
+	DAMOS_TRIED_REGIONS_UPD_STARTED,
+	DAMOS_TRIED_REGIONS_UPD_FINISHED,
+};
+
 struct damon_sysfs_scheme_regions {
 	struct kobject kobj;
 	struct list_head regions_list;
 	int nr_regions;
 	unsigned long total_bytes;
+	enum damos_sysfs_regions_upd_status upd_status;
 };
 
 static struct damon_sysfs_scheme_regions *
@@ -130,6 +166,7 @@ damon_sysfs_scheme_regions_alloc(void)
 	INIT_LIST_HEAD(&regions->regions_list);
 	regions->nr_regions = 0;
 	regions->total_bytes = 0;
+	regions->upd_status = DAMOS_TRIED_REGIONS_UPD_IDLE;
 	return regions;
 }
 
@@ -1777,6 +1814,10 @@ static int damon_sysfs_before_damos_appl
 		return 0;
 
 	sysfs_regions = sysfs_schemes->schemes_arr[schemes_idx]->tried_regions;
+	if (sysfs_regions->upd_status == DAMOS_TRIED_REGIONS_UPD_FINISHED)
+		return 0;
+	if (sysfs_regions->upd_status == DAMOS_TRIED_REGIONS_UPD_IDLE)
+		sysfs_regions->upd_status = DAMOS_TRIED_REGIONS_UPD_STARTED;
 	sysfs_regions->total_bytes += r->ar.end - r->ar.start;
 	if (damos_regions_upd_total_bytes_only)
 		return 0;
@@ -1793,6 +1834,29 @@ static int damon_sysfs_before_damos_appl
 	return 0;
 }
 
+/*
+ * DAMON callback that called after each accesses sampling.  While this
+ * callback is registered, damon_sysfs_lock should be held to ensure the
+ * regions directories exist.
+ */
+static int damon_sysfs_after_sampling(struct damon_ctx *ctx)
+{
+	struct damon_sysfs_schemes *sysfs_schemes =
+		damon_sysfs_schemes_for_damos_callback;
+	struct damon_sysfs_scheme_regions *sysfs_regions;
+	int i;
+
+	for (i = 0; i < sysfs_schemes->nr; i++) {
+		sysfs_regions = sysfs_schemes->schemes_arr[i]->tried_regions;
+		if (sysfs_regions->upd_status ==
+				DAMOS_TRIED_REGIONS_UPD_STARTED)
+			sysfs_regions->upd_status =
+				DAMOS_TRIED_REGIONS_UPD_FINISHED;
+	}
+
+	return 0;
+}
+
 /* Called from damon_sysfs_cmd_request_callback under damon_sysfs_lock */
 int damon_sysfs_schemes_clear_regions(
 		struct damon_sysfs_schemes *sysfs_schemes,
@@ -1816,6 +1880,16 @@ int damon_sysfs_schemes_clear_regions(
 	return 0;
 }
 
+static void damos_tried_regions_init_upd_status(
+		struct damon_sysfs_schemes *sysfs_schemes)
+{
+	int i;
+
+	for (i = 0; i < sysfs_schemes->nr; i++)
+		sysfs_schemes->schemes_arr[i]->tried_regions->upd_status =
+			DAMOS_TRIED_REGIONS_UPD_IDLE;
+}
+
 /* Called from damon_sysfs_cmd_request_callback under damon_sysfs_lock */
 int damon_sysfs_schemes_update_regions_start(
 		struct damon_sysfs_schemes *sysfs_schemes,
@@ -1823,8 +1897,10 @@ int damon_sysfs_schemes_update_regions_s
 {
 	damon_sysfs_schemes_clear_regions(sysfs_schemes, ctx);
 	damon_sysfs_schemes_for_damos_callback = sysfs_schemes;
+	damos_tried_regions_init_upd_status(sysfs_schemes);
 	damos_regions_upd_total_bytes_only = total_bytes_only;
 	ctx->callback.before_damos_apply = damon_sysfs_before_damos_apply;
+	ctx->callback.after_sampling = damon_sysfs_after_sampling;
 	return 0;
 }
 
@@ -1837,6 +1913,7 @@ int damon_sysfs_schemes_update_regions_s
 {
 	damon_sysfs_schemes_for_damos_callback = NULL;
 	ctx->callback.before_damos_apply = NULL;
+	ctx->callback.after_sampling = NULL;
 	damon_sysfs_schemes_region_idx = 0;
 	return 0;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-check-damos-regions-update-progress-from-before_terminate.patch
mm-damon-sysfs-schemes-do-not-update-tried-regions-more-than-one-damon-snapshot.patch
mm-damon-sysfs-avoid-empty-scheme-tried-regions-for-large-apply-interval.patch
docs-admin-guide-mm-damon-usage-update-for-tried-regions-update-time-interval.patch

