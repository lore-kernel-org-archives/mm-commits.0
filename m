Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92AFC352A1
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiK3XCX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiK3XCH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:02:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C78A94566
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:02:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6B38B81D4F
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981ADC433C1;
        Wed, 30 Nov 2022 23:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669849323;
        bh=uEj3Sc2QcCTZWPk0SEIGtFKonPUrnam4BpAymmMEnv8=;
        h=Date:To:From:Subject:From;
        b=vtcM6uCku6z+/fGaXG5AdCXQhSNMRg+aCWVBVm4/jsGdGvvwQZN/casSGN6dZBoZz
         XaVXunVG2zly8mGhcXgc+02QBwavgD9sJnPOCB5J9LDVLb7yX+49OwEBiw8MxUJF0l
         sIHl3Mb+hq5E7qgAvQA/YUYdAQHEjH3ICvLDnqQ8=
Date:   Wed, 30 Nov 2022 15:02:02 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch removed from -mm tree
Message-Id: <20221130230203.981ADC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: split out kdamond-independent schemes stats update logic into a new function
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: split out kdamond-independent schemes stats update logic into a new function
Date: Wed, 26 Oct 2022 22:59:40 +0000

'damon_sysfs_schemes_update_stats()' is coupled with both
damon_sysfs_kdamond and damon_sysfs_schemes.  It's a wide range of types
dependency.  It makes splitting the logics a little bit distracting. 
Split the function so that each function is coupled with smaller range of
types.

Link: https://lkml.kernel.org/r/20221026225943.100429-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function
+++ a/mm/damon/sysfs.c
@@ -2246,25 +2246,13 @@ static void damon_sysfs_before_terminate
 	mutex_unlock(&ctx->kdamond_lock);
 }
 
-/*
- * damon_sysfs_upd_schemes_stats() - Update schemes stats sysfs files.
- * @kdamond:	The kobject wrapper that associated to the kdamond thread.
- *
- * This function reads the schemes stats of specific kdamond and update the
- * related values for sysfs files.  This function should be called from DAMON
- * callbacks while holding ``damon_syfs_lock``, to safely access the DAMON
- * contexts-internal data and DAMON sysfs variables.
- */
-static int damon_sysfs_upd_schemes_stats(struct damon_sysfs_kdamond *kdamond)
+static void damon_sysfs_schemes_update_stats(
+		struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx)
 {
-	struct damon_ctx *ctx = kdamond->damon_ctx;
-	struct damon_sysfs_schemes *sysfs_schemes;
 	struct damos *scheme;
 	int schemes_idx = 0;
 
-	if (!ctx)
-		return -EINVAL;
-	sysfs_schemes = kdamond->contexts->contexts_arr[0]->schemes;
 	damon_for_each_scheme(scheme, ctx) {
 		struct damon_sysfs_stats *sysfs_stats;
 
@@ -2279,6 +2267,25 @@ static int damon_sysfs_upd_schemes_stats
 		sysfs_stats->sz_applied = scheme->stat.sz_applied;
 		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
 	}
+}
+
+/*
+ * damon_sysfs_upd_schemes_stats() - Update schemes stats sysfs files.
+ * @kdamond:	The kobject wrapper that associated to the kdamond thread.
+ *
+ * This function reads the schemes stats of specific kdamond and update the
+ * related values for sysfs files.  This function should be called from DAMON
+ * callbacks while holding ``damon_syfs_lock``, to safely access the DAMON
+ * contexts-internal data and DAMON sysfs variables.
+ */
+static int damon_sysfs_upd_schemes_stats(struct damon_sysfs_kdamond *kdamond)
+{
+	struct damon_ctx *ctx = kdamond->damon_ctx;
+
+	if (!ctx)
+		return -EINVAL;
+	damon_sysfs_schemes_update_stats(
+			kdamond->contexts->contexts_arr[0]->schemes, ctx);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command-fix.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command-fix.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

