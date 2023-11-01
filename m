Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB17BC001B5
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345943AbjKATjU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345945AbjKATjR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:39:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4BE10F;
        Wed,  1 Nov 2023 12:39:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C122C43391;
        Wed,  1 Nov 2023 19:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698867549;
        bh=x5igLu//8esRL7CVAC+CciwwV3qsiVqX+yA/TNznEZg=;
        h=Date:To:From:Subject:From;
        b=NnCLgJNZRftlCoftJXV/695kWXye7E2cTQKnCvuMJEFXnAW2wFYl8tY6zH8xbvNSK
         FeM3cXGbvyP2WAkcDzpyCMz0EHUBdunUx+WZ/DsgILejc0miwCh4I91INJZ8dYQtR/
         3F8vasbv8iOR+Zdw9D8EcaDO4sk0rXa6TPVgqG7g=
Date:   Wed, 01 Nov 2023 12:39:07 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-update-monitoring-target-regions-for-online-input-commit.patch removed from -mm tree
Message-Id: <20231101193909.8C122C43391@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: update monitoring target regions for online input commit
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-update-monitoring-target-regions-for-online-input-commit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: update monitoring target regions for online input commit
Date: Tue, 31 Oct 2023 17:01:31 +0000

When user input is committed online, DAMON sysfs interface is ignoring the
user input for the monitoring target regions.  Such request is valid and
useful for fixed monitoring target regions-based monitoring ops like
'paddr' or 'fvaddr'.

Update the region boundaries as user specified, too.  Note that the
monitoring results of the regions that overlap between the latest
monitoring target regions and the new target regions are preserved.

Treat empty monitoring target regions user request as a request to just
make no change to the monitoring target regions.  Otherwise, users should
set the monitoring target regions same to current one for every online
input commit, and it could be challenging for dynamic monitoring target
regions update DAMON ops like 'vaddr'.  If the user really need to remove
all monitoring target regions, they can simply remove the target and then
create the target again with empty target regions.

Link: https://lkml.kernel.org/r/20231031170131.46972-1-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   47 ++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-update-monitoring-target-regions-for-online-input-commit
+++ a/mm/damon/sysfs.c
@@ -1150,34 +1150,47 @@ destroy_targets_out:
 	return err;
 }
 
-static int damon_sysfs_update_target(struct damon_target *target,
-		struct damon_ctx *ctx,
-		struct damon_sysfs_target *sys_target)
+static int damon_sysfs_update_target_pid(struct damon_target *target, int pid)
 {
-	struct pid *pid;
-	struct damon_region *r, *next;
-
-	if (!damon_target_has_pid(ctx))
-		return 0;
+	struct pid *pid_new;
 
-	pid = find_get_pid(sys_target->pid);
-	if (!pid)
+	pid_new = find_get_pid(pid);
+	if (!pid_new)
 		return -EINVAL;
 
-	/* no change to the target */
-	if (pid == target->pid) {
-		put_pid(pid);
+	if (pid_new == target->pid) {
+		put_pid(pid_new);
 		return 0;
 	}
 
-	/* remove old monitoring results and update the target's pid */
-	damon_for_each_region_safe(r, next, target)
-		damon_destroy_region(r, target);
 	put_pid(target->pid);
-	target->pid = pid;
+	target->pid = pid_new;
 	return 0;
 }
 
+static int damon_sysfs_update_target(struct damon_target *target,
+		struct damon_ctx *ctx,
+		struct damon_sysfs_target *sys_target)
+{
+	int err;
+
+	if (damon_target_has_pid(ctx)) {
+		err = damon_sysfs_update_target_pid(target, sys_target->pid);
+		if (err)
+			return err;
+	}
+
+	/*
+	 * Do monitoring target region boundary update only if one or more
+	 * regions are set by the user.  This is for keeping current monitoring
+	 * target results and range easier, especially for dynamic monitoring
+	 * target regions update ops like 'vaddr'.
+	 */
+	if (sys_target->regions->nr)
+		err = damon_sysfs_set_regions(target, sys_target->regions);
+	return err;
+}
+
 static int damon_sysfs_set_targets(struct damon_ctx *ctx,
 		struct damon_sysfs_targets *sysfs_targets)
 {
_

Patches currently in -mm which might be from sj@kernel.org are


