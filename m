Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8361C36CE06
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 05:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782883254; cv=none; b=FgEB2pYzzYdywV7DJI5FJWLDLR8qtW3r973GAs1p6zu7IeoIzIvDPw98bSivrJI1M4wafUPqUv46p/3O2cQD8UrJloBeHkHd7zZdpLkNYCxoiJO6HGMs/fEYWDKKe6AGjys2OdKxrDYSN6VX/I+gglifmjU5DDAq3NYwbdZ6oKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782883254; c=relaxed/simple;
	bh=L/uDs0mugZC2eH+WFEUgYuaafmOXnh7xOiDJ9L3ib50=;
	h=Date:To:From:Subject:Message-Id; b=BL5QQXEkXltoCd//SZxjP4sCmlN/UPTiL1fMS8YJdy0Ua8bIYDVEIvw+aFyIBN7hk8WrT8eR2rPg5LfH7M6UDim9JBnWsYGe+0p+O9vg7bnr3/CZLpkDn8qBuu9PhuBTz0buIMAtdY7zquCVTC74+vS090Cv5OS6mpeo7KqU7M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WsAxq5r5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WsAxq5r5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD011F000E9;
	Wed,  1 Jul 2026 05:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782883253;
	bh=gQY2VEiHWY79mgJSbH/iEnNQ1587z7zXRhR5QHRLN4U=;
	h=Date:To:From:Subject;
	b=WsAxq5r5bMVTw4X/2UBZWOuk1BYkY6/woj32wxfuqAz680gyAzJCjEbqj+Mocg4MW
	 j17IDh88fse4v04TBk4fYK9CiDbNFXSzAoKHQW7Ayq7LLk5TyQhXskRebULIaWFzVw
	 0Uoixlr4Rhz64uAHrDpLoReWszecpqVa+WgtxSw4=
Date: Tue, 30 Jun 2026 22:20:52 -0700
To: mm-commits@vger.kernel.org,zwisler@google.com,yury.khrustalev@arm.com,vbabka@kernel.org,usama.anjum@collabora.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,kevin.brodsky@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,jhubbard@nvidia.com,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch added to mm-new branch
Message-Id: <20260701052053.1DD011F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: use pkey_assert on clone_raw failure in pkey test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch

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

selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc.patch
selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch
selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch
selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch
selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch

