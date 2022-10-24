Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C76C38A2D
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 00:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiJYAHs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiJYAH0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 20:07:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7E9F6C1A
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 15:25:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14433B81707
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 22:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41ECC433D6;
        Mon, 24 Oct 2022 22:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666650336;
        bh=l+/m89+h5N7sJWizD9Gy8MA141lZeTK6b0KIKsjJCpo=;
        h=Date:To:From:Subject:From;
        b=lfF+Cv8+96J/xjUy6zot6+X0reOzCcGDCVPhBs+Q+Xa1E0y393LPxWTdUPzpp4Qcu
         XnLX1HT9m6WxuFYJrZNlRf9i9imKr14xDzhhRDCEUYxrA252ffKa3O7tGG8YRRLBzr
         KJXCBjRCSQMDj3Rtq+N4Zxs1f3u0T3uUf9H/s2yE=
Date:   Mon, 24 Oct 2022 15:25:35 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-split-damos-application-logic-into-a-new-function.patch added to mm-unstable branch
Message-Id: <20221024222536.A41ECC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: split damos application logic into a new function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-split-damos-application-logic-into-a-new-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-split-damos-application-logic-into-a-new-function.patch

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
Subject: mm/damon/core: split damos application logic into a new function
Date: Mon, 24 Oct 2022 20:49:10 +0000

The DAMOS action applying function, 'damon_do_apply_schemes()', is still
long and not easy to read.  Split out the code for applying a single
action to a single region into a new function for better readability.

Link: https://lkml.kernel.org/r/20221024204919.18524-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   73 ++++++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 34 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-split-damos-application-logic-into-a-new-function
+++ a/mm/damon/core.c
@@ -755,6 +755,44 @@ static bool damos_skip_charged_region(st
 	return false;
 }
 
+static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
+		struct damon_region *r, struct damos *s)
+{
+	struct damos_quota *quota = &s->quota;
+	unsigned long sz = damon_sz_region(r);
+	struct timespec64 begin, end;
+	unsigned long sz_applied = 0;
+
+	if (c->ops.apply_scheme) {
+		if (quota->esz && quota->charged_sz + sz > quota->esz) {
+			sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
+					DAMON_MIN_REGION);
+			if (!sz)
+				goto update_stat;
+			damon_split_region_at(t, r, sz);
+		}
+		ktime_get_coarse_ts64(&begin);
+		sz_applied = c->ops.apply_scheme(c, t, r, s);
+		ktime_get_coarse_ts64(&end);
+		quota->total_charged_ns += timespec64_to_ns(&end) -
+			timespec64_to_ns(&begin);
+		quota->charged_sz += sz;
+		if (quota->esz && quota->charged_sz >= quota->esz) {
+			quota->charge_target_from = t;
+			quota->charge_addr_from = r->ar.end + 1;
+		}
+	}
+	if (s->action != DAMOS_STAT)
+		r->age = 0;
+
+update_stat:
+	s->stat.nr_tried++;
+	s->stat.sz_tried += sz;
+	if (sz_applied)
+		s->stat.nr_applied++;
+	s->stat.sz_applied += sz_applied;
+}
+
 static void damon_do_apply_schemes(struct damon_ctx *c,
 				   struct damon_target *t,
 				   struct damon_region *r)
@@ -763,9 +801,6 @@ static void damon_do_apply_schemes(struc
 
 	damon_for_each_scheme(s, c) {
 		struct damos_quota *quota = &s->quota;
-		unsigned long sz;
-		struct timespec64 begin, end;
-		unsigned long sz_applied = 0;
 
 		if (!s->wmarks.activated)
 			continue;
@@ -780,37 +815,7 @@ static void damon_do_apply_schemes(struc
 		if (!damos_valid_target(c, t, r, s))
 			continue;
 
-		/* Apply the scheme */
-		sz = damon_sz_region(r);
-		if (c->ops.apply_scheme) {
-			if (quota->esz &&
-					quota->charged_sz + sz > quota->esz) {
-				sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
-						DAMON_MIN_REGION);
-				if (!sz)
-					goto update_stat;
-				damon_split_region_at(t, r, sz);
-			}
-			ktime_get_coarse_ts64(&begin);
-			sz_applied = c->ops.apply_scheme(c, t, r, s);
-			ktime_get_coarse_ts64(&end);
-			quota->total_charged_ns += timespec64_to_ns(&end) -
-				timespec64_to_ns(&begin);
-			quota->charged_sz += sz;
-			if (quota->esz && quota->charged_sz >= quota->esz) {
-				quota->charge_target_from = t;
-				quota->charge_addr_from = r->ar.end + 1;
-			}
-		}
-		if (s->action != DAMOS_STAT)
-			r->age = 0;
-
-update_stat:
-		s->stat.nr_tried++;
-		s->stat.sz_tried += sz;
-		if (sz_applied)
-			s->stat.nr_applied++;
-		s->stat.sz_applied += sz_applied;
+		damos_apply_scheme(c, t, r, s);
 	}
 }
 
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

