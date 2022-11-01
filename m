Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798BEC43217
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 22:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiKAW6j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Nov 2022 18:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiKAW6g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2022 18:58:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5C6FFB
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 15:58:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2604361774
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 22:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B776C433C1;
        Tue,  1 Nov 2022 22:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667343513;
        bh=8tQsLZ7Na3gJdy+R0/AwuOsNIc3A26vPUSdqwz9kSxU=;
        h=Date:To:From:Subject:From;
        b=cwf9FL7qvXRKg1LmlxFk14+TOR4Kupm4Zbidtai/rlwW2e3cKGsZf1nKWHxj1rbq+
         2V+5mZ4CnlgZNnPfie4iCpSYaMKFpGkcl2aS5Uy3SUbWRBU1KL7Vj4wouvdiWT1nSg
         OoLyKkPizO4nzesT+kqm/Il+7ta5Q+mTKV1qPbPE=
Date:   Tue, 01 Nov 2022 15:58:32 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-implement-damos-tried-regions-update-command.patch added to mm-unstable branch
Message-Id: <20221101225833.7B776C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: implement DAMOS tried regions update command
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-implement-damos-tried-regions-update-command.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-implement-damos-tried-regions-update-command.patch

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
Subject: mm/damon/sysfs: implement DAMOS tried regions update command
Date: Tue, 1 Nov 2022 22:03:24 +0000

Implement the code for filling the data of 'tried_regions' DAMON sysfs
directory.  With this commit, DAMON sysfs interface users can write a
special keyword, 'update_schemes_tried_regions' to the corresponding
'state' file of the kdamond.  Then, DAMON sysfs interface will collect the
tried regions information using the 'before_damos_apply()' callback for
one aggregation interval and populate scheme region directories with the
values.

Link: https://lkml.kernel.org/r/20221101220328.95765-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    6 ++
 mm/damon/sysfs-schemes.c |   75 +++++++++++++++++++++++++++++++++++++
 mm/damon/sysfs.c         |   57 +++++++++++++++++++++++++++-
 3 files changed, 136 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-damos-tried-regions-update-command
+++ a/mm/damon/sysfs.c
@@ -1000,6 +1000,11 @@ enum damon_sysfs_cmd {
 	 */
 	DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS,
 	/*
+	 * @DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS: Update schemes tried
+	 * regions
+	 */
+	DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS,
+	/*
 	 * @NR_DAMON_SYSFS_CMDS: Total number of DAMON sysfs commands.
 	 */
 	NR_DAMON_SYSFS_CMDS,
@@ -1011,6 +1016,7 @@ static const char * const damon_sysfs_cm
 	"off",
 	"commit",
 	"update_schemes_stats",
+	"update_schemes_tried_regions",
 };
 
 /*
@@ -1193,6 +1199,16 @@ static int damon_sysfs_set_targets(struc
 static void damon_sysfs_before_terminate(struct damon_ctx *ctx)
 {
 	struct damon_target *t, *next;
+	struct damon_sysfs_kdamond *kdamond;
+
+	/* damon_sysfs_schemes_update_regions_stop() might not yet called */
+	kdamond = damon_sysfs_cmd_request.kdamond;
+	if (kdamond && damon_sysfs_cmd_request.cmd ==
+			DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS &&
+			ctx == kdamond->damon_ctx) {
+		damon_sysfs_schemes_update_regions_stop(ctx);
+		mutex_unlock(&damon_sysfs_lock);
+	}
 
 	if (!damon_target_has_pid(ctx))
 		return;
@@ -1225,6 +1241,27 @@ static int damon_sysfs_upd_schemes_stats
 	return 0;
 }
 
