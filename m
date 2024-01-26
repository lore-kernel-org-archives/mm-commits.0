Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6031C11
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235351; cv=none; b=q9SScfVBxotGOO+xvyRhWc/3O2IdIHstHwNASq31dhN9lRdeOZMZY5k28UGAmFzNjOOLPEk5QQmh0Taq2sHcbEHORWAej44xwHxMf0DAG7DEpIQesf7gaPYKuB759w64qbFgEY8VqfoicJd4X0tRbEzt3VwTPsaiVal1hOz7AHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235351; c=relaxed/simple;
	bh=x5zY4zvXXLAmVEpDyGFam50Q9yXnqbvVcRZFCqnXtfs=;
	h=Date:To:From:Subject:Message-Id; b=jpLA5cbYlRrEJPHoJ8G7w2/SCSmWCuMJa3w0RMRRJKkEM5b1aHUwEKhYDOdUKh3cHCnHoPgZj1YCA371cFIyuATdVu6U02lJupsFqIWPZ9189cIisg2hw8c/nZEbXo+8v2ECnbUDi6baHCl55AK/gBOpDSFqJK4B8lPJN+eQW9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D5ExNYDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D5ExNYDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DF9C433F1;
	Fri, 26 Jan 2024 02:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235351;
	bh=x5zY4zvXXLAmVEpDyGFam50Q9yXnqbvVcRZFCqnXtfs=;
	h=Date:To:From:Subject:From;
	b=D5ExNYDWb0M6HW79qLKFGJhBWMoTuUin+b1xT4H0xQwvZJExfQmyL53qyql3pWL+b
	 h0ZLor2S6qXOs4EJPwpZrV4PesfHLEAOeCfVuDCs2YbIvo7rF852fNuu0Y7Fk3jG1w
	 DoE3eI32qolYnMSLjjUhYVofPSM5GNav1SEN22jY=
Date: Thu, 25 Jan 2024 18:15:47 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch added to mm-nonmm-unstable branch
Message-Id: <20240126021550.A9DF9C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: run_vmtests: remove sudo and conform to tap
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: run_vmtests: remove sudo and conform to tap
Date: Thu, 25 Jan 2024 20:46:05 +0500

Remove sudo as some test running environments may not have sudo available.
Instead skip the test if root privileges aren't available in the test.

Link: https://lkml.kernel.org/r/20240125154608.720072-3-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/on-fault-limit.c |   38 ++++++++----------
 tools/testing/selftests/mm/run_vmtests.sh   |    2 
 2 files changed, 19 insertions(+), 21 deletions(-)

--- a/tools/testing/selftests/mm/on-fault-limit.c~selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap
+++ a/tools/testing/selftests/mm/on-fault-limit.c
@@ -5,40 +5,38 @@
 #include <string.h>
 #include <sys/time.h>
 #include <sys/resource.h>
+#include "../kselftest.h"
 
-static int test_limit(void)
+static void test_limit(void)
 {
-	int ret = 1;
 	struct rlimit lims;
 	void *map;
 
-	if (getrlimit(RLIMIT_MEMLOCK, &lims)) {
-		perror("getrlimit");
-		return ret;
-	}
-
-	if (mlockall(MCL_ONFAULT | MCL_FUTURE)) {
-		perror("mlockall");
-		return ret;
-	}
+	if (getrlimit(RLIMIT_MEMLOCK, &lims))
+		ksft_exit_fail_msg("getrlimit: %s\n", strerror(errno));
+
+	if (mlockall(MCL_ONFAULT | MCL_FUTURE))
+		ksft_exit_fail_msg("mlockall: %s\n", strerror(errno));
 
 	map = mmap(NULL, 2 * lims.rlim_max, PROT_READ | PROT_WRITE,
 		   MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
+
+	ksft_test_result(map == MAP_FAILED, "Failed mmap\n");
+
 	if (map != MAP_FAILED)
-		printf("mmap should have failed, but didn't\n");
-	else {
-		ret = 0;
 		munmap(map, 2 * lims.rlim_max);
-	}
-
 	munlockall();
-	return ret;
 }
 
 int main(int argc, char **argv)
 {
-	int ret = 0;
+	ksft_print_header();
+	ksft_set_plan(1);
+
+	if (getuid())
+		ksft_test_result_skip("Require root privileges to run\n");
+	else
+		test_limit();
 
-	ret += test_limit();
-	return ret;
+	ksft_finished();
 }
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -301,7 +301,7 @@ echo "$nr_hugepgs" > /proc/sys/vm/nr_hug
 
 CATEGORY="compaction" run_test ./compaction_test
 
-CATEGORY="mlock" run_test sudo -u nobody ./on-fault-limit
+CATEGORY="mlock" run_test ./on-fault-limit
 
 CATEGORY="mmap" run_test ./map_populate
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-mremap_test-fix-build-warning.patch
selftests-mm-switch-to-bash-from-sh.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch

