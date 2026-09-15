Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C223876BB
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 21:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789508461; cv=none; b=HeNNTs/ZMJ9KJWlBgKqVLpS6uEtlGSLLrNMTZDb78u+Zaali28zrtyebmnxHhMVRZ3yChbH5UEkUnvNeUFdPqC9+7iThnsqAyExtLWjZMGKAECtVNaImc3IXqjuInVSfJP2uuS8h1UCVL082RMBW0wwwP2P3+DuwrstRdXnv89w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789508461; c=relaxed/simple;
	bh=Q01PnRgrcUN+sLaFhU9zIguzmob8nHamMBMbpFhoBms=;
	h=Date:To:From:Subject:Message-Id; b=TNQfan+WlO3qjsopQx8SibUvuykwuRivnSCuA5Bl+VXHJ5hDQbEfZ/q6q1ha6NfIzVpiVMvemPjVZFRyxkd+p6c2b830b58l4ctuQ9qRX6U/XcYDEuN3cPdp0gUM/CNQ4M1BiiU8tlyrDftVG8p72FgcqKr5wxGddJthEpaoDEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ufP8/3Ne; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ufP8/3Ne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04A11F000FF;
	Tue, 15 Sep 2026 21:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789508460;
	bh=isjCb6sbp+vlOmO5ey85x8kVZGFQSSDmPaJn+S5SnI0=;
	h=Date:To:From:Subject;
	b=ufP8/3NeaXF0furE1pOLyCt7pKaf3Bp0bQlCpax/3FCYlExvpe/Asde7T7/CR4Qhp
	 7yZdxFqHP0WC14cJ2DSfYuNWBonW6MQ2SGo4jHIxUlw2zDJfllL/TIv/3L7KeVLMaA
	 eDKn82nZrrI8oUwrGD4MmRukun4ZlFoybRrR4xfA=
Date: Tue, 15 Sep 2026 14:40:59 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,tj@kernel.org,sj@kernel.org,shuah@kernel.org,nphamcs@gmail.com,mkoutny@suse.com,kas@kernel.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,harry@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-ignore-memoryreclaim-eagain-for-zswap-writeback-test.patch added to mm-new branch
Message-Id: <20260915214059.E04A11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap writeback test
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-ignore-memoryreclaim-eagain-for-zswap-writeback-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-ignore-memoryreclaim-eagain-for-zswap-writeback-test.patch

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
From: "Harry Yoo (Meta)" <harry@kernel.org>
Subject: selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap writeback test
Date: Mon, 14 Sep 2026 21:36:39 +0100

The zswap_writeback_enabled test fails when a write to memory.reclaim
returns -EAGAIN, which means less than the requested amount was reclaimed.
attempt_writeback() propagates the -EAGAIN to the caller, and the test
case is marked as failed even when zswap writeback did happen.

This heavily depends on the performance of the backing swap device. 
Reclaim does not wait for writeback (on cgroup v2), does not count pages
that are under writeback as reclaimed, and memory.reclaim gives up after
MAX_RECLAIM_RETRIES passes without making progress.  On a slow device
where reclaim does not make any progress before writeback completes, a
write to memory.reclaim fails.

On a VM with zswap enabled, where IO delay was injected via dm-delay, the
success rate of the zswap writeback test drops dramatically once the delay
reaches 11 ms: 7% failures at 10 ms and 79% failures at 11 ms, n = 100.

When zswap writeback is enabled, ignore -EAGAIN from memory.reclaim and
determine pass/fail based on the zswpwb counter because that is what
zswap_writeback_enabled actually wants to test.

With this change, the test reliably passes even on a slow swap device
(tested up to 1000 ms delay).  This makes the test resilient against the
performance of the swap device.

Assisted-by: LLM
Link: https://lore.kernel.org/20260914-test-zswap-wb-ignore-eagain-v1-1-6fb715c22cd8@kernel.org
Fixes: 158863e5d7cc ("selftests: cgroup: add tests to verify the zswap writeback path")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Harry Yoo <harry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
---

 tools/testing/selftests/cgroup/test_zswap.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-ignore-memoryreclaim-eagain-for-zswap-writeback-test
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -346,7 +346,16 @@ static int attempt_writeback(const char
 	 * it can't writeback to swap.
 	 */
 	ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
-	if (!wb_enabled)
+
+	/*
+	 * When writeback is enabled, memory.reclaim may still fail to reclaim
+	 * the requested amount of memory due to a slow swap device.
+	 * Ignore -EAGAIN here. The caller determines pass/fail based on the
+	 * zswap writeback counter.
+	 */
+	if (wb_enabled && ret == -EAGAIN)
+		ret = 0;
+	else if (!wb_enabled)
 		ret = (ret == -EAGAIN) ? 0 : -1;
 
 out:
_

Patches currently in -mm which might be from harry@kernel.org are

selftests-cgroup-ignore-memoryreclaim-eagain-for-zswap-writeback-test.patch

