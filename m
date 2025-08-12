Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E092E03EC
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 04:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754971346; cv=none; b=nJcrujKRCI4Pf/c6iAjCkqgMywUfCUDUODqpNdBvGCC4hnSoWTFF6ZVMb8gpqnzTRhjYuCo2pGeMe8e8GclnRXCbYiEpT8L1dITC9yUJOKkDs8sc1HxvMnY4iDc5lNDhPm95XwYlSC7lJ17JdYTifs8daTsFzkAbcvPjoHXhN8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754971346; c=relaxed/simple;
	bh=Q1XIWJF08TseSttJ1g5qvKomGq9RGPmYQ97C4tye9as=;
	h=Date:To:From:Subject:Message-Id; b=W1/6COz0v2HrbyTbXGu3UfICMkqOeoHX587mInC+Qs5+AW/Odjq3rFad9ht2HwCk2jQl/bR1PFj0paReE/aGG5LN9lTahWFDCwOXm53tUA4FdefrpbC9LT+iA7fRma1JsV283TGlyPS0jIv9MrSnbndq5pCNKjjxr+IDx5+GIMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hUYyZGaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hUYyZGaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7025C4CEF9;
	Tue, 12 Aug 2025 04:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754971345;
	bh=Q1XIWJF08TseSttJ1g5qvKomGq9RGPmYQ97C4tye9as=;
	h=Date:To:From:Subject:From;
	b=hUYyZGaHQ5Qr4rKL4FHZU+wpydy0PSdrgtk6DxYsled+GzEas2f1vJpugw3cniPBB
	 iSqtbHbyejJeUG+XogboRP81VKY21EYlffaXtHJ5T7JmxGLxxPV2fMzWTzwy4sxsYT
	 dSRhluHpK1cqw9pp9pbGNSj4K2hJs6hi0bdL8C64=
Date: Mon, 11 Aug 2025 21:02:25 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-test-for-invalid-multi-vma-operations.patch added to mm-hotfixes-unstable branch
Message-Id: <20250812040225.B7025C4CEF9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add test for invalid multi VMA operations
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-add-test-for-invalid-multi-vma-operations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-test-for-invalid-multi-vma-operations.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: selftests/mm: add test for invalid multi VMA operations
Date: Sun, 3 Aug 2025 12:11:23 +0100

We can use UFFD to easily assert invalid multi VMA moves, so do so,
asserting expected behaviour when VMAs invalid for a multi VMA operation
are encountered.

We assert both that such operations are not permitted, and that we do not
even attempt to move the first VMA under these circumstances.

We also assert that we can still move a single VMA regardless.

We then assert that a partial failure can occur if the invalid VMA appears
later in the range of multiple VMAs, both at the very next VMA, and also at
the end of the range.

As part of this change, we are using the is_range_valid() helper more
aggressively. Therefore, fix a bug where stale buffered data would hang
around on success, causing subsequent calls to is_range_valid() to
potentially give invalid results.

We simply have to fflush() the stream on success to resolve this issue.

Link: https://lkml.kernel.org/r/c4fb86dd5ba37610583ad5fc0e0c2306ddf318b9.1754218667.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |  264 ++++++++++++++++++++-
 1 file changed, 261 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-add-test-for-invalid-multi-vma-operations
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -5,10 +5,14 @@
 #define _GNU_SOURCE
 
 #include <errno.h>
+#include <fcntl.h>
+#include <linux/userfaultfd.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
+#include <sys/ioctl.h>
 #include <sys/mman.h>
+#include <syscall.h>
 #include <time.h>
 #include <stdbool.h>
 
@@ -168,6 +172,7 @@ static bool is_range_mapped(FILE *maps_f
 
 		if (first_val <= start && second_val >= end) {
 			success = true;
+			fflush(maps_fp);
 			break;
 		}
 	}
@@ -175,6 +180,15 @@ static bool is_range_mapped(FILE *maps_f
 	return success;
 }
 
+/* Check if [ptr, ptr + size) mapped in /proc/self/maps. */
+static bool is_ptr_mapped(FILE *maps_fp, void *ptr, unsigned long size)
+{
+	unsigned long start = (unsigned long)ptr;
+	unsigned long end = start + size;
+
+	return is_range_mapped(maps_fp, start, end);
+}
+
 /*
  * Returns the start address of the mapping on success, else returns
  * NULL on failure.
@@ -733,6 +747,249 @@ out:
 				      dont_unmap ? " [dontunnmap]" : "");
 }
 
+#ifdef __NR_userfaultfd
+static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
+		unsigned long page_size)
+{
+	char *test_name = "mremap move multiple invalid vmas";
+	const size_t size = 10 * page_size;
+	bool success = true;
+	char *ptr, *tgt_ptr;
+	int uffd, err, i;
+	void *res;
+	struct uffdio_api api = {
+		.api = UFFD_API,
+		.features = UFFD_EVENT_PAGEFAULT,
+	};
+
+	uffd = syscall(__NR_userfaultfd, O_NONBLOCK);
+	if (uffd == -1) {
+		err = errno;
+		perror("userfaultfd");
+		if (err == EPERM) {
+			ksft_test_result_skip("%s - missing uffd", test_name);
+			return;
+		}
+		success = false;
+		goto out;
+	}
+	if (ioctl(uffd, UFFDIO_API, &api)) {
+		perror("ioctl UFFDIO_API");
+		success = false;
+		goto out_close_uffd;
+	}
+
+	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (ptr == MAP_FAILED) {
+		perror("mmap");
+		success = false;
+		goto out_close_uffd;
+	}
+
+	tgt_ptr = mmap(NULL, size, PROT_NONE, MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (tgt_ptr == MAP_FAILED) {
+		perror("mmap");
+		success = false;
+		goto out_close_uffd;
+	}
+	if (munmap(tgt_ptr, size)) {
+		perror("munmap");
+		success = false;
+		goto out_unmap;
+	}
+
+	/*
+	 * Unmap so we end up with:
+	 *
+	 *  0   2   4   6   8   10 offset in buffer
+	 * |*| |*| |*| |*| |*|
+	 * |*| |*| |*| |*| |*|
+	 *
+	 * Additionally, register each with UFFD.
+	 */
+	for (i = 0; i < 10; i += 2) {
+		void *unmap_ptr = &ptr[(i + 1) * page_size];
+		unsigned long start = (unsigned long)&ptr[i * page_size];
+		struct uffdio_register reg = {
+			.range = {
+				.start = start,
+				.len = page_size,
+			},
+			.mode = UFFDIO_REGISTER_MODE_MISSING,
+		};
+
+		if (ioctl(uffd, UFFDIO_REGISTER, &reg) == -1) {
+			perror("ioctl UFFDIO_REGISTER");
+			success = false;
+			goto out_unmap;
+		}
+		if (munmap(unmap_ptr, page_size)) {
+			perror("munmap");
+			success = false;
+			goto out_unmap;
+		}
+	}
+
+	/*
+	 * Now try to move the entire range which is invalid for multi VMA move.
+	 *
+	 * This will fail, and no VMA should be moved, as we check this ahead of
+	 * time.
+	 */
+	res = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
+	err = errno;
+	if (res != MAP_FAILED) {
+		fprintf(stderr, "mremap() succeeded for multi VMA uffd armed\n");
+		success = false;
+		goto out_unmap;
+	}
+	if (err != EFAULT) {
+		errno = err;
+		perror("mrmeap() unexpected error");
+		success = false;
+		goto out_unmap;
+	}
+	if (is_ptr_mapped(maps_fp, tgt_ptr, page_size)) {
+		fprintf(stderr,
+			"Invalid uffd-armed VMA at start of multi range moved\n");
+		success = false;
+		goto out_unmap;
+	}
+
+	/*
+	 * Now try to move a single VMA, this should succeed as not multi VMA
+	 * move.
+	 */
+	res = mremap(ptr, page_size, page_size,
+		     MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
+	if (res == MAP_FAILED) {
+		perror("mremap single invalid-multi VMA");
+		success = false;
+		goto out_unmap;
+	}
+
+	/*
+	 * Unmap the VMA, and remap a non-uffd registered (therefore, multi VMA
+	 * move valid) VMA at the start of ptr range.
+	 */
+	if (munmap(tgt_ptr, page_size)) {
+		perror("munmap");
+		success = false;
+		goto out_unmap;
+	}
+	res = mmap(ptr, page_size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	if (res == MAP_FAILED) {
+		perror("mmap");
+		success = false;
+		goto out_unmap;
+	}
+
+	/*
+	 * Now try to move the entire range, we should succeed in moving the
+	 * first VMA, but no others, and report a failure.
+	 */
+	res = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
+	err = errno;
+	if (res != MAP_FAILED) {
+		fprintf(stderr, "mremap() succeeded for multi VMA uffd armed\n");
+		success = false;
+		goto out_unmap;
+	}
+	if (err != EFAULT) {
+		errno = err;
+		perror("mrmeap() unexpected error");
+		success = false;
+		goto out_unmap;
+	}
+	if (!is_ptr_mapped(maps_fp, tgt_ptr, page_size)) {
+		fprintf(stderr, "Valid VMA not moved\n");
+		success = false;
+		goto out_unmap;
+	}
+
+	/*
+	 * Unmap the VMA, and map valid VMA at start of ptr range, and replace
+	 * all existing multi-move invalid VMAs, except the last, with valid
+	 * multi-move VMAs.
+	 */
+	if (munmap(tgt_ptr, page_size)) {
+		perror("munmap");
+		success = false;
+		goto out_unmap;
+	}
+	if (munmap(ptr, size - 2 * page_size)) {
+		perror("munmap");
+		success = false;
+		goto out_unmap;
+	}
+	for (i = 0; i < 8; i += 2) {
+		res = mmap(&ptr[i * page_size], page_size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+		if (res == MAP_FAILED) {
+			perror("mmap");
+			success = false;
+			goto out_unmap;
+		}
+	}
+
+	/*
+	 * Now try to move the entire range, we should succeed in moving all but
+	 * the last VMA, and report a failure.
+	 */
+	res = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
+	err = errno;
+	if (res != MAP_FAILED) {
+		fprintf(stderr, "mremap() succeeded for multi VMA uffd armed\n");
+		success = false;
+		goto out_unmap;
+	}
+	if (err != EFAULT) {
+		errno = err;
+		perror("mrmeap() unexpected error");
+		success = false;
+		goto out_unmap;
+	}
+
+	for (i = 0; i < 10; i += 2) {
+		bool is_mapped = is_ptr_mapped(maps_fp,
+				&tgt_ptr[i * page_size], page_size);
+
+		if (i < 8 && !is_mapped) {
+			fprintf(stderr, "Valid VMA not moved at %d\n", i);
+			success = false;
+			goto out_unmap;
+		} else if (i == 8 && is_mapped) {
+			fprintf(stderr, "Invalid VMA moved at %d\n", i);
+			success = false;
+			goto out_unmap;
+		}
+	}
+
+out_unmap:
+	if (munmap(tgt_ptr, size))
+		perror("munmap tgt");
+	if (munmap(ptr, size))
+		perror("munmap src");
+out_close_uffd:
+	close(uffd);
+out:
+	if (success)
+		ksft_test_result_pass("%s\n", test_name);
+	else
+		ksft_test_result_fail("%s\n", test_name);
+}
+#else
+static void mremap_move_multi_invalid_vmas(FILE *maps_fp, unsigned long page_size)
+{
+	char *test_name = "mremap move multiple invalid vmas";
+
+	ksft_test_result_skip("%s - missing uffd", test_name);
+}
+#endif /* __NR_userfaultfd */
+
 /* Returns the time taken for the remap on success else returns -1. */
 static long long remap_region(struct config c, unsigned int threshold_mb,
 			      char *rand_addr)
@@ -1074,7 +1331,7 @@ int main(int argc, char **argv)
 	char *rand_addr;
 	size_t rand_size;
 	int num_expand_tests = 2;
-	int num_misc_tests = 8;
+	int num_misc_tests = 9;
 	struct test test_cases[MAX_TEST] = {};
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
@@ -1197,8 +1454,6 @@ int main(int argc, char **argv)
 	mremap_expand_merge(maps_fp, page_size);
 	mremap_expand_merge_offset(maps_fp, page_size);
 
-	fclose(maps_fp);
-
 	mremap_move_within_range(pattern_seed, rand_addr);
 	mremap_move_1mb_from_start(pattern_seed, rand_addr);
 	mremap_shrink_multiple_vmas(page_size, /* inplace= */true);
@@ -1207,6 +1462,9 @@ int main(int argc, char **argv)
 	mremap_move_multiple_vmas(pattern_seed, page_size, /* dontunmap= */ true);
 	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ false);
 	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ true);
+	mremap_move_multi_invalid_vmas(maps_fp, page_size);
+
+	fclose(maps_fp);
 
 	if (run_perf_tests) {
 		ksft_print_msg("\n%s\n",
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mremap-avoid-expensive-folio-lookup-on-mremap-folio-pte-batch.patch
tools-testing-add-linux-argsh-header-and-fix-radix-vma-tests.patch
mm-mremap-allow-multi-vma-move-when-filesystem-uses-thp_get_unmapped_area.patch
mm-mremap-catch-invalid-multi-vma-moves-earlier.patch
selftests-mm-add-test-for-invalid-multi-vma-operations.patch

