Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48BE18B15
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876003; cv=none; b=lurODS8A7sn5ecz4l87VaGv9NgBSz8RZwd71zmL2lQD000h6qWFvQv13x/e0qU+USPGyyNrg+N5HGmPERtAhMG2mo+VGSEfMHycbLuLmuerccrmk7ZIV+94c4vLA72Yx4MuD79vJi+Z2KYJ2ditIdRI1okLLBCtBguyGe7Juo98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876003; c=relaxed/simple;
	bh=TM0K1e0afgpD6bgcUvicm6S1Ekm2hQslpnFx7cdJu5o=;
	h=Date:To:From:Subject:Message-Id; b=UXXrl6HWC8L4yFIllmCS8UMIJdrTxifIIDMWnc/j21hDD1FRhKvk1vOARhle0pF/XW6A/FES8DayqOz8f5MPnKtd7kWwuSK3+ZfzdaNaXAGjfqaUMe4YBtANGrvs2CwAT8WpNzOFlGpPRQAoDISCPh7FBslFhQ7ttWxymiX6vV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jDa9TXon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jDa9TXon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1089C433C7;
	Fri,  2 Feb 2024 12:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876003;
	bh=TM0K1e0afgpD6bgcUvicm6S1Ekm2hQslpnFx7cdJu5o=;
	h=Date:To:From:Subject:From;
	b=jDa9TXonYIqewyUfZNbVTPgYq/t+7RVpCWZHMWEeUc7//uv2BfFO/Ws4JQwN1xSzL
	 3J8Kh4cO9vXShfGre2vXPODO0TC59y4qRbzVfheAZVQk0X99F2jQNB9jyuZc8OEJBd
	 9oT0RvRq/1QooXrEz1Crq3RqYvlR/mO7FcwOvruc=
Date: Fri, 02 Feb 2024 04:13:20 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mlock2-tests-conform-test-to-tap-format-output.patch added to mm-unstable branch
Message-Id: <20240202121322.D1089C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: mlock2-tests: conform test to TAP format output
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-mlock2-tests-conform-test-to-tap-format-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mlock2-tests-conform-test-to-tap-format-output.patch

This patch will later appear in the mm-unstable branch at
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
Subject: selftests/mm: mlock2-tests: conform test to TAP format output
Date: Wed, 31 Jan 2024 19:05:15 +0500

Conform the layout, informational and status messages to TAP. No
functional change is intended other than the layout of output messages.
I've done some cleanups as well.

Link: https://lkml.kernel.org/r/20240131140528.320252-5-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mlock2-tests.c |  282 ++++++++------------
 tools/testing/selftests/mm/mlock2.h       |   11 
 2 files changed, 118 insertions(+), 175 deletions(-)

--- a/tools/testing/selftests/mm/mlock2.h~selftests-mm-mlock2-tests-conform-test-to-tap-format-output
+++ a/tools/testing/selftests/mm/mlock2.h
@@ -6,12 +6,7 @@
 
 static int mlock2_(void *start, size_t len, int flags)
 {
-#ifdef __NR_mlock2
 	return syscall(__NR_mlock2, start, len, flags);
-#else
-	errno = ENOSYS;
-	return -1;
-#endif
 }
 
 static FILE *seek_to_smaps_entry(unsigned long addr)
