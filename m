Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B380E16DEB1;
	Mon, 29 Jun 2026 04:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708934; cv=none; b=lzLONj4xGLjb0qB8E9L+ZuDE0S3iV1pw1pinAoTJ5iamcNS1KXXwGoarBjlnx3KGfO+OxO1iyyJSGGb0v0H++ZHaiJ/WPdPSpxs8W/cOXzuRA5jSvzjJ6DFzfM9dIuqf17+wr7KCA+11MWoUfXD5cQ0CjEj8EJCtnISG4nWkD54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708934; c=relaxed/simple;
	bh=AIYh6QngtEEgDARn0FR6EFLo5lnTTxhFW4sI/VSan3Y=;
	h=Date:To:From:Subject:Message-Id; b=k7bxSoj6aHlC7mpNbPILpFur60llGqA9Mbsz9k43tjptMPo5dkxurqeTI920jIN/rCzOTxZdrEaH6S0OQcUa17QTJIeR/r9DkoVAjUXmo1YbCviTsTVxUU1gL/d3oLiGlIE9YiFjxanS3R42aLhWIW0mMmw/ZWUVwGk4LWo0gKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pca3x0Qp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pca3x0Qp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF051F000E9;
	Mon, 29 Jun 2026 04:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708933;
	bh=laL/K2nP+TX1KtEzT+kpdpeI88X5XcFhpgprXhHb/YI=;
	h=Date:To:From:Subject;
	b=Pca3x0Qp/eemTy88molkqvJa0TjO4xV5oZmXmXoatrblIaUod1o8uxFFUXHab1iig
	 Fs6qvt/fcj3nzavtx3gll+v7ljQUgFh5enn+2d3qkdERz0LMNj12Vdvswpe/LXGzhY
	 Tk2MsgyzD429XlR1AMDmZTo57+xWZHMqCwsvRP/8=
Date: Sun, 28 Jun 2026 21:55:32 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch added to mm-new branch
Message-Id: <20260629045533.4CF051F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: kobject_del() scheme quota goal dirs
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch

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
Subject: mm/damon/sysfs-schemes: kobject_del() scheme quota goal dirs
Date: Sun, 28 Jun 2026 15:01:15 -0700

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for scheme quota goal directories by adding kobject_del()
calls.

Link: https://lore.kernel.org/20260628220121.97360-7-sj@kernel.org
Fixes: 7f262da0a30d ("mm/damon/sysfs-schemes: implement files for scheme quota goals setup")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.8.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs
+++ a/mm/damon/sysfs-schemes.c
@@ -1463,8 +1463,10 @@ static void damos_sysfs_quota_goals_rm_d
 	struct damos_sysfs_quota_goal **goals_arr = goals->goals_arr;
 	int i;
 
-	for (i = 0; i < goals->nr; i++)
+	for (i = 0; i < goals->nr; i++) {
+		kobject_del(&goals_arr[i]->kobj);
 		kobject_put(&goals_arr[i]->kobj);
+	}
 	goals->nr = 0;
 	kfree(goals_arr);
 	goals->goals_arr = NULL;
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

