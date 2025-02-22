Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEDF3D76
	for <mm-commits@vger.kernel.org>; Sat, 22 Feb 2025 00:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740183068; cv=none; b=bkh16PIhkoS5ZDgdx3rzPrYeFXQxEUOeK4WzEfcFUw+Nn+MKdftx65F4a5yxi7L71Hgyv+GWCcoW+GtB9zKdeBsXCVpK80jPt7d6iCtK+UKc9M5C1oRJE4qdCX2e1dCfVf/EyOQqIWFY8OKaDO+v0ylw7wPua+tS1xiJ4kvYljs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740183068; c=relaxed/simple;
	bh=BhnZx4gkvCYWCRA9zaSeB6fwksW2iLtoEYbOyj/BHog=;
	h=Date:To:From:Subject:Message-Id; b=SxIWBIqoDbqTN4yfbpGek6Iqu1Et0OzIvUP93m8qlbPo3hSANkBKqKYFibEf465SbVZWRw2vDZrMOEIy+mFlDfsRF3OYHPcmfpDnWRT1Ugy+xP4HJqcLpc2hdoKgSBd//XU41DN35XuhjBBI5AIXV5bTnmrtU94IUl8ZX9Jyw8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vr1d8gSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vr1d8gSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBA4C4CED6;
	Sat, 22 Feb 2025 00:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740183068;
	bh=BhnZx4gkvCYWCRA9zaSeB6fwksW2iLtoEYbOyj/BHog=;
	h=Date:To:From:Subject:From;
	b=Vr1d8gSWwjUxv/ulMzXFYpTgxVrkJ061jn/P69/ugQFiVaQ2t5ILhfaDSNI0j4vr3
	 tjlps/nMCdN1jwjOD5hdMibGVo0iIXhXI8uHMD3WcNrqbRS/6qSnk7A7wWcpapEMQZ
	 bOjlG+DB8J0BrpuRn9tK/U8RNukHcI2MsG9YFJWM=
Date: Fri, 21 Feb 2025 16:11:07 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-rename-nr_cpus-nr_threads.patch added to mm-unstable branch
Message-Id: <20250222001108.3BBA4C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/uffd: rename nr_cpus -> nr_threads
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-uffd-rename-nr_cpus-nr_threads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-rename-nr_cpus-nr_threads.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm/uffd: rename nr_cpus -> nr_threads
Date: Fri, 21 Feb 2025 18:25:44 +0000

A later commit will bound this variable so it no longer necessarily
matches the number of CPUs.  Rename it appropriately.

Link: https://lkml.kernel.org/r/20250221-mm-selftests-v2-5-28c4d66383c5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c     |    8 ++--
 tools/testing/selftests/mm/uffd-common.h     |    2 -
 tools/testing/selftests/mm/uffd-stress.c     |   28 ++++++++---------
 tools/testing/selftests/mm/uffd-unit-tests.c |    2 -
 4 files changed, 20 insertions(+), 20 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-uffd-rename-nr_cpus-nr_threads
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -10,7 +10,7 @@
 #define BASE_PMD_ADDR ((void *)(1UL << 30))
 
 volatile bool test_uffdio_copy_eexist = true;
-unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
+unsigned long nr_threads, nr_pages, nr_pages_per_cpu, page_size;
 char *area_src, *area_src_alias, *area_dst, *area_dst_alias, *area_remap;
 int uffd = -1, uffd_flags, finished, *pipefd, test_type;
 bool map_shared;
