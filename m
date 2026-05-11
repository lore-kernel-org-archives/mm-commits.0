Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E784D8DAE
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 21:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535224; cv=none; b=ajJCBlgkxid7Owhtjntbu8eklhMmVlTFVqW2uIzUVWOnBGTZq6qhmt3FCA1awvr4U2+cFZOZcWliVgtHexv5VMttwTmNT22CJkbVqB8kSBMrJAevzSLP44jN+23Ir4hrAozUSv+Rg34+xUejdcz7PppKOCAC5z2RtHcjzbw6j70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535224; c=relaxed/simple;
	bh=knuRvIwjiaLSZ2hNsp6e2qWDpVYCCSzHK4fvfA5miNE=;
	h=Date:To:From:Subject:Message-Id; b=DEgh9EFqQLfdacWEbhgsx0BPVwqKuZojJt8eWl2vfveJE98T6hgw94YpQaeFWBN6lLmJmuQbUO0MkUaWKLiCkt7ZobvfloLWkaEQUN60NUpHNuc6HrCNQVo6kdMQweSobP3hLtYWiF/5p63juZskoopuh2K1K/QM95nT+R1e/k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=apxfd77e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="apxfd77e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBC0C2BCB0;
	Mon, 11 May 2026 21:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778535223;
	bh=knuRvIwjiaLSZ2hNsp6e2qWDpVYCCSzHK4fvfA5miNE=;
	h=Date:To:From:Subject:From;
	b=apxfd77eyQm7Qe4BYkifJxpdpeEctUdoFIjNYw4L25lYDTqpEwBacaX0FzcqzktWW
	 v9OQpc50SH7T4GQRhvEw2yyFMu3YMknFkKdmZO06+HfTG/4xh+vm6ebJroqmVIgxWM
	 4M1DgsgC/8Q9kiE02c/6EMuKPz5v1iaveg9eNH74=
Date: Mon, 11 May 2026 14:33:43 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-migration-make-nthreads-represent-number-of-working-threads.patch added to mm-new branch
Message-Id: <20260511213343.ADBC0C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: migration: make nthreads represent number of working threads
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-migration-make-nthreads-represent-number-of-working-threads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-migration-make-nthreads-represent-number-of-working-threads.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: migration: make nthreads represent number of working threads
Date: Mon, 11 May 2026 19:27:47 +0300

Fixture setup sets self->nthreads to number of available CPUs minus 1 and
then each test creates 'self->nthreads - 1' threads or processes, so
essentially nthreads counts the worker tasks and the main task.

Make nthreads represent the number of spawned tasks to simplify
thread/process creation and teardown.

While on it, make the fixture setup skip the tests if there are not enough
CPUs or NUMA nodes instead of checking this in each test.

Link: https://lore.kernel.org/20260511162840.375890-4-rppt@kernel.org
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/migration.c |   47 +++++++----------------
 1 file changed, 16 insertions(+), 31 deletions(-)

--- a/tools/testing/selftests/mm/migration.c~selftests-mm-migration-make-nthreads-represent-number-of-working-threads
+++ a/tools/testing/selftests/mm/migration.c
@@ -38,7 +38,7 @@ FIXTURE_SETUP(migration)
 
 	if (numa_available() < 0)
 		SKIP(return, "NUMA not available");
-	self->nthreads = numa_num_task_cpus() - 1;
+	self->nthreads = numa_num_task_cpus() - 2;
 	self->n1 = -1;
 	self->n2 = -1;
 
@@ -52,6 +52,9 @@ FIXTURE_SETUP(migration)
 			}
 		}
 
+	if (self->nthreads < 1 || self->n1 < 0 || self->n2 < 0)
+		SKIP(return, "Not enough threads or NUMA nodes available");
+
 	self->threads = malloc(self->nthreads * sizeof(*self->threads));
 	ASSERT_NE(self->threads, NULL);
 	self->pids = malloc(self->nthreads * sizeof(*self->pids));
@@ -127,20 +130,17 @@ TEST_F_TIMEOUT(migration, private_anon,
 	uint64_t *ptr;
 	int i;
 
-	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
-		SKIP(return, "Not enough threads or NUMA nodes available");
-
 	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
 		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	memset(ptr, 0xde, TWOMEG);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
 			perror("Couldn't create thread");
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		ASSERT_EQ(pthread_cancel(self->threads[i]), 0);
 }
 
@@ -153,15 +153,12 @@ TEST_F_TIMEOUT(migration, shared_anon, 2
 	uint64_t *ptr;
 	int i;
 
-	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
-		SKIP(return, "Not enough threads or NUMA nodes available");
-
 	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
 		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	memset(ptr, 0xde, TWOMEG);
-	for (i = 0; i < self->nthreads - 1; i++) {
+	for (i = 0; i < self->nthreads; i++) {
 		pid = fork();
 		if (!pid) {
 			prctl(PR_SET_PDEATHSIG, SIGHUP);
@@ -175,7 +172,7 @@ TEST_F_TIMEOUT(migration, shared_anon, 2
 	}
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
 }
 
@@ -195,9 +192,6 @@ TEST_F_TIMEOUT(migration, private_anon_t
 	if (!pmdsize)
 		SKIP(return, "Reading PMD pagesize failed");
 
-	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
-		SKIP(return, "Not enough threads or NUMA nodes available");
-
 	ptr = mmap(NULL, 2 * pmdsize, PROT_READ | PROT_WRITE,
 		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
@@ -205,12 +199,12 @@ TEST_F_TIMEOUT(migration, private_anon_t
 	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, pmdsize);
 	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
 	memset(ptr, 0xde, pmdsize);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
 			perror("Couldn't create thread");
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		ASSERT_EQ(pthread_cancel(self->threads[i]), 0);
 }
 
@@ -232,9 +226,6 @@ TEST_F_TIMEOUT(migration, shared_anon_th
 	if (!pmdsize)
 		SKIP(return, "Reading PMD pagesize failed");
 
-	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
-		SKIP(return, "Not enough threads or NUMA nodes available");
-
 	ptr = mmap(NULL, 2 * pmdsize, PROT_READ | PROT_WRITE,
 		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
@@ -243,7 +234,7 @@ TEST_F_TIMEOUT(migration, shared_anon_th
 	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
 
 	memset(ptr, 0xde, pmdsize);
-	for (i = 0; i < self->nthreads - 1; i++) {
+	for (i = 0; i < self->nthreads; i++) {
 		pid = fork();
 		if (!pid) {
 			prctl(PR_SET_PDEATHSIG, SIGHUP);
@@ -257,7 +248,7 @@ TEST_F_TIMEOUT(migration, shared_anon_th
 	}
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
 }
 
@@ -270,9 +261,6 @@ TEST_F_TIMEOUT(migration, private_anon_h
 	uint64_t *ptr;
 	int i;
 
-	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
-		SKIP(return, "Not enough threads or NUMA nodes available");
-
 	hugepage_size = default_huge_page_size();
 	if (!hugepage_size)
 		SKIP(return, "Reading HugeTLB pagesize failed");
@@ -282,12 +270,12 @@ TEST_F_TIMEOUT(migration, private_anon_h
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	memset(ptr, 0xde, hugepage_size);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
 			perror("Couldn't create thread");
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		ASSERT_EQ(pthread_cancel(self->threads[i]), 0);
 }
 
@@ -301,9 +289,6 @@ TEST_F_TIMEOUT(migration, shared_anon_ht
 	uint64_t *ptr;
 	int i;
 
-	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
-		SKIP(return, "Not enough threads or NUMA nodes available");
-
 	hugepage_size = default_huge_page_size();
 	if (!hugepage_size)
 		SKIP(return, "Reading HugeTLB pagesize failed");
@@ -313,7 +298,7 @@ TEST_F_TIMEOUT(migration, shared_anon_ht
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	memset(ptr, 0xde, hugepage_size);
-	for (i = 0; i < self->nthreads - 1; i++) {
+	for (i = 0; i < self->nthreads; i++) {
 		pid = fork();
 		if (!pid) {
 			prctl(PR_SET_PDEATHSIG, SIGHUP);
@@ -327,7 +312,7 @@ TEST_F_TIMEOUT(migration, shared_anon_ht
 	}
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads - 1; i++)
+	for (i = 0; i < self->nthreads; i++)
 		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
 }
 
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-tree-for-kdump-and-kexec.patch
maintainers-add-kexec-list-to-live-update-entry.patch
sh-fix-fallout-from-zero_page-consolidation.patch
selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler.patch
selftests-mm-migration-dont-assume-huge-page-is-twomeg.patch
selftests-mm-migration-make-nthreads-represent-number-of-working-threads.patch
selftests-mm-migration-properly-cleanup-forked-processes.patch
selftests-mm-run_vmtestssh-dont-gate-thp-and-ksm-tests-on-have_hugepages.patch
selftests-mm-merge-map_hugetlb-into-hugepage-mmap.patch
selftests-mm-rename-hugepage-tests-to-hugetlb.patch
selftests-mm-hugetlb-shm-use-kselftest-framework.patch
selftests-mm-hugetlb-vmemmap-use-kselftest-framework.patch
selftests-mm-hugetlb-madvise-use-kselftest-framework.patch
selftests-mm-hugetlb_madv_vs_map-use-kselftest-framework.patch
selftests-mm-hugetlb-read-hwpoison-use-kselftest-framework.patch
selftests-mm-khugepaged-group-tests-in-an-array.patch
selftests-mm-khugepaged-use-ksefltest-framework.patch
selftests-mm-ksm_tests-use-kselftest-framework.patch
selftests-mm-protection_keys-use-descriptive-test-names-in-the-output.patch
selftests-mm-protection_keys-use-kselftest-framework.patch
selftests-mm-uffd-common-use-kselftest-framework.patch
selftests-mm-uffd-stress-use-kselftest-framework.patch
selftests-mm-uffd-unit-tests-use-kselftest-framework.patch
selftests-mm-va_high_addr_switch-use-kselftest-framework.patch
selftests-mm-add-atexit-and-signal-handlers-to-thp_settings.patch
selftests-mm-rename-thp_settings-to-hugepage_settings.patch
selftests-mm-move-hugetlb-helpers-to-hugepage_settings.patch
selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size.patch
selftests-mm-hugepage_settings-add-apis-to-get-and-set-nr_hugepages.patch
selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages.patch
selftests-mm-hugepage_settings-add-apis-for-hugetlb-setup-and-teardown.patch
selftests-mm-move-read_file-read_num-and-write_num-to-vm_util.patch
selftests-mm-vm_util-add-helpers-to-set-and-restore-shm-limits.patch
selftests-mm-compaction_test-use-hugetlb-helpers.patch
selftests-mm-cow-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_longterm-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_test-add-setup-of-hugetlb-pages.patch
selftests-mm-hmm-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-hugepage_dio-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_fault_after_madv-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-madvise-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_madv_vs_map-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mmap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-shm-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-soft-offline-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-vmemmap-add-setup-of-hugetlb-pages.patch
selftests-mm-migration-add-setup-of-hugetlb-pages.patch
selftests-mm-pagemap_ioctl-add-setup-of-hugetlb-pages.patch
selftests-mm-protection_keys-use-library-code-for-hugetlb-setup.patch
selftests-mm-thuge-gen-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-stress-use-hugetlb_save-and-alloc-huge-pages.patch
selftests-mm-uffd-unit-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-wp-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switch-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switchsh-drop-huge-pages-setup.patch
selftests-mm-run_vmtestssh-free-memory-if-available-memory-is-low.patch
selftests-mm-run_vmtestssh-drop-detection-and-setup-of-hugetlb.patch

