Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36CE2C029D
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 01:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774574352; cv=none; b=V8uY0JP6n/o9K5nu6dMaeW6Pz1ortovC+X1f50AGr7SkXBS5XfT0DN7/Bpi8UWrSMrVh/sxSg5o8C6QtMna3bbdvhM5b8l9cPP4Bf4I4Ay9a/SLeWiyLpGynZ873Wl+0FSJ6aaFdoRtlaEHRcbj9nHVzkIynu4W+I4pgp1ycCOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774574352; c=relaxed/simple;
	bh=2xTniZe/R7QYBxkVNP70ZTcn+vWDC2yhA3MwVNhj+1s=;
	h=Date:To:From:Subject:Message-Id; b=VNr1GPDl1qXBIOKj/GAy6rqr2T6J2GBPrWrQgsl4KCRJAx2A06zkLzWvbEHBTrnuT8S17ld6xtgpZBfJ59vp19PvexZnvzGa299WsKJZzkmTv04uyL7wwPzw51twnLdVfmuNRjHQ0LC9rYpKPdfkGmAsmjy4LOrXYLFwUUmTzfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wwrP984t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wwrP984t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435D5C116C6;
	Fri, 27 Mar 2026 01:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774574352;
	bh=2xTniZe/R7QYBxkVNP70ZTcn+vWDC2yhA3MwVNhj+1s=;
	h=Date:To:From:Subject:From;
	b=wwrP984tv5clk4jWPYv0+9tqbd8DyZm+unmPtfCTs+2lwMD+Zm4TqwNRKU8m3/Xas
	 HQdxlYXKNBasE/+tKH4KhnXrJb7n5a3NeXVHCkmdW4ESMAev3s25rxmRVvPkX0AmmL
	 ClPhCPCHjGLhhNx/oN4f88xQ93D8h0nTEIUSCfZI=
Date: Thu, 26 Mar 2026 18:19:11 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,shuah@kernel.org,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-liveupdate-add-test-for-double-preservation.patch added to mm-new branch
Message-Id: <20260327011912.435D5C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: liveupdate: add test for double preservation
has been added to the -mm mm-new branch.  Its filename is
     selftests-liveupdate-add-test-for-double-preservation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-liveupdate-add-test-for-double-preservation.patch

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: selftests: liveupdate: add test for double preservation
Date: Thu, 26 Mar 2026 16:39:43 +0000

Verify that a file can only be preserved once across all active sessions. 
Attempting to preserve it a second time, whether in the same or a
different session, should fail with EBUSY.

Link: https://lkml.kernel.org/r/20260326163943.574070-4-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
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

liveupdate-protect-file-handler-list-with-rwsem.patch
liveupdate-protect-flb-lists-with-rwsem.patch
liveupdate-remove-file-handler-module-refcounting.patch
liveupdate-defer-flb-module-refcounting-to-active-sessions.patch
liveupdate-remove-luo_session_quiesce.patch
liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch
liveupdate-remove-liveupdate_test_unregister.patch
liveupdate-make-unregister-functions-return-void.patch
liveupdate-prevent-double-management-of-files.patch
memfd-implement-get_id-for-memfd_luo.patch
selftests-liveupdate-add-test-for-double-preservation.patch

