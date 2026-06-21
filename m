Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15C5366564
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067122; cv=none; b=VQUD9BWlyF7w2tRxSmlFBygzf2DJ7z1zxJ2CJRP9R9X+fvpSGAuzMi5leGNls7+NvB5kWF+FVNamUVxa9iAeWJ1NfkDcG2w8H5TujPWz/ORgvPajzxf54O+Mo7OQLUqeaa5r0dTHUu7vW56GcY/ChXlTAII00Goh3QkcWeE9YFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067122; c=relaxed/simple;
	bh=iWujGrP0T+17lyLrhXtP7ktK09keZX2pIibVGxnf+FM=;
	h=Date:To:From:Subject:Message-Id; b=BhDrQNAL5MlnsTSFA7VhbJkbB7u/KCi7Onal/LmmkKfSWjC5jcAgUm9r/JacmFrnsrXoHnApk+Kw+ZCZ8Jztpe5qChh2rsIxflvFNcD7SqI3H+prd4qacswV67Pr34bcXcuyRY/bdO8SCpZPOvYZZQyWHtAaeDOYWgzfSncef6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VVaxl92E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VVaxl92E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A931F000E9;
	Sun, 21 Jun 2026 18:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067120;
	bh=MzBCDvYzhdL1HCqIV7IzDsAH1hLcqMuGDVxJXFDvky0=;
	h=Date:To:From:Subject;
	b=VVaxl92EciKvxQajlZ0+FIwClipayUkufkYSrBpdsbdpUyFBnzpuCQgN9Jzv7bQw7
	 k24V7KsiuB7lIwSB3kK//gyjNiM3x16qFadlQYw5/wNQcmZIJPN0R0jzjiBMS26fW7
	 8Ap13737bRs4/LF2GgSABQoUHnjnH0WE9TB73kSs=
Date: Sun, 21 Jun 2026 11:38:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-migration-make-nthreads-represent-number-of-working-threads.patch removed from -mm tree
Message-Id: <20260621183840.C9A931F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: migration: make nthreads represent number of working threads
has been removed from the -mm tree.  Its filename was
     selftests-mm-migration-make-nthreads-represent-number-of-working-threads.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


