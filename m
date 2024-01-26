Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DBF125DB
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 07:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255696; cv=none; b=nfmCb4U92rL3VxDuIcmYfeLP9dWww+VHhIcHZJ+uMjlIfplM0amqB3pGr/tYhKa1n4bTSoXjUVWuqOI31LTVSeQtc0X3ekWOUVH1p49r9U9Ml6s5c1cFvMm7xCyxElEMH1Frv9byk3bROLDJkq0VsGixaGxPEXuKDb7UkJW64cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255696; c=relaxed/simple;
	bh=8an9quhf7W+57X8dMORVYYXaL6rbTKikMTZZLof4tG4=;
	h=Date:To:From:Subject:Message-Id; b=D0jjKnQ/EFjyn9iX6yJ8My5XSb1eSouUYy6XsEGOPg9ZNMRyGSt04RrySW3z+mTCJpJJP4ZICjGy85esaHASfekxCSE33pO3Bkc2SDz7YmelAQS95pXkvcRdjzsB/mPfweQlLg63vPv3ojIapInv1A+BaIkkDfXj9Uv+oogOPbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ym5ljqmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ym5ljqmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A540AC433F1;
	Fri, 26 Jan 2024 07:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255696;
	bh=8an9quhf7W+57X8dMORVYYXaL6rbTKikMTZZLof4tG4=;
	h=Date:To:From:Subject:From;
	b=ym5ljqmyVo1WTO/o7W1Jur9cG7oyey1BozBe9cRWcaZJR9NRw6G1PcfnjEMrRY/Qq
	 Y8oi2IR89NzLBUUiAuus1J7qoXFs+hHLXRLlgFSSdyn2DtHeyXmXclrP4MgPzJ8lUQ
	 I8NQPLdKIYZfqwHZp6HDXOK+YuNlKGuQlYLo+cDQ=
Date: Thu, 25 Jan 2024 23:54:53 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,lstoakes@gmail.com,joel@joelfernandes.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mremap_test-fix-build-warning.patch removed from -mm tree
Message-Id: <20240126075455.A540AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: mremap_test: fix build warning
has been removed from the -mm tree.  Its filename was
     selftests-mm-mremap_test-fix-build-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch

