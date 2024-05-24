Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD8840867;
	Fri, 24 May 2024 18:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716576951; cv=none; b=SORjxEdEQlCfQytONeRL9MbQ7fdNtSyAviS9v0ij/C7DqPi/tfD0KyFSo9pKAQUv4jdxqyWtZdPDShGTVHhUeMYnwBSPit8dpYHjfMHvh0r+4SF1Wc6i6S8Cw50MMY1rj/kdtlmVjWtwPsjawB/SQzWwkgkY6MMRMWEBX2iui9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716576951; c=relaxed/simple;
	bh=lerouPibmTaCjh8zH1c0PgU/2tJmRrzc3VgEBEn11Fg=;
	h=Date:To:From:Subject:Message-Id; b=Ax1u+xPZQz33AkOMehWSxRYI2NezQvy5fFUW0ymS8XeTWHCxe/M2mKfrc6gGNOIo1469IM6I+atyRLqDiY0IrLQYD42LaChlq2B41CmKzqlkH3DjOc/Y3i44hMn52vjk5Ie3gQWMkYRyrc68hVc/SJGQfC4GJrcJup78rk+XMMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tDxIl/R/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tDxIl/R/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5888C2BD11;
	Fri, 24 May 2024 18:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716576951;
	bh=lerouPibmTaCjh8zH1c0PgU/2tJmRrzc3VgEBEn11Fg=;
	h=Date:To:From:Subject:From;
	b=tDxIl/R/PJ3cGTtA7nnBzVJ3abdL070UPtHEFNgkeCsNgwpBr6RgpDG0D7EYk/3hK
	 OYRePr92BASQ/L1VmDbQ3Rf8ljW0TfQRuXy6rB/Q5mfIM84nL+H8ukNNzlJWJtLwPo
	 jNuAZiYdCiuqwRKXXJNXbJZSST6Q4msPowUjPj8g=
Date: Fri, 24 May 2024 11:55:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sjayaram@akamai.com,shuah@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-compaction_test-fix-bogus-test-success-and-reduce-probability-of-oom-killer-invocation.patch removed from -mm tree
Message-Id: <20240524185550.E5888C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: compaction_test: fix bogus test success and reduce probability of OOM-killer invocation
has been removed from the -mm tree.  Its filename was
     selftests-mm-compaction_test-fix-bogus-test-success-and-reduce-probability-of-oom-killer-invocation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: compaction_test: fix bogus test success and reduce probability of OOM-killer invocation
Date: Tue, 21 May 2024 13:13:58 +0530

Reset nr_hugepages to zero before the start of the test.

If a non-zero number of hugepages is already set before the start of the
test, the following problems arise:

 - The probability of the test getting OOM-killed increases.  Proof:
   The test wants to run on 80% of available memory to prevent OOM-killing
   (see original code comments).  Let the value of mem_free at the start
   of the test, when nr_hugepages = 0, be x.  In the other case, when
   nr_hugepages > 0, let the memory consumed by hugepages be y.  In the
   former case, the test operates on 0.8 * x of memory.  In the latter,
   the test operates on 0.8 * (x - y) of memory, with y already filled,
   hence, memory consumed is y + 0.8 * (x - y) = 0.8 * x + 0.2 * y > 0.8 *
   x.  Q.E.D

 - The probability of a bogus test success increases.  Proof: Let the
   memory consumed by hugepages be greater than 25% of x, with x and y
   defined as above.  The definition of compaction_index is c_index = (x -
   y)/z where z is the memory consumed by hugepages after trying to
   increase them again.  In check_compaction(), we set the number of
   hugepages to zero, and then increase them back; the probability that
   they will be set back to consume at least y amount of memory again is
   very high (since there is not much delay between the two attempts of
   changing nr_hugepages).  Hence, z >= y > (x/4) (by the 25% assumption).
   Therefore, c_index = (x - y)/z <= (x - y)/y = x/y - 1 < 4 - 1 = 3
   hence, c_index can always be forced to be less than 3, thereby the test
   succeeding always.  Q.E.D

Link: https://lkml.kernel.org/r/20240521074358.675031-4-dev.jain@arm.com
Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: <stable@vger.kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sri Jayaramappa <sjayaram@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |   71 +++++++++++------
 1 file changed, 49 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-compaction_test-fix-bogus-test-success-and-reduce-probability-of-oom-killer-invocation
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -82,13 +82,16 @@ int prereq(void)
 	return -1;
 }
 
-int check_compaction(unsigned long mem_free, unsigned long hugepage_size)
+int check_compaction(unsigned long mem_free, unsigned long hugepage_size,
+		     unsigned long initial_nr_hugepages)
 {
 	unsigned long nr_hugepages_ul;
 	int fd, ret = -1;
 	int compaction_index = 0;
-	char initial_nr_hugepages[20] = {0};
 	char nr_hugepages[20] = {0};
+	char init_nr_hugepages[20] = {0};
+
+	sprintf(init_nr_hugepages, "%lu", initial_nr_hugepages);
 
 	/* We want to test with 80% of available memory. Else, OOM killer comes
 	   in to play */
@@ -102,23 +105,6 @@ int check_compaction(unsigned long mem_f
 		goto out;
 	}
 
-	if (read(fd, initial_nr_hugepages, sizeof(initial_nr_hugepages)) <= 0) {
-		ksft_print_msg("Failed to read from /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
-
-	lseek(fd, 0, SEEK_SET);
-
-	/* Start with the initial condition of 0 huge pages*/
-	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
-		ksft_print_msg("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
-
-	lseek(fd, 0, SEEK_SET);
-
 	/* Request a large number of huge pages. The Kernel will allocate
 	   as much as it can */
 	if (write(fd, "100000", (6*sizeof(char))) != (6*sizeof(char))) {
@@ -146,8 +132,8 @@ int check_compaction(unsigned long mem_f
 
 	lseek(fd, 0, SEEK_SET);
 
-	if (write(fd, initial_nr_hugepages, strlen(initial_nr_hugepages))
-	    != strlen(initial_nr_hugepages)) {
+	if (write(fd, init_nr_hugepages, strlen(init_nr_hugepages))
+	    != strlen(init_nr_hugepages)) {
 		ksft_print_msg("Failed to write value to /proc/sys/vm/nr_hugepages: %s\n",
 			       strerror(errno));
 		goto close_fd;
@@ -171,6 +157,41 @@ int check_compaction(unsigned long mem_f
 	return ret;
 }
 
+int set_zero_hugepages(unsigned long *initial_nr_hugepages)
+{
+	int fd, ret = -1;
+	char nr_hugepages[20] = {0};
+
+	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
+	if (fd < 0) {
+		ksft_print_msg("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
+		goto out;
+	}
+	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
+		ksft_print_msg("Failed to read from /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
+		goto close_fd;
+	}
+
+	lseek(fd, 0, SEEK_SET);
+
+	/* Start with the initial condition of 0 huge pages */
+	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
+		ksft_print_msg("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
+		goto close_fd;
+	}
+
+	*initial_nr_hugepages = strtoul(nr_hugepages, NULL, 10);
+	ret = 0;
+
+ close_fd:
+	close(fd);
+
+ out:
+	return ret;
+}
 
 int main(int argc, char **argv)
 {
@@ -181,6 +202,7 @@ int main(int argc, char **argv)
 	unsigned long mem_free = 0;
 	unsigned long hugepage_size = 0;
 	long mem_fragmentable_MB = 0;
+	unsigned long initial_nr_hugepages;
 
 	ksft_print_header();
 
@@ -189,6 +211,10 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(1);
 
+	/* Start the test without hugepages reducing mem_free */
+	if (set_zero_hugepages(&initial_nr_hugepages))
+		ksft_exit_fail();
+
 	lim.rlim_cur = RLIM_INFINITY;
 	lim.rlim_max = RLIM_INFINITY;
 	if (setrlimit(RLIMIT_MEMLOCK, &lim))
@@ -232,7 +258,8 @@ int main(int argc, char **argv)
 		entry = entry->next;
 	}
 
-	if (check_compaction(mem_free, hugepage_size) == 0)
+	if (check_compaction(mem_free, hugepage_size,
+			     initial_nr_hugepages) == 0)
 		ksft_exit_pass();
 
 	ksft_exit_fail();
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-va_high_addr_switch-reduce-test-noise.patch
selftests-mm-va_high_addr_switch-dynamically-initialize-testcases-to-enable-lpa2-testing.patch

