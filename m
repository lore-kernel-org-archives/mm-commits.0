Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025CE362153
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 10:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777025179; cv=none; b=lOvaGm30GbL0m12MhIXsJKo208EexdmmRQImUIxBkeRgIr7SYzDLUiQl3DW6PGtmR1mKoxPKrETEUDjsBl3tgI6YSKAl9RZ5RDkLDf3Sb1Mpqod9Z3m8ji70f1HBT0tpuCjVSOXsrDtfqU/FuFKvCfsq62WdqVvqBa3aVMgG4nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777025179; c=relaxed/simple;
	bh=izQHrsjIZLCTCuFYOflMBGHQjN20JpJC0QgslljK/SQ=;
	h=Date:To:From:Subject:Message-Id; b=RovO6Ls1Vx/Cov3raCLVrwERhh/jva/+Rx2STHmETHjZyiFKPbEFFEMQSF1m8P6Kjz02eh8jv21CVKSG4lbxzf5xILr8DsS1l/pvznrI4cY4kYOouNtsYgOAFKmsvOU4mGrpUnxcIyqITa6t8FftBG0yvViwJEkDsH/Gh9v/eUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cqjHh5NO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cqjHh5NO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A20BC19425;
	Fri, 24 Apr 2026 10:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777025178;
	bh=izQHrsjIZLCTCuFYOflMBGHQjN20JpJC0QgslljK/SQ=;
	h=Date:To:From:Subject:From;
	b=cqjHh5NO8N4HqWrl16QVErZ1slR6tpJyuVsLtOfY194q4cjITBKC0CU5DGcLiQl9q
	 SEUcVPv03Mo0wemUQ7FiVzo47LFQQ9sgCll0OVYfSQd1O5yINSKJ2mFsZb6JYq1bhr
	 BLu2PjQiLwOYNZPwmigzBFEsZQoHOsXbDfsIumCI=
Date: Fri, 24 Apr 2026 03:06:17 -0700
To: mm-commits@vger.kernel.org,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-skip-test_zswap-if-zswap-is-globally-disabled.patch added to mm-new branch
Message-Id: <20260424100618.8A20BC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/cgroup: skip test_zswap if zswap is globally disabled
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-skip-test_zswap-if-zswap-is-globally-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-skip-test_zswap-if-zswap-is-globally-disabled.patch

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
From: Li Wang <li.wang@linux.dev>
Subject: selftests/cgroup: skip test_zswap if zswap is globally disabled
Date: Fri, 24 Apr 2026 12:00:52 +0800

Patch series "selftests/cgroup: improve zswap tests robustness and support
large page sizes", v7.

This patchset aims to fix various spurious failures and improve the
overall robustness of the cgroup zswap selftests.

The primary motivation is to make the tests compatible with architectures
that use non-4K page sizes (such as 64K on ppc64le and arm64).  Currently,
the tests rely heavily on hardcoded 4K page sizes and fixed memory limits.
On 64K page size systems, these hardcoded values lead to sub-page
granularity accesses, incorrect page count calculations, and insufficient
memory pressure to trigger zswap writeback, ultimately causing the tests
to fail.

Additionally, this series addresses OOM kills occurring in
test_swapin_nozswap by dynamically scaling memory limits, and prevents
spurious test failures when zswap is built into the kernel but globally
disabled.


This patch (of 8):

test_zswap currently only checks whether zswap is present by testing
/sys/module/zswap.  This misses the runtime global state exposed in
/sys/module/zswap/parameters/enabled.

When zswap is built/loaded but globally disabled, the zswap cgroup
selftests run in an invalid environment and may fail spuriously.

Check the runtime enabled state before running the tests:
  - skip if zswap is not configured,
  - fail if the enabled knob cannot be read,
  - skip if zswap is globally disabled.

Also print a hint in the skip message on how to enable zswap.

Link: https://lore.kernel.org/20260424040059.12940-1-li.wang@linux.dev
Link: https://lore.kernel.org/20260424040059.12940-2-li.wang@linux.dev
Signed-off-by: Li Wang <li.wang@linux.dev>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |   19 ++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-skip-test_zswap-if-zswap-is-globally-disabled
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -15,6 +15,9 @@
 #include "kselftest.h"
 #include "cgroup_util.h"
 
+#define PATH_ZSWAP "/sys/module/zswap"
+#define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
+
 static int read_int(const char *path, size_t *value)
 {
 	FILE *file;
@@ -725,9 +728,18 @@ struct zswap_test {
 };
 #undef T
 
-static bool zswap_configured(void)
+static void check_zswap_enabled(void)
 {
-	return access("/sys/module/zswap", F_OK) == 0;
+	char value[2];
+
+	if (access(PATH_ZSWAP, F_OK))
+		ksft_exit_skip("zswap isn't configured\n");
+
+	if (read_text(PATH_ZSWAP_ENABLED, value, sizeof(value)) <= 0)
+		ksft_exit_fail_msg("Failed to read " PATH_ZSWAP_ENABLED "\n");
+
+	if (value[0] == 'N')
+		ksft_exit_skip("zswap is disabled (hint: echo 1 > " PATH_ZSWAP_ENABLED ")\n");
 }
 
 int main(int argc, char **argv)
@@ -740,8 +752,7 @@ int main(int argc, char **argv)
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
-	if (!zswap_configured())
-		ksft_exit_skip("zswap isn't configured\n");
+	check_zswap_enabled();
 
 	/*
 	 * Check that memory controller is available:
_

Patches currently in -mm which might be from li.wang@linux.dev are

maintainers-update-li-wangs-email-address.patch
selftests-cgroup-skip-test_zswap-if-zswap-is-globally-disabled.patch
selftests-cgroup-avoid-oom-in-test_swapin_nozswap.patch
selftests-cgroup-use-runtime-page-size-for-zswpin-check.patch
selftests-cgroup-rename-page_size-to-buf_size-in-cgroup_util.patch
selftests-cgroup-replace-hardcoded-page-size-values-in-test_zswap.patch
selftest-cgroup-fix-zswap-test_no_invasive_cgroup_shrink-on-large-pagesize-system.patch
selftest-cgroup-fix-zswap-attempt_writeback-on-64k-pagesize-system.patch
selftests-cgroup-test_zswap-wait-for-asynchronous-writeback.patch

