Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64F536AB49
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067159; cv=none; b=trpqc7QzNJIAKYhfy3jCLgSN7GVmqNaz5NUf2xCjUKKNsOrh45iyEK4cFw5laI5DzOwIqGC1CcAphgx5DOJb+b8LhUIKsE0qK5mspX+QD+4Qr/EbjuwCE+/Wt+CvWkTVLGoutUtCzwdaGWrk/k88T7BJc/gNskFVGzkgCluVnAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067159; c=relaxed/simple;
	bh=RDMJ2+kqmaRba11Bea68D0ciLOdV7J5sWpA52xTImng=;
	h=Date:To:From:Subject:Message-Id; b=oSNxS99VXX9ElmoLRH1JuEI9AptyFIaRX1fX7kXuhqjRv59v/geTSVZm6LJGrn5vYxI305WQJ1BZMebZgqrHg0/G1NqkAjd6ZOlpCJagxRKaAdUJYyrvh2YzGZEfc20C+/GYR4eb4vaH5si7ZB8IxboguQDC9LVyz01/iA2t5Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q2sYcw89; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q2sYcw89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8901F00A3A;
	Sun, 21 Jun 2026 18:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067157;
	bh=D2FpjizFuNfLXLqV+yeSAIejCdrspM+6PyOBSKQUPes=;
	h=Date:To:From:Subject;
	b=Q2sYcw89NthEbb/FEY3siX/y1d0fiI7dAN6ra73x6JTTo6bU4aZRPsG0e5hSjZoSl
	 guMAd2Z0xk3jQO8tkMIpwz5P9DTKt/p6jtubr4fKo7Tp86yVF9CuCBfbZHdmD3M1W/
	 4mDDjpREG4SrKj4lFZQ+aPyFnhbTr2kvNMHjmGn8=
Date: Sun, 21 Jun 2026 11:39:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-compaction_test-use-hugetlb-helpers.patch removed from -mm tree
Message-Id: <20260621183917.9E8901F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: compaction_test: use HugeTLB helpers ...
has been removed from the -mm tree.  Its filename was
     selftests-mm-compaction_test-use-hugetlb-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: compaction_test: use HugeTLB helpers ...
Date: Mon, 11 May 2026 19:28:15 +0300

... instead of open coded access of HugeTLB parameters via /proc.

Link: https://lore.kernel.org/20260511162840.375890-32-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |  115 ++---------------
 1 file changed, 17 insertions(+), 98 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-compaction_test-use-hugetlb-helpers
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -17,6 +17,7 @@
 #include <string.h>
 
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #define MAP_SIZE_MB	100
 #define MAP_SIZE	(MAP_SIZE_MB * 1024 * 1024)
@@ -82,124 +83,44 @@ int prereq(void)
 	return -1;
 }
 
