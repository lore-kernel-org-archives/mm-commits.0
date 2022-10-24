Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698C0C38A2D
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 00:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiJYAHz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbiJYAH2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 20:07:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCC01D0C6
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 15:25:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 924E3615D9
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 22:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F56C433D6;
        Mon, 24 Oct 2022 22:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666650341;
        bh=N8hq6yK9j8Zqt3ilMW69jia1dg3g1Hrw0pB8IDuyIC0=;
        h=Date:To:From:Subject:From;
        b=hGpDNUHvLt897x9XH6JucgAXMOJd6tIm/weWefesOsd+ZEc+154qxgGTkaA+VoRDa
         LyEhaEyfiAXGiUvTfYIo4OxI5RiT7b5KcQx3H5E01+sKa7h0HWvrHR7t3K/avZoQHV
         H3xm5y8cHgsvrGmd4iSfCAAQEvh6IShpLQMBkCmw=
Date:   Mon, 24 Oct 2022 15:25:40 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch added to mm-unstable branch
Message-Id: <20221024222540.E9F56C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: split out scheme quota adjustment logic into a new function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch

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
Subject: mm/damon/core: split out scheme quota adjustment logic into a new function
Date: Mon, 24 Oct 2022 20:49:12 +0000

DAMOS quota adjustment logic in 'kdamond_apply_schemes()', has some amount
of code, and the logic is not so straightforward.  Split it out to a new
function for better readability.

Link: https://lkml.kernel.org/r/20221024204919.18524-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   91 ++++++++++++++++++++++++----------------------
 1 file changed, 48 insertions(+), 43 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function
+++ a/mm/damon/core.c
@@ -848,6 +848,53 @@ static void damos_set_effective_quota(st
 	quota->esz = esz;
 }
 
+static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
+{
+	struct damos_quota *quota = &s->quota;
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned long cumulated_sz;
+	unsigned int score, max_score = 0;
+
+	if (!quota->ms && !quota->sz)
+		return;
+
+	/* New charge window starts */
+	if (time_after_eq(jiffies, quota->charged_from +
+				msecs_to_jiffies(quota->reset_interval))) {
+		if (quota->esz && quota->charged_sz >= quota->esz)
+			s->stat.qt_exceeds++;
+		quota->total_charged_sz += quota->charged_sz;
+		quota->charged_from = jiffies;
+		quota->charged_sz = 0;
+		damos_set_effective_quota(quota);
+	}
+
+	if (!c->ops.get_scheme_score)
+		return;
+
+	/* Fill up the score histogram */
+	memset(quota->histogram, 0, sizeof(quota->histogram));
+	damon_for_each_target(t, c) {
+		damon_for_each_region(r, t) {
+			if (!__damos_valid_target(r, s))
+				continue;
+			score = c->ops.get_scheme_score(c, t, r, s);
+			quota->histogram[score] += damon_sz_region(r);
+			if (score > max_score)
+				max_score = score;
+		}
+	}
+
+	/* Set the min score limit */
+	for (cumulated_sz = 0, score = max_score; ; score--) {
+		cumulated_sz += quota->histogram[score];
+		if (cumulated_sz >= quota->esz || !score)
+			break;
+	}
+	quota->min_score = score;
+}
+
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
@@ -855,52 +902,10 @@ static void kdamond_apply_schemes(struct
 	struct damos *s;
 
 	damon_for_each_scheme(s, c) {
-		struct damos_quota *quota = &s->quota;
-		unsigned long cumulated_sz;
-		unsigned int score, max_score = 0;
-
 		if (!s->wmarks.activated)
 			continue;
 
-		if (!quota->ms && !quota->sz)
-			continue;
-
-		/* New charge window starts */
-		if (time_after_eq(jiffies, quota->charged_from +
-					msecs_to_jiffies(
-						quota->reset_interval))) {
-			if (quota->esz && quota->charged_sz >= quota->esz)
-				s->stat.qt_exceeds++;
-			quota->total_charged_sz += quota->charged_sz;
-			quota->charged_from = jiffies;
-			quota->charged_sz = 0;
-			damos_set_effective_quota(quota);
-		}
-
-		if (!c->ops.get_scheme_score)
-			continue;
-
-		/* Fill up the score histogram */
-		memset(quota->histogram, 0, sizeof(quota->histogram));
-		damon_for_each_target(t, c) {
-			damon_for_each_region(r, t) {
-				if (!__damos_valid_target(r, s))
-					continue;
-				score = c->ops.get_scheme_score(
-						c, t, r, s);
-				quota->histogram[score] += damon_sz_region(r);
-				if (score > max_score)
-					max_score = score;
-			}
-		}
-
-		/* Set the min score limit */
-		for (cumulated_sz = 0, score = max_score; ; score--) {
-			cumulated_sz += quota->histogram[score];
-			if (cumulated_sz >= quota->esz || !score)
-				break;
-		}
-		quota->min_score = score;
+		damos_adjust_quota(c, s);
 	}
 
 	damon_for_each_target(t, c) {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function.patch
mm-damon-core-split-damos-application-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch
mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch
mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch
mm-damon-sysfs-move-sysfs_lock-to-common-module.patch
mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module.patch
mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch

