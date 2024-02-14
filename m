Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C62332189
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 18:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707936875; cv=none; b=SXI6owpQFrPXg1PEzD0EhwpZGtSY1v4sUh+ORx7H0x2EnGRcVWVPEyJutt9jhCSnaQiHPcbfIRvwj+MfcDGtDyayc7mQeHmeWqlYVsdKIGfYC2NH1VO7Gm/91caJZix0lXYu0395/muxfOFHVxNMVZSccI7VMlX2ocSWqiu1P0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707936875; c=relaxed/simple;
	bh=21j1nMfMaFWfGs8VSiQrVL47cLmhMjk1K27F56E4LO8=;
	h=Date:To:From:Subject:Message-Id; b=JrYERyymNhBy2jqR2r5J3SVeR8MS0THBfqZ2KKip5v4b+UW5G1d6ShIKazsz+SxdJkKZwDfI0lE2ECF+SnRkt+9iMH8eNGr+ZKY1RFlC3dJ4U0EXlvilOa+OxiOTe7PtXb2NK8Kv8WHPe7/MByN0Wpuea+w2Oxatw5kekREET+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TBiwmWgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TBiwmWgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93364C433F1;
	Wed, 14 Feb 2024 18:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707936874;
	bh=21j1nMfMaFWfGs8VSiQrVL47cLmhMjk1K27F56E4LO8=;
	h=Date:To:From:Subject:From;
	b=TBiwmWggWY/akTRc3td28G31KbtM3XuBct0SEundFndGWRrMOiMSpM6ji5IZC8kp1
	 xpipCrGn5pkSYEYY0xej0ADtHqbcDUoGLOF7hZ3l8JFsd/JRRs8Dr8xFezSv1L1nYw
	 JesAkuSPjSn6APv2V1ZIWP+j96EgWoCJyPHCY5a8=
Date: Wed, 14 Feb 2024 10:54:34 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-handle-schemes-sysfs-dir-removal-before-commit_schemes_quota_goals.patch added to mm-hotfixes-unstable branch
Message-Id: <20240214185434.93364C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: handle schemes sysfs dir removal before commit_schemes_quota_goals
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-handle-schemes-sysfs-dir-removal-before-commit_schemes_quota_goals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-handle-schemes-sysfs-dir-removal-before-commit_schemes_quota_goals.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: handle schemes sysfs dir removal before commit_schemes_quota_goals
Date: Mon, 12 Feb 2024 18:36:32 -0800

'commit_schemes_quota_goals' command handler,
damos_sysfs_set_quota_scores() assumes the number of schemes sysfs
directory will be same to the number of schemes of the DAMON context.  The
assumption is wrong since users can remove schemes sysfs directories while
DAMON is running.  In the case, illegal memory accesses can happen.  Fix
it by checking the case.

Link: https://lkml.kernel.org/r/20240213023633.124928-1-sj@kernel.org
Fixes: d91beaa505a0 ("mm/damon/sysfs-schemes: implement a command for scheme quota goals only commit")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-handle-schemes-sysfs-dir-removal-before-commit_schemes_quota_goals
+++ a/mm/damon/sysfs-schemes.c
@@ -1905,6 +1905,10 @@ void damos_sysfs_set_quota_scores(struct
 	damon_for_each_scheme(scheme, ctx) {
 		struct damon_sysfs_scheme *sysfs_scheme;
 
+		/* user could have removed the scheme sysfs dir */
+		if (i >= sysfs_schemes->nr)
+			break;
+
 		sysfs_scheme = sysfs_schemes->schemes_arr[i];
 		damos_sysfs_set_quota_score(sysfs_scheme->quotas->goals,
 				&scheme->quota);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch
mm-damon-sysfs-schemes-handle-schemes-sysfs-dir-removal-before-commit_schemes_quota_goals.patch
docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch
mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible.patch
selftests-damon-_damon_sysfs-support-damos-quota.patch
selftests-damon-_damon_sysfs-support-damos-stats.patch
selftests-damon-_damon_sysfs-support-damos-apply-interval.patch
selftests-damon-add-a-test-for-damos-quota.patch
selftests-damon-add-a-test-for-damos-apply-intervals.patch
selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate.patch
selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write.patch
selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts.patch

