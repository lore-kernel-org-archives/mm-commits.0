Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095962571A0;
	Sun, 28 Dec 2025 21:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766958549; cv=none; b=lF652fjL7BeG4LWL+SBYlLs0Upxb+YiiG32yaN/eew9iPDkj791ijfL1V5XDk2BtqYTuhVjpNNH3rY9SWMqf1dMiJwK3JC24rpswnpPYBkUziClCQEVq/C6Gv9zhJbpmec5J4DAA3EGuIyHwrA6+eQy8matYAsAzhcqHkbxx5Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766958549; c=relaxed/simple;
	bh=WiKkNqaVGyD+3WP2nxdZU5QauiKRt1HwW9QgQv4ogP8=;
	h=Date:To:From:Subject:Message-Id; b=VPPzXFrn/i0muoGDijjGOlCeszqjcuIKW5RbxUlV/SKptacYYfiqnK7P/y+Zl3+blVqA1dj/PzD46ZGJhAk2f7Oi0WeKMgL86Jcpty0VAsKqtbJZ+pcub0DysHfxWuAkFNfpuavWrZT8GH1buwV5G5RB9nOzKahcETWq9qW4YBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r/AONAng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r/AONAng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F91EC4CEFB;
	Sun, 28 Dec 2025 21:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766958545;
	bh=WiKkNqaVGyD+3WP2nxdZU5QauiKRt1HwW9QgQv4ogP8=;
	h=Date:To:From:Subject:From;
	b=r/AONAng2CME21ueaY7RCdNudRp1FO1X7DtBInE6uCPSZW39jWLZTR3hDgDlkCf0W
	 KPVSabdP17gwrcrQ3tiWUzMs4v5Z5AIczCOwl0aLPmJ/gUSpEvQWDkbyW9fVh2ZVEE
	 Eflwy5iEGrm0ZqJ747nO5DNusINVzVXoe7182hm8=
Date: Sun, 28 Dec 2025 13:49:04 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jiapeng.chong@linux.alibaba.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-cleanup-attrs-subdirs-on-context-dir-setup-failure.patch added to mm-new branch
Message-Id: <20251228214905.7F91EC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: cleanup attrs subdirs on context dir setup failure
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-cleanup-attrs-subdirs-on-context-dir-setup-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-cleanup-attrs-subdirs-on-context-dir-setup-failure.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-damon-core-remove-call_control-in-inactive-contexts.patch
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
mm-damon-sysfs-cleanup-intervals-subdirs-on-attrs-dir-setup-failure.patch
mm-damon-sysfs-cleanup-attrs-subdirs-on-context-dir-setup-failure.patch
mm-damon-sysfs-scheme-cleanup-quotas-subdirs-on-scheme-dir-setup-failure.patch
mm-damon-sysfs-scheme-cleanup-access_pattern-subdirs-on-scheme-dir-setup-failure.patch

