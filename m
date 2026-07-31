Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3052331EDF
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465747; cv=none; b=MB1zwj0ciCRQAFylSa2+ZQQWIZLzBLSMFJ5zqJE32587SY6qzeFEE8+cZhEbFAFcoDQfy+ysJ9yj/7PDCTwFWa17g5CWSLvbycb3TL0ZVV5J8cCI1KEb8OKVPBex/7hAA6NgvTHjdURwimCZnH8CugHIRi03HeKPysSHTVCAsAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465747; c=relaxed/simple;
	bh=UmpmH8P3Qlkfjfh40ngsvoh26MeUOAjYMndgN/qtBfU=;
	h=Date:To:From:Subject:Message-Id; b=qhqQpzIBZd3jdjZKkjrh8hlU8vHADrtNPTOKbr+L3bT4yIoT8VyYjeJYT9bMBXVqiMoh1FeStjeS5L3NnIc+I8DTewu4ElFLScdgZeleGqH8pzkXhqmIKYIdM/jjn+4MhES5v8QgpQZzRhgN/9zdVRjwlSmi/CAGMd+aaWWjHIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f6AwekLC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f6AwekLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5F11F00A3A;
	Fri, 31 Jul 2026 02:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465745;
	bh=rmD3vX3+crR6w5aU4AgWhTVADbSEXuJh610+J1PGJLQ=;
	h=Date:To:From:Subject;
	b=f6AwekLCbS8p+4p666JA2SSnJFk6yyxKqWDduNctj3SmDIz6jZ+A3leVBhMInoBaq
	 pFl0K3AMKO5ICULMUmqUUxYUFKsz4cKMx9dQ6JQPo4hxtlwZbJ8IHTVC5bmaQ6gD2Q
	 Qu4I1NruBc5cV5qWMbeGVbsiclH8mS8KbuvhPc6w=
Date: Thu, 30 Jul 2026 19:42:25 -0700
To: mm-commits@vger.kernel.org,zwisler@google.com,yury.khrustalev@arm.com,vbabka@kernel.org,usama.anjum@collabora.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kevin.brodsky@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,jhubbard@nvidia.com,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch removed from -mm tree
Message-Id: <20260731024225.7F5F11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add missing mmap() return checks in pkey tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: add missing mmap() return checks in pkey tests
Date: Mon, 6 Jul 2026 16:15:58 +0800

Add missing checks against mmap() return value, replace (void *)-1 with
MAP_FAILED for better readability and consistency.

Link: https://lore.kernel.org/20260706081600.3570203-5-lihongfu@kylinos.cn
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
@@ -313,6 +313,7 @@ static void test_sigsegv_handler_with_di
 	/* Set up alternate signal stack that will use the default MPK */
 	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	pkey_assert(sigstack.ss_sp != MAP_FAILED);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
 
@@ -488,6 +489,7 @@ static void test_pkru_sigreturn(void)
 	/* Set up alternate signal stack that will use the default MPK */
 	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	pkey_assert(sigstack.ss_sp != MAP_FAILED);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
 
--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-add-missing-mmap-return-checks-in-pkey-tests
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -582,7 +582,7 @@ static void *malloc_pkey_with_mprotect(l
 			size, prot, pkey);
 	pkey_assert(pkey < NR_PKEYS);
 	ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 	ret = mprotect_pkey((void *)ptr, PAGE_SIZE, prot, pkey);
 	pkey_assert(!ret);
 	record_pkey_malloc(ptr, size, prot);
@@ -605,7 +605,7 @@ static void *malloc_pkey_anon_huge(long
 	 */
 	size = ALIGN_UP(size, HPAGE_SIZE * 2);
 	ptr = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 	record_pkey_malloc(ptr, size, prot);
 	mprotect_pkey(ptr, size, prot, pkey);
 
@@ -663,7 +663,7 @@ static void *malloc_pkey_hugetlb(long si
 	size = ALIGN_UP(size, HPAGE_SIZE * 2);
 	pkey_assert(pkey < NR_PKEYS);
 	ptr = mmap(NULL, size, PROT_NONE, flags, -1, 0);
-	pkey_assert(ptr != (void *)-1);
+	pkey_assert(ptr != MAP_FAILED);
 	mprotect_pkey(ptr, size, prot, pkey);
 
 	record_pkey_malloc(ptr, size, prot);
@@ -692,7 +692,7 @@ static void *malloc_pkey(long size, int
 		pkey_assert(malloc_type < nr_malloc_types);
 
 		ret = pkey_malloc[malloc_type](size, prot, pkey);
-		pkey_assert(ret != (void *)-1);
+		pkey_assert(ret != MAP_FAILED);
 
 		malloc_type++;
 		if (malloc_type >= nr_malloc_types)
@@ -1110,6 +1110,7 @@ static void arch_force_pkey_reg_init(voi
 	 * doing the XSAVE size enumeration dance.
 	 */
 	buf = mmap(NULL, 1*MB, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
+	pkey_assert(buf != MAP_FAILED);
 
 	/* These __builtins require compiling with -mxsave */
 
@@ -1676,7 +1677,8 @@ int main(void)
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

selftests-mm-fix-memleak-in-migration-benchmark.patch
selftests-mm-factor-out-hmm_buffer_alloc-to-consolidate-buffer-setup.patch
selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch

