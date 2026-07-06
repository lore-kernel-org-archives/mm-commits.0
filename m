Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4C53F888C
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 23:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783380550; cv=none; b=ENxXGaEe2cO/hqU+gu2Ld++FuamMtqkSBhbZEU7nuyOnGwK6OyakWiX1G8qij9kHitnblJXup/QWfzj6NRRtWQf01oT70mHwS09pkipQFCViZbljTXqnhMBAnuRZ2xeYtqmMdBtwpNnFxrWIQexxpWSuAwKeFO4ocs9qo/fx7hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783380550; c=relaxed/simple;
	bh=D/0ati3QsCcP0f5HuXjnBRjvA4Iuy8lJZ8FlsIBKJFQ=;
	h=Date:To:From:Subject:Message-Id; b=PyzivdVYE3SGZctbjwfDoMFumtPXNtdbS2Kdwdcahs3QALxfftZ5GeNgX04btZnZWD3nu/Mqno3CJWFR1D9zP7HrwYN0nrX1+094M9ej5D2xiLhrNmOeCSuHuwK9ng9w/T1fMFQJtQO9OHuQQQ/MyBOBijvySw1BiISF8RbMNKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s/Gwjgg4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s/Gwjgg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC371F000E9;
	Mon,  6 Jul 2026 23:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783380548;
	bh=cfbeOsDiV07zWY9hluTAn8LVKWgFkKlC/o46fZ3Uypw=;
	h=Date:To:From:Subject;
	b=s/Gwjgg4bD9PuUOwQLN7U93dN4jdyXY1KkdBaDsZwX5Ac8f1hiDNf9tO8MT8PLiBz
	 AD4XK/DPGRrUtvL3yUpsebn9Ut6Tezw9UWJNs6P/v+leut3ll5CYpl5dCPRKpFO+uJ
	 LcoCaY2ZFrhkzGUDOTw0SXvqHDNkWq6VDw/BqG1w=
Date: Mon, 06 Jul 2026 16:29:08 -0700
To: mm-commits@vger.kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch added to mm-unstable branch
Message-Id: <20260706232908.CDC371F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add missing pthread_create() return checks in pkey tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch

This patch will later appear in the mm-unstable branch at
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
Subject: selftests/mm: add missing pthread_create() return checks in pkey tests
Date: Mon, 6 Jul 2026 16:15:59 +0800

Add missing pthread_create() return checks in pkey sighandler tests to
avoid hanging in pthread_cond_wait() when thread creation fails.

Link: https://lore.kernel.org/20260706081600.3570203-6-lihongfu@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Tested-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ross Zwisler <zwisler@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yury Khrustalev <yury.khrustalev@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey_sighandler_tests.c |   12 +++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -220,7 +220,11 @@ static void test_sigsegv_handler_with_pk
 	pthread_attr_init(&attr);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
-	pthread_create(&thr, &attr, thread_segv_with_pkey0_disabled, NULL);
+	ret = pthread_create(&thr, &attr, thread_segv_with_pkey0_disabled, NULL);
+	if (ret) {
+		errno = ret;
+		pkey_assert(0);
+	}
 
 	pthread_mutex_lock(&mutex);
 	while (siginfo.si_signo == 0)
@@ -259,7 +263,11 @@ static void test_sigsegv_handler_cannot_
 	pthread_attr_init(&attr);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
-	pthread_create(&thr, &attr, thread_segv_pkuerr_stack, NULL);
+	ret = pthread_create(&thr, &attr, thread_segv_pkuerr_stack, NULL);
+	if (ret) {
+		errno = ret;
+		pkey_assert(0);
+	}
 
 	pthread_mutex_lock(&mutex);
 	while (siginfo.si_signo == 0)
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc.patch
selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch
selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch
selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch
selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch
selftests-mm-fix-clone-cleartid-race-in-pkey-sighandler-tests.patch

