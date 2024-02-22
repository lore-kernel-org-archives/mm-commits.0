Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E8F19452
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644864; cv=none; b=qKPPSEX6BF/wh3ql6TrR1Z/nuayafI7oO/JemA71zZKx3cTzXbOiPkGInWzi0wPx3/VvZ/nIjWOxCJ0Nxbwny/zOT0QcPyq97m3iuD5wPjTinL1nUtoVNMONqbIvrPXWdFZYYS0aO4ClOlEoXcxnUh1XASOmkuBXprgfvh5WRwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644864; c=relaxed/simple;
	bh=i3ua6UmE5lshIjfCORkYiR5H0dnW29cRwc9WdYUMU3o=;
	h=Date:To:From:Subject:Message-Id; b=PVaWCQwNhvhrqHo5qTLeuzkU5kbfsFAW9k3c70EJ8kixL/YLYkPs2utIu8iMKEdZZGhHtO11VsQCnriEvySTTWrpSCtWIVePUAL/fAaRVd/a77DdSiQ+aPWmkg9LYrtm8IRiynp/8LiYqYsWB/hVqIqRqz/mGx++PVzzew8tDpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rxJbSLal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rxJbSLal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6C1C43609;
	Thu, 22 Feb 2024 23:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644863;
	bh=i3ua6UmE5lshIjfCORkYiR5H0dnW29cRwc9WdYUMU3o=;
	h=Date:To:From:Subject:From;
	b=rxJbSLalm0YWnliRAIG6N8BeT6gGcl7tyt+dgDSfO3cj1OElCamaS7fjVdN0RhYC5
	 DaMr4BXe5zqTSgGghxf9U1CmhlZJ/bIoCvX0osIExArkTCtSTrqz5rI4iyv981daSp
	 rcnM/i/1yxELLZgw0EwiywxPLZhtUROM7KzVT4LM=
Date: Thu, 22 Feb 2024 15:34:23 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch removed from -mm tree
Message-Id: <20240222233423.9E6C1C43609@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: on-fault-limit: run test without root privileges otherwise skip
has been removed from the -mm tree.  Its filename was
     selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch

This patch was dropped because it was folded into selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch

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
@@ -291,7 +291,12 @@ echo "$nr_hugepgs" > /proc/sys/vm/nr_hug
 
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

selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch

