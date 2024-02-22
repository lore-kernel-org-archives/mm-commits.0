Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236B7320B
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560156; cv=none; b=JuMZmVPRwyIRt/c56UaYv2HC89hoHYNsq8Riy/lVtrkbPPG+nBblmBt6y+XcdOSFcGTeMZ7eE5XRHX5TbHSzehx2lOfbPwAcqI25H6hmsPZDLzJJoA39KQlPYEyLThzTYnLzPqNctb4lOX117UtJAnbx//PtQLmFJh6q7WFjdq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560156; c=relaxed/simple;
	bh=LO6IBTNGd1F1x7rtszgfpuCKygi0IssSg1TawfzjvIM=;
	h=Date:To:From:Subject:Message-Id; b=doUdbaC84U0Fd/JR6HafmAlrp2HliFAMrNnr0K3AtFy/SIl0SRFJGt8IN/1C98bixnztKjAnIIF/9x7CWlXJ4OHUs2TDSmOeTuenh9ikPPd3PBklpbVK8+nNmnE20N3R5MjtRHOiZQrUksAvQktXd4cKb8I1cQUS/Wzv6POnqaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=khvn0UgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="khvn0UgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D9DC433C7;
	Thu, 22 Feb 2024 00:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560155;
	bh=LO6IBTNGd1F1x7rtszgfpuCKygi0IssSg1TawfzjvIM=;
	h=Date:To:From:Subject:From;
	b=khvn0UgGOxGpF21MWMXRnABS3+ftUNcEpsi9LWigpWYu/bBxCoMBw50SA0VLkHoug
	 eCJxQsaAKtzNJmU7hxESPtL/OA6qb9xr8i8GTEUId/N3+yJFpPkYCFgcSiVE0pv7pp
	 DmfB+MPDW4vo5majOnytG86qjCeCVb/u6zlERgXE=
Date: Wed, 21 Feb 2024 16:02:35 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mlock-random-test-conform-test-to-tap-format-output.patch removed from -mm tree
Message-Id: <20240222000235.97D9DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: mlock-random-test: conform test to TAP format output
has been removed from the -mm tree.  Its filename was
     selftests-mm-mlock-random-test-conform-test-to-tap-format-output.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: mlock-random-test: conform test to TAP format output
Date: Fri, 2 Feb 2024 16:31:11 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240202113119.2047740-5-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mlock-random-test.c |  136 +++++----------
 1 file changed, 54 insertions(+), 82 deletions(-)

--- a/tools/testing/selftests/mm/mlock-random-test.c~selftests-mm-mlock-random-test-conform-test-to-tap-format-output
+++ a/tools/testing/selftests/mm/mlock-random-test.c
@@ -13,6 +13,7 @@
 #include <sys/ipc.h>
 #include <sys/shm.h>
 #include <time.h>
+#include "../kselftest.h"
 #include "mlock2.h"
 
 #define CHUNK_UNIT (128 * 1024)
@@ -31,14 +32,14 @@ int set_cap_limits(rlim_t max)
 	new.rlim_cur = max;
 	new.rlim_max = max;
 	if (setrlimit(RLIMIT_MEMLOCK, &new)) {
-		perror("setrlimit() returns error\n");
+		ksft_perror("setrlimit() returns error\n");
 		return -1;
 	}
 
 	/* drop capabilities including CAP_IPC_LOCK */
 	if (cap_set_proc(cap)) {
-		perror("cap_set_proc() returns error\n");
-		return -2;
+		ksft_perror("cap_set_proc() returns error\n");
+		return -1;
 	}
 
 	return 0;
@@ -52,27 +53,24 @@ int get_proc_locked_vm_size(void)
 	unsigned long lock_size = 0;
 
 	f = fopen("/proc/self/status", "r");
-	if (!f) {
-		perror("fopen");
-		return -1;
-	}
+	if (!f)
+		ksft_exit_fail_msg("fopen: %s\n", strerror(errno));
 
 	while (fgets(line, 1024, f)) {
 		if (strstr(line, "VmLck")) {
 			ret = sscanf(line, "VmLck:\t%8lu kB", &lock_size);
 			if (ret <= 0) {
-				printf("sscanf() on VmLck error: %s: %d\n",
-						line, ret);
 				fclose(f);
-				return -1;
+				ksft_exit_fail_msg("sscanf() on VmLck error: %s: %d\n",
+						   line, ret);
 			}
 			fclose(f);
 			return (int)(lock_size << 10);
 		}
 	}
 
