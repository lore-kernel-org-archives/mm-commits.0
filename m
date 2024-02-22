Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA27C628
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560214; cv=none; b=UmXdI2hnipzUi7z3uyQ6Mhf9j0n/Z/haSn4zkxtNWbaNUJiFzkffefIGqsHwibg5kwrlKmnlLOpZfqeqh8dxn+PxiIROnlyo6ESxOPYxTO3Os2FfYOd1ZNDYYr6kMC0NWhHTcgCEXh4jJP+c0/uZNE+E/orDTQkTU6D6pqgIjHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560214; c=relaxed/simple;
	bh=EqBU34hq/ZNnXZbhufHWpq+kyDnNYALZaoRBDRbKcVw=;
	h=Date:To:From:Subject:Message-Id; b=bz0QTszycADXjXjzimRJaiFgT4zUwAID7ZvTPdJZBk3UHsZ7cMQSsdecb/ubYfGbG7WYH2JVu4iV3gzUFOnkDq0TG1pXC37p1RMr3Bdeg2xMYIMFsn/l5qSci74XBi7ix1dM4zweXTjn4GAOB2Efg01seppVd0rea5wU8230fag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KCpccSnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KCpccSnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E448C43390;
	Thu, 22 Feb 2024 00:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560214;
	bh=EqBU34hq/ZNnXZbhufHWpq+kyDnNYALZaoRBDRbKcVw=;
	h=Date:To:From:Subject:From;
	b=KCpccSnxHt9zpV7onPIe472Q5/jweMnmQYyc7CmaIbotzfxU+7GNoPZmKaTJ57wf6
	 eHB/SoAwcCHls72fN6izOkW9/xoQc3LCKY3aEpm6bpJAZxH6NPEvvhGbwO60Qt8GyV
	 wBMkbdzvRosCAqClHxWLB+kYzU0q2U8XvO/bsmQQ=
Date: Wed, 21 Feb 2024 16:03:33 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,ryan.roberts@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-log-a-consistent-test-name-for-check_compaction.patch removed from -mm tree
Message-Id: <20240222000334.7E448C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: log a consistent test name for check_compaction
has been removed from the -mm tree.  Its filename was
     selftests-mm-log-a-consistent-test-name-for-check_compaction.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: log a consistent test name for check_compaction
Date: Fri, 09 Feb 2024 14:30:04 +0000

Every test result report in the compaction test prints a distinct log
messae, and some of the reports print a name that varies at runtime.  This
causes problems for automation since a lot of automation software uses the
printed string as the name of the test, if the name varies from run to run
and from pass to fail then the automation software can't identify that a
test changed result or that the same tests are being run.

Refactor the logging to use a consistent name when printing the result of
the test, printing the existing messages as diagnostic information instead
so they are still available for people trying to interpret the results.

Link: https://lkml.kernel.org/r/20240209-kselftest-mm-cleanup-v1-2-a3c0386496b5@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |   35 +++++++++--------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-log-a-consistent-test-name-for-check_compaction
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -95,21 +95,22 @@ int check_compaction(unsigned long mem_f
 
 	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
 	if (fd < 0) {
-		ksft_test_result_fail("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
-				      strerror(errno));
-		return -1;
+		ksft_print_msg("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
+		ret = -1;
+		goto out;
 	}
 
 	if (read(fd, initial_nr_hugepages, sizeof(initial_nr_hugepages)) <= 0) {
-		ksft_test_result_fail("Failed to read from /proc/sys/vm/nr_hugepages: %s\n",
-				      strerror(errno));
+		ksft_print_msg("Failed to read from /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
 		goto close_fd;
 	}
 
 	/* Start with the initial condition of 0 huge pages*/
 	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
-		ksft_test_result_fail("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
-				      strerror(errno));
+		ksft_print_msg("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
 		goto close_fd;
 	}
 
@@ -118,16 +119,16 @@ int check_compaction(unsigned long mem_f
 	/* Request a large number of huge pages. The Kernel will allocate
 	   as much as it can */
 	if (write(fd, "100000", (6*sizeof(char))) != (6*sizeof(char))) {
-		ksft_test_result_fail("Failed to write 100000 to /proc/sys/vm/nr_hugepages: %s\n",
-				      strerror(errno));
+		ksft_print_msg("Failed to write 100000 to /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
 		goto close_fd;
 	}
 
 	lseek(fd, 0, SEEK_SET);
 
 	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
-		ksft_test_result_fail("Failed to re-read from /proc/sys/vm/nr_hugepages: %s\n",
-				      strerror(errno));
+		ksft_print_msg("Failed to re-read from /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
 		goto close_fd;
 	}
 
@@ -139,24 +140,26 @@ int check_compaction(unsigned long mem_f
 
 	if (write(fd, initial_nr_hugepages, strlen(initial_nr_hugepages))
 	    != strlen(initial_nr_hugepages)) {
-		ksft_test_result_fail("Failed to write value to /proc/sys/vm/nr_hugepages: %s\n",
-				      strerror(errno));
+		ksft_print_msg("Failed to write value to /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
 		goto close_fd;
 	}
 
+	ksft_print_msg("Number of huge pages allocated = %d\n",
+		       atoi(nr_hugepages));
+
 	if (compaction_index > 3) {
 		ksft_print_msg("ERROR: Less that 1/%d of memory is available\n"
 			       "as huge pages\n", compaction_index);
-		ksft_test_result_fail("No of huge pages allocated = %d\n", (atoi(nr_hugepages)));
 		goto close_fd;
 	}
 
-	ksft_test_result_pass("Memory compaction succeeded. No of huge pages allocated = %d\n",
-			      (atoi(nr_hugepages)));
 	ret = 0;
 
  close_fd:
 	close(fd);
+ out:
+	ksft_test_result(ret == 0, "check_compaction\n");
 	return ret;
 }
 
_

Patches currently in -mm which might be from broonie@kernel.org are


