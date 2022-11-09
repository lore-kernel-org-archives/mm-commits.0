Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D1DC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiKIBmA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiKIBkV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBD7682A7
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE9D7617E8
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBB1C433D6;
        Wed,  9 Nov 2022 01:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957981;
        bh=wBFYz4N5la4XqkGIeZXHPLWrW6B7Z/sixMnJUkdeYJs=;
        h=Date:To:From:Subject:From;
        b=W62Y006Fqp3VHo/PqAFu6MvlaAwd8cdFnDSnk3rMWSaud9/fOCZLQ0h9kFzlX9OBO
         NhldIOvVP0t3hXrQ6blhxklY+RYdOBr2ZjCA6S+1b1DyH4zXpeFv4P+Z2yMXSECvwc
         8OBlAtl6twsgEexDgHV9hkyRMegfjlmLKw3qqQqY=
Date:   Tue, 08 Nov 2022 17:39:40 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch removed from -mm tree
Message-Id: <20221109013941.4EBB1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: split out scheme quota adjustment logic into a new function
has been removed from the -mm tree.  Its filename was
     mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: split out scheme quota adjustment logic into a new function
Date: Wed, 26 Oct 2022 22:59:35 +0000

DAMOS quota adjustment logic in 'kdamond_apply_schemes()', has some amount
of code, and the logic is not so straightforward.  Split it out to a new
function for better readability.

Link: https://lkml.kernel.org/r/20221026225943.100429-5-sj@kernel.org
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

docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

