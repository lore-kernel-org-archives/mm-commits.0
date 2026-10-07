Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24644345EDC
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338648; cv=none; b=T5pAiu5Spik7nZvqDdVJxn1j2ns48O6GLMQKQ0d0opVSEfXhcW5n2x9RDf+ayXJ2PSfndeDiEkYpE+M7XPsN09SqOht0URZ6J1HjbmCUqgDnaODz5VeslkPP9y+t+RQrHWj/rXieiM+b5s1KopOkCEpO2fnsxNdcjfCsMDP484g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338648; c=relaxed/simple;
	bh=lYt2an4vDQ9v1sanbjxaa9G1hNcePixbwDWnPPYa94U=;
	h=Date:To:From:Subject:Message-Id; b=pTMxztlUk0pV6LhD5eIKUApvt0EF2Htl3Y7J00orLdIpz6q7f3Hss2rnMOooRMZbRlTcCw6tQgGDn0CQRokG8mrl0igQFv6BE7gsbgrSkGIjkjuunY5C+c4b0LmOklwU6LbRhJAUx5LmGLgjUpSlCuAYnkiwPa83c3YndRg0ai4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k03ql+Xv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k03ql+Xv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6471F0089B;
	Wed,  7 Oct 2026 02:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338646;
	bh=IclrGpw+LaUrPe4+VaFxTxHsalLvLSP5lQF3Yp0/Zds=;
	h=Date:To:From:Subject;
	b=k03ql+XvRjmC19aCI2yM3n0TghjSbi57hmApuW+WB/8SOF8uR5WMG9bLT8lTKgpHu
	 2VcTHgksvdvi/tpylA+otrIqE3u5KN60TSGL8h1zkliMqwXYNVSOGE08BQZgDKjbwq
	 y6vxHKF3xUkNYKQeEMN10El+6dVYASZ78q7rUeto=
Date: Tue, 06 Oct 2026 19:04:06 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,shuah@kernel.org,rostedt@goodmis.org,richard.weiyang@gmail.com,peterz@infradead.org,paulmck@kernel.org,mjeanson@efficios.com,mingo@redhat.com,mgorman@suse.de,mathieu.desnoyers@efficios.com,kprateek.nayak@amd.com,juri.lelli@redhat.com,dietmar.eggemann@arm.com,bsegall@google.com,christian.gellermann@codasip.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-membarrier-introduce-helper-to-get-membarrier-command-registrations.patch removed from -mm tree
Message-Id: <20261007020406.BA6471F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/membarrier: introduce helper to get membarrier command registrations
has been removed from the -mm tree.  Its filename was
     selftests-membarrier-introduce-helper-to-get-membarrier-command-registrations.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


