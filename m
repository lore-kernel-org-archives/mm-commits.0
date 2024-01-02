Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC5015E94
	for <mm-commits@vger.kernel.org>; Tue,  2 Jan 2024 19:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v2Qi34VG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBA2C433C7;
	Tue,  2 Jan 2024 19:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704223324;
	bh=1GGfCpngoCuJXJjaT++xTNo/jHoY/+tGBZcp3A6Lszs=;
	h=Date:To:From:Subject:From;
	b=v2Qi34VGdGgPusBfdDZPBpeg4U/CVn3ZWNE56N9gn+h1uEQx9SOypNRqdtlP3OVBv
	 imJpJE4zJYvs70OtJsp8krsBkEBf7kw4fBzQdUleGCn2Sxi89WPX787A3ik1euYM5F
	 YxYEDGgVM4Sxo4pNEMU4PluIb6okQo10WX3g5IIY=
Date: Tue, 02 Jan 2024 11:22:03 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-conform-test-to-tap-format-output.patch added to mm-unstable branch
Message-Id: <20240102192204.7CBA2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: conform test to TAP format output
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-conform-test-to-tap-format-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-conform-test-to-tap-format-output.patch

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
Subject: selftests/mm: conform test to TAP format output
Date: Mon, 1 Jan 2024 13:36:12 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240101083614.1076768-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |   91 ++++++++---------
 1 file changed, 44 insertions(+), 47 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-conform-test-to-tap-format-output
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -33,7 +33,7 @@ int read_memory_info(unsigned long *memf
 	FILE *cmdfile = popen(cmd, "r");
 
 	if (!(fgets(buffer, sizeof(buffer), cmdfile))) {
-		perror("Failed to read meminfo\n");
+		ksft_print_msg("Failed to read meminfo: %s\n", strerror(errno));
 		return -1;
 	}
 
@@ -44,7 +44,7 @@ int read_memory_info(unsigned long *memf
 	cmdfile = popen(cmd, "r");
 
 	if (!(fgets(buffer, sizeof(buffer), cmdfile))) {
-		perror("Failed to read meminfo\n");
+		ksft_print_msg("Failed to read meminfo: %s\n", strerror(errno));
 		return -1;
 	}
 
@@ -62,14 +62,14 @@ int prereq(void)
 	fd = open("/proc/sys/vm/compact_unevictable_allowed",
 		  O_RDONLY | O_NONBLOCK);
 	if (fd < 0) {
-		perror("Failed to open\n"
-		       "/proc/sys/vm/compact_unevictable_allowed\n");
+		ksft_print_msg("Failed to open /proc/sys/vm/compact_unevictable_allowed: %s\n",
+			       strerror(errno));
 		return -1;
 	}
 
 	if (read(fd, &allowed, sizeof(char)) != sizeof(char)) {
-		perror("Failed to read from\n"
-		       "/proc/sys/vm/compact_unevictable_allowed\n");
+		ksft_print_msg("Failed to read from /proc/sys/vm/compact_unevictable_allowed: %s\n",
+			       strerror(errno));
 		close(fd);
 		return -1;
 	}
@@ -78,12 +78,13 @@ int prereq(void)
 	if (allowed == '1')
 		return 0;
 
+	ksft_print_msg("Compaction isn't allowed\n");
 	return -1;
 }
 
 int check_compaction(unsigned long mem_free, unsigned int hugepage_size)
 {
-	int fd;
+	int fd, ret = -1;
 	int compaction_index = 0;
 	char initial_nr_hugepages[10] = {0};
 	char nr_hugepages[10] = {0};
@@ -94,18 +95,21 @@ int check_compaction(unsigned long mem_f
 
 	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
 	if (fd < 0) {
-		perror("Failed to open /proc/sys/vm/nr_hugepages");
+		ksft_test_result_fail("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
+				      strerror(errno));
 		return -1;
 	}
 
 	if (read(fd, initial_nr_hugepages, sizeof(initial_nr_hugepages)) <= 0) {
-		perror("Failed to read from /proc/sys/vm/nr_hugepages");
+		ksft_test_result_fail("Failed to read from /proc/sys/vm/nr_hugepages: %s\n",
+				      strerror(errno));
 		goto close_fd;
 	}
 
 	/* Start with the initial condition of 0 huge pages*/
 	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
-		perror("Failed to write 0 to /proc/sys/vm/nr_hugepages\n");
+		ksft_test_result_fail("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
+				      strerror(errno));
 		goto close_fd;
 	}
 
@@ -114,14 +118,16 @@ int check_compaction(unsigned long mem_f
 	/* Request a large number of huge pages. The Kernel will allocate
 	   as much as it can */
 	if (write(fd, "100000", (6*sizeof(char))) != (6*sizeof(char))) {
-		perror("Failed to write 100000 to /proc/sys/vm/nr_hugepages\n");
+		ksft_test_result_fail("Failed to write 100000 to /proc/sys/vm/nr_hugepages: %s\n",
+				      strerror(errno));
 		goto close_fd;
 	}
 
 	lseek(fd, 0, SEEK_SET);
 
 	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
-		perror("Failed to re-read from /proc/sys/vm/nr_hugepages\n");
+		ksft_test_result_fail("Failed to re-read from /proc/sys/vm/nr_hugepages: %s\n",
+				      strerror(errno));
 		goto close_fd;
 	}
 
@@ -129,67 +135,58 @@ int check_compaction(unsigned long mem_f
 	   huge pages */
 	compaction_index = mem_free/(atoi(nr_hugepages) * hugepage_size);
 
-	if (compaction_index > 3) {
-		printf("No of huge pages allocated = %d\n",
-		       (atoi(nr_hugepages)));
-		fprintf(stderr, "ERROR: Less that 1/%d of memory is available\n"
-			"as huge pages\n", compaction_index);
-		goto close_fd;
-	}
-
-	printf("No of huge pages allocated = %d\n",
-	       (atoi(nr_hugepages)));
-
 	lseek(fd, 0, SEEK_SET);
 
 	if (write(fd, initial_nr_hugepages, strlen(initial_nr_hugepages))
 	    != strlen(initial_nr_hugepages)) {
-		perror("Failed to write value to /proc/sys/vm/nr_hugepages\n");
+		ksft_test_result_fail("Failed to write value to /proc/sys/vm/nr_hugepages: %s\n",
+				      strerror(errno));
 		goto close_fd;
 	}
 
-	close(fd);
-	return 0;
+	if (compaction_index > 3) {
+		ksft_print_msg("ERROR: Less that 1/%d of memory is available\n"
+			       "as huge pages\n", compaction_index);
+		ksft_test_result_fail("No of huge pages allocated = %d\n", (atoi(nr_hugepages)));
+		goto close_fd;
+	}
+
+	ksft_test_result_pass("Memory compaction succeeded. No of huge pages allocated = %d\n",
+			      (atoi(nr_hugepages)));
+	ret = 0;
 
  close_fd:
 	close(fd);
-	printf("Not OK. Compaction test failed.");
-	return -1;
+	return ret;
 }
 
 
 int main(int argc, char **argv)
 {
 	struct rlimit lim;
-	struct map_list *list, *entry;
+	struct map_list *list = NULL, *entry;
 	size_t page_size, i;
 	void *map = NULL;
 	unsigned long mem_free = 0;
 	unsigned long hugepage_size = 0;
 	long mem_fragmentable_MB = 0;
 
-	if (prereq() != 0) {
-		printf("Either the sysctl compact_unevictable_allowed is not\n"
-		       "set to 1 or couldn't read the proc file.\n"
-		       "Skipping the test\n");
-		return KSFT_SKIP;
-	}
+	ksft_print_header();
+
+	if (prereq() != 0)
+		return ksft_exit_pass();
+
+	ksft_set_plan(1);
 
 	lim.rlim_cur = RLIM_INFINITY;
 	lim.rlim_max = RLIM_INFINITY;
-	if (setrlimit(RLIMIT_MEMLOCK, &lim)) {
-		perror("Failed to set rlimit:\n");
-		return -1;
-	}
+	if (setrlimit(RLIMIT_MEMLOCK, &lim))
+		ksft_exit_fail_msg("Failed to set rlimit: %s\n", strerror(errno));
 
 	page_size = getpagesize();
 
-	list = NULL;
-
-	if (read_memory_info(&mem_free, &hugepage_size) != 0) {
-		printf("ERROR: Cannot read meminfo\n");
-		return -1;
-	}
+	if (read_memory_info(&mem_free, &hugepage_size) != 0)
+		ksft_exit_fail_msg("Failed to get meminfo\n");
 
 	mem_fragmentable_MB = mem_free * 0.8 / 1024;
 
@@ -225,7 +222,7 @@ int main(int argc, char **argv)
 	}
 
 	if (check_compaction(mem_free, hugepage_size) == 0)
-		return 0;
+		return ksft_exit_pass();
 
-	return -1;
+	return ksft_exit_fail();
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

mm-selftests-hugepage-mremap-conform-test-to-tap-format-output.patch
selftests-mm-gup_test-conform-test-to-tap-format-output.patch
selftests-mm-hugepage-mmap-conform-to-tap-format-output.patch
selftests-mm-conform-test-to-tap-format-output.patch
selftests-mm-skip-test-if-application-doesnt-has-root-privileges.patch

