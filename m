Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310E630AD0A;
	Tue, 13 Jan 2026 05:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280981; cv=none; b=RqQc89EFeixzJlU0IETYNUIHAiQIq4Qh28cZnrMhjwBowEuCuKgLovXFZ+ET3f5Lv/jqTXPWfWA4Ig8UiEVBc+tjpg7Fml/lRhXnQyBYKXrTdXoBY60urwsBxWndPwdQnGVjoqn6egc+dopPKwKR8Eut0uu6DWCwQua3+gOYBAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280981; c=relaxed/simple;
	bh=qTqIiZhyyFQ3KqJ4Gy3y4VDGa6i556bHoKGG/4cKvE0=;
	h=Date:To:From:Subject:Message-Id; b=rxbTfizDB58CPqR/5HRXWk19BTyTwDSxtCQMQ5zUEkjW22chiLJ1vQHlTml0fjdjPnVqvz2/GP2S4EtcV1Yi+3vpKDFho5fiN1GjdfRQZ5rWgzN6n0mrSpXEtJdFz/w18f78drrfJoSjcNmI8F8FQtErJpct0lYLike2aZbEsD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TXVEEqQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TXVEEqQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2A8C116C6;
	Tue, 13 Jan 2026 05:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280981;
	bh=qTqIiZhyyFQ3KqJ4Gy3y4VDGa6i556bHoKGG/4cKvE0=;
	h=Date:To:From:Subject:From;
	b=TXVEEqQXJdMbEADApgWWEMMX5/pBQoubpdEq7sjb3gK+GY2olrePbGhmf1qGv9/dl
	 bxXY86INqx/v5yFENxkHOEJXQZALVxY8nwrVmV/0AXXjr09GL3O7T6xLEbX7aGubqd
	 KYa+o6I/5XwWGb8eZPODx6ywjpyWykG+wwU6mthA=
Date: Mon, 12 Jan 2026 21:09:40 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jiapeng.chong@linux.alibaba.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-scheme-cleanup-quotas-subdirs-on-scheme-dir-setup-failure.patch removed from -mm tree
Message-Id: <20260113050941.0B2A8C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-scheme: cleanup quotas subdirs on scheme dir setup failure
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-scheme-cleanup-quotas-subdirs-on-scheme-dir-setup-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-scheme: cleanup quotas subdirs on scheme dir setup failure
Date: Wed, 24 Dec 2025 18:30:36 -0800

When a DAMOS-scheme DAMON sysfs directory setup fails after setup of
quotas/ directory, subdirectories of quotas/ directory are not cleaned up.
As a result, DAMON sysfs interface is nearly broken until the system
reboots, and the memory for the unremoved directory is leaked.

Cleanup the directories under such failures.

Link: https://lkml.kernel.org/r/20251225023043.18579-4-sj@kernel.org
Fixes: 1b32234ab087 ("mm/damon/sysfs: support DAMOS watermarks")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: chongjiapeng <jiapeng.chong@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-scheme-cleanup-quotas-subdirs-on-scheme-dir-setup-failure
+++ a/mm/damon/sysfs-schemes.c
@@ -2158,7 +2158,7 @@ static int damon_sysfs_scheme_add_dirs(s
 		goto put_dests_out;
 	err = damon_sysfs_scheme_set_watermarks(scheme);
 	if (err)
-		goto put_quotas_access_pattern_out;
+		goto rmdir_put_quotas_access_pattern_out;
 	err = damos_sysfs_set_filter_dirs(scheme);
 	if (err)
 		goto put_watermarks_quotas_access_pattern_out;
@@ -2183,7 +2183,8 @@ put_filters_watermarks_quotas_access_pat
 put_watermarks_quotas_access_pattern_out:
 	kobject_put(&scheme->watermarks->kobj);
 	scheme->watermarks = NULL;
-put_quotas_access_pattern_out:
+rmdir_put_quotas_access_pattern_out:
+	damon_sysfs_quotas_rm_dirs(scheme->quotas);
 	kobject_put(&scheme->quotas->kobj);
 	scheme->quotas = NULL;
 put_dests_out:
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

