Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647B33624CE
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 10:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777025196; cv=none; b=o31+2HWzpU8ME2TMGqYB3p5HB+/0wZ64rY8yDHuDiqk2D+7dbjmVj9plibM2ndvfUKyV0VvahYHvzrstmBRcG6m1bNXbI1hXCqMAC9wBd7AQXcIz9qfPQOXVI3KsyiIP6jvNNW/zp2e8X5PM63PumQEja0hlSc7qSip6HB4deLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777025196; c=relaxed/simple;
	bh=go1/Aoba+PUcmij9feCw5CXACVsWzoc/Mh/LzzISIKk=;
	h=Date:To:From:Subject:Message-Id; b=PRfcKdBkOXF5PRRANDx38NbdWO2F6ruRO+hWPSPb5ThNoiFwglRh17LlwhD5xgS0x5cTUUmkGBbdZnbK1m94+RZnkufnr6W9blb4vKwmakH+Uv23UAsjJ6lXXFtRTk7z+RVF7QTWC4A37nMG8LlbMLs86nFvVNMl+jkfo+S0Znk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SIVTxfX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SIVTxfX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBFFC19425;
	Fri, 24 Apr 2026 10:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777025196;
	bh=go1/Aoba+PUcmij9feCw5CXACVsWzoc/Mh/LzzISIKk=;
	h=Date:To:From:Subject:From;
	b=SIVTxfX694eNtLXD40lRXyJhy0T7QHxRBgBFCxKThO9IqQHjZEScQKCVSWMbzpgIQ
	 Iahm9hfoa2UCVWoKXtNot2+DRQpCd4IGWbvNJ+f7GEPJkqiyCEA3vNq/XvuDzImo6O
	 q1MgeMeyae8M9xPYOGaksGc+THolqPDIN0Vxc4a4=
Date: Fri, 24 Apr 2026 03:06:35 -0700
To: mm-commits@vger.kernel.org,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-test_zswap-wait-for-asynchronous-writeback.patch added to mm-new branch
Message-Id: <20260424100635.EBBFFC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/cgroup: test_zswap: wait for asynchronous writeback
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-test_zswap-wait-for-asynchronous-writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-test_zswap-wait-for-asynchronous-writeback.patch

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
Subject: selftests/cgroup: test_zswap: wait for asynchronous writeback
Date: Fri, 24 Apr 2026 12:00:59 +0800

zswap writeback is asynchronous, but test_zswap.c checks writeback
counters immediately after reclaim/trigger paths.  On some platforms (e.g.
ppc64le), this can race with background writeback and cause spurious
failures even when behavior is correct.

Add wait_for_writeback() to poll get_cg_wb_count() with a bounded
timeout, and use it in:

  test_zswap_writeback_one() when writeback is expected
  test_no_invasive_cgroup_shrink() for the wb_group check

This keeps the original before/after assertion style while making the
tests robust against writeback completion latency.

No test behavior change, selftest stability improvement only.

Link: https://lore.kernel.org/20260424040059.12940-9-li.wang@linux.dev
Signed-off-by: Li Wang <li.wang@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |   28 ++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-wait-for-asynchronous-writeback
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -121,6 +121,27 @@ fail:
 }
 
 /*
+ * Writeback is asynchronous; poll until at least one writeback has
+ * been recorded for @cg, or until @timeout_ms has elapsed.
+ */
+static long wait_for_writeback(const char *cg, int timeout_ms)
+{
+	long elapsed, count;
+	for (elapsed = 0; elapsed < timeout_ms; elapsed += 100) {
+		count = get_cg_wb_count(cg);
+
+		if (count < 0)
+			return -1;
+		if (count > 0)
+			return count;
+
+		usleep(100000);
+	}
+
+	return 0;
+}
+
+/*
  * Sanity test to check that pages are written into zswap.
  */
 static int test_zswap_usage(const char *root)
@@ -345,7 +366,10 @@ static int test_zswap_writeback_one(cons
 		return -1;
 
 	/* Verify that zswap writeback occurred only if writeback was enabled */
-	zswpwb_after = get_cg_wb_count(cgroup);
+	if (wb)
+		zswpwb_after = wait_for_writeback(cgroup, 5000);
+	else
+		zswpwb_after = get_cg_wb_count(cgroup);
 	if (zswpwb_after < 0)
 		return -1;
 
@@ -476,7 +500,7 @@ static int test_no_invasive_cgroup_shrin
 	}
 
 	/* Verify that only zswapped memory from gwb_group has been written back */
-	if (get_cg_wb_count(wb_group) > 0 && get_cg_wb_count(zw_group) == 0)
+	if (wait_for_writeback(wb_group, 5000) > 0 && get_cg_wb_count(zw_group) == 0)
 		ret = KSFT_PASS;
 out:
 	cg_enter_current(root);
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

