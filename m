Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DEC63B3
	for <mm-commits@vger.kernel.org>; Fri,  9 Feb 2024 21:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707515947; cv=none; b=gjjyLT/SPj9bLAP6clM1aH3mtfQrh3f4p45bq1X5LUA8B4fNSX76gDp19/XzfRfGaWlNdsX2QLOd2xtbdLcXR6bC837MbcdXTkxTe8ok362kKkIvT3YPfFAllBfZ4uFxrCgf6wpnZviDqOfINdzWK9Okfn5MjVoPjinP9fverXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707515947; c=relaxed/simple;
	bh=XuanXdMpk689+b91u25LXWI7ERrWMGi8F8UuvAhZq7U=;
	h=Date:To:From:Subject:Message-Id; b=c/yQmheUpiDy2HQL1iH8XcyJsZ39Bai8uXYeV0h864mSDhdV+M6adesqEXKEcQ5cu1YSI+mFKjAZwPA4MOB/7WkTZyUDFiwOmyZDuGXv2LCEnFO9hZ5/UgR2+RitKNrhrs5YKQKe5s+20yd8RL9MlGqG+TS25oyfr9+skYbjJk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ym3ao+IK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ym3ao+IK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4D6C433F1;
	Fri,  9 Feb 2024 21:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707515946;
	bh=XuanXdMpk689+b91u25LXWI7ERrWMGi8F8UuvAhZq7U=;
	h=Date:To:From:Subject:From;
	b=ym3ao+IK2Rt6FiMW+MMYCFU+Ipk6cauVwJrS/xwqK01lLXZe79MGexF0ZHbLRCDWa
	 aLpfTOFIQYYch3Vr74m5K+navkb1X40Cf93gU6QwKyeGxULS1pG5ixN/uBrOkg6osS
	 TqoJsnxL6MuVAdglJcVCIgDzy9Hm13691bMbTqRM=
Date: Fri, 09 Feb 2024 13:59:05 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-dont-needlessly-use-sudo-to-obtain-root-in-run_vmtestssh.patch added to mm-nonmm-unstable branch
Message-Id: <20240209215906.7A4D6C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: don't needlessly use sudo to obtain root in run_vmtests.sh
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-mm-dont-needlessly-use-sudo-to-obtain-root-in-run_vmtestssh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-dont-needlessly-use-sudo-to-obtain-root-in-run_vmtestssh.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: don't needlessly use sudo to obtain root in run_vmtests.sh
Date: Fri, 09 Feb 2024 20:21:52 +0000

When opening yama/ptrace_scope we unconditionally use sudo to ensure we
are running as root, resulting in failures if running in a minimal root
filesystem where sudo is not installed.  Since automated test systems will
typically just run all of kselftest as root (and many kselftests rely on
this for full functionality) add a check to see if we're already root and
only invoke sudo if not.

Since I am unclear what the intended effect of the command being run is I
have not added any error handling for the case where we fail to obtain
root.

Link: https://lkml.kernel.org/r/20240209-kselftest-mm-check-deps-v1-1-19b09b151522@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-dont-needlessly-use-sudo-to-obtain-root-in-run_vmtestssh
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -248,6 +248,17 @@ run_test() {
 
 echo "TAP version 13" | tap_output
 
+HAVE_ROOT=0
+if [ "$(id -u)" = "0" ]; then
+	AS_ROOT=
+	HAVE_ROOT=1
+elif [ "$(command -v sudo)" != "" ]; then
+	AS_ROOT=sudo
+	HAVE_ROOT=1
+else
+	echo # WARNING: Unable to run as root
+fi
+
 CATEGORY="hugetlb" run_test ./hugepage-mmap
 
 shmmax=$(cat /proc/sys/kernel/shmmax)
@@ -363,7 +374,8 @@ CATEGORY="hmm" run_test bash ./test_hmm.
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
-(echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
+# FIXME: What if we can't get root?
+(echo 0 | ${AS_ROOT} tee /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
 CATEGORY="memfd_secret" run_test ./memfd_secret
 
 # KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-dont-needlessly-use-sudo-to-obtain-root-in-run_vmtestssh.patch