@@ -269,7 +269,7 @@ void uffd_test_ctx_clear(void)
 	size_t i;
 
 	if (pipefd) {
-		for (i = 0; i < nr_cpus * 2; ++i) {
+		for (i = 0; i < nr_threads * 2; ++i) {
 			if (close(pipefd[i]))
 				err("close pipefd");
 		}
@@ -365,10 +365,10 @@ int uffd_test_ctx_init(uint64_t features
 	 */
 	uffd_test_ops->release_pages(area_dst);
 
-	pipefd = malloc(sizeof(int) * nr_cpus * 2);
+	pipefd = malloc(sizeof(int) * nr_threads * 2);
 	if (!pipefd)
 		err("pipefd");
-	for (cpu = 0; cpu < nr_cpus; cpu++)
+	for (cpu = 0; cpu < nr_threads; cpu++)
 		if (pipe2(&pipefd[cpu * 2], O_CLOEXEC | O_NONBLOCK))
 			err("pipe");
 
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-uffd-rename-nr_cpus-nr_threads
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -98,7 +98,7 @@ struct uffd_test_case_ops {
 };
 typedef struct uffd_test_case_ops uffd_test_case_ops_t;
 
-extern unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
+extern unsigned long nr_threads, nr_pages, nr_pages_per_cpu, page_size;
 extern char *area_src, *area_src_alias, *area_dst, *area_dst_alias, *area_remap;
 extern int uffd, uffd_flags, finished, *pipefd, test_type;
 extern bool map_shared;
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-uffd-rename-nr_cpus-nr_threads
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -180,12 +180,12 @@ static void *background_thread(void *arg
 static int stress(struct uffd_args *args)
 {
 	unsigned long cpu;
-	pthread_t locking_threads[nr_cpus];
-	pthread_t uffd_threads[nr_cpus];
-	pthread_t background_threads[nr_cpus];
+	pthread_t locking_threads[nr_threads];
+	pthread_t uffd_threads[nr_threads];
+	pthread_t background_threads[nr_threads];
 
 	finished = 0;
-	for (cpu = 0; cpu < nr_cpus; cpu++) {
+	for (cpu = 0; cpu < nr_threads; cpu++) {
 		if (pthread_create(&locking_threads[cpu], &attr,
 				   locking_thread, (void *)cpu))
 			return 1;
@@ -203,7 +203,7 @@ static int stress(struct uffd_args *args
 				   background_thread, (void *)cpu))
 			return 1;
 	}
-	for (cpu = 0; cpu < nr_cpus; cpu++)
+	for (cpu = 0; cpu < nr_threads; cpu++)
 		if (pthread_join(background_threads[cpu], NULL))
 			return 1;
 
@@ -219,11 +219,11 @@ static int stress(struct uffd_args *args
 	uffd_test_ops->release_pages(area_src);
 
 	finished = 1;
-	for (cpu = 0; cpu < nr_cpus; cpu++)
+	for (cpu = 0; cpu < nr_threads; cpu++)
 		if (pthread_join(locking_threads[cpu], NULL))
 			return 1;
 
-	for (cpu = 0; cpu < nr_cpus; cpu++) {
+	for (cpu = 0; cpu < nr_threads; cpu++) {
 		char c;
 		if (bounces & BOUNCE_POLL) {
 			if (write(pipefd[cpu*2+1], &c, 1) != 1)
@@ -246,11 +246,11 @@ static int userfaultfd_stress(void)
 {
 	void *area;
 	unsigned long nr;
-	struct uffd_args args[nr_cpus];
+	struct uffd_args args[nr_threads];
 	uint64_t mem_size = nr_pages * page_size;
 	int flags = 0;
 
-	memset(args, 0, sizeof(struct uffd_args) * nr_cpus);
+	memset(args, 0, sizeof(struct uffd_args) * nr_threads);
 
 	if (features & UFFD_FEATURE_WP_UNPOPULATED && test_type == TEST_ANON)
 		flags = UFFD_FEATURE_WP_UNPOPULATED;
@@ -325,7 +325,7 @@ static int userfaultfd_stress(void)
 		 */
 		uffd_test_ops->release_pages(area_dst);
 
-		uffd_stats_reset(args, nr_cpus);
+		uffd_stats_reset(args, nr_threads);
 
 		/* bounce pass */
 		if (stress(args)) {
@@ -359,7 +359,7 @@ static int userfaultfd_stress(void)
 
 		swap(area_src_alias, area_dst_alias);
 
-		uffd_stats_report(args, nr_cpus);
+		uffd_stats_report(args, nr_threads);
 	}
 	uffd_test_ctx_clear();
 
@@ -453,9 +453,9 @@ int main(int argc, char **argv)
 		return KSFT_SKIP;
 	}
 
-	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	nr_threads = sysconf(_SC_NPROCESSORS_ONLN);
 
-	nr_pages_per_cpu = bytes / page_size / nr_cpus;
+	nr_pages_per_cpu = bytes / page_size / nr_threads;
 	if (!nr_pages_per_cpu) {
 		_err("invalid MiB");
 		usage();
@@ -466,7 +466,7 @@ int main(int argc, char **argv)
 		_err("invalid bounces");
 		usage();
 	}
-	nr_pages = nr_pages_per_cpu * nr_cpus;
+	nr_pages = nr_pages_per_cpu * nr_threads;
 
 	printf("nr_pages: %lu, nr_pages_per_cpu: %lu\n",
 	       nr_pages, nr_pages_per_cpu);
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-uffd-rename-nr_cpus-nr_threads
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -198,7 +198,7 @@ uffd_setup_environment(uffd_test_args_t
 
 	nr_pages = UFFD_TEST_MEM_SIZE / page_size;
 	/* TODO: remove this global var.. it's so ugly */
-	nr_cpus = 1;
+	nr_threads = 1;
 
 	/* Initialize test arguments */
 	args->mem_type = mem_type;
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-fix-assumption-that-sudo-is-present.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_threads.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch

