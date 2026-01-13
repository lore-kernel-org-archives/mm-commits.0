Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4F729D28B;
	Tue, 13 Jan 2026 05:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280979; cv=none; b=W7FIk0SSCKq7GAfkBOvyMf/RdQdHNxI163114MRaYkLKj5ziI/Sm9aqmV/KXXA5KFTeqvPiTKWsUVfLEwoWzjFYUDnQliiq5eZhiCiBdvbblQCcoF/BZsD9jhvIaGetYSFb9KMuPnWHFpG2lI9D6NH762qDwqLSL0JoqTx4dfLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280979; c=relaxed/simple;
	bh=JxPfHpPCokfrXFVPnvQANGNehZLXFgYUNdmSEOrfI9g=;
	h=Date:To:From:Subject:Message-Id; b=jlyfLXWsrwnQVaE5YrnQkV3z6R0Jl6274NVkoa9NCx2+rQtRcmH6HpihR2ip5QdZWFSN1tisOP0xfKnqKKSMxAMa+0q7l1WH3i3zasLa+O4D57b0/m2DoPH89+KKhqbIcewkw7AwG9aE5BAJHesYmu2RDC9wzNxLK9h3K2mw0ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DlXTFm8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DlXTFm8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16E7C116C6;
	Tue, 13 Jan 2026 05:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280978;
	bh=JxPfHpPCokfrXFVPnvQANGNehZLXFgYUNdmSEOrfI9g=;
	h=Date:To:From:Subject:From;
	b=DlXTFm8t8y5s+BtS/NGJOW61SJKw73diGEo7gcASHcmna8TTI/6/nu/Ntwy0FIN3k
	 caid/EWwquefI5obc0e6WtMa2irlMBfe5Zr89+78ye0uxPc4fPrrI4d6/GAr1ZF+ZN
	 ml9Hr40NuHjkmtYyARcUCkiVNMX6Yk2kMF6G+/TY=
Date: Mon, 12 Jan 2026 21:09:38 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jiapeng.chong@linux.alibaba.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-cleanup-intervals-subdirs-on-attrs-dir-setup-failure.patch removed from -mm tree
Message-Id: <20260113050938.B16E7C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: cleanup intervals subdirs on attrs dir setup failure
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-cleanup-intervals-subdirs-on-attrs-dir-setup-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

