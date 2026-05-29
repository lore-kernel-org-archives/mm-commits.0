Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7BE370AC6
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027654; cv=none; b=DUe5/Ww0j7lIG8PNFGB284eQn4Qp0UdxWqYU869HPVtTfgodtZiiW2OMDjpCJHO7MP88PRnbNm+I/9yV7hRUjmQVWiHFhSJ51urtJ12FyO1cHaVXCV7tjDRZijIUjT6n3hK3hu+PyqCQZImP1YpSxS0eCTV6W9m6r7ZJG0hYyFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027654; c=relaxed/simple;
	bh=A4CTLbuAei6DXHKJzR9QNrcTaVSU3f6/GEWkcZVMf6Y=;
	h=Date:To:From:Subject:Message-Id; b=d4Wl1e+J9A9o0t00zV20IUXwHqU4R0EuYehMn6MfQAU641ukOkhCH8IkdQ8EnFVAyT3AAxxZVZfQ/xwT8J+Fr9mZ/DgK342AFtH3QoPz+TIYfQwO92dacMe8cTRVEKXhLNXHZTVUBGfy2XEGNg+1GJfnTDtBW0XZ4KtmwqwFJhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lLVR5aGm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lLVR5aGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A5C1F00893;
	Fri, 29 May 2026 04:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027651;
	bh=Qc8czZqfxkhNkBdEsj9ENOmYamuL2u0r2DRfE12mp9Q=;
	h=Date:To:From:Subject;
	b=lLVR5aGmZeb+vbDjNk2iVOnV/jOw1JFvQJ2uwDApmzoPs6zAPYBYZkXpwv7BQrnL2
	 Z0sz1IDd9hPaB4QPZUuzHc84/SkBQyupFYVCVmc76wQEaoEHisOfgQrL988pJCS8L4
	 5q/s7WWEO+HURGauD+otu27/rBwJBFzAWtpJhjt4=
Date: Thu, 28 May 2026 21:07:31 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,sj@kernel.org,shuah@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,brauner@kernel.org,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch removed from -mm tree
Message-Id: <20260529040731.B0A5C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: reject invalid process_madvise() advice for zero-length vectors
has been removed from the -mm tree.  Its filename was
     mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: fujunjie <fujunjie1@qq.com>
Subject: mm/madvise: reject invalid process_madvise() advice for zero-length vectors
Date: Mon, 4 May 2026 10:39:57 +0000

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
same priority for local and remote mm.

Use an errno-returning helper for address/length validation, and handle
zero-length ranges explicitly at the call sites.  Requests with valid
advice and zero total length remain a noop and continue to return 0.  Add
a selftest that covers invalid advice with a zero-length iovec and an
empty vector, while also checking that a request with valid advice and
zero length still succeeds.

Link: https://lore.kernel.org/tencent_C3AEB0E769C5F4F9370F9411B69B7F8B2907@qq.com
Fixes: 021781b01275 ("mm/madvise: unrestrict process_madvise() for current process")
Signed-off-by: fujunjie <fujunjie1@qq.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c                              |   60 ++++++++------------
 tools/testing/selftests/mm/process_madv.c |   28 +++++++++
 2 files changed, 53 insertions(+), 35 deletions(-)

--- a/mm/madvise.c~mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors
+++ a/mm/madvise.c
@@ -1834,50 +1834,29 @@ static void madvise_finish_tlb(struct ma
 		tlb_finish_mmu(madv_behavior->tlb);
 }
 
-static bool is_valid_madvise(unsigned long start, size_t len_in, int behavior)
+/**
+ * check_input_range() - Check if the requested range is valid.
+ * @start:	Start address of madvise-requested address range.
+ * @len_in:	Length of madvise-requested address range.
+ *
+ * Returns: 0 if the input range is valid, otherwise an error code.
+ */
+static int check_input_range(unsigned long start, size_t len_in)
 {
 	size_t len;
 
-	if (!madvise_behavior_valid(behavior))
-		return false;
-
 	if (!PAGE_ALIGNED(start))
-		return false;
+		return -EINVAL;
 	len = PAGE_ALIGN(len_in);
 
 	/* Check to see whether len was rounded up from small -ve to zero */
 	if (len_in && !len)
-		return false;
+		return -EINVAL;
 
 	if (start + len < start)
-		return false;
+		return -EINVAL;
 
-	return true;
-}
-
-/*
- * madvise_should_skip() - Return if the request is invalid or nothing.
- * @start:	Start address of madvise-requested address range.
- * @len_in:	Length of madvise-requested address range.
- * @behavior:	Requested madvise behavior.
- * @err:	Pointer to store an error code from the check.
- *
- * If the specified behaviour is invalid or nothing would occur, we skip the
- * operation.  This function returns true in the cases, otherwise false.  In
- * the former case we store an error on @err.
- */
-static bool madvise_should_skip(unsigned long start, size_t len_in,
-		int behavior, int *err)
-{
-	if (!is_valid_madvise(start, len_in, behavior)) {
-		*err = -EINVAL;
-		return true;
-	}
-	if (start + PAGE_ALIGN(len_in) == start) {
-		*err = 0;
-		return true;
-	}
-	return false;
+	return 0;
 }
 
 static bool is_madvise_populate(struct madvise_behavior *madv_behavior)
@@ -2013,8 +1992,13 @@ int do_madvise(struct mm_struct *mm, uns
 		.tlb = &tlb,
 	};
 
-	if (madvise_should_skip(start, len_in, behavior, &error))
+	if (!madvise_behavior_valid(behavior))
+		return -EINVAL;
+
+	error = check_input_range(start, len_in);
+	if (error || !len_in)
 		return error;
+
 	error = madvise_lock(&madv_behavior);
 	if (error)
 		return error;
@@ -2056,7 +2040,8 @@ static ssize_t vector_madvise(struct mm_
 		size_t len_in = iter_iov_len(iter);
 		int error;
 
-		if (madvise_should_skip(start, len_in, behavior, &error))
+		error = check_input_range(start, len_in);
+		if (error || !len_in)
 			ret = error;
 		else
 			ret = madvise_do_behavior(start, len_in, &madv_behavior);
@@ -2131,6 +2116,11 @@ SYSCALL_DEFINE5(process_madvise, int, pi
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
@@ -310,6 +310,34 @@ TEST_F(process_madvise, invalid_vlen)
 }
 
 /*
+ * Test that invalid advice is rejected even when the iovec has zero total
+ * length. A request with valid advice and zero length is a noop, but
+ * invalid advice should still fail with EINVAL.
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

mm-compaction-respect-cpusets-when-checking-retry-suitability.patch
mm-page_alloc-fix-deferred-compaction-accounting.patch

