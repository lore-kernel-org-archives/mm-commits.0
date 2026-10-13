Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFA047F3AF
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865927; cv=none; b=dm9DZjXdMmWt/WT0rlFGqMiRufoIRmjwOwOWXxGwYAyZksCHiiCzSFkN2qqLCABJX5bKZ+IqSZdOb4sw4OOEV6iEYhtd1z65W+sFvAhAf3UOI7hZK2K7yscmG2do7EYDH1ZCV5l6JTjTMF8atsGnCsPNgGvBoyeDOP8XXC1RzsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865927; c=relaxed/simple;
	bh=RJB/raY3NdAD2BknNCl0EYR8edfgx/qAj9pPmuIOLIU=;
	h=Date:To:From:Subject:Message-Id; b=BtFrN5+3vlm3br1FC9Sq4sYsCoJe9YCHrjMWRTQZ57a8sLKuKuAz6XLcpBcGfM73NDWSc2qm+XYzEJqc811MA2xL/bOhs8LHIPL3wWK51PQTKn1HHnBkaF4MZzfUunIpawHU+OQ+zbmOjLeSe4YICYOzr3cjagexXbBVHSXs8Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gmjZdije; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gmjZdije"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6EB1F000FF;
	Tue, 13 Oct 2026 04:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865926;
	bh=8JUTeb1R2xsFwI/uH+717zdAe/zuUmI66E5oFoEgp5Y=;
	h=Date:To:From:Subject;
	b=gmjZdijeztxNvbob6pL8uEgjEIpRrR03uh5pMMMNczhLXTUcddaLS5zhLk2AvPbPk
	 bgpN5joUuLaP2VvZLO1KFlKED3pwHe15CohRt87ot4+eM86NkCi7BbhJCb317vhaKZ
	 twA7J1xX4Rjz9bB6vtikMPwi4Lqo9WHi/CcGKPys=
Date: Mon, 12 Oct 2026 21:32:05 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,tj@kernel.org,sj@kernel.org,shuah@kernel.org,nphamcs@gmail.com,mkoutny@suse.com,kas@kernel.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,harry@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-ignore-memoryreclaim-eagain-for-zswap-writeback-test.patch removed from -mm tree
Message-Id: <20261013043206.1F6EB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap writeback test
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-ignore-memoryreclaim-eagain-for-zswap-writeback-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260914-test-zswap-wb-ignore-eagain-v1-1-6fb715c22cd8@kernel.org
Fixes: 158863e5d7cc ("selftests: cgroup: add tests to verify the zswap writeback path")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Assisted-by: LLM
Cc: Chengming Zhou <chengming.zhou@linux.dev>
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


