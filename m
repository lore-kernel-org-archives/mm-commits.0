Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEC113D50C
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706875961; cv=none; b=Hw29gA2FRIhN6cMFRWdCffr/VCrH1nIdCB6XHudXObMOxykC6daV/m7fAHyujG7Hvih4+dtI32VIhJi5CE6MSAG8OjMonLaMPVPgf0oNh+M4KaBWihg2cSjoD/7aFyNG9jsUNzN3Kd4moKdjQkQ8ilJ0wEvjQi4UCg2Rgpu9vUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706875961; c=relaxed/simple;
	bh=hwN6ddwJe/6aaJ8/NlZQgghxGugW3x8QqP30xJOhUPo=;
	h=Date:To:From:Subject:Message-Id; b=ktYZj2TnlZYQq/1xinFl/91heP39PNJhLjVMhENbPd0qhe35EBWBaDvfqOOzwgnIg6yfL6Va//ltCaP7MJ6bkLYSCqHNc7ZwBkkK3eds9QxaMyFkLqMCjOacdwA1eLyppKEGqKp6jCUtPLAASYjoVTZCUkXun8/ehZgguqqo4eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wa3k9hQ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wa3k9hQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D68C433C7;
	Fri,  2 Feb 2024 12:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706875961;
	bh=hwN6ddwJe/6aaJ8/NlZQgghxGugW3x8QqP30xJOhUPo=;
	h=Date:To:From:Subject:From;
	b=Wa3k9hQ4Gz0BmOJHEVphnysWTPmYflnFVg1C9x9SsET5btA0Hsd9eqafd/yv3Cvdv
	 o9Mk+BttWpA+qzwPwxrCpQwkwp7eAr6yLjURK0r4cesnYG7dlTW6nU0yoDFhMNDChr
	 BQFb8IoCg8gcbwXdfjzVm6lI6YldtXoAfV7oC4Ag=
Date: Fri, 02 Feb 2024 04:12:38 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240202121240.B4D68C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: on-fault-limit: run test without root privileges otherwise skip
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch

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
Subject: selftests/mm: on-fault-limit: run test without root privileges otherwise skip
Date: Thu, 1 Feb 2024 18:05:36 +0500

The mmap() respects rlimit only for normal users.  This test should be run
as normal user, without root privileges.  Also add back the sudo -u nobody
as run_vmtests.sh is run as root most of the times.  Skip the test instead
if sudo isn't present to lower the privileges.

Link: https://lkml.kernel.org/r/20240201130538.1404897-1-usama.anjum@collabora.com
Fixes: b6221771d468 ("selftests/mm: run_vmtests: remove sudo and conform to tap")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/on-fault-limit.c |    6 +++---
 tools/testing/selftests/mm/run_vmtests.sh   |    7 ++++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/on-fault-limit.c~selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix
+++ a/tools/testing/selftests/mm/on-fault-limit.c
@@ -21,7 +21,7 @@ static void test_limit(void)
 	map = mmap(NULL, 2 * lims.rlim_max, PROT_READ | PROT_WRITE,
 		   MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
 
-	ksft_test_result(map == MAP_FAILED, "Failed mmap\n");
+	ksft_test_result(map == MAP_FAILED, "The map failed respecting mlock limits\n");
 
 	if (map != MAP_FAILED)
 		munmap(map, 2 * lims.rlim_max);
@@ -33,8 +33,8 @@ int main(int argc, char **argv)
 	ksft_print_header();
 	ksft_set_plan(1);
 
-	if (getuid())
-		ksft_test_result_skip("Require root privileges to run\n");
+	if (!getuid())
+		ksft_test_result_skip("The test must be run from a normal user\n");
 	else
 		test_limit();
 
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -300,7 +300,12 @@ echo "$nr_hugepgs" > /proc/sys/vm/nr_hug
 
 CATEGORY="compaction" run_test ./compaction_test
 
-CATEGORY="mlock" run_test ./on-fault-limit
+if command -v sudo &> /dev/null;
+then
+	CATEGORY="mlock" run_test sudo -u nobody ./on-fault-limit
+else
+	echo "# SKIP ./on-fault-limit"
+fi
 
 CATEGORY="mmap" run_test ./map_populate
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch
selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch
selftests-mm-hugepage-vmemmap-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-madvise-conform-test-to-tap-format-output.patch
selftests-mm-khugepaged-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-read-hwpoison-conform-test-to-tap-format-output.patch
selftests-mm-config-add-missing-configs.patch

