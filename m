Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E02C46CA1
	for <mm-commits@archiver.kernel.org>; Sat, 16 Sep 2023 20:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbjIPUSc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Sep 2023 16:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237994AbjIPUSW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Sep 2023 16:18:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7DACD8
        for <mm-commits@vger.kernel.org>; Sat, 16 Sep 2023 13:18:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166A8C433C8;
        Sat, 16 Sep 2023 20:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694895496;
        bh=tek3r3gofjAPu3kgH93dOzjQSVf+a4SoL2xo8G3+eZc=;
        h=Date:To:From:Subject:From;
        b=wsLUs6BSG4P4HMHo6qXv6W/37Vl6lN2ToiHn3w6sf70dvkC94C+xGu5s5WWEyC7/K
         LHfaUVP3KSNWICN0HR1cXK856EHKF8TB2l8Sb9i6ARCNaiLZZ7nD1TiLZnWBfyMCdC
         nTMpk8P6mBKQQmqpZjuO5wPBiwm0pwToX3q2QNz0=
Date:   Sat, 16 Sep 2023 13:18:15 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, rostedt@goodmis.org,
        corbet@lwn.net, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-support-damos-apply-interval.patch added to mm-unstable branch
Message-Id: <20230916201816.166A8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: support DAMOS apply interval
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-support-damos-apply-interval.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-support-damos-apply-interval.patch

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
Subject: mm/damon/sysfs-schemes: support DAMOS apply interval
Date: Sat, 16 Sep 2023 02:09:42 +0000

Update DAMON sysfs interface to support DAMOS apply intervals by adding a
new file, 'apply_interval_us' in each scheme directory.  Users can set and
get the interval for each scheme in microseconds by writing to and reading
from the file.

Link: https://lkml.kernel.org/r/20230916020945.47296-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   38 +++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-support-damos-apply-interval
+++ a/mm/damon/sysfs-schemes.c
@@ -1121,6 +1121,7 @@ struct damon_sysfs_scheme {
 	struct kobject kobj;
 	enum damos_action action;
 	struct damon_sysfs_access_pattern *access_pattern;
+	unsigned long apply_interval_us;
 	struct damon_sysfs_quotas *quotas;
 	struct damon_sysfs_watermarks *watermarks;
 	struct damon_sysfs_scheme_filters *filters;
@@ -1141,7 +1142,7 @@ static const char * const damon_sysfs_da
 };
 
 static struct damon_sysfs_scheme *damon_sysfs_scheme_alloc(
-		enum damos_action action)
+		enum damos_action action, unsigned long apply_interval_us)
 {
 	struct damon_sysfs_scheme *scheme = kmalloc(sizeof(*scheme),
 				GFP_KERNEL);
@@ -1150,6 +1151,7 @@ static struct damon_sysfs_scheme *damon_
 		return NULL;
 	scheme->kobj = (struct kobject){};
 	scheme->action = action;
+	scheme->apply_interval_us = apply_interval_us;
 	return scheme;
 }
 
@@ -1353,6 +1355,25 @@ static ssize_t action_store(struct kobje
 	return -EINVAL;
 }
 
+static ssize_t apply_interval_us_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme *scheme = container_of(kobj,
+			struct damon_sysfs_scheme, kobj);
+
+	return sysfs_emit(buf, "%lu\n", scheme->apply_interval_us);
+}
+
+static ssize_t apply_interval_us_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_scheme *scheme = container_of(kobj,
+			struct damon_sysfs_scheme, kobj);
+	int err = kstrtoul(buf, 0, &scheme->apply_interval_us);
+
+	return err ? err : count;
+}
+
 static void damon_sysfs_scheme_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_scheme, kobj));
@@ -1361,8 +1382,12 @@ static void damon_sysfs_scheme_release(s
 static struct kobj_attribute damon_sysfs_scheme_action_attr =
 		__ATTR_RW_MODE(action, 0600);
 
+static struct kobj_attribute damon_sysfs_scheme_apply_interval_us_attr =
+		__ATTR_RW_MODE(apply_interval_us, 0600);
+
 static struct attribute *damon_sysfs_scheme_attrs[] = {
 	&damon_sysfs_scheme_action_attr.attr,
+	&damon_sysfs_scheme_apply_interval_us_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme);
@@ -1413,7 +1438,11 @@ static int damon_sysfs_schemes_add_dirs(
 	schemes->schemes_arr = schemes_arr;
 
 	for (i = 0; i < nr_schemes; i++) {
-		scheme = damon_sysfs_scheme_alloc(DAMOS_STAT);
+		/*
+		 * apply_interval_us as 0 means same to aggregation interval
+		 * (same to before-apply_interval behavior)
+		 */
+		scheme = damon_sysfs_scheme_alloc(DAMOS_STAT, 0);
 		if (!scheme) {
 			damon_sysfs_schemes_rm_dirs(schemes);
 			return -ENOMEM;
@@ -1610,8 +1639,8 @@ static struct damos *damon_sysfs_mk_sche
 		.low = sysfs_wmarks->low,
 	};
 
-	scheme = damon_new_scheme(&pattern, sysfs_scheme->action, 0, &quota,
-			&wmarks);
+	scheme = damon_new_scheme(&pattern, sysfs_scheme->action,
+			sysfs_scheme->apply_interval_us, &quota, &wmarks);
 	if (!scheme)
 		return NULL;
 
@@ -1641,6 +1670,7 @@ static void damon_sysfs_update_scheme(st
 	scheme->pattern.max_age_region = access_pattern->age->max;
 
 	scheme->action = sysfs_scheme->action;
+	scheme->apply_interval_us = sysfs_scheme->apply_interval_us;
 
 	scheme->quota.ms = sysfs_quotas->ms;
 	scheme->quota.sz = sysfs_quotas->sz;
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
mm-damon-core-add-a-tracepoint-for-damos-apply-target-regions.patch
docs-admin-guide-mm-damon-usage-document-damos_before_apply-tracepoint.patch
mm-damon-core-use-number-of-passed-access-sampling-as-a-timer.patch
mm-damon-core-define-and-use-a-dedicated-function-for-region-access-rate-update.patch
mm-damon-vaddr-call-damon_update_region_access_rate-always.patch
mm-damon-core-implement-a-pseudo-moving-sum-function.patch
mm-damon-core-test-add-a-unit-test-for-damon_moving_sum.patch
mm-damon-core-introduce-nr_accesses_bp.patch
mm-damon-core-use-pseudo-moving-sum-for-nr_accesses_bp.patch
mm-damon-core-skip-updating-nr_accesses_bp-for-each-aggregation-interval.patch
mm-damon-core-mark-damon_moving_sum-as-a-static-function.patch
mm-damon-core-make-damos-uses-nr_accesses_bp-instead-of-nr_accesses.patch
mm-damon-sysfs-schemes-use-nr_accesses_bp-as-the-source-of-tried_regions-n-nr_accesses.patch
mm-damon-core-use-nr_accesses_bp-as-a-source-of-damos_before_apply-tracepoint.patch
mm-damon-core-implement-scheme-specific-apply-interval.patch
docs-mm-damon-design-document-damos-apply-intervals.patch
mm-damon-sysfs-schemes-support-damos-apply-interval.patch
selftests-damon-sysfs-test-damos-apply-intervals.patch
docs-admin-guide-mm-damon-usage-update-for-damos-apply-intervals.patch
docs-abi-damon-update-for-damos-apply-intervals.patch

