Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEA219E819
	for <mm-commits@vger.kernel.org>; Sun, 26 Apr 2026 19:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777232510; cv=none; b=W3/R8p1DeDnoiGry827A5gyGw5ishOuM+M7ok4nzx5n+PXP+agoAVv64NhwaQqE9hjaK/AE8rSdAf/6G0JRnsf6LmGZB5sIkRGvldGOtzSZPpQcq3JJhCLwtz2aacCSZ7z6vUyWq0pXXuvKRsZ+/kUzLUE/F4430kfgTvE2/pEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777232510; c=relaxed/simple;
	bh=Zte1cDizmZbMgzPYjs1QZO36HzzO0rMGjm879LiqpwM=;
	h=Date:To:From:Subject:Message-Id; b=uSNIrXqvaNRumyaitZX9HwbCvOvl8cQizPuIDtbrzKOgHS8RQ6Iiydt9jo1/LEFJlyBqTwDhyxD9Cy+nZXfuaUuOsTFzlBuzegRv+buqCG4icVkR5I3981W/Vjbd/gzY15iqHpXfWIrViEG13T2L6Q3S43+zInIMV9EOiPcsm3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qz5xabW8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qz5xabW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1855C2BCAF;
	Sun, 26 Apr 2026 19:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777232510;
	bh=Zte1cDizmZbMgzPYjs1QZO36HzzO0rMGjm879LiqpwM=;
	h=Date:To:From:Subject:From;
	b=Qz5xabW8mQSgPDXRAuMTeOskU/8i0dXZ83y8EvZV1NNNbntrmhmw+Vzm5scUG/Yr6
	 PUg8+2EMKSernZgbA9/FHg9SnLWBvqf2f87E2mcWy8el5lpzP0VulHBP54VE+Ii8Bx
	 031x7yIHhgI6bYBIFV3Gx/4rhL8NSgU69wYUViV8=
Date: Sun, 26 Apr 2026 12:41:49 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,brauner@kernel.org,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch added to mm-new branch
Message-Id: <20260426194149.E1855C2BCAF@smtp.kernel.org>
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
Date: Sun, 26 Apr 2026 11:08:22 +0000

process_madvise() validates the advice while walking the imported iovec. 
If the iovec has zero total length, vector_madvise() never enters the loop
and returns 0 without checking whether the advice value is valid.

For a local mm, such as process_madvise(PIDFD_SELF, ...), the remote-only
process_madvise_remote_valid() check is skipped.  As a result, an invalid
advice can be reported as success when the vector has zero total length. 
This differs from madvise(), which rejects an invalid advice before
returning success for a zero-length range.

Reject invalid advice before walking the vector.  Valid zero-length
requests remain no-ops and continue to return 0.

Add a selftest that covers invalid advice with a zero-length iovec and an
empty vector, while also checking that a valid zero-length request still
succeeds.

Link: https://lore.kernel.org/tencent_98F3571EF9236437E5165F5C08CF258A9E08@qq.com
Fixes: 021781b01275 ("mm/madvise: unrestrict process_madvise() for current process")
Signed-off-by: fujunjie <fujunjie1@qq.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
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

 mm/madvise.c                              |    3 ++
 tools/testing/selftests/mm/process_madv.c |   29 ++++++++++++++++++++
 2 files changed, 32 insertions(+)

--- a/mm/madvise.c~mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors
+++ a/mm/madvise.c
@@ -2046,6 +2046,9 @@ static ssize_t vector_madvise(struct mm_
 
 	total_len = iov_iter_count(iter);
 
+	if (!madvise_behavior_valid(behavior))
+		return -EINVAL;
+
 	ret = madvise_lock(&madv_behavior);
 	if (ret)
 		return ret;
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

