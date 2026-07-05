Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741D12DFA4A
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 20:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783284222; cv=none; b=YTpR3BqFaD7KCOGdvPEICAgQYMK62ROYx941i9YJZOXQcvilFZyUHQgPGlAD2tXGUIzkXO6K+RYjuOI7hyMcrdwvrJYHRTQFe9WzYJbfwk3wp2lUvxU1pIYalJqcuu9UHMUpyoQdSVS7hyzuSucpfLWfiGGaHLf1nAfribl0PcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783284222; c=relaxed/simple;
	bh=4wSkFyvVbEVDFcVv/zO2c4WKEhDI85EKNqYOHxHDVOo=;
	h=Date:To:From:Subject:Message-Id; b=PMi4VUi4KI862N4iaixGVtFLOQFGU5wgVPeBxAeXmk+1vXjZGpgpOAdRjCb590laVadJbphU6DVM1Rgt5x6weDyYjFTmBatmrqkGhYYqpOjmP1AUhUHqQkFoVxBXh2LoBUwkNsfZ0LNbxf8kDsDWBTvknKgnENDOdd+SlePTzVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vMjbisD3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vMjbisD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF081F00A3A;
	Sun,  5 Jul 2026 20:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783284221;
	bh=3m6jtlu7NxZivF22QJabIsg1HrQ8N2Hf3gcyNs5U6rA=;
	h=Date:To:From:Subject;
	b=vMjbisD3ZKObixgrp1GxLugdRSRfxaiy7XED4epRHlDzNAN34ClCN+iecPuSD4RIQ
	 DTB7GoXGA0b7o6FazDhqPCSt5134HdrEAPhRRJv/tyy7g2+cReF1rWKEOIAw4TglK2
	 MaI+sjBfPIO5/oDJIX/z8qi8Em54wKXuGtXmRYB0=
Date: Sun, 05 Jul 2026 13:43:40 -0700
To: mm-commits@vger.kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch removed from -mm tree
Message-Id: <20260705204341.2FF081F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add missing mmap() return checks in pkey tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch

This patch was dropped because an updated version will be issued

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

selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch

