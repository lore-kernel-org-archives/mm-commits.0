Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD16441760
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801581; cv=none; b=Jiv+XH1Xwz7GGwPmyZlTG2cE0/mgej+mdDBxfCS7z4Zn5/CsqWgioX69NeXkw7vq5QthfCpmui+T9AxZPxnmNnTEX6ZWKrfZiRF7OwDZyA2SnddqIgLagYinnh2NtL1ldwhB6cVb9t/NjOZbxlGM7CkUraqaa0KB7PCzSINq4uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801581; c=relaxed/simple;
	bh=EnZmPtKyyOGsV4PUAtEtA9gla1OePRkM2Cm/wKgUQd4=;
	h=Date:To:From:Subject:Message-Id; b=JyI0OH3MJcpLd0TH7Y5FFI0Q65x/3jZc+B9FKqOBhp9Rp9tk8Av3z/eya3sJJtG6hZhgQHf2dBGuG3UTCUoN7VG1/16kILuWsg5sGDBuxs/pO5eJa7EN1dcIaIhr82U0JG/blTC6rhqXzoG4MZJWq8p5OtijnqXUNZge/VTyH3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jtY86HzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jtY86HzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7BAC4FF68;
	Tue, 27 Aug 2024 23:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724801580;
	bh=EnZmPtKyyOGsV4PUAtEtA9gla1OePRkM2Cm/wKgUQd4=;
	h=Date:To:From:Subject:From;
	b=jtY86HzTOccCVPSPi1QjypKfxhQf7Gf2fR5COszgucOLUrOqsil8UupPtUublUdGZ
	 AVpP5FpKbpqHAnGyYK1x1uG+cRsrBKpmzFoJumIjYWQeMzWpLVjbPVzV7go/HS2w8z
	 UUpGk7/D2pZyseh6kh4urcfPHboYLzhp5rjoGHQ0=
Date: Tue, 27 Aug 2024 16:33:00 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-execute-permissions-to-test-scripts.patch added to mm-unstable branch
Message-Id: <20240827233300.8E7BAC4FF68@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: add execute permissions to test scripts
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-add-execute-permissions-to-test-scripts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-execute-permissions-to-test-scripts.patch

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
Subject: selftests/damon: add execute permissions to test scripts
Date: Mon, 26 Aug 2024 20:03:30 -0700

Some test scripts are missing executable permissions.  It causes warnings
that make the test output unnecessarily verbose.  Add executable
permissions.

Link: https://lkml.kernel.org/r/20240827030336.7930-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 0 files changed

diff --git a/tools/testing/selftests/damon/damon_nr_regions.py a/tools/testing/selftests/damon/damon_nr_regions.py
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/damos_apply_interval.py a/tools/testing/selftests/damon/damos_apply_interval.py
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/damos_quota_goal.py a/tools/testing/selftests/damon/damos_quota_goal.py
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/damos_quota.py a/tools/testing/selftests/damon/damos_quota.py
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/damos_tried_regions.py a/tools/testing/selftests/damon/damos_tried_regions.py
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/debugfs_target_ids_pid_leak.sh a/tools/testing/selftests/damon/debugfs_target_ids_pid_leak.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.sh a/tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
old mode 100644
new mode 100755
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