+static int damon_sysfs_upd_schemes_regions_start(
+		struct damon_sysfs_kdamond *kdamond)
+{
+	struct damon_ctx *ctx = kdamond->damon_ctx;
+
+	if (!ctx)
+		return -EINVAL;
+	return damon_sysfs_schemes_update_regions_start(
+			kdamond->contexts->contexts_arr[0]->schemes, ctx);
+}
+
+static int damon_sysfs_upd_schemes_regions_stop(
+		struct damon_sysfs_kdamond *kdamond)
+{
+	struct damon_ctx *ctx = kdamond->damon_ctx;
+
+	if (!ctx)
+		return -EINVAL;
+	return damon_sysfs_schemes_update_regions_stop(ctx);
+}
+
 static inline bool damon_sysfs_kdamond_running(
 		struct damon_sysfs_kdamond *kdamond)
 {
@@ -1277,10 +1314,12 @@ static int damon_sysfs_commit_input(stru
 static int damon_sysfs_cmd_request_callback(struct damon_ctx *c)
 {
 	struct damon_sysfs_kdamond *kdamond;
+	static bool damon_sysfs_schemes_regions_updating;
 	int err = 0;
 
 	/* avoid deadlock due to concurrent state_store('off') */
-	if (!mutex_trylock(&damon_sysfs_lock))
+	if (!damon_sysfs_schemes_regions_updating &&
+			!mutex_trylock(&damon_sysfs_lock))
 		return 0;
 	kdamond = damon_sysfs_cmd_request.kdamond;
 	if (!kdamond || kdamond->damon_ctx != c)
@@ -1292,13 +1331,27 @@ static int damon_sysfs_cmd_request_callb
 	case DAMON_SYSFS_CMD_COMMIT:
 		err = damon_sysfs_commit_input(kdamond);
 		break;
+	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS:
+		if (!damon_sysfs_schemes_regions_updating) {
+			err = damon_sysfs_upd_schemes_regions_start(kdamond);
+			if (!err) {
+				damon_sysfs_schemes_regions_updating = true;
+				goto keep_lock_out;
+			}
+		} else {
+			err = damon_sysfs_upd_schemes_regions_stop(kdamond);
+			damon_sysfs_schemes_regions_updating = false;
+		}
+		break;
 	default:
 		break;
 	}
 	/* Mark the request as invalid now. */
 	damon_sysfs_cmd_request.kdamond = NULL;
 out:
-	mutex_unlock(&damon_sysfs_lock);
+	if (!damon_sysfs_schemes_regions_updating)
+		mutex_unlock(&damon_sysfs_lock);
+keep_lock_out:
 	return err;
 }
 
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-implement-damos-tried-regions-update-command
+++ a/mm/damon/sysfs-common.h
@@ -44,3 +44,9 @@ int damon_sysfs_set_schemes(struct damon
 void damon_sysfs_schemes_update_stats(
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx);
+
+int damon_sysfs_schemes_update_regions_start(
+		struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx);
+
+int damon_sysfs_schemes_update_regions_stop(struct damon_ctx *ctx);
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-implement-damos-tried-regions-update-command
+++ a/mm/damon/sysfs-schemes.c
@@ -1198,3 +1198,78 @@ void damon_sysfs_schemes_update_stats(
 		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
 	}
 }
+
+/*
+ * damon_sysfs_schemes that need to update its schemes regions dir.  Protected
+ * by damon_sysfs_lock
+ */
+static struct damon_sysfs_schemes *damon_sysfs_schemes_for_damos_callback;
+static int damon_sysfs_schemes_region_idx;
+
+/*
+ * DAMON callback that called before damos apply.  While this callback is
+ * registered, damon_sysfs_lock should be held to ensure the regions
+ * directories exist.
+ */
+static int damon_sysfs_before_damos_apply(struct damon_ctx *ctx,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *s)
+{
+	struct damos *scheme;
+	struct damon_sysfs_scheme_regions *sysfs_regions;
+	struct damon_sysfs_scheme_region *region;
+	struct damon_sysfs_schemes *sysfs_schemes =
+		damon_sysfs_schemes_for_damos_callback;
+	int schemes_idx = 0;
+
+	damon_for_each_scheme(scheme, ctx) {
+		if (scheme == s)
+			break;
+		schemes_idx++;
+	}
+	sysfs_regions = sysfs_schemes->schemes_arr[schemes_idx]->tried_regions;
+	region = damon_sysfs_scheme_region_alloc(r);
+	list_add_tail(&region->list, &sysfs_regions->regions_list);
+	sysfs_regions->nr_regions++;
+	if (kobject_init_and_add(&region->kobj,
+				&damon_sysfs_scheme_region_ktype,
+				&sysfs_regions->kobj, "%d",
+				damon_sysfs_schemes_region_idx++)) {
+		kobject_put(&region->kobj);
+	}
+	return 0;
+}
+
+/* Called from damon_sysfs_cmd_request_callback under damon_sysfs_lock */
+int damon_sysfs_schemes_update_regions_start(
+		struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx)
+{
+	struct damos *scheme;
+	int schemes_idx = 0;
+
+	damon_for_each_scheme(scheme, ctx) {
+		struct damon_sysfs_scheme *sysfs_scheme;
+
+		sysfs_scheme = sysfs_schemes->schemes_arr[schemes_idx++];
+		damon_sysfs_scheme_regions_rm_dirs(
+				sysfs_scheme->tried_regions);
+	}
+
+	damon_sysfs_schemes_for_damos_callback = sysfs_schemes;
+	ctx->callback.before_damos_apply = damon_sysfs_before_damos_apply;
+	return 0;
+}
+
+/*
+ * Called from damon_sysfs_cmd_request_callback under damon_sysfs_lock.  Caller
+ * should unlock damon_sysfs_lock which held before
+ * damon_sysfs_schemes_update_regions_start()
+ */
+int damon_sysfs_schemes_update_regions_stop(struct damon_ctx *ctx)
+{
+	damon_sysfs_schemes_for_damos_callback = NULL;
+	ctx->callback.before_damos_apply = NULL;
+	damon_sysfs_schemes_region_idx = 0;
+	return 0;
+}
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
mm-damon-sysfs-split-out-schemes-directory-implementation-to-separate-file.patch
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch
mm-damon-reclaim-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch
mm-damon-lru_sort-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter.patch
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