-	perror("cannot parse VmLck in /proc/self/status\n");
 	fclose(f);
+	ksft_exit_fail_msg("cannot parse VmLck in /proc/self/status: %s\n", strerror(errno));
 	return -1;
 }
 
@@ -91,10 +89,8 @@ int get_proc_page_size(unsigned long add
 	size_t size;
 
 	smaps = seek_to_smaps_entry(addr);
-	if (!smaps) {
-		printf("Unable to parse /proc/self/smaps\n");
-		return 0;
-	}
+	if (!smaps)
+		ksft_exit_fail_msg("Unable to parse /proc/self/smaps\n");
 
 	while (getline(&line, &size, smaps) > 0) {
 		if (!strstr(line, "MMUPageSize")) {
@@ -105,12 +101,9 @@ int get_proc_page_size(unsigned long add
 		}
 
 		/* found the MMUPageSize of this section */
-		if (sscanf(line, "MMUPageSize:    %8lu kB",
-					&mmupage_size) < 1) {
-			printf("Unable to parse smaps entry for Size:%s\n",
-					line);
-			break;
-		}
+		if (sscanf(line, "MMUPageSize:    %8lu kB", &mmupage_size) < 1)
+			ksft_exit_fail_msg("Unable to parse smaps entry for Size:%s\n",
+					   line);
 
 	}
 	free(line);
@@ -136,7 +129,7 @@ int get_proc_page_size(unsigned long add
  *    return value: 0 - success
  *    else: failure
  */
-int test_mlock_within_limit(char *p, int alloc_size)
+static void test_mlock_within_limit(char *p, int alloc_size)
 {
 	int i;
 	int ret = 0;
@@ -145,11 +138,9 @@ int test_mlock_within_limit(char *p, int
 	int page_size = 0;
 
 	getrlimit(RLIMIT_MEMLOCK, &cur);
-	if (cur.rlim_cur < alloc_size) {
-		printf("alloc_size[%d] < %u rlimit,lead to mlock failure\n",
-				alloc_size, (unsigned int)cur.rlim_cur);
-		return -1;
-	}
+	if (cur.rlim_cur < alloc_size)
+		ksft_exit_fail_msg("alloc_size[%d] < %u rlimit,lead to mlock failure\n",
+				   alloc_size, (unsigned int)cur.rlim_cur);
 
 	srand(time(NULL));
 	for (i = 0; i < TEST_LOOP; i++) {
@@ -169,13 +160,11 @@ int test_mlock_within_limit(char *p, int
 			ret = mlock2_(p + start_offset, lock_size,
 				       MLOCK_ONFAULT);
 
-		if (ret) {
-			printf("%s() failure at |%p(%d)| mlock:|%p(%d)|\n",
-					is_mlock ? "mlock" : "mlock2",
-					p, alloc_size,
-					p + start_offset, lock_size);
-			return ret;
-		}
+		if (ret)
+			ksft_exit_fail_msg("%s() failure at |%p(%d)| mlock:|%p(%d)|\n",
+					   is_mlock ? "mlock" : "mlock2",
+					   p, alloc_size,
+					   p + start_offset, lock_size);
 	}
 
 	/*
@@ -183,18 +172,12 @@ int test_mlock_within_limit(char *p, int
 	 */
 	locked_vm_size = get_proc_locked_vm_size();
 	page_size = get_proc_page_size((unsigned long)p);
-	if (page_size == 0) {
-		printf("cannot get proc MMUPageSize\n");
-		return -1;
-	}
 
-	if (locked_vm_size > PAGE_ALIGN(alloc_size, page_size) + page_size) {
-		printf("test_mlock_within_limit() left VmLck:%d on %d chunk\n",
-				locked_vm_size, alloc_size);
-		return -1;
-	}
+	if (locked_vm_size > PAGE_ALIGN(alloc_size, page_size) + page_size)
+		ksft_exit_fail_msg("%s left VmLck:%d on %d chunk\n",
+				   __func__, locked_vm_size, alloc_size);
 
-	return 0;
+	ksft_test_result_pass("%s\n", __func__);
 }
 
 
@@ -213,7 +196,7 @@ int test_mlock_within_limit(char *p, int
  *    return value: 0 - success
  *    else: failure
  */
-int test_mlock_outof_limit(char *p, int alloc_size)
+static void test_mlock_outof_limit(char *p, int alloc_size)
 {
 	int i;
 	int ret = 0;
@@ -221,11 +204,9 @@ int test_mlock_outof_limit(char *p, int
 	struct rlimit cur;
 
 	getrlimit(RLIMIT_MEMLOCK, &cur);
-	if (cur.rlim_cur >= alloc_size) {
-		printf("alloc_size[%d] >%u rlimit, violates test condition\n",
-				alloc_size, (unsigned int)cur.rlim_cur);
-		return -1;
-	}
+	if (cur.rlim_cur >= alloc_size)
+		ksft_exit_fail_msg("alloc_size[%d] >%u rlimit, violates test condition\n",
+				   alloc_size, (unsigned int)cur.rlim_cur);
 
 	old_locked_vm_size = get_proc_locked_vm_size();
 	srand(time(NULL));
@@ -240,56 +221,47 @@ int test_mlock_outof_limit(char *p, int
 		else
 			ret = mlock2_(p + start_offset, lock_size,
 					MLOCK_ONFAULT);
-		if (ret == 0) {
-			printf("%s() succeeds? on %p(%d) mlock%p(%d)\n",
-					is_mlock ? "mlock" : "mlock2",
-					p, alloc_size,
-					p + start_offset, lock_size);
-			return -1;
-		}
+		if (ret == 0)
+			ksft_exit_fail_msg("%s() succeeds? on %p(%d) mlock%p(%d)\n",
+					   is_mlock ? "mlock" : "mlock2",
+					   p, alloc_size, p + start_offset, lock_size);
 	}
 
 	locked_vm_size = get_proc_locked_vm_size();
-	if (locked_vm_size != old_locked_vm_size) {
-		printf("tests leads to new mlocked page: old[%d], new[%d]\n",
-				old_locked_vm_size,
-				locked_vm_size);
-		return -1;
-	}
+	if (locked_vm_size != old_locked_vm_size)
+		ksft_exit_fail_msg("tests leads to new mlocked page: old[%d], new[%d]\n",
+				   old_locked_vm_size,
+				   locked_vm_size);
 
-	return 0;
+	ksft_test_result_pass("%s\n", __func__);
 }
 
 int main(int argc, char **argv)
 {
 	char *p = NULL;
-	int ret = 0;
+
+	ksft_print_header();
 
 	if (set_cap_limits(MLOCK_RLIMIT_SIZE))
-		return -1;
+		ksft_finished();
+
+	ksft_set_plan(2);
 
 	p = malloc(MLOCK_WITHIN_LIMIT_SIZE);
-	if (p == NULL) {
-		perror("malloc() failure\n");
-		return -1;
-	}
-	ret = test_mlock_within_limit(p, MLOCK_WITHIN_LIMIT_SIZE);
-	if (ret)
-		return ret;
+	if (p == NULL)
+		ksft_exit_fail_msg("malloc() failure: %s\n", strerror(errno));
+
+	test_mlock_within_limit(p, MLOCK_WITHIN_LIMIT_SIZE);
 	munlock(p, MLOCK_WITHIN_LIMIT_SIZE);
 	free(p);
 
-
 	p = malloc(MLOCK_OUTOF_LIMIT_SIZE);
-	if (p == NULL) {
-		perror("malloc() failure\n");
-		return -1;
-	}
-	ret = test_mlock_outof_limit(p, MLOCK_OUTOF_LIMIT_SIZE);
-	if (ret)
-		return ret;
+	if (p == NULL)
+		ksft_exit_fail_msg("malloc() failure: %s\n", strerror(errno));
+
+	test_mlock_outof_limit(p, MLOCK_OUTOF_LIMIT_SIZE);
 	munlock(p, MLOCK_OUTOF_LIMIT_SIZE);
 	free(p);
 
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

