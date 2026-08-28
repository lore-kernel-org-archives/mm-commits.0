Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3563655D8
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 02:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787885597; cv=none; b=b6W2EraEOD81GK3rbekiP2KTpfIci10KQrykbwrNKkwpa1Fjh+royEpqesYP/Cz0V++zGd70gWrf08oi/+IU0R8XB3SbdYr5zQ/jAUWBgq+qYtmlz05iVK8oS5t7+JeFYa3mbgGBLv0y0F0B8q8VH8Jqz9wugfNiZS/Bv+qykRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787885597; c=relaxed/simple;
	bh=qPNwO8+Clg2lQKucDw4hoSfDSYjlaL6GayrWLkpjQnA=;
	h=Date:To:From:Subject:Message-Id; b=g157ligZwbUUdVcymHBuDHXSfyREVV+GLYz24rmVz5VlQnihARvUJb/g7sZ1GecRkQ0KnBTzqgFywLgnk/Pd7bOFtLha2n7Z4wpOXlGHWKaa42RQzjnSg4OizHtPVsThU4ZYvx4MIX35kLanYm0U3Kex0QTy3Gy8Rro/q3IE2CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MEEv0uxm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MEEv0uxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BB11F000E9;
	Fri, 28 Aug 2026 02:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787885594;
	bh=Q7ozEPQBW3+CKnegj/XkWDugd+GTt7Nim3AcI8DQcdw=;
	h=Date:To:From:Subject;
	b=MEEv0uxm2GpBABoJJG/HL/DYZVRR9kzJ5rda6T+7NcA2i5k0Gj6oWW929HfQCt2gy
	 HhBJ6IU1dIA4pZHkmJQ4gpuM+t+Lb/W6CEt5HYsIvFVBqP8/q1ZwTneFlPdc3wlwJC
	 Yu9bCG2LjKO1Cz4oDjuJmhUUEUR2U9yJ6SsTYsss=
Date: Thu, 27 Aug 2026 19:53:14 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,shuah@kernel.org,rostedt@goodmis.org,richard.weiyang@gmail.com,peterz@infradead.org,paulmck@kernel.org,mjeanson@efficios.com,mingo@redhat.com,mgorman@suse.de,mathieu.desnoyers@efficios.com,kprateek.nayak@amd.com,juri.lelli@redhat.com,dietmar.eggemann@arm.com,bsegall@google.com,christian.gellermann@codasip.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-membarrier-introduce-helper-to-get-membarrier-command-registrations.patch added to mm-nonmm-unstable branch
Message-Id: <20260828025314.B6BB11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/membarrier: introduce helper to get membarrier command registrations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-membarrier-introduce-helper-to-get-membarrier-command-registrations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-membarrier-introduce-helper-to-get-membarrier-command-registrations.patch

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
Subject: selftests/membarrier: introduce helper to get membarrier command registrations
Date: Mon, 3 Aug 2026 14:48:59 +0200

Patch series "selftests/membarrier: Skip an unregistered memory barrier
test on Musl".

The membarrier test "membarrier MEMBARRIER_CMD_PRIVATE_EXPEDITED not
registered failure" fails in the multithreaded test scenario when using
Musl libc as the command gets preregistered implicitly during thread
creation.  Skip the test if command registration is detected.


This patch (of 2):

Add a new membarrier_get_registrations() for reusage.

Link: https://lore.kernel.org/20260803124900.3328789-1-christian.gellermann@codasip.com
Link: https://lore.kernel.org/20260803124900.3328789-2-christian.gellermann@codasip.com
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

 tools/testing/selftests/membarrier/membarrier_test_impl.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/membarrier/membarrier_test_impl.h~selftests-membarrier-introduce-helper-to-get-membarrier-command-registrations
+++ a/tools/testing/selftests/membarrier/membarrier_test_impl.h
@@ -16,6 +16,11 @@ static int sys_membarrier(int cmd, int f
 	return syscall(__NR_membarrier, cmd, flags);
 }
 
+static int membarrier_get_registrations(void)
+{
+	return sys_membarrier(MEMBARRIER_CMD_GET_REGISTRATIONS, 0);
+}
+
 static int test_membarrier_get_registrations(int cmd)
 {
 	int ret, flags = 0;
@@ -24,7 +29,7 @@ static int test_membarrier_get_registrat
 
 	registrations |= cmd;
 
-	ret = sys_membarrier(MEMBARRIER_CMD_GET_REGISTRATIONS, 0);
+	ret = membarrier_get_registrations();
 	if (ret < 0) {
 		ksft_exit_fail_msg(
 			"%s test: flags = %d, errno = %d\n",
_

Patches currently in -mm which might be from christian.gellermann@codasip.com are

selftests-membarrier-introduce-helper-to-get-membarrier-command-registrations.patch
selftests-membarrier-skip-unpermitted-membarrier-command-test-if-preregistered-by-libc.patch

