Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2275285C84
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 22:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771628054; cv=none; b=FjoIGj3+Dt3nIbncOj3Wl1or3rnc4M66+5xqEYkXyorEr+tfBacJUj5xH0CH6Sm6bFlopW70AoH/lyYFlX3iiyn+DxNl5HK8JgkCyBcwKpK4Ok/dmpNCzmUvapJz7S0Mj3aV/PX3MYA4wyRrPGdmoIsvxYNXQC5ylrDTM1zbolQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771628054; c=relaxed/simple;
	bh=3N8eOo1wWk4SmTDSmBrQlN5ker4PTCt6MTKRU8f3KcA=;
	h=Date:To:From:Subject:Message-Id; b=eARxbRJSmsjACku29710HDyDH9gjV/oVH2QYvrq7FfqnFmgZG/GcqCNtYrLQJgLNYZ/a3rch/FNukbtiIUb6xc+huQ5cnOfGCEAqTa4i+335mLJu+f2EIqkMptNAE2GyazosjU7OBbLhm/xv9k2GXeHSySzZxq8jV5tSTl0O29w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AjUr8CdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AjUr8CdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F76C116C6;
	Fri, 20 Feb 2026 22:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771628054;
	bh=3N8eOo1wWk4SmTDSmBrQlN5ker4PTCt6MTKRU8f3KcA=;
	h=Date:To:From:Subject:From;
	b=AjUr8CdFmAiWQELg2KapGN1prvqhNNjSBCEXLR6CdDbsW6qGb5r8cXI3T4I1+GvzL
	 YdAl4SSVAffiK3eP7/4JKigjeI79xl9QHySsL+jwLY2vPH4pdBpcnqLkQgBW9b0Y4q
	 I81f2zgjmMFXTo6+ow/pnGfybMjgWAtmSInVZYAc=
Date: Fri, 20 Feb 2026 14:54:13 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,jouyeol8739@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-ipc-skip-msgque-test-when-msg_copy-is-unsupported.patch added to mm-nonmm-unstable branch
Message-Id: <20260220225413.E6F76C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/ipc: skip msgque test when MSG_COPY is unsupported
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-ipc-skip-msgque-test-when-msg_copy-is-unsupported.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-ipc-skip-msgque-test-when-msg_copy-is-unsupported.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

selftests-ipc-skip-msgque-test-when-msg_copy-is-unsupported.patch

