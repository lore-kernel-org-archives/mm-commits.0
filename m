Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C873595D;
	Tue, 13 Jan 2026 05:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280982; cv=none; b=RQx+a6jcW/oYKsKSSqCq2gnHU7KlGL1iHVq+rRm/qxQLkMNBbK/NHQ1do8GTHromvUJsSdf8nG2cvv2f6Gg4c758ja5pT5ZtFC05hNbG91OFloCtXyQz28szUzeaoC2CA8j6i9RZhLycU7JqzCjvyNbpK/ffWIiq9lj/g7qg0aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280982; c=relaxed/simple;
	bh=6ETA/XLo1TMjJ4nGcicpyNNzdj/yxUTA9evz+OqXw7Y=;
	h=Date:To:From:Subject:Message-Id; b=piXTPrvhWOJ33QTZE76pJ/J4unhTWJSOVaBCNaaqYyejKF6kgkg0wOPqWmD8SykiqfLwj7wnDNV/kgUVSRy/Igdt7ghotxq2WSQVql2InxDoFyF74cADQvFhXJkcZh9Vf5P85gZzmyVxQKtx3NoKehETXttkODGb/LHbwuFYxMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1a0uoDmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1a0uoDmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F863C116C6;
	Tue, 13 Jan 2026 05:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280982;
	bh=6ETA/XLo1TMjJ4nGcicpyNNzdj/yxUTA9evz+OqXw7Y=;
	h=Date:To:From:Subject:From;
	b=1a0uoDmhZTIAU41/b7oDEzJgiBDJNOcwC4VmzBkobHLL/s5yTw5bbCGqqR45IUe0N
	 AWIVyHTcUy74k6XXrZWEoFtS0CI9eDr6ZDJ9SoEhkP3Nqrm1c/b4rERokojkCR2fBu
	 SUzISlbv246BkB+TaAGHRx5twDnY6hIkI0PyXIbM=
Date: Mon, 12 Jan 2026 21:09:41 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jiapeng.chong@linux.alibaba.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-scheme-cleanup-access_pattern-subdirs-on-scheme-dir-setup-failure.patch removed from -mm tree
Message-Id: <20260113050942.2F863C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-scheme: cleanup access_pattern subdirs on scheme dir setup failure
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-scheme-cleanup-access_pattern-subdirs-on-scheme-dir-setup-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2152,7 +2152,7 @@ static int damon_sysfs_scheme_add_dirs(s
 		return err;
 	err = damos_sysfs_set_dests(scheme);
 	if (err)
-		goto put_access_pattern_out;
+		goto rmdir_put_access_pattern_out;
 	err = damon_sysfs_scheme_set_quotas(scheme);
 	if (err)
 		goto put_dests_out;
@@ -2190,7 +2190,8 @@ rmdir_put_quotas_access_pattern_out:
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

