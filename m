Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A167535E1B1
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 20:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783284223; cv=none; b=NSPuW9FHPVMarjlBMV4oM4CisOCL+OEaZ+AAu0cH4xXeedjyJLEZAFLR1nssnIO5FaPg89mIxGZ3tscvA93AkqeyA5NqXmCsJQTzRiuCSwlINQyivyyVHy2n1iChzuFczVcqzrXM4q6gsr8pfUQa+i+MIHFO30tPNaW3SZAEG+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783284223; c=relaxed/simple;
	bh=5bhodwrFVP614HwrbZYEoR8zVEgI+xLNQeA+rPFOhy4=;
	h=Date:To:From:Subject:Message-Id; b=ip1QOGgYBTF1+6aKCC2+hk48p619bAX4AStYPqFMEV65tZY/DmE8kuTampRL/HxXCunScUA6JNgEaUlo1h/rXL6Dy6Z332skJdp+EYqYDNvdrVkrrqFjlexGCJm+6mSXm1ogOytbe0B4nv/wgJ75VDeci+jl3oYcP4w4wUL12GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ov9zxYox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ov9zxYox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B121F000E9;
	Sun,  5 Jul 2026 20:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783284222;
	bh=xpzi2J83gvwztNeTrv/wxoog+jO2LrN4VetWM6K3MI0=;
	h=Date:To:From:Subject;
	b=ov9zxYoxDzlKcFezXz8U53aU+k9N3x5BX/5f1egW5Udet13Jw26C2WUnkscHPFTk7
	 /CLvLBUvy6e9CaRcS2p8boDPePD64eOqPFsuzU0Tr7njOEscZ6CGrVnZGCkrbrLn9i
	 ZQstevVc0Jc0QM1z1OY4r+Po+LZOf57iC1E8kkdg=
Date: Sun, 05 Jul 2026 13:43:42 -0700
To: mm-commits@vger.kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch removed from -mm tree
Message-Id: <20260705204342.78B121F000E9@smtp.kernel.org>
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
Date: Tue, 30 Jun 2026 15:32:35 +0800

Add missing pthread_create() return checks in pkey sighandler tests to
avoid hanging in pthread_cond_wait() when thread creation fails.

Link: https://lore.kernel.org/20260630073235.3802271-6-lihongfu@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Tested-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
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


