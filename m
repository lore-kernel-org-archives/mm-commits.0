Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF92331209
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465744; cv=none; b=GT/Z+CwFK11JINptlBZzZeLin5aNrd3YX8kYghxLje3bPcEi3XXG2Jk1RT3nqUxjTaIxBI2K/jFCWwxmvf/I3XeTnxSaKk2WzNvkgN3p8L4LgOavl+F9j+9de5g5RnAU4RZstbMxTP7V8vNKagL0Yu9TrN9vPjrd1RpQIJrJOG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465744; c=relaxed/simple;
	bh=dHwydy1CvTKgEIWBlFTc1ZPfQ+sPMXbtOtN/n2FJhoU=;
	h=Date:To:From:Subject:Message-Id; b=Q4YIZHFpTjT22sHP93iKJgD9ziNyM/DPsL1AdsE1dRbd5Haa4gwk9e/kahAvaPdGy4fqlvqifSBq2JwKDYmSt6lg4UnBJJIqY8bF4Yh2tcB8q2CR+UE9pxp0pYuntf1XOLcB7Qm5aTmIrOw+mBiSr3fcXKPaPqsVk9RUeQDZrYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hhAzICmJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hhAzICmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAE61F000E9;
	Fri, 31 Jul 2026 02:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465742;
	bh=WbqkxVUEes0DrkpDA2oSVYWyIawTUc3aKoZKqpkhV4c=;
	h=Date:To:From:Subject;
	b=hhAzICmJDFundfTfJO7ACxHTpMfFhtvl8qCsDimGnFkT9JPWaEWBwhVNW/EXmg23q
	 UypR+6QoUZsVMDuq7780YZG7qPB2dK4tPWloFGtuidftSA5rAMDEA75gtvJeC1LE6k
	 u3SP0pClW915lBk3YN7l2R++FzE90ogZKBsZ3QC8=
Date: Thu, 30 Jul 2026 19:42:21 -0700
To: mm-commits@vger.kernel.org,zwisler@google.com,yury.khrustalev@arm.com,vbabka@kernel.org,usama.anjum@collabora.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kevin.brodsky@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,jhubbard@nvidia.com,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch removed from -mm tree
Message-Id: <20260731024222.4FAE61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: unify pkey sighandler selftest assertions and tracing
has been removed from the -mm tree.  Its filename was
     selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: unify pkey sighandler selftest assertions and tracing
Date: Mon, 6 Jul 2026 16:15:56 +0800

Add per-test tracing to the pkey signal-handler selftest and use
pkey_assert() for error handling.  Each test enables tracing at start and
disables it at end; on failure, pkey_assert() calls abort_hooks() to turn
tracing off so ftrace is not left enabled.

Link: https://lore.kernel.org/20260706081600.3570203-3-lihongfu@kylinos.cn
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

 tools/testing/selftests/mm/pkey_sighandler_tests.c |   89 +++++------
 1 file changed, 44 insertions(+), 45 deletions(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -19,7 +19,6 @@
 #include <stdint.h>
 #include <stdbool.h>
 #include <signal.h>
-#include <assert.h>
 #include <stdlib.h>
 #include <sys/mman.h>
 #include <sys/types.h>
@@ -207,15 +206,14 @@ static void test_sigsegv_handler_with_pk
 	struct sigaction sa;
 	pthread_attr_t attr;
 	pthread_t thr;
+	int ret;
 
 	sa.sa_flags = SA_SIGINFO;
 
 	sa.sa_sigaction = sigsegv_handler;
 	sigemptyset(&sa.sa_mask);
-	if (sigaction(SIGSEGV, &sa, NULL) == -1) {
-		perror("sigaction");
-		exit(EXIT_FAILURE);
-	}
+	ret = sigaction(SIGSEGV, &sa, NULL);
+	pkey_assert(ret == 0);
 
 	memset(&siginfo, 0, sizeof(siginfo));
 
@@ -247,15 +245,14 @@ static void test_sigsegv_handler_cannot_
 	struct sigaction sa;
 	pthread_attr_t attr;
 	pthread_t thr;
+	int ret;
 
 	sa.sa_flags = SA_SIGINFO;
 
 	sa.sa_sigaction = sigsegv_handler;
 	sigemptyset(&sa.sa_mask);
-	if (sigaction(SIGSEGV, &sa, NULL) == -1) {
-		perror("sigaction");
-		exit(EXIT_FAILURE);
-	}
+	ret = sigaction(SIGSEGV, &sa, NULL);
+	pkey_assert(ret == 0);
 
 	memset(&siginfo, 0, sizeof(siginfo));
 
@@ -288,21 +285,20 @@ static void test_sigsegv_handler_with_di
 	int parent_pid = 0;
 	int child_pid = 0;
 	u64 pkey_reg;
+	long ret;
 
 	sa.sa_flags = SA_SIGINFO | SA_ONSTACK;
 
 	sa.sa_sigaction = sigsegv_handler;
 
 	sigemptyset(&sa.sa_mask);
-	if (sigaction(SIGSEGV, &sa, NULL) == -1) {
-		perror("sigaction");
-		exit(EXIT_FAILURE);
-	}
+	ret = sigaction(SIGSEGV, &sa, NULL);
+	pkey_assert(ret == 0);
 
 	stack = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
-	assert(stack != MAP_FAILED);
+	pkey_assert(stack != MAP_FAILED);
 
 	/* Allow access to MPK 0 and MPK 1 */
 	pkey_reg = pkey_reg_restrictive_default();
@@ -323,13 +319,13 @@ static void test_sigsegv_handler_with_di
 	memset(&siginfo, 0, sizeof(siginfo));
 
 	/* Use clone to avoid newer glibcs using rseq on new threads */
-	long ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
-			     CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
-			     CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
-			     CLONE_DETACHED,
-			     stack + STACK_SIZE,
-			     &parent_pid,
-			     &child_pid);
+	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
+			CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
+			CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
+			CLONE_DETACHED,
+			stack + STACK_SIZE,
+			&parent_pid,
+			&child_pid);
 
 	if (ret < 0) {
 		errno = -ret;
@@ -358,6 +354,7 @@ static void test_pkru_preserved_after_si
 {
 	struct sigaction sa;
 	u64 pkey_reg;
+	int ret;
 
 	/* Allow access to MPK 0 and an arbitrary set of keys */
 	pkey_reg = pkey_reg_restrictive_default();
@@ -369,10 +366,8 @@ static void test_pkru_preserved_after_si
 
 	sa.sa_sigaction = sigusr1_handler;
 	sigemptyset(&sa.sa_mask);
-	if (sigaction(SIGUSR1, &sa, NULL) == -1) {
-		perror("sigaction");
-		exit(EXIT_FAILURE);
-	}
+	ret = sigaction(SIGUSR1, &sa, NULL);
+	pkey_assert(ret == 0);
 
 	memset(&siginfo, 0, sizeof(siginfo));
 
@@ -444,6 +439,13 @@ static void test_pkru_sigreturn(void)
 	int parent_pid = 0;
 	int child_pid = 0;
 	u64 pkey_reg;
+	long ret;
+
+	/*
+	 * SIGSEGV handler is reset to SIG_DFL below; turn tracing off first
+	 * so a crash does not leave ftrace enabled.
+	 */
+	tracing_off();
 
 	sa.sa_handler = SIG_DFL;
 	sa.sa_flags = 0;
@@ -453,24 +455,20 @@ static void test_pkru_sigreturn(void)
 	 * For this testcase, we do not want to handle SIGSEGV. Reset handler
 	 * to default so that the application can crash if it receives SIGSEGV.
 	 */
-	if (sigaction(SIGSEGV, &sa, NULL) == -1) {
-		perror("sigaction");
-		exit(EXIT_FAILURE);
-	}
+	ret = sigaction(SIGSEGV, &sa, NULL);
+	pkey_assert(ret == 0);
 
 	sa.sa_flags = SA_SIGINFO | SA_ONSTACK;
 	sa.sa_sigaction = sigusr2_handler;
 	sigemptyset(&sa.sa_mask);
 
-	if (sigaction(SIGUSR2, &sa, NULL) == -1) {
-		perror("sigaction");
-		exit(EXIT_FAILURE);
-	}
+	ret = sigaction(SIGUSR2, &sa, NULL);
+	pkey_assert(ret == 0);
 
 	stack = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
-	assert(stack != MAP_FAILED);
+	pkey_assert(stack != MAP_FAILED);
 
 	/*
 	 * Allow access to MPK 0 and MPK 2. The child thread (to be created
@@ -494,13 +492,13 @@ static void test_pkru_sigreturn(void)
 	sigstack.ss_size = STACK_SIZE;
 
 	/* Use clone to avoid newer glibcs using rseq on new threads */
-	long ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
-			     CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
-			     CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
-			     CLONE_DETACHED,
-			     stack + STACK_SIZE,
-			     &parent_pid,
-			     &child_pid);
+	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
+			CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
+			CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
+			CLONE_DETACHED,
+			stack + STACK_SIZE,
+			&parent_pid,
+			&child_pid);
 
 	if (ret < 0) {
 		errno = -ret;
@@ -530,16 +528,17 @@ static void (*pkey_tests[])(void) = {
 
 int main(int argc, char *argv[])
 {
-	int i;
-
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(pkey_tests));
 
 	if (!is_pkeys_supported())
 		ksft_exit_skip("pkeys not supported\n");
 
-	for (i = 0; i < ARRAY_SIZE(pkey_tests); i++)
-		(*pkey_tests[i])();
+	for (test_nr = 0; test_nr < ARRAY_SIZE(pkey_tests); test_nr++) {
+		tracing_on();
+		(*pkey_tests[test_nr])();
+		tracing_off();
+	}
 
 	ksft_finished();
 	return 0;
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-fix-memleak-in-migration-benchmark.patch
selftests-mm-factor-out-hmm_buffer_alloc-to-consolidate-buffer-setup.patch
selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch

