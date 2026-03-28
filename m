Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB0D2D1913
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671888; cv=none; b=JNSXEmN7fBdyDnQwvT9jmMnNuwZRWVPjHqncyj4OY6BNARP60Opg6pU/bNQzahkLQBoEZHmxf6uCWahzJsaVw+YfseMcvq1QpZjJ0NrSXiQmRDNWA0cTFrgFiLjmIUh83WPH6E2bK9ujdGDmOTBLpRJj6EuAoI1zamJQ7UGFCBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671888; c=relaxed/simple;
	bh=lxntcEuLaBO3qFvnvJA1GgJVNZuJWmO6oZyNHx8z1KI=;
	h=Date:To:From:Subject:Message-Id; b=q4aWE0SD/Z/yr112esEf2MXvyyPBXqBvPIRC96ab4JPQ6ThN9wFyQ74O0ldlSqILmio+9IdMgL7UeNFe8TeGsMjqZ/iGkhlxt/IfDfxA635m0VTOJvXR8UEenLX7gvZ8WjJmqVUL3ld5kkS3faT01lAqi4RfI15iQ8gTsalC9Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EuVhr2XR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EuVhr2XR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132C0C4CEF7;
	Sat, 28 Mar 2026 04:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671888;
	bh=lxntcEuLaBO3qFvnvJA1GgJVNZuJWmO6oZyNHx8z1KI=;
	h=Date:To:From:Subject:From;
	b=EuVhr2XRWqF/wAPTyg4Z643XJanER8LFnN+V7i0B9YN2DYEGtgQtvE3Agm+13ir6q
	 JPD2qyZlXGKSkBAa0ZBZzQazob3XuRICgczwvUjuHLKUdEh5Tf0dDw8ofIvvOcAeSe
	 g/thBaqVOMfLZnwrVbpCb6YjeAmFNaiaDXw/2Isk=
Date: Fri, 27 Mar 2026 21:24:47 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,jouyeol8739@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-ipc-skip-msgque-test-when-msg_copy-is-unsupported.patch removed from -mm tree
Message-Id: <20260328042448.132C0C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/ipc: skip msgque test when MSG_COPY is unsupported
has been removed from the -mm tree.  Its filename was
     selftests-ipc-skip-msgque-test-when-msg_copy-is-unsupported.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: UYeol Jo <jouyeol8739@gmail.com>
Subject: selftests/ipc: skip msgque test when MSG_COPY is unsupported
Date: Tue, 10 Feb 2026 22:53:59 +0900

msgque kselftest uses msgrcv(..., MSG_COPY) to copy messages.  When the
kernel is built without CONFIG_CHECKPOINT_RESTORE, prepare_copy() is
stubbed out and msgrcv() returns -ENOSYS.  The test currently reports this
as a failure even though it is simply a missing feature/configuration.

Skip the test when msgrcv() fails with ENOSYS.

Link: https://lkml.kernel.org/r/20260210135359.178636-1-jouyeol8739@gmail.com
Signed-off-by: UYeol Jo <jouyeol8739@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/ipc/msgque.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/ipc/msgque.c~selftests-ipc-skip-msgque-test-when-msg_copy-is-unsupported
+++ a/tools/testing/selftests/ipc/msgque.c
@@ -161,6 +161,9 @@ int dump_queue(struct msgque_data *msgqu
 		ret = msgrcv(msgque->msq_id, &msgque->messages[i].mtype,
 				MAX_MSG_SIZE, i, IPC_NOWAIT | MSG_COPY);
 		if (ret < 0) {
+			if (errno == ENOSYS)
+				ksft_exit_skip("MSG_COPY not supported\n");
+
 			ksft_test_result_fail("Failed to copy IPC message: %m (%d)\n", errno);
 			return -errno;
 		}
_

Patches currently in -mm which might be from jouyeol8739@gmail.com are


