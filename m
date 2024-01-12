Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB66615E94
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 19:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jlwHLQPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64385C433C7;
	Fri, 12 Jan 2024 19:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705088600;
	bh=Lbd1jSDbOpkDG8taPJykJSysGNsdAkkrIvCsnwYkZe8=;
	h=Date:To:From:Subject:From;
	b=jlwHLQPCZxid6D5J4wAG7Gj/WaYot6x4DBH1+hTzo9r7OGC68hJc7+FAb6Fc0il4u
	 TkRCCU4jEtH/nPbreppzNukKZIk88751ZAkrS7hpjBMxd+0TheVoD602qB7YHuey46
	 fsblP0grzdhzY0nwcoMLQA9VnkSTW826XdzYWfI8=
Date: Fri, 12 Jan 2024 11:43:19 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,lstoakes@gmail.com,joel@joelfernandes.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mremap_test-fix-build-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20240112194320.64385C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: mremap_test: fix build warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-mremap_test-fix-build-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mremap_test-fix-build-warning.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: selftests/mm: mremap_test: fix build warning
Date: Fri, 12 Jan 2024 12:18:50 +0500

Use 2 separate variables of types int and unsigned long long instead of
confusing them.  This corrects the correct print format for each of them
and removes the build warning:

warning: format `%d' expects argument of type `int', but argument 2 has type `long long unsigned int'

Link: https://lkml.kernel.org/r/20240112071851.612930-1-usama.anjum@collabora.com
Fixes: a4cb3b243343 ("selftests: mm: add a test for remapping to area immediately after existing mapping")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |   27 ++++++++++-----------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-mremap_test-fix-build-warning
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -360,7 +360,8 @@ static long long remap_region(struct con
 			      char pattern_seed)
 {
 	void *addr, *src_addr, *dest_addr, *dest_preamble_addr;
-	unsigned long long i;
+	int d;
+	unsigned long long t;
 	struct timespec t_start = {0, 0}, t_end = {0, 0};
 	long long  start_ns, end_ns, align_mask, ret, offset;
 	unsigned long long threshold;
@@ -378,8 +379,8 @@ static long long remap_region(struct con
 
 	/* Set byte pattern for source block. */
 	srand(pattern_seed);
-	for (i = 0; i < threshold; i++)
-		memset((char *) src_addr + i, (char) rand(), 1);
+	for (t = 0; t < threshold; t++)
+		memset((char *) src_addr + t, (char) rand(), 1);
 
 	/* Mask to zero out lower bits of address for alignment */
 	align_mask = ~(c.dest_alignment - 1);
@@ -420,8 +421,8 @@ static long long remap_region(struct con
 
 		/* Set byte pattern for the dest preamble block. */
 		srand(pattern_seed);
-		for (i = 0; i < c.dest_preamble_size; i++)
-			memset((char *) dest_preamble_addr + i, (char) rand(), 1);
+		for (d = 0; d < c.dest_preamble_size; d++)
+			memset((char *) dest_preamble_addr + d, (char) rand(), 1);
 	}
 
 	clock_gettime(CLOCK_MONOTONIC, &t_start);
@@ -437,14 +438,14 @@ static long long remap_region(struct con
 
 	/* Verify byte pattern after remapping */
 	srand(pattern_seed);
-	for (i = 0; i < threshold; i++) {
+	for (t = 0; t < threshold; t++) {
 		char c = (char) rand();
 
-		if (((char *) dest_addr)[i] != c) {
+		if (((char *) dest_addr)[t] != c) {
 			ksft_print_msg("Data after remap doesn't match at offset %llu\n",
-				       i);
+				       t);
 			ksft_print_msg("Expected: %#x\t Got: %#x\n", c & 0xff,
-					((char *) dest_addr)[i] & 0xff);
+					((char *) dest_addr)[t] & 0xff);
 			ret = -1;
 			goto clean_up_dest;
 		}
@@ -453,14 +454,14 @@ static long long remap_region(struct con
 	/* Verify the dest preamble byte pattern after remapping */
 	if (c.dest_preamble_size) {
 		srand(pattern_seed);
-		for (i = 0; i < c.dest_preamble_size; i++) {
+		for (d = 0; d < c.dest_preamble_size; d++) {
 			char c = (char) rand();
 
-			if (((char *) dest_preamble_addr)[i] != c) {
+			if (((char *) dest_preamble_addr)[d] != c) {
 				ksft_print_msg("Preamble data after remap doesn't match at offset %d\n",
-					       i);
+					       d);
 				ksft_print_msg("Expected: %#x\t Got: %#x\n", c & 0xff,
-					       ((char *) dest_preamble_addr)[i] & 0xff);
+					       ((char *) dest_preamble_addr)[d] & 0xff);
 				ret = -1;
 				goto clean_up_dest;
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

