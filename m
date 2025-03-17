Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8651D214A89
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188440; cv=none; b=eEYZ2982YUvuy0UJluzLx1zxynxPP/WK0znEelfqUTuLl8z0fK7pkPHcAoJmuEl+XrBnws/QKl8LUKQtllPAJM5nN8XeBJHiLX3W5YtU5zRZizeYC4YLAp2HgjpK8i9u8OiortCTSZDlF3/Jqt7jz10JGC/FfJ2mh3Rcr6H4H+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188440; c=relaxed/simple;
	bh=zgTIR8ZiJEwVcMmOxz8xFm3vMtYRd1zo/1UDByzjNxQ=;
	h=Date:To:From:Subject:Message-Id; b=f1QYw8wAOffc1TC8m42n32dDGtdA8RiTrODLdrWczlpqJAcMF/YgKzfAbKj5rPC2fOD5F2DzCdWQ/zONtIuV08G89iwfLGF1YB3SV9sX9o/nRI8dhikB8+Jp6NQe0mln2Dm22otEKEFl/HZzBCJYKCj+ZSjWuJ4Li3CoJaZaWMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PZrbB3Gy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PZrbB3Gy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE8FC4CEEC;
	Mon, 17 Mar 2025 05:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188440;
	bh=zgTIR8ZiJEwVcMmOxz8xFm3vMtYRd1zo/1UDByzjNxQ=;
	h=Date:To:From:Subject:From;
	b=PZrbB3Gy483GGyAwR3avAHIfZWTmjz86Wavog6By6U841qallMLgI/NLXZRdsNZen
	 D0OVDoz2vZ1YnxgvZB0c5fx007SmDAb8FflreCk/0Jc3vcEPJ0DqeK8yq87Ct8yAsh
	 rsPyRWvvmKuEsp9kczIcRUCubyiulbCr21/JLR6k=
Date: Sun, 16 Mar 2025 22:13:59 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-uffd-rename-nr_cpus-nr_parallel.patch removed from -mm tree
Message-Id: <20250317051400.5CE8FC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/uffd: rename nr_cpus -> nr_parallel
has been removed from the -mm tree.  Its filename was
     selftests-mm-uffd-rename-nr_cpus-nr_parallel.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm/uffd: rename nr_cpus -> nr_parallel
Date: Tue, 11 Mar 2025 13:18:15 +0000

A later commit will bound this variable so it no longer necessarily
matches the number of CPUs.  Rename it appropriately.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-4-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c     |    8 ++--
 tools/testing/selftests/mm/uffd-common.h     |    2 -
 tools/testing/selftests/mm/uffd-stress.c     |   28 ++++++++---------
 tools/testing/selftests/mm/uffd-unit-tests.c |    2 -
 4 files changed, 20 insertions(+), 20 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-uffd-rename-nr_cpus-nr_parallel
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -10,7 +10,7 @@
 #define BASE_PMD_ADDR ((void *)(1UL << 30))
 
 volatile bool test_uffdio_copy_eexist = true;
-unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
+unsigned long nr_parallel, nr_pages, nr_pages_per_cpu, page_size;
 char *area_src, *area_src_alias, *area_dst, *area_dst_alias, *area_remap;
 int uffd = -1, uffd_flags, finished, *pipefd, test_type;
 bool map_shared;
@@ -269,7 +269,7 @@ void uffd_test_ctx_clear(void)
 	size_t i;
 
 	if (pipefd) {
-		for (i = 0; i < nr_cpus * 2; ++i) {
+		for (i = 0; i < nr_parallel * 2; ++i) {
 			if (close(pipefd[i]))
 				err("close pipefd");
 		}
@@ -365,10 +365,10 @@ int uffd_test_ctx_init(uint64_t features
 	 */
 	uffd_test_ops->release_pages(area_dst);
 
-	pipefd = malloc(sizeof(int) * nr_cpus * 2);
+	pipefd = malloc(sizeof(int) * nr_parallel * 2);
 	if (!pipefd)
 		err("pipefd");
-	for (cpu = 0; cpu < nr_cpus; cpu++)
+	for (cpu = 0; cpu < nr_parallel; cpu++)
 		if (pipe2(&pipefd[cpu * 2], O_CLOEXEC | O_NONBLOCK))
 			err("pipe");
 
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-uffd-rename-nr_cpus-nr_parallel
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -98,7 +98,7 @@ struct uffd_test_case_ops {
 };
 typedef struct uffd_test_case_ops uffd_test_case_ops_t;
 
-extern unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
+extern unsigned long nr_parallel, nr_pages, nr_pages_per_cpu, page_size;
 extern char *area_src, *area_src_alias, *area_dst, *area_dst_alias, *area_remap;
 extern int uffd, uffd_flags, finished, *pipefd, test_type;
 extern bool map_shared;
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-uffd-rename-nr_cpus-nr_parallel
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -180,12 +180,12 @@ static void *background_thread(void *arg
 static int stress(struct uffd_args *args)
 {
 	unsigned long cpu;
-	pthread_t locking_threads[nr_cpus];
-	pthread_t uffd_threads[nr_cpus];
-	pthread_t background_threads[nr_cpus];
+	pthread_t locking_threads[nr_parallel];
+	pthread_t uffd_threads[nr_parallel];
+	pthread_t background_threads[nr_parallel];
 
 	finished = 0;
-	for (cpu = 0; cpu < nr_cpus; cpu++) {
+	for (cpu = 0; cpu < nr_parallel; cpu++) {
 		if (pthread_create(&locking_threads[cpu], &attr,
 				   locking_thread, (void *)cpu))
 			return 1;
@@ -203,7 +203,7 @@ static int stress(struct uffd_args *args
 				   background_thread, (void *)cpu))
 			return 1;
 	}
-	for (cpu = 0; cpu < nr_cpus; cpu++)
+	for (cpu = 0; cpu < nr_parallel; cpu++)
 		if (pthread_join(background_threads[cpu], NULL))
 			return 1;
 
@@ -219,11 +219,11 @@ static int stress(struct uffd_args *args
 	uffd_test_ops->release_pages(area_src);
 
 	finished = 1;
-	for (cpu = 0; cpu < nr_cpus; cpu++)
+	for (cpu = 0; cpu < nr_parallel; cpu++)
 		if (pthread_join(locking_threads[cpu], NULL))
 			return 1;
 
-	for (cpu = 0; cpu < nr_cpus; cpu++) {
+	for (cpu = 0; cpu < nr_parallel; cpu++) {
 		char c;
 		if (bounces & BOUNCE_POLL) {
 			if (write(pipefd[cpu*2+1], &c, 1) != 1)
@@ -246,11 +246,11 @@ static int userfaultfd_stress(void)
 {
 	void *area;
 	unsigned long nr;
-	struct uffd_args args[nr_cpus];
+	struct uffd_args args[nr_parallel];
 	uint64_t mem_size = nr_pages * page_size;
 	int flags = 0;
 
-	memset(args, 0, sizeof(struct uffd_args) * nr_cpus);
+	memset(args, 0, sizeof(struct uffd_args) * nr_parallel);
 
 	if (features & UFFD_FEATURE_WP_UNPOPULATED && test_type == TEST_ANON)
 		flags = UFFD_FEATURE_WP_UNPOPULATED;
@@ -325,7 +325,7 @@ static int userfaultfd_stress(void)
 		 */
 		uffd_test_ops->release_pages(area_dst);
 
-		uffd_stats_reset(args, nr_cpus);
+		uffd_stats_reset(args, nr_parallel);
 
 		/* bounce pass */
 		if (stress(args)) {
@@ -359,7 +359,7 @@ static int userfaultfd_stress(void)
 
 		swap(area_src_alias, area_dst_alias);
 
-		uffd_stats_report(args, nr_cpus);
+		uffd_stats_report(args, nr_parallel);
 	}
 	uffd_test_ctx_clear();
 
@@ -453,9 +453,9 @@ int main(int argc, char **argv)
 		return KSFT_SKIP;
 	}
 
-	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	nr_parallel = sysconf(_SC_NPROCESSORS_ONLN);
 
-	nr_pages_per_cpu = bytes / page_size / nr_cpus;
+	nr_pages_per_cpu = bytes / page_size / nr_parallel;
 	if (!nr_pages_per_cpu) {
 		_err("invalid MiB");
 		usage();
@@ -466,7 +466,7 @@ int main(int argc, char **argv)
 		_err("invalid bounces");
 		usage();
 	}
-	nr_pages = nr_pages_per_cpu * nr_cpus;
+	nr_pages = nr_pages_per_cpu * nr_parallel;
 
 	printf("nr_pages: %lu, nr_pages_per_cpu: %lu\n",
 	       nr_pages, nr_pages_per_cpu);
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-uffd-rename-nr_cpus-nr_parallel
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -198,7 +198,7 @@ uffd_setup_environment(uffd_test_args_t
 
 	nr_pages = UFFD_TEST_MEM_SIZE / page_size;
 	/* TODO: remove this global var.. it's so ugly */
-	nr_cpus = 1;
+	nr_parallel = 1;
 
 	/* Initialize test arguments */
 	args->mem_type = mem_type;
_

Patches currently in -mm which might be from jackmanb@google.com are

scripts-gdb-add-lx_per_cpu_ptr.patch

