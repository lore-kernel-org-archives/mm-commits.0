Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C104EB49
	for <mm-commits@vger.kernel.org>; Mon, 12 Feb 2024 23:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707779724; cv=none; b=rJ7F5Vvvuvfj/T9kQBGWTMDUtZWGL1ydmCF1BtPbircKm7mWP1QSDlZClCNstH6arhw5b4v/QW2fdgkgZCd595YkIe4+B40swSMDzFq2WVqO7lql2R5OfI4eWIZ9aztuylI8TeHWJYuUfbqFPGIpqN+0JYr0wphcjWmFOUu20VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707779724; c=relaxed/simple;
	bh=YVtBG7MMqHpvKOKroRMCGfkwAvGF+D+6AyATUsn25c8=;
	h=Date:To:From:Subject:Message-Id; b=sxn5M9btiXA6dF5b6qN3JQ4yQXq/iwOvzJ7Kpg1lRlQQBQbTzDRIlAZgVgWrdxzU3AFB6RXwZkDqZAm/qpSEIEJ6ZEyVXuootlvmYEakpiCC9ghMjRDIUkZssO6oCpH+vYSZDOCdiTvJExToIpyc8HkUOaw/O0OA/sllIIbaMZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=156TJ1QM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="156TJ1QM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9390BC433F1;
	Mon, 12 Feb 2024 23:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707779723;
	bh=YVtBG7MMqHpvKOKroRMCGfkwAvGF+D+6AyATUsn25c8=;
	h=Date:To:From:Subject:From;
	b=156TJ1QMMl1LezasibMvlP10DDe31k+tp6RohGTy0CmI2fFhVPAm9cpa62EPmzleV
	 e/LJV534mh2uBL4JZZrLdiFu61uWet8Un5ufpH0m3fjuM8+oZKiy7dzUZHIXkLqnpL
	 maAPHboG57uV/CKwGQ+RWIwLpesbOklSJA5jvlG8=
Date: Mon, 12 Feb 2024 15:15:23 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] selftests-mm-dont-needlessly-use-sudo-to-obtain-root-in-run_vmtestssh.patch removed from -mm tree
Message-Id: <20240212231523.9390BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: don't needlessly use sudo to obtain root in run_vmtests.sh
has been removed from the -mm tree.  Its filename was
     selftests-mm-dont-needlessly-use-sudo-to-obtain-root-in-run_vmtestssh.patch

This patch was dropped because an alternative patch was or shall be merged

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
@@ -237,6 +237,17 @@ run_test() {
 
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
@@ -351,7 +362,8 @@ CATEGORY="hmm" run_test bash ./test_hmm.
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
-(echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
+# FIXME: What if we can't get root?
+(echo 0 | ${AS_ROOT} tee /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
 CATEGORY="memfd_secret" run_test ./memfd_secret
 
 # KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-log-skipped-compaction-test-as-a-skip.patch
selftests-mm-log-a-consistent-test-name-for-check_compaction.patch

