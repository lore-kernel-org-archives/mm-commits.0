Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0807B4084D;
	Fri, 24 May 2024 18:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716576949; cv=none; b=P1aRJyz5ZQbiBodOJCD3HJlLZiRFEnArzzvd1pPX/r51EFKsQQdxmGuReEpbOxSyPocazWcChOFSKF5YL7riKUScIEQbd2faOr1qwjfBYdUU1syiQxjXDb5o8GWiiUT6D7lKLD/0WN/o0IerTyBsOnMI+1QzNqcD1DQSS6oFJ5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716576949; c=relaxed/simple;
	bh=B6TUwFIMQhBhX+YVgqWG8QZ4LYCezc1WO/dMAri4U6w=;
	h=Date:To:From:Subject:Message-Id; b=tZX0I8hAU9ryqiWFhYo3o401xRalQ/g26Zx2XdkgVJ+dZC6fGty7r8Dh51IBbYAXen9OstdmhvX0M6nRZ3zMF3e5yKgyvJ6QLUzLl5UsJlhBsR2Sl0dGmhQW//QegIjS62ANQlLO+xvPJeM2s4d3ye7hZsWb7/mzd3uFTow8GxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aQ4QnW8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aQ4QnW8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B1BC2BBFC;
	Fri, 24 May 2024 18:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716576948;
	bh=B6TUwFIMQhBhX+YVgqWG8QZ4LYCezc1WO/dMAri4U6w=;
	h=Date:To:From:Subject:From;
	b=aQ4QnW8nbuze7vSy95ZaHh55qSS1xz+xzs7z7QaNvOIknw+JIxCLwJ1ovxLw4uSOq
	 EgeZZ0I61GVTKNme0kAG6X+1rF4hFf1cdBXRggWbb6x2eSWBwJSeGlUN6jT7pQuY9q
	 tBrwlHgycQiTT9p6Q/0sXgyDpbTCw5vjUFPu45Ic=
Date: Fri, 24 May 2024 11:55:48 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sjayaram@akamai.com,shuah@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-compaction_test-fix-bogus-test-success-on-aarch64.patch removed from -mm tree
Message-Id: <20240524185548.C1B1BC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: compaction_test: fix bogus test success on Aarch64
has been removed from the -mm tree.  Its filename was
     selftests-mm-compaction_test-fix-bogus-test-success-on-aarch64.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: compaction_test: fix bogus test success on Aarch64
Date: Tue, 21 May 2024 13:13:56 +0530

Patch series "Fixes for compaction_test", v2.

The compaction_test memory selftest introduces fragmentation in memory
and then tries to allocate as many hugepages as possible. This series
addresses some problems.

On Aarch64, if nr_hugepages == 0, then the test trivially succeeds since
compaction_index becomes 0, which is less than 3, due to no division by
zero exception being raised. We fix that by checking for division by
zero.

Secondly, correctly set the number of hugepages to zero before trying
to set a large number of them.

Now, consider a situation in which, at the start of the test, a non-zero
number of hugepages have been already set (while running the entire
selftests/mm suite, or manually by the admin). The test operates on 80%
of memory to avoid OOM-killer invocation, and because some memory is
already blocked by hugepages, it would increase the chance of OOM-killing.
Also, since mem_free used in check_compaction() is the value before we
set nr_hugepages to zero, the chance that the compaction_index will
be small is very high if the preset nr_hugepages was high, leading to a
bogus test success.


This patch (of 3):

Currently, if at runtime we are not able to allocate a huge page, the test
will trivially pass on Aarch64 due to no exception being raised on
division by zero while computing compaction_index.  Fix that by checking
for nr_hugepages == 0.  Anyways, in general, avoid a division by zero by
exiting the program beforehand.  While at it, fix a typo, and handle the
case where the number of hugepages may overflow an integer.

Link: https://lkml.kernel.org/r/20240521074358.675031-1-dev.jain@arm.com
Link: https://lkml.kernel.org/r/20240521074358.675031-2-dev.jain@arm.com
Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sri Jayaramappa <sjayaram@akamai.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |   20 +++++++++++------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-compaction_test-fix-bogus-test-success-on-aarch64
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -82,12 +82,13 @@ int prereq(void)
 	return -1;
 }
 
-int check_compaction(unsigned long mem_free, unsigned int hugepage_size)
+int check_compaction(unsigned long mem_free, unsigned long hugepage_size)
 {
+	unsigned long nr_hugepages_ul;
 	int fd, ret = -1;
 	int compaction_index = 0;
-	char initial_nr_hugepages[10] = {0};
-	char nr_hugepages[10] = {0};
+	char initial_nr_hugepages[20] = {0};
+	char nr_hugepages[20] = {0};
 
 	/* We want to test with 80% of available memory. Else, OOM killer comes
 	   in to play */
@@ -134,7 +135,12 @@ int check_compaction(unsigned long mem_f
 
 	/* We should have been able to request at least 1/3 rd of the memory in
 	   huge pages */
-	compaction_index = mem_free/(atoi(nr_hugepages) * hugepage_size);
+	nr_hugepages_ul = strtoul(nr_hugepages, NULL, 10);
+	if (!nr_hugepages_ul) {
+		ksft_print_msg("ERROR: No memory is available as huge pages\n");
+		goto close_fd;
+	}
+	compaction_index = mem_free/(nr_hugepages_ul * hugepage_size);
 
 	lseek(fd, 0, SEEK_SET);
 
@@ -145,11 +151,11 @@ int check_compaction(unsigned long mem_f
 		goto close_fd;
 	}
 
-	ksft_print_msg("Number of huge pages allocated = %d\n",
-		       atoi(nr_hugepages));
+	ksft_print_msg("Number of huge pages allocated = %lu\n",
+		       nr_hugepages_ul);
 
 	if (compaction_index > 3) {
-		ksft_print_msg("ERROR: Less that 1/%d of memory is available\n"
+		ksft_print_msg("ERROR: Less than 1/%d of memory is available\n"
 			       "as huge pages\n", compaction_index);
 		goto close_fd;
 	}
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-va_high_addr_switch-reduce-test-noise.patch
selftests-mm-va_high_addr_switch-dynamically-initialize-testcases-to-enable-lpa2-testing.patch

