Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7705816DEB1
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 04:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708940; cv=none; b=uk3BJQltinCRioAWLndfCf6snik0iuXQMgwm/za8XmN7KeREwKrwsEpkQP6f7/75TG7J6R2Zr21VxeSg2zFCM6PTQOOQgs6p7tmpkMiTprfrNVnlscasSURXwkH9/MrNk6MtH9l2skd59oPWGUWPbndeH+zTFZsE/MtNEjpq2OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708940; c=relaxed/simple;
	bh=E4OFzl7zXVh8GR2C+etx2q6WWHQFwEzSTmxsNffKSI4=;
	h=Date:To:From:Subject:Message-Id; b=X5dvbyPXF4uT/58aY5eBZ02nwT/iz3K7rS0mKTvjcEnlHs9EisBfGHmzkspwvPubfubO/YvdD13LyrhsfIHDNOOBkf1Adf+EotR6zQBFRm2XtZJG7giVVivhoyQoHdKvk/Az2v2SnIu0MFzKoaPcxtDV/fFlBMZ8LFDjNET6pU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rcKTa3As; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rcKTa3As"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB921F000E9;
	Mon, 29 Jun 2026 04:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708939;
	bh=oX+gp8GOeGRDld9GKtZmvG5MnS9MWxXPYHcIzxOEDtc=;
	h=Date:To:From:Subject;
	b=rcKTa3AsSoEyPhq3/G80EE9ueA0p9CKekL//kdxcLDIxZLSstRN0Uu3ZeIV3wN1At
	 aQTwmGB4ugDzHXbDDt49lRLn6/TxIDofJWu7rj4AHTEjl2huwe9eIOke8FL4u2RLtb
	 J1cbYoXvB7fErMCFeVDzT0wuNiemRNaAgjiGgTn8=
Date: Sun, 28 Jun 2026 21:55:38 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-kobject_del-probe-filter-dirs.patch added to mm-new branch
Message-Id: <20260629045539.1AB921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: kobject_del() probe filter dirs
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-kobject_del-probe-filter-dirs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-kobject_del-probe-filter-dirs.patch

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
Subject: mm/damon/sysfs: kobject_del() probe filter dirs
Date: Sun, 28 Jun 2026 15:01:18 -0700

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for data attribute probe filter directories by adding
kobject_del() calls.

Link: https://lore.kernel.org/20260628220121.97360-10-sj@kernel.org
Fixes: 82e66aef7714 ("mm/damon/sysfs: implement filter dir")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-kobject_del-probe-filter-dirs
+++ a/mm/damon/sysfs.c
@@ -960,8 +960,10 @@ static void damon_sysfs_filters_rm_dirs(
 	struct damon_sysfs_filter **filters_arr = filters->filters_arr;
 	int i;
 
-	for (i = 0; i < filters->nr; i++)
+	for (i = 0; i < filters->nr; i++) {
+		kobject_del(&filters_arr[i]->kobj);
 		kobject_put(&filters_arr[i]->kobj);
+	}
 	filters->nr = 0;
 	kfree(filters_arr);
 	filters->filters_arr = NULL;
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

