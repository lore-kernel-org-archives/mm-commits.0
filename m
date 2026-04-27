Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E2D3A784A
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777292512; cv=none; b=rEcKQdCddY3XGOAv3PP8TZ4ZGznP4wE7IfPineYA4qfVXU9bxS1Ac9BWv+d31GGX5X1qYJ6CvIlt0odx8+0TuYZCXKoiJ5T0CEcmIzIs0oBP/b0/LMejPxXmQfNGLwI9VQJOXUxFOD6Nhh9YfOolLjLfkcOyLs6nl8d4MQ+pY9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777292512; c=relaxed/simple;
	bh=kcKzrcobk3cheMzrPKX3UCoZiaU9RdolYXoO9duwEEI=;
	h=Date:To:From:Subject:Message-Id; b=cpJJAcDjVqPPMvWoVPAwks8UTOf/eMLNYCCIoRu7f9VXnscoXwV9oSZHV8Rr4AiTwVmDHbSYLuAbvecS48DCVDWChAJUe63PKJQd/iRYleGOJ+8lMNDeCKFh76OCoHtIo0iMdon/x/T+ISVJIFpP66s17MvozGXoD1Z83rTmpPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eIOuvDGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eIOuvDGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FCDC2BCB4;
	Mon, 27 Apr 2026 12:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777292511;
	bh=kcKzrcobk3cheMzrPKX3UCoZiaU9RdolYXoO9duwEEI=;
	h=Date:To:From:Subject:From;
	b=eIOuvDGUvOwBUzE1iM2kpdn4PE4+aL3NhFQb0JPHmhyLbs9i91pJu51HmldOmXlqn
	 1ZwXnVYbg8XRI4OPqOmxgCjt4GM86a5J52VUtNsj4DnhhgNlzJO2Rurer/+ajG9yCY
	 /BaZNH39O7/+Yb/nBHj0Y8lsM3A6A2yJMAwlvshU=
Date: Mon, 27 Apr 2026 05:21:51 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,brauner@kernel.org,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch removed from -mm tree
Message-Id: <20260427122151.B4FCDC2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: reject invalid process_madvise() advice for zero-length vectors
has been removed from the -mm tree.  Its filename was
     mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch

This patch was dropped because an updated version will be issued

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


