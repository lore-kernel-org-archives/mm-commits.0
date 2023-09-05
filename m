Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28482CA0FF3
	for <mm-commits@archiver.kernel.org>; Tue,  5 Sep 2023 16:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjIEQfV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbjIEQRz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2023 12:17:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B17B1999
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 09:17:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97A8D6097C
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 16:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC87C433C7;
        Tue,  5 Sep 2023 16:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693929778;
        bh=PmDQJTo1cJTft8ndxyyY8Jdun19PAVv/v6sjI0th960=;
        h=Date:To:From:Subject:From;
        b=oPStb/oCQ0Nue9lsB8RqzcUflYtdDbT92lfHCHIO7oFnMdc/TKbm8P++EG4goigiZ
         LCubXcm9IDfSYCUJAH7IftAM4Oo26HNd50djYIh9RbiMs0r1WpCNurIeYIQXPM8Y80
         Wpvrls3V0EjE7MMpcWJtkhnoO/1H586LBgdNw1lg=
Date:   Tue, 05 Sep 2023 09:02:57 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, surenb@google.com, shuah@kernel.org,
        paulmck@kernel.org, mhocko@suse.com, lstoakes@gmail.com,
        lokeshgidra@google.com, Liam.Howlett@oracle.com,
        kirill@shutemov.name, kaleshsingh@google.com,
        joel@joelfernandes.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-a-test-for-moving-from-an-offset-from-start-of-mapping.patch added to mm-unstable branch
Message-Id: <20230905160257.EEC87C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: mm: add a test for moving from an offset from start of mapping
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-a-test-for-moving-from-an-offset-from-start-of-mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-a-test-for-moving-from-an-offset-from-start-of-mapping.patch

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
From: Joel Fernandes <joel@joelfernandes.org>
Subject: selftests: mm: add a test for moving from an offset from start of mapping
Date: Sun, 3 Sep 2023 15:13:28 +0000

It is possible that the aligned address falls on no existing mapping,
however that does not mean that we can just align it down to that.  This
test verifies that the "vma->vm_start != addr_to_align" check in
can_align_down() prevents disastrous results if aligning down when source
and dest are mutually aligned within a PMD but the source/dest addresses
requested are not at the beginning of the respective mapping containing
these addresses.

Link: https://lkml.kernel.org/r/20230903151328.2981432-8-joel@joelfernandes.org
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |  189 ++++++++++++++-------
 1 file changed, 134 insertions(+), 55 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-add-a-test-for-moving-from-an-offset-from-start-of-mapping
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -24,6 +24,7 @@
 
 #define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
 #define SIZE_MB(m) ((size_t)m * (1024 * 1024))
+#define SIZE_KB(k) ((size_t)k * 1024)
 
 struct config {
 	unsigned long long src_alignment;
@@ -149,6 +150,60 @@ static bool is_range_mapped(FILE *maps_f
 }
 
 /*
+ * Returns the start address of the mapping on success, else returns
+ * NULL on failure.
+ */
+static void *get_source_mapping(struct config c)
+{
+	unsigned long long addr = 0ULL;
+	void *src_addr = NULL;
+	unsigned long long mmap_min_addr;
+
+	mmap_min_addr = get_mmap_min_addr();
+	/*
+	 * For some tests, we need to not have any mappings below the
+	 * source mapping. Add some headroom to mmap_min_addr for this.
+	 */
+	mmap_min_addr += 10 * _4MB;
+
+retry:
+	addr += c.src_alignment;
+	if (addr < mmap_min_addr)
+		goto retry;
+
+	src_addr = mmap((void *) addr, c.region_size, PROT_READ | PROT_WRITE,
+					MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
+					-1, 0);
+	if (src_addr == MAP_FAILED) {
+		if (errno == EPERM || errno == EEXIST)
+			goto retry;
+		goto error;
+	}
+	/*
+	 * Check that the address is aligned to the specified alignment.
+	 * Addresses which have alignments that are multiples of that
+	 * specified are not considered valid. For instance, 1GB address is
+	 * 2MB-aligned, however it will not be considered valid for a
+	 * requested alignment of 2MB. This is done to reduce coincidental
+	 * alignment in the tests.
+	 */
+	if (((unsigned long long) src_addr & (c.src_alignment - 1)) ||
+			!((unsigned long long) src_addr & c.src_alignment)) {
+		munmap(src_addr, c.region_size);
+		goto retry;
+	}
+
+	if (!src_addr)
+		goto error;
+
+	return src_addr;
+error:
+	ksft_print_msg("Failed to map source region: %s\n",
+			strerror(errno));
+	return NULL;
+}
+
+/*
  * This test validates that merge is called when expanding a mapping.
  * Mapping containing three pages is created, middle page is unmapped
  * and then the mapping containing the first page is expanded so that
@@ -300,60 +355,6 @@ out:
 		ksft_test_result_fail("%s\n", test_name);
 }
 
-/*
- * Returns the start address of the mapping on success, else returns
- * NULL on failure.
- */
-static void *get_source_mapping(struct config c)
-{
-	unsigned long long addr = 0ULL;
-	void *src_addr = NULL;
-	unsigned long long mmap_min_addr;
-
-	mmap_min_addr = get_mmap_min_addr();
-	/*
-	 * For some tests, we need to not have any mappings below the
-	 * source mapping. Add some headroom to mmap_min_addr for this.
-	 */
-	mmap_min_addr += 10 * _4MB;
-
-retry:
-	addr += c.src_alignment;
-	if (addr < mmap_min_addr)
-		goto retry;
-
-	src_addr = mmap((void *) addr, c.region_size, PROT_READ | PROT_WRITE,
-					MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
-					-1, 0);
-	if (src_addr == MAP_FAILED) {
-		if (errno == EPERM || errno == EEXIST)
-			goto retry;
-		goto error;
-	}
-	/*
-	 * Check that the address is aligned to the specified alignment.
-	 * Addresses which have alignments that are multiples of that
-	 * specified are not considered valid. For instance, 1GB address is
-	 * 2MB-aligned, however it will not be considered valid for a
-	 * requested alignment of 2MB. This is done to reduce coincidental
-	 * alignment in the tests.
-	 */
-	if (((unsigned long long) src_addr & (c.src_alignment - 1)) ||
-			!((unsigned long long) src_addr & c.src_alignment)) {
-		munmap(src_addr, c.region_size);
-		goto retry;
-	}
-
-	if (!src_addr)
-		goto error;
-
-	return src_addr;
-error:
-	ksft_print_msg("Failed to map source region: %s\n",
-			strerror(errno));
-	return NULL;
-}
-
 /* Returns the time taken for the remap on success else returns -1. */
 static long long remap_region(struct config c, unsigned int threshold_mb,
 			      char pattern_seed)
@@ -487,6 +488,83 @@ out:
 	return ret;
 }
 
