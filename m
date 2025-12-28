Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE49625;
	Sun, 28 Dec 2025 21:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766958544; cv=none; b=t0B2lP4iAFr11fmxGVGm/iwdRZqMVKqFmXXlnEcGxFIzvhCJPwHFfr7GErLYseRhydbMdU6sVpdC6Hs245KTHi3Ito/thRprIamylXuWkeBQ2uKZNLbZppc1kE9BzlzzDUO6Z4YIBkl9WP+/lKjZgCP8pkTOnUJCm9iX4Z3rNxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766958544; c=relaxed/simple;
	bh=PyoIfZuHrC0Jud/Y6As3ZLdi70V+qiNq2ysRNhMFotk=;
	h=Date:To:From:Subject:Message-Id; b=jrRO0O7tfQPz6zlp8W8Q61OKxld56jSJozfdKvD306C0S3b89V6Wwg1nesevWCBmiTtKETlE5/NlLN1l74knp13x3sOM+XmrfU5sAI1QopC09lEox4weWbM6vnOX4hmlmoxzoeJa02BeRS2MZhqwFLzt66+7HW41JTF3LCeMb2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ftkpRA2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ftkpRA2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706D4C4CEFB;
	Sun, 28 Dec 2025 21:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766958543;
	bh=PyoIfZuHrC0Jud/Y6As3ZLdi70V+qiNq2ysRNhMFotk=;
	h=Date:To:From:Subject:From;
	b=ftkpRA2iFtcdhZfoRnNZdgSRjYiu1UoevZO1Bfo8S7QbbB7rqD9atX4CINHPJFb5R
	 PyYux4IPiG5JY5tYZP7GrbSfo/Co1//2Sr7uUGbPitDoUldVIMoQzaT+5FWw8squ0q
	 tmdhGE8eiWZ3+5/bBfkB/bFljlyU0Kqe3aJ11/aA=
Date: Sun, 28 Dec 2025 13:49:02 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jiapeng.chong@linux.alibaba.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-cleanup-intervals-subdirs-on-attrs-dir-setup-failure.patch added to mm-new branch
Message-Id: <20251228214903.706D4C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: cleanup intervals subdirs on attrs dir setup failure
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-cleanup-intervals-subdirs-on-attrs-dir-setup-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-cleanup-intervals-subdirs-on-attrs-dir-setup-failure.patch

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
Subject: mm/damon/sysfs: cleanup intervals subdirs on attrs dir setup failure
Date: Wed, 24 Dec 2025 18:30:34 -0800

Patch series "mm/damon/sysfs: free setup failures generated zombie sub-sub
dirs".

Some DAMON sysfs directory setup functions generates its sub and sub-sub
directories.  For example, 'monitoring_attrs/' directory setup creates
'intervals/' and 'intervals/intervals_goal/' directories under
'monitoring_attrs/' directory.  When such sub-sub directories are
successfully made but followup setup is failed, the setup function should
recursively clean up the subdirectories.

However, such setup functions are only dereferencing sub directory
reference counters.  As a result, under certain setup failures, the
sub-sub directories keep having non-zero reference counters.  It means the
directories cannot be removed like zombies, and the memory for the
directories cannot be freed.

The user impact of this issue is limited due to the following reasons.

When the issue happens, the zombie directories are still taking the path. 
Hence attempts to generate the directories again will fail, without
additional memory leak.  This means the upper bound memory leak is
limited.  Nonetheless this also implies controlling DAMON with a feature
that requires the setup-failed sysfs files will be impossible until the
system reboots.

Also, the setup operations are quite simple.  The certain failures would
hence only rarely happen, and are difficult to artificially trigger.


This patch (of 4):

When attrs/ DAMON sysfs directory setup is failed after setup of
intervals/ directory, intervals/intervals_goal/ directory is not cleaned
up.  As a result, DAMON sysfs interface is nearly broken until the system
reboots, and the memory for the unremoved directory is leaked.

Cleanup the directory under such failures.

Link: https://lkml.kernel.org/r/20251225023043.18579-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251225023043.18579-2-sj@kernel.org
Fixes: 8fbbcbeaafeb ("mm/damon/sysfs: implement intervals tuning goal directory")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: chongjiapeng <jiapeng.chong@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-cleanup-intervals-subdirs-on-attrs-dir-setup-failure
+++ a/mm/damon/sysfs.c
@@ -792,7 +792,7 @@ static int damon_sysfs_attrs_add_dirs(st
 	nr_regions_range = damon_sysfs_ul_range_alloc(10, 1000);
 	if (!nr_regions_range) {
 		err = -ENOMEM;
-		goto put_intervals_out;
+		goto rmdir_put_intervals_out;
 	}
 
 	err = kobject_init_and_add(&nr_regions_range->kobj,
@@ -806,6 +806,8 @@ static int damon_sysfs_attrs_add_dirs(st
 put_nr_regions_intervals_out:
 	kobject_put(&nr_regions_range->kobj);
 	attrs->nr_regions_range = NULL;
+rmdir_put_intervals_out:
+	damon_sysfs_intervals_rm_dirs(intervals);
 put_intervals_out:
 	kobject_put(&intervals->kobj);
 	attrs->intervals = NULL;
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

