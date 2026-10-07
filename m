Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0F11ABEDE
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338649; cv=none; b=pp6S0W/wXM9HpoKPXvMj0o8UNEeHAKVsyF13CALDCBZg8mUGtNO/Oedvd1Pb+ZtsoujXvT0XDftmjLpubNI1EE/KZcK5KYLBnhs9RPqeVlXZJQbSoPkBcmR2AfpYotovHTBuDOgSt2xn3gzeIis1iTr/IE+0Bsi/fOMIusmoKtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338649; c=relaxed/simple;
	bh=8Z650uuLpM7ABYvpG5YcXI+LX9daiF8nxWZsptN/trw=;
	h=Date:To:From:Subject:Message-Id; b=PG6o0yE8W85Q9t85XLSAbAWREtFAZdkpnzbSZkwtlE/vGpGD4oyCG641xMsJDpYXu3z4XaodvNx8ojfUNBHU0Apge9HQ19oSZ+qungDjxIJ5ibS0dFzgZn11CBUKHoAzoBa0TH8kYP3sNFya6pyM59sj7YJc29aOfR2et8it9E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M4D0QLtz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M4D0QLtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFF51F0089C;
	Wed,  7 Oct 2026 02:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338647;
	bh=Gq4vJro4F+CnI/SsoIPQwZ8rE2gPsSs+2jBt6sJ/wj0=;
	h=Date:To:From:Subject;
	b=M4D0QLtzBD8G25QfdF2a9zahK/FILzJo4MW2XN6FmwPiCKNRQ2lWovI5fDDthPn7j
	 Ctfw/YKxvtsgvt9W5MAFCVn/D333Wd0au1dU5jfQHpY8BsAdEZdqK7Dqbte5QMS7fM
	 spZIxa97AQZurZ0wZTCDFZrQkr1y9wlBJgc3dVQo=
Date: Tue, 06 Oct 2026 19:04:07 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,shuah@kernel.org,rostedt@goodmis.org,richard.weiyang@gmail.com,peterz@infradead.org,paulmck@kernel.org,mjeanson@efficios.com,mingo@redhat.com,mgorman@suse.de,mathieu.desnoyers@efficios.com,kprateek.nayak@amd.com,juri.lelli@redhat.com,dietmar.eggemann@arm.com,bsegall@google.com,christian.gellermann@codasip.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-membarrier-skip-unpermitted-membarrier-command-test-if-preregistered-by-libc.patch removed from -mm tree
Message-Id: <20261007020407.DAFF51F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/membarrier: skip unpermitted membarrier command test if preregistered by libc
has been removed from the -mm tree.  Its filename was
     selftests-membarrier-skip-unpermitted-membarrier-command-test-if-preregistered-by-libc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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


