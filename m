Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006511CD30
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711477094; cv=none; b=JyMsCNukyzQwuv950Zz7bhhf6QCLhjkSq1bwesycDs0Oo6M89bRftA+1B4IlAWeAkQWK6IsQdQberHe2f1hGxm6mcPLT7qOo/xQFH5MyVJSPsQYc0+zmZ3js7reNwD07u330BFiO27OsnL/ezs26/bK2RKvFgxFc4XuPeYYaiQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711477094; c=relaxed/simple;
	bh=Mfq5bQz7Qbz4Ul/ty17RKaJIp8GJWJypqRLj8rPYhew=;
	h=Date:To:From:Subject:Message-Id; b=KQcIaV8vNJze/Th2pjI6SrwBfY6+uwmw646JBNt8FXWwAL69/IGy9Q0BG9aDj8ClR/24uIn+GThPXca2mkKGWnYmr6+YbIJ8mTOhgHm0lBKf6S999BCi5pseHdlurfB+w4zYx4N1wcTcqBGJLpx6ojdv9QVdK8ap0bUiWCWDzI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S243e1x2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S243e1x2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D992C433F1;
	Tue, 26 Mar 2024 18:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711477093;
	bh=Mfq5bQz7Qbz4Ul/ty17RKaJIp8GJWJypqRLj8rPYhew=;
	h=Date:To:From:Subject:From;
	b=S243e1x2Ci+lVCmwSY6jt3RjjMPybYJ/CeYOTstqKXsiD0I2Ll/WG3wDvUdTJBtVB
	 In+aHE7eNXS52gZCgws6LCWjRtZXIClWPI6V5ACnF8fZCIrTPOj/JcSlx+MUyYAHqt
	 ihvTHD9cFvzFwu5/vzhYYikaS+ITOAgwTwE4R90w=
Date: Tue, 26 Mar 2024 11:18:12 -0700
To: mm-commits@vger.kernel.org,xrivendell7@gmail.com,samsun1006219@gmail.com,rppt@kernel.org,mszeredi@redhat.com,lstoakes@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memfd_secret-add-vmsplice-test.patch added to mm-unstable branch
Message-Id: <20240326181813.6D992C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/memfd_secret: add vmsplice() test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-memfd_secret-add-vmsplice-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memfd_secret-add-vmsplice-test.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: David Hildenbrand <david@redhat.com>
Subject: selftests/memfd_secret: add vmsplice() test
Date: Tue, 26 Mar 2024 15:32:09 +0100

Let's add a simple reproducer for a scenario where GUP-fast could succeed
on secretmem folios, making vmsplice() succeed instead of failing.  The
reproducer is based on a reproducer [1] by Miklos Szeredi.

We want to perform two tests: vmsplice() when a fresh page was just
faulted in, and vmsplice() on an existing page after munmap() that would
drain certain LRU caches/batches in the kernel.

In an ideal world, we could use fallocate(FALLOC_FL_PUNCH_HOLE) /
MADV_REMOVE to remove any existing page.  As that is currently not
possible, run the test before any other tests that would allocate memory
in the secretmem fd.

Perform the ftruncate() only once, and check the return value.

[1] https://lkml.kernel.org/r/CAJfpegt3UCsMmxd0taOY11Uaw5U=eS1fE5dn0wZX3HF0oy8-oQ@mail.gmail.com

Link: https://lkml.kernel.org/r/20240326143210.291116-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: xingwei lee <xrivendell7@gmail.com>
Cc: yue sun <samsun1006219@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/memfd_secret.c |   51 +++++++++++++++++++-
 1 file changed, 49 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/memfd_secret.c~selftests-memfd_secret-add-vmsplice-test
+++ a/tools/testing/selftests/mm/memfd_secret.c
@@ -20,6 +20,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <stdio.h>
+#include <fcntl.h>
 
 #include "../kselftest.h"
 
@@ -83,6 +84,45 @@ static void test_mlock_limit(int fd)
 	pass("mlock limit is respected\n");
 }
 
+static void test_vmsplice(int fd, const char *desc)
+{
+	ssize_t transferred;
+	struct iovec iov;
+	int pipefd[2];
+	char *mem;
+
+	if (pipe(pipefd)) {
+		fail("pipe failed: %s\n", strerror(errno));
+		return;
+	}
+
+	mem = mmap(NULL, page_size, prot, mode, fd, 0);
+	if (mem == MAP_FAILED) {
+		fail("Unable to mmap secret memory\n");
+		goto close_pipe;
+	}
+
+	/*
+	 * vmsplice() may use GUP-fast, which must also fail. Prefault the
+	 * page table, so GUP-fast could find it.
+	 */
+	memset(mem, PATTERN, page_size);
+
+	iov.iov_base = mem;
+	iov.iov_len = page_size;
+	transferred = vmsplice(pipefd[1], &iov, 1, 0);
+
+	if (transferred < 0 && errno == EFAULT)
+		pass("vmsplice is blocked as expected with %s\n", desc);
+	else
+		fail("vmsplice: unexpected memory access with %s\n", desc);
+
+	munmap(mem, page_size);
+close_pipe:
+	close(pipefd[0]);
+	close(pipefd[1]);
+}
+
 static void try_process_vm_read(int fd, int pipefd[2])
 {
 	struct iovec liov, riov;
@@ -187,7 +227,6 @@ static void test_remote_access(int fd, c
 		return;
 	}
 
-	ftruncate(fd, page_size);
 	memset(mem, PATTERN, page_size);
 
 	if (write(pipefd[1], &mem, sizeof(mem)) < 0) {
@@ -258,7 +297,7 @@ static void prepare(void)
 				   strerror(errno));
 }
 
-#define NUM_TESTS 4
+#define NUM_TESTS 6
 
 int main(int argc, char *argv[])
 {
@@ -277,9 +316,17 @@ int main(int argc, char *argv[])
 			ksft_exit_fail_msg("memfd_secret failed: %s\n",
 					   strerror(errno));
 	}
+	if (ftruncate(fd, page_size))
+		ksft_exit_fail_msg("ftruncate failed: %s\n", strerror(errno));
 
 	test_mlock_limit(fd);
 	test_file_apis(fd);
+	/*
+	 * We have to run the first vmsplice test before any secretmem page was
+	 * allocated for this fd.
+	 */
+	test_vmsplice(fd, "fresh page");
+	test_vmsplice(fd, "existing page");
 	test_process_vm_read(fd);
 	test_ptrace(fd);
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch
mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch

