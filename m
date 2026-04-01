Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1CD3B52E2
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 21:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775077327; cv=none; b=XLQKf3sJ1UH1OFnMFmXw4SF05oAmZclsUqHEcnze+BiAnvBJTFCjN2s5XSrOuIhUI4NksjgdHdgrXsHXdh9ir+Cv/nV4dcqTRIjHJ9PX+XyIszKL4fbLd1jHA0I6vzBSBYFMVstGFybl9vwyjQGiYE81ghbC6n3A1rzyfTugcPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775077327; c=relaxed/simple;
	bh=eT8FH+tmsBGeRNkiql+VysylPXOooxBiVst635b89nQ=;
	h=Date:To:From:Subject:Message-Id; b=lR4ia1KHUxq/0MbSgZPz2iJ7Ejg2V+1hdIybP/GQo1PsDkWdAjkDKmW/2e2xKW1LbURKitnJnhdEjtG1PmdQ2MMAkuFxfEJT1bx5/iPs9xgay/Zicn6srHfbtWNSqsXLb2E5HLd6+UQgpoTEHG6fANt+1pGUXJi+E0R3mRD+m58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AI7T6DT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AI7T6DT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA854C116C6;
	Wed,  1 Apr 2026 21:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775077326;
	bh=eT8FH+tmsBGeRNkiql+VysylPXOooxBiVst635b89nQ=;
	h=Date:To:From:Subject:From;
	b=AI7T6DT3nCFOGAhsrIX2YRywnlywsm7be35Z0qQN5afxxgdELCU/4eY6qbSGrOtBv
	 UJtQGnR5i8D2CctXhHN7lT2o81vZVMBl5KyDvO9mu2cNhXsXWYzUWH/jjebmrnZ/Ef
	 wsn2QwtIceFZfniYhw7QNJ7KxXN/H/3GlTdE+D5k=
Date: Wed, 01 Apr 2026 14:02:06 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible.patch added to mm-new branch
Message-Id: <20260401210206.CA854C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip hugetlb_dio tests when DIO alignment is incompatible
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible.patch

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
From: Li Wang <liwang@redhat.com>
Subject: selftests/mm: skip hugetlb_dio tests when DIO alignment is incompatible
Date: Wed, 1 Apr 2026 17:05:20 +0800

hugetlb_dio test uses sub-page offsets (pagesize / 2) to verify that
hugepages used as DIO user buffers are correctly unpinned at completion.

However, on filesystems with a logical block size larger than half the
page size (e.g., 4K-sector block devices), these unaligned DIO writes are
rejected with -EINVAL, causing the test to fail unexpectedly.

Add get_dio_alignment() to query the filesystem's required DIO alignment
via statx(STATX_DIOALIGN) and skip individual test cases whose file offset
or write size is not a multiple of that alignment.  Aligned cases continue
to run so the core coverage is preserved.

While here, open the temporary file once in main() and share the fd across
all test cases instead of reopening it in each invocation.

=== Reproduce Steps ===

  # dd if=/dev/zero of=/tmp/test.img bs=1M count=512
  # losetup --sector-size 4096 /dev/loop0 /tmp/test.img
  # mkfs.xfs /dev/loop0
  # mkdir -p /mnt/dio_test
  # mount /dev/loop0 /mnt/dio_test

  // Modify test to open /mnt/dio_test and rebuild it:
  -       fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
  +       fd = open("/mnt/dio_test", O_TMPFILE | O_RDWR | O_DIRECT, 0664);

  # getconf PAGESIZE
  4096

  # echo 100 >/proc/sys/vm/nr_hugepages

  # ./hugetlb_dio
  TAP version 13
  1..4
  # No. Free pages before allocation : 100
  # No. Free pages after munmap : 100
  ok 1 free huge pages from 0-12288
  Bail out! Error writing to file
  : Invalid argument (22)
  # Planned tests != run tests (4 != 1)
  # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

Link: https://lkml.kernel.org/r/20260401090520.24018-1-liwang@redhat.com
Signed-off-by: Li Wang <liwang@redhat.com>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_dio.c |   91 +++++++++++++++------
 1 file changed, 69 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb_dio.c~selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible
+++ a/tools/testing/selftests/mm/hugetlb_dio.c
@@ -17,12 +17,57 @@
 #include <unistd.h>
 #include <string.h>
 #include <sys/mman.h>
+#include <sys/syscall.h>
 #include "vm_util.h"
 #include "kselftest.h"
 
