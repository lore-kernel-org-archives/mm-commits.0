Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAAAC4167D
	for <mm-commits@archiver.kernel.org>; Tue, 31 Oct 2023 17:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236476AbjJaRKI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Oct 2023 13:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347015AbjJaRJx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Oct 2023 13:09:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB969107;
        Tue, 31 Oct 2023 10:09:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E314C433C8;
        Tue, 31 Oct 2023 17:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698772184;
        bh=m86oyc3bRDX2IeOM23fQkXV6Q0RvIJ6t2FflEZWLCyU=;
        h=Date:To:From:Subject:From;
        b=0mH5iQbdUvH/2cfnKK5zkLZ/6fRNWwq65Jk/TsmcNyZyJgYjQGurWuvmOTnXmIj4Q
         bLfWSeGBUdn1N6h/Icb6+ahZP8KoOSCueNqi4cGXygRxutKHeSSuTeTOIUBiOc9haS
         whlCqHGn6RxC0uJ38KT87r470GOwdx6AcIffLBHc=
Date:   Tue, 31 Oct 2023 10:09:43 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-update-monitoring-target-regions-for-online-input-commit.patch added to mm-hotfixes-unstable branch
Message-Id: <20231031170944.4E314C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: update monitoring target regions for online input commit
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-update-monitoring-target-regions-for-online-input-commit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-update-monitoring-target-regions-for-online-input-commit.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs.patch
mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs-fix.patch
mm-damon-sysfs-update-monitoring-target-regions-for-online-input-commit.patch

