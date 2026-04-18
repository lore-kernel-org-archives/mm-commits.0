Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1443161BE
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498757; cv=none; b=i8MYdGWiiCC09xHlihEsOQYmezsWFDoQEBFLsVzxSfEiE4QAXGhNXWNCQPj2svbTxoHVy7fqt/GIlt5tUwO9g/Z9FQ8/3P16rMXaAUgQZNjUii8g2FRG/4sn6AzL6oNLRnUVZsuXa/wzihEH+5ICgh/ZJl1ILlHIwxxKXSFTs4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498757; c=relaxed/simple;
	bh=2ayQnYCB7WySxWPWOmNaePYTaVvMJ5vU8/yN1Owy21s=;
	h=Date:To:From:Subject:Message-Id; b=J8+xY9Xnsl6NrjmTNi2la2SbQDtjKy73PLGeE6WnaPKSIUOV9kmGjbyZ4S5HRrcWc44mhkz6+MndW9GHLO7wnvzu4ccRxV8jdZxHQpVqZqi+qL5DjhriWM5CPYbwtI4FpYOneidBGwKbC5UmhJNB9Sg3/feoOnguyv8Dw2i8OKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=snIrk75u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="snIrk75u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504F0C19424;
	Sat, 18 Apr 2026 07:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498756;
	bh=2ayQnYCB7WySxWPWOmNaePYTaVvMJ5vU8/yN1Owy21s=;
	h=Date:To:From:Subject:From;
	b=snIrk75uHwqWeLzg6YUlb7Wkw7O+WxHCq3kowsZJ7uB90XOBo0iK+x1bJEf2eMSLF
	 DxjfEHSp8xO/U9COMSbwS3M5sMpZcfafejlUBcnr+ub7h5L+k5g+2GRaL3xM7+TvNG
	 ogp7M7RG8bd3LLIwXLHDKy93+GysHl4Hp+2qFbdQ=
Date: Sat, 18 Apr 2026 00:52:30 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,shuah@kernel.org,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-liveupdate-add-test-for-double-preservation.patch removed from -mm tree
Message-Id: <20260418075235.504F0C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: liveupdate: add test for double preservation
has been removed from the -mm tree.  Its filename was
     selftests-liveupdate-add-test-for-double-preservation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: selftests: liveupdate: add test for double preservation
Date: Thu, 26 Mar 2026 16:39:43 +0000

Verify that a file can only be preserved once across all active sessions. 
Attempting to preserve it a second time, whether in the same or a
different session, should fail with EBUSY.

Link: https://lore.kernel.org/20260326163943.574070-4-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Christian Brauner <brauner@kernel.org> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/liveupdate/liveupdate.c |   41 ++++++++++++++
 1 file changed, 41 insertions(+)

--- a/tools/testing/selftests/liveupdate/liveupdate.c~selftests-liveupdate-add-test-for-double-preservation
+++ a/tools/testing/selftests/liveupdate/liveupdate.c
@@ -345,4 +345,45 @@ TEST_F(liveupdate_device, preserve_unsup
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Prevent Double Preservation
+ *
+ * Verifies that a file (memfd) can only be preserved once across all active
+ * sessions. Attempting to preserve it a second time, whether in the same or
+ * a different session, should fail with EBUSY.
+ */
+TEST_F(liveupdate_device, prevent_double_preservation)
+{
+	int session_fd1, session_fd2, mem_fd;
+	int ret;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd1 = create_session(self->fd1, "double-preserve-session-1");
+	ASSERT_GE(session_fd1, 0);
+	session_fd2 = create_session(self->fd1, "double-preserve-session-2");
+	ASSERT_GE(session_fd2, 0);
+
+	mem_fd = memfd_create("test-memfd", 0);
+	ASSERT_GE(mem_fd, 0);
+
+	/* First preservation should succeed */
+	ASSERT_EQ(preserve_fd(session_fd1, mem_fd, 0x1111), 0);
+
+	/* Second preservation in a different session should fail with EBUSY */
+	ret = preserve_fd(session_fd2, mem_fd, 0x2222);
+	EXPECT_EQ(ret, -EBUSY);
+
+	/* Second preservation in the same session (different token) should fail with EBUSY */
+	ret = preserve_fd(session_fd1, mem_fd, 0x3333);
+	EXPECT_EQ(ret, -EBUSY);
+
+	ASSERT_EQ(close(mem_fd), 0);
+	ASSERT_EQ(close(session_fd1), 0);
+	ASSERT_EQ(close(session_fd2), 0);
+}
+
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-fix-return-value-on-session-allocation-failure.patch

