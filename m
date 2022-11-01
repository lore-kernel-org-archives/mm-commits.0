Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3AFC4332F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 22:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiKAW6y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Nov 2022 18:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiKAW6j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2022 18:58:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75A81101
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 15:58:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E88C61773
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 22:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B073DC433D6;
        Tue,  1 Nov 2022 22:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667343515;
        bh=ZTr7vyHtVTGFN+9nDOJcHcj/opkhxtuA5OGb+ZAZm3o=;
        h=Date:To:From:Subject:From;
        b=lLGtkLW4a8KXF1mYR8uAe8YX/O787Wo3gyAw09a04G0Ktlw+P5YK9LHj59WUD4/pT
         4VWIAMUC+ONUXkfXJErwCks7GQCvmGT8LtP1yZ50wsYcWicAxe0Ht/iI79W/rOeEiG
         OIOgqhSAvQMwvG1MMZSp511riKCjrSlmFju0Vr90=
Date:   Tue, 01 Nov 2022 15:58:35 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch added to mm-unstable branch
Message-Id: <20221101225835.B073DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: implement DAMOS-tried regions clear command
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch

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
Subject: mm/damon/sysfs-schemes: implement DAMOS-tried regions clear command
Date: Tue, 1 Nov 2022 22:03:25 +0000

When there are huge number of DAMON regions that specific scheme actions
are tried to be applied, directories and files under 'tried_regions'
scheme directory could waste some memory.  Add another special input
keyword ('clear_schemes_tried_regions') for 'state' file of each kdamond
sysfs directory that can be used for cleanup of the 'tried_regions'
sub-directories.

Link: https://lkml.kernel.org/r/20221101220328.95765-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    4 ++++
 mm/damon/sysfs-schemes.c |   10 +++++++++-
 mm/damon/sysfs.c         |   20 ++++++++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command
+++ a/mm/damon/sysfs.c
@@ -1005,6 +1005,11 @@ enum damon_sysfs_cmd {
 	 */
 	DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS,
 	/*
+	 * @DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS: Clear schemes tried
+	 * regions
+	 */
+	DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS,
+	/*
 	 * @NR_DAMON_SYSFS_CMDS: Total number of DAMON sysfs commands.
 	 */
 	NR_DAMON_SYSFS_CMDS,
@@ -1017,6 +1022,7 @@ static const char * const damon_sysfs_cm
 	"commit",
 	"update_schemes_stats",
 	"update_schemes_tried_regions",
+	"clear_schemes_tried_regions",
 };
 
 /*
@@ -1262,6 +1268,17 @@ static int damon_sysfs_upd_schemes_regio
 	return damon_sysfs_schemes_update_regions_stop(ctx);
 }
 
+static int damon_sysfs_clear_schemes_regions(
+		struct damon_sysfs_kdamond *kdamond)
+{
+	struct damon_ctx *ctx = kdamond->damon_ctx;
+
+	if (!ctx)
+		return -EINVAL;
+	return damon_sysfs_schemes_clear_regions(
+			kdamond->contexts->contexts_arr[0]->schemes, ctx);
+}
+
 static inline bool damon_sysfs_kdamond_running(
 		struct damon_sysfs_kdamond *kdamond)
 {
@@ -1343,6 +1360,9 @@ static int damon_sysfs_cmd_request_callb
 			damon_sysfs_schemes_regions_updating = false;
 		}
 		break;
+	case DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS:
+		err = damon_sysfs_clear_schemes_regions(kdamond);
+		break;
 	default:
 		break;
 	}
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command
+++ a/mm/damon/sysfs-common.h
@@ -50,3 +50,7 @@ int damon_sysfs_schemes_update_regions_s
 		struct damon_ctx *ctx);
 
 int damon_sysfs_schemes_update_regions_stop(struct damon_ctx *ctx);
+
+int damon_sysfs_schemes_clear_regions(
+		struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx);
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command
+++ a/mm/damon/sysfs-schemes.c
@@ -1241,7 +1241,7 @@ static int damon_sysfs_before_damos_appl
 }
 
 /* Called from damon_sysfs_cmd_request_callback under damon_sysfs_lock */
-int damon_sysfs_schemes_update_regions_start(
+int damon_sysfs_schemes_clear_regions(
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx)
 {
@@ -1255,7 +1255,15 @@ int damon_sysfs_schemes_update_regions_s
 		damon_sysfs_scheme_regions_rm_dirs(
 				sysfs_scheme->tried_regions);
 	}
+	return 0;
+}
 
+/* Called from damon_sysfs_cmd_request_callback under damon_sysfs_lock */
+int damon_sysfs_schemes_update_regions_start(
+		struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx)
+{
+	damon_sysfs_schemes_clear_regions(sysfs_schemes, ctx);
 	damon_sysfs_schemes_for_damos_callback = sysfs_schemes;
 	ctx->callback.before_damos_apply = damon_sysfs_before_damos_apply;
 	return 0;
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

