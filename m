Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D850682D64;
	Thu, 23 May 2024 19:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716491645; cv=none; b=j6PKkpNeZRBv46xH9ktyGnXRlhlUFfBTxkfK+klHYmbINlq3cHbLHxwQyFV/43QF/6rbLIJfNU+uWp91Mms5Ii69leJT+mLQawFNUi6dewuRbhDVA7y86mq7pNmvBtI8rBUfyc6SPaD19dw3OIUa3HZDzrv4GVDXQAyVBgDjcIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716491645; c=relaxed/simple;
	bh=rIwffAsp4BxzpZk80EFk6wCoBRirhS5q2UtE9B6Cr94=;
	h=Date:To:From:Subject:Message-Id; b=Q2TAiDqvXzk4LPHatAIzgbEHaU9mHzNlh1pZI4rdhmLBIiT09DP2AmFkvb/V8Nd6nh/wJogDtfaF5oQEQiHd5zxqkK/67Giep1MKYUTc4Uzixu1MG/5ds6c4fZ7+Lr+lNDPngoRSLCbMVuqTYsAEfoWiiZJe4FRkud1AfF6y7l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GSqiWFWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GSqiWFWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2711C2BD10;
	Thu, 23 May 2024 19:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716491645;
	bh=rIwffAsp4BxzpZk80EFk6wCoBRirhS5q2UtE9B6Cr94=;
	h=Date:To:From:Subject:From;
	b=GSqiWFWfdbXEYxYPoeG4wCPH656bNJxGEtspyeihYz7suV4ZqWTU8ymS5Rzeeo0Jk
	 OIVhJtqa6nBSKyhY9Jenl/Azv/eiBhpHqeli/W7V7C2H9Pvzhv5l3gYpIM3ki6pd6U
	 DUffV9yIOR9vzRVk3IqVc1FtfbqRtmInqoxpbe+U=
Date: Thu, 23 May 2024 12:14:05 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tonyb@cybernetics.com,stable@vger.kernel.org,songmuchun@bytedance.com,shuah@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,david@redhat.com,axboe@kernel.dk,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages.patch added to mm-unstable branch
Message-Id: <20240523191405.A2711C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest: mm: Test if hugepage does not get leaked during __bio_release_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages.patch

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: selftest: mm: Test if hugepage does not get leaked during __bio_release_pages()
Date: Thu, 23 May 2024 01:39:05 -0500

Commit 1b151e2435fc ("block: Remove special-casing of compound pages")
caused a change in behaviour when releasing the pages if the buffer does
not start at the beginning of the page.  This was because the calculation
of the number of pages to release was incorrect.  This was fixed by commit
38b43539d64b ("block: Fix page refcounts for unaligned buffers in
__bio_release_pages()").

We pin the user buffer during direct I/O writes.  If this buffer is a
hugepage, bio_release_page() will unpin it and decrement all references
and pin counts at ->bi_end_io.  However, if any references to the hugepage
remain post-I/O, the hugepage will not be freed upon unmap, leading to a
memory leak.

This patch verifies that a hugepage, used as a user buffer for DIO
operations, is correctly freed upon unmapping, regardless of whether the
offsets are aligned or unaligned w.r.t page boundary.

Test Result  Fail Scenario (Without the fix)
--------------------------------------------------------
[]# ./hugetlb_dio
TAP version 13
1..4
No. Free pages before allocation : 7
No. Free pages after munmap : 7
ok 1 : Huge pages freed successfully !
No. Free pages before allocation : 7
No. Free pages after munmap : 7
ok 2 : Huge pages freed successfully !
No. Free pages before allocation : 7
No. Free pages after munmap : 7
ok 3 : Huge pages freed successfully !
No. Free pages before allocation : 7
No. Free pages after munmap : 6
not ok 4 : Huge pages not freed!
Totals: pass:3 fail:1 xfail:0 xpass:0 skip:0 error:0

Test Result  PASS Scenario (With the fix)
---------------------------------------------------------
[]#./hugetlb_dio
TAP version 13
1..4
No. Free pages before allocation : 7
No. Free pages after munmap : 7
ok 1 : Huge pages freed successfully !
No. Free pages before allocation : 7
No. Free pages after munmap : 7
ok 2 : Huge pages freed successfully !
No. Free pages before allocation : 7
No. Free pages after munmap : 7
ok 3 : Huge pages freed successfully !
No. Free pages before allocation : 7
No. Free pages after munmap : 7
ok 4 : Huge pages freed successfully !
Totals: pass:4 fail:0 xfail:0 xpass:0 skip:0 error:0

Link: https://lkml.kernel.org/r/20240523063905.3173-1-donettom@linux.ibm.com
Fixes: 38b43539d64b ("block: Fix page refcounts for unaligned buffers in __bio_release_pages()")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile      |    1 
 tools/testing/selftests/mm/hugetlb_dio.c |  118 +++++++++++++++++++++
 2 files changed, 119 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/mm/hugetlb_dio.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This program tests for hugepage leaks after DIO writes to a file using a
+ * hugepage as the user buffer. During DIO, the user buffer is pinned and
+ * should be properly unpinned upon completion. This patch verifies that the
+ * kernel correctly unpins the buffer at DIO completion for both aligned and
+ * unaligned user buffer offsets (w.r.t page boundary), ensuring the hugepage
+ * is freed upon unmapping.
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <sys/stat.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <stdint.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/mman.h>
+#include "vm_util.h"
+#include "../kselftest.h"
+
+void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
+{
+	int fd;
+	char *buffer =  NULL;
+	char *orig_buffer = NULL;
+	size_t h_pagesize = 0;
+	size_t writesize;
+	int free_hpage_b = 0;
+	int free_hpage_a = 0;
+
+	writesize = end_off - start_off;
+
+	/* Get the default huge page size */
+	h_pagesize = default_huge_page_size();
+	if (!h_pagesize)
+		ksft_exit_fail_msg("Unable to determine huge page size\n");
+
+	/* Open the file to DIO */
+	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT);
+	if (fd < 0)
+		ksft_exit_fail_msg("Error opening file");
+
+	/* Get the free huge pages before allocation */
+	free_hpage_b = get_free_hugepages();
+	if (free_hpage_b == 0) {
+		close(fd);
+		ksft_exit_skip("No free hugepage, exiting!\n");
+	}
+
+	/* Allocate a hugetlb page */
+	orig_buffer = mmap(NULL, h_pagesize, PROT_READ | PROT_WRITE, MAP_PRIVATE
+			| MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+	if (orig_buffer == MAP_FAILED) {
+		close(fd);
+		ksft_exit_fail_msg("Error mapping memory");
+	}
+	buffer = orig_buffer;
+	buffer += start_off;
+
+	memset(buffer, 'A', writesize);
+
+	/* Write the buffer to the file */
+	if (write(fd, buffer, writesize) != (writesize)) {
+		munmap(orig_buffer, h_pagesize);
+		close(fd);
+		ksft_exit_fail_msg("Error writing to file");
+	}
+
+	/* unmap the huge page */
+	munmap(orig_buffer, h_pagesize);
+	close(fd);
+
+	/* Get the free huge pages after unmap*/
+	free_hpage_a = get_free_hugepages();
+
+	/*
+	 * If the no. of free hugepages before allocation and after unmap does
+	 * not match - that means there could still be a page which is pinned.
+	 */
+	if (free_hpage_a != free_hpage_b) {
+		printf("No. Free pages before allocation : %d\n", free_hpage_b);
+		printf("No. Free pages after munmap : %d\n", free_hpage_a);
+		ksft_test_result_fail(": Huge pages not freed!\n");
+	} else {
+		printf("No. Free pages before allocation : %d\n", free_hpage_b);
+		printf("No. Free pages after munmap : %d\n", free_hpage_a);
+		ksft_test_result_pass(": Huge pages freed successfully !\n");
+	}
+}
+
+int main(void)
+{
+	size_t pagesize = 0;
+
+	ksft_print_header();
+	ksft_set_plan(4);
+
+	/* Get base page size */
+	pagesize  = psize();
+
+	/* start and end is aligned to pagesize */
+	run_dio_using_hugetlb(0, (pagesize * 3));
+
+	/* start is aligned but end is not aligned */
+	run_dio_using_hugetlb(0, (pagesize * 3) - (pagesize / 2));
+
+	/* start is unaligned and end is aligned */
+	run_dio_using_hugetlb(pagesize / 2, (pagesize * 3));
+
+	/* both start and end are unaligned */
+	run_dio_using_hugetlb(pagesize / 2, (pagesize * 3) + (pagesize / 2));
+
+	ksft_finished();
+	return 0;
+}
+
--- a/tools/testing/selftests/mm/Makefile~selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages
+++ a/tools/testing/selftests/mm/Makefile
@@ -71,6 +71,7 @@ TEST_GEN_FILES += ksm_functional_tests
 TEST_GEN_FILES += mdwe_test
 TEST_GEN_FILES += hugetlb_fault_after_madv
 TEST_GEN_FILES += hugetlb_madv_vs_map
+TEST_GEN_FILES += hugetlb_dio
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

selftest-mm-test-if-hugepage-does-not-get-leaked-during-__bio_release_pages.patch

