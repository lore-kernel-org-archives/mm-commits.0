Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB98C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442149AbjLGANq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442095AbjLGANd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5776D3
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:38 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51205C433C9;
        Thu,  7 Dec 2023 00:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908018;
        bh=jazxRliskDmzc1Drri43dvIbu3oMKjke07Ic+IoXtxs=;
        h=Date:To:From:Subject:From;
        b=rI95+Uc2od/4aErNzMwhLlmHG+sF9X/H2zzqIgSPpCLKZdNX3WGs146XOjnJAS52F
         yIH49NddSZQtyhzzel0+OV1PjPixMegkxa7E8/R7qZ1stAakhijG5gm/V8sHiTmSMb
         iXJmhz/JXveMVKkYb6W2sUSfxNcJc4FZynrZXDAM=
Date:   Wed, 06 Dec 2023 16:13:37 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-schemes-add-timeout-for-update_schemes_tried_regions.patch removed from -mm tree
Message-Id: <20231207001338.51205C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: add timeout for update_schemes_tried_regions
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-add-timeout-for-update_schemes_tried_regions.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: add timeout for update_schemes_tried_regions
Date: Fri, 24 Nov 2023 21:38:40 +0000

If a scheme is set to not applied to any monitoring target region for any
reasons including the target access pattern, quota, filters, or
watermarks, writing 'update_schemes_tried_regions' to 'state' DAMON sysfs
file can indefinitely hang.  Fix the case by implementing a timeout for
the operation.  The time limit is two apply intervals of each scheme.

Link: https://lkml.kernel.org/r/20231124213840.39157-1-sj@kernel.org
Fixes: 4d4e41b68299 ("mm/damon/sysfs-schemes: do not update tried regions more than one DAMON snapshot")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   49 ++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 6 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-add-timeout-for-update_schemes_tried_regions
+++ a/mm/damon/sysfs-schemes.c
@@ -139,6 +139,13 @@ static const struct kobj_type damon_sysf
  * damon_sysfs_before_damos_apply() understands the situation by showing the
  * 'finished' status and do nothing.
  *
+ * If DAMOS is not applied to any region due to any reasons including the
+ * access pattern, the watermarks, the quotas, and the filters,
+ * ->before_damos_apply() will not be called back.  Until the situation is
+ * changed, the update will not be finished.  To avoid this,
+ * damon_sysfs_after_sampling() set the status as 'finished' if more than two
+ * apply intervals of the scheme is passed while the state is 'idle'.
+ *
  *  Finally, the tried regions request handling finisher function
  *  (damon_sysfs_schemes_update_regions_stop()) unregisters the callbacks.
  */
@@ -154,6 +161,7 @@ struct damon_sysfs_scheme_regions {
 	int nr_regions;
 	unsigned long total_bytes;
 	enum damos_sysfs_regions_upd_status upd_status;
+	unsigned long upd_timeout_jiffies;
 };
 
 static struct damon_sysfs_scheme_regions *
@@ -1854,7 +1862,9 @@ static int damon_sysfs_after_sampling(st
 	for (i = 0; i < sysfs_schemes->nr; i++) {
 		sysfs_regions = sysfs_schemes->schemes_arr[i]->tried_regions;
 		if (sysfs_regions->upd_status ==
-				DAMOS_TRIED_REGIONS_UPD_STARTED)
+				DAMOS_TRIED_REGIONS_UPD_STARTED ||
+				time_after(jiffies,
+					sysfs_regions->upd_timeout_jiffies))
 			sysfs_regions->upd_status =
 				DAMOS_TRIED_REGIONS_UPD_FINISHED;
 	}
@@ -1885,14 +1895,41 @@ int damon_sysfs_schemes_clear_regions(
 	return 0;
 }
 
+static struct damos *damos_sysfs_nth_scheme(int n, struct damon_ctx *ctx)
+{
+	struct damos *scheme;
+	int i = 0;
+
+	damon_for_each_scheme(scheme, ctx) {
+		if (i == n)
+			return scheme;
+		i++;
+	}
+	return NULL;
+}
+
 static void damos_tried_regions_init_upd_status(
-		struct damon_sysfs_schemes *sysfs_schemes)
+		struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx)
 {
 	int i;
+	struct damos *scheme;
+	struct damon_sysfs_scheme_regions *sysfs_regions;
 
-	for (i = 0; i < sysfs_schemes->nr; i++)
-		sysfs_schemes->schemes_arr[i]->tried_regions->upd_status =
-			DAMOS_TRIED_REGIONS_UPD_IDLE;
+	for (i = 0; i < sysfs_schemes->nr; i++) {
+		sysfs_regions = sysfs_schemes->schemes_arr[i]->tried_regions;
+		scheme = damos_sysfs_nth_scheme(i, ctx);
+		if (!scheme) {
+			sysfs_regions->upd_status =
+				DAMOS_TRIED_REGIONS_UPD_FINISHED;
+			continue;
+		}
+		sysfs_regions->upd_status = DAMOS_TRIED_REGIONS_UPD_IDLE;
+		sysfs_regions->upd_timeout_jiffies = jiffies +
+			2 * usecs_to_jiffies(scheme->apply_interval_us ?
+					scheme->apply_interval_us :
+					ctx->attrs.sample_interval);
+	}
 }
 
 /* Called from damon_sysfs_cmd_request_callback under damon_sysfs_lock */
@@ -1902,7 +1939,7 @@ int damon_sysfs_schemes_update_regions_s
 {
 	damon_sysfs_schemes_clear_regions(sysfs_schemes, ctx);
 	damon_sysfs_schemes_for_damos_callback = sysfs_schemes;
-	damos_tried_regions_init_upd_status(sysfs_schemes);
+	damos_tried_regions_init_upd_status(sysfs_schemes, ctx);
 	damos_regions_upd_total_bytes_only = total_bytes_only;
 	ctx->callback.before_damos_apply = damon_sysfs_before_damos_apply;
 	ctx->callback.after_sampling = damon_sysfs_after_sampling;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-test-test-damon_split_region_ats-access-rate-copying.patch
mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning.patch
mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning-fix.patch
mm-damon-sysfs-schemes-implement-files-for-scheme-quota-goals-setup.patch
mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos.patch
mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit.patch
mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm.patch
selftests-damon-test-quota-goals-directory.patch
docs-mm-damon-design-document-damos-quota-auto-tuning.patch
docs-abi-damon-document-damos-quota-goals.patch
docs-admin-guide-mm-damon-usage-document-for-quota-goals.patch

