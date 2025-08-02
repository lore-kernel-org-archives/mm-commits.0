Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03827173
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754157707; cv=none; b=t4NoBTEoWk7iZCEs9A6HC+9DGUrkFAUPj6ykmTd0YtQYhT8axxfJEAn6uQ4UbOQyFFNHSvv7QRfTBEPDB2g24FF4vKbB2uwnOptshDczVXx1Z5GDEqgUSGH+GRZFQ5c855xLa5nw6pcmLXH5qKFgLh8tiVMALj2oItILKZhQiWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754157707; c=relaxed/simple;
	bh=AWOmaiZ6KnqvMPcJGG4xNqZ/S4FOcSottXQmk3VsZyk=;
	h=Date:To:From:Subject:Message-Id; b=K6pROSg6g5IR/utzXZKKo6Yn9BSz+MKCzDhV70zJ+D1e2iPZdmMJGCp/sJ1FX+Ecjzxg60+ZRRZPHVKLwwlYZCKG3/xa2WWVpLReQs+07Px18snZD6cwchrrFJNTb2L2FAZDxWm+phb9QbhPCxDnspUQfs5UyoD9vuYvguVn7qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VbPMnxCt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VbPMnxCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A68AC4CEEF;
	Sat,  2 Aug 2025 18:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754157706;
	bh=AWOmaiZ6KnqvMPcJGG4xNqZ/S4FOcSottXQmk3VsZyk=;
	h=Date:To:From:Subject:From;
	b=VbPMnxCtOf6mFMu0XsHfnASNS6vmwhEn6DvCf+kL6Nh4nWfJgr3UmeTeZh/mWn7FR
	 hb4z0FqZZHWxbJcwysW2yTG7/sc4TgD92+D+ESDVuP5/O1FzlxrZ6CQG6I3x5Mi1Do
	 saXy1/drRzr6YSB0wIVivD3yxIMe+Sl/VqFpn0B0=
Date: Sat, 02 Aug 2025 11:01:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sj@kernel.org,shuah@kernel.org,ryncsn@gmail.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,broonie@kernel.org,brauner@kernel.org,lianux.mm@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-add-process_madvise-tests-v7.patch removed from -mm tree
Message-Id: <20250802180146.8A68AC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-add-process_madvise-tests-v7
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-process_madvise-tests-v7.patch

This patch was dropped because it was folded into selftests-mm-add-process_madvise-tests.patch

------------------------------------------------------
From: wang lian <lianux.mm@gmail.com>
Subject: selftests-mm-add-process_madvise-tests-v7
Date: Tue, 29 Jul 2025 19:31:09 +0800

- In the remote_collapse test, replace default_huge_page_size() with
  read_pmd_pagesize()

- Add a new test, invalid_vlen, to verify that process_madvise()
  correctly fails with EINVAL when the vlen argument exceeds UIO_MAXIOV.

Link: https://lkml.kernel.org/r/20250729113109.12272-1-lianux.mm@gmail.com
Signed-off-by: wang lian <lianux.mm@gmail.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Mark Brown <broonie@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Zi Yan <ziy@nvidia.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/process_madv.c |   64 ++++++++++++++++----
 1 file changed, 53 insertions(+), 11 deletions(-)

--- a/tools/testing/selftests/mm/process_madv.c~selftests-mm-add-process_madvise-tests-v7
+++ a/tools/testing/selftests/mm/process_madv.c
@@ -141,7 +141,7 @@ TEST_F(process_madvise, remote_collapse)
 		void *map_addr;
 	} info;
 
-	huge_page_size = default_huge_page_size();
+	huge_page_size = read_pmd_pagesize();
 	if (huge_page_size <= 0)
 		SKIP(return, "Could not determine a valid huge page size.\n");
 
@@ -193,7 +193,8 @@ TEST_F(process_madvise, remote_collapse)
 	vec.iov_base = info.map_addr;
 	vec.iov_len = huge_page_size;
 
-	ret = sys_process_madvise(self->remote_pidfd, &vec, 1, MADV_COLLAPSE, 0);
+	ret = sys_process_madvise(self->remote_pidfd, &vec, 1, MADV_COLLAPSE,
+				  0);
 	if (ret == -1) {
 		if (errno == EINVAL)
 			SKIP(return, "PROCESS_MADV_ADVISE is not supported.\n");
@@ -212,12 +213,18 @@ TEST_F(process_madvise, remote_collapse)
  */
 TEST_F(process_madvise, exited_process_pidfd)
 {
+	const unsigned long pagesize = self->page_size;
 	struct iovec vec;
+	char *map;
 	ssize_t ret;
-	int pidfd;
 
-	vec.iov_base = (void *)0x1234;
-	vec.iov_len = 4096;
+	map = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS, -1,
+		   0);
+	if (map == MAP_FAILED)
+		SKIP(return, "mmap failed, not enough memory.\n");
+
+	vec.iov_base = map;
+	vec.iov_len = pagesize;
 
 	/*
 	 * Using a pidfd for a process that has already exited should fail
@@ -229,16 +236,16 @@ TEST_F(process_madvise, exited_process_p
 	if (self->child_pid == 0)
 		exit(0);
 
-	pidfd = syscall(__NR_pidfd_open, self->child_pid, 0);
-	ASSERT_GE(pidfd, 0);
+	self->remote_pidfd = syscall(__NR_pidfd_open, self->child_pid, 0);
+	ASSERT_GE(self->remote_pidfd, 0);
 
 	/* Wait for the child to ensure it has terminated. */
 	waitpid(self->child_pid, NULL, 0);
 
-	ret = sys_process_madvise(pidfd, &vec, 1, MADV_DONTNEED, 0);
+	ret = sys_process_madvise(self->remote_pidfd, &vec, 1, MADV_DONTNEED,
+				  0);
 	ASSERT_EQ(ret, -1);
 	ASSERT_EQ(errno, ESRCH);
-	close(pidfd);
 }
 
 /*
@@ -247,11 +254,18 @@ TEST_F(process_madvise, exited_process_p
  */
 TEST_F(process_madvise, bad_pidfd)
 {
+	const unsigned long pagesize = self->page_size;
 	struct iovec vec;
+	char *map;
 	ssize_t ret;
 
-	vec.iov_base = (void *)0x1234;
-	vec.iov_len = 4096;
+	map = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS, -1,
+		   0);
+	if (map == MAP_FAILED)
+		SKIP(return, "mmap failed, not enough memory.\n");
+
+	vec.iov_base = map;
+	vec.iov_len = pagesize;
 
 	/* Using an invalid fd number (-1) should fail with EBADF. */
 	ret = sys_process_madvise(-1, &vec, 1, MADV_DONTNEED, 0);
@@ -268,6 +282,34 @@ TEST_F(process_madvise, bad_pidfd)
 }
 
 /*
+ * Test that process_madvise() rejects vlen > UIO_MAXIOV.
+ * The kernel should return -EINVAL when the number of iovecs exceeds 1024.
+ */
+TEST_F(process_madvise, invalid_vlen)
+{
+	const unsigned long pagesize = self->page_size;
+	int pidfd = self->pidfd;
+	struct iovec vec;
+	char *map;
+	ssize_t ret;
+
+	map = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS, -1,
+		   0);
+	if (map == MAP_FAILED)
+		SKIP(return, "mmap failed, not enough memory.\n");
+
+	vec.iov_base = map;
+	vec.iov_len = pagesize;
+
+	ret = sys_process_madvise(pidfd, &vec, 1025, MADV_DONTNEED, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	/* Cleanup. */
+	ASSERT_EQ(munmap(map, pagesize), 0);
+}
+
+/*
  * Test process_madvise() with an invalid flag value. Currently, only a flag
  * value of 0 is supported. This test is reserved for the future, e.g., if
  * synchronous flags are added.
_

Patches currently in -mm which might be from lianux.mm@gmail.com are

selftests-mm-add-process_madvise-tests.patch

