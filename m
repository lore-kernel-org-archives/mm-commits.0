Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3431DDE9;
	Fri,  6 Dec 2024 03:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457320; cv=none; b=TXFPNsbN+CQ8h8xKr3dE2L0XEcYuPa5Q6ODZ4ybPdKydo/1TfTW5OgICQQzceBnozoLQHWhrACJLuclHa2/w+4anIpAoHKBHC5s0I2R8owknF0GBTb8ArI9rTAlvEomHGBb6h4OMPIjStpkJAGZLoa5tk4qx+YrWBk6X9vsWtR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457320; c=relaxed/simple;
	bh=DPHE5zmk87OnS/hVDQyDW7S9W8I29C+6MOHGxObdhAU=;
	h=Date:To:From:Subject:Message-Id; b=KKDBz0VJbIRhauU3Snoo0wzRRYCc+mF/NBymhHPNWkOZdVWPd+NVpkUFnA571MBHN3SMkd7ErKCJ1rcKC6NekJVXqTyMfxuub0MMg4II+fmtZI3kwI2P+QDnwzZdBkU++aQdNiuhzsDaFRGSvez8G2vxmIi0TH9AJprwUg8QpAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wqI1moNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wqI1moNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DC9C4CED2;
	Fri,  6 Dec 2024 03:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457320;
	bh=DPHE5zmk87OnS/hVDQyDW7S9W8I29C+6MOHGxObdhAU=;
	h=Date:To:From:Subject:From;
	b=wqI1moNGGUO6nPVJYxJt+adHusJw3KYJAhQlp10Fotks0WI1QKgQT/4zNm2Waf3SP
	 kgv/ZJfiGd6O4oz5qDxpVkOvv4D+10GtDcFLtYfDf1bMlSUzFKJMYu+ybQ7C+Nxi0n
	 txqhX7TYVhMeTSHiC2dWfZRn7G5Vi5Jfc3XV0V9k=
Date: Thu, 05 Dec 2024 19:55:19 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,shuah@kernel.org,mheyne@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-damon-add-_damon_sysfspy-to-test_files.patch removed from -mm tree
Message-Id: <20241206035520.70DC9C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: add _damon_sysfs.py to TEST_FILES
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-_damon_sysfspy-to-test_files.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Maximilian Heyne <mheyne@amazon.de>
Subject: selftests/damon: add _damon_sysfs.py to TEST_FILES
Date: Wed, 27 Nov 2024 12:08:53 +0000

When running selftests I encountered the following error message with
some damon tests:

 # Traceback (most recent call last):
 #   File "[...]/damon/./damos_quota.py", line 7, in <module>
 #     import _damon_sysfs
 # ModuleNotFoundError: No module named '_damon_sysfs'

Fix this by adding the _damon_sysfs.py file to TEST_FILES so that it
will be available when running the respective damon selftests.

Link: https://lkml.kernel.org/r/20241127-picks-visitor-7416685b-mheyne@amazon.de
Fixes: 306abb63a8ca ("selftests/damon: implement a python module for test-purpose DAMON sysfs controls")
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/Makefile~selftests-damon-add-_damon_sysfspy-to-test_files
+++ a/tools/testing/selftests/damon/Makefile
@@ -6,7 +6,7 @@ TEST_GEN_FILES += debugfs_target_ids_rea
 TEST_GEN_FILES += debugfs_target_ids_pid_leak
 TEST_GEN_FILES += access_memory access_memory_even
 
-TEST_FILES = _chk_dependency.sh _debugfs_common.sh
+TEST_FILES = _chk_dependency.sh _debugfs_common.sh _damon_sysfs.py
 
 # functionality tests
 TEST_PROGS = debugfs_attrs.sh debugfs_schemes.sh debugfs_target_ids.sh
_

Patches currently in -mm which might be from mheyne@amazon.de are


