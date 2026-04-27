Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C754C30BB8D
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777292581; cv=none; b=YBwdIPXlzhhg5taUddc8sWOATPtRq4IZcIoYN/RToS0jE8jkqu/adGJhBHuYk4JAMhYHcksuFW3bUXidT517y6YwA+97hKGSOfWoW3tFaDs+4obEIxgD5JhsITB+hYvHqS+BAG+9JarrTpvicP6964kMm11zZWxHLJtDlmYIOfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777292581; c=relaxed/simple;
	bh=Ie7xMINu6B0wTvjOsVFyEaPMa32WMpoSjczAwIxfF3Q=;
	h=Date:To:From:Subject:Message-Id; b=Nz1vBxK3xx8g2hR6rmeP3G7PLQoyccaagHJhM7yhnZKVG+wX4UEtwzC012bzwziLBLCQzJhH3FDIYQGIYTe8Qt4rli8p7FIeutjSwD13KrCFmAFPEwbQE7huDzkYf18I7FORFf1X/DpsrwLNluAri7hEH9jG4OI78J4xNCO/wzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KZ7+MOkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KZ7+MOkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E38EC19425;
	Mon, 27 Apr 2026 12:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777292581;
	bh=Ie7xMINu6B0wTvjOsVFyEaPMa32WMpoSjczAwIxfF3Q=;
	h=Date:To:From:Subject:From;
	b=KZ7+MOklKvYRRH11eKuWln/UriJvB7HVCVLzaXWR9Fu7njELXPsF5zXn9snq6xmPB
	 koPtd8SGjYNSMWpqB/xvfHSCtRyMydCx85MSbJ2BZ4eUpP28F2xlXfgsB/okrgELKQ
	 3IsJ+vP6izUwyjZdax86lqnZB7RQEmehzGLRdkD0=
Date: Mon, 27 Apr 2026 05:23:01 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,brauner@kernel.org,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch added to mm-new branch
Message-Id: <20260427122301.9E38EC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: reject invalid process_madvise() advice for zero-length vectors
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch

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
From: fujunjie <fujunjie1@qq.com>
Subject: mm/madvise: reject invalid process_madvise() advice for zero-length vectors
Date: Mon, 27 Apr 2026 09:43:30 +0000

process_madvise() used to validate the advice while walking each imported
iovec.  If the vector has zero total length, vector_madvise() does not
enter the loop and can return success without checking whether the advice
value is valid.

For a local mm, such as process_madvise(PIDFD_SELF, ...), the remote-only
process_madvise_remote_valid() check is skipped.  As a result, an invalid
advice can be reported as success when the vector has zero total length. 
This differs from madvise(), which rejects an invalid advice before
returning success for a zero-length range.

Validate the generic madvise behavior at the syscall-facing entry points
before any vector walk.  In process_madvise(), do this before the
remote-only advice restriction so unsupported advice is rejected with the
same priority for local and remote mm.  Then keep the per-range helper
focused on address/length validation, avoiding repeated behavior checks
for every iovec.

Valid zero-length requests remain no-ops and continue to return 0.  Add a
selftest that covers invalid advice with a zero-length iovec and an empty
vector, while also checking that a valid zero-length request still
succeeds.

Link: https://lore.kernel.org/tencent_BB588C2CDED859A873093DAF28B2CC1F7B0A@qq.com
Fixes: 021781b01275 ("mm/madvise: unrestrict process_madvise() for current process")
Signed-off-by: fujunjie <fujunjie1@qq.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c                              |   29 +++++++++++---------
 tools/testing/selftests/mm/process_madv.c |   29 ++++++++++++++++++++
 2 files changed, 45 insertions(+), 13 deletions(-)

--- a/mm/madvise.c~mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors
+++ a/mm/madvise.c
@@ -1834,13 +1834,10 @@ static void madvise_finish_tlb(struct ma
 		tlb_finish_mmu(madv_behavior->tlb);
 }
 
-static bool is_valid_madvise(unsigned long start, size_t len_in, int behavior)
+static bool is_valid_madvise_range(unsigned long start, size_t len_in)
 {
 	size_t len;
 
-	if (!madvise_behavior_valid(behavior))
-		return false;
-
 	if (!PAGE_ALIGNED(start))
 		return false;
 	len = PAGE_ALIGN(len_in);
@@ -1859,17 +1856,15 @@ static bool is_valid_madvise(unsigned lo
  * madvise_should_skip() - Return if the request is invalid or nothing.
  * @start:	Start address of madvise-requested address range.
  * @len_in:	Length of madvise-requested address range.
- * @behavior:	Requested madvise behavior.
  * @err:	Pointer to store an error code from the check.
  *
- * If the specified behaviour is invalid or nothing would occur, we skip the
- * operation.  This function returns true in the cases, otherwise false.  In
- * the former case we store an error on @err.
+ * If the specified range is invalid or nothing would occur, we skip the
+ * operation.  This function returns true in these cases, otherwise false.  In
+ * the former case we store an error in @err.
  */
-static bool madvise_should_skip(unsigned long start, size_t len_in,
-		int behavior, int *err)
+static bool madvise_should_skip(unsigned long start, size_t len_in, int *err)
 {
-	if (!is_valid_madvise(start, len_in, behavior)) {
+	if (!is_valid_madvise_range(start, len_in)) {
 		*err = -EINVAL;
 		return true;
 	}
@@ -2013,7 +2008,10 @@ int do_madvise(struct mm_struct *mm, uns
 		.tlb = &tlb,
 	};
 
-	if (madvise_should_skip(start, len_in, behavior, &error))
+	if (!madvise_behavior_valid(behavior))
+		return -EINVAL;
+
+	if (madvise_should_skip(start, len_in, &error))
 		return error;
 	error = madvise_lock(&madv_behavior);
 	if (error)
@@ -2056,7 +2054,7 @@ static ssize_t vector_madvise(struct mm_
 		size_t len_in = iter_iov_len(iter);
 		int error;
 
-		if (madvise_should_skip(start, len_in, behavior, &error))
+		if (madvise_should_skip(start, len_in, &error))
 			ret = error;
 		else
 			ret = madvise_do_behavior(start, len_in, &madv_behavior);
@@ -2131,6 +2129,11 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 		goto release_task;
 	}
 
+	if (!madvise_behavior_valid(behavior)) {
+		ret = -EINVAL;
+		goto release_mm;
+	}
+
 	/*
 	 * We need only perform this check if we are attempting to manipulate a
 	 * remote process's address space.
--- a/tools/testing/selftests/mm/process_madv.c~mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors
+++ a/tools/testing/selftests/mm/process_madv.c
@@ -310,6 +310,35 @@ TEST_F(process_madvise, invalid_vlen)
 }
 
 /*
+ * Test that invalid advice is rejected even when the iovec has zero total
+ * length. A zero-length advice is a no-op for valid advice, but invalid
+ * advice should still fail with EINVAL.
+ */
+TEST_F(process_madvise, invalid_advice_zero_length)
+{
+	struct iovec vec = {
+		.iov_base = NULL,
+		.iov_len = 0,
+	};
+	int pidfd = self->pidfd;
+	ssize_t ret;
+
+	errno = 0;
+	ret = sys_process_madvise(pidfd, &vec, 1, -1, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	errno = 0;
+	ret = sys_process_madvise(pidfd, &vec, 1, MADV_DONTNEED, 0);
+	ASSERT_EQ(ret, 0);
+
+	errno = 0;
+	ret = sys_process_madvise(pidfd, NULL, 0, -1, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EINVAL);
+}
+
+/*
  * Test process_madvise() with an invalid flag value. Currently, only a flag
  * value of 0 is supported. This test is reserved for the future, e.g., if
  * synchronous flags are added.
_

Patches currently in -mm which might be from fujunjie1@qq.com are

mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch

