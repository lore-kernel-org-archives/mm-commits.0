Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0E3307492
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 05:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782883252; cv=none; b=mmwIAUHAKJgLm4hN3fAE+CALbQGK+gGypsE7xdWtXUjD8MifJEvN03LYjKyA/op9Yko15+LE/67k2+uNPhChuidhupjV+ued9H7SSyV6VrddKrI6vR39fZ8BHQsIihdz/SpknirtdCJLLgnm2RJEef5S5h/zOsQtuDZ+SpKmHFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782883252; c=relaxed/simple;
	bh=zTcEiHQgp4UZ+EvkATj028FYWx7Oz/6CG8H89W8Elg0=;
	h=Date:To:From:Subject:Message-Id; b=Gy3EkMgdpbbpK0m4BeFpXACz0A4AqL37ghUUxRzt6+IEHDq0zc1lsroaqrk1hr8iMvwXf3cdJO5Z+cwxXY6LaFqyvsfK++qtBsH7UTvm9glnARIoBHQqb4eGNKCezb0/t83a1j1r4mWx1XAQe4DtRdfIKCtb3ZyExXdDUOSb5lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uiv5BHDq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uiv5BHDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E825B1F000E9;
	Wed,  1 Jul 2026 05:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782883251;
	bh=P1gnpXB7a6cgQK6m58drBWfeQFQDGiv3MBKMUsPsDBM=;
	h=Date:To:From:Subject;
	b=uiv5BHDqU+Jf0ANOq8aMJJGjsGfEcnyBhjz5iWy3QqTzpD8lXwINV7eEqpzGcOK1d
	 NNPRAK73iSszvfhxC4GxILiAsBAs2ovxTVDXmNcv74qdqfMmrIHf4ERTxVH3sH8I5Q
	 uqeTSjKI8FzcyuAVG9ImqK5XaxzzH4sUyTycpUy4=
Date: Tue, 30 Jun 2026 22:20:50 -0700
To: mm-commits@vger.kernel.org,zwisler@google.com,yury.khrustalev@arm.com,vbabka@kernel.org,usama.anjum@collabora.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,kevin.brodsky@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,jhubbard@nvidia.com,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch added to mm-new branch
Message-Id: <20260701052050.E825B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: unify pkey sighandler selftest assertions and tracing
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch

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
Subject: selftests/mm: unify pkey sighandler selftest assertions and tracing
Date: Tue, 30 Jun 2026 15:32:32 +0800

Add per-test tracing to the pkey signal-handler selftest and use
pkey_assert() for error handling.  Each test enables tracing at start and
disables it at end; on failure, pkey_assert() calls abort_hooks() to turn
tracing off so ftrace is not left enabled.

Link: https://lore.kernel.org/20260630073235.3802271-3-lihongfu@kylinos.cn
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

 tools/testing/selftests/mm/pkey_sighandler_tests.c |   69 +++++------
 1 file changed, 36 insertions(+), 33 deletions(-)

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
@@ -36,6 +35,10 @@ static pthread_mutex_t mutex = PTHREAD_M
 static pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
 static siginfo_t siginfo = {0};
 
+int iteration_nr = 1;
+int test_nr;
+int dprint_in_signal;
+
 /*
  * We need to use inline assembly instead of glibc's syscall because glibc's
  * syscall will attempt to access the PLT in order to call a library function
@@ -207,15 +210,14 @@ static void test_sigsegv_handler_with_pk
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
 
@@ -247,15 +249,14 @@ static void test_sigsegv_handler_cannot_
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
 
@@ -288,21 +289,20 @@ static void test_sigsegv_handler_with_di
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
@@ -323,7 +323,7 @@ static void test_sigsegv_handler_with_di
 	memset(&siginfo, 0, sizeof(siginfo));
 
 	/* Use clone to avoid newer glibcs using rseq on new threads */
-	long ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
+	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
 			     CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
 			     CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
 			     CLONE_DETACHED,
@@ -358,6 +358,7 @@ static void test_pkru_preserved_after_si
 {
 	struct sigaction sa;
 	u64 pkey_reg;
+	int ret;
 
 	/* Allow access to MPK 0 and an arbitrary set of keys */
 	pkey_reg = pkey_reg_restrictive_default();
@@ -369,10 +370,8 @@ static void test_pkru_preserved_after_si
 
 	sa.sa_sigaction = sigusr1_handler;
 	sigemptyset(&sa.sa_mask);
-	if (sigaction(SIGUSR1, &sa, NULL) == -1) {
-		perror("sigaction");
-		exit(EXIT_FAILURE);
-	}
+	ret = sigaction(SIGUSR1, &sa, NULL);
+	pkey_assert(ret == 0);
 
 	memset(&siginfo, 0, sizeof(siginfo));
 
@@ -444,6 +443,13 @@ static void test_pkru_sigreturn(void)
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
@@ -453,24 +459,20 @@ static void test_pkru_sigreturn(void)
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
@@ -494,7 +496,7 @@ static void test_pkru_sigreturn(void)
 	sigstack.ss_size = STACK_SIZE;
 
 	/* Use clone to avoid newer glibcs using rseq on new threads */
-	long ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
+	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
 			     CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
 			     CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
 			     CLONE_DETACHED,
@@ -530,16 +532,17 @@ static void (*pkey_tests[])(void) = {
 
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

selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc.patch
selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch
selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch
selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch
selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch

