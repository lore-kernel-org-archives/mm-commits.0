Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEB129D28B;
	Tue, 13 Jan 2026 05:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280980; cv=none; b=Qy9S1l7PPdlxu8hNByVc+1rJcVkkBGo7KiLuikLD0JwP/Q3jGOTOGHHPt/stg6qzXNKuNy1okMGe3zluARWY3dzVgdkmvI6H+kNm8oFBdUpz9kf9ihjgJnVqJ/+eBHQSCFAQHtxDdrx8vN8RuqBxva8pcR1SeGBSW0qlfwSRlIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280980; c=relaxed/simple;
	bh=XjlUWzvw124piZ58aggGh2w4odHInPo4Q0pAY8GxHXw=;
	h=Date:To:From:Subject:Message-Id; b=PSl9zHfuQ0o0pLcmy/orSbY2iAJWpdzrkVRV5Tk89H3K731H7yEcGA305IC1n+KlDI8MsEXr9Qd3NAccq+aMbKzZECp62FIheJ5tYC7V+5b9R8F0stRZXKdLQTs6PQ6lDrE7ed4sTFOHwafpdpICTTzfFfz+lwyPejb7rINzxJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kXNRmLgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kXNRmLgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAC0C116C6;
	Tue, 13 Jan 2026 05:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280979;
	bh=XjlUWzvw124piZ58aggGh2w4odHInPo4Q0pAY8GxHXw=;
	h=Date:To:From:Subject:From;
	b=kXNRmLgWCIfOsEAYtAKcE58GzWHoCvepiRhbl8/SgaxjDdgAa0uC9248Kis8SUqro
	 e/c8I8QpXQg+XrEYUeh1OIYeVM3eNqZqD/j90n7LX1Oo19CHWsQdi6plregyH3mJG1
	 MW/opOGifcDN6MN0fsCZsDezJEOJoCKPI538oI4E=
Date: Mon, 12 Jan 2026 21:09:39 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jiapeng.chong@linux.alibaba.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-cleanup-attrs-subdirs-on-context-dir-setup-failure.patch removed from -mm tree
Message-Id: <20260113050939.DCAC0C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: cleanup attrs subdirs on context dir setup failure
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-cleanup-attrs-subdirs-on-context-dir-setup-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: cleanup attrs subdirs on context dir setup failure
Date: Wed, 24 Dec 2025 18:30:35 -0800

When a context DAMON sysfs directory setup is failed after setup of attrs/
directory, subdirectories of attrs/ directory are not cleaned up.  As a
result, DAMON sysfs interface is nearly broken until the system reboots,
and the memory for the unremoved directory is leaked.

Cleanup the directories under such failures.

Link: https://lkml.kernel.org/r/20251225023043.18579-3-sj@kernel.org
Fixes: c951cd3b8901 ("mm/damon: implement a minimal stub for sysfs-based DAMON interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: chongjiapeng <jiapeng.chong@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-cleanup-attrs-subdirs-on-context-dir-setup-failure
+++ a/mm/damon/sysfs.c
@@ -950,7 +950,7 @@ static int damon_sysfs_context_add_dirs(
 
 	err = damon_sysfs_context_set_targets(context);
 	if (err)
-		goto put_attrs_out;
+		goto rmdir_put_attrs_out;
 
 	err = damon_sysfs_context_set_schemes(context);
 	if (err)
@@ -960,7 +960,8 @@ static int damon_sysfs_context_add_dirs(
 put_targets_attrs_out:
 	kobject_put(&context->targets->kobj);
 	context->targets = NULL;
-put_attrs_out:
+rmdir_put_attrs_out:
+	damon_sysfs_attrs_rm_dirs(context->attrs);
 	kobject_put(&context->attrs->kobj);
 	context->attrs = NULL;
 	return err;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch

