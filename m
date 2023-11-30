Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB922C4167B
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 22:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377163AbjK3WXW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 17:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377147AbjK3WXO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 17:23:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC6910DF
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 14:23:20 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27877C433C7;
        Thu, 30 Nov 2023 22:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701383000;
        bh=UEnxvCks/yquTDY2IFo/YXwQM6ajdMlro1Io4PTGOgw=;
        h=Date:To:From:Subject:From;
        b=gk8gLRpJmF4kGJOmfuQkFV1Ny9cCDheZtmco/D95IHEAq9Ld/MEqLEFvc5STo6z3v
         QSM0UDVCNujNFHPCOWZ6gicBgHwI+50/Jubs3Rvaxf1v7oqMMfNRo8EcA/DkAJ0tt2
         G9nm3zkKjsoKY2E9mudcdBuxvoYKcMGF305mIEBk=
Date:   Thu, 30 Nov 2023 14:23:19 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, davidgow@google.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit.patch added to mm-unstable branch
Message-Id: <20231130222320.27877C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: implement a command for scheme quota goals only commit
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit.patch

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
Subject: mm/damon/sysfs-schemes: implement a command for scheme quota goals only commit
Date: Thu, 30 Nov 2023 02:36:47 +0000

To update DAMOS quota goals, users need to enter 'commit' command to the
'state' file of the kdamond, which applies not only the goals but entire
inputs.  It is inefficient.  Implement yet another 'state' file input
command for reading and committing only the scheme quota goals, namely
'commit_schemes_quota_goals'.

Link: https://lkml.kernel.org/r/20231130023652.50284-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    3 +++
 mm/damon/sysfs-schemes.c |   16 ++++++++++++++++
 mm/damon/sysfs.c         |   27 +++++++++++++++++++++++++++
 3 files changed, 46 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit
+++ a/mm/damon/sysfs.c
@@ -995,6 +995,11 @@ enum damon_sysfs_cmd {
 	/* @DAMON_SYSFS_CMD_COMMIT: Update kdamond inputs. */
 	DAMON_SYSFS_CMD_COMMIT,
 	/*
+	 * @DAMON_SYSFS_CMD_COMMIT_SCHEMES_QUOTA_GOALS: Commit the quota goals
+	 * to DAMON.
+	 */
+	DAMON_SYSFS_CMD_COMMIT_SCHEMES_QUOTA_GOALS,
+	/*
 	 * @DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS: Update scheme stats sysfs
 	 * files.
 	 */
@@ -1025,6 +1030,7 @@ static const char * const damon_sysfs_cm
 	"on",
 	"off",
 	"commit",
+	"commit_schemes_quota_goals",
 	"update_schemes_stats",
 	"update_schemes_tried_bytes",
 	"update_schemes_tried_regions",
@@ -1351,6 +1357,24 @@ static int damon_sysfs_commit_input(stru
 			kdamond->contexts->contexts_arr[0]);
 }
 
+static int damon_sysfs_commit_schemes_quota_goals(
+		struct damon_sysfs_kdamond *sysfs_kdamond)
+{
+	struct damon_ctx *ctx;
+	struct damon_sysfs_context *sysfs_ctx;
+
+	if (!damon_sysfs_kdamond_running(sysfs_kdamond))
+		return -EINVAL;
+	/* TODO: Support multiple contexts per kdamond */
+	if (sysfs_kdamond->contexts->nr != 1)
+		return -EINVAL;
+
+	ctx = sysfs_kdamond->damon_ctx;
+	sysfs_ctx = sysfs_kdamond->contexts->contexts_arr[0];
+	damos_sysfs_set_quota_scores(sysfs_ctx->schemes, ctx);
+	return 0;
+}
+
 /*
  * damon_sysfs_cmd_request_callback() - DAMON callback for handling requests.
  * @c:		The DAMON context of the callback.
@@ -1379,6 +1403,9 @@ static int damon_sysfs_cmd_request_callb
 	case DAMON_SYSFS_CMD_COMMIT:
 		err = damon_sysfs_commit_input(kdamond);
 		break;
+	case DAMON_SYSFS_CMD_COMMIT_SCHEMES_QUOTA_GOALS:
+		err = damon_sysfs_commit_schemes_quota_goals(kdamond);
+		break;
 	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_BYTES:
 		total_bytes_only = true;
 		fallthrough;
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit
+++ a/mm/damon/sysfs-common.h
@@ -56,3 +56,6 @@ int damon_sysfs_schemes_update_regions_s
 int damon_sysfs_schemes_clear_regions(
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx);
+
+void damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx);
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit
+++ a/mm/damon/sysfs-schemes.c
@@ -1896,6 +1896,22 @@ static void damos_sysfs_set_quota_score(
 	}
 }
 
+void damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx)
+{
+	struct damos *scheme;
+	int i = 0;
+
+	damon_for_each_scheme(scheme, ctx) {
+		struct damon_sysfs_scheme *sysfs_scheme;
+
+		sysfs_scheme = sysfs_schemes->schemes_arr[i];
+		damos_sysfs_set_quota_score(sysfs_scheme->quotas->goals,
+				&scheme->quota);
+		i++;
+	}
+}
+
 static struct damos *damon_sysfs_mk_scheme(
 		struct damon_sysfs_scheme *sysfs_scheme)
 {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-copy-nr_accesses-when-splitting-region.patch
mm-damon-sysfs-schemes-add-timeout-for-update_schemes_tried_regions.patch
mm-damon-core-test-test-damon_split_region_ats-access-rate-copying.patch
mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning.patch
mm-damon-sysfs-schemes-implement-files-for-scheme-quota-goals-setup.patch
mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos.patch
mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit.patch
mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm.patch
selftests-damon-test-quota-goals-directory.patch
docs-mm-damon-design-document-damos-quota-auto-tuning.patch
docs-abi-damon-document-damos-quota-goals.patch
docs-admin-guide-mm-damon-usage-document-for-quota-goals.patch

