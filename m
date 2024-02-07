Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11491CD26
	for <mm-commits@vger.kernel.org>; Wed,  7 Feb 2024 22:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707346520; cv=none; b=qCsfcTd+wxJKcxXmLrnxfewdjKKnTmaV+t6IEt5fYj8MwZrp+3zeOYn3ANHDFXa0CnGOgKZZiFZ3TN+V3i2JgBS5kJFc3q2tjkw499tZQFpAw10PHbpp3D58CfTayYD85W38vxC5lnVf89xMBCkjzdpvk9OxOElOb6F4AUsnKZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707346520; c=relaxed/simple;
	bh=POrWWmCfw+dKQgL6vOF+jrynPQKgOzZLd4zCTi/ame8=;
	h=Date:To:From:Subject:Message-Id; b=Wfn+R4qsnXNjg4rX8pYKvPcugI++Qf1mEBPHLIxXRBjI1VkgFATJiR86HKq1ItDBQvXJc51XmjIdvrscapS99mC6SAKBcBnenVit4MdZcwYsKrM4LDY2E+IxWhlQKI4C6hXiaa+s27flMulM0VhnTcpD/O6teWPpOFESvACUXD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LyMoUCvH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LyMoUCvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0316C43390;
	Wed,  7 Feb 2024 22:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707346518;
	bh=POrWWmCfw+dKQgL6vOF+jrynPQKgOzZLd4zCTi/ame8=;
	h=Date:To:From:Subject:From;
	b=LyMoUCvHL/hzVm63VhO9XrTOgEbUDEXpVOP0K8I/oPBw8Kz0oZrMZfwhOSDLNVPBk
	 7n+rgBfBDXjDaHSIvggYOLKasKBN/u0QfwmXsPGOU9zN2gNp9xQ6rfAHb9GEO9eP7o
	 1ApR+jZ1c+W2wrTL9j3xVJKTbBPTgt3nv/eMF8GI=
Date: Wed, 07 Feb 2024 14:55:18 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts.patch added to mm-unstable branch
Message-Id: <20240207225518.B0316C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_chk_dependency: get debugfs mount point from /proc/mounts
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts.patch

This patch will later appear in the mm-unstable branch at
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
Subject: selftests/damon/_chk_dependency: get debugfs mount point from /proc/mounts
Date: Wed, 7 Feb 2024 12:31:34 -0800

DAMON debugfs selftests dependency checker assumes debugfs would be
mounted at /sys/kernel/debug.  That would be ok for many cases, but some
systems might mounted the file system on some different places.  Parse the
real mount point using /proc/mounts file.

Link: https://lkml.kernel.org/r/20240207203134.69976-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_chk_dependency.sh |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_chk_dependency.sh~selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts
+++ a/tools/testing/selftests/damon/_chk_dependency.sh
@@ -4,7 +4,14 @@
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
-DBGFS=/sys/kernel/debug/damon
+DBGFS=$(grep debugfs /proc/mounts --max-count 1 | awk '{print $2}')
+if [ "$DBGFS" = "" ]
+then
+	echo "debugfs not mounted"
+	exit $ksft_skip
+fi
+
+DBGFS+="/damon"
 
 if [ $EUID -ne 0 ];
 then
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-wrong-damos-tried-regions-update-timeout-setup.patch
mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch
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

