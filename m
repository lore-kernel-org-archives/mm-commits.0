Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C10115E90
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409745; cv=none; b=oYasan4uJ/4jWmuczhfNsBScBB0iypSqFlNj9DWJb+/JAqScbR8O/S13yp70OL4KAAr6gH3W743+zjV1Q2yj/fzfa4hR1I9OQ/7Ou2oCbnv+8gv/vmgEQ92PlZBPQQeIsewr32r9oFRh8ne5usQSX40EMWu7bwUPCViUgAGvXFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409745; c=relaxed/simple;
	bh=W0rDjeCaHE1HQu2SjixHjGHuQZXzxNCf+WzlON25z7w=;
	h=Date:To:From:Subject:Message-Id; b=PJmW8sHPqlrBXdmBfGKPzdLBUNPeFACVhqPg4QdrHU51FJmGkTE6IvbLdfWfjoMwIOFYIpW8A9M1vUAeAwiAEnNzircqXd1iQEiVTFtO/ylUrxYKOsxc7Qb1dMzZkwav/NfW7SPWrytu0UDre1VypXx3bjC9CC/smrNbSmMPjZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=thWRyp2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="thWRyp2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E97C4CEED;
	Fri, 25 Jul 2025 02:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409745;
	bh=W0rDjeCaHE1HQu2SjixHjGHuQZXzxNCf+WzlON25z7w=;
	h=Date:To:From:Subject:From;
	b=thWRyp2lvjMRsFh6/ct1EKbGM1taPN5cQwDW/HSrJEMjYwcA0dR9w6AAGZNQdFpqN
	 Qye9WLefUJ8vP6XCTyYPo+/MjO3fIbSbuEsEQnhQ5qnpe0gBNK+uyBagkhdxvRnJ1M
	 FOKLYchs/vcoqoJcE8YMcYfj7WHb2IkTt/v9EV6M=
Date: Thu, 24 Jul 2025 19:15:44 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-selftests-explicitly-test-split-multi-vma-mremap-move.patch removed from -mm tree
Message-Id: <20250725021545.63E97C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/selftests: explicitly test split multi VMA mremap move
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-explicitly-test-split-multi-vma-mremap-move.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/selftests: explicitly test split multi VMA mremap move
Date: Mon, 21 Jul 2025 18:33:27 +0100

Check that moving a range of VMAs where we are offset into the first and
last VMAs works correctly.

This results in the VMAs being split at these points at which we are offset
into VMAs.

We explicitly test both the ordinary MREMAP_FIXED multi VMA move case and
the MREMAP_DONTUNMAP multi VMA move case.

Link: https://lkml.kernel.org/r/b04920bb6c09dc86c207c251eab8ec670fbbcaef.1753119043.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |  127 ++++++++++++++++++++-
 1 file changed, 126 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mremap_test.c~tools-testing-selftests-explicitly-test-split-multi-vma-mremap-move
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -610,6 +610,129 @@ out:
 				      inplace ? " [inplace]" : "");
 }
 
+static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
+					    unsigned long page_size,
+					    bool dont_unmap)
+{
+	char *test_name = "mremap move multiple vmas split";
+	int mremap_flags = MREMAP_FIXED | MREMAP_MAYMOVE;
+	const size_t size = 10 * page_size;
+	bool success = true;
+	char *ptr, *tgt_ptr;
+	int i;
+
+	if (dont_unmap)
+		mremap_flags |= MREMAP_DONTUNMAP;
+
+	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (ptr == MAP_FAILED) {
+		perror("mmap");
+		success = false;
+		goto out;
+	}
+
+	tgt_ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (tgt_ptr == MAP_FAILED) {
+		perror("mmap");
+		success = false;
+		goto out;
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
+	 *  0 1 2 3 4 5 6 7 8 9 10 offset in buffer
+	 * |**********| |*******|
+	 * |**********| |*******|
+	 *  0 1 2 3 4   5 6 7 8 9  pattern offset
+	 */
+	if (munmap(&ptr[5 * page_size], page_size)) {
+		perror("munmap");
+		success = false;
+		goto out_unmap;
+	}
+
+	/* Set up random patterns. */
+	srand(pattern_seed);
+	for (i = 0; i < 10; i++) {
+		int j;
+		char *buf = &ptr[i * page_size];
+
+		if (i == 5)
+			continue;
+
+		for (j = 0; j < page_size; j++)
+			buf[j] = rand();
+	}
+
+	/*
+	 * Move the below:
+	 *
+	 *      <------------->
+	 *  0 1 2 3 4 5 6 7 8 9 10 offset in buffer
+	 * |**********| |*******|
+	 * |**********| |*******|
+	 *  0 1 2 3 4   5 6 7 8 9  pattern offset
+	 *
+	 * Into:
+	 *
+	 * 0 1 2 3 4 5 6 7 offset in buffer
+	 * |*****| |*****|
+	 * |*****| |*****|
+	 * 2 3 4   5 6 7   pattern offset
+	 */
+	if (mremap(&ptr[2 * page_size], size - 3 * page_size, size - 3 * page_size,
+		   mremap_flags, tgt_ptr) == MAP_FAILED) {
+		perror("mremap");
+		success = false;
+		goto out_unmap;
+	}
+
+	/* Offset into random pattern. */
+	srand(pattern_seed);
+	for (i = 0; i < 2 * page_size; i++)
+		rand();
+
+	/* Check pattern. */
+	for (i = 0; i < 7; i++) {
+		int j;
+		char *buf = &tgt_ptr[i * page_size];
+
+		if (i == 3)
+			continue;
+
+		for (j = 0; j < page_size; j++) {
+			char chr = rand();
+
+			if (chr != buf[j]) {
+				ksft_print_msg("page %d offset %d corrupted, expected %d got %d\n",
+					       i, j, chr, buf[j]);
+				goto out_unmap;
+			}
+		}
+	}
+
+out_unmap:
+	if (munmap(tgt_ptr, size))
+		perror("munmap tgt");
+	if (munmap(ptr, size))
+		perror("munmap src");
+out:
+	if (success)
+		ksft_test_result_pass("%s%s\n", test_name,
+				      dont_unmap ? " [dontunnmap]" : "");
+	else
+		ksft_test_result_fail("%s%s\n", test_name,
+				      dont_unmap ? " [dontunnmap]" : "");
+}
+
 /* Returns the time taken for the remap on success else returns -1. */
 static long long remap_region(struct config c, unsigned int threshold_mb,
 			      char *rand_addr)
@@ -951,7 +1074,7 @@ int main(int argc, char **argv)
 	char *rand_addr;
 	size_t rand_size;
 	int num_expand_tests = 2;
-	int num_misc_tests = 6;
+	int num_misc_tests = 8;
 	struct test test_cases[MAX_TEST] = {};
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
@@ -1082,6 +1205,8 @@ int main(int argc, char **argv)
 	mremap_shrink_multiple_vmas(page_size, /* inplace= */false);
 	mremap_move_multiple_vmas(pattern_seed, page_size, /* dontunmap= */ false);
 	mremap_move_multiple_vmas(pattern_seed, page_size, /* dontunmap= */ true);
+	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ false);
+	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ true);
 
 	if (run_perf_tests) {
 		ksft_print_msg("\n%s\n",
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch
maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-add-missing-mm_sloth-file-thp-section-fix.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch
maintainers-add-missing-file-to-cgroup-section.patch

