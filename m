Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A34171AC
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 19:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kuOpOwwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DD4C433F1;
	Fri, 12 Jan 2024 19:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705088272;
	bh=JytlekYcQwRzLR4fq8Yqg0OljPzAVo4zJTdQ1MrLiuI=;
	h=Date:To:From:Subject:From;
	b=kuOpOwwMCejhXXlcIqtmyOd5dTb3mM5cM8WBpZQdy8bGpeB9qgFZOJT1FtDCfhWWQ
	 E0ARS1O4aD84QHw+mY/ZG3hX4kSp0Jd+plPjpySrXLsZsZVDK+9l4zqTPRvS6sQypi
	 aC4Dq/g7jU8GNbpzP9MaaBFdqm+H9DazV3/c5SyA=
Date: Fri, 12 Jan 2024 11:37:51 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch added to mm-unstable branch
Message-Id: <20240112193752.49DD4C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hugepage-shm: conform test to TAP format output
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch

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
Subject: selftests/mm: hugepage-shm: conform test to TAP format output
Date: Fri, 12 Jan 2024 12:21:34 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

The "." was being printed inside for loop to indicate the writes progress.
This was extraneous and hence removed in the patch.

Link: https://lkml.kernel.org/r/20240112072144.620098-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
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

fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock.patch
selftests-mm-mremap_test-fix-build-warning.patch
selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch
selftests-mm-hugepage-vmemmap-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-madvise-conform-test-to-tap-format-output.patch
selftests-mm-khugepaged-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-read-hwpoison-conform-test-to-tap-format-output.patch
selftests-mm-ksm_tests-conform-test-to-tap-format-output.patch
selftests-mm-config-add-missing-configs.patch

