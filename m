Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5730D75818
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942883; cv=none; b=HHS89GBTlyGMfHg/lLvkkCWfMiXWOv9Tm2FhryJ6CxHUqQeYyWq+cNRJG2UrpfjtijXpxIxMiNdXwiInXA8R7BE7BM/YU7jlJGREobsysYj/mgRWkXBrONonhz1xVJnfKA+Zt24LKjtPpGrkCBXdKFIiDfmXnURS/Qq/tgddwhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942883; c=relaxed/simple;
	bh=hWGmBA4Ks/IHqUoWDlgPC48Lp02aXE8iFuWcde9p+js=;
	h=Date:To:From:Subject:Message-Id; b=MZj3KYOlAa3+KfWOLtExMmCKCvJke2BbCnznZDsSMoXdI/N0JPZrlaepR8brxDBZPeBsE1eZ/iRBH+3idEumAlJgEm6EoqmM+z9jeiiz2nPRnujPW7yIlfoqpAp3JjUcsVIphZMm2mhiXN5m96DJSS54EMVbpIMlQKsDvW2boEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WG3JglBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WG3JglBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C465DC113CC;
	Sun,  5 May 2024 21:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942882;
	bh=hWGmBA4Ks/IHqUoWDlgPC48Lp02aXE8iFuWcde9p+js=;
	h=Date:To:From:Subject:From;
	b=WG3JglBz3VWmko9Sy/DhJX3uQeXINr90BA+n2oV2kVRZgIvdEqtYsQ48GrH/5hb/V
	 uofKJ1InlD2iPFsvpR0nXtTQvavA5IAL+/eOfQ0qBCRTYmQYmifdQ7gKplRBb/8VL1
	 OkpMkokXD1f/SVT8PFKbbNEAWkFLBizY6rrCbIi8=
Date: Sun, 05 May 2024 14:01:22 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-classify-tests-for-functionalities-and-regressions.patch added to mm-unstable branch
Message-Id: <20240505210122.C465DC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: classify tests for functionalities and regressions
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-classify-tests-for-functionalities-and-regressions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-classify-tests-for-functionalities-and-regressions.patch

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
Subject: selftests/damon: classify tests for functionalities and regressions
Date: Fri, 3 May 2024 11:03:13 -0700

DAMON selftests can be classified into two categories: functionalities and
regressions.  Functionality tests are for checking if the function is
working as specified, while the regression tests are basically reproducers
of previously reported and fixed bugs.  The tests of the categories are
mixed in the selftests Makefile.  Separate those for easier understanding
of the types of tests.

Link: https://lkml.kernel.org/r/20240503180318.72798-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/damon/Makefile~selftests-damon-classify-tests-for-functionalities-and-regressions
+++ a/tools/testing/selftests/damon/Makefile
@@ -7,16 +7,21 @@ TEST_GEN_FILES += debugfs_target_ids_pid
 TEST_GEN_FILES += access_memory
 
 TEST_FILES = _chk_dependency.sh _debugfs_common.sh
+
+# functionality tests
 TEST_PROGS = debugfs_attrs.sh debugfs_schemes.sh debugfs_target_ids.sh
+TEST_PROGS += sysfs.sh
+TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
+TEST_PROGS += damos_quota.py damos_quota_goal.py damos_apply_interval.py
+TEST_PROGS += reclaim.sh lru_sort.sh
+
+# regression tests (reproducers of previously found bugs)
 TEST_PROGS += debugfs_empty_targets.sh debugfs_huge_count_read_write.sh
 TEST_PROGS += debugfs_duplicate_context_creation.sh
 TEST_PROGS += debugfs_rm_non_contexts.sh
 TEST_PROGS += debugfs_target_ids_read_before_terminate_race.sh
 TEST_PROGS += debugfs_target_ids_pid_leak.sh
-TEST_PROGS += sysfs.sh sysfs_update_removed_scheme_dir.sh
+TEST_PROGS += sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
-TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
-TEST_PROGS += damos_quota.py damos_quota_goal.py damos_apply_interval.py
-TEST_PROGS += reclaim.sh lru_sort.sh
 
 include ../lib.mk
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

