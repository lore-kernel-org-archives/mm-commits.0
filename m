Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4108BCDB485
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 19:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbjJRTN0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 15:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbjJRTNW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 15:13:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BFD119;
        Wed, 18 Oct 2023 12:13:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E80C433CD;
        Wed, 18 Oct 2023 19:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697656400;
        bh=4c3TEHANLYyMJlSMjF1ER0bH+v65lmFoaKWNmKj3z0Q=;
        h=Date:To:From:Subject:From;
        b=GAnp5zUjLhYLXUE7vJgeTtSLfUNBaOSS3sWP5qCQ0jiPBBJntqnjZRFhN7ZOUB6a4
         r9P4qPrC0Z96nSBPHS2vfL0DHBRDrzSv6hLqcRkHPF7p1lqZviWievC9nrW24wrafx
         RGzgMkOwULFA+juy4mFE80LF35GOt7sNU2A4R2do=
Date:   Wed, 18 Oct 2023 12:13:19 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-check-damos-regions-update-progress-from-before_terminate.patch removed from -mm tree
Message-Id: <20231018191320.46E80C433CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: check DAMOS regions update progress from before_terminate()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-check-damos-regions-update-progress-from-before_terminate.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: check DAMOS regions update progress from before_terminate()
Date: Sat, 7 Oct 2023 20:04:32 +0000

DAMON_SYSFS can receive DAMOS tried regions update request while kdamond
is already out of the main loop and before_terminate callback
(damon_sysfs_before_terminate() in this case) is not yet called.  And
damon_sysfs_handle_cmd() can further be finished before the callback is
invoked.  Then, damon_sysfs_before_terminate() unlocks damon_sysfs_lock,
which is not locked by anyone.  This happens because the callback function
assumes damon_sysfs_cmd_request_callback() should be called before it. 
Check if the assumption was true before doing the unlock, to avoid this
problem.

Link: https://lkml.kernel.org/r/20231007200432.3110-1-sj@kernel.org
Fixes: f1d13cacabe1 ("mm/damon/sysfs: implement DAMOS tried regions update command")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.2.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-check-damos-regions-update-progress-from-before_terminate
+++ a/mm/damon/sysfs.c
@@ -1208,6 +1208,8 @@ static int damon_sysfs_set_targets(struc
 	return 0;
 }
 
+static bool damon_sysfs_schemes_regions_updating;
+
 static void damon_sysfs_before_terminate(struct damon_ctx *ctx)
 {
 	struct damon_target *t, *next;
@@ -1219,8 +1221,10 @@ static void damon_sysfs_before_terminate
 	cmd = damon_sysfs_cmd_request.cmd;
 	if (kdamond && ctx == kdamond->damon_ctx &&
 			(cmd == DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS ||
-			 cmd == DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_BYTES)) {
+			 cmd == DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_BYTES) &&
+			damon_sysfs_schemes_regions_updating) {
 		damon_sysfs_schemes_update_regions_stop(ctx);
+		damon_sysfs_schemes_regions_updating = false;
 		mutex_unlock(&damon_sysfs_lock);
 	}
 
@@ -1340,7 +1344,6 @@ static int damon_sysfs_commit_input(stru
 static int damon_sysfs_cmd_request_callback(struct damon_ctx *c)
 {
 	struct damon_sysfs_kdamond *kdamond;
-	static bool damon_sysfs_schemes_regions_updating;
 	bool total_bytes_only = false;
 	int err = 0;
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-do-not-update-tried-regions-more-than-one-damon-snapshot.patch
mm-damon-sysfs-avoid-empty-scheme-tried-regions-for-large-apply-interval.patch
docs-admin-guide-mm-damon-usage-update-for-tried-regions-update-time-interval.patch

