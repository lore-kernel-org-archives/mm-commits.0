Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2CCAC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 21:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 815A36136A
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 21:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhJSVdz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 17:33:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhJSVdz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 17:33:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D5C061355;
        Tue, 19 Oct 2021 21:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634679101;
        bh=wxlikA5bNP1NIdzDXiGUvBiK41JgyYJlEQktgXrDRS4=;
        h=Date:From:To:Subject:From;
        b=XS9Lm620TuUgCkQ/Pf9vJ76K1iamBd33lR5lc1lH8dVa4srcUEd0vLuV1Q2ZaAcpV
         HP5ndqkm5TiQAsQGBtacTLLc1TVCuEj09LM1kJzity9CtfXiDZpL/SUtJRhOmNQHb0
         Vy/2QatLUdzpfFzrxyfBiZMmNjQxQIZtitKvVv4o=
Date:   Tue, 19 Oct 2021 14:31:40 -0700
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  +
 =?US-ASCII?Q?mm-damon-schemes-implement-size-quota-for-schemes-applica?=
 =?US-ASCII?Q?tion-speed-control.patch?= added to -mm tree
Message-ID: <20211019213140.Tyo9xk5hK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/schemes: implement size quota for schemes application speed control
has been added to the -mm tree.  Its filename is
     mm-damon-schemes-implement-size-quota-for-schemes-application-speed-control.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-schemes-implement-size-quota-for-schemes-application-speed-control.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-schemes-implement-size-quota-for-schemes-application-speed-control.patch

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
Subject: mm/damon/schemes: implement size quota for schemes application speed control

There could be arbitrarily large memory regions fulfilling the target data
access pattern of a DAMON-based operation scheme.  In the case, applying
the action of the scheme could incur too high overhead.  To provide an
intuitive way for avoiding it, this commit implements a feature called
size quota.  If the quota is set, DAMON tries to apply the action only up
to the given amount of memory regions within a given time window.

Link: https://lkml.kernel.org/r/20211019150731.16699-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   36 +++++++++++++++++++++---
 mm/damon/core.c       |   60 ++++++++++++++++++++++++++++++++++------
 mm/damon/dbgfs.c      |    4 ++
 3 files changed, 87 insertions(+), 13 deletions(-)

