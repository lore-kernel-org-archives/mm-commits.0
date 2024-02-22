Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FA2320B
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560153; cv=none; b=VNOK/CgUdm1yn1LJnOLAC2Na5iYj6VGIoVdwSSkqd3S8i4+VqyMc3uLu0wqXvRauDyAAG1oHv7LBhYLxn/qpcnagJQxPeq4W75fm+FBHUucwScL9kVn3IowcdxFbhtZjSRsxs/0vtKxfavCE79inLBfMheaBZapR9s060KHYE6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560153; c=relaxed/simple;
	bh=LCU7A8Ymvty13DQXWOVexmqA1UPoxwim1yOMfTCyKwY=;
	h=Date:To:From:Subject:Message-Id; b=L8bmFCSse6dUVBcrPMH2LCRnv85rYewwkv3ZyxAgVZmKdoDbki262ltxLZdQJVWOmI4iWLKHf5wtpyqlkJ0Ajo+FZ+2/p/3ql4lGeqFOCX6sz4xFmiFqhJTF/VkPV+weIY7kvmP3mu9QGs44AoWp7WVwh3PBTHXpHJs510q9EIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RaDyC+vP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RaDyC+vP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CCEC433C7;
	Thu, 22 Feb 2024 00:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560152;
	bh=LCU7A8Ymvty13DQXWOVexmqA1UPoxwim1yOMfTCyKwY=;
	h=Date:To:From:Subject:From;
	b=RaDyC+vPeNbUhtl86E6Lfk9ZxudcrGzqSKqvRa6qE9PIZzMo2hO2XnpJYw4gNhoZH
	 vKepXaTdSRcgyUFMVA+HnFhFhdUeApLl/85iJKZ2nqoUTm3qd+RdhKKLHEkPd1jEzh
	 8ayAHo6DYLODL4SH+Vw1JCZQ7Z6qFT/UA846KMD4=
Date: Wed, 21 Feb 2024 16:02:32 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-map_fixed_noreplace-conform-test-to-tap-format-output.patch removed from -mm tree
Message-Id: <20240222000232.B5CCEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: map_fixed_noreplace: conform test to TAP format output
has been removed from the -mm tree.  Its filename was
     selftests-mm-map_fixed_noreplace-conform-test-to-tap-format-output.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: map_fixed_noreplace: conform test to TAP format output
Date: Fri, 2 Feb 2024 16:31:08 +0500

Patch series "conform tests to TAP format output", v2.


This patch (of 12):

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages. 
While at it, convert commenting style from // to /**/.

Link: https://lkml.kernel.org/r/20240202113119.2047740-1-usama.anjum@collabora.com
Link: https://lkml.kernel.org/r/20240202113119.2047740-2-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/map_fixed_noreplace.c |   96 ++++---------
 1 file changed, 31 insertions(+), 65 deletions(-)

