Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6165733556D
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465750; cv=none; b=Ipui8HywW6nO9U3/voqa3XEQIUQosDWFYQjiq84t6X1kClwJJEJ91ApVHkYbCpAhy6maLcOfxjvy/RQNN+eHxRbEHfg25yMGzBogJoveRtQmCBYgFqVzV7jJJWGirOcaCZ3hDf1Px2dYnMadqUqfI+0sx4MCjCTNeqinfYS1s0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465750; c=relaxed/simple;
	bh=CDoq1goHL4DDL1g7wIdLTj44F2tLU8vOpt5TGfyYHCs=;
	h=Date:To:From:Subject:Message-Id; b=ur10dZ4wELcxJu4kB0aqa0fwQlcMl6FaB/6gmDJ3hfiFhqRZWQDeeDEDFK5nmzMLoYzGQ/6v5K3t4TzLRkZFevMclm4Bh3ttWrSoF+iGW8+B8f91BP5gfM0nazHqOzxqUOtBduA2VvHvimkEpYM079DRU/jxjdGeJ3s4zpKLLZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VkpbK6Tr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VkpbK6Tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96121F00A3A;
	Fri, 31 Jul 2026 02:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465749;
	bh=3XJYjF3XZNTq1aWDbsMpny5YU6xywHtHKIgR3QWShok=;
	h=Date:To:From:Subject;
	b=VkpbK6Trmod6TW2X1DInQgs/Rd/k0N+3KTndot6Fs6Gog9QbNAodwR37T7RgHkRoe
	 OozQqUBEp2pwJuZAhq1RwzOydJNVyV8qaJuap2A8WwdFwX7eKAStF04/KHajW9XdAe
	 KCED59utvTzWtnxGYX4leMc+SWl0xabW1EvDxVcs=
Date: Thu, 30 Jul 2026 19:42:28 -0700
To: mm-commits@vger.kernel.org,zwisler@google.com,yury.khrustalev@arm.com,vbabka@kernel.org,usama.anjum@collabora.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kevin.brodsky@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,jhubbard@nvidia.com,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-clone-cleartid-race-in-pkey-sighandler-tests.patch removed from -mm tree
Message-Id: <20260731024228.E96121F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix clone cleartid race in pkey sighandler tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-clone-cleartid-race-in-pkey-sighandler-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-fix-memleak-in-migration-benchmark.patch
selftests-mm-factor-out-hmm_buffer_alloc-to-consolidate-buffer-setup.patch
selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch

