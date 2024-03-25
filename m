Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA3310962
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 18:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711391343; cv=none; b=KHd1ArYw6DI8HgVpz4j8qi6DIYXsPiTP+vGJv1XnYLjtlIZqaIpbqXTzOS4apLKBMNCmW11ahbLZaNEL522sT7lpPNHaJ1TLjlQquAuS8F03XkdO84MxWQ62V3G5XIzSTEtHT4uYqX4Y/xapo1qHllVLJIs8JYxguZOr7/9Kcs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711391343; c=relaxed/simple;
	bh=JcUq0dJat6AGxHO1gr/JQr4B+A992I9Kbcs5vMoU5r4=;
	h=Date:To:From:Subject:Message-Id; b=AWH9FbF71R++mGiFTaLJoZbycZeOgxUi9upwqjyDuoJq66jwE+UCeQaVdiWoyC5l1To34R1dsinsDcEZUsX3ZH5uk6zgguSU4qEpcIG+xZWeZ0uRD9rXmRwCSlF7UJp1rFBHiU9ghTOdv/m7BmkuaNwr0coXBFHfLSj0MXyA8dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=unvz6mgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="unvz6mgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F211FC433C7;
	Mon, 25 Mar 2024 18:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711391343;
	bh=JcUq0dJat6AGxHO1gr/JQr4B+A992I9Kbcs5vMoU5r4=;
	h=Date:To:From:Subject:From;
	b=unvz6mgP/b6JtA9cxteDaZ8ovV+2A0cBQ1UVAx4evO0o5CKovzfA1UOgwuawAARnR
	 HCIkQyGQo6vkNf/bYea7hu6lvSv5FeA1HXpRsWR5wOqBFar+a4UGftwlbc4acm321x
	 wXPxec+W2slMKvKQZDB3YcX1DmD+sCdlZQymUP0k=
Date: Mon, 25 Mar 2024 11:29:02 -0700
To: mm-commits@vger.kernel.org,xrivendell7@gmail.com,samsun1006219@gmail.com,rppt@kernel.org,mszeredi@redhat.com,lstoakes@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memfd_secret-add-vmsplice-test.patch added to mm-unstable branch
Message-Id: <20240325182902.F211FC433C7@smtp.kernel.org>
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
Date: Mon, 25 Mar 2024 14:41:13 +0100

Let's add a simple reproducer for a scneario where GUP-fast could succeed
on secretmem folios, making vmsplice() succeed instead of failing.  The
reproducer is based on a reproducer [1] by Miklos Szeredi.

Perform the ftruncate() only once, and check the return value.

For some reason, vmsplice() reliably fails (making the test succeed) when
we move the test_vmsplice() call after test_process_vm_read() /
test_ptrace().  Properly cleaning up in test_remote_access(), which is not
part of this change, won't change that behavior.  Therefore, run the
vmsplice() test for now first -- something is a bit off once we involve
fork().

[1] https://lkml.kernel.org/r/CAJfpegt3UCsMmxd0taOY11Uaw5U=eS1fE5dn0wZX3HF0oy8-oQ@mail.gmail.com

Link: https://lkml.kernel.org/r/20240325134114.257544-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: xingwei lee <xrivendell7@gmail.com>
Cc: yue sun <samsun1006219@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/memfd_secret.c |   44 +++++++++++++++++++-
 1 file changed, 42 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/memfd_secret.c~selftests-memfd_secret-add-vmsplice-test
+++ a/tools/testing/selftests/mm/memfd_secret.c
@@ -20,6 +20,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <stdio.h>
+#include <fcntl.h>
 
 #include "../kselftest.h"
 
@@ -83,6 +84,43 @@ static void test_mlock_limit(int fd)
 	pass("mlock limit is respected\n");
 }
 
+static void test_vmsplice(int fd)
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
+	ksft_test_result(transferred < 0 && errno == EFAULT,
+			 "vmsplice is blocked as expected\n");
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
@@ -187,7 +225,6 @@ static void test_remote_access(int fd, c
 		return;
 	}
 
-	ftruncate(fd, page_size);
 	memset(mem, PATTERN, page_size);
 
 	if (write(pipefd[1], &mem, sizeof(mem)) < 0) {
@@ -258,7 +295,7 @@ static void prepare(void)
 				   strerror(errno));
 }
 
-#define NUM_TESTS 4
+#define NUM_TESTS 5
 
 int main(int argc, char *argv[])
 {
@@ -277,9 +314,12 @@ int main(int argc, char *argv[])
 			ksft_exit_fail_msg("memfd_secret failed: %s\n",
 					   strerror(errno));
 	}
+	if (ftruncate(fd, page_size))
+		ksft_exit_fail_msg("ftruncate failed: %s\n", strerror(errno));
 
 	test_mlock_limit(fd);
 	test_file_apis(fd);
+	test_vmsplice(fd);
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
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-into-folio_fast_pin_allowed.patch

