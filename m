Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012101805F
	for <mm-commits@vger.kernel.org>; Fri,  9 Feb 2024 22:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707516482; cv=none; b=J3mrGlywM5wZ4V5UIv0HHEfPnp4nWaWmtskJ3jmVtuDVkTqXppXtVAEqxmU5T3TQDfdiIaIM0OGFedMjCGJ2jBTkX/h5bio0J4Yk2sqQtjt90LWsdw4DtQ8Z+BpWXaOXu5iXuvStPhfmLHMu98ur1cHAuJCmuPeqCzdZ8Re7osc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707516482; c=relaxed/simple;
	bh=q1qcW519OYw/jsjtbrTmdN5q9ugN1NEQejRaqIZ5kYE=;
	h=Date:To:From:Subject:Message-Id; b=TXCGQNnLghYa0d9pwjfk8XjAz1qgUJRMXlooq2x3NwFg3BiclS/mwnFTnLRUu8nUWMDixv+R+hJw24WLbpt6j/bXlO8k+jnqs49GRyGbgPBipP+1wAJb4rWfxT0VwZQusRegGM2NSgKYGU1oppZ5UQemHSDUSiN/24BPNP2/PXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SDnHbD5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SDnHbD5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D0DC43390;
	Fri,  9 Feb 2024 22:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707516481;
	bh=q1qcW519OYw/jsjtbrTmdN5q9ugN1NEQejRaqIZ5kYE=;
	h=Date:To:From:Subject:From;
	b=SDnHbD5EHU0bxIILG+lAC8GHqBkI/MnnLgO1wMdfbC8CDNBr8kREY1cDUXf8Sqojo
	 bRc7xOf24cuhfZlNvc0V5w6Bcf7Fcj7lAq3VizSW4CBhTkmnP4erLWiJdDN9su60wP
	 hX3YdOpqPZYPj7gV4tgvXmasTMYyVZOgjmCpcgRY=
Date: Fri, 09 Feb 2024 14:08:00 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,ryan.roberts@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-log-a-consistent-test-name-for-check_compaction.patch added to mm-unstable branch
Message-Id: <20240209220801.55D0DC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: log a consistent test name for check_compaction
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-log-a-consistent-test-name-for-check_compaction.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-log-a-consistent-test-name-for-check_compaction.patch

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

selftests-mm-log-skipped-compaction-test-as-a-skip.patch
selftests-mm-log-a-consistent-test-name-for-check_compaction.patch
selftests-mm-dont-needlessly-use-sudo-to-obtain-root-in-run_vmtestssh.patch

