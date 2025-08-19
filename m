Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5D426D4CF
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 23:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646605; cv=none; b=ev8nuCnMBQgNC4wEvFLHZpECLL26YajncrCMyqhxqtodlCiYVDriqQuz1Uis1W//+R2tT6xBB8sfw6ucrUh3XSQKl6b6JvwheViHtu/meBRRtDeBjKURXdbLDuMG5qvYxHJ4xutIGaLgKwR4OTU3zjKSrUO0gCZcNjq78QS7BhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646605; c=relaxed/simple;
	bh=B/EjAsNl5c102qX/qWONmFQkuFUuaQAZhZ2LjuX10e4=;
	h=Date:To:From:Subject:Message-Id; b=rzzWY+hD03ezJCXeL2s3HcFAzygz3A0xJs3vASoFg0uxVcmDXaLpR17xcPKZ5vtFkAr+NpmsvX6WNP59gjuTJwoYMCaAM2jX2elrT3ZoqgeF6uZypKjUVs4ikhEL/lcAMTdF4icO+kG16e8tnQuFWvsKRYu3cJEj2hqVVsWZoz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iKlSTVeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iKlSTVeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E87AC4CEF1;
	Tue, 19 Aug 2025 23:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646604;
	bh=B/EjAsNl5c102qX/qWONmFQkuFUuaQAZhZ2LjuX10e4=;
	h=Date:To:From:Subject:From;
	b=iKlSTVeLz25Hh4hirzJzlR1BTrd8TUQmRFsy1KhRCJ9mPHkv/IO4CkV+syt1B8/+K
	 OKGOhwzjxIjv4fc2f4NM5R7C5fDlhN+sR8XNpgIP0l3X1BU2ODrRZ5A7/Y32ggrUn9
	 t0VNE4VVRsw7laROPA2ar/dYtAnhm8JpVMQ85MBs=
Date: Tue, 19 Aug 2025 16:36:44 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,alexghiti@rivosinc.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-damon-fix-selftests-by-installing-drgn-related-script.patch removed from -mm tree
Message-Id: <20250819233644.9E87AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: fix selftests by installing drgn related script
has been removed from the -mm tree.  Its filename was
     selftests-damon-fix-selftests-by-installing-drgn-related-script.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: selftests/damon: fix selftests by installing drgn related script
Date: Tue, 12 Aug 2025 23:00:46 +0900

drgn_dump_damon_status is not installed during kselftest setup.  It can
break other tests which depend on drgn_dump_damon_status.  Install
drgn_dump_damon_status files to fix broken test.

Link: https://lkml.kernel.org/r/20250812140046.660486-1-ekffu200098@gmail.com
Fixes: f3e8e1e51362 ("selftests/damon: add drgn script for extracting damon status")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/Makefile~selftests-damon-fix-selftests-by-installing-drgn-related-script
+++ a/tools/testing/selftests/damon/Makefile
@@ -4,6 +4,7 @@
 TEST_GEN_FILES += access_memory access_memory_even
 
 TEST_FILES = _damon_sysfs.py
+TEST_FILES += drgn_dump_damon_status.py
 
 # functionality tests
 TEST_PROGS += sysfs.sh
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window.patch
mm-damon-update-expired-description-of-damos_action.patch
docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch
selftests-damon-test-no-op-commit-broke-damon-status.patch
selftests-damon-test-no-op-commit-broke-damon-status-fix.patch
mm-damon-tests-core-kunit-add-damos_commit_filter-test.patch

