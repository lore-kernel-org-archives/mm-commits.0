Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACAD28D8DA
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 04:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708944; cv=none; b=uCrD8cVvYhxqzZvtkrj8aCHF2vH2bXC95rhdlzw/GxSl11nO2BvHEPRjKG0nsFXtVGnj/0EyBJnStuYVnGK07oFvefhdoICqzgfRutQgtfc3GXZL8aL1sFix60Y/hChylO0OdvglTVTXBI+ZnKDOQLkN3aVolqMu0HjQ6g2QOOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708944; c=relaxed/simple;
	bh=P5P3hGbPFG9vRjQIYRnhbQZC7Gv+tmu0H3z/wDx6XG4=;
	h=Date:To:From:Subject:Message-Id; b=Yv6frZ/pluzD80mMkB3JCshlg1nqIdCY/YGo/MccaaEqtTRBvmPMaPclqHDQjnnkethIjvnyrATwWRMwrFXzwJCP7AOUEwgqRhf1HfN3/BwiaJIBAVt2n8hCr6uWAAMEIAxNKPlhS81SlBhI2ZwtEuzTGURFu26cRrYrosYfj5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J+BVIxbc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J+BVIxbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E402B1F000E9;
	Mon, 29 Jun 2026 04:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708943;
	bh=rJVVF8P4AN666QzeGj/Zn/rdhkmdqDdFBgNcbQlkc/0=;
	h=Date:To:From:Subject;
	b=J+BVIxbc5Ub4u/IMSfnSv1aZN8v5FQMempVHQrPibK6RScor5amF9QsCR/NymJPVs
	 ZQKURNvY5tp5OqpsoJP8ZX/dl0jEof61U13RBaAp++sCFMKY/+7yqb+bsCC+7BCugO
	 AVaamIQjWDdVCTDzYs7Mp8Kok5H5RpJcjX5IkEU8=
Date: Sun, 28 Jun 2026 21:55:42 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch added to mm-new branch
Message-Id: <20260629045542.E402B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: kobject_del() region for populate_region error
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch

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
Subject: mm/damon/sysfs-schemes: kobject_del() region for populate_region error
Date: Sun, 28 Jun 2026 15:01:20 -0700

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
the issue for tried region directories in the error handling path of
damon_sysfs_populate_region_dir() by adding a kobject_del() call.

Link: https://lore.kernel.org/20260628220121.97360-12-sj@kernel.org
Fixes: b574a82d10de ("mm/damon/sysfs-schemes: implement tried_regions/<r>/probes/")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error
+++ a/mm/damon/sysfs-schemes.c
@@ -3132,12 +3132,14 @@ void damos_sysfs_populate_region_dir(str
 				sysfs_regions->nr_regions))
 		goto out;
 	if (damos_sysfs_region_add_dirs(region, ctx, r))
-		goto out;
+		goto del_out;
 
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
 	sysfs_regions->nr_regions++;
 	return;
 
+del_out:
+	kobject_del(&region->kobj);
 out:
 	kobject_put(&region->kobj);
 }
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

