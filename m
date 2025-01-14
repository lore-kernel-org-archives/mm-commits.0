Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701322451FC
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837105; cv=none; b=kiY6ULKK91aUD9kauT4iAhVNGe1FJiAFfzv3D38BzIRDsNtjFRiJdEdoGey0SQhxaCeMP1Ao0Ft9533PCw7Wz07nQOZ4DWxhtfZPGWW7IN0Xam7/0VCd9RSbpgiW9g94J732lJ/skJoJFZtvwF9SnUY3Inocx5cSLPHtbZRCShk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837105; c=relaxed/simple;
	bh=ZBFex2662nPnbEMDFqS4aVCKgwWVm4SFx3z49oUz4ag=;
	h=Date:To:From:Subject:Message-Id; b=FTEU/T3vairYSnDouzCRuCLdSEs/GojI+dbnh3ydpep/Rxn0k7v4SJ9i06YybsnGVYWCgzmTF5ZluIZkjSgMzANCTYyOosjVWhP5qPUS8dWOwbKMFFQTQkSmSQp14TAB+uTIOzeUmY+1MBAOiGdMKkSNGfxbUjGoWESKEYFvVNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z0O/DBSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z0O/DBSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40ABEC4CEDD;
	Tue, 14 Jan 2025 06:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837105;
	bh=ZBFex2662nPnbEMDFqS4aVCKgwWVm4SFx3z49oUz4ag=;
	h=Date:To:From:Subject:From;
	b=Z0O/DBSx4TCYiJipg1lnuteOLw2GaqdI/gQb4BMMaCMhHWv4FWrGLSuCT/BlT4wWF
	 k8jFJ4NEdK/tgKwOesXM/CKRDFbkx/sQyh84mi6G0bI7LHvJdLAzyD+C/N8omNWQRn
	 XbH6ekqe7XAxntgnb78eVAqyW1EblukXlm1+2JaI=
Date: Mon, 13 Jan 2025 22:45:04 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ritesh.list@gmail.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-added-new-test-cases-to-the-migration-test.patch removed from -mm tree
Message-Id: <20250114064505.40ABEC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add new test cases to the migration test
has been removed from the -mm tree.  Its filename was
     selftests-mm-added-new-test-cases-to-the-migration-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: selftests/mm: add new test cases to the migration test
Date: Thu, 19 Dec 2024 04:27:20 -0600

Added three new test cases to the migration tests:

1. Shared anon THP migration test
This test will mmap shared anon memory, madvise it to
MADV_HUGEPAGE, then do migration entry testing. One thread
will move pages back and forth between nodes whilst other
threads try and access them.

2. Private anon hugetlb migration test
This test will mmap private anon hugetlb memory and then
do the migration entry testing.

3. Shared anon hugetlb migration test
This test will mmap shared anon hugetlb memory and then
do the migration entry testing.

Test results
============
 # ./tools/testing/selftests/mm/migration
 TAP version 13
 1..6
 # Starting 6 tests from 1 test cases.
 #  RUN           migration.private_anon ...
 #            OK  migration.private_anon
 ok 1 migration.private_anon
 #  RUN           migration.shared_anon ...
 #            OK  migration.shared_anon
 ok 2 migration.shared_anon
 #  RUN           migration.private_anon_thp ...
 #            OK  migration.private_anon_thp
 ok 3 migration.private_anon_thp
 #  RUN           migration.shared_anon_thp ...
 #            OK  migration.shared_anon_thp
 ok 4 migration.shared_anon_thp
 #  RUN           migration.private_anon_htlb ...
 #            OK  migration.private_anon_htlb
 ok 5 migration.private_anon_htlb
 #  RUN           migration.shared_anon_htlb ...
 #            OK  migration.shared_anon_htlb
 ok 6 migration.shared_anon_htlb
 # PASSED: 6 / 6 tests passed.
 # Totals: pass:6 fail:0 xfail:0 xpass:0 skip:0 error:0
 #

Link: https://lkml.kernel.org/r/20241219102720.4487-1-donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/migration.c |   99 +++++++++++++++++++++++
 1 file changed, 99 insertions(+)

--- a/tools/testing/selftests/mm/migration.c~selftests-mm-added-new-test-cases-to-the-migration-test
+++ a/tools/testing/selftests/mm/migration.c
@@ -204,4 +204,103 @@ TEST_F_TIMEOUT(migration, private_anon_t
 		ASSERT_EQ(pthread_cancel(self->threads[i]), 0);
 }
 
+/*
+ * migration test with shared anon THP page
+ */
+
+TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
+{
+	pid_t pid;
+	uint64_t *ptr;
+	int i;
+
+	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
+		SKIP(return, "Not enough threads or NUMA nodes available");
+
+	ptr = mmap(NULL, 2 * TWOMEG, PROT_READ | PROT_WRITE,
+		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, TWOMEG);
+	ASSERT_EQ(madvise(ptr, TWOMEG, MADV_HUGEPAGE), 0);
+
+	memset(ptr, 0xde, TWOMEG);
+	for (i = 0; i < self->nthreads - 1; i++) {
+		pid = fork();
+		if (!pid) {
+			prctl(PR_SET_PDEATHSIG, SIGHUP);
+			/* Parent may have died before prctl so check now. */
+			if (getppid() == 1)
+				kill(getpid(), SIGHUP);
+			access_mem(ptr);
+		} else {
+			self->pids[i] = pid;
+		}
+	}
+
+	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
+	for (i = 0; i < self->nthreads - 1; i++)
+		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
+}
+
+/*
+ * migration test with private anon hugetlb page
+ */
+TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
+{
+	uint64_t *ptr;
+	int i;
+
+	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
+		SKIP(return, "Not enough threads or NUMA nodes available");
+
+	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
+		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	memset(ptr, 0xde, TWOMEG);
+	for (i = 0; i < self->nthreads - 1; i++)
+		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
+			perror("Couldn't create thread");
+
+	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
+	for (i = 0; i < self->nthreads - 1; i++)
+		ASSERT_EQ(pthread_cancel(self->threads[i]), 0);
+}
+
+/*
+ * migration test with shared anon hugetlb page
+ */
+TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
+{
+	pid_t pid;
+	uint64_t *ptr;
+	int i;
+
+	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
+		SKIP(return, "Not enough threads or NUMA nodes available");
+
+	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
+		MAP_SHARED | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	memset(ptr, 0xde, TWOMEG);
+	for (i = 0; i < self->nthreads - 1; i++) {
+		pid = fork();
+		if (!pid) {
+			prctl(PR_SET_PDEATHSIG, SIGHUP);
+			/* Parent may have died before prctl so check now. */
+			if (getppid() == 1)
+				kill(getpid(), SIGHUP);
+			access_mem(ptr);
+		} else {
+			self->pids[i] = pid;
+		}
+	}
+
+	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
+	for (i = 0; i < self->nthreads - 1; i++)
+		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
+}
+
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from donettom@linux.ibm.com are


