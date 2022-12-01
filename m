Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC58C47089
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiLAABT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiLAAAp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FEE83EBC
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11B1CB81D84
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC90EC433D7;
        Thu,  1 Dec 2022 00:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852840;
        bh=UMC4qvuQabeEcc+ojlMRuNXne4/u6jtq8up1GbYNlbY=;
        h=Date:To:From:Subject:From;
        b=GpiZO4KSdCJAfJ6W/mZ0oVRW298ao5sG7xl1jQBNaWwlC+HgWf4jInmy/OZLD7q2N
         W9dQpPynNVIUgYML03Dt9I5Ug4Nign0LAzr+j7D/0zgzLbeEKoNPotsulFduMlEjvP
         sc5hNtBeLM+I/AYQcRCEIrdxBljveHn64dIOV4R0=
Date:   Wed, 30 Nov 2022 16:00:40 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch removed from -mm tree
Message-Id: <20221201000040.AC90EC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: implement DAMOS-tried regions clear command
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[sj@kernel.org: skip regions clearing if the scheme directory was removed]
  Link: https://lkml.kernel.org/r/20221114182954.4745-3-sj@kernel.org
Link: https://lkml.kernel.org/r/20221101220328.95765-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    4 ++++
 mm/damon/sysfs-schemes.c |   14 +++++++++++++-
 mm/damon/sysfs.c         |   20 ++++++++++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)

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
@@ -1292,7 +1292,7 @@ static int damon_sysfs_before_damos_appl
 }
 
 /* Called from damon_sysfs_cmd_request_callback under damon_sysfs_lock */
-int damon_sysfs_schemes_update_regions_start(
+int damon_sysfs_schemes_clear_regions(
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx)
 {
@@ -1302,11 +1302,23 @@ int damon_sysfs_schemes_update_regions_s
 	damon_for_each_scheme(scheme, ctx) {
 		struct damon_sysfs_scheme *sysfs_scheme;
 
+		/* user could have removed the scheme sysfs dir */
+		if (schemes_idx >= sysfs_schemes->nr)
+			break;
+
 		sysfs_scheme = sysfs_schemes->schemes_arr[schemes_idx++];
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


