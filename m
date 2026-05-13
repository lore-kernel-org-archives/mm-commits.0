Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A533B6BE4
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 23:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778715532; cv=none; b=LE0J8sJexsgsjnQWJt1t2ZLDq29GINWCfJYLaMmREViKrgSNFc9u+JA7OKDNJEpzaBE4DQGaUmJD2FrWcej6zjJKgl+0ilNHI1+FNhJAp3GK1Gp9rZbCaqlcCIQ5+TZk1+S/QHfTRho8iAfVrLQhEQWpAF5au8Z15ZisX1PpLQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778715532; c=relaxed/simple;
	bh=NxFyTsUJ/UCUIzKr4uO4SmZY/7UJOk0Gt+PTIo3qRIo=;
	h=Date:To:From:Subject:Message-Id; b=g/UJx1lWmDtfKUSQgPVUnjIToRaTAZkiThWgMFISu7Y/qbok5Bxhm15OekP3orc9ux/zE4w7WeH9g3NlThy7oOTNnkXslNHb+sZb4RrsC8n+N6/tDvtJ74axAXO03AGzTPiV0VYOo4AEtOQ3aCPNLvZ/zDd/4pB77I42h14J9Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VPhUGUTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VPhUGUTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB14C19425;
	Wed, 13 May 2026 23:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778715532;
	bh=NxFyTsUJ/UCUIzKr4uO4SmZY/7UJOk0Gt+PTIo3qRIo=;
	h=Date:To:From:Subject:From;
	b=VPhUGUTThfh8yzfL7xvT24efeUEn1nSbmXCjtTXzJ64myJ8PXXzHEUMfxcTeg4OSq
	 wNCu3B0snVOjCbHGOB6X4iaR9n8EC8u0odT8vdcZ2xZ76IfO2cqRrl6gPY4n2pxHPV
	 gZDLXcRNyhdusmQ2GxloQs1AWfo5KQeCtrxoWDPY=
Date: Wed, 13 May 2026 16:38:51 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,mingo@kernel.org,mic@digikod.net,khuey@kylehuey.com,akpm@linux-foundation.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-perf_events-fix-mmap-error-check-in-sigtrap_threads.patch added to mm-nonmm-unstable branch
Message-Id: <20260513233852.1DB14C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/perf_events: fix mmap() error check in sigtrap_threads
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-perf_events-fix-mmap-error-check-in-sigtrap_threads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-perf_events-fix-mmap-error-check-in-sigtrap_threads.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/perf_events: fix mmap() error check in sigtrap_threads
Date: Wed, 13 May 2026 10:58:38 +0800

In sigtrap_threads(), the return value of mmap() is checked against NULL. 
mmap() returns MAP_FAILED, which is (void *)-1, not NULL, when it fails. 
Since MAP_FAILED is non-zero and non-NULL, the condition "p == NULL" will
never be true on failure, causing the program to proceed with an invalid
pointer and segfault if mmap() actually fails under memory pressure.

Link: https://lore.kernel.org/20260513025838.594945-1-lihongfu@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mickael Salaun <mic@digikod.net>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Kyle Huey <khuey@kylehuey.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/perf_events/watermark_signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/perf_events/watermark_signal.c~selftests-perf_events-fix-mmap-error-check-in-sigtrap_threads
+++ a/tools/testing/selftests/perf_events/watermark_signal.c
@@ -102,7 +102,7 @@ TEST(watermark_signal)
 	}
 
 	p = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
-	if (p == NULL) {
+	if (p == MAP_FAILED) {
 		perror("mmap");
 		goto cleanup;
 	}
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-fix-mmap-return-value-check-in-run_migration_benchmark.patch
selftests-perf_events-fix-mmap-error-check-in-sigtrap_threads.patch