+/*
+ * Verify that an mremap aligning down does not destroy
+ * the beginning of the mapping just because the aligned
+ * down address landed on a mapping that maybe does not exist.
+ */
+static void mremap_move_1mb_from_start(char pattern_seed)
+{
+	char *test_name = "mremap move 1mb from start at 1MB+256KB aligned src";
+	void *src = NULL, *dest = NULL;
+	int i, success = 1;
+
+	/* Config to reuse get_source_mapping() to do an aligned mmap. */
+	struct config c = {
+		.src_alignment = SIZE_MB(1) + SIZE_KB(256),
+		.region_size = SIZE_MB(6)
+	};
+
+	src = get_source_mapping(c);
+	if (!src) {
+		success = 0;
+		goto out;
+	}
+
+	c.src_alignment = SIZE_MB(1) + SIZE_KB(256);
+	dest = get_source_mapping(c);
+	if (!dest) {
+		success = 0;
+		goto out;
+	}
+
+	/* Set byte pattern for source block. */
+	srand(pattern_seed);
+	for (i = 0; i < SIZE_MB(2); i++) {
+		((char *)src)[i] = (char) rand();
+	}
+
+	/*
+	 * Unmap the beginning of dest so that the aligned address
+	 * falls on no mapping.
+	 */
+	munmap(dest, SIZE_MB(1));
+
+	void *new_ptr = mremap(src + SIZE_MB(1), SIZE_MB(1), SIZE_MB(1),
+						   MREMAP_MAYMOVE | MREMAP_FIXED, dest + SIZE_MB(1));
+	if (new_ptr == MAP_FAILED) {
+		perror("mremap");
+		success = 0;
+		goto out;
+	}
+
+	/* Verify byte pattern after remapping */
+	srand(pattern_seed);
+	for (i = 0; i < SIZE_MB(1); i++) {
+		char c = (char) rand();
+
+		if (((char *)src)[i] != c) {
+			ksft_print_msg("Data at src at %d got corrupted due to unrelated mremap\n",
+				       i);
+			ksft_print_msg("Expected: %#x\t Got: %#x\n", c & 0xff,
+					((char *) src)[i] & 0xff);
+			success = 0;
+		}
+	}
+
+out:
+	if (src && munmap(src, c.region_size) == -1)
+		perror("munmap src");
+
+	if (dest && munmap(dest, c.region_size) == -1)
+		perror("munmap dest");
+
+	if (success)
+		ksft_test_result_pass("%s\n", test_name);
+	else
+		ksft_test_result_fail("%s\n", test_name);
+}
+
 static void run_mremap_test_case(struct test test_case, int *failures,
 				 unsigned int threshold_mb,
 				 unsigned int pattern_seed)
@@ -565,7 +643,7 @@ int main(int argc, char **argv)
 	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
 	unsigned int pattern_seed;
 	int num_expand_tests = 2;
-	int num_misc_tests = 1;
+	int num_misc_tests = 2;
 	struct test test_cases[MAX_TEST] = {};
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
@@ -666,6 +744,7 @@ int main(int argc, char **argv)
 	fclose(maps_fp);
 
 	mremap_move_within_range(pattern_seed);
+	mremap_move_1mb_from_start(pattern_seed);
 
 	if (run_perf_tests) {
 		ksft_print_msg("\n%s\n",
_

Patches currently in -mm which might be from joel@joelfernandes.org are

mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug.patch
mm-mremap-optimize-the-start-addresses-in-move_page_tables.patch
mm-mremap-allow-moves-within-the-same-vma-for-stack-moves.patch
selftests-mm-fix-failure-case-when-new-remap-region-was-not-found.patch
selftests-mm-add-a-test-for-mutually-aligned-moves-pmd-size.patch
selftests-mm-add-a-test-for-remapping-to-area-immediately-after-existing-mapping.patch
selftests-mm-add-a-test-for-remapping-within-a-range.patch
selftests-mm-add-a-test-for-moving-from-an-offset-from-start-of-mapping.patch

