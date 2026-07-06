Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8B53DD538
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 23:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783379890; cv=none; b=raeZtEskIrWLyWOFzPSlRzrINqjZ1dGivazd2ntl84FeNubdRg1k0oHtZSEJ/9QfajL7ltj+RTfR4WPg22CYQbAnhpnWOoJ2QM51idTloV9K75gmk6NFz2+cYLjeM6EMf6LG42Lun54LIokmUhn/gNOzDVbiKsu9o1CL/zflRk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783379890; c=relaxed/simple;
	bh=qjcsSF9LZEIZN90lapftmsppGmGRcMml6CjQV+48Y64=;
	h=Date:To:From:Subject:Message-Id; b=bB5ITPv/d7ZYJWKlhbbudcNpXpVuIVkAMln4uvkPBfQSP5iUQ/X96YX8M8fO0Vs19sRO5NWZtMEfVKn3+bKo+Lk9mWtKZCKZQw4CglQ2FGtU2qZc1Y/8qC3uhCDMb79cvJxOkpcJSufZvgI2JXpHE3LRc/FLjQ/UYV8DZqJz8wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sNJxGD/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sNJxGD/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0C61F00A3A;
	Mon,  6 Jul 2026 23:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783379889;
	bh=e+mOPAL7lhOEpQ7isc1Ile9yFqNDcxkDk8nhmwMGuxg=;
	h=Date:To:From:Subject;
	b=sNJxGD/ZQZYNgHYVp9kbtaFjxTSC1l9bxo4e7rmBMu3E6oSIzcfFzG+RfPJaCiMk5
	 5nzTS+Jz2GNlnFfW7sw4ICOe0+/Af75KdKsK6PlHr8mSZRho/2EcDN3WbKDKOtD0NM
	 8aDoCBae1wVwzB57y5GzREOw06Talu8Mh8JiD1mY=
Date: Mon, 06 Jul 2026 16:18:08 -0700
To: mm-commits@vger.kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch removed from -mm tree
Message-Id: <20260706231809.0B0C61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: use pkey_assert on clone_raw failure in pkey test
has been removed from the -mm tree.  Its filename was
     selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: use pkey_assert on clone_raw failure in pkey test
Date: Thu, 2 Jul 2026 14:23:30 +0800

Use pkey_assert(0) instead of perror("clone") when clone_raw() fails.  The
old path only printed an error and continued; the test now exits via
pkey_assert() on failure so it does not hang or proceed with an invalid
child.

Link: https://lore.kernel.org/20260702062332.911786-4-lihongfu@kylinos.cn
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

 tools/testing/selftests/mm/pkey_sighandler_tests.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -329,7 +329,7 @@ static void test_sigsegv_handler_with_di
 
 	if (ret < 0) {
 		errno = -ret;
-		perror("clone");
+		pkey_assert(0);
 	} else if (ret == 0) {
 		thread_segv_maperr_ptr(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
@@ -502,7 +502,7 @@ static void test_pkru_sigreturn(void)
 
 	if (ret < 0) {
 		errno = -ret;
-		perror("clone");
+		pkey_assert(0);
 	}  else if (ret == 0) {
 		thread_sigusr2_self(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch
selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch

