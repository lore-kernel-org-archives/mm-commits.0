Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B45F1F956
	for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2025 19:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753818388; cv=none; b=X+WnvbabhsD4wZYfmf1oVarzybIH5RAYXXWHMl9xtBHXEO9/iiRyoQ1x6m/8VHoIYcRmWYjOb0nrQNwOaOvGH2GDySdBPJG7VbsxJJYvCjWN/FjOqeCL/L6jpjRDNSokBjqDSLPJqAAPPFMTKQ2l/F8OIO6D1axS3LfnpuGfnuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753818388; c=relaxed/simple;
	bh=+1oRGCvkVFjYgnDoTffoGVfYjik2ZDYo1uuj7g24nK4=;
	h=Date:To:From:Subject:Message-Id; b=eOP7SRXz7U7KhTF/8HDBL00Qb4vwgXfNenwc3fZZMkAqeT6hoZVotNAfih2TKYt+pyTJmkGUN1TB4aK3MfpRcvKfPSiwp844EsZQSVTBPmKlPT2WFsX6TEwpXFJjo5TZurT9dO7gUjVnzocRA7avyfFuX/Y8WXEO8tV94xrKKkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WyRvWiVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WyRvWiVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FA0C4CEF6;
	Tue, 29 Jul 2025 19:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753818388;
	bh=+1oRGCvkVFjYgnDoTffoGVfYjik2ZDYo1uuj7g24nK4=;
	h=Date:To:From:Subject:From;
	b=WyRvWiVCkt2A4WWtf6iMxIqXA1KhbUYvJXIJguejpV+44Ewx7qCe1cFtRo4vMNUoW
	 yvOEYw2VQ8MqirrXf9kjhy2IMAjGPbwYoVHC3bXOP04a8lJIFw5yHpXrWuX6dYLrRD
	 XV4pngzX+hJu9zrjaEbXzXJnaNQH+/VEdLKu6lIU=
Date: Tue, 29 Jul 2025 12:46:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sj@kernel.org,shuah@kernel.org,ryncsn@gmail.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,broonie@kernel.org,brauner@kernel.org,lianux.mm@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-process_madvise-tests-v7.patch added to mm-unstable branch
Message-Id: <20250729194628.00FA0C4CEF6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-add-process_madvise-tests-v7
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-process_madvise-tests-v7.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-process_madvise-tests-v7.patch

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
selftests-mm-add-process_madvise-tests-v7.patch