@@ -27,10 +22,8 @@ static FILE *seek_to_smaps_entry(unsigne
 	char path[BUFSIZ];
 
 	file = fopen("/proc/self/smaps", "r");
-	if (!file) {
-		perror("fopen smaps");
-		_exit(1);
-	}
+	if (!file)
+		ksft_exit_fail_msg("fopen smaps: %s\n", strerror(errno));
 
 	while (getline(&line, &size, file) > 0) {
 		if (sscanf(line, "%lx-%lx %s %lx %s %lu %s\n",
--- a/tools/testing/selftests/mm/mlock2-tests.c~selftests-mm-mlock2-tests-conform-test-to-tap-format-output
+++ a/tools/testing/selftests/mm/mlock2-tests.c
@@ -7,9 +7,8 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <stdbool.h>
-#include "mlock2.h"
-
 #include "../kselftest.h"
+#include "mlock2.h"
 
 struct vm_boundaries {
 	unsigned long start;
@@ -40,14 +39,14 @@ static int get_vm_area(unsigned long add
 	while(fgets(line, 1024, file)) {
 		end_addr = strchr(line, '-');
 		if (!end_addr) {
-			printf("cannot parse /proc/self/maps\n");
+			ksft_print_msg("cannot parse /proc/self/maps\n");
 			goto out;
 		}
 		*end_addr = '\0';
 		end_addr++;
 		stop = strchr(end_addr, ' ');
 		if (!stop) {
-			printf("cannot parse /proc/self/maps\n");
+			ksft_print_msg("cannot parse /proc/self/maps\n");
 			goto out;
 		}
 
@@ -78,7 +77,7 @@ static bool is_vmflag_set(unsigned long
 
 	smaps = seek_to_smaps_entry(addr);
 	if (!smaps) {
-		printf("Unable to parse /proc/self/smaps\n");
+		ksft_print_msg("Unable to parse /proc/self/smaps\n");
 		goto out;
 	}
 
@@ -115,7 +114,7 @@ static unsigned long get_value_for_name(
 
 	smaps = seek_to_smaps_entry(addr);
 	if (!smaps) {
-		printf("Unable to parse /proc/self/smaps\n");
+		ksft_print_msg("Unable to parse /proc/self/smaps\n");
 		goto out;
 	}
 
@@ -129,7 +128,7 @@ static unsigned long get_value_for_name(
 
 		value_ptr = line + strlen(name);
 		if (sscanf(value_ptr, "%lu kB", &value) < 1) {
-			printf("Unable to parse smaps entry for Size\n");
+			ksft_print_msg("Unable to parse smaps entry for Size\n");
 			goto out;
 		}
 		break;
@@ -180,57 +179,45 @@ static int lock_check(unsigned long addr
 static int unlock_lock_check(char *map)
 {
 	if (is_vmflag_set((unsigned long)map, LOCKED)) {
-		printf("VMA flag %s is present on page 1 after unlock\n", LOCKED);
+		ksft_print_msg("VMA flag %s is present on page 1 after unlock\n", LOCKED);
 		return 1;
 	}
 
 	return 0;
 }
 
-static int test_mlock_lock()
+static void test_mlock_lock(void)
 {
 	char *map;
-	int ret = 1;
 	unsigned long page_size = getpagesize();
 
 	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
 		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-	if (map == MAP_FAILED) {
-		perror("test_mlock_locked mmap");
-		goto out;
-	}
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s", strerror(errno));
 
 	if (mlock2_(map, 2 * page_size, 0)) {
-		if (errno == ENOSYS) {
-			printf("Cannot call new mlock family, skipping test\n");
-			_exit(KSFT_SKIP);
-		}
-		perror("mlock2(0)");
-		goto unmap;
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("mlock2(0): %s\n", strerror(errno));
 	}
 
-	if (!lock_check((unsigned long)map))
-		goto unmap;
+	ksft_test_result(lock_check((unsigned long)map), "%s: Locked\n", __func__);
 
 	/* Now unlock and recheck attributes */
 	if (munlock(map, 2 * page_size)) {
-		perror("munlock()");
-		goto unmap;
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("munlock(): %s\n", strerror(errno));
 	}
 
-	ret = unlock_lock_check(map);
-
-unmap:
+	ksft_test_result(!unlock_lock_check(map), "%s: Locked\n", __func__);
 	munmap(map, 2 * page_size);
-out:
-	return ret;
 }
 
 static int onfault_check(char *map)
 {
 	*map = 'a';
 	if (!is_vma_lock_on_fault((unsigned long)map)) {
-		printf("VMA is not marked for lock on fault\n");
+		ksft_print_msg("VMA is not marked for lock on fault\n");
 		return 1;
 	}
 
@@ -243,172 +230,131 @@ static int unlock_onfault_check(char *ma
 
 	if (is_vma_lock_on_fault((unsigned long)map) ||
 	    is_vma_lock_on_fault((unsigned long)map + page_size)) {
-		printf("VMA is still lock on fault after unlock\n");
+		ksft_print_msg("VMA is still lock on fault after unlock\n");
 		return 1;
 	}
 
 	return 0;
 }
 
-static int test_mlock_onfault()
+static void test_mlock_onfault(void)
 {
 	char *map;
-	int ret = 1;
 	unsigned long page_size = getpagesize();
 
 	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
 		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-	if (map == MAP_FAILED) {
-		perror("test_mlock_locked mmap");
-		goto out;
-	}
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s", strerror(errno));
 
 	if (mlock2_(map, 2 * page_size, MLOCK_ONFAULT)) {
-		if (errno == ENOSYS) {
-			printf("Cannot call new mlock family, skipping test\n");
-			_exit(KSFT_SKIP);
-		}
-		perror("mlock2(MLOCK_ONFAULT)");
-		goto unmap;
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("mlock2(MLOCK_ONFAULT): %s\n", strerror(errno));
 	}
 
-	if (onfault_check(map))
-		goto unmap;
+	ksft_test_result(!onfault_check(map), "%s: VMA marked for lock on fault\n", __func__);
 
 	/* Now unlock and recheck attributes */
 	if (munlock(map, 2 * page_size)) {
-		if (errno == ENOSYS) {
-			printf("Cannot call new mlock family, skipping test\n");
-			_exit(KSFT_SKIP);
-		}
-		perror("munlock()");
-		goto unmap;
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("munlock(): %s\n", strerror(errno));
 	}
 
-	ret = unlock_onfault_check(map);
-unmap:
+	ksft_test_result(!unlock_onfault_check(map), "VMA open lock after fault\n");
 	munmap(map, 2 * page_size);
-out:
-	return ret;
 }
 
-static int test_lock_onfault_of_present()
+static void test_lock_onfault_of_present(void)
 {
 	char *map;
-	int ret = 1;
 	unsigned long page_size = getpagesize();
 
 	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
 		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-	if (map == MAP_FAILED) {
-		perror("test_mlock_locked mmap");
-		goto out;
-	}
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s", strerror(errno));
 
 	*map = 'a';
 
 	if (mlock2_(map, 2 * page_size, MLOCK_ONFAULT)) {
-		if (errno == ENOSYS) {
-			printf("Cannot call new mlock family, skipping test\n");
-			_exit(KSFT_SKIP);
-		}
-		perror("mlock2(MLOCK_ONFAULT)");
-		goto unmap;
+		munmap(map, 2 * page_size);
+		ksft_test_result_fail("mlock2(MLOCK_ONFAULT) error: %s", strerror(errno));
 	}
 
-	if (!is_vma_lock_on_fault((unsigned long)map) ||
-	    !is_vma_lock_on_fault((unsigned long)map + page_size)) {
-		printf("VMA with present pages is not marked lock on fault\n");
-		goto unmap;
-	}
-	ret = 0;
-unmap:
+	ksft_test_result(is_vma_lock_on_fault((unsigned long)map) ||
+			 is_vma_lock_on_fault((unsigned long)map + page_size),
+			 "VMA with present pages is not marked lock on fault\n");
 	munmap(map, 2 * page_size);
-out:
-	return ret;
 }
 
-static int test_munlockall()
+static void test_munlockall0(void)
 {
 	char *map;
-	int ret = 1;
 	unsigned long page_size = getpagesize();
 
 	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
 		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-
-	if (map == MAP_FAILED) {
-		perror("test_munlockall mmap");
-		goto out;
-	}
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
 
 	if (mlockall(MCL_CURRENT)) {
-		perror("mlockall(MCL_CURRENT)");
-		goto out;
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("mlockall(MCL_CURRENT): %s\n", strerror(errno));
 	}
 
-	if (!lock_check((unsigned long)map))
-		goto unmap;
+	ksft_test_result(lock_check((unsigned long)map), "%s: Locked memory area\n", __func__);
 
 	if (munlockall()) {
-		perror("munlockall()");
-		goto unmap;
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("munlockall(): %s\n", strerror(errno));
 	}
 
-	if (unlock_lock_check(map))
-		goto unmap;
-
+	ksft_test_result(!unlock_lock_check(map), "%s: No locked memory\n", __func__);
 	munmap(map, 2 * page_size);
+}
+
+static void test_munlockall1(void)
+{
+	char *map;
+	unsigned long page_size = getpagesize();
 
 	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
 		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-
-	if (map == MAP_FAILED) {
-		perror("test_munlockall second mmap");
-		goto out;
-	}
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s", strerror(errno));
 
 	if (mlockall(MCL_CURRENT | MCL_ONFAULT)) {
-		perror("mlockall(MCL_CURRENT | MCL_ONFAULT)");
-		goto unmap;
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("mlockall(MCL_CURRENT | MCL_ONFAULT): %s\n", strerror(errno));
 	}
 
-	if (onfault_check(map))
-		goto unmap;
+	ksft_test_result(!onfault_check(map), "%s: VMA marked for lock on fault\n", __func__);
 
 	if (munlockall()) {
-		perror("munlockall()");
-		goto unmap;
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("munlockall(): %s\n", strerror(errno));
 	}
 
-	if (unlock_onfault_check(map))
-		goto unmap;
+	ksft_test_result(!unlock_onfault_check(map), "%s: Unlocked\n", __func__);
 
 	if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
-		perror("mlockall(MCL_CURRENT | MCL_FUTURE)");
-		goto out;
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("mlockall(MCL_CURRENT | MCL_FUTURE): %s\n", strerror(errno));
 	}
 
-	if (!lock_check((unsigned long)map))
-		goto unmap;
+	ksft_test_result(lock_check((unsigned long)map), "%s: Locked\n", __func__);
 
 	if (munlockall()) {
-		perror("munlockall()");
-		goto unmap;
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
 	}
 
-	ret = unlock_lock_check(map);
-
-unmap:
+	ksft_test_result(!unlock_lock_check(map), "%s: No locked memory\n", __func__);
 	munmap(map, 2 * page_size);
-out:
-	munlockall();
-	return ret;
 }
 
-static int test_vma_management(bool call_mlock)
+static void test_vma_management(bool call_mlock)
 {
-	int ret = 1;
 	void *map;
 	unsigned long page_size = getpagesize();
 	struct vm_boundaries page1;
@@ -417,25 +363,19 @@ static int test_vma_management(bool call
 
 	map = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
 		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-	if (map == MAP_FAILED) {
-		perror("mmap()");
-		return ret;
-	}
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s", strerror(errno));
 
 	if (call_mlock && mlock2_(map, 3 * page_size, MLOCK_ONFAULT)) {
-		if (errno == ENOSYS) {
-			printf("Cannot call new mlock family, skipping test\n");
-			_exit(KSFT_SKIP);
-		}
-		perror("mlock(ONFAULT)\n");
-		goto out;
+		munmap(map, 3 * page_size);
+		ksft_test_result_fail("mlock error: %s", strerror(errno));
 	}
 
 	if (get_vm_area((unsigned long)map, &page1) ||
 	    get_vm_area((unsigned long)map + page_size, &page2) ||
 	    get_vm_area((unsigned long)map + page_size * 2, &page3)) {
-		printf("couldn't find mapping in /proc/self/maps\n");
-		goto out;
+		munmap(map, 3 * page_size);
+		ksft_test_result_fail("couldn't find mapping in /proc/self/maps");
 	}
 
 	/*
@@ -444,76 +384,86 @@ static int test_vma_management(bool call
 	 * not a failure)
 	 */
 	if (page1.start != page2.start || page2.start != page3.start) {
-		printf("VMAs are not merged to start, aborting test\n");
-		ret = 0;
-		goto out;
+		munmap(map, 3 * page_size);
+		ksft_test_result_fail("VMAs are not merged to start, aborting test");
 	}
 
 	if (munlock(map + page_size, page_size)) {
-		perror("munlock()");
-		goto out;
+		munmap(map, 3 * page_size);
+		ksft_test_result_fail("munlock(): %s", strerror(errno));
 	}
 
 	if (get_vm_area((unsigned long)map, &page1) ||
 	    get_vm_area((unsigned long)map + page_size, &page2) ||
 	    get_vm_area((unsigned long)map + page_size * 2, &page3)) {
-		printf("couldn't find mapping in /proc/self/maps\n");
-		goto out;
+		munmap(map, 3 * page_size);
+		ksft_test_result_fail("couldn't find mapping in /proc/self/maps");
 	}
 
 	/* All three VMAs should be different */
 	if (page1.start == page2.start || page2.start == page3.start) {
-		printf("failed to split VMA for munlock\n");
-		goto out;
+		munmap(map, 3 * page_size);
+		ksft_test_result_fail("failed to split VMA for munlock");
 	}
 
 	/* Now unlock the first and third page and check the VMAs again */
 	if (munlock(map, page_size * 3)) {
-		perror("munlock()");
-		goto out;
+		munmap(map, 3 * page_size);
+		ksft_test_result_fail("munlock(): %s", strerror(errno));
 	}
 
 	if (get_vm_area((unsigned long)map, &page1) ||
 	    get_vm_area((unsigned long)map + page_size, &page2) ||
 	    get_vm_area((unsigned long)map + page_size * 2, &page3)) {
-		printf("couldn't find mapping in /proc/self/maps\n");
-		goto out;
+		munmap(map, 3 * page_size);
+		ksft_test_result_fail("couldn't find mapping in /proc/self/maps");
 	}
 
 	/* Now all three VMAs should be the same */
 	if (page1.start != page2.start || page2.start != page3.start) {
-		printf("failed to merge VMAs after munlock\n");
-		goto out;
+		munmap(map, 3 * page_size);
+		ksft_test_result_fail("failed to merge VMAs after munlock");
 	}
 
-	ret = 0;
-out:
+	ksft_test_result_pass("%s call_mlock %d\n", __func__, call_mlock);
 	munmap(map, 3 * page_size);
-	return ret;
 }
 
-static int test_mlockall(int (test_function)(bool call_mlock))
+static void test_mlockall(void)
 {
-	int ret = 1;
+	if (mlockall(MCL_CURRENT | MCL_ONFAULT | MCL_FUTURE))
+		ksft_exit_fail_msg("mlockall failed: %s\n", strerror(errno));
 
-	if (mlockall(MCL_CURRENT | MCL_ONFAULT | MCL_FUTURE)) {
-		perror("mlockall");
-		return ret;
-	}
-
-	ret = test_function(false);
+	test_vma_management(false);
 	munlockall();
-	return ret;
 }
 
 int main(int argc, char **argv)
 {
-	int ret = 0;
-	ret += test_mlock_lock();
-	ret += test_mlock_onfault();
-	ret += test_munlockall();
-	ret += test_lock_onfault_of_present();
-	ret += test_vma_management(true);
-	ret += test_mlockall(test_vma_management);
-	return ret;
+	int ret, size = 3 * getpagesize();
+	void *map;
+
+	ksft_print_header();
+
+	map = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s", strerror(errno));
+
+	ret = mlock2_(map, size, MLOCK_ONFAULT);
+	if (ret && errno == ENOSYS)
+		ksft_finished();
+
+	munmap(map, size);
+
+	ksft_set_plan(13);
+
+	test_mlock_lock();
+	test_mlock_onfault();
+	test_munlockall0();
+	test_munlockall1();
+	test_lock_onfault_of_present();
+	test_vma_management(true);
+	test_mlockall();
+
+	ksft_finished();
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch
selftests-mm-map_fixed_noreplace-conform-test-to-tap-format-output.patch
selftests-mm-map_hugetlb-conform-test-to-tap-format-output.patch
selftests-mm-map_populate-conform-test-to-tap-format-output.patch
selftests-mm-mlock-random-test-conform-test-to-tap-format-output.patch
selftests-mm-mlock2-tests-conform-test-to-tap-format-output.patch
selftests-mm-mrelease_test-conform-test-to-tap-format-output.patch
selftests-mm-mremap_dontunmap-conform-test-to-tap-format-output.patch
selftests-mm-split_huge_page_test-conform-test-to-tap-format-output.patch
selftests-mm-thp_settings-conform-to-tap-format-output.patch
selftests-mm-thuge-gen-conform-to-tap-format-output.patch
selftests-mm-transhuge-stress-conform-to-tap-format-output.patch
selftests-mm-virtual_address_range-conform-to-tap-format-output.patch
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

