Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A5675818
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942881; cv=none; b=jzSuQS1S59S/EGeN3VF2NfjEL9G2wEmonUCVqDDLnZRTuPtoEAR4ZpRdbs6An5IixcPjo6Q4v2XcngmJXwph/YRvYV2x6g2J4Qvs5qQI2UbZSqUgWJiQFmQnErBDhCfuv5tR1fXmF4To0hY0X94VsaMCBVLld/2rcp7VkxRIbU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942881; c=relaxed/simple;
	bh=g8vyXn30/issdzFYlp0/fJ3cVq7Xb4ut7nsqoJn6YaI=;
	h=Date:To:From:Subject:Message-Id; b=mc2rxMyOtTuPguxABJYucpn1N4AsPMBTqIWJMkedg+Y9RlOgFLBj+GZSVFfhsro1kyj31bZw0QS+KSEPCNvyDj1CIpz1MXPNrggqjlRIkcuu/+RZqE4egM/8mYcBX9eMdLc/SItNKq/R7Lp320UsaucgmPvTaDbfyWmhpZm5jzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qUjScJQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qUjScJQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0000FC113CC;
	Sun,  5 May 2024 21:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942881;
	bh=g8vyXn30/issdzFYlp0/fJ3cVq7Xb4ut7nsqoJn6YaI=;
	h=Date:To:From:Subject:From;
	b=qUjScJQRcaQhfq5dZauoOxp4OReP8kbVj0s78EVXoeKO8mily/s0Xo1uvIXGimHXR
	 QQ6ZKyI1OYRk9cKUjDqTwm4dmtq0VYN50hp1yTC8UhauRkKJ1rNPeGQB65XPbQOFyY
	 yft8JZQjjdXR+KRPvLInQz8qlGmtAcPY7Xk+urhQ=
Date: Sun, 05 May 2024 14:01:20 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch added to mm-unstable branch
Message-Id: <20240505210121.0000FC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: find sysfs mount point from /proc/mounts
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch

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
Subject: selftests/damon/_damon_sysfs: find sysfs mount point from /proc/mounts
Date: Fri, 3 May 2024 11:03:11 -0700

_damon_sysfs.py assumes sysfs is mounted at /sys.  In some systems, that
might not be true.  Find the mount point from /proc/mounts file content.

Link: https://lkml.kernel.org/r/20240503180318.72798-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -2,7 +2,18 @@
 
 import os
 
-sysfs_root = '/sys/kernel/mm/damon/admin'
+ksft_skip=4
+
+sysfs_root = None
+with open('/proc/mounts', 'r') as f:
+    for line in f:
+        dev_name, mount_point, dev_fs = line.split()[:3]
+        if dev_fs == 'sysfs':
+            sysfs_root = '%s/kernel/mm/damon/admin' % mount_point
+            break
+if sysfs_root is None:
+    print('Seems sysfs not mounted?')
+    exit(ksft_skip)
 
 def write_file(path, string):
     "Returns error string if failed, or None otherwise"
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-paddr-implement-damon_folio_young.patch
mm-damon-paddr-implement-damon_folio_mkold.patch
mm-damon-add-damos-filter-type-young.patch
mm-damon-paddr-implement-damos-filter-type-young.patch
docs-mm-damon-design-document-young-page-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch
docs-abi-damon-update-for-youg-page-type-damos-filter.patch
mm-damon-paddr-avoid-unnecessary-page-level-access-check-for-pageout-damos-action.patch
mm-damon-paddr-do-page-level-access-check-for-pageout-damos-action-on-its-own.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_pages.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_folio_list.patch
selftests-damon-_damon_sysfs-support-quota-goals.patch
selftests-damon-add-a-test-for-damos-quota-goal.patch
mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch
selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch
selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch
selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch
selftests-damon-classify-tests-for-functionalities-and-regressions.patch
docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch
docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch
docs-mm-damon-design-use-a-list-for-supported-filters.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

