Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D6B2D0C89
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334183; cv=none; b=TgqKRCjMYomKvtPxEve5pEv2DJe7FOuk5e5dpcOxGz5nef1IMeGVujyrNNOG3m8JsonyY0BCDuGOUdM8xsCK1pYHs8l/4UsF0w28GT6fOQVHijxVXPdYD8IvQBUM6IexUNo8gVrzDFHg3gmF9WfUcNFjiPexXe+8DGTnOvcucK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334183; c=relaxed/simple;
	bh=IgMvXmw6c107//DCB6ogWuIsgHfM1L4F2RxXAfFOeQw=;
	h=Date:To:From:Subject:Message-Id; b=haXTZ9Cu63X/89rDVck5R6kRfGawWFNU4Bvdl74nFYCwrdULK3IGTEQlwfNdMjZAjFa8VkTYDZxVL11kwAYABntKqBYdQhRGoXh47Lw5KR8mSijH9RPXoH6P9ihwRs7wucCkCayuWCrMDIoOHQsOUsMuSXLXgU2YDyPSL827J8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pmuE5uO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pmuE5uO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AFB1F0089B;
	Wed,  7 Oct 2026 00:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334179;
	bh=qGfHFcMUOmFoUJ6J5JRwdKPTbIFUPjxc4lMlLHnWYLY=;
	h=Date:To:From:Subject;
	b=pmuE5uO5Xoqw4aYkajWOEBRYC6JH5Qa3UHLLcmKSLWoJCQBdd3+DvrP7uml19l7YN
	 M03aWz+/1iuPpvFpdjem0VjQZHmSt6x626ZuNG78I8AWBpelkBwid0VJ9M3q43OPKy
	 uyEPaxtxYrGD5gSV5h9dEMBEFEF1A0gYWftHXtqA=
Date: Tue, 06 Oct 2026 17:49:38 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-emit-tap-header-and-use-tap-skip-in-mremap_test.patch removed from -mm tree
Message-Id: <20261007004939.05AFB1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: emit TAP header and use TAP skip in mremap_test
has been removed from the -mm tree.  Its filename was
     selftests-mm-emit-tap-header-and-use-tap-skip-in-mremap_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Song Hu <husong@kylinos.cn>
Subject: selftests/mm: emit TAP header and use TAP skip in mremap_test
Date: Tue, 25 Aug 2026 16:57:55 +0800

mremap_test calls ksft_set_plan() without ksft_print_header(), and its
get_mmap_min_addr() skip path uses a bare exit(KSFT_SKIP) that prints no
TAP line, so its output is not valid KTAP.  Add the header and switch the
skip to ksft_exit_skip().

Also fix two more KTAP compliance issues spotted in review:

- get_mmap_min_addr() calls strerror(errno) after fclose(), which may
  clobber errno; save errno before fclose() instead.

- Some ksft_*() messages embed "\n\t", so the text after each embedded
  newline is printed without the "# " prefix.  Split those into separate
  messages.

And cache mmap_min_addr in main() before ksft_set_plan(), so that the skip
paths in get_mmap_min_addr() are taken before the plan is set; a skip
after the plan leaves the run with fewer tests than planned.

Link: https://lore.kernel.org/20260825085756.63030-3-husong@kylinos.cn
Signed-off-by: Song Hu <husong@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/mm/mremap_test.c |   43 ++++++++++++---------
 1 file changed, 25 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-emit-tap-header-and-use-tap-skip-in-mremap_test
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -111,18 +111,17 @@ static unsigned long long get_mmap_min_a
 		return addr;
 
 	fp = fopen("/proc/sys/vm/mmap_min_addr", "r");
-	if (fp == NULL) {
-		ksft_print_msg("Failed to open /proc/sys/vm/mmap_min_addr: %s\n",
-			strerror(errno));
-		exit(KSFT_SKIP);
-	}
+	if (!fp)
+		ksft_exit_skip("Failed to open /proc/sys/vm/mmap_min_addr: %s\n",
+			       strerror(errno));
 
 	n_matched = fscanf(fp, "%llu", &addr);
 	if (n_matched != 1) {
-		ksft_print_msg("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
-			strerror(errno));
+		int err = errno;
+
 		fclose(fp);
-		exit(KSFT_SKIP);
+		ksft_exit_skip("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
+			       strerror(err));
 	}
 
 	fclose(fp);
@@ -1165,10 +1164,11 @@ static void run_mremap_test_case(struct
 					    rand_addr);
 
 	if (remap_time < 0) {
-		if (test_case.expect_failure)
-			ksft_test_result_xfail("%s\n\tExpected mremap failure\n",
-					      test_case.name);
-		else {
+		if (test_case.expect_failure) {
+			ksft_print_msg("%s: expected mremap failure\n",
+				       test_case.name);
+			ksft_test_result_xfail("%s\n", test_case.name);
+		} else {
 			ksft_test_result_fail("%s\n", test_case.name);
 			*failures += 1;
 		}
@@ -1178,11 +1178,13 @@ static void run_mremap_test_case(struct
 		 * was faulted in.
 		 */
 		if (threshold_mb == VALIDATION_NO_THRESHOLD ||
-		    test_case.config.region_size <= threshold_mb * _1MB)
-			ksft_test_result_pass("%s\n\tmremap time: %12lldns\n",
-					      test_case.name, remap_time);
-		else
+		    test_case.config.region_size <= threshold_mb * _1MB) {
+			ksft_print_msg("%s: mremap time: %12lldns\n",
+				       test_case.name, remap_time);
 			ksft_test_result_pass("%s\n", test_case.name);
+		} else {
+			ksft_test_result_pass("%s\n", test_case.name);
+		}
 	}
 }
 
@@ -1251,13 +1253,18 @@ int main(int argc, char **argv)
 	time_t t;
 	FILE *maps_fp;
 
+	ksft_print_header();
+
+	get_mmap_min_addr();
+
 	pattern_seed = (unsigned int) time(&t);
 
 	if (parse_args(argc, argv, &threshold_mb, &pattern_seed) < 0)
 		exit(EXIT_FAILURE);
 
-	ksft_print_msg("Test configs:\n\tthreshold_mb=%u\n\tpattern_seed=%u\n\n",
-		       threshold_mb, pattern_seed);
+	ksft_print_msg("Test configs:\n");
+	ksft_print_msg("threshold_mb=%u\n", threshold_mb);
+	ksft_print_msg("pattern_seed=%u\n", pattern_seed);
 
 	/*
 	 * set preallocated random array according to test configs; see the
_

Patches currently in -mm which might be from husong@kylinos.cn are


