Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1E1C001E0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 21:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbjHBVrv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 17:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbjHBVr0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 17:47:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AF93C1E
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 14:46:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9002D61B3B
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 21:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D9EC433C8;
        Wed,  2 Aug 2023 21:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691012806;
        bh=xkomfD6zeavUEPoHIS1Y8s7aBeatYpfA8O4GBpc+2do=;
        h=Date:To:From:Subject:From;
        b=jdl6l8YU8ibfScPC7AZEZtsiO8x39tgjwSreL2CN7wqeVdj7GEVmAVLh+PWhk+aRb
         /uqqtUYHxz9O2neaqPvsjUIr+UzirfgyfwboCdyHjpeUKJ5/e7kybm5lZ9hrJK93Hk
         COg69oo8tISkBbNrYNi5SWP5m0Y+2uvJhmbmTGqU=
Date:   Wed, 02 Aug 2023 14:46:45 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-implement-a-command-for-updating-only-schemes-tried-total-bytes.patch added to mm-unstable branch
Message-Id: <20230802214645.E4D9EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: implement a command for updating only schemes tried total bytes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-implement-a-command-for-updating-only-schemes-tried-total-bytes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-implement-a-command-for-updating-only-schemes-tried-total-bytes.patch

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
Subject: mm/damon/sysfs: implement a command for updating only schemes tried total bytes
Date: Wed, 2 Aug 2023 21:32:18 +0000

Using tried_regions/total_bytes file, users can efficiently retrieve the
total size of memory regions having specific access pattern.  However,
DAMON sysfs interface in kernel still populates all the infomration on the
tried_regions subdirectories.  That means the kernel part overhead for the
construction of tried regions directories still exists.  To remove the
overhead, implement yet another command input for 'state' DAMON sysfs
file.  Writing the input to the file makes DAMON sysfs interface to update
only the total_bytes file.

Link: https://lkml.kernel.org/r/20230802213222.109841-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    2 +-
 mm/damon/sysfs-schemes.c |    7 ++++++-
 mm/damon/sysfs.c         |   26 ++++++++++++++++++++------
 3 files changed, 27 insertions(+), 8 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-a-command-for-updating-only-schemes-tried-total-bytes
+++ a/mm/damon/sysfs.c
@@ -1000,6 +1000,11 @@ enum damon_sysfs_cmd {
 	 */
 	DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS,
 	/*
+	 * @DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_BYTES: Update
+	 * tried_regions/total_bytes sysfs files for each scheme.
+	 */
+	DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_BYTES,
+	/*
 	 * @DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS: Update schemes tried
 	 * regions
 	 */
@@ -1021,6 +1026,7 @@ static const char * const damon_sysfs_cm
 	"off",
 	"commit",
 	"update_schemes_stats",
+	"update_schemes_tried_bytes",
 	"update_schemes_tried_regions",
 	"clear_schemes_tried_regions",
 };
@@ -1206,12 +1212,14 @@ static void damon_sysfs_before_terminate
 {
 	struct damon_target *t, *next;
 	struct damon_sysfs_kdamond *kdamond;
+	enum damon_sysfs_cmd cmd;
 
 	/* damon_sysfs_schemes_update_regions_stop() might not yet called */
 	kdamond = damon_sysfs_cmd_request.kdamond;
-	if (kdamond && damon_sysfs_cmd_request.cmd ==
-			DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS &&
-			ctx == kdamond->damon_ctx) {
+	cmd = damon_sysfs_cmd_request.cmd;
+	if (kdamond && ctx == kdamond->damon_ctx &&
+			(cmd == DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS ||
+			 cmd == DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_BYTES)) {
 		damon_sysfs_schemes_update_regions_stop(ctx);
 		mutex_unlock(&damon_sysfs_lock);
 	}
@@ -1248,14 +1256,15 @@ static int damon_sysfs_upd_schemes_stats
 }
 
 static int damon_sysfs_upd_schemes_regions_start(
-		struct damon_sysfs_kdamond *kdamond)
+		struct damon_sysfs_kdamond *kdamond, bool total_bytes_only)
 {
 	struct damon_ctx *ctx = kdamond->damon_ctx;
 
 	if (!ctx)
 		return -EINVAL;
 	return damon_sysfs_schemes_update_regions_start(
-			kdamond->contexts->contexts_arr[0]->schemes, ctx);
+			kdamond->contexts->contexts_arr[0]->schemes, ctx,
+			total_bytes_only);
 }
 
 static int damon_sysfs_upd_schemes_regions_stop(
@@ -1332,6 +1341,7 @@ static int damon_sysfs_cmd_request_callb
 {
 	struct damon_sysfs_kdamond *kdamond;
 	static bool damon_sysfs_schemes_regions_updating;
+	bool total_bytes_only = false;
 	int err = 0;
 
 	/* avoid deadlock due to concurrent state_store('off') */
@@ -1348,9 +1358,13 @@ static int damon_sysfs_cmd_request_callb
 	case DAMON_SYSFS_CMD_COMMIT:
 		err = damon_sysfs_commit_input(kdamond);
 		break;
+	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_BYTES:
+		total_bytes_only = true;
+		fallthrough;
 	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS:
 		if (!damon_sysfs_schemes_regions_updating) {
-			err = damon_sysfs_upd_schemes_regions_start(kdamond);
+			err = damon_sysfs_upd_schemes_regions_start(kdamond,
+					total_bytes_only);
 			if (!err) {
 				damon_sysfs_schemes_regions_updating = true;
 				goto keep_lock_out;
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-implement-a-command-for-updating-only-schemes-tried-total-bytes
+++ a/mm/damon/sysfs-common.h
@@ -47,7 +47,7 @@ void damon_sysfs_schemes_update_stats(
 
 int damon_sysfs_schemes_update_regions_start(
 		struct damon_sysfs_schemes *sysfs_schemes,
-		struct damon_ctx *ctx);
+		struct damon_ctx *ctx, bool total_bytes_only);
 
 int damon_sysfs_schemes_update_regions_stop(struct damon_ctx *ctx);
 
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-implement-a-command-for-updating-only-schemes-tried-total-bytes
+++ a/mm/damon/sysfs-schemes.c
@@ -1635,6 +1635,7 @@ void damon_sysfs_schemes_update_stats(
  */
 static struct damon_sysfs_schemes *damon_sysfs_schemes_for_damos_callback;
 static int damon_sysfs_schemes_region_idx;
+static bool damos_regions_upd_total_bytes_only;
 
 /*
  * DAMON callback that called before damos apply.  While this callback is
@@ -1664,6 +1665,9 @@ static int damon_sysfs_before_damos_appl
 
 	sysfs_regions = sysfs_schemes->schemes_arr[schemes_idx]->tried_regions;
 	sysfs_regions->total_bytes += r->ar.end - r->ar.start;
+	if (damos_regions_upd_total_bytes_only)
+		return 0;
+
 	region = damon_sysfs_scheme_region_alloc(r);
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
 	sysfs_regions->nr_regions++;
@@ -1702,10 +1706,11 @@ int damon_sysfs_schemes_clear_regions(
 /* Called from damon_sysfs_cmd_request_callback under damon_sysfs_lock */
 int damon_sysfs_schemes_update_regions_start(
 		struct damon_sysfs_schemes *sysfs_schemes,
-		struct damon_ctx *ctx)
+		struct damon_ctx *ctx, bool total_bytes_only)
 {
 	damon_sysfs_schemes_clear_regions(sysfs_schemes, ctx);
 	damon_sysfs_schemes_for_damos_callback = sysfs_schemes;
+	damos_regions_upd_total_bytes_only = total_bytes_only;
 	ctx->callback.before_damos_apply = damon_sysfs_before_damos_apply;
 	return 0;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damo_filter-list-from-damos_new_filter.patch
mm-damon-core-test-add-a-test-for-damos_new_filter.patch
mm-damon-sysfs-schemes-implement-damos-tried-total-bytes-file.patch
mm-damon-sysfs-implement-a-command-for-updating-only-schemes-tried-total-bytes.patch
selftests-damon-sysfs-test-tried_regions-total_bytes-file.patch
docs-abi-damon-update-for-tried_regions-total_bytes.patch
docs-admin-guide-mm-damon-usage-update-for-tried_regions-total_bytes.patch