--- a/include/linux/damon.h~mm-damon-schemes-implement-size-quota-for-schemes-application-speed-control
+++ a/include/linux/damon.h
@@ -90,6 +90,26 @@ enum damos_action {
 };
 
 /**
+ * struct damos_quota - Controls the aggressiveness of the given scheme.
+ * @sz:			Maximum bytes of memory that the action can be applied.
+ * @reset_interval:	Charge reset interval in milliseconds.
+ *
+ * To avoid consuming too much CPU time or IO resources for applying the
+ * &struct damos->action to large memory, DAMON allows users to set a size
+ * quota.  The quota can be set by writing non-zero values to &sz.  If the size
+ * quota is set, DAMON tries to apply the action only up to &sz bytes within
+ * &reset_interval.
+ */
+struct damos_quota {
+	unsigned long sz;
+	unsigned long reset_interval;
+
+/* private: For charging the quota */
+	unsigned long charged_sz;
+	unsigned long charged_from;
+};
+
+/**
  * struct damos - Represents a Data Access Monitoring-based Operation Scheme.
  * @min_sz_region:	Minimum size of target regions.
  * @max_sz_region:	Maximum size of target regions.
@@ -98,13 +118,20 @@ enum damos_action {
  * @min_age_region:	Minimum age of target regions.
  * @max_age_region:	Maximum age of target regions.
  * @action:		&damo_action to be applied to the target regions.
+ * @quota:		Control the aggressiveness of this scheme.
  * @stat_count:		Total number of regions that this scheme is applied.
  * @stat_sz:		Total size of regions that this scheme is applied.
  * @list:		List head for siblings.
  *
- * For each aggregation interval, DAMON applies @action to monitoring target
- * regions fit in the condition and updates the statistics.  Note that both
- * the minimums and the maximums are inclusive.
+ * For each aggregation interval, DAMON finds regions which fit in the
+ * condition (&min_sz_region, &max_sz_region, &min_nr_accesses,
+ * &max_nr_accesses, &min_age_region, &max_age_region) and applies &action to
+ * those.  To avoid consuming too much CPU time or IO resources for the
+ * &action, &quota is used.
+ *
+ * After applying the &action to each region, &stat_count and &stat_sz is
+ * updated to reflect the number of regions and total size of regions that the
+ * &action is applied.
  */
 struct damos {
 	unsigned long min_sz_region;
@@ -114,6 +141,7 @@ struct damos {
 	unsigned int min_age_region;
 	unsigned int max_age_region;
 	enum damos_action action;
+	struct damos_quota quota;
 	unsigned long stat_count;
 	unsigned long stat_sz;
 	struct list_head list;
@@ -310,7 +338,7 @@ struct damos *damon_new_scheme(
 		unsigned long min_sz_region, unsigned long max_sz_region,
 		unsigned int min_nr_accesses, unsigned int max_nr_accesses,
 		unsigned int min_age_region, unsigned int max_age_region,
-		enum damos_action action);
+		enum damos_action action, struct damos_quota *quota);
 void damon_add_scheme(struct damon_ctx *ctx, struct damos *s);
 void damon_destroy_scheme(struct damos *s);
 
--- a/mm/damon/core.c~mm-damon-schemes-implement-size-quota-for-schemes-application-speed-control
+++ a/mm/damon/core.c
@@ -89,7 +89,7 @@ struct damos *damon_new_scheme(
 		unsigned long min_sz_region, unsigned long max_sz_region,
 		unsigned int min_nr_accesses, unsigned int max_nr_accesses,
 		unsigned int min_age_region, unsigned int max_age_region,
-		enum damos_action action)
+		enum damos_action action, struct damos_quota *quota)
 {
 	struct damos *scheme;
 
@@ -107,6 +107,11 @@ struct damos *damon_new_scheme(
 	scheme->stat_sz = 0;
 	INIT_LIST_HEAD(&scheme->list);
 
+	scheme->quota.sz = quota->sz;
+	scheme->quota.reset_interval = quota->reset_interval;
+	scheme->quota.charged_sz = 0;
+	scheme->quota.charged_from = 0;
+
 	return scheme;
 }
 
@@ -530,15 +535,25 @@ static void kdamond_reset_aggregated(str
 	}
 }
 
