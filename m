Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94233DD874
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 23:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783379893; cv=none; b=n06YsIV+Z9gkJAbddsXKs/2g6wxhZxyBQTbIzGGO5q3UsW8cPltxvZYuFr28tcLUL0j4elomjeJLD7OFB5SxMwhpr7snTA/b7cFXye4Qgs2cDMaWYPubDNMdZ4xq+QM4XK62xpf4SGc+YvPlmlx5k/Z9kNtlTcrfPUDnTYAr0NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783379893; c=relaxed/simple;
	bh=V81AdZsHdUuV9BCJrE5rsFCz1R1fC/rmMRWG3tFBhD4=;
	h=Date:To:From:Subject:Message-Id; b=LO2XE9g8hgF1o9NWf/lWwWabz4OsWrIPtk5Gg9AzO7Lix3SitnK0SYMOOW1Bb/GNvIyfGTMgGiMpRYZytcLBuWxNhJrqNy2t61mS5fM0aomgOoSBzJhGOr87xa/cIfp4h15QH9iVukhc99wc8fj6D3sotWtddXCNch8xIcx/b+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c79CE6QG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c79CE6QG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526C91F000E9;
	Mon,  6 Jul 2026 23:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783379892;
	bh=WI/w8DuOxpCS3kS2zSo+lR6U0EpacTimPGZNEiGrm8k=;
	h=Date:To:From:Subject;
	b=c79CE6QGSiY7U+WvqfLs0LueEaCJ4MowVG6CTvA50GTMOyw9tb8voMCg+ro0l0jfX
	 DA0VbqJgDozrrJou68ynxLoB5kYH9Vu4ANFqBjoqqstfP+Z5jhAji8Sdecp6y48TDS
	 cMUc5DJc304NYEKZ5sp0P0TnDzFEBy8+/GhobJdQ=
Date: Mon, 06 Jul 2026 16:18:11 -0700
To: mm-commits@vger.kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch removed from -mm tree
Message-Id: <20260706231812.526C91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add missing pthread_create() return checks in pkey tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: add missing pthread_create() return checks in pkey tests
Date: Thu, 2 Jul 2026 14:23:32 +0800

Add missing pthread_create() return checks in pkey sighandler tests to
avoid hanging in pthread_cond_wait() when thread creation fails.

Link: https://lore.kernel.org/20260702062332.911786-6-lihongfu@kylinos.cn
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


