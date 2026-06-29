Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C81016DEB1
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 04:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708938; cv=none; b=DaMGsb7cwHi/ANxzW/vMoDODjHl+kVLgoGMZZ+Qn2UtJ9uLOdSAExrP26RajsleEwohIg5Ik04j8MQySuuIUUN3/ALBYrNsE8a+AcsRGjIIugzLwKx/vfqe99DORqZ2KCQlp7I2Md6zBn6um+VvvMiEFWyLATBZznkVD1FwFTdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708938; c=relaxed/simple;
	bh=dUEPQxIr8AetmyNltm9EhWwAw9yK/2d+P6V8Xi2dYD8=;
	h=Date:To:From:Subject:Message-Id; b=CfJD+wOtzouee3zvC+2hMC+80M/QGuNl8IlX92OV+GYMIRNfJNbbs4n4kSSwkfxyge9uP6gpi41AW3AgQ/LhuBv7A/iNLw5R7YYe11RGa5NNFMgfc/QAPpRY825pPYpX6puG45VQb7yjLN3l08ENoz7m3qVxzjggM6AUyTXdUAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E134pB4t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E134pB4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAC21F000E9;
	Mon, 29 Jun 2026 04:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708937;
	bh=/gGhC3mV6z23bL9nEHVTsx2rVPY8wwYTWO5vl/o6LmM=;
	h=Date:To:From:Subject;
	b=E134pB4t5Y+Kn9eayJfBWc63TM1U/LEsqeYafIEpZEyOTOxcx7cdwVubfTT84+uJP
	 vn4Q8uuPdEizbEK+oIofMneovYs3urQxc9/a7ulRf80Xm3pPqgxxSGfYyH377guYn0
	 zwkJYcMKFdXSlxv2+unySU/aB42DbZ2Zdr9nLFC0=
Date: Sun, 28 Jun 2026 21:55:36 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-kobject_del-probe-dirs.patch added to mm-new branch
Message-Id: <20260629045537.2FAC21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: kobject_del() probe dirs
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-kobject_del-probe-dirs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-kobject_del-probe-dirs.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs: kobject_del() probe dirs
Date: Sun, 28 Jun 2026 15:01:17 -0700

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for data attribute probe directories by adding kobject_del()
calls.

Link: https://lore.kernel.org/20260628220121.97360-9-sj@kernel.org
Fixes: bf3ea3d30880 ("mm/damon/sysfs: implement probe dir")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-kobject_del-probe-dirs
+++ a/mm/damon/sysfs.c
@@ -1137,6 +1137,7 @@ static void damon_sysfs_probes_rm_dirs(
 
 	for (i = 0; i < probes->nr; i++) {
 		damon_sysfs_probe_rm_dirs(probes_arr[i]);
+		kobject_del(&probes_arr[i]->kobj);
 		kobject_put(&probes_arr[i]->kobj);
 	}
 	probes->nr = 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-dir-put-orders-in-access_pattern_add_dirs.patch
mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch
mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score.patch
maintainers-s-seongjae-sj.patch
samples-damon-wsse-handle-damon_start-failure.patch
samples-damon-prcl-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_stop-failure.patch
samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch
samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch
mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch
mm-damon-sysfs-kobject_del-region-and-target-error-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-filter-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs.patch
mm-damon-sysfs-kobject_del-probe-filter-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch
mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch

