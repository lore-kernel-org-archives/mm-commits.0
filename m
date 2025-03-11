Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F5A2620E5
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741714610; cv=none; b=Ntzszbip1LP20MBmy9hbskrmyhFiEYOqUlIXnLCtHuYGvI7+fLl5XM393pojRsgnZdiuwFCdGAfb3dLP0rJ+SP2goBdqbqv1nE/C0s38i4a4HaYDaOnwPeV7ZyxosbTABmqrbkXL8bTl70cmoOCjfyLbxUkxVUJoMyfvdfLIwNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741714610; c=relaxed/simple;
	bh=3z622fDpwdCXdvobKYojI+aPmAejnFCu9cNoBbBTPdo=;
	h=Date:To:From:Subject:Message-Id; b=owHrgKEByW/l9qyLZ4WC7eOcQEC3c/EnRBOPqQeZ8+De5LQJYX4DZnr278MRZugzXExeEGFnq1bnSDSMpJC9lZ8z8qkcaH+cbz9H/WoFEPh7MK7X3omXbVWBRxBx0jqwaEvF4bxSc1Hd0+UTSfW5g/+yGlceUaAE7dgp2CCeKhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dOEmognk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dOEmognk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC8EC4CEE9;
	Tue, 11 Mar 2025 17:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741714609;
	bh=3z622fDpwdCXdvobKYojI+aPmAejnFCu9cNoBbBTPdo=;
	h=Date:To:From:Subject:From;
	b=dOEmognktngP0aJkiuVBy/1g8QM8mXiqOZ4OsDinKgSAYuE2giM79oCdDjbrCD3Gy
	 S/ikSa4TNhe+hWytVPc4cR4C8F+Fj2XQJ/qAWXm5wMFct1BA5B7sq7lEKdhr1jGn0I
	 4ykmCcWSx0RkXtNPzdl2BqAtSb4VRr4I64FmkPxo=
Date: Tue, 11 Mar 2025 10:36:48 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-rename-nr_cpus-nr_parallel.patch added to mm-unstable branch
Message-Id: <20250311173649.5BC8EC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/uffd: rename nr_cpus -> nr_parallel
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-uffd-rename-nr_cpus-nr_parallel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-rename-nr_cpus-nr_parallel.patch

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

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_parallel.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longterm-tests-on-weird-filesystems.patch
selftests-mm-drop-unnecessary-sudo-usage.patch
selftests-mm-ensure-uffd-wp-mremap-gets-pages-of-each-size.patch
selftests-mm-skip-mlock-tests-if-nobody-user-cant-read-it.patch
selftests-mm-mlock-print-error-on-failure.patch
mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch
mm-page_alloc-clarify-terminology-in-migratetype-fallback-code.patch
mm-page_alloc-clarify-should_claim_block-commentary.patch
scripts-gdb-add-lx_per_cpu_ptr.patch

