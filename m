Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA772CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbjJRVhq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbjJRVg6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4861BD
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:36:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A768C433C9;
        Wed, 18 Oct 2023 21:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664973;
        bh=Gj//YJMBAaS3QZ3XG0PUEMPOs+fYk5FcKvv12dPV0QM=;
        h=Date:To:From:Subject:From;
        b=vLCbMkHyo+XogdKEiV2eidna4JT3T+MnxcIGkurTjpPaw+Tf3mgSqSwzbUHUECjq2
         sjqW699V3asyVrgfRHMVfOYYulYC2WeN+c5gM0I3u9OUzD53JWVpuY6Gl1ssnP1DOr
         nLQr2VNaiHyjiD5GQtfYd1SX7MqNIBONOcMJV4Bw=
Date:   Wed, 18 Oct 2023 14:36:12 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-avoid-empty-scheme-tried-regions-for-large-apply-interval.patch removed from -mm tree
Message-Id: <20231018213613.5A768C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: avoid empty scheme tried regions for large apply interval
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-avoid-empty-scheme-tried-regions-for-large-apply-interval.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: avoid empty scheme tried regions for large apply interval
Date: Thu, 12 Oct 2023 19:22:54 +0000

DAMON_SYSFS assumes all schemes will be applied for at least one DAMON
monitoring results snapshot within one aggregation interval, or makes no
sense to wait for it while DAMON is deactivated by the watermarks.  That
for deactivated status still makes sense, but the aggregation interval
based assumption is invalid now because each scheme can has its own apply
interval.  For schemes having larger than the aggregation or watermarks
check interval, DAMOS tried regions update request can be finished without
the update.  Avoid the case by explicitly checking the status of the
schemes tried regions update and watermarks based DAMON deactivation.

Link: https://lkml.kernel.org/r/20231012192256.33556-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    2 ++
 mm/damon/sysfs-schemes.c |   16 ++++++++++++++++
 mm/damon/sysfs.c         |   34 ++++++++++++++++++++++++++++++----
 3 files changed, 48 insertions(+), 4 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-avoid-empty-scheme-tried-regions-for-large-apply-interval
+++ a/mm/damon/sysfs.c
@@ -1336,12 +1336,13 @@ static int damon_sysfs_commit_input(stru
 
 /*
  * damon_sysfs_cmd_request_callback() - DAMON callback for handling requests.
- * @c:	The DAMON context of the callback.
+ * @c:		The DAMON context of the callback.
+ * @active:	Whether @c is not deactivated due to watermarks.
  *
  * This function is periodically called back from the kdamond thread for @c.
  * Then, it checks if there is a waiting DAMON sysfs request and handles it.
  */
-static int damon_sysfs_cmd_request_callback(struct damon_ctx *c)
+static int damon_sysfs_cmd_request_callback(struct damon_ctx *c, bool active)
 {
 	struct damon_sysfs_kdamond *kdamond;
 	bool total_bytes_only = false;
@@ -1373,6 +1374,13 @@ static int damon_sysfs_cmd_request_callb
 				goto keep_lock_out;
 			}
 		} else {
+			/*
+			 * Continue regions updating if DAMON is till
+			 * active and the update for all schemes is not
+			 * finished.
+			 */
+			if (active && !damos_sysfs_regions_upd_done())
+				goto keep_lock_out;
 			err = damon_sysfs_upd_schemes_regions_stop(kdamond);
 			damon_sysfs_schemes_regions_updating = false;
 		}
@@ -1392,6 +1400,24 @@ keep_lock_out:
 	return err;
 }
 
+static int damon_sysfs_after_wmarks_check(struct damon_ctx *c)
+{
+	/*
+	 * after_wmarks_check() is called back while the context is deactivated
+	 * by watermarks.
+	 */
+	return damon_sysfs_cmd_request_callback(c, false);
+}
+
+static int damon_sysfs_after_aggregation(struct damon_ctx *c)
+{
+	/*
+	 * after_aggregation() is called back only while the context is not
+	 * deactivated by watermarks.
+	 */
+	return damon_sysfs_cmd_request_callback(c, true);
+}
+
 static struct damon_ctx *damon_sysfs_build_ctx(
 		struct damon_sysfs_context *sys_ctx)
 {
@@ -1407,8 +1433,8 @@ static struct damon_ctx *damon_sysfs_bui
 		return ERR_PTR(err);
 	}
 
-	ctx->callback.after_wmarks_check = damon_sysfs_cmd_request_callback;
-	ctx->callback.after_aggregation = damon_sysfs_cmd_request_callback;
+	ctx->callback.after_wmarks_check = damon_sysfs_after_wmarks_check;
+	ctx->callback.after_aggregation = damon_sysfs_after_aggregation;
 	ctx->callback.before_terminate = damon_sysfs_before_terminate;
 	return ctx;
 }
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-avoid-empty-scheme-tried-regions-for-large-apply-interval
+++ a/mm/damon/sysfs-common.h
@@ -49,6 +49,8 @@ int damon_sysfs_schemes_update_regions_s
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx, bool total_bytes_only);
 
+bool damos_sysfs_regions_upd_done(void);
+
 int damon_sysfs_schemes_update_regions_stop(struct damon_ctx *ctx);
 
 int damon_sysfs_schemes_clear_regions(
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-avoid-empty-scheme-tried-regions-for-large-apply-interval
+++ a/mm/damon/sysfs-schemes.c
@@ -1904,6 +1904,22 @@ int damon_sysfs_schemes_update_regions_s
 	return 0;
 }
 
+bool damos_sysfs_regions_upd_done(void)
+{
+	struct damon_sysfs_schemes *sysfs_schemes =
+		damon_sysfs_schemes_for_damos_callback;
+	struct damon_sysfs_scheme_regions *sysfs_regions;
+	int i;
+
+	for (i = 0; i < sysfs_schemes->nr; i++) {
+		sysfs_regions = sysfs_schemes->schemes_arr[i]->tried_regions;
+		if (sysfs_regions->upd_status !=
+				DAMOS_TRIED_REGIONS_UPD_FINISHED)
+			return false;
+	}
+	return true;
+}
+
 /*
  * Called from damon_sysfs_cmd_request_callback under damon_sysfs_lock.  Caller
  * should unlock damon_sysfs_lock which held before
_

Patches currently in -mm which might be from sj@kernel.org are


