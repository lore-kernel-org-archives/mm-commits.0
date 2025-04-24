Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217A71F1520
	for <mm-commits@vger.kernel.org>; Thu, 24 Apr 2025 23:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745537604; cv=none; b=JPrJWIR/71zsrsjPyDhGOYFkh/P6u3WG+gSLUXq/haU7uz0h7W6Zlzr4do2sqv3+LIrjsOU3xcmieiIWqOe8JcHQgh/H1WSrnCb0BJ4+2D6Sl2Q5XHFOmVOZ4BcL+a0quGpxeR5Fs3cDE2dDUayfHOix6COVnGehIweQ+OTYwmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745537604; c=relaxed/simple;
	bh=/WU5ojVPpYuQfXY+bN3WJ5mzR0wIfU6uH8IttZALLaQ=;
	h=Date:To:From:Subject:Message-Id; b=hrq7VQUuRArs1vl5OCIIf5ef2Z0sC3rsf+eEO3yNIErDTkJlsVINsKDh3UrCoBscEJVDMiBhPd/Y3lxuDN8wQ2SYWM7AURtwVB8Z1w/h27jC0uI67F1DVdPJDHKP4kf5Hou9yjtsvOEL5ByJfBWsX8B/Q99LuJ65aJnsTdAkbk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=enFC5X7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="enFC5X7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C324C4CEE3;
	Thu, 24 Apr 2025 23:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745537603;
	bh=/WU5ojVPpYuQfXY+bN3WJ5mzR0wIfU6uH8IttZALLaQ=;
	h=Date:To:From:Subject:From;
	b=enFC5X7tTXxZwU7IK/KZnHbXA5hBNKnI5bcLVjeUgODUxPpXtmGWOHFw6Vf9tdeT6
	 LOenrXYncJwFkUpD7TQRUf6c4RRElS/3Np4MV1dXEJmL870EKVg5xF/7lzbpy362T/
	 1z5UcOVzw4oAUGe4ImdtWV6ZDMK/P/dyWBnV6WE4=
Date: Thu, 24 Apr 2025 16:33:22 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,axelrasmussen@google.com,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain.patch added to mm-new branch
Message-Id: <20250424233323.6C324C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/selftests: add a test to verify mmap_changing race with -EAGAIN
has been added to the -mm mm-new branch.  Its filename is
     mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/selftests: add a test to verify mmap_changing race with -EAGAIN
Date: Thu, 24 Apr 2025 17:57:29 -0400

Add an unit test to verify the recent mmap_changing ABI breakage.

Note that I used some tricks here and there to make the test simple, e.g. 
I abused UFFDIO_MOVE on top of shmem with the fact that I know what I want
to test will be even earlier than the vma type check.  Rich comments were
added to explain trivial details.

Before that fix, -EAGAIN would have been written to the copy field most of
the time but not always; the test should be able to reliably trigger the
outlier case.  After the fix, it's written always, the test verifies that
making sure corresponding field (e.g.  copy.copy for UFFDIO_COPY) is
updated.

Link: https://lkml.kernel.org/r/20250424215729.194656-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |  203 +++++++++++++++++
 1 file changed, 203 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1231,6 +1231,183 @@ static void uffd_move_pmd_split_test(uff
 			      uffd_move_pmd_handle_fault);
 }
 
+static bool
+uffdio_verify_results(const char *name, int ret, int error, long result)
+{
+	/*
+	 * Should always return -1 with errno=EAGAIN, with corresponding
+	 * result field updated in ioctl() args to be -EAGAIN too
+	 * (e.g. copy.copy field for UFFDIO_COPY).
+	 */
+	if (ret != -1) {
+		uffd_test_fail("%s should have returned -1", name);
+		return false;
+	}
+
+	if (error != EAGAIN) {
+		uffd_test_fail("%s should have errno==EAGAIN", name);
+		return false;
+	}
+
+	if (result != -EAGAIN) {
+		uffd_test_fail("%s should have been updated for -EAGAIN",
+			       name);
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * This defines a function to test one ioctl.  Note that here "field" can
+ * be 1 or anything not -EAGAIN.  With that initial value set, we can
+ * verify later that it should be updated by kernel (when -EAGAIN
+ * returned), by checking whether it is also updated to -EAGAIN.
+ */
+#define DEFINE_MMAP_CHANGING_TEST(name, ioctl_name, field)		\
+	static bool uffdio_mmap_changing_test_##name(int fd)		\
+	{								\
+		int ret;						\
+		struct uffdio_##name args = {				\
+			.field = 1,					\
+		};							\
+		ret = ioctl(fd, ioctl_name, &args);			\
+		return uffdio_verify_results(#ioctl_name, ret, errno, args.field); \
+	}
+
+DEFINE_MMAP_CHANGING_TEST(zeropage, UFFDIO_ZEROPAGE, zeropage)
+DEFINE_MMAP_CHANGING_TEST(copy, UFFDIO_COPY, copy)
+DEFINE_MMAP_CHANGING_TEST(move, UFFDIO_MOVE, move)
+DEFINE_MMAP_CHANGING_TEST(poison, UFFDIO_POISON, updated)
+DEFINE_MMAP_CHANGING_TEST(continue, UFFDIO_CONTINUE, mapped)
+
+typedef enum {
+	/* We actually do not care about any state except UNINTERRUPTIBLE.. */
+	THR_STATE_UNKNOWN = 0,
+	THR_STATE_UNINTERRUPTIBLE,
+} thread_state;
+
+static void sleep_short(void)
+{
+	usleep(1000);
+}
+
+static thread_state thread_state_get(pid_t tid)
+{
+	const char *header = "State:\t";
+	char tmp[256], *p, c;
+	FILE *fp;
+
+	snprintf(tmp, sizeof(tmp), "/proc/%d/status", tid);
+	fp = fopen(tmp, "r");
+
+	if (!fp) {
+		return THR_STATE_UNKNOWN;
+	}
+
+	while (fgets(tmp, sizeof(tmp), fp)) {
+		p = strstr(tmp, header);
+		if (p) {
+			/* For example, "State:\tD (disk sleep)" */
+			c = *(p + sizeof(header) - 1);
+			return c == 'D' ?
+			    THR_STATE_UNINTERRUPTIBLE : THR_STATE_UNKNOWN;
+		}
+	}
+
+	return THR_STATE_UNKNOWN;
+}
+
+static void thread_state_until(pid_t tid, thread_state state)
+{
+	thread_state s;
+
+	do {
+		s = thread_state_get(tid);
+		sleep_short();
+	} while (s != state);
+}
+
+static void *uffd_mmap_changing_thread(void *opaque)
+{
+	volatile pid_t *pid = opaque;
+	int ret;
+
+	/* Unfortunately, it's only fetch-able from the thread itself.. */
+	assert(*pid == 0);
+	*pid = syscall(SYS_gettid);
+
+	/* Inject an event, this will hang solid until the event read */
+	ret = madvise(area_dst, page_size, MADV_REMOVE);
+	if (ret)
+		err("madvise(MADV_REMOVE) failed");
+
+	return NULL;
+}
+
+static void uffd_consume_message(int fd)
+{
+	struct uffd_msg msg = { 0 };
+
+	while (uffd_read_msg(fd, &msg));
+}
+
+static void uffd_mmap_changing_test(uffd_test_args_t *targs)
+{
+	/*
+	 * This stores the real PID (which can be different from how tid is
+	 * defined..) for the child thread, 0 means not initialized.
+	 */
+	pid_t pid = 0;
+	pthread_t tid;
+	int ret;
+
+	if (uffd_register(uffd, area_dst, nr_pages * page_size,
+			  true, false, false))
+		err("uffd_register() failed");
+
+	/* Create a thread to generate the racy event */
+	ret = pthread_create(&tid, NULL, uffd_mmap_changing_thread, &pid);
+	if (ret)
+		err("pthread_create() failed");
+
+	/*
+	 * Wait until the thread setup the pid.  Use volatile to make sure
+	 * it reads from RAM not regs.
+	 */
+	while (!(volatile pid_t)pid)
+		sleep_short();
+
+	/* Wait until the thread hangs at REMOVE event */
+	thread_state_until(pid, THR_STATE_UNINTERRUPTIBLE);
+
+	if (!uffdio_mmap_changing_test_copy(uffd))
+		return;
+
+	if (!uffdio_mmap_changing_test_zeropage(uffd))
+		return;
+
+	if (!uffdio_mmap_changing_test_move(uffd))
+		return;
+
+	if (!uffdio_mmap_changing_test_poison(uffd))
+		return;
+
+	if (!uffdio_mmap_changing_test_continue(uffd))
+		return;
+
+	/*
+	 * All succeeded above!  Recycle everything.  Start by reading the
+	 * event so as to kick the thread roll again..
+	 */
+	uffd_consume_message(uffd);
+
+	ret = pthread_join(tid, NULL);
+	assert(ret == 0);
+
+	uffd_test_pass();
+}
+
 static int prevent_hugepages(const char **errmsg)
 {
 	/* This should be done before source area is populated */
@@ -1470,6 +1647,32 @@ uffd_test_case_t uffd_tests[] = {
 		.mem_targets = MEM_ALL,
 		.uffd_feature_required = UFFD_FEATURE_POISON,
 	},
+	{
+		.name = "mmap-changing",
+		.uffd_fn = uffd_mmap_changing_test,
+		/*
+		 * There's no point running this test over all mem types as
+		 * they share the same code paths.
+		 *
+		 * Choose shmem for simplicity, because (1) shmem supports
+		 * MINOR mode to cover UFFDIO_CONTINUE, and (2) shmem is
+		 * almost always available (unlike hugetlb).  Here we
+		 * abused SHMEM for UFFDIO_MOVE, but the test we want to
+		 * cover doesn't yet need the correct memory type..
+		 */
+		.mem_targets = MEM_SHMEM,
+		/*
+		 * Any UFFD_FEATURE_EVENT_* should work to trigger the
+		 * race logically, but choose the simplest (REMOVE).
+		 *
+		 * Meanwhile, since we'll cover quite a few new ioctl()s
+		 * (CONTINUE, POISON, MOVE), skip this test for old kernels
+		 * by choosing all of them.
+		 */
+		.uffd_feature_required = UFFD_FEATURE_EVENT_REMOVE |
+		UFFD_FEATURE_MOVE | UFFD_FEATURE_POISON |
+		UFFD_FEATURE_MINOR_SHMEM,
+	},
 };
 
 static void usage(const char *prog)
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-fix-uninitialized-output-field-for-eagain-race.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain.patch

