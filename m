Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC7B367B9E
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 20:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783284221; cv=none; b=BhGWnrTGiGOCh7jLAxT+MQLlJS5W0Fhs4wU+M3pDn8Jz6i6OkKapItWjMLIwOR4RQ+XRaO0hmcgAUQx8OMus/7j50x066i9jEK1av2Fh2yojm/w3Elxj7lRDkIu5NEFBkWR+9o5zOfeQkgpSEl2+K2kXLmpGzjbZ6o4YTYy3EyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783284221; c=relaxed/simple;
	bh=ouGCJTzzSKyxbpjxoqI3Y1tdY+1irmkGcYkdMBBE69E=;
	h=Date:To:From:Subject:Message-Id; b=XEduXmuSC5niwlve0DZ9Tk/3Bl7o9KZKbQJ6VgCasf5qbjhT5jRV6D9NHBjVTmVJdTLRmx8gKraBnMIxrRKHT0u1VPkRSxxNNVh7t7NDMGyrRNOzPIR3ktcVfc24AaYOR6Mtlbga0BFiPjpyADGr4ht6J+ycdozAcbkg8cQw9bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eIMWaI48; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eIMWaI48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB41B1F000E9;
	Sun,  5 Jul 2026 20:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783284220;
	bh=TII5Ci/pnknTGZWSfg8miBYkexJjEqNFpK7IicC8ZTY=;
	h=Date:To:From:Subject;
	b=eIMWaI48Y42xnHQ6ahblnuEa7AHJf8w2PYdG2FaJERe9OnASXIEUb38UiFdl6QL7Q
	 n01lKj8DVgFsH/K5jpgscXKBsCLH4mTFmW4/5G7QGn7TegNUjxV37nrdHB39GZn0t8
	 9lbJA6NSh4tSOwlljkaLcdJK5ATcN6KnLNaalYY4=
Date: Sun, 05 Jul 2026 13:43:39 -0700
To: mm-commits@vger.kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch removed from -mm tree
Message-Id: <20260705204339.DB41B1F000E9@smtp.kernel.org>
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
Date: Tue, 30 Jun 2026 15:32:33 +0800

Use pkey_assert(0) instead of perror("clone") when clone_raw() fails.  The
old path only printed an error and continued; the test now exits via
pkey_assert() on failure so it does not hang or proceed with an invalid
child.

Link: https://lore.kernel.org/20260630073235.3802271-4-lihongfu@kylinos.cn
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

 tools/testing/selftests/mm/pkey_sighandler_tests.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -333,7 +333,7 @@ static void test_sigsegv_handler_with_di
 
 	if (ret < 0) {
 		errno = -ret;
-		perror("clone");
+		pkey_assert(0);
 	} else if (ret == 0) {
 		thread_segv_maperr_ptr(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
@@ -506,7 +506,7 @@ static void test_pkru_sigreturn(void)
 
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