--- a/tools/testing/selftests/mm/map_fixed_noreplace.c~selftests-mm-map_fixed_noreplace-conform-test-to-tap-format-output
+++ a/tools/testing/selftests/mm/map_fixed_noreplace.c
@@ -12,6 +12,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include "../kselftest.h"
 
 static void dump_maps(void)
 {
@@ -28,15 +29,12 @@ static unsigned long find_base_addr(unsi
 
 	flags = MAP_PRIVATE | MAP_ANONYMOUS;
 	addr = mmap(NULL, size, PROT_NONE, flags, -1, 0);
-	if (addr == MAP_FAILED) {
-		printf("Error: couldn't map the space we need for the test\n");
-		return 0;
-	}
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("Error: couldn't map the space we need for the test\n");
+
+	if (munmap(addr, size) != 0)
+		ksft_exit_fail_msg("Error: munmap failed\n");
 
-	if (munmap(addr, size) != 0) {
-		printf("Error: couldn't map the space we need for the test\n");
-		return 0;
-	}
 	return (unsigned long)addr;
 }
 
@@ -46,51 +44,39 @@ int main(void)
 	unsigned long flags, addr, size, page_size;
 	char *p;
 
+	ksft_print_header();
+	ksft_set_plan(9);
+
 	page_size = sysconf(_SC_PAGE_SIZE);
 
-	//let's find a base addr that is free before we start the tests
+	/* let's find a base addr that is free before we start the tests */
 	size = 5 * page_size;
 	base_addr = find_base_addr(size);
-	if (!base_addr) {
-		printf("Error: couldn't map the space we need for the test\n");
-		return 1;
-	}
 
 	flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED_NOREPLACE;
 
-	// Check we can map all the areas we need below
-	errno = 0;
+	/* Check we can map all the areas we need below */
 	addr = base_addr;
 	size = 5 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
-
-	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
-
 	if (p == MAP_FAILED) {
 		dump_maps();
-		printf("Error: couldn't map the space we need for the test\n");
-		return 1;
+		ksft_exit_fail_msg("Error: couldn't map the space we need for the test\n");
 	}
-
-	errno = 0;
 	if (munmap((void *)addr, 5 * page_size) != 0) {
 		dump_maps();
-		printf("Error: munmap failed!?\n");
-		return 1;
+		ksft_exit_fail_msg("Error: munmap failed!?\n");
 	}
-	printf("unmap() successful\n");
+	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
 
-	errno = 0;
 	addr = base_addr + page_size;
 	size = 3 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
-	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
-
 	if (p == MAP_FAILED) {
 		dump_maps();
-		printf("Error: first mmap() failed unexpectedly\n");
-		return 1;
+		ksft_exit_fail_msg("Error: first mmap() failed unexpectedly\n");
 	}
+	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
 
 	/*
 	 * Exact same mapping again:
@@ -100,17 +86,14 @@ int main(void)
 	 *     +3 | mapped | new
 	 *     +4 |  free  | new
 	 */
-	errno = 0;
 	addr = base_addr;
 	size = 5 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
-	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
-
 	if (p != MAP_FAILED) {
 		dump_maps();
-		printf("Error:1: mmap() succeeded when it shouldn't have\n");
-		return 1;
+		ksft_exit_fail_msg("Error:1: mmap() succeeded when it shouldn't have\n");
 	}
+	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
 
 	/*
 	 * Second mapping contained within first:
@@ -121,17 +104,14 @@ int main(void)
 	 *     +3 | mapped |
 	 *     +4 |  free  |
 	 */
-	errno = 0;
 	addr = base_addr + (2 * page_size);
 	size = page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
-	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
-
 	if (p != MAP_FAILED) {
 		dump_maps();
-		printf("Error:2: mmap() succeeded when it shouldn't have\n");
-		return 1;
+		ksft_exit_fail_msg("Error:2: mmap() succeeded when it shouldn't have\n");
 	}
+	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
 
 	/*
 	 * Overlap end of existing mapping:
@@ -141,17 +121,14 @@ int main(void)
 	 *     +3 | mapped | new
 	 *     +4 |  free  | new
 	 */
-	errno = 0;
 	addr = base_addr + (3 * page_size);
 	size = 2 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
-	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
-
 	if (p != MAP_FAILED) {
 		dump_maps();
-		printf("Error:3: mmap() succeeded when it shouldn't have\n");
-		return 1;
+		ksft_exit_fail_msg("Error:3: mmap() succeeded when it shouldn't have\n");
 	}
+	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
 
 	/*
 	 * Overlap start of existing mapping:
@@ -161,17 +138,14 @@ int main(void)
 	 *     +3 | mapped |
 	 *     +4 |  free  |
 	 */
-	errno = 0;
 	addr = base_addr;
 	size = 2 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
-	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
-
 	if (p != MAP_FAILED) {
 		dump_maps();
-		printf("Error:4: mmap() succeeded when it shouldn't have\n");
-		return 1;
+		ksft_exit_fail_msg("Error:4: mmap() succeeded when it shouldn't have\n");
 	}
+	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
 
 	/*
 	 * Adjacent to start of existing mapping:
@@ -181,17 +155,14 @@ int main(void)
 	 *     +3 | mapped |
 	 *     +4 |  free  |
 	 */
-	errno = 0;
 	addr = base_addr;
 	size = page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
-	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
-
 	if (p == MAP_FAILED) {
 		dump_maps();
-		printf("Error:5: mmap() failed when it shouldn't have\n");
-		return 1;
+		ksft_exit_fail_msg("Error:5: mmap() failed when it shouldn't have\n");
 	}
+	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
 
 	/*
 	 * Adjacent to end of existing mapping:
@@ -201,27 +172,22 @@ int main(void)
 	 *     +3 | mapped |
 	 *     +4 |  free  |  new
 	 */
-	errno = 0;
 	addr = base_addr + (4 * page_size);
 	size = page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
-	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
-
 	if (p == MAP_FAILED) {
 		dump_maps();
-		printf("Error:6: mmap() failed when it shouldn't have\n");
-		return 1;
+		ksft_exit_fail_msg("Error:6: mmap() failed when it shouldn't have\n");
 	}
+	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
 
 	addr = base_addr;
 	size = 5 * page_size;
 	if (munmap((void *)addr, size) != 0) {
 		dump_maps();
-		printf("Error: munmap failed!?\n");
-		return 1;
+		ksft_exit_fail_msg("Error: munmap failed!?\n");
 	}
-	printf("unmap() successful\n");
+	ksft_test_result_pass("Base Address unmap() successful\n");
 
-	printf("OK\n");
-	return 0;
+	ksft_finished();
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch

