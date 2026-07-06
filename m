Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0983F888C
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 23:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783380552; cv=none; b=sOldZcSFy8vbMKBtFQtsiZqNZ4lM3SXdsQeNrvjrQSz/synomXOT3DnObpTzAlpR51OCb9yqNGB05kL36u7Vs1tX00Mq/DMJ73JHkLGEd/6fmVJbOkTONlvdSwoUa6LgT/KanKT/T77tJCIg1sYxo9tUqLbtDmYtCQpcVee+UYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783380552; c=relaxed/simple;
	bh=RXRGuxqEIwqhATpS0yjdkKqfmiqdjM0uL4Gw/KcyGcM=;
	h=Date:To:From:Subject:Message-Id; b=HlKv/HtkbcftVO5aTtkdp1yR53MPjYEJEWiE0NKnlrKzF5fRrOyDzP1wpo0S3srPdEmeHBF9sGCurTJ74h7eKAG2cIypyMWPjdcro7zg1ctTa9D1YwAOMPnfqnziNW3neWcVilcJOBjZ+I+7WHWe/AmrEUou+Yell9GatDvmKnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qCIZX057; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qCIZX057"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC97A1F000E9;
	Mon,  6 Jul 2026 23:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783380551;
	bh=6iKo0ORevHFCvupQvsb5KooswJYu9dRc1EkF7hpyGLc=;
	h=Date:To:From:Subject;
	b=qCIZX057Dmwl/Npq8Vpn/U3cc2n8jvrZEhcoeqop8wXxkSb+MYjt86T08ec6p845W
	 LKpw+Wt6MoaFrB/CnE056obMAKY3WpHtBGcQ4e+4pexmrupiYe0n8RzyjcJOQw5ulo
	 S70Y11eRRPfc9XA6Ey2bUs/b6LYJDOkRJP3D3wtk=
Date: Mon, 06 Jul 2026 16:29:10 -0700
To: mm-commits@vger.kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-clone-cleartid-race-in-pkey-sighandler-tests.patch added to mm-unstable branch
Message-Id: <20260706232910.EC97A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix clone cleartid race in pkey sighandler tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-clone-cleartid-race-in-pkey-sighandler-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-clone-cleartid-race-in-pkey-sighandler-tests.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: selftests/mm: fix clone cleartid race in pkey sighandler tests
Date: Mon, 6 Jul 2026 16:16:00 +0800

Passing a stack-local child_pid to clone() with CLONE_CHILD_CLEARTID is
unsafe: the kernel clears that address when the child exits, which may
happen after the test function has returned and the stack slot has been
reused.

Neither testcase uses the settid/cleartid pointers for synchronization.

Drop CLONE_PARENT_SETTID and CLONE_CHILD_CLEARTID and pass NULL for the
clone tid arguments.  Wait for the clone child to exit via tkill in
test_sigsegv_handler_with_different_pkey_for_stack(), matching
test_pkru_sigreturn(), so the detached thread cannot overlap with the next
testcase.

Link: https://lore.kernel.org/20260706081600.3570203-7-lihongfu@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Cc: David Hildenbrand <david@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ross Zwisler <zwisler@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yury Khrustalev <yury.khrustalev@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey_sighandler_tests.c |   20 ++++++-----
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-fix-clone-cleartid-race-in-pkey-sighandler-tests
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -290,7 +290,6 @@ static void test_sigsegv_handler_with_di
 	static stack_t sigstack;
 	void *stack;
 	int pkey;
-	int parent_pid = 0;
 	int child_pid = 0;
 	u64 pkey_reg;
 	long ret;
@@ -330,11 +329,10 @@ static void test_sigsegv_handler_with_di
 	/* Use clone to avoid newer glibcs using rseq on new threads */
 	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
 			CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
-			CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
 			CLONE_DETACHED,
 			stack + STACK_SIZE,
-			&parent_pid,
-			&child_pid);
+			NULL,
+			NULL);
 
 	if (ret < 0) {
 		errno = -ret;
@@ -344,11 +342,19 @@ static void test_sigsegv_handler_with_di
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
 	}
 
+	child_pid = ret;
+
 	pthread_mutex_lock(&mutex);
 	while (siginfo.si_signo == 0)
 		pthread_cond_wait(&cond, &mutex);
 	pthread_mutex_unlock(&mutex);
 
+	/* Wait for child to exit before returning */
+	do {
+		sched_yield();
+		ret = syscall_raw(SYS_tkill, child_pid, 0, 0, 0, 0, 0);
+	} while (ret != -ESRCH && ret != -EINVAL);
+
 	ksft_test_result(siginfo.si_signo == SIGSEGV &&
 			 siginfo.si_code == SEGV_MAPERR &&
 			 siginfo.si_addr == NULL,
@@ -445,7 +451,6 @@ static void test_pkru_sigreturn(void)
 	static stack_t sigstack;
 	void *stack;
 	int pkey;
-	int parent_pid = 0;
 	int child_pid = 0;
 	u64 pkey_reg;
 	long ret;
@@ -504,11 +509,10 @@ static void test_pkru_sigreturn(void)
 	/* Use clone to avoid newer glibcs using rseq on new threads */
 	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
 			CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
-			CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
 			CLONE_DETACHED,
 			stack + STACK_SIZE,
-			&parent_pid,
-			&child_pid);
+			NULL,
+			NULL);
 
 	if (ret < 0) {
 		errno = -ret;
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc.patch
selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch
selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch
selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch
selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch
selftests-mm-fix-clone-cleartid-race-in-pkey-sighandler-tests.patch

