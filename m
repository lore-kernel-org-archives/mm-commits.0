Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B3A156F28
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756849; cv=none; b=ZKFmAVftiLvNb0QnzYrbbBYipfCYeCvP6+gnoZcxN02XGaKKn1UJoLHIAmqgiMvQzHoWnS+vz1s5iWn7rkCoWYdp+Yb/nIb9iTIz3v7ox5FdDdpjsXE5P1b/60iKVgo/cC/07ayCG1HRnZE0nNxPfVQBE7nhCwTqQyMChkQUr+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756849; c=relaxed/simple;
	bh=O+0nfDFagsQ+9z+2yqKzbwiJBpS3gN2co4qovJMGfcg=;
	h=Date:To:From:Subject:Message-Id; b=GQAzkdyYn9v/Bp2mGe3+7VkCHdPGpToilESBu82aGaeEx9vadcg+puYIbe4+QABrSUPlEfX4oohC5d/x17tKudW5ETjeFb/yBVmRYjgCa4sCpV8qkBAYJYo/FYF2TKMrjbggbr5O/5Oj8Kj/W/GaGH+nH6Ak6sLsx1RxIXDj7pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CnD1ZU2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CnD1ZU2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02ADC4CEED;
	Sun,  1 Jun 2025 05:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756848;
	bh=O+0nfDFagsQ+9z+2yqKzbwiJBpS3gN2co4qovJMGfcg=;
	h=Date:To:From:Subject:From;
	b=CnD1ZU2hrCcPznrAL4f1kRmHw6/SEC1S8TUHTGTM8uiw1op/1ewUQ2owAjumnrJWO
	 lCAVqO0+O+HVtWC3N7BexefeyVuufUq55Hbc0rE/i8NHU+3J9+a6UhiRO58k/97LQd
	 ffR8Fw3R48yDULZS9MFNmC8hKR9ymR0TfQeY5RHo=
Date: Sat, 31 May 2025 22:47:28 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,Liam.Howlett@oracle.com,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-deduplicate-test-names-in-madv_populate.patch removed from -mm tree
Message-Id: <20250601054728.A02ADC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: deduplicate test names in madv_populate
has been removed from the -mm tree.  Its filename was
     selftests-mm-deduplicate-test-names-in-madv_populate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
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


