Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345D42BEC3F
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 04:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708942; cv=none; b=RGQnbFcq8u4yE5zil5nb60ATjkH0dPk3BD9GVkE8TQdc4Q1MNjtrt/iIu2B0i+Je3WcCl1/H1sv6clr8fnhQRPuv4gNuxpIYcg6LCIDp9UuITtpSL7igbJjbDW/QzEyhsG4QrJEZufyE9JcE6guH1ecp506fDODYZotvthEqMrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708942; c=relaxed/simple;
	bh=6GkItLyokhv66uBfwZCzXpXHyUZJkSMaKTGFQU5x5X0=;
	h=Date:To:From:Subject:Message-Id; b=KLFpsT0lNj416USWe70bVDod5lalzN3qYHvdO2U1CK+YTOmNp7o0Ct/3+13BNxRuP0qodK9y3WYiOGOh2s4J+PZCC1f5wEkVRRNFZv5qdv2GALoNK5b0eM0VrDEZybyaTNjcuRY/cHuwhnCsFmrvxjr6lHxuroVnfezb2oKeKGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ziIEjxqt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ziIEjxqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F9E1F000E9;
	Mon, 29 Jun 2026 04:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708941;
	bh=xOizV/xvKD6sHhDUt26r91fLztcsOenPmWPeQyn6d10=;
	h=Date:To:From:Subject;
	b=ziIEjxqtwDFTS+DbnwH5c0bznykODOnAKqmIGNwcmCBTzoiT/PdHTk7NiHnFgOAj7
	 UzVMzHWBhyNnsxkGQ40d3ItDD2ImZYzRu0VvuDbXMzr1hwZaArj9f2wAP0AS/fqUNe
	 9BvAXCdmvYvLnF6i7rlT1KUasULDSZ7LyGw6iDRQ=
Date: Sun, 28 Jun 2026 21:55:40 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch added to mm-new branch
Message-Id: <20260629045541.07F9E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: kobject_del() probe dirs in probes_addd_dir error path
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch

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
Subject: mm/damon/sysfs: kobject_del() probe dirs in probes_addd_dir error path
Date: Sun, 28 Jun 2026 15:01:19 -0700

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
the issue for data attribute probe filter directories in the error
handling path of damon_sysfs_probes_add_dirs() by adding a kobject_del()
call.

Link: https://lore.kernel.org/20260628220121.97360-11-sj@kernel.org
Fixes: af7cb41af9a9 ("mm/damon/sysfs: implement filters directory")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path
+++ a/mm/damon/sysfs.c
@@ -1181,6 +1181,7 @@ static int damon_sysfs_probes_add_dirs(
 
 		err = damon_sysfs_probe_add_dirs(probe);
 		if (err) {
+			kobject_del(&probe->kobj);
 			kobject_put(&probe->kobj);
 			damon_sysfs_probes_rm_dirs(probes);
 			return err;
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

