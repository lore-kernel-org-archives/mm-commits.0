Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743A5361662
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 10:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777025183; cv=none; b=CeIAeWBCzD5ICRTCn+C2ye3JvzY14v7+TJ+FkkYYwWqJC9Cc9Jtp/0Ly3uMJtSwc9lOyHzydDIW5MA02PqLKkk/apcx6QZBb/j9PWEqQZdDrO4X+NGeT7XW1gpDSIIpMmQC0d2+S2B65jI8Zp9+Mh6+BK4ZKAXSfCOeBQO/gUe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777025183; c=relaxed/simple;
	bh=71NeRC88xuDfvD+jJbb63393mbpEnqSd3hJs85I784w=;
	h=Date:To:From:Subject:Message-Id; b=mxVWyxa3wFcjaROdfDBMfWr1eDtQgtrtu1Ca/XBpLNGElCxtbSmkboj6pxVRxETMKo6YDEtu2WDUrbcduykMRbAkzWli7FFcCih+BZwEfK825GQgyJ1xoW7MTWkOxCSFW1A63yl4suYwkmq5xlbJI0nj4qEai/hf0KC3j/knkbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YJy00t8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YJy00t8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D88CC19425;
	Fri, 24 Apr 2026 10:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777025183;
	bh=71NeRC88xuDfvD+jJbb63393mbpEnqSd3hJs85I784w=;
	h=Date:To:From:Subject:From;
	b=YJy00t8XfsBCGJlIcHAbquob6YroF1cfNUhPg9mG5cD9homOG15hJnGmzR7t5MLK0
	 SdmtW9KEKckqe0L1p+zFDbRHn1QGZdIXeLMydkLktAPTfwZ0XZt/fNO0X9w9Q6xfIt
	 maTNoymv7vl8nqrBqH3jTBMqyatFSJ310WKKWT3w=
Date: Fri, 24 Apr 2026 03:06:22 -0700
To: mm-commits@vger.kernel.org,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-use-runtime-page-size-for-zswpin-check.patch added to mm-new branch
Message-Id: <20260424100623.0D88CC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/cgroup: use runtime page size for zswpin check
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-use-runtime-page-size-for-zswpin-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-use-runtime-page-size-for-zswpin-check.patch

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
Subject: selftests/cgroup: use runtime page size for zswpin check
Date: Fri, 24 Apr 2026 12:00:54 +0800

test_zswapin compares memory.stat:zswpin (counted in pages) against a byte
threshold converted with PAGE_SIZE.  In cgroup selftests, PAGE_SIZE is
hardcoded to 4096, which makes the conversion wrong on systems with non-4K
base pages (e.g.  64K).

As a result, the test requires too many pages to pass and fails spuriously
even when zswap is working.

Use sysconf(_SC_PAGESIZE) for the zswpin threshold conversion so the check
matches the actual system page size.

Link: https://lore.kernel.org/20260424040059.12940-4-li.wang@linux.dev
Signed-off-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
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

 tools/testing/selftests/cgroup/test_zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-use-runtime-page-size-for-zswpin-check
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -245,7 +245,7 @@ static int test_zswapin(const char *root
 		goto out;
 	}
 
-	if (zswpin < MB(24) / PAGE_SIZE) {
+	if (zswpin < MB(24) / sysconf(_SC_PAGESIZE)) {
 		ksft_print_msg("at least 24MB should be brought back from zswap\n");
 		goto out;
 	}
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

