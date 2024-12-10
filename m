Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CA12AD16
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 01:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733794682; cv=none; b=GT+RJUWM4zrr69QGwoLKSeie05AVsUgmgQ/oNN9mZ1Zr8SGVkx8gEX5dbRzwum8sH3AjEaRAa7vqOOTNsQFOZlN1Q2SSJ5AK8lL9rYoxvkhkYNNx7DMO8NcinCv1Q2LHYHGEbC9JSYcVvZfGKksSlj7k2H7gx3CXwKu90hv8Ymk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733794682; c=relaxed/simple;
	bh=VED6oGaNQRJgoJKDCb1jXvU/+ohynNoGlOXYddVPgYU=;
	h=Date:To:From:Subject:Message-Id; b=U9xfn2lldEZTwRs3h9H76PIefc72yUCJnByYMlml7oKSArh42Vq0lR6y4kOq0Ycy8vJkXTfKQpLI+Ma/6KaVEMq2LmlJIe4OY10fzeEJ04aUhZLkbHJwGbFfsr6e99wu3geY7SQuk6yWMsJw0ZGn8jWO3oAfJMJPjX2RfH2pDZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iBuowyUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iBuowyUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336F5C4CED1;
	Tue, 10 Dec 2024 01:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733794682;
	bh=VED6oGaNQRJgoJKDCb1jXvU/+ohynNoGlOXYddVPgYU=;
	h=Date:To:From:Subject:From;
	b=iBuowyUZMVQs2eamxr7hB99bNddn3oLAsWL4Ey35OKltuYUOGYq0TqalQoAlIiCAP
	 1q+ACkKq2XqqGGDXdW+wOih+v9c/FgTb3EZmzsHDgl/IDiMztp8E4f1ggfx+hErTVU
	 j03GognVG9QzDqC2QkaDRgljNetx+FGbGJFCIu5M=
Date: Mon, 09 Dec 2024 17:38:01 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mremap_test-remove-unused-variable-and-type-mismatches.patch added to mm-unstable branch
Message-Id: <20241210013802.336F5C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: mremap_test: Remove unused variable and type mismatches
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-mremap_test-remove-unused-variable-and-type-mismatches.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mremap_test-remove-unused-variable-and-type-mismatches.patch

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
Subject: selftests/mm: mremap_test: Remove unused variable and type mismatches
Date: Mon, 9 Dec 2024 23:56:24 +0500

Remove unused variable and fix type mismatches.

Link: https://lkml.kernel.org/r/20241209185624.2245158-5-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-mremap_test-remove-unused-variable-and-type-mismatches
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -34,7 +34,7 @@ struct config {
 	unsigned long long dest_alignment;
 	unsigned long long region_size;
 	int overlapping;
-	int dest_preamble_size;
+	unsigned int dest_preamble_size;
 };
 
 struct test {
@@ -328,7 +328,7 @@ static void mremap_move_within_range(uns
 {
 	char *test_name = "mremap mremap move within range";
 	void *src, *dest;
-	int i, success = 1;
+	unsigned int i, success = 1;
 
 	size_t size = SIZE_MB(20);
 	void *ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
@@ -569,7 +569,7 @@ static void mremap_move_1mb_from_start(u
 {
 	char *test_name = "mremap move 1mb from start at 1MB+256KB aligned src";
 	void *src = NULL, *dest = NULL;
-	int i, success = 1;
+	unsigned int i, success = 1;
 
 	/* Config to reuse get_source_mapping() to do an aligned mmap. */
 	struct config c = {
@@ -636,7 +636,7 @@ out:
 
 static void run_mremap_test_case(struct test test_case, int *failures,
 				 unsigned int threshold_mb,
-				 unsigned int pattern_seed, char *rand_addr)
+				 char *rand_addr)
 {
 	long long remap_time = remap_region(test_case.config, threshold_mb,
 					    rand_addr);
@@ -708,7 +708,8 @@ static int parse_args(int argc, char **a
 int main(int argc, char **argv)
 {
 	int failures = 0;
-	int i, run_perf_tests;
+	unsigned int i;
+	int run_perf_tests;
 	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
 
 	/* hard-coded test configs */
@@ -831,7 +832,7 @@ int main(int argc, char **argv)
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
 		run_mremap_test_case(test_cases[i], &failures, threshold_mb,
-				     pattern_seed, rand_addr);
+				     rand_addr);
 
 	maps_fp = fopen("/proc/self/maps", "r");
 
@@ -853,7 +854,7 @@ int main(int argc, char **argv)
 		 "mremap HAVE_MOVE_PMD/PUD optimization time comparison for 1GB region:");
 		for (i = 0; i < ARRAY_SIZE(perf_test_cases); i++)
 			run_mremap_test_case(perf_test_cases[i], &failures,
-					     threshold_mb, pattern_seed,
+					     threshold_mb,
 					     rand_addr);
 	}
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-thp_settings-remove-const-from-return-type.patch
selftests-mm-pagemap_ioctl-fix-types-mismatches-shown-by-compiler-options.patch
selftests-mm-mseal_test-remove-unused-variables.patch
selftests-mm-mremap_test-remove-unused-variable-and-type-mismatches.patch

