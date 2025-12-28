Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49A22571A0;
	Sun, 28 Dec 2025 21:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766958549; cv=none; b=nx/Y3Zl1+c4KzamWm33p0N/4TU4HWaWrhabJiZgv/pIVQZyzaqPjsfwlWxIenn97eRD7R/N0fQPPHtH+/AxMgNP0+rnJCoxqJfr4Xkq/zd+n0NqSG4m4FIP9I49dJm/AqxJ4tvZLOrHG0DNZ/mkL7F+1abhVl5/yRnIsiUQcDZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766958549; c=relaxed/simple;
	bh=qSQuJabF5kC/d1M37FodqE+Jpw9DDF8qLcMM9h5FrT8=;
	h=Date:To:From:Subject:Message-Id; b=Ic/5H3/rrtqmOnq4n0mQPcZz81KHLeLQwtgCYPJFgIITK1zWQmP90B2KzaoYLdccVAIl8vCe7XE4+9CsV5c1DmtUK+tDcCgZlatU4WM9w+dL8ismyQnnw9Ye8xK4pZrCHQqvePmi0hq8vlndbEFnkQL7VmjkKyOOff/L0ghtrh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VC8ttUcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VC8ttUcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75919C4CEFB;
	Sun, 28 Dec 2025 21:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766958549;
	bh=qSQuJabF5kC/d1M37FodqE+Jpw9DDF8qLcMM9h5FrT8=;
	h=Date:To:From:Subject:From;
	b=VC8ttUcFwxCHzvWqHNhAJWCKSZOEoRfpXrKODMMKkdVmxKroMrnBULhgmPui/3WMr
	 85LCk+HeHEj38tORf5IXJv19nr8Iqes6+tg6tkh4FwpSPaPR2dWorfkMZFXq4kGHJ3
	 tkxHkgtYZa+kwmzfCmEi2VGc/znUl9CAoJNoHlMU=
Date: Sun, 28 Dec 2025 13:49:08 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jiapeng.chong@linux.alibaba.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-scheme-cleanup-access_pattern-subdirs-on-scheme-dir-setup-failure.patch added to mm-new branch
Message-Id: <20251228214909.75919C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-scheme: cleanup access_pattern subdirs on scheme dir setup failure
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-scheme-cleanup-access_pattern-subdirs-on-scheme-dir-setup-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-scheme-cleanup-access_pattern-subdirs-on-scheme-dir-setup-failure.patch

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
Subject: mm/damon/sysfs-scheme: cleanup access_pattern subdirs on scheme dir setup failure
Date: Wed, 24 Dec 2025 18:30:37 -0800

When a DAMOS-scheme DAMON sysfs directory setup fails after setup of
access_pattern/ directory, subdirectories of access_pattern/ directory are
not cleaned up.  As a result, DAMON sysfs interface is nearly broken until
the system reboots, and the memory for the unremoved directory is leaked.

Cleanup the directories under such failures.

Link: https://lkml.kernel.org/r/20251225023043.18579-5-sj@kernel.org
Fixes: 9bbb820a5bd5 ("mm/damon/sysfs: support DAMOS quotas")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: chongjiapeng <jiapeng.chong@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-scheme-cleanup-access_pattern-subdirs-on-scheme-dir-setup-failure
+++ a/mm/damon/sysfs-schemes.c
@@ -2193,7 +2193,7 @@ static int damon_sysfs_scheme_add_dirs(s
 		return err;
 	err = damos_sysfs_set_dests(scheme);
 	if (err)
-		goto put_access_pattern_out;
+		goto rmdir_put_access_pattern_out;
 	err = damon_sysfs_scheme_set_quotas(scheme);
 	if (err)
 		goto put_dests_out;
@@ -2231,7 +2231,8 @@ rmdir_put_quotas_access_pattern_out:
 put_dests_out:
 	kobject_put(&scheme->dests->kobj);
 	scheme->dests = NULL;
-put_access_pattern_out:
+rmdir_put_access_pattern_out:
+	damon_sysfs_access_pattern_rm_dirs(scheme->access_pattern);
 	kobject_put(&scheme->access_pattern->kobj);
 	scheme->access_pattern = NULL;
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

