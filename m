Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23AA2032D
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 03:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778641268; cv=none; b=hxtfONOzu9tnEXccoScdIEBdw6VHQDY7Na5KIhmjhC4KmQUygQCP8sz1Oc8tE/AAkInJ+muBsn+/piVUL2P1whvG0lq/7+iU2nzQHNA1+VbJR6gUJ3id+lgVngdqXfjvyUriWx7ynaoA+srsDCpyk3azSmAt9CxzZQvk/yjiivI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778641268; c=relaxed/simple;
	bh=LG5FqvSAZ5ztPtcx9tB8n6khpZvqBbS5uu1cFqc9xxw=;
	h=Date:To:From:Subject:Message-Id; b=Ky6lNT/Li93zYXtCwwjeCpWTQyngqoOtu8s5KHQkCJfaind4/z1cx0ES+f7gSetqLdemKMyN9J9jmFSjKCSkHXArjIJTBciFck5GKggWOnXCJugj89usTiNVoYYoN6mJNrBO3q5Pk7wh73E6NTeUDWBJVgx1ADcsx2pRiHaLIG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2YO5jEID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2YO5jEID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B783C2BCB0;
	Wed, 13 May 2026 03:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778641268;
	bh=LG5FqvSAZ5ztPtcx9tB8n6khpZvqBbS5uu1cFqc9xxw=;
	h=Date:To:From:Subject:From;
	b=2YO5jEIDbDwVee8GAd/VdhtK95qHk8H1fNu2AEmK4WeZ/x/1f1TypfbN9cYtB/shy
	 LB9MRZs9n+0QBl0qo+kUfZC64bZAXieEAyTN/02u2B9WarhdYaE5sqSeLRrWj2A/p7
	 8tfzd7n1pwlsHCmazVP1LJd2Ltj/pWCMB75D8f1Y=
Date: Tue, 12 May 2026 20:01:07 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,sj@kernel.org,shuah@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,brauner@kernel.org,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch added to mm-unstable branch
Message-Id: <20260513030108.5B783C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: reject invalid process_madvise() advice for zero-length vectors
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: SeongJae Park <sj@kernel.org>
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

mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch
mm-filemap-count-only-the-faulting-address-as-a-mmap-hit.patch
mm-filemap-do-not-count-fault_flag_tried-retries-as-mmap-hits.patch

