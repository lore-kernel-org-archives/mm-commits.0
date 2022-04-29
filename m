Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D64B6C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379083AbiD2Q3h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379090AbiD2Q3e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:29:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873282F3B4
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:26:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00791B83238
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F266C385A7;
        Fri, 29 Apr 2022 16:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651249565;
        bh=qDiiWmg4JAyfokJ+XJcSrNWECrjkJP3NTzFxfWd7LgM=;
        h=Date:To:From:Subject:From;
        b=h0UbOmEtCxL6CuXcL/XdC9pvFmi69YjCCQ303M6cSn+FiDqW18tgKqDmPNttcfs/J
         c1QqNhgdwZKoHOBpLVZVeg47rXp96xidE3P0yxYTV+w+wlbvZfWhu3APX/na16JNsx
         sW71jt7kdw+zjn7L/PkbWYlDZNRbiLOtDSZwNPgY=
Date:   Fri, 29 Apr 2022 09:26:04 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-reuse-damon_set_regions-for-regions-setting.patch added to mm-unstable branch
Message-Id: <20220429162605.9F266C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: reuse damon_set_regions() for regions setting
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-reuse-damon_set_regions-for-regions-setting.patch

This patch should soon appear in the mm-unstable branch at
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
Subject: mm/damon/sysfs: reuse damon_set_regions() for regions setting

'damon_set_regions()' is general enough so that it can also be used for
only creating regions.  This commit makes DAMON sysfs interface to reuse
the function rather keeping two implementations for a same purpose.

Link: https://lkml.kernel.org/r/20220429160606.127307-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-reuse-damon_set_regions-for-regions-setting
+++ a/mm/damon/sysfs.c
@@ -2095,28 +2095,31 @@ static void damon_sysfs_destroy_targets(
 static int damon_sysfs_set_regions(struct damon_target *t,
 		struct damon_sysfs_regions *sysfs_regions)
 {
-	int i;
+	struct damon_addr_range *ranges = kmalloc_array(sysfs_regions->nr,
+			sizeof(*ranges), GFP_KERNEL | __GFP_NOWARN);
+	int i, err = -EINVAL;
 
+	if (!ranges)
+		return -ENOMEM;
 	for (i = 0; i < sysfs_regions->nr; i++) {
 		struct damon_sysfs_region *sys_region =
 			sysfs_regions->regions_arr[i];
-		struct damon_region *prev, *r;
 
 		if (sys_region->start > sys_region->end)
-			return -EINVAL;
-		r = damon_new_region(sys_region->start, sys_region->end);
-		if (!r)
-			return -ENOMEM;
-		damon_add_region(r, t);
-		if (damon_nr_regions(t) > 1) {
-			prev = damon_prev_region(r);
-			if (prev->ar.end > r->ar.start) {
-				damon_destroy_region(r, t);
-				return -EINVAL;
-			}
-		}
+			goto out;
+
+		ranges[i].start = sys_region->start;
+		ranges[i].end = sys_region->end;
+		if (i == 0)
+			continue;
+		if (ranges[i - 1].end > ranges[i].start)
+			goto out;
 	}
-	return 0;
+	err = damon_set_regions(t, ranges, sysfs_regions->nr);
+out:
+	kfree(ranges);
+	return err;
+
 }
 
 static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch
mm-damon-core-add-a-function-for-damon_operations-registration-checks.patch
mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch
selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch
docs-abiadmin-guide-damon-document-avail_operations-sysfs-file.patch
mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch
docs-abiadmin-guide-damon-update-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-core-add-a-new-callback-for-watermarks-checks.patch
mm-damon-core-finish-kdamond-as-soon-as-any-callback-returns-an-error.patch
mm-damon-vaddr-generalize-damon_va_apply_three_regions.patch
mm-damon-vaddr-move-damon_set_regions-to-core.patch
mm-damon-vaddr-remove-damon_va_apply_three_regions.patch
mm-damon-sysfs-prohibit-multiple-physical-address-space-monitoring-targets.patch
mm-damon-sysfs-move-targets-setup-code-to-a-separated-function.patch
mm-damon-sysfs-reuse-damon_set_regions-for-regions-setting.patch
mm-damon-sysfs-use-enum-for-state-input-handling.patch
mm-damon-sysfs-update-schemes-stat-in-the-kdamond-context.patch
mm-damon-sysfs-support-online-inputs-update.patch
docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit.patch
mm-damon-reclaim-support-online-inputs-update.patch
docs-admin-guide-mm-damon-reclaim-document-commit_inputs-parameter.patch

