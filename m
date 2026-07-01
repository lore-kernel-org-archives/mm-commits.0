Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783E7146A66
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 05:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782883259; cv=none; b=YX/C0HkXAaFK0cYzczEXZpf2C/oPALRj7/yTQm4iPMde0nMaso4Myj1A7Gf5M18q2kUWgEY80RCqATapDhvM0RoG+4lz5OgVuMR6r8GxRMtkyh/Drh1CraeiHblzAIc2zgMrlOCX66nZoGr8c9SNuqdnuc0AFVEXEHUdN2LSu2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782883259; c=relaxed/simple;
	bh=aZyhpmU8r2XcE/UmjUZtCiuLZmrqmSDLh3HB7kfz95w=;
	h=Date:To:From:Subject:Message-Id; b=Es6/m2KMsMbCjlhyp6fbVDFKr+EhKi3bDp3Wzyz6u0KqNP/yTeJyalSh4EbdJdeB0JOAeT+XMv6Tgxx6r9Q8raIlZupVkK/N7ngVGQHXvbKguGg9IdKIiqoiYnQrMOZQmwExCvB4X+5bFhFiCAPoB7h3GvWAcGW8JTKWoUJymA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RN5RmOQQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RN5RmOQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5078D1F000E9;
	Wed,  1 Jul 2026 05:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782883258;
	bh=MCfFj7dSDZfn72PLyYCKrQBYD3ObzYBvM8OjUQLaEqk=;
	h=Date:To:From:Subject;
	b=RN5RmOQQyOBEXQzM4fPCWa1QwdTPpSYvPfe5v8rKDT52ttQ94IHjJc7BZGVPO5z7w
	 YTzhpW+eqK/g+OAPVKMsr2w/Ci99I7DnG4F5QIJXkf8Nj/bboNh3wJkM5YePRmgeAI
	 /6BkwyaJAXPJ7MJ0RXmVYWlbU6xjjuah7cdo3WH0=
Date: Tue, 30 Jun 2026 22:20:57 -0700
To: mm-commits@vger.kernel.org,zwisler@google.com,yury.khrustalev@arm.com,vbabka@kernel.org,usama.anjum@collabora.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,kevin.brodsky@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,jhubbard@nvidia.com,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch added to mm-new branch
Message-Id: <20260701052058.5078D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add missing pthread_create() return checks in pkey tests
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: add missing pthread_create() return checks in pkey tests
Date: Tue, 30 Jun 2026 15:32:35 +0800

Add missing pthread_create() return checks in pkey sighandler tests to
avoid hanging in pthread_cond_wait() when thread creation fails.

Link: https://lore.kernel.org/20260630073235.3802271-6-lihongfu@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ross Zwisler <zwisler@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yury Khrustalev <yury.khrustalev@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey_sighandler_tests.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -224,7 +224,8 @@ static void test_sigsegv_handler_with_pk
 	pthread_attr_init(&attr);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
-	pthread_create(&thr, &attr, thread_segv_with_pkey0_disabled, NULL);
+	ret = pthread_create(&thr, &attr, thread_segv_with_pkey0_disabled, NULL);
+	pkey_assert(ret == 0);
 
 	pthread_mutex_lock(&mutex);
 	while (siginfo.si_signo == 0)
@@ -263,7 +264,8 @@ static void test_sigsegv_handler_cannot_
 	pthread_attr_init(&attr);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
-	pthread_create(&thr, &attr, thread_segv_pkuerr_stack, NULL);
+	ret = pthread_create(&thr, &attr, thread_segv_pkuerr_stack, NULL);
+	pkey_assert(ret == 0);
 
 	pthread_mutex_lock(&mutex);
 	while (siginfo.si_signo == 0)
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc.patch
selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch
selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch
selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch
selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch

