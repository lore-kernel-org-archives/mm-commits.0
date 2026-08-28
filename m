Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9F93655D9
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 02:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787885598; cv=none; b=jh0PiPatUr8A8y8erFeawLhkSNdiIgnMzasD5H2rBklWv6dJQSSEKE7oeXdz2aOf3KSl8dnWAY93j0rlppS88F9hj62ra6YcRaMrM4eEE/ExGUXF8K5NFFt3B+g29XfZHoEnKt/JX8wW0Z3a4fn8iYatVFs2zQQjWfJRzuvaou0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787885598; c=relaxed/simple;
	bh=IsTLn2d/J6UCDzQ5kVFIOgyQ3qpsN9qfTKNa0J+5IW4=;
	h=Date:To:From:Subject:Message-Id; b=r74URNV4owllxCb3Q+LZHJalqfSZ43GuG0QFSMbcj1jvJxl9HZ7Y7B2r1K5YakNBe/cK30moEUS2bh/gbR2CZ0p5T9vGnstsU/FT2aIP1BNtZ/3iojN3bWZFaR3CrUSEB3ts5Y/p6fivImYvxlHzHRQiw6o45QwBwKbcX6S4ZRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aLmbcFsd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aLmbcFsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE38E1F00A3A;
	Fri, 28 Aug 2026 02:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787885596;
	bh=DL/7SV3PLNp/I7F7egjWemOI2cPVzW8nhIDCREE2w80=;
	h=Date:To:From:Subject;
	b=aLmbcFsdBqL+V4wLo4K4atDPgUUhhpbDFvKxTp9NBbswVWLgPlg9bQHu4sTawdWyN
	 uIKSXi8QVWqn1jWun6jDeQhNGqbrjuvFE4vafeteJq+kJnPS3HYdWywFN5DOI60yCH
	 h5yPKoTO2JkDq/Uof79jES/EI2fBRcCc5zHHrnn8=
Date: Thu, 27 Aug 2026 19:53:16 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,shuah@kernel.org,rostedt@goodmis.org,richard.weiyang@gmail.com,peterz@infradead.org,paulmck@kernel.org,mjeanson@efficios.com,mingo@redhat.com,mgorman@suse.de,mathieu.desnoyers@efficios.com,kprateek.nayak@amd.com,juri.lelli@redhat.com,dietmar.eggemann@arm.com,bsegall@google.com,christian.gellermann@codasip.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-membarrier-skip-unpermitted-membarrier-command-test-if-preregistered-by-libc.patch added to mm-nonmm-unstable branch
Message-Id: <20260828025316.CE38E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/membarrier: skip unpermitted membarrier command test if preregistered by libc
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-membarrier-skip-unpermitted-membarrier-command-test-if-preregistered-by-libc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-membarrier-skip-unpermitted-membarrier-command-test-if-preregistered-by-libc.patch

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
From: Chris Gellermann <christian.gellermann@codasip.com>
Subject: selftests/membarrier: skip unpermitted membarrier command test if preregistered by libc
Date: Mon, 3 Aug 2026 14:49:00 +0200

On thread creation, Musl registers the private expedited memory barrier,
see pthread_create [1].  Thus, invoking the barrier command will no longer
be rejected by the kernel with EPERM.  The test checking this will fail. 
Check if the memory barrier command has been registered and skip the test
in this case.

Link: https://git.musl-libc.org/cgit/musl/tree/src/thread/pthread_create.c#n260 [1]
Link: https://lore.kernel.org/20260803124900.3328789-3-christian.gellermann@codasip.com
Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>
Tested-by: Michael Jeanson <mjeanson@efficios.com>
Cc: Ben Segall <bsegall@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/membarrier/membarrier_test_impl.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/tools/testing/selftests/membarrier/membarrier_test_impl.h~selftests-membarrier-skip-unpermitted-membarrier-command-test-if-preregistered-by-libc
+++ a/tools/testing/selftests/membarrier/membarrier_test_impl.h
@@ -113,6 +113,16 @@ static int test_membarrier_private_exped
 	int cmd = MEMBARRIER_CMD_PRIVATE_EXPEDITED, flags = 0;
 	const char *test_name = "sys membarrier MEMBARRIER_CMD_PRIVATE_EXPEDITED not registered failure";
 
+	/*
+	 * Some C libraries, like Musl, register the private expedited barrier
+	 * command when creating a thread. Expecting an EPERM on an unregistered
+	 * command will therefore no longer work. Skip the test in this case.
+	 */
+	if (MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED & membarrier_get_registrations()) {
+		ksft_test_result_skip("%s test: Command already registered\n", test_name);
+		return 0;
+	}
+
 	if (sys_membarrier(cmd, flags) != -1) {
 		ksft_exit_fail_msg(
 			"%s test: flags = %d. Should fail, but passed\n",
_

Patches currently in -mm which might be from christian.gellermann@codasip.com are

selftests-membarrier-introduce-helper-to-get-membarrier-command-registrations.patch
selftests-membarrier-skip-unpermitted-membarrier-command-test-if-preregistered-by-libc.patch