-void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
+#ifndef STATX_DIOALIGN
+#define STATX_DIOALIGN		0x00002000U
+#endif
+
+static int get_dio_alignment(int fd)
+{
+	struct statx stx;
+	int ret;
+
+	ret = syscall(__NR_statx, fd, "", AT_EMPTY_PATH, STATX_DIOALIGN, &stx);
+	if (ret < 0)
+		return -1;
+
+	/*
+	 * If STATX_DIOALIGN is unsupported, assume no alignment
+	 * constraint and let the test proceed.
+	 */
+	if (!(stx.stx_mask & STATX_DIOALIGN) || !stx.stx_dio_offset_align)
+		return 1;
+
+	return stx.stx_dio_offset_align;
+}
+
+static bool check_dio_alignment(unsigned int start_off,
+				unsigned int end_off, unsigned int align)
+{
+	unsigned int writesize = end_off - start_off;
+
+	/*
+	 * The kernel's DIO path checks that file offset, length, and
+	 * buffer address are all multiples of dio_offset_align.  When
+	 * this test case's parameters don't satisfy that, the write
+	 * would fail with -EINVAL before exercising the hugetlb unpin
+	 * path, so skip.
+	 */
+	if (start_off % align != 0 || writesize % align != 0) {
+		ksft_test_result_skip("DIO align=%u incompatible with offset %u writesize %u\n",
+				align, start_off, writesize);
+		return false;
+	}
+
+	return true;
+}
+
+static void run_dio_using_hugetlb(int fd, unsigned int start_off,
+				unsigned int end_off, unsigned int align)
 {
-	int fd;
 	char *buffer =  NULL;
 	char *orig_buffer = NULL;
 	size_t h_pagesize = 0;
@@ -32,6 +77,9 @@ void run_dio_using_hugetlb(unsigned int
 	const int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
 	const int mmap_prot  = PROT_READ | PROT_WRITE;
 
+	if (!check_dio_alignment(start_off, end_off, align))
+		return;
+
 	writesize = end_off - start_off;
 
 	/* Get the default huge page size */
@@ -39,10 +87,9 @@ void run_dio_using_hugetlb(unsigned int
 	if (!h_pagesize)
 		ksft_exit_fail_msg("Unable to determine huge page size\n");
 
-	/* Open the file to DIO */
-	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
-	if (fd < 0)
-		ksft_exit_fail_perror("Error opening file\n");
+	/* Reset file position since fd is shared across tests */
+	if (lseek(fd, 0, SEEK_SET) < 0)
+		ksft_exit_fail_perror("lseek failed\n");
 
 	/* Get the free huge pages before allocation */
 	free_hpage_b = get_free_hugepages();
@@ -71,7 +118,6 @@ void run_dio_using_hugetlb(unsigned int
 
 	/* unmap the huge page */
 	munmap(orig_buffer, h_pagesize);
-	close(fd);
 
 	/* Get the free huge pages after unmap*/
 	free_hpage_a = get_free_hugepages();
@@ -89,37 +135,38 @@ void run_dio_using_hugetlb(unsigned int
 
 int main(void)
 {
-	size_t pagesize = 0;
-	int fd;
+	int fd, align;
+	const size_t pagesize = psize();
 
 	ksft_print_header();
 
-	/* Open the file to DIO */
-	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
-	if (fd < 0)
-		ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
-	close(fd);
-
 	/* Check if huge pages are free */
 	if (!get_free_hugepages())
 		ksft_exit_skip("No free hugepage, exiting\n");
 
-	ksft_set_plan(4);
+	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
+	if (fd < 0)
+		ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
 
-	/* Get base page size */
-	pagesize  = psize();
+	align = get_dio_alignment(fd);
+	if (align < 0)
+		ksft_exit_skip("Unable to obtain DIO alignment: %s\n",
+				strerror(errno));
+	ksft_set_plan(4);
 
 	/* start and end is aligned to pagesize */
-	run_dio_using_hugetlb(0, (pagesize * 3));
+	run_dio_using_hugetlb(fd, 0, (pagesize * 3), align);
 
 	/* start is aligned but end is not aligned */
-	run_dio_using_hugetlb(0, (pagesize * 3) - (pagesize / 2));
+	run_dio_using_hugetlb(fd, 0, (pagesize * 3) - (pagesize / 2), align);
 
 	/* start is unaligned and end is aligned */
-	run_dio_using_hugetlb(pagesize / 2, (pagesize * 3));
+	run_dio_using_hugetlb(fd, pagesize / 2, (pagesize * 3), align);
 
 	/* both start and end are unaligned */
-	run_dio_using_hugetlb(pagesize / 2, (pagesize * 3) + (pagesize / 2));
+	run_dio_using_hugetlb(fd, pagesize / 2, (pagesize * 3) + (pagesize / 2), align);
+
+	close(fd);
 
 	ksft_finished();
 }
_

Patches currently in -mm which might be from liwang@redhat.com are

selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible.patch