-int check_compaction(unsigned long mem_free, unsigned long hugepage_size,
-		     unsigned long initial_nr_hugepages)
+int check_compaction(unsigned long mem_free, unsigned long hugepage_size)
 {
-	unsigned long nr_hugepages_ul;
-	int fd, ret = -1;
+	unsigned long nr_hugepages;
 	int compaction_index = 0;
-	char nr_hugepages[20] = {0};
-	char init_nr_hugepages[24] = {0};
-	char target_nr_hugepages[24] = {0};
-	int slen;
-
-	snprintf(init_nr_hugepages, sizeof(init_nr_hugepages),
-		 "%lu", initial_nr_hugepages);
+	int ret = -1;
 
 	/* We want to test with 80% of available memory. Else, OOM killer comes
 	   in to play */
 	mem_free = mem_free * 0.8;
 
-	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
-	if (fd < 0) {
-		ksft_print_msg("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		ret = -1;
-		goto out;
-	}
-
 	/*
 	 * Request huge pages for about half of the free memory. The Kernel
 	 * will allocate as much as it can, and we expect it will get at least 1/3
 	 */
-	nr_hugepages_ul = mem_free / hugepage_size / 2;
-	snprintf(target_nr_hugepages, sizeof(target_nr_hugepages),
-		 "%lu", nr_hugepages_ul);
-
-	slen = strlen(target_nr_hugepages);
-	if (write(fd, target_nr_hugepages, slen) != slen) {
-		ksft_print_msg("Failed to write %lu to /proc/sys/vm/nr_hugepages: %s\n",
-			       nr_hugepages_ul, strerror(errno));
-		goto close_fd;
-	}
-
-	lseek(fd, 0, SEEK_SET);
-
-	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
-		ksft_print_msg("Failed to re-read from /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
+	nr_hugepages = mem_free / hugepage_size / 2;
+	hugetlb_set_nr_default_pages(nr_hugepages);
 
 	/* We should have been able to request at least 1/3 rd of the memory in
 	   huge pages */
-	nr_hugepages_ul = strtoul(nr_hugepages, NULL, 10);
-	if (!nr_hugepages_ul) {
+	nr_hugepages = hugetlb_nr_default_pages();
+	if (!nr_hugepages) {
 		ksft_print_msg("ERROR: No memory is available as huge pages\n");
-		goto close_fd;
-	}
-	compaction_index = mem_free/(nr_hugepages_ul * hugepage_size);
-
-	lseek(fd, 0, SEEK_SET);
-
-	if (write(fd, init_nr_hugepages, strlen(init_nr_hugepages))
-	    != strlen(init_nr_hugepages)) {
-		ksft_print_msg("Failed to write value to /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
+		goto out;
 	}
+	compaction_index = mem_free/(nr_hugepages * hugepage_size);
 
-	ksft_print_msg("Number of huge pages allocated = %lu\n",
-		       nr_hugepages_ul);
+	ksft_print_msg("Number of huge pages allocated = %lu\n", nr_hugepages);
 
 	if (compaction_index > 3) {
 		ksft_print_msg("ERROR: Less than 1/%d of memory is available\n"
 			       "as huge pages\n", compaction_index);
-		goto close_fd;
-	}
-
-	ret = 0;
-
- close_fd:
-	close(fd);
- out:
-	ksft_test_result(ret == 0, "check_compaction\n");
-	return ret;
-}
-
-int set_zero_hugepages(unsigned long *initial_nr_hugepages)
-{
-	int fd, ret = -1;
-	char nr_hugepages[20] = {0};
-
-	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
-	if (fd < 0) {
-		ksft_print_msg("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
 		goto out;
 	}
-	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
-		ksft_print_msg("Failed to read from /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
-
-	lseek(fd, 0, SEEK_SET);
 
-	/* Start with the initial condition of 0 huge pages */
-	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
-		ksft_print_msg("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
-
-	*initial_nr_hugepages = strtoul(nr_hugepages, NULL, 10);
 	ret = 0;
 
- close_fd:
-	close(fd);
-
  out:
+	ksft_test_result(ret == 0, "check_compaction\n");
 	return ret;
 }
 
@@ -212,18 +133,17 @@ int main(int argc, char **argv)
 	unsigned long mem_free = 0;
 	unsigned long hugepage_size = 0;
 	long mem_fragmentable_MB = 0;
-	unsigned long initial_nr_hugepages;
 
 	ksft_print_header();
 
 	if (prereq() || geteuid())
 		ksft_exit_skip("Prerequisites unsatisfied\n");
 
-	ksft_set_plan(1);
-
 	/* Start the test without hugepages reducing mem_free */
-	if (set_zero_hugepages(&initial_nr_hugepages))
-		ksft_exit_fail();
+	if (!hugetlb_setup_default_exact(0))
+		ksft_exit_skip("Could not reset nr_hugepages\n");
+
+	ksft_set_plan(1);
 
 	lim.rlim_cur = RLIM_INFINITY;
 	lim.rlim_max = RLIM_INFINITY;
@@ -268,8 +188,7 @@ int main(int argc, char **argv)
 		entry = entry->next;
 	}
 
-	if (check_compaction(mem_free, hugepage_size,
-			     initial_nr_hugepages) == 0)
+	if (check_compaction(mem_free, hugepage_size) == 0)
 		ksft_exit_pass();
 
 	ksft_exit_fail();
_

Patches currently in -mm which might be from rppt@kernel.org are