+static void damon_split_region_at(struct damon_ctx *ctx,
+		struct damon_target *t, struct damon_region *r,
+		unsigned long sz_r);
+
 static void damon_do_apply_schemes(struct damon_ctx *c,
 				   struct damon_target *t,
 				   struct damon_region *r)
 {
 	struct damos *s;
-	unsigned long sz;
 
 	damon_for_each_scheme(s, c) {
-		sz = r->ar.end - r->ar.start;
+		struct damos_quota *quota = &s->quota;
+		unsigned long sz = r->ar.end - r->ar.start;
+
+		/* Check the quota */
+		if (quota->sz && quota->charged_sz >= quota->sz)
+			continue;
+
+		/* Check the target regions condition */
 		if (sz < s->min_sz_region || s->max_sz_region < sz)
 			continue;
 		if (r->nr_accesses < s->min_nr_accesses ||
@@ -546,22 +561,51 @@ static void damon_do_apply_schemes(struc
 			continue;
 		if (r->age < s->min_age_region || s->max_age_region < r->age)
 			continue;
-		s->stat_count++;
-		s->stat_sz += sz;
-		if (c->primitive.apply_scheme)
+
+		/* Apply the scheme */
+		if (c->primitive.apply_scheme) {
+			if (quota->sz && quota->charged_sz + sz > quota->sz) {
+				sz = ALIGN_DOWN(quota->sz - quota->charged_sz,
+						DAMON_MIN_REGION);
+				if (!sz)
+					goto update_stat;
+				damon_split_region_at(c, t, r, sz);
+			}
 			c->primitive.apply_scheme(c, t, r, s);
+			quota->charged_sz += sz;
+		}
 		if (s->action != DAMOS_STAT)
 			r->age = 0;
+
+update_stat:
+		s->stat_count++;
+		s->stat_sz += sz;
 	}
 }
 
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
-	struct damon_region *r;
+	struct damon_region *r, *next_r;
+	struct damos *s;
+
+	damon_for_each_scheme(s, c) {
+		struct damos_quota *quota = &s->quota;
+
+		if (!quota->sz)
+			continue;
+
+		/* New charge window starts */
+		if (time_after_eq(jiffies, quota->charged_from +
+					msecs_to_jiffies(
+						quota->reset_interval))) {
+			quota->charged_from = jiffies;
+			quota->charged_sz = 0;
+		}
+	}
 
 	damon_for_each_target(t, c) {
-		damon_for_each_region(r, t)
+		damon_for_each_region_safe(r, next_r, t)
 			damon_do_apply_schemes(c, t, r);
 	}
 }
--- a/mm/damon/dbgfs.c~mm-damon-schemes-implement-size-quota-for-schemes-application-speed-control
+++ a/mm/damon/dbgfs.c
@@ -188,6 +188,8 @@ static struct damos **str_to_schemes(con
 
 	*nr_schemes = 0;
 	while (pos < len && *nr_schemes < max_nr_schemes) {
+		struct damos_quota quota = {};
+
 		ret = sscanf(&str[pos], "%lu %lu %u %u %u %u %u%n",
 				&min_sz, &max_sz, &min_nr_a, &max_nr_a,
 				&min_age, &max_age, &action, &parsed);
@@ -200,7 +202,7 @@ static struct damos **str_to_schemes(con
 
 		pos += parsed;
 		scheme = damon_new_scheme(min_sz, max_sz, min_nr_a, max_nr_a,
-				min_age, max_age, action);
+				min_age, max_age, action, &quota);
 		if (!scheme)
 			goto fail;
 
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch
mm-damon-core-account-age-of-target-regions.patch
mm-damon-core-implement-damon-based-operation-schemes-damos.patch
mm-damon-vaddr-support-damon-based-operation-schemes.patch
mm-damon-dbgfs-support-damon-based-operation-schemes.patch
mm-damon-schemes-implement-statistics-feature.patch
selftests-damon-add-schemes-debugfs-tests.patch
docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch
mm-damon-dbgfs-allow-users-to-set-initial-monitoring-target-regions.patch
mm-damon-dbgfs-test-add-a-unit-test-case-for-init_regions.patch
docs-admin-guide-mm-damon-document-init_regions-feature.patch
mm-damon-vaddr-separate-commonly-usable-functions.patch
mm-damon-vaddr-separate-commonly-usable-functions-fix.patch
mm-damon-implement-primitives-for-physical-address-space-monitoring.patch
mm-damon-dbgfs-support-physical-memory-monitoring.patch
docs-damon-document-physical-memory-monitoring-support.patch
mm-damon-paddr-support-the-pageout-scheme.patch
mm-damon-schemes-implement-size-quota-for-schemes-application-speed-control.patch
mm-damon-schemes-skip-already-charged-targets-and-regions.patch
mm-damon-schemes-implement-time-quota.patch
mm-damon-dbgfs-support-quotas-of-schemes.patch
mm-damon-selftests-support-schemes-quotas.patch
mm-damon-schemes-prioritize-regions-within-the-quotas.patch
mm-damon-vaddrpaddr-support-pageout-prioritization.patch
mm-damon-dbgfs-support-prioritization-weights.patch
tools-selftests-damon-update-for-regions-prioritization-of-schemes.patch
mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism.patch
mm-damon-dbgfs-support-watermarks.patch
selftests-damon-support-watermarks.patch
mm-damon-introduce-damon-based-reclamation-damon_reclaim.patch
documentation-admin-guide-mm-damon-add-a-document-for-damon_reclaim.patch

