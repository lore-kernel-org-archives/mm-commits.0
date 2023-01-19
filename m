Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9A7C677F1
	for <mm-commits@archiver.kernel.org>; Fri, 20 Jan 2023 04:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjATEhf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 23:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjATEhN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 23:37:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65593C382E
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 20:34:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24D11B826FC
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA97CC433EF;
        Thu, 19 Jan 2023 22:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674167664;
        bh=9wrClXoXS8jAv50hRYvcb3jghf+8XVcn4mg/mULgQvE=;
        h=Date:To:From:Subject:From;
        b=tPHBv1jLp4WKdR0E41cs3vtMyGKnYKVRxM0evM4jWyXGerJUM+pOcUCF360DhGCzf
         m+5VUoRh5eTWBRyhN9i23fSaO+VMHGqqkb72B3sxdQX36SvXSUulhmEvnBTgsYxprr
         ZJfiEFZgh/10jhkf8wFpAk6uZ6grUuVEIryBcoa8=
Date:   Thu, 19 Jan 2023 14:34:24 -0800
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-update-monitoring-results-for-new-monitoring-attributes.patch added to mm-unstable branch
Message-Id: <20230119223424.BA97CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: update monitoring results for new monitoring attributes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-update-monitoring-results-for-new-monitoring-attributes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-update-monitoring-results-for-new-monitoring-attributes.patch

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
Subject: mm/damon/core: update monitoring results for new monitoring attributes
Date: Thu, 19 Jan 2023 01:38:30 +0000

region->nr_accesses is the number of sampling intervals in the last
aggregation interval that access to the region has found, and region->age
is the number of aggregation intervals that its access pattern has
maintained.  Hence, the real meaning of the two fields' values is
depending on current sampling and aggregation intervals.

This means the values need to be updated for every sampling and/or
aggregation intervals updates.  As DAMON core doesn't, it is a duty of
in-kernel DAMON framework applications like DAMON sysfs interface, or the
userspace users.

Handling it in userspace or in-kernel DAMON application is complicated,
inefficient, and repetitive compared to doing the update in DAMON core. 
Do the update in DAMON core.

Link: https://lkml.kernel.org/r/20230119013831.1911-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/core.c~mm-damon-core-update-monitoring-results-for-new-monitoring-attributes
+++ a/mm/damon/core.c
@@ -465,6 +465,76 @@ void damon_destroy_ctx(struct damon_ctx
 	kfree(ctx);
 }
 
+static unsigned int damon_age_for_new_attrs(unsigned int age,
+		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
+{
+	return age * old_attrs->aggr_interval / new_attrs->aggr_interval;
+}
+
+/* convert access ratio in bp (per 10,000) to nr_accesses */
+static unsigned int damon_accesses_bp_to_nr_accesses(
+		unsigned int accesses_bp, struct damon_attrs *attrs)
+{
+	unsigned int max_nr_accesses =
+		attrs->aggr_interval / attrs->sample_interval;
+
+	return accesses_bp * max_nr_accesses / 10000;
+}
+
+/* convert nr_accesses to access ratio in bp (per 10,000) */
+static unsigned int damon_nr_accesses_to_accesses_bp(
+		unsigned int nr_accesses, struct damon_attrs *attrs)
+{
+	unsigned int max_nr_accesses =
+		attrs->aggr_interval / attrs->sample_interval;
+
+	return nr_accesses * 10000 / max_nr_accesses;
+}
+
+static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
+		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
+{
+	return damon_accesses_bp_to_nr_accesses(
+			damon_nr_accesses_to_accesses_bp(
+				nr_accesses, old_attrs),
+			new_attrs);
+}
+
+static void damon_update_monitoring_result(struct damon_region *r,
+		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
+{
+	r->nr_accesses = damon_nr_accesses_for_new_attrs(r->nr_accesses,
+			old_attrs, new_attrs);
+	r->age = damon_age_for_new_attrs(r->age, old_attrs, new_attrs);
+}
+
+/*
+ * region->nr_accesses is the number of sampling intervals in the last
+ * aggregation interval that access to the region has found, and region->age is
+ * the number of aggregation intervals that its access pattern has maintained.
+ * For the reason, the real meaning of the two fields depend on current
+ * sampling interval and aggregation interval.  This function updates
+ * ->nr_accesses and ->age of given damon_ctx's regions for new damon_attrs.
+ */
+static void damon_update_monitoring_results(struct damon_ctx *ctx,
+		struct damon_attrs *new_attrs)
+{
+	struct damon_attrs *old_attrs = &ctx->attrs;
+	struct damon_target *t;
+	struct damon_region *r;
+
+	/* if any interval is zero, simply forgive conversion */
+	if (!old_attrs->sample_interval || !old_attrs->aggr_interval ||
+			!new_attrs->sample_interval ||
+			!new_attrs->aggr_interval)
+		return;
+
+	damon_for_each_target(t, ctx)
+		damon_for_each_region(r, t)
+			damon_update_monitoring_result(
+					r, old_attrs, new_attrs);
+}
+
 /**
  * damon_set_attrs() - Set attributes for the monitoring.
  * @ctx:		monitoring context
@@ -482,6 +552,7 @@ int damon_set_attrs(struct damon_ctx *ct
 	if (attrs->min_nr_regions > attrs->max_nr_regions)
 		return -EINVAL;
 
+	damon_update_monitoring_results(ctx, attrs);
 	ctx->attrs = *attrs;
 	return 0;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
mm-damon-update-comments-in-damonh-for-damon_attrs.patch
mm-damon-core-update-monitoring-results-for-new-monitoring-attributes.patch
mm-damon-core-test-add-a-test-for-damon_update_monitoring_results.patch
scripts-spelling-add-a-few-more-typos.patch

