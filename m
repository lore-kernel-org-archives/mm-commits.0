Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03A0282F38;
	Mon, 29 Jun 2026 04:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708931; cv=none; b=kDqTtm8SJfgP4PsRO/rVwfHDjlPpErd8pTTwk9zwOCvGGZXRsTLwiOje+ZBoR3HDJQIH0k64h+3xyRlf5WVhjeXbnsU/GpQHzdQeGOrdYTQdAhUtiTT9xPh79YUg7MVo0EW+FtpRpKCzqn0o1G9zDw90Z7l+WLU65J/kN+0lPe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708931; c=relaxed/simple;
	bh=em/O/LQY3GCnSddB+mYj5HNprZ6yn/9nAzjOhb6JDVg=;
	h=Date:To:From:Subject:Message-Id; b=tg7jygeIVvuLNa97/WQWiLizSn+JefPS1GcWAlrr0arXQujK9evdcxXkVV/M51xIis6W8skrT0KhjFHt5JZsNCNqJOvLw9ZiCaE+lsJFsmixYd76Q0Paqvce5PmisKXukOwrm1yYMJsPUHz1tNJAcFc69qhfeJF99QouRhjkgiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wpOSqLCK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wpOSqLCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A14D1F000E9;
	Mon, 29 Jun 2026 04:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708929;
	bh=IaDWGI0L+d77v1PWzS5NDb/mkWi9/RllzE6Xui5La3c=;
	h=Date:To:From:Subject;
	b=wpOSqLCKDSs0r+6Scp5h4MwqHo2fZwCwDkDWlRhaKI8KpdbCNJ5ZFncW+zjjP3pHT
	 km+Ul1DyGot+Av94RqmuDi1MSsq0q7ykrt+DrZ7LfqKJUWakNPHaiKa/k49LFGEJ3v
	 R+KlVXL/wZXKtNe0/W93UahXm/HaDVfBMI8uXCFE=
Date: Sun, 28 Jun 2026 21:55:29 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch added to mm-new branch
Message-Id: <20260629045529.6A14D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: kobject_del() scheme region dirs
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch

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
Subject: mm/damon/sysfs-schemes: kobject_del() scheme region dirs
Date: Sun, 28 Jun 2026 15:01:13 -0700

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for scheme region directories by adding kobject_del() calls.

This issue was discovered [1] by Sashiko, though its analysis was
partially incorrect.

Link: https://lore.kernel.org/20260628220121.97360-5-sj@kernel.org
Link: https://lore.kernel.org/20260517205828.6204-1-sj@kernel.org [1]
Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs
+++ a/mm/damon/sysfs-schemes.c
@@ -332,6 +332,7 @@ static void damon_sysfs_scheme_regions_r
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
 		damos_sysfs_region_rm_dirs(r);
 		list_del(&r->list);
+		kobject_del(&r->kobj);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
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

