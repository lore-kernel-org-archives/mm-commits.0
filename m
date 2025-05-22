Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE64724A04F
	for <mm-commits@vger.kernel.org>; Thu, 22 May 2025 20:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747946759; cv=none; b=EGClBU0bJhBnS9Bm/1ftn/OcAooMqS9MosNv7/ussB7KkuhN2c8XjKIjv9Z7gNY9n0o55bJXhvkd9InUssq02v8zZrqODNoNEkD2ZLMQHnt/hdB1Oe5E+w1oNc6Qz5R93sixeM0DNQrGUFU19NpBIJK81in4l02S6W5fFIVg2UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747946759; c=relaxed/simple;
	bh=/9OI/pTJUygollnXPLOtd7WgNZ/QzTSCZT65+UXy9Pw=;
	h=Date:To:From:Subject:Message-Id; b=KOTHDsBMnDEk+iiLYQn33nEyhQwJqdNIV22wUlLpLuSW7Wv80znDkDnEAqtvVP3qxNOPcgFmeoPn0ZSUWjr9YIqi4ykP7zSTfWxWYt4Awl4WR1jpAnkoJRnuVevZ/KLIta0hEFa3XuTA0FTGxn/onms7gBcw06P140nYDAm2C0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YQiDsuPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YQiDsuPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1452FC4CEED;
	Thu, 22 May 2025 20:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747946759;
	bh=/9OI/pTJUygollnXPLOtd7WgNZ/QzTSCZT65+UXy9Pw=;
	h=Date:To:From:Subject:From;
	b=YQiDsuPUJkO7S+9ShJbJ3eZt/WecNPrb9US3DgGvwPYAnoKWAf65/YImQJnBrS5pT
	 SilaSUGbOt5OiIERmZdHNRCDgexwI/V1nAU23ACRoprM3lyFmxF2kVWaedQnsBUQ42
	 DWiL1kD4jfNBLDXlZhkVpFjxqA4CMxoaQYckFxyI=
Date: Thu, 22 May 2025 13:45:58 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,Liam.Howlett@oracle.com,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-deduplicate-test-names-in-madv_populate.patch added to mm-new branch
Message-Id: <20250522204559.1452FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: deduplicate test names in madv_populate
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-deduplicate-test-names-in-madv_populate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-deduplicate-test-names-in-madv_populate.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: deduplicate test names in madv_populate
Date: Thu, 22 May 2025 17:29:00 +0100

The madv_populate selftest has some repetitive code for several different
cases that it covers, included repeated test names used in
ksft_test_result() reports.  This causes problems for automation, the test
name is used to both track the test between runs and distinguish between
multiple tests within the same run.  Fix this by tweaking the messages
with duplication to be more specific about the contexts they're in.

Link: https://lkml.kernel.org/r/20250522-selftests-mm-madv-populate-dedupe-v1-1-fd1dedd79b4b@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/madv_populate.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/mm/madv_populate.c~selftests-mm-deduplicate-test-names-in-madv_populate
+++ a/tools/testing/selftests/mm/madv_populate.c
@@ -172,12 +172,12 @@ static void test_populate_read(void)
 	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap failed\n");
 	ksft_test_result(range_is_not_populated(addr, SIZE),
-			 "range initially not populated\n");
+			 "read range initially not populated\n");
 
 	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
 	ksft_test_result(!ret, "MADV_POPULATE_READ\n");
 	ksft_test_result(range_is_populated(addr, SIZE),
-			 "range is populated\n");
+			 "read range is populated\n");
 
 	munmap(addr, SIZE);
 }
@@ -194,12 +194,12 @@ static void test_populate_write(void)
 	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap failed\n");
 	ksft_test_result(range_is_not_populated(addr, SIZE),
-			 "range initially not populated\n");
+			 "write range initially not populated\n");
 
 	ret = madvise(addr, SIZE, MADV_POPULATE_WRITE);
 	ksft_test_result(!ret, "MADV_POPULATE_WRITE\n");
 	ksft_test_result(range_is_populated(addr, SIZE),
-			 "range is populated\n");
+			 "write range is populated\n");
 
 	munmap(addr, SIZE);
 }
@@ -247,19 +247,19 @@ static void test_softdirty(void)
 	/* Clear any softdirty bits. */
 	clear_softdirty();
 	ksft_test_result(range_is_not_softdirty(addr, SIZE),
-			 "range is not softdirty\n");
+			 "cleared range is not softdirty\n");
 
 	/* Populating READ should set softdirty. */
 	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
-	ksft_test_result(!ret, "MADV_POPULATE_READ\n");
+	ksft_test_result(!ret, "softdirty MADV_POPULATE_READ\n");
 	ksft_test_result(range_is_not_softdirty(addr, SIZE),
-			 "range is not softdirty\n");
+			 "range is not softdirty after MADV_POPULATE_READ\n");
 
 	/* Populating WRITE should set softdirty. */
 	ret = madvise(addr, SIZE, MADV_POPULATE_WRITE);
-	ksft_test_result(!ret, "MADV_POPULATE_WRITE\n");
+	ksft_test_result(!ret, "softdirty MADV_POPULATE_WRITE\n");
 	ksft_test_result(range_is_softdirty(addr, SIZE),
-			 "range is softdirty\n");
+			 "range is softdirty after MADV_POPULATE_WRITE \n");
 
 	munmap(addr, SIZE);
 }
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-deduplicate-test-logging-in-test_mlock_lock.patch
selftests-mm-deduplicate-default-page-size-test-results-in-thuge-gen.patch
selftests-mm-use-standard-ksft_finished-in-cow-and-gup_longterm.patch
selftest-mm-add-helper-for-logging-test-start-and-results.patch
selftests-mm-report-unique-test-names-for-each-cow-test.patch
selftests-mm-fix-test-result-reporting-in-gup_longterm.patch
selftests-mm-deduplicate-test-names-in-madv_populate.patch

