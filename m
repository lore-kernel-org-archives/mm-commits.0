Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A04146A66
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 05:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782883256; cv=none; b=HHcAcLmhPL+GfdPrOxaWSwyEBGfqNAOlsiTxW/acya4PXISsSG1QPQggPaR2rrsXMzHq9PoXBKuectNmcLV8jPWC7GGn4ZuoBOe/w+7lPMQyM2xYk1WGxaRv8JAvFxr6GwO/Ubi4vCRBKhtnYDMvcusrWUsE9kFyQF7b7Og3bbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782883256; c=relaxed/simple;
	bh=IpwKqLGtStB2ljBX5dLi+U5uL7mTI5dBD3WEf27isHU=;
	h=Date:To:From:Subject:Message-Id; b=niTWKBjMXOGbN6Zo4iDLGX6+EeTXLMpwdUeMyogdSjKxu1QLGNoOGvoA5BXGc4/UKewke5f0XtLe37fDMi1boR7RsT3EAOSMOzN/jAK41uqidkX4bgKT4QMTZCQM8UKLHHnZxAlUDJqgshQOoauBCSfo+8vpYFTw3VfRM2tN8AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ggJfvnyI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ggJfvnyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9131F000E9;
	Wed,  1 Jul 2026 05:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782883255;
	bh=C73TJbIsOuRGoGHo91rMzHVF/FnW6IO8QD8hjE3Y1os=;
	h=Date:To:From:Subject;
	b=ggJfvnyIZqq2DJrExQkuUI7P/XT63ImUWW85TzKFgdU3sBZWYWd6HEoS5Og0ruBKG
	 eoJBjbn2ZzXYg5p+K1JeBO1anYXzBOO/AqCo3YWLRNJLRW1LJZV3FPgh38d9wSHzOk
	 j+iD0X6tt/qgd4ez74XbYGS+/iQCzY0BcbxfSM7M=
Date: Tue, 30 Jun 2026 22:20:54 -0700
To: mm-commits@vger.kernel.org,zwisler@google.com,yury.khrustalev@arm.com,vbabka@kernel.org,usama.anjum@collabora.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,kevin.brodsky@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,jhubbard@nvidia.com,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch added to mm-new branch
Message-Id: <20260701052055.3E9131F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add missing mmap() return checks in pkey tests
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch

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
Subject: selftests/mm: add missing mmap() return checks in pkey tests
Date: Tue, 30 Jun 2026 15:32:34 +0800

Add missing checks against mmap() return value, replace (void *)-1 with
MAP_FAILED for better readability and consistency.

Link: https://lore.kernel.org/20260630073235.3802271-5-lihongfu@kylinos.cn
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

 tools/testing/selftests/mm/pkey-powerpc.h          |    2 -
 tools/testing/selftests/mm/pkey_sighandler_tests.c |    2 +
 tools/testing/selftests/mm/protection_keys.c       |   12 ++++++-----
 3 files changed, 10 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/pkey-powerpc.h~selftests-mm-add-missing-mmap-return-checks-in-pkey-tests
+++ a/tools/testing/selftests/mm/pkey-powerpc.h
@@ -126,7 +126,7 @@ static inline void *malloc_pkey_with_mpr
 			size, prot, pkey);
 	pkey_assert(pkey < NR_PKEYS);
 	ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 
 	ret = syscall(__NR_subpage_prot, ptr, size, NULL);
 	if (ret) {
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-add-missing-mmap-return-checks-in-pkey-tests
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -317,6 +317,7 @@ static void test_sigsegv_handler_with_di
 	/* Set up alternate signal stack that will use the default MPK */
 	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	pkey_assert(sigstack.ss_sp != MAP_FAILED);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
 
@@ -492,6 +493,7 @@ static void test_pkru_sigreturn(void)
 	/* Set up alternate signal stack that will use the default MPK */
 	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	pkey_assert(sigstack.ss_sp != MAP_FAILED);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
 
--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-add-missing-mmap-return-checks-in-pkey-tests
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -586,7 +586,7 @@ static void *malloc_pkey_with_mprotect(l
 			size, prot, pkey);
 	pkey_assert(pkey < NR_PKEYS);
 	ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 	ret = mprotect_pkey((void *)ptr, PAGE_SIZE, prot, pkey);
 	pkey_assert(!ret);
 	record_pkey_malloc(ptr, size, prot);
@@ -609,7 +609,7 @@ static void *malloc_pkey_anon_huge(long
 	 */
 	size = ALIGN_UP(size, HPAGE_SIZE * 2);
 	ptr = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 	record_pkey_malloc(ptr, size, prot);
 	mprotect_pkey(ptr, size, prot, pkey);
 
@@ -667,7 +667,7 @@ static void *malloc_pkey_hugetlb(long si
 	size = ALIGN_UP(size, HPAGE_SIZE * 2);
 	pkey_assert(pkey < NR_PKEYS);
 	ptr = mmap(NULL, size, PROT_NONE, flags, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 	mprotect_pkey(ptr, size, prot, pkey);
 
 	record_pkey_malloc(ptr, size, prot);
@@ -696,7 +696,7 @@ static void *malloc_pkey(long size, int
 		pkey_assert(malloc_type < nr_malloc_types);
 
 		ret = pkey_malloc[malloc_type](size, prot, pkey);
-		pkey_assert(ret != (void *)-1);
+		pkey_assert(ret != MAP_FAILED);
 
 		malloc_type++;
 		if (malloc_type >= nr_malloc_types)
@@ -1114,6 +1114,7 @@ static void arch_force_pkey_reg_init(voi
 	 * doing the XSAVE size enumeration dance.
 	 */
 	buf = mmap(NULL, 1*MB, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
+	pkey_assert(buf != MAP_FAILED);
 
 	/* These __builtins require compiling with -mxsave */
 
@@ -1680,7 +1681,8 @@ int main(void)
 		ksft_print_msg("running PKEY tests for unsupported CPU/OS\n");
 
 		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-		assert(ptr != (void *)-1);
+		if (ptr == MAP_FAILED)
+			ksft_exit_fail_perror("mmap");
 		test_mprotect_pkey_on_unsupported_cpu(ptr, 1);
 		ksft_test_result_pass("pkey on unsupported CPU/OS\n");
 		ksft_finished();
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc.patch
selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch
selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch
selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch
selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch

