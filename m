Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2064B19A281
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801602; cv=none; b=GOlPEG3ERPmC4nRYm3Rul6Lf8w8ylTfskh50wgytcI7Q5iEpH5DmuQky4/VraGMt6JaJg/bs6L2VfSo80RMvLF3r7EPos+FiiA53cECM0Alhu9lYvw1aXfhs4ehJhty1Kxxslqiype10eydCg6TWt8INKptfqmAUh//bwsJtD1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801602; c=relaxed/simple;
	bh=0W9ZR4gsoHHI30cYuAHkFmzLx8Nlqjn24XowZerjek4=;
	h=Date:To:From:Subject:Message-Id; b=D77H9qdmYks7EMmtE1iW+Xpke7TdUhT9+1iPA8K+e9re74sQ1AVeandCmJZQ8iAeWRFgHJXkPjnNkbSZGqxJyTKqqJKCvCkjHjlk1iKcWDoRl7lv7PmjCJuYSkhT+odosbmroQdyS0lXB9oAyOzV7VK6DoNA6Yaen5dXALUJpe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yB4MQ/XH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yB4MQ/XH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D27C4FF7C;
	Tue, 27 Aug 2024 23:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724801602;
	bh=0W9ZR4gsoHHI30cYuAHkFmzLx8Nlqjn24XowZerjek4=;
	h=Date:To:From:Subject:From;
	b=yB4MQ/XHnFh0utlXTlYHhh+vEh3iKMeNLqme8z+DaIxNUFQZauDCoK4JhBxxIU3s8
	 eb97QA+yYR3q6YfqWbE846tetkS7fVAKJWEcxlVoyZBdsgp3Vc8zZ3lC7z4oiOUT6c
	 y7cHoBEfgy7XjmMvpLCVcl41QE3HWIkzl6CBnmYo=
Date: Tue, 27 Aug 2024 16:33:21 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-add-kunitconfig-file-for-damon-kunit-tests.patch added to mm-unstable branch
Message-Id: <20240827233321.E4D27C4FF7C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests: add .kunitconfig file for DAMON kunit tests
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-tests-add-kunitconfig-file-for-damon-kunit-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-add-kunitconfig-file-for-damon-kunit-tests.patch

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
Subject: mm/damon/tests: add .kunitconfig file for DAMON kunit tests
Date: Mon, 26 Aug 2024 20:03:36 -0700

'--kunitconfig' option of 'kunit.py run' supports '.kunitconfig' file name
convention.  Add the file for DAMON kunit tests for more convenient kunit
run.

Link: https://lkml.kernel.org/r/20240827030336.7930-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/.kunitconfig |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/tests/.kunitconfig a/mm/damon/tests/.kunitconfig
new file mode 100644
--- /dev/null
+++ a/mm/damon/tests/.kunitconfig
@@ -0,0 +1,22 @@
+# for DAMON core
+CONFIG_KUNIT=y
+CONFIG_DAMON=y
+CONFIG_DAMON_KUNIT_TEST=y
+
+# for DAMON vaddr ops
+CONFIG_MMU=y
+CONFIG_PAGE_IDLE_FLAG=y
+CONFIG_DAMON_VADDR=y
+CONFIG_DAMON_VADDR_KUNIT_TEST=y
+
+# for DAMON sysfs interface
+CONFIG_SYSFS=y
+CONFIG_DAMON_SYSFS=y
+CONFIG_DAMON_SYSFS_KUNIT_TEST=y
+
+# for DAMON debugfs interface
+CONFIG_DEBUG_FS=y
+CONFIG_DAMON_PADDR=y
+CONFIG_DAMON_DBGFS_DEPRECATED=y
+CONFIG_DAMON_DBGFS=y
+CONFIG_DAMON_DBGFS_KUNIT_TEST=y
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-access_memory_even-to-gitignore.patch
selftests-damon-cleanup-__pycache__-with-make-clean.patch
selftests-damon-add-execute-permissions-to-test-scripts.patch
mm-damon-core-test-test-only-vaddr-case-on-ops-registration-test.patch
mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case.patch
mm-damon-dbgfs-test-skip-dbgfs_set_targets-test-if-paddr-is-not-registered.patch
mm-damon-dbgfs-test-skip-dbgfs_set_init_regions-test-if-paddr-is-not-registered.patch
mm-damon-move-kunit-tests-to-tests-subdirectory-with-_kunit-suffix.patch
mm-damon-tests-add-kunitconfig-file-for-damon-kunit-tests.patch

