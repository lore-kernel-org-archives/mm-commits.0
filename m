Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BA5371D01
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028779; cv=none; b=o+lbPGMQTJO1eG6Riih0GIYMkwIe5t54YAbRF4OmURGC2Qcoezj8kp/W9TWSdOC3bsiyoYpeOB4YYwKnlt2gMcKiH7mqrfZbWPVL1rQIJyVzkYuMsetx40L2sGjxvC6fOhi5CT/0B6DnGVRj0CmlEUqbdogKHs217blTRIwB+ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028779; c=relaxed/simple;
	bh=Gav6ZeYJgQkrUIyYKWEGNKruTCsLZRUa2QhIRNizD3k=;
	h=Date:To:From:Subject:Message-Id; b=s6lYGK/VAyWo3dNJtzeo6GcXD7GrsZtrNLADdHtswV3rDAUoG+bHTK7A0Xm+m637/HYKxPIHGMVufSi+8mhTnaPgRKFGMeMQJOBsuEe4GWTCT+PXm9sa75EBIRjH0lYyfvE0uiElHo2LguJu3Gdv8g4GOksmUtIG2M2ovdjnePQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YMqwecfY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YMqwecfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7F51F00898;
	Fri, 29 May 2026 04:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028778;
	bh=c3n2AGreV0qe1nB0j0LETfe9k2ZnZkr4vqMxxl0ZXtI=;
	h=Date:To:From:Subject;
	b=YMqwecfYjHfuRplbpGdqLubTzy96yDj6u6U1oa67iqbQvJvC9TyES9GaVR0Rl5/h+
	 tyLyTLvKQrVJrMap7mrKT3BjO3ZjPdIx9KmQXXrDEJvb5YzrOSkyYrGDgg+AjsbGby
	 Yqz+9o5m7QoljIj+Uw+qPi8JlSl3xsU9BXPHb1zw=
Date: Thu, 28 May 2026 21:26:17 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,mingo@kernel.org,mic@digikod.net,khuey@kylehuey.com,akpm@linux-foundation.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-perf_events-fix-mmap-error-check-in-sigtrap_threads.patch removed from -mm tree
Message-Id: <20260529042618.4A7F51F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/perf_events: fix mmap() error check in sigtrap_threads
has been removed from the -mm tree.  Its filename was
     selftests-perf_events-fix-mmap-error-check-in-sigtrap_threads.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
selftests-mm-fix-incorrect-mmap-error-handling-with-null-instead-of-map_failed.patch

