Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D03EDDA2
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 08:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706430764; cv=none; b=NZG+q/NQhRVlWGIRmSLukXKOZwr/tRYpoMmcRPDYC5U3IQrIm15m05iVp81EgeFd1mhq8R3/pk08bwUnx2DXtJ5mZDugQ0LPpc27qbyBt+V3u3eONgrb/k7vQ3liRANC0PxzgmDLgm4PC3KUdfNpI3jfJZFhRJsUyWSTxsVs6lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706430764; c=relaxed/simple;
	bh=e2tu8jpzI2VzccwEaQ5Ssq+xob/TrLMkT23Ktn8xCwo=;
	h=Date:To:From:Subject:Message-Id; b=hhnaXHKN1J3BbQYXREmQrPTqIwfeXAL3gvCNpd9AmwRB5Rgcvx0r2b9hd08MwHqrWFjiHoOF0a1IpGMWBTjw7xjbACzW9qodZTHyobFH5jgpgS0ZMmsqxi0dLMyhgTYHfjSKHh4yqjn6BzA3ikJLQbxSK9XrVPqoaK5ekGIPTq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dcafIqpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dcafIqpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F28C433C7;
	Sun, 28 Jan 2024 08:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706430763;
	bh=e2tu8jpzI2VzccwEaQ5Ssq+xob/TrLMkT23Ktn8xCwo=;
	h=Date:To:From:Subject:From;
	b=dcafIqpXTLHgd8queMbifNy8x9y2HMGFj4cjrqFzpbRye0tssZ1OqTi3nh/KzQHts
	 TkNO6F2/yY/u8TOoOWOXOS+ZLtfaRcJH1sTxu04d33K42+STvC1Wy8VdNQJZZCM6oD
	 EarQ6Wv1sExf1IsxmuGk0gahR/B0iynqSYyBCIOU=
Date: Sun, 28 Jan 2024 00:32:40 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,jiaqiyan@google.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch added to mm-nonmm-unstable branch
Message-Id: <20240128083243.43F28C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hugepage-shm: conform test to TAP format output
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch

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
Subject: selftests/mm: hugepage-shm: conform test to TAP format output
Date: Fri, 26 Jan 2024 16:21:20 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

The "." was being printed inside for loop to indicate the writes progress.
This was extraneous and hence removed in the patch.

Link: https://lkml.kernel.org/r/20240126112129.1480265-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugepage-shm.c |   47 +++++++++-----------
 1 file changed, 22 insertions(+), 25 deletions(-)

--- a/tools/testing/selftests/mm/hugepage-shm.c~selftests-mm-hugepage-shm-conform-test-to-tap-format-output
+++ a/tools/testing/selftests/mm/hugepage-shm.c
@@ -34,11 +34,10 @@
 #include <sys/ipc.h>
 #include <sys/shm.h>
 #include <sys/mman.h>
+#include "../kselftest.h"
 
 #define LENGTH (256UL*1024*1024)
 
-#define dprintf(x)  printf(x)
-
 /* Only ia64 requires this */
 #ifdef __ia64__
 #define ADDR (void *)(0x8000000000000000UL)
@@ -54,44 +53,42 @@ int main(void)
 	unsigned long i;
 	char *shmaddr;
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	shmid = shmget(2, LENGTH, SHM_HUGETLB | IPC_CREAT | SHM_R | SHM_W);
-	if (shmid < 0) {
-		perror("shmget");
-		exit(1);
-	}
-	printf("shmid: 0x%x\n", shmid);
+	if (shmid < 0)
+		ksft_exit_fail_msg("shmget: %s\n", strerror(errno));
+
+	ksft_print_msg("shmid: 0x%x\n", shmid);
 
 	shmaddr = shmat(shmid, ADDR, SHMAT_FLAGS);
 	if (shmaddr == (char *)-1) {
-		perror("Shared memory attach failure");
 		shmctl(shmid, IPC_RMID, NULL);
-		exit(2);
+		ksft_exit_fail_msg("Shared memory attach failure: %s\n", strerror(errno));
 	}
-	printf("shmaddr: %p\n", shmaddr);
 
-	dprintf("Starting the writes:\n");
-	for (i = 0; i < LENGTH; i++) {
+	ksft_print_msg("shmaddr: %p\n", shmaddr);
+
+	ksft_print_msg("Starting the writes:");
+	for (i = 0; i < LENGTH; i++)
 		shmaddr[i] = (char)(i);
-		if (!(i % (1024 * 1024)))
-			dprintf(".");
-	}
-	dprintf("\n");
+	ksft_print_msg("Done.\n");
 
-	dprintf("Starting the Check...");
+	ksft_print_msg("Starting the Check...");
 	for (i = 0; i < LENGTH; i++)
-		if (shmaddr[i] != (char)i) {
-			printf("\nIndex %lu mismatched\n", i);
-			exit(3);
-		}
-	dprintf("Done.\n");
+		if (shmaddr[i] != (char)i)
+			ksft_exit_fail_msg("\nIndex %lu mismatched\n", i);
+	ksft_print_msg("Done.\n");
 
 	if (shmdt((const void *)shmaddr) != 0) {
-		perror("Detach failure");
 		shmctl(shmid, IPC_RMID, NULL);
-		exit(4);
+		ksft_exit_fail_msg("Detach failure: %s\n", strerror(errno));
 	}
 
 	shmctl(shmid, IPC_RMID, NULL);
 
-	return 0;
+	ksft_test_result_pass("Completed test\n");
+
+	ksft_finished();
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch
selftests-mm-hugepage-vmemmap-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-madvise-conform-test-to-tap-format-output.patch
selftests-mm-khugepaged-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-read-hwpoison-conform-test-to-tap-format-output.patch
selftests-mm-ksm_tests-conform-test-to-tap-format-output.patch
selftests-mm-config-add-missing-configs.patch

