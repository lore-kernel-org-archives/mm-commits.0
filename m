Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9268FC636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjBCGmw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbjBCGld (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC884EEE
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2D8EB82986
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564F3C433D2;
        Fri,  3 Feb 2023 06:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406286;
        bh=VFXYbH8vATlrXk72LIz57HbzdIagxbCh3BqcOSbZOXM=;
        h=Date:To:From:Subject:From;
        b=HSKRdlp5OhNt22GbMGvGVfkneimj4WtDkQw5DKN+u//m9XmgMyaOVFwjEB2tPe10s
         62LUcc+rkaY6CQGO/fv4b/WyioS8GkcDEujIBK5XgmA55yO8HXyCrWcmR50VoLdnFt
         el/1M7oE4FCCCVs7YBOx1/eFM/baMbIqnwukEtVM=
Date:   Thu, 02 Feb 2023 22:38:05 -0800
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-update-monitoring-results-for-new-monitoring-attributes.patch removed from -mm tree
Message-Id: <20230203063806.564F3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: update monitoring results for new monitoring attributes
has been removed from the -mm tree.  Its filename was
     mm-damon-core-update-monitoring-results-for-new-monitoring-attributes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

scripts-spelling-add-a-few-more-typos.patch

